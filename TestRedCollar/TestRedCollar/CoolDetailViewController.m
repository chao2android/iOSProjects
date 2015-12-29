//
//  CoolDetailViewController.m
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-5.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "CoolDetailViewController.h"
#import "NewCommentView.h"
#import "FansInfoViewController.h"
#import "AutoAlertView.h"
#import "BottomDetailView.h"
#import "SubGoodsView.h"
#import "CoolCommentView.h"
#import "JSON.h"
#import "NetImageView.h"
#import "CommentModel.h"
#import "TestViewController.h"
#import "ZCScreenShot.h"
#import "CoolDetailPicModel.h"
#import "CoolCommentModel.h"
#import "CoolCommentListViewController.h"
#import "UMSocial.h"
#import "ShareSheetView.h"
#import "UMSocialWechatHandler.h"


@interface CoolDetailViewController ()
{
    int _scrollCount;
    int _inCount;
    int _commentCount;
    UIPageControl *_pageControl;
    BOOL mbNotice;
    UIButton *mNoticeBtn;
}
@end

@implementation CoolDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        mbNotice = NO;
        // Custom initialization
        self.mArray = [NSMutableArray arrayWithCapacity:0];
        self.isReloadComment = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"self.type--->%d",self.type);
    if (self.type >=3) {
        self.title = @"街拍详情";
    }
    else{
        self.title = @"设计作品";
    }
    
    if (!self.PictureID) {
        self.PictureID = self.model._id;
    }
    self.view.backgroundColor = [UIColor colorWithWhite:0.91 alpha:1.0];
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50)];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _scrollView.bounces = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    
#pragma mark 底部视图
    UIImageView *botView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
    botView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    botView.userInteractionEnabled = YES;
    botView.image = [UIImage imageNamed:@"22底.png"];
    [self.view addSubview:botView];
    
    int iWidth = self.view.frame.size.width/3;
    for (int i = 0; i < 3; i ++) {
        NSString *imagename = [NSString stringWithFormat:@"%d.png", i+112];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*iWidth, 0, iWidth, 50);
        [btn setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
        btn.tag = i+1600;
        [btn addTarget:self action:@selector(OnBotBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [botView addSubview:btn];
    }
    
    self.mStatusManager = [[UserStatusManager alloc] init];
    _mStatusManager.delegate = self;
    _mStatusManager.OnLoadStatus = @selector(OnLoadStatus:);
    
#pragma mark 下载用户信息
    [self loadData];
}

- (void)OnLoadStatus:(UserStatusManager *)sender {
    mbNotice = sender.mbNotice;
    if (mbNotice) {
        [mNoticeBtn setImage:[UIImage imageNamed:@"f_noticebtn02.png"] forState:UIControlStateNormal];
    }
    else {
        [mNoticeBtn setImage:[UIImage imageNamed:@"f_noticebtn01.png"] forState:UIControlStateNormal];
    }
}

#pragma mark 数据下载
#pragma mark - ImageDownManager

- (void)Cancel{
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}

#pragma mark 下载picID的基本信息
- (void)loadData {
    if (self.mDownManager) {
        return;
    }
    [self StartLoading];
    
    self.mDownManager = [[ImageDownManager alloc] init];
    self.mDownManager.delegate = self;
    self.mDownManager.OnImageDown = @selector(OnLoadFinish:);
    self.mDownManager.OnImageFail = @selector(OnLoadFail:);
    //http://www.rctailor.com/soaapi/soap/flow.php?act=kukeInfo&picId=3
    NSString *urlstr = [NSString stringWithFormat:@"%@flow.php",SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"kukeInfo" forKey:@"act"];
    [dict setObject:self.PictureID forKey:@"picId"];
    [self.mDownManager PostHttpRequest:urlstr :dict];
}

- (void)OnLoadFinish:(ImageDownManager *)sender {
    
    NSDictionary *dict = [sender.mWebStr JSONValue];
    //NSLog(@"-kukeInfo-dict---->%@",dict);
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        
        CoolDetailPicModel *model = [[CoolDetailPicModel alloc]init];
        [model setValuesForKeysWithDictionary:dict];
        model._id = [dict objectForKey:@"id"];
        
        [self.mArray addObject:model];
        [self refreshDetailView:NO];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self GoBack];
}

