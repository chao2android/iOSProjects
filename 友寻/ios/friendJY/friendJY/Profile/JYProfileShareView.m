//
//  JYProfileShareView.m
//  friendJY
//
//  Created by ouyang on 3/24/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//

#import "JYProfileShareView.h"
#import <ShareSDK/ShareSDK.h>
//#import "JYViewDelegate.h"
#import "JYAppDelegate.h"
#import "JYHttpServeice.h"
#import "JYFeedEditController.h"
#import "JYShareToMyFriendController.h"
#import "SDPhotoBrowser.h"
#import "JYNavigationController.h"
#import "JYShareData.h"
#import "CPPhotoBrowser.h"

//#import "JYManageFirendController.h"

#define BUFFER_SIZE 1024*100
@interface JYProfileShareView()

@property (nonatomic, strong) id<ISSContent> publishContent;

@end

@implementation JYProfileShareView{
    UIView * content;
    UIView * bgView;
}
- (id<ISSContent>)publishContent{
//    if (_publishContent == nil) {
//    [ShareSDK imageWithData:[[NSData alloc] init] fileName:@"" mimeType:@""];
    _publishContent = [ShareSDK content:_shareContent
                                       defaultContent:nil
                                                image:[ShareSDK imageWithUrl:_shareImageUrl]
                                                title:_shareTitle
                                                  url:_shareUrl
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
//    }
    return _publishContent;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
        
        // Initialization code
        [self _initUI];
    }
    return self;
}

