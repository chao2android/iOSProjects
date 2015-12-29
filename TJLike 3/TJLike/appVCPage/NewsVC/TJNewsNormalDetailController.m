//
//  TJNewsNormalDetailController.m
//  TJLike
//
//  Created by MC on 15-3-31.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJNewsNormalDetailController.h"
#import "CommentBottom.h"
#import "CommentListView.h"
#import "SendCommentView.h"
#import "NewsRelationNewsList.h"
#import "NewsRelationListView.h"
#import "NewsRelationDetailViewController.h"
#import "ShareSDK.h"

@interface TJNewsNormalDetailController ()
{
    UIWebView *mWebView;
    NSMutableArray *relationArray;
    float webHeight;
}
@property (nonatomic, strong)UIScrollView *mScrollView;

@property (nonatomic, strong)CommentListView *commentListView;

@property (nonatomic, assign)int mPage;

@property (nonatomic, strong)CommentBottom *bottomView;
@end

@implementation TJNewsNormalDetailController



- (UIButton *)GetRightBtn{
    //news_top_4_
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 44, 44);
    rightBtn.backgroundColor = [UIColor clearColor];
    [rightBtn setImage:[UIImage imageNamed:@"news_top_4_"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(RightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    return rightBtn;
}
- (void)RightBtnClick{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK" ofType:@"png"];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                       defaultContent:@"测试一下"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"ShareSDK"
                                                  url:@"http://www.mob.com"
                                          description:@"这是一条测试信息"
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.naviController setNaviBarTitle:@"资讯新闻"];
    [self.naviController setNavigationBarHidden:NO];
    [self.naviController setNaviBarDefaultLeftBut_Back];
    [self.naviController setNaviBarRightBtn:[self GetRightBtn]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.naviController setNaviBarTitle:@"资讯新闻"];
//    [self.naviController setNavigationBarHidden:NO];
//    [self.naviController setNaviBarDefaultLeftBut_Back];
    
    self.mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44)];
    self.mScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.mScrollView.showsHorizontalScrollIndicator = NO;
    self.mScrollView.delegate = self;
    self.mScrollView.pagingEnabled = YES;
    self.mScrollView.bounces = NO;
    self.mScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, 0);
    self.mScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.mScrollView];
    
    mWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height-108)];
    mWebView.scalesPageToFit =NO;
    mWebView.delegate =self;
    mWebView.scrollView.backgroundColor = [UIColor colorWithRed:240/250.f green:240/250.f blue:240/250.f alpha:1];
    mWebView.backgroundColor = [UIColor colorWithRed:240/250.f green:240/250.f blue:240/250.f alpha:1];
    mWebView.dataDetectorTypes = UIDataDetectorTypeAll;
    [self.mScrollView addSubview:mWebView];
    
    [self requestRegionsInfo];
    
    _commentListView = [[CommentListView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-108) WithNid:self.mlInfo];
    [_mScrollView addSubview:_commentListView];
    
    _bottomView = [[CommentBottom alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-44, SCREEN_WIDTH, 44)];
    _bottomView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    _bottomView.mDelegate = self;
    _bottomView.comment = self.mlInfo.comment;
    _bottomView.onGoComment = @selector(ShowCommentView:);
    _bottomView.OnSendClick = @selector(SendCommentClick);
    [self.view addSubview:_bottomView];
}
- (void)SendCommentClick{
    NSLog(@"%@",UserManager.userInfor.userId);
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


- (void)requestRelationNews {
    NSString *urlStr = [NSString stringWithFormat:@"http://www.zounai.com/index.php/api/RelationNews"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%d",self.mlInfo.nid] forKey:@"nid"];
    [[HttpClient postRequestWithPath:urlStr para:dict] subscribeNext:^(NSDictionary *info) {
        relationArray = [[NSMutableArray alloc]initWithCapacity:10];
        NSLog(@"相关新闻----%@",info);
        for (int i = 0; i<[info[@"data"] count]; i++) {
            NSDictionary *dict = info[@"data"][i];
            NewsRelationNewsList *info = [NewsRelationNewsList CreateWithDict:dict];
            [relationArray addObject:info];
        }
        
        [self AddRelationNews];
        
    } error:^(NSError *error) {
        HttpClient.failBlock(error);
    }];
}
- (void)AddRelationNews{
    NSLog(@"---------->%f",webHeight);
    NSLog(@"---------->%f",mWebView.scrollView .contentSize.height);
    mWebView.scrollView .contentSize = CGSizeMake(0, webHeight+relationArray.count*60+60);
    
    //相关
    UIImageView *mImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, webHeight+20, SCREEN_WIDTH, 34)];
    mImageView.backgroundColor = [UIColor colorWithRed:230.f/250.f green:230.f/250.f blue:230.f/250.f alpha:1];
    [mWebView.scrollView addSubview:mImageView];
    //news_bottom_17_@2x.png
    
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(28, 8, 18, 18)];
    icon.image = [UIImage imageNamed:@"news_bottom_17_@2x.png"];
    [mImageView addSubview:icon];
    
    UILabel *mLabel = [[UILabel alloc]initWithFrame:CGRectMake(54, 0, SCREEN_WIDTH-20, 34)];
    mLabel.backgroundColor = [UIColor clearColor];
    mLabel.text = @"相关新闻";
    mLabel.font = [UIFont systemFontOfSize:13.5];
    mLabel.textColor = [UIColor redColor];
    [mImageView addSubview:mLabel];
    
    for (int i = 0; i<relationArray.count; i++) {
        NewsRelationListView *view = [[NewsRelationListView alloc]initWithFrame:CGRectMake(20, webHeight+54+i*60, SCREEN_WIDTH-40, 60)];
        [view LoadContent:relationArray[i]];
        view.mDelegate = self;
        view.onClick = @selector(RelationNewsClick:);
        [mWebView.scrollView addSubview:view];
    }
}
- (void)RelationNewsClick:(NewsRelationNewsList *)info{
    NewsRelationDetailViewController *ctrl = [[NewsRelationDetailViewController alloc]init];
    ctrl.nid =[NSString stringWithFormat:@"%d",info.nid];
    [self.naviController pushViewController:ctrl animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView==self.mScrollView) {
        NSLog(@"self.mPage---->%d",self.mPage);
        _bottomView.showContent.hidden = self.mPage==0;
        _bottomView.commentNum.hidden = !self.mPage==0;
        [self.naviController setNaviBarTitle:self.mPage==0?@"资讯新闻":@"热门评论"];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //根据偏移量计算是哪个图片；
    if (scrollView == self.mScrollView){
        self.mPage = (scrollView.contentOffset.x/scrollView.frame.size.width);
    }
}

- (void)ShowCommentView:(UIButton *)sender{
    _bottomView.showContent.hidden = !_bottomView.showContent.hidden;
    _bottomView.commentNum.hidden = !_bottomView.commentNum.hidden;
    if (self.mScrollView.contentOffset.x==0) {
        [self.mScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, self.mScrollView.contentOffset.y) animated:YES];
        [self.naviController setNaviBarTitle:@"热门评论"];
    }else if(self.mScrollView.contentOffset.x>SCREEN_WIDTH*0.7){
        [self.mScrollView setContentOffset:CGPointMake(0, self.mScrollView.contentOffset.y) animated:YES];
        [self.naviController setNaviBarTitle:@"资讯新闻"];
    }
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"webViewDidStartLoad");
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
     NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.offsetHeight"];
    webHeight = [currentURL floatValue];
    [self requestRelationNews];
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
     "document.getElementsByTagName('head')[0].appendChild(script);"
     "document.body.style.backgroundColor = '#f6f6f6';"];
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