#pragma mark 刷新晒酷详情页第一部分
- (void)refreshDetailView:(BOOL)isDefault {
    
    CoolDetailPicModel *model =nil;
    
    model = self.mArray[0];
    
    
    
    
#pragma mark 图片横向滚动视图
    UIScrollView *imgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 68, 320,HIGHT-80)];
    imgScrollView.autoresizingMask = YES;
    
    imgScrollView.showsHorizontalScrollIndicator = NO;
    imgScrollView.bounces = NO;
    imgScrollView.pagingEnabled = YES;
    imgScrollView.delegate = self;
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    
#pragma mark  如果photo_list 没有数据,则跳过,如果不跳过,如果是nil ,则会崩溃
    NSArray *picArray = model.photo_list;
    if (picArray.count != 0) {
        for (int i = 0; i < picArray.count; i++) {
            [array addObject:[picArray[i] objectForKey:@"url"]];
        }
        
    }
    
    NSArray *subImageArray = [NSArray arrayWithArray:array];
    _scrollCount = subImageArray.count;
    for (int i = 0; i <_scrollCount; i++) {
        double w = _scrollView.bounds.size.width;
        double h = HIGHT  - 68;
        double x = i * w;
        double y = 0;
        
        NSString *path = subImageArray[i];
        NSRange range = [path rangeOfString:@"http"];
        if (range.length == 0) {
            if (self.type > 2) {
                path = [NSString stringWithFormat:@"%@upload_user_photo/jiepai/original/%@", URL_HEADER, path];
            }
            else {
                path = [NSString stringWithFormat:@"%@upload_user_photo/sheji/original/%@", URL_HEADER, path];
            }
        }
        NetImageView *netImage = [[NetImageView alloc]initWithFrame:CGRectMake(x, y, w, h)];
        netImage.mImageType = TImageType_CutFill;
        [netImage GetImageByStr:path];
        NSLog(@"subImageArray = %@",path);
        [imgScrollView addSubview:netImage];
    }
    imgScrollView.contentSize = CGSizeMake(_scrollCount * self.view.bounds.size.width, HIGHT-80);
    [_scrollView addSubview:imgScrollView];
    
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(100, HIGHT-40, 100, 30)];
    _pageControl.numberOfPages = _scrollCount;
    _pageControl.currentPage = 0;
    [_scrollView addSubview:_pageControl];
    
    
