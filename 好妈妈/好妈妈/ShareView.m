//
//  ShareView.m
//  好妈妈
//
//  Created by iHope on 13-11-18.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "ShareView.h"
#import <ShareSDK/ShareSDK.h>
#import "AGViewDelegate.h"
@implementation ShareView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hidesTabBar" object:nil];

        
        // Initialization code
    }
    return self;
}
- (void)SharecontentMenth:(NSString *)contentString shareImagePath:(NSString *)imageString biaoti:(NSString *)biaotiString fenxiangleixing:(int)fenxiangType
{
    
   
        id<ISSAuthController> controller=[ShareSDK authorizeController:ShareTypeTencentWeibo];
        
        [controller  start:NO result:^(SSAuthState state ,CMErrorInfo *error){
            NSLog(@"state  %d",state);
            if (state)
            {
                
                [[controller view]removeFromSuperview];
                [ShareSDK getUserInfoWithType:fenxiangType
                                  authOptions:nil
                                       result:^(BOOL result, id<ISSUserInfo> userInfo, id<ICMErrorInfo> error) {
                                           if (result)
                                           {
                                               NSLog(@"%@  %d",[userInfo icon],[userInfo type]);
                                               [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayTabBar" object:nil];

                                               id<ISSContent> publishContent = [ShareSDK content:contentString
                                                                                  defaultContent:@""
                                                                                           image:[ShareSDK imageWithPath:imageString]
                                                                                           title:@"好妈妈"
                                                                                             url:@""
                                                                                     description:biaotiString
                                                                                       mediaType:SSPublishContentMediaTypeNews];
                                               
                                               
                                               AGViewDelegate * agviewDelegate = [[AGViewDelegate alloc] init];
                                             
                                               
                                               
                                               [ShareSDK shareContent:publishContent type:fenxiangType authOptions:nil shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                                                                                                                                   oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                                                                                                                                    qqButtonHidden:NO
                                                                                                                                                             wxSessionButtonHidden:NO
                                                                                                                                                            wxTimelineButtonHidden:NO
                                                                                                                                                              showKeyboardOnAppear:NO
                                                                                                                                                                 shareViewDelegate:agviewDelegate
                                                                                                                                                               friendsViewDelegate:agviewDelegate
                                                                                                                                                             picViewerViewDelegate:nil] statusBarTips:YES result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                   if (state == SSPublishContentStateSuccess)
                                                   {
                                                       NSLog(@"发表成功");
                                                   }
                                                   else if (state == SSPublishContentStateFail)
                                                   {
                                                       NSLog(@"发布失败!error code == %d, error code == %@", [error errorCode], [error errorDescription]);
                                                   }
                                               }];
                                               [agviewDelegate release];
                                           }
                                           if ([[error errorDescription] length]) {
                                               
                                               
                                               UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:[error errorDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                               [alertView show];
                                               [alertView release];
                                               NSLog(@"%d:%@",[error errorCode], [error errorDescription]);
                                           }
                                       }];
                
            }
        }];
        if (![controller isSSOLogin]) {
           UIView * aView=[controller view];
            aView.frame=CGRectMake(0, 0, Screen_Width, Screen_Height);
            [self addSubview:aView];
            UIImageView * navigation=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 44)];
            navigation.userInteractionEnabled=YES;
            navigation.backgroundColor=[UIColor blackColor];
            navigation.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nav_background" ofType:@"png"]];
            [aView addSubview:navigation];
            [navigation release];
            UILabel * navigationLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 11, (Screen_Width-160), 22)];
            navigationLabel.backgroundColor=[UIColor clearColor];
            navigationLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:22];
            navigationLabel.textAlignment=NSTextAlignmentCenter;
            navigationLabel.textColor=[UIColor whiteColor];
            navigationLabel.text=@"腾讯微博授权";
            [navigation addSubview:navigationLabel];
            [navigationLabel release];
            UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
            back.frame = CGRectMake(5, 7, 51, 33);
            [back setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"钮" ofType:@"png"]] forState:UIControlStateNormal];
            [back setTitle:@"取 消" forState:UIControlStateNormal];
            [back addTarget:self action:@selector(backup) forControlEvents:UIControlEventTouchUpInside];
            [navigation addSubview:back];
        }
    
}
- (void)backup
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayTabBar" object:nil];

    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