- (void) _initUI{
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
    [bgView setBackgroundColor:[UIColor blackColor]];
    bgView.alpha = 0.5;
    [self addSubview:bgView];
    //点击背景退出选择视图
    [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(positionAnimationOut)]];
    
    content =[[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight , kScreenWidth, 240+49)];
    [content setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:content];
    
    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(0, content.height-49, kScreenWidth, 49)];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelBtn.userInteractionEnabled = YES;
    cancelBtn.backgroundColor = [JYHelpers setFontColorWithString:@"#2695ff"];
    cancelBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    [cancelBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
 
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [content addSubview:cancelBtn];
    
    UILabel * myTitleLable = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-100)/2,10,100,40)];
    myTitleLable.lineBreakMode = NSLineBreakByWordWrapping;
    myTitleLable.textAlignment = NSTextAlignmentCenter;
    myTitleLable.backgroundColor = [UIColor clearColor];
    myTitleLable.textColor = [JYHelpers setFontColorWithString:@"#303030"];
    myTitleLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    myTitleLable.text = @"分享给好友";
    [content addSubview:myTitleLable];
    
    CGFloat paddingY = (kScreenWidth - 50*5)/6;
    //添加第一个标签
    UIImageView *myFriend = [[UIImageView alloc] initWithFrame:CGRectMake(paddingY, myTitleLable.bottom + 10, 50, 50)];
    myFriend.userInteractionEnabled = YES;
    myFriend.backgroundColor = [UIColor clearColor];
    myFriend.image = [UIImage imageNamed:@"profile_share_friend"];
    [myFriend addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareMyFriend)]];
    [content addSubview:myFriend];
    
    UILabel * myFriendLabel = [[UILabel alloc] initWithFrame:CGRectMake(myFriend.left, myFriend.bottom+5, 50, 20)];
    myFriendLabel.lineBreakMode = NSLineBreakByWordWrapping;
    myFriendLabel.textAlignment = NSTextAlignmentCenter;
    myFriendLabel.backgroundColor = [UIColor clearColor];
    myFriendLabel.textColor = [JYHelpers setFontColorWithString:@"#303030"];
    myFriendLabel.font = [UIFont systemFontOfSize:12];
    myFriendLabel.text = @"友寻";
    [content addSubview:myFriendLabel];
    
    //添加第二个标签，微信好友
    UIImageView *myWeixinFriend = [[UIImageView alloc] initWithFrame:CGRectMake(myFriend.right+paddingY, myFriend.top, 50, 50)];
    myWeixinFriend.userInteractionEnabled = YES;
    [myWeixinFriend addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareWeiXinFriends:)]];
    myWeixinFriend.backgroundColor = [UIColor clearColor];
    myWeixinFriend.image = [UIImage imageNamed:@"profile_share_weixin"];
    [content addSubview:myWeixinFriend];
    
    UILabel * myWeixinFriendLabel = [[UILabel alloc] initWithFrame:CGRectMake(myWeixinFriend.left, myWeixinFriend.bottom+5, 50, 20)];
    myWeixinFriendLabel.lineBreakMode = NSLineBreakByWordWrapping;
    myWeixinFriendLabel.textAlignment = NSTextAlignmentCenter;
    myWeixinFriendLabel.backgroundColor = [UIColor clearColor];
    myWeixinFriendLabel.textColor = [JYHelpers setFontColorWithString:@"#303030"];
    myWeixinFriendLabel.font = [UIFont systemFontOfSize:12];
    myWeixinFriendLabel.text = @"微信";
    [content addSubview:myWeixinFriendLabel];
    
    //添加第三个标签，微信朋友圈
    UIImageView *myQuanFriend = [[UIImageView alloc] initWithFrame:CGRectMake(myWeixinFriend.right+paddingY, myFriend.top, 50, 50)];
    myQuanFriend.userInteractionEnabled = YES;
    myQuanFriend.backgroundColor = [UIColor clearColor];
    myQuanFriend.image = [UIImage imageNamed:@"profile_share_quan"];
    [myQuanFriend addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareWeiXinTimeline:)]];
    [content addSubview:myQuanFriend];
    
    UILabel * myQuanFriendLabel = [[UILabel alloc] initWithFrame:CGRectMake(myQuanFriend.left-5, myQuanFriend.bottom+5, 60, 20)];
    myQuanFriendLabel.lineBreakMode = NSLineBreakByWordWrapping;
    myQuanFriendLabel.textAlignment = NSTextAlignmentCenter;
    myQuanFriendLabel.backgroundColor = [UIColor clearColor];
    myQuanFriendLabel.textColor = [JYHelpers setFontColorWithString:@"#303030"];
    myQuanFriendLabel.font = [UIFont systemFontOfSize:12];
    myQuanFriendLabel.text = @"朋友圈";
    [content addSubview:myQuanFriendLabel];
    
    //添加第四个标签，微博好友
    UIImageView *myWeiboFriend = [[UIImageView alloc] initWithFrame:CGRectMake(myQuanFriend.right+paddingY, myFriend.top, 50, 50)];
    myWeiboFriend.userInteractionEnabled = YES;
    myWeiboFriend.backgroundColor = [UIColor clearColor];
    myWeiboFriend.image = [UIImage imageNamed:@"profile_share_weibo"];
    [content addSubview:myWeiboFriend];
    [myWeiboFriend addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareSinaWeiBo:)]];
    UILabel * myWeiboFriendLabel = [[UILabel alloc] initWithFrame:CGRectMake(myWeiboFriend.left, myWeiboFriend.bottom+5, 50, 20)];
    myWeiboFriendLabel.lineBreakMode = NSLineBreakByWordWrapping;
    myWeiboFriendLabel.textAlignment = NSTextAlignmentCenter;
    myWeiboFriendLabel.backgroundColor = [UIColor clearColor];
    myWeiboFriendLabel.textColor = [JYHelpers setFontColorWithString:@"#303030"];
    myWeiboFriendLabel.font = [UIFont systemFontOfSize:12];
    myWeiboFriendLabel.text = @"微博";
    [content addSubview:myWeiboFriendLabel];
    
    
    //添加第五个标签，QQ好友
    UIImageView *myQQFriend = [[UIImageView alloc] initWithFrame:CGRectMake(myWeiboFriend.right+paddingY, myFriend.top, 50, 50)];
    myQQFriend.userInteractionEnabled = YES;
    myQQFriend.backgroundColor = [UIColor clearColor];
    myQQFriend.image = [UIImage imageNamed:@"profile_share_qq"];
    [content addSubview:myQQFriend];
    [myQQFriend addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareQQFriend:)]];
    UILabel * myQQFriendLabel = [[UILabel alloc] initWithFrame:CGRectMake(myQQFriend.left, myQQFriend.bottom+5, 50, 20)];
    myQQFriendLabel.lineBreakMode = NSLineBreakByWordWrapping;
    myQQFriendLabel.textAlignment = NSTextAlignmentCenter;
    myQQFriendLabel.backgroundColor = [UIColor clearColor];
    myQQFriendLabel.textColor = [JYHelpers setFontColorWithString:@"#303030"];
    myQQFriendLabel.font = [UIFont systemFontOfSize:12];
    myQQFriendLabel.text = @"QQ";
    [content addSubview:myQQFriendLabel];
    
    //添加第六个标签，转发动态
    UIImageView *myDynamicFriend = [[UIImageView alloc] initWithFrame:CGRectMake(myFriend.left, myFriendLabel.bottom + 10, 50, 50)];
    myDynamicFriend.userInteractionEnabled = YES;
    myDynamicFriend.backgroundColor = [UIColor clearColor];
    myDynamicFriend.image = [UIImage imageNamed:@"profile_share_dynamic"];
    [content addSubview:myDynamicFriend];
    [myDynamicFriend addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareDynamic)]];
    UILabel * myDynamicFriendLabel = [[UILabel alloc] initWithFrame:CGRectMake(myDynamicFriend.left, myDynamicFriend.bottom+5, 50, 20)];
    myDynamicFriendLabel.lineBreakMode = NSLineBreakByWordWrapping;
    myDynamicFriendLabel.textAlignment = NSTextAlignmentCenter;
    myDynamicFriendLabel.backgroundColor = [UIColor clearColor];
    myDynamicFriendLabel.textColor = [JYHelpers setFontColorWithString:@"#303030"];
    myDynamicFriendLabel.font = [UIFont systemFontOfSize:12];
    myDynamicFriendLabel.text = @"动态";
    [content addSubview:myDynamicFriendLabel];
    
    
}