#pragma mark 头部视图
    UIImageView *headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 80)];
    headView.userInteractionEnabled = YES;
    [headView setImage:[UIImage imageNamed:@"87.png"]];
    [_scrollView addSubview:headView];
    
    NetImageView *faceView = [[NetImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    faceView.mDefaultImage = [UIImage imageNamed:@"default_avatar"];
    faceView.layer.cornerRadius = faceView.frame.size.width/2;
    faceView.layer.masksToBounds = YES;
    [headView addSubview:faceView];
    
    if (model.avatar && model.avatar > 0){
        NSRange range = [model.avatar rangeOfString:@"http://"];
        if (range.length == 0){
            model.avatar = [NSString stringWithFormat:@"%@%@",URL_HEADER,model.avatar];
        }
    }
    
    [faceView GetImageByStr:model.avatar];
//    [faceView ShowLocalImage];
    
    UIButton *userbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    userbtn.frame = faceView.bounds;
    [userbtn addTarget:self action:@selector(OnUserBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:userbtn];
    
    //  添加关注按钮
    mNoticeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mNoticeBtn.frame = CGRectMake(220, 18, 80, 34);
    [mNoticeBtn addTarget:self action:@selector(OnNoticeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [mNoticeBtn setImage:[UIImage imageNamed:@"f_noticebtn01.png"] forState:UIControlStateNormal];
    [headView addSubview:mNoticeBtn];
    
    UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(70, 5, 160, 30)];
    nameLable.backgroundColor = [UIColor clearColor];
    nameLable.text = [UserInfoManager GetSecretName:model.nickname username:model.user_name];
    nameLable.font = [UIFont systemFontOfSize:17];
    [headView addSubview:nameLable];
    
    
    //计算几天前发布
    NSDate *data = [[NSDate alloc]initWithTimeIntervalSince1970:[model.add_time doubleValue]];
    NSDate *data2 = [[NSDate alloc]init];
    double timerInt = [data2 timeIntervalSinceDate:data];
    int intervalDay = timerInt/(24*60*60);
    if (intervalDay<1) {
        intervalDay = 1;
    }
    
    
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 40, 100, 15)];
    dateLabel.backgroundColor = [UIColor clearColor];
    [dateLabel setText:[NSString stringWithFormat:@"%d天前 发布",intervalDay]];
    dateLabel.textColor = [UIColor grayColor];
    dateLabel.font =[UIFont systemFontOfSize:15];
    [headView addSubview:dateLabel];
    // 下载晒酷详情页的评论数据
    [self loadComment];
    
    [_mStatusManager GetUserStatus:self.model.uid];
}
#pragma mark  数据下载失败
- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}

#pragma mark  开始下载晒酷详情页的评论数据
- (void)loadComment{
    if (self.mDownManager) {
        return;
    }
    [self StartLoading];
    
    self.mDownManager = [[ImageDownManager alloc] init];
    self.mDownManager.delegate = self;
    self.mDownManager.OnImageDown = @selector(OnLoadCommentFinish:);
    self.mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *urlstr = [NSString stringWithFormat:@"%@flow.php",SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"getCommentList" forKey:@"act"];
    [dict setObject:@"4" forKey:@"pageSize"];
    [dict setObject:@"1" forKey:@"pageIndex"];
    [dict setObject:self.PictureID forKey:@"id"];
    
    [self.mDownManager PostHttpRequest:urlstr :dict];
}
#pragma mark 完成下载晒酷详情页的评论数据
- (void)OnLoadCommentFinish:(ImageDownManager *)sender {
    
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    
    //如果是添加新品论则重新刷新评论列表
    if (self.isReloadComment) {
        CoolDetailPicModel *model = self.mArray[0];
        [self.mArray removeAllObjects];
        [self.mArray addObject:model];
    }
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        self.hasNext = [[dict objectForKey:@"hasNext"] intValue];
        NSDictionary *comment_list = [dict objectForKey:@"comment_list"];
        NSArray *array = [UserInfoManager DictionaryToArray:comment_list desc:YES];
        if (array) {
            for (NSDictionary *tmpdict in array) {
                CoolCommentModel *model = [CoolCommentModel CreateWithDict:tmpdict];
                [self.mArray addObject:model];
            }
        }
        [self refreshDetailCommentView];
    }
}

