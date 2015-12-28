//
//  TJNewsImageDetailController.m
//  TJLike
//
//  Created by MC on 15-3-31.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJNewsImageDetailController.h"
#import "CommentBottom.h"
#import "UIImageView+WebCache.h"
#import "CommentListView.h"
#import "SendCommentView.h"
#import "ShareSDK.h"

@interface TJNewsImageDetailController ()

@property (nonatomic, strong)UIScrollView *mScrollView;

@property (nonatomic, strong)UILabel *contentLabel;

@property (nonatomic, strong)NSString *curText;

@property (nonatomic, strong)CommentListView *commentListView;

@property (nonatomic, assign)int mPage;

@property (nonatomic, strong)CommentBottom *bottomView;
@end

@implementation TJNewsImageDetailController
{
    
    NSMutableArray *imageArray;
    NSMutableArray *textArray;
    
    int totalPage;
    
}
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
    [self.naviController setNaviBarDefaultLeftBut_Back];
    [self.naviController setNavigationBarHidden:NO];
    [self.naviController setNaviBarRightBtn:[self GetRightBtn]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = [UIColor blackColor];
    imageArray = [[NSMutableArray alloc]initWithCapacity:10];
    textArray = [[NSMutableArray alloc]initWithCapacity:10];
    
    self.mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.mScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.mScrollView.showsHorizontalScrollIndicator = NO;
    self.mScrollView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.mScrollView];
    self.mScrollView.delegate = self;
    self.mScrollView.pagingEnabled = YES;
    self.mScrollView.bounces = NO;
    
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, SCREEN_HEIGHT-100, SCREEN_WIDTH-15, 25)];
    self.contentLabel.textColor = [UIColor whiteColor];
    self.contentLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:_contentLabel];
    
    [self InitImageArrayAndTextArray];
    
    for (int i = 0; i<imageArray.count; i++) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*i, 0, self.view.frame.size.width, self.view.frame.size.height-120)];
        scrollView.bounces = NO;
        scrollView.delegate = self;
        scrollView.minimumZoomScale = 1.0;
        scrollView.maximumZoomScale = 2.0;  //放大比例；
        scrollView.zoomScale = 1.0;
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height-120);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [self.mScrollView addSubview:scrollView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:scrollView.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tag = 500;
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageArray[i]]];
        imageView.userInteractionEnabled = YES;
        [scrollView addSubview:imageView];
    }
    
    _commentListView = [[CommentListView alloc]initWithFrame:CGRectMake(totalPage*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-105) WithNid:self.mlInfo];
    [_mScrollView addSubview:_commentListView];
    
    _bottomView = [[CommentBottom alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-44, SCREEN_WIDTH, 44)];
    _bottomView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1];
    _bottomView.mDelegate = self;
    _bottomView.comment = self.mlInfo.comment;
    _bottomView.onGoComment = @selector(ShowCommentView:);
    _bottomView.OnSendClick = @selector(SendCommentClick);
    [self.view addSubview:_bottomView];
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
- (void)sendClick:(NSString *)comment{
    //    NSString *urlStr = [NSString stringWithFormat:@"http://www.zounai.com/index.php/api/AddComment"];
    //    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //    [dict setObject:[NSString stringWithFormat:@"%d",self.cid] forKey:@"cid"];
    //    [[HttpClient postRequestWithPath:urlStr para:dict] subscribeNext:^(NSDictionary *info) {
    //
    //    } error:^(NSError *error) {
    //        HttpClient.failBlock(error);
    //        //[self executeStateBlock];
    //    }];
    
}

- (void)InitImageArrayAndTextArray{
    [imageArray removeAllObjects];
    [textArray removeAllObjects];
    NSArray *array = self.mlInfo.tuwen;
    totalPage = array.count;
    for (int i = 0; i<array.count; i++) {
        NSString *pic = array[i][@"pic"];
        [imageArray addObject:pic];
        NSString *description = array[i][@"description"];
        [textArray addObject:description];
    }
    self.mPage = 0;
    [self ChangeText];
    self.mScrollView.contentSize = CGSizeMake(self.view.bounds.size.width*(totalPage+1), 0);
}
- (void)ChangeText{
    if (self.mPage == totalPage) {
        self.contentLabel.hidden = YES;
    }
    else{
        self.contentLabel.hidden = NO;
        self.curText = [NSString stringWithFormat:@"%d/%d %@",self.mPage+1,totalPage,textArray[self.mPage]];
        NSLog(@"_curPageText---->%@",self.curText);
        NSMutableAttributedString *butedString = [[NSMutableAttributedString alloc]initWithString:self.curText];
        NSRange range = {0,3};
        [butedString addAttributes:[NSDictionary dictionaryWithObjects:@[[UIFont systemFontOfSize:20],NSForegroundColorAttributeName] forKeys:@[NSFontAttributeName,NSUnderlineStyleAttributeName]] range:range];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:10];
        [butedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, 2)];
        [self.contentLabel setAttributedText:butedString];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView==self.mScrollView) {
        [self ChangeText];
        _bottomView.showContent.hidden = self.mPage<totalPage;
        _bottomView.commentNum.hidden = self.mPage==totalPage;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //根据偏移量计算是哪个图片；
    if (scrollView == self.mScrollView){
        self.mPage = (scrollView.contentOffset.x/scrollView.frame.size.width);
        NSLog(@"--------->%d---------->%d",self.mPage,totalPage);
    }
}
- (void)ShowCommentView:(UIButton *)sender{
    _bottomView.showContent.hidden = !_bottomView.showContent.hidden;
    _bottomView.commentNum.hidden = !_bottomView.commentNum.hidden;
    if (self.mScrollView.contentOffset.x<SCREEN_WIDTH*totalPage) {
        [self.mScrollView setContentOffset:CGPointMake(totalPage*SCREEN_WIDTH, self.mScrollView.contentOffset.y) animated:NO];
    }else if(self.mScrollView.contentOffset.x==SCREEN_WIDTH*totalPage){
        [self.mScrollView setContentOffset:CGPointMake(0, self.mScrollView.contentOffset.y) animated:NO];
        self.mPage = 0;
        [self ChangeText];
    }
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView !=self.mScrollView){
        UIImageView *imageView = (UIImageView *)[scrollView viewWithTag:500];
        return imageView;
    }
    return nil;
}



- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
