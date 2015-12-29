//
//  TJNewsZTDetailViewController.m
//  TJLike
//
//  Created by MC on 15/4/10.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJNewsZTDetailViewController.h"
#import "CommentBottom.h"
#import "CommentListView.h"
#import "SendCommentView.h"

@interface TJNewsZTDetailViewController ()
{
    UIWebView *mWebView;
}
@property (nonatomic, strong)UIScrollView *mScrollView;

@property (nonatomic, strong)CommentListView *commentListView;
@end

@implementation TJNewsZTDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.naviController setNaviBarTitle:@"资讯新闻"];
    [self.naviController setNavigationBarHidden:NO];
    [self.naviController setNaviBarDefaultLeftBut_Back];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44)];
    self.mScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.mScrollView.showsHorizontalScrollIndicator = NO;
    self.mScrollView.delegate = self;
    self.mScrollView.pagingEnabled = YES;
    self.mScrollView.bounces = NO;
    self.mScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, 0);
    self.mScrollView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.mScrollView];
    
    mWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height-108)];
    mWebView.scalesPageToFit =NO;
    mWebView.delegate =self;
    mWebView.dataDetectorTypes = UIDataDetectorTypeAll;
    [self.mScrollView addSubview:mWebView];
    
    [self requestRegionsInfo];
    
    _commentListView = [[CommentListView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-108) WithNid:self.mlInfo];
    [_mScrollView addSubview:_commentListView];
    
    CommentBottom *bottomView = [[CommentBottom alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-44, SCREEN_WIDTH, 44)];
    bottomView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    bottomView.mDelegate = self;
    bottomView.onGoComment = @selector(ShowCommentView:);
    bottomView.OnSendClick = @selector(SendCommentClick);
    [self.view addSubview:bottomView];
}
- (void)SendCommentClick{
    if ([UserAuthorManager gainCurrentStateForUserLoginAndBind]==0){
        [UserAuthorManager authorizationLogin:self EnterPage:EnterPresentMode_push andSuccess:^{
            NSLog(@"成功");
            [self ReginstCommentView];
        }andFaile:^{
            NSLog(@"失败");
        }];
    }else{
        [self ReginstCommentView];
    }
}
- (void)ReginstCommentView{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    SendCommentView *commentView = [[SendCommentView alloc] initWithFrame:window.bounds];
    commentView.nid = [NSString stringWithFormat:@"%d",self.mlInfo.nid];
    [window addSubview:commentView];

}

- (void)ShowCommentView:(UIButton *)sender{
    NSLog(@"ShowCommentView");
    if (sender.selected == NO) {
        [self.mScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, self.mScrollView.contentOffset.y) animated:YES];
    }else{
        [self.mScrollView setContentOffset:CGPointMake(0, self.mScrollView.contentOffset.y) animated:YES];
    }
    sender.selected = !sender.selected;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"webViewDidStartLoad");
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.offsetHeight"];
    NSLog(@"currentURL------>%@",currentURL);
    
    //    [webView stringByEvaluatingJavaScriptFromString:
    //     @"var tagHead =document.documentElement.firstChild;"
    //     "var tagMeta = document.createElement(\"meta\");"
    //     "tagMeta.setAttribute(\"http-equiv\", \"Content-Type\");"
    //     "tagMeta.setAttribute(\"content\", \"text/html; charset=utf-8\");"
    //     "var tagHeadAdd = tagHead.appendChild(tagMeta);"];
    //
    //    [webView stringByEvaluatingJavaScriptFromString:
    //     @"var tagHead =document.documentElement.firstChild;"
    //     "var tagStyle = document.createElement(\"style\");"
    //     "tagStyle.setAttribute(\"type\", \"text/css\");"
    //     "tagStyle.appendChild(document.createTextNode(\"BODY{padding: 20pt 15pt}\"));"
    //     "var tagHeadAdd = tagHead.appendChild(tagStyle);"];
    
    
    //拦截网页图片  并修改图片大小
    [webView stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth;"
     "var maxwidth = 300.0;" // UIWebView中显示的图片宽度
     "for(i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "if(myimg.width > maxwidth){"
     "oldwidth = myimg.width;"
     "myimg.width = maxwidth;"
     "}"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
    // 一般获取网页高度会在这个方法里获取
    // 但这里获取的高度未必就是web页面的真实高度，因为web中图片未加载完有可能导致web界面不真实，或长或短
    // 你能可能用到下面的js方法去获取，但其实都没用
    /**
     1、document.documentElement.offsetHeight;
     2、document.body.clientHeight;
     3、document.documentElement.scrollHeight
     4、
     CGRect frame = webView.frame;
     CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
     frame.size = fittingSize;
     webView.frame = frame;
     5、getBodyHeight() // 网页用js实现好的方法
     6、CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.clientHeight"] floatValue];
     */
    // 所以必须要找到能完全确定web加载，才能确定web高度
    // 在网上找了个工具 NJKWebViewProgress
    
    
}

/*
 #pragma mark - NJKWebViewProgressDelegate
 }*/
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"error---->%@",error);
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    TLog(@"%@",request.URL);
    return YES;
}

- (void)requestRegionsInfo {
    NSString *urlStr = [NSString stringWithFormat:@"http://www.zounai.com/index.php/api/Aview"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%d",self.mlInfo.nid] forKey:@"nid"];
    [[HttpClient postRequestWithPath:urlStr para:dict] subscribeNext:^(NSDictionary *info) {
        NSLog(@"info--------%@",info);
        NSMutableString *str = [NSMutableString stringWithFormat:@"%@",info[@"data"][@"description"]];
        NSString *cutStr = @"alt=";
        //NSString *centerStr = @"<img";
        NSRange  rang = [str rangeOfString:cutStr];
        //NSRange  rangC = [str rangeOfString:centerStr];
        if (rang.location != NSNotFound) {
            int location = rang.location;
            NSString *strFrame = [NSString stringWithFormat:@"width=\"%f\" height=\"%f\" margin=\"%f\" style=\"text-align: center\" ", SCREEN_WIDTH - 20,SCREEN_WIDTH/2,20.0];
            //NSString *strCFrame = [NSString stringWithFormat:@"<p style=\"text-align:center\">"];
            [str insertString:strFrame atIndex:location];
            
            //int locationCenter = rangC.location;
            //[str insertString:strCFrame atIndex:locationCenter];
            
        }
        
        [mWebView loadHTMLString:str baseURL:nil];
        
    } error:^(NSError *error) {
        HttpClient.failBlock(error);
        //[self executeStateBlock];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