#pragma mark 刷新评论部分
- (void)refreshDetailCommentView {
    if (!self.isReloadComment) {
        UIImageView *commentHeadView = [[UIImageView alloc]initWithFrame:CGRectMake(15,HIGHT+18, 106, 33)];
        commentHeadView.image = [UIImage imageNamed:@"111.png"];
        [_scrollView addSubview:commentHeadView];
        
    }
    
    //清除旧评论和点击进入更多的button
    @autoreleasepool {
        UIView *view = [_scrollView viewWithTag:1000];
        if (view) {
            [view removeFromSuperview];
        }
        for (int i = 1; i < 6; i ++) {
            UIView *view = [_scrollView viewWithTag:i];
            if (view) {
                [view removeFromSuperview];
            }
        }
    }
    
#pragma mark 有评论
    if (self.mArray.count>1) {
        _commentCount = self.mArray.count-1;
        
        for (int i = 1; i<self.mArray.count; i++) {
            CoolCommentModel *model2  = self.mArray[i];
            NSLog(@"CoolCommentModel---->%@",model2.avatar);
            double w = self.view.bounds.size.width-20;
            double h = 41;
            double x = 10;
            double y = HIGHT+65+(h+5)*(i-1);
            NewCommentView *comView = [[NewCommentView alloc]initWithFrame:CGRectMake(x, y, w, h)];
            comView.tag = i;
            comView.delegate = self;
            comView.didSelected = @selector(didClickComment:);
            [comView loadCoolCommentContent:model2];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moreCommentButtonClick)];
            [comView.commentView addGestureRecognizer:tap];
            [_scrollView addSubview:comView];
            if (self.hasNext == 1&&i == 4) {
                _commentCount = 5;
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.tag = 5;
                button.frame = CGRectMake(69.5, HIGHT+65+(41+5)*(_commentCount-1)+10, 181, 35);
                [button setBackgroundImage:[UIImage imageNamed:@"1(3).png"] forState:UIControlStateNormal];
                [button setTitle:@"点击进入更多" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
                [button addTarget:self action:@selector(moreCommentButtonClick) forControlEvents:UIControlEventTouchUpInside];
                [_scrollView addSubview:button];
                break;
                
            }
        }
#pragma  mark 无评论
    }else{
        
        _commentCount= 1;
        UIImageView *emptyComment = [[UIImageView alloc]initWithFrame:CGRectMake(10, HIGHT+65, self.view.bounds.size.width-20, 41)];
        emptyComment.image = [UIImage imageNamed:@"2_06.png"];
        emptyComment.tag = 1000;
        [_scrollView addSubview:emptyComment];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10,5.5, self.view.bounds.size.width-40, 30)];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"暂无评论";
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = UITextAlignmentCenter;
        // label.textAlignment = NSTextAlignmentCenter;
        [emptyComment addSubview:label];
        
        
    }
    
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, HIGHT+65+(41+5)*_commentCount+15);
    
}

#pragma mark 点击进入更多评论
- (void)moreCommentButtonClick {
    NSLog(@"点击进入更多评论");
    
    CoolCommentListViewController *vc = [[CoolCommentListViewController alloc]init];
    vc.urlID = self.model._id;
    vc.isTheme = NO;
    [self.navigationController pushViewController:vc animated:YES];
    vc.title = @"评论";
    
}

#pragma mark 点击评论的用户头像,进入该用户的详情页
- (void)didClickComment:(CoolCommentModel *)model
{
    FansInfoViewController *ctrl = [[FansInfoViewController alloc] init];
    ctrl.isAdded=YES;
    ctrl.userID = model.uid;
    [self.navigationController pushViewController:ctrl animated:YES];
}


#pragma mark 点击用户头像的处理方法
- (void)OnUserBtnClick {
    FansInfoViewController *ctrl = [[FansInfoViewController alloc] init];
    ctrl.isAdded=YES;
    ctrl.userID = self.model.uid;
    [self.navigationController pushViewController:ctrl animated:YES];
}
#pragma mark 底部btn的处理方法
- (void)OnBotBtnClick:(UIButton *)sender {
    int index = sender.tag-1600;
    //添加评论
    if (index == 0) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        CoolCommentView *commentView = [[CoolCommentView alloc] initWithFrame:window.bounds];
        commentView.delegate = self;
        commentView.sendClick = @selector(sendClick:);
        [window addSubview:commentView];
    }
    // 喜欢街拍
    else if(index == 1){
        [self sendLoveTheme];
        
    }
    else {
        [self OnShareClick];
    }
}