- (void)positionAnimationIn //位移动画进入
{
    bgView.origin = CGPointMake(0, 0);
    self.origin = CGPointMake(0, 0);
    [UIView beginAnimations:@"PositionAnitionIn" context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    CGPoint point = content.center;
    point.y -= content.height;
    content.center = point;
    // [UIView setAnimationDidStopSelector:@selector(scareAnimation)];
    [UIView commitAnimations];
}

- (void)positionAnimationOut //位移动画出去
{
    [UIView beginAnimations:@"PositionAnitionOut" context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    CGPoint point = content.center;
    point.y += content.height;
    content.center = point;
    [UIView setAnimationDidStopSelector:@selector(scareAnimationStop)];
    [UIView commitAnimations];
}
#pragma mark - 手势触发事件
//新浪微博分享
- (void)shareSinaWeiBo:(UIGestureRecognizer*)tap{
    [self cancelClick];
    if ([self.fromSDBrower isKindOfClass:[SDPhotoBrowser class]]) {
        [(SDPhotoBrowser*)self.fromSDBrower setHidden:YES];
    }else if ([self.fromSDBrower isKindOfClass:[CPPhotoBrowser class]]){
        [(CPPhotoBrowser*)self.fromSDBrower setHidden:YES];
    }
    id<ISSContent>publishSinaContent;
    if (_profileDataDic) {
        id<ISSCAttachment>image;
        NSString *imageUrl = [[_profileDataDic objectForKey:@"avatars"] objectForKey:@"200"];
        if (imageUrl.length != 0) {
            image = [ShareSDK imageWithUrl:imageUrl];
        }else{
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"pic_morentouxiang_man" ofType:@"png"];
            image = [ShareSDK imageWithPath:imagePath];
        }

        publishSinaContent = [ShareSDK content:[self contentStr]
                                defaultContent:@""
                                         image:image
                                         title:[NSString stringWithFormat:@"友寻-%@的主页",[_profileDataDic objectForKey:@"nick"]]
                                           url:[NSString stringWithFormat:@"http://m.iyouxun.com/wechat/share_profile/?uid=%@",[_profileDataDic objectForKey:@"uid"]]
                                   description:@"友寻"
                                     mediaType:SSPublishContentMediaTypeNews];
    }else{
        publishSinaContent = [ShareSDK content:_shareContent
                                defaultContent:nil
                                         image:[ShareSDK imageWithUrl:_shareImageUrl]
                                         title:_shareTitle
                                           url:_shareUrl
                                   description:@"友寻"
                                     mediaType:SSPublishContentMediaTypeNews];
    }
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                                scopes:nil
                                                         powerByHidden:YES
                                                        followAccounts:nil
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
            //分享内容
    [ShareSDK shareContent:publishSinaContent type:ShareTypeSinaWeibo authOptions:authOptions statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        if (state == SSResponseStateSuccess) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"发送成功！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alert show];
            
        }else if(state == SSResponseStateFail){
            NSLog(@"errorcode ---> %ld",(long)[error errorCode])
            NSLog(@"error ---> %@",[error errorDescription])
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"发送失败！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alert show];
        }

    }];
    
}
//分享微信好友
- (void)shareWeiXinFriends:(UITapGestureRecognizer*)tap{
    [self cancelClick];
    
    Byte* pBuffer = (Byte *)malloc(BUFFER_SIZE);
    memset(pBuffer, 0, BUFFER_SIZE);
    NSData* data = [NSData dataWithBytes:pBuffer length:BUFFER_SIZE];
    free(pBuffer);
    
    id<ISSContent>publishContent;
    SSPublishContentMediaType publishType = SSPublishContentMediaTypeNews;
    
    if ([self.fromSDBrower isKindOfClass:[SDPhotoBrowser class]] || [self.fromSDBrower isKindOfClass:[CPPhotoBrowser class]]) {
        publishType = SSPublishContentMediaTypeImage;
    }
    
    if (_profileDataDic != nil) {
        id<ISSCAttachment>image;
        NSString *imageUrl = [[_profileDataDic objectForKey:@"avatars"] objectForKey:@"200"];
        if (imageUrl.length != 0) {
            image = [ShareSDK imageWithUrl:imageUrl];
        }else{
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"pic_morentouxiang_man" ofType:@"png"];
            image = [ShareSDK imageWithPath:imagePath];
        }
        
        publishContent = [ShareSDK content:[self contentStr]
                            defaultContent:@""
                                     image:image
                                     title:[NSString stringWithFormat:@"%@的友寻主页",[_profileDataDic objectForKey:@"nick"]]
                                       url:[NSString stringWithFormat:@"http://m.iyouxun.com/wechat/share_profile/?uid=%@",[_profileDataDic objectForKey:@"uid"]]
                               description:@"友寻"
                                 mediaType:publishType];
    }else{
 
        publishContent = [ShareSDK content:_shareContent
                            defaultContent:nil
                                     image:[ShareSDK imageWithUrl:_shareImageUrl]
                                     title:_shareTitle
                                       url:_shareUrl
                               description:nil
                                 mediaType:publishType];
    }
    
    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                  content:INHERIT_VALUE
                                    title:INHERIT_VALUE
                                      url:INHERIT_VALUE
                                    image:INHERIT_VALUE
                             musicFileUrl:nil
                                  extInfo:@"<xml>test</xml>"
                                 fileData:data
                             emoticonData:nil];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    [ShareSDK shareContent:publishContent
                      type:ShareTypeWeixiSession
               authOptions:authOptions
             statusBarTips:YES
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        
                        if (state == SSPublishContentStateSuccess)
                        {
                            NSLog(@"success");
                        }
                        else if (state == SSPublishContentStateFail)
                        {
                            if ([error errorCode] == -22003)
                            {
                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                    message:[error errorDescription]
                                                                                   delegate:nil
                                                                          cancelButtonTitle:@"知道了"
                                                                          otherButtonTitles:nil];
                                [alertView show];
                            }
                        }
                    }];
}
//分享到微信朋友圈
- (void)shareWeiXinTimeline:(UITapGestureRecognizer*)tap{
    [self cancelClick];

    Byte* pBuffer = (Byte *)malloc(BUFFER_SIZE);
    memset(pBuffer, 0, BUFFER_SIZE);
    NSData* data = [NSData dataWithBytes:pBuffer length:BUFFER_SIZE];
    free(pBuffer);
    
    id<ISSContent>publishContent;
    
    SSPublishContentMediaType publishType = SSPublishContentMediaTypeNews;
    if ([self.fromSDBrower isKindOfClass:[SDPhotoBrowser class]] || [self.fromSDBrower isKindOfClass:[CPPhotoBrowser class]]) {
        publishType = SSPublishContentMediaTypeImage;
    }
    
    if (_profileDataDic != nil) {
        id<ISSCAttachment>image;
        NSString *imageUrl = [[_profileDataDic objectForKey:@"avatars"] objectForKey:@"200"];
        if (imageUrl.length != 0) {
            image = [ShareSDK imageWithUrl:imageUrl];
        }else{
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"pic_morentouxiang_man" ofType:@"png"];
            image = [ShareSDK imageWithPath:imagePath];
        }


        publishContent = [ShareSDK content:[self contentStr]
                            defaultContent:@""
                                     image:image
                                     title:[NSString stringWithFormat:@"%@的友寻主页",[_profileDataDic objectForKey:@"nick"]]
                                       url:[NSString stringWithFormat:@"http://m.iyouxun.com/wechat/share_profile/?uid=%@",[_profileDataDic objectForKey:@"uid"]]
                               description:@"友寻"
                                 mediaType:publishType];
    }else{
        publishContent = [ShareSDK content:_shareContent
                            defaultContent:nil
                                     image:[ShareSDK imageWithUrl:_shareImageUrl]
                                     title:_shareTitle
                                       url:_shareUrl
                               description:nil
                                 mediaType:publishType];
    }
    
    [publishContent addWeixinTimelineUnitWithType:INHERIT_VALUE
                                          content:INHERIT_VALUE
                                            title:INHERIT_VALUE
                                              url:INHERIT_VALUE
                                            image:INHERIT_VALUE
                                     musicFileUrl:nil
                                          extInfo:@"<xml>test</xml>"
                                         fileData:data
                                     emoticonData:nil];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    //    //在授权页面中添加关注官方微博
    //    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
    //                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
    //                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
    //                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
    //                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
    //                                    nil]];
    
    [ShareSDK shareContent:publishContent
                      type:ShareTypeWeixiTimeline
               authOptions:authOptions
             statusBarTips:YES
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        
                        if (state == SSPublishContentStateSuccess)
                        {
                            NSLog(@"success");
                        }
                        else if (state == SSPublishContentStateFail)
                        {
//                            if ([error errorCode] == -22003)
//                            {
                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                    message:[error errorDescription]
                                                                                   delegate:nil
                                                                          cancelButtonTitle:@"知道了"
                                                                          otherButtonTitles:nil];
                                [alertView show];
//                            }
                        }
                    }];
    
}
//分享QQ好友
- (void)shareQQFriend:(UITapGestureRecognizer*)tap{
   
    [self cancelClick];
    
    id<ISSContent>publishContent;
    SSPublishContentMediaType publishType = _isImageShare ? SSPublishContentMediaTypeImage: SSPublishContentMediaTypeNews;

    if (_profileDataDic != nil) {
        id<ISSCAttachment>image;
        NSString *imageUrl = [[_profileDataDic objectForKey:@"avatars"] objectForKey:@"200"];
        if (imageUrl.length != 0) {
            image = [ShareSDK imageWithUrl:imageUrl];
        }else{
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"pic_morentouxiang_man" ofType:@"png"];
            image = [ShareSDK imageWithPath:imagePath];
        }
        publishContent = [ShareSDK content:[self contentStr]
                            defaultContent:@""
                                     image:image
                                     title:[NSString stringWithFormat:@"友寻-%@的资料",[_profileDataDic objectForKey:@"nick"]]
                                       url:[NSString stringWithFormat:@"http://m.iyouxun.com/wechat/share_profile/?uid=%@",[_profileDataDic objectForKey:@"uid"]]
                               description:@"友寻"
                                 mediaType:publishType];
    }else{
        publishContent = [ShareSDK content:_shareContent
                            defaultContent:nil
                                     image:[ShareSDK imageWithUrl:_shareImageUrl]
                                     title:_shareTitle
                                       url:_shareUrl
                               description:nil
                                 mediaType:publishType];
    }
    
    id<ISSAuthOptions>authOptions = [ShareSDK authOptionsWithAutoAuth:YES allowCallback:YES authViewStyle:SSAuthViewStyleFullScreenPopup viewDelegate:nil authManagerViewDelegate:nil];
   

    [ShareSDK shareContent:publishContent type:ShareTypeQQ authOptions:authOptions statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        if (state == SSResponseStateFail) {
//            NSLog(@"%@",[error errorDescription])
//            NSLog(@"%d",[error errorCode])
            if ([error errorCode] == -24002) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"尚未安装QQ" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
                [alertView show];
            }
        }
    }];
    
}
//发布动态分享
- (void)shareDynamic{
    
    [self cancelClick];
    if ([self.fromSDBrower isKindOfClass:[SDPhotoBrowser class]]) {
        [(SDPhotoBrowser*)self.fromSDBrower setHidden:YES];
    }else if ([self.fromSDBrower isKindOfClass:[CPPhotoBrowser class]]){
        [(CPPhotoBrowser*)self.fromSDBrower setHidden:YES];
    }
    JYFeedEditController *feedEditVC = [[JYFeedEditController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:feedEditVC];
    if (_profileDataDic) {
        [feedEditVC setContent:[self contentStr]];
//        feedEditVC setPicImage:_
    }else{
        [feedEditVC setContent:[self contentShareSingleInYouxun]];
    }
    [feedEditVC setPicId:_pid];
    [feedEditVC setPicImage:_shareImage];
    NSInteger formId = _isImageShare ? 3 : 2;
    [feedEditVC setFormId:formId];
//    [self.pushDelegate presentViewController:feedEditVC animated:YES completion:nil];
     JYNavigationController *currentNav = (JYNavigationController*)[JYAppDelegate sharedAppDelegate].mainTabBarController.selectedViewController;
    [currentNav pushViewController:feedEditVC animated:YES];
    
}
//发送给自己的好友。
- (void)shareMyFriend{
    [self cancelClick];
    if ([self.fromSDBrower isKindOfClass:[SDPhotoBrowser class]]) {
        [(SDPhotoBrowser*)self.fromSDBrower setHidden:YES];
    }else if ([self.fromSDBrower isKindOfClass:[CPPhotoBrowser class]]){
        [(CPPhotoBrowser*)self.fromSDBrower setHidden:YES];
    }
    
    JYShareToMyFriendController *shareMyFriendVC = [[JYShareToMyFriendController alloc] init];
    if (_profileDataDic) {
        [shareMyFriendVC setShareContent:[self contentStr]];
    }else{
        [shareMyFriendVC setShareContent:[self contentShareSingleInYouxun]];
    }
    [shareMyFriendVC setIsShareImage:_isImageShare];
    [shareMyFriendVC setShareImage:_shareImage];
    JYNavigationController *currentNav = (JYNavigationController*)[JYAppDelegate sharedAppDelegate].mainTabBarController.selectedViewController;
    [currentNav pushViewController:shareMyFriendVC animated:YES];

}
- (void) cancelClick{
    
    [self positionAnimationOut];
}
- (NSString*)contentStr{
    if ([[_profileDataDic objectForKey:@"uid"] integerValue] == [[SharedDefault objectForKey:@"uid"] integerValue]) {
        return _shareContent;
    }else{
        NSString *sex = [_profileDataDic[@"sex"] intValue]==0?@"她":@"他";
        NSMutableString *contenStr = [NSMutableString stringWithFormat:@"%@是单身，帮%@脱单吧。",_profileDataDic[@"nick"],sex];
        [contenStr appendFormat:@"%@的资料：http://m.iyouxun.com/wechat/share_profile/?uid=%@",sex,[_profileDataDic objectForKey:@"uid"]];
        return contenStr;
    }
}
- (void) scareAnimationStop{
    bgView.origin = CGPointMake(0, kScreenHeight);
    self.origin = CGPointMake(0, kScreenHeight);
}

- (NSString*)contentShareSingleInYouxun{
    if (_shareSingleContent) {
        return _shareSingleContent;
    }else{
        return _shareContent;
    }

}

//        NSString * animal = [[[JYShareData sharedInstance].profile_dict objectForKey:@"animal"] objectForKey:[_profileDataDic objectForKey:@"animal"]];
//        NSString * mystar = [[[JYShareData sharedInstance].profile_dict objectForKey:@"star"] objectForKey:[_profileDataDic objectForKey:@"star"]];
//
//        NSString *star = @"";
//        if (animal.length != 0 && mystar.length != 0) {
//            star = [NSString stringWithFormat:@"%@, 属相%@",mystar,animal];
//        }
//        NSString *province = [[JYShareData sharedInstance].province_code_dict objectForKey:[_profileDataDic objectForKey:@"live_location"]];
//        NSString *marriage = [[[JYShareData sharedInstance].profile_dict objectForKey:@"marriage"] objectForKey:[_profileDataDic objectForKey:@"marriage"]];
//        NSString *confirm = [NSString stringWithFormat:@"%@位好友认证",[_profileDataDic objectForKey:@"lonely_confirm"]];
//        NSString *province = [[JYShareData sharedInstance].province_code_dict objectForKey:[_profileDataDic objectForKey:@"live_sublocation"]];
//        //        NSString *marriage = [[[JYShareData sharedInstance].profile_dict objectForKey:@"marriage"] objectForKey:[_profileDataDic objectForKey:@"marriage"]];
//        //        NSString *confirm = [NSString stringWithFormat:@"%@位好友认证",[_profileDataDic objectForKey:@"lonely_confirm"]];
//        NSString *friend = @"";
//        if ([[_profileDataDic objectForKey:@"is_friend"] isEqualToString:@"1"]) {
//            friend = [[JYShareData sharedInstance].myself_profile_dict objectForKey:@"nick"];
//        }
//        NSMutableString *contenStr = [NSMutableString stringWithFormat:@"我是%@，",_profileDataDic[@"nick"]];
//        if (province.length > 0) {
//            [contenStr appendFormat:@"来自%@",province];
//        }
//        if (friend.length > 0) {
//            [contenStr appendFormat:@",是%@的好友",friend];
//        }
//        [contenStr appendFormat:@",我的资料：http://m.friendly.dev/wechat/share_profile/?uid=%@",[_profileDataDic objectForKey:@"uid"]];

//        SSPublishContentMediaType publishType = SSPublishContentMediaTypeNews;
//
//        if ([self.fromSDBrower isKindOfClass:[SDPhotoBrowser class]]) {
//            publishType = SSPublishContentMediaTypeImage;
//        }

@end