- (void)OnShareClick {
    CoolListModel *model = self.model;
    CoolDetailPicModel *model1 = self.mArray[0];
    UIImage *image = nil;
    for (NSDictionary *dict in model1.photo_list) {
        NSString *picurl = [dict objectForKey:@"url"];
        image = [UIImage imageWithContentsOfFile:[NetImageView GetLocalPathOfUrl:picurl]];
        break;
    }
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    ShareSheetView *view = [[ShareSheetView alloc] initWithFrame:keywindow.bounds];
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    view.mImage = image;
    view.mContent = model.des;
    view.mShareUrl = [NSString stringWithFormat:@"%@%@", URL_HEADER, model1.link];
    view.mRootCtrl = self;
    [UMSocialWechatHandler setWXAppId:WX_APPID url:view.mShareUrl];
    
    [keywindow addSubview:view];
}


/*********************************************************************************/
#pragma mark 上传喜欢街拍
- (void)sendLoveTheme {
    if (self.mDownManager) {
        return;
    }
    [self StartLoading];
    
    self.mDownManager = [[ImageDownManager alloc] init];
    self.mDownManager.delegate = self;
    self.mDownManager.OnImageDown = @selector(OnLoadFinish_sendLoveTheme:);
    self.mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    //  NSString *urlstr = [NSString stringWithFormat:THEME_DETAIL,[self.model._id integerValue]];
    NSString *str = SERVER_URL;
    NSString *urlstr = [str stringByAppendingString:@"flow.php?"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.type>2) {
        [dict setObject:@"loveJiePai" forKey:@"act"];
    }else{
        [dict setObject:@"loveSheJi" forKey:@"act"];
    }
    
    [dict setObject:kkToken forKey:@"token"];
    [dict setObject:self.PictureID  forKey:@"id"];
    NSLog(@"urlstr = %@",urlstr);
    [self.mDownManager PostHttpRequest:urlstr :dict];
    
    
}

- (void)OnLoadFinish_sendLoveTheme:(ImageDownManager *)sender {
    
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSLog(@"%@", dict);
        int statusCode = [[dict objectForKeyedSubscript:@"statusCode"] integerValue];
        [self  Click_loveTheme:statusCode];
        
    }
}

#pragma mark 提示是否上传喜欢成功
//创建一个没有点击按钮的警告框
-(void)Click_loveTheme:(int)statusCode{
    if(statusCode == 0){
        [AutoAlertView ShowAlert:@"提示" message:@"喜欢成功"];
        CoolDetailPicModel *model = self.mArray[0];
        int num = [model.like_num intValue];
        num++;
        NSString *content = [NSString stringWithFormat:@"%d",num];
        if (self.updateBlock) {
            self.updateBlock(4,content);
        }
        
    }else{
        [AutoAlertView ShowAlert:@"提示" message:@"您已经喜欢过了"];
    }
}



/*********************************************************************************/

#pragma  mark 上传评论
- (void)sendClick:(NSString*)str{
    NSLog(@"str = %@",str);
    if ([str isEqual:[NSNull null]] || [str isEqual:@""]) {
        [AutoAlertView ShowAlert:@"提示" message:@"评论内容不能为空"];
        return;
    }
    if (self.mDownManager) {
        return;
    }
    [self StartLoading];
    
    self.mDownManager = [[ImageDownManager alloc] init];
    self.mDownManager.delegate = self;
    self.mDownManager.OnImageDown = @selector(OnLoadFinish_SendState:);
    self.mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *str2 = SERVER_URL;
    NSString *urlstr = [str2 stringByAppendingString:@"flow.php?"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"addComment" forKey:@"act"];
    [dict setObject:kkToken forKey:@"token"];
    [dict setObject:self.PictureID forKey:@"id"];
    [dict setObject:str forKey:@"content"];
    NSLog(@"urlstr = %@",str);
    [self.mDownManager PostHttpRequest:urlstr :dict];
    
    
    
}
- (void)OnLoadFinish_SendState: (ImageDownManager *)sender {
    
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSLog(@"%@", dict);
        int statusCode = [[dict objectForKeyedSubscript:@"statusCode"] integerValue];
        [self Click:statusCode];
        
    }
}


#pragma mark 提示是否上传评论成功
- (void)Click:(int)statusCode{
    if(statusCode == 0){
        [AutoAlertView ShowAlert:@"提示" message:@"评论上传成功"];
        CoolDetailPicModel *model = self.mArray[0];
        int num = [model.comment_num intValue];
        num++;
        NSString *content = [NSString stringWithFormat:@"%d",num];
        if (self.updateBlock) {
            self.updateBlock(3,content);
            
        }
        //刷新评论界面
        self.isReloadComment = TRUE;
        [self loadComment];
    }
    else{
        [AutoAlertView ShowAlert:@"提示" message:@"您已经评论过了"];
    }
    
}
-(void)alertClick{
    //没有按键，强行调用第0位取消按键
    [_alert dismissWithClickedButtonIndex:0 animated:YES];
    
}
/*********************************************************************************/

#pragma mark 点击关注他的处理方法
- (void)OnNoticeBtnClick {
    
    [self sendFocusOnUser];
}

#pragma mark 上传关注他
- (void)sendFocusOnUser {
    if (self.mDownManager) {
        return;
    }
    [self StartLoading];
    
    self.mDownManager = [[ImageDownManager alloc] init];
    self.mDownManager.delegate = self;
    self.mDownManager.OnImageDown = @selector(OnLoadFinish_sendFocusOnUser:);
    self.mDownManager.OnImageFail = @selector(OnLoadFail:);
    CoolDetailPicModel *model = self.mArray[0];
    
    //  NSString *urlstr = [NSString stringWithFormat:THEME_DETAIL,[self.model._id integerValue]];
    NSString *str = SERVER_URL;
    NSString *urlstr = [str stringByAppendingString:@"club.php?"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"noticeuser" forKey:@"act"];
    [dict setObject:kkToken forKey:@"token"];
    [dict setObject:model.uid forKey:@"targetid"];
    [dict setObject:mbNotice?@"2":@"1" forKey:@"state"];
    NSLog(@"urlstr = %@",urlstr);
    [self.mDownManager PostHttpRequest:urlstr :dict];
    
    
}
- (void)OnLoadFinish_sendFocusOnUser:(ImageDownManager *)sender {
    
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSLog(@"%@", dict);
        [_mStatusManager GetUserStatus:self.model.uid];
        int statusCode = [[dict objectForKeyedSubscript:@"statusCode"] integerValue];
        [self  Click_lFocusOnUser:statusCode];
        
    }
}

#pragma mark 提示是否上传关注成功
- (void)Click_lFocusOnUser:(int)statusCode{
    if(statusCode == 0){
        [AutoAlertView ShowAlert:@"提示" message:mbNotice?@"取消关注成功":@"关注成功"];
    }
    else{
        [AutoAlertView ShowAlert:@"提示" message:@"您已经关注过了"];
    }
}

/*********************************************************************************/
- (void)sharePic:(int)statusCode {
    UIWindow *window =   [UIApplication sharedApplication].keyWindow;
    UIView *view =  [window viewWithTag:2000];
    view.hidden = NO;
    if(statusCode == 200){
        [AutoAlertView ShowAlert:@"提示" message:@"分享成功"];
    }
    else{
        [AutoAlertView ShowAlert:@"提示" message:@"分享失败"];
    }
}

#pragma mark scrollview的代理  小白点指示显示imgScrollview的当前页
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView!=_scrollView) {
        int currentPage = scrollView.contentOffset.x/self.view.bounds.size.width;
        _pageControl.currentPage = currentPage;
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_mStatusManager GetUserStatus:self.model.uid];
}

#pragma mark  dealloc;
- (void)dealloc {
    NSLog(@"free cool detail");
    [self Cancel];
    self.mArray = nil;
    self.model = nil;
    self.PictureID = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
