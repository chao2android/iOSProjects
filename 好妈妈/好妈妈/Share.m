//
//  Share.m
//  好妈妈
//
//  Created by iHope on 13-10-28.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "Share.h"
#import <ShareSDK/ShareSDK.h>
#import "AGViewDelegate.h"
@implementation Share
+ (void)SharecontentMenth:(NSString *)contentString shareImagePath:(NSString *)imageString biaoti:(NSString *)biaotiString fenxiangleixing:(int)fenxiangType
{


    id<ISSContent> publishContent = [ShareSDK content:contentString
                                       defaultContent:@""
                                                image:[ShareSDK imageWithPath:imageString]
                                                title:@"好妈妈"
                                                  url:@""
                                          description:biaotiString
                                            mediaType:SSPublishContentMediaTypeNews];
    
    
        AGViewDelegate * agviewDelegate = [[AGViewDelegate alloc] init];
        
        id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                             allowCallback:YES
                                                             authViewStyle:SSAuthViewStyleFullScreenPopup
                                                              viewDelegate:nil
                                                   authManagerViewDelegate:agviewDelegate];
        
        [authOptions setPowerByHidden:YES];

        [ShareSDK shareContent:publishContent type:fenxiangType authOptions:authOptions shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
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
+ (void)ShareShouquan
{
//    ShareType type = 1;
//    AGViewDelegate * _viewDelegate = [[AGViewDelegate alloc] init];
//    
//    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
//                                                         allowCallback:YES
//                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
//                                                          viewDelegate:nil
//                                               authManagerViewDelegate:_viewDelegate];
//    
//    [ShareSDK getUserInfoWithType:type
//                      authOptions:authOptions
//                           result:^(BOOL result, id<ISSUserInfo> userInfo, id<ICMErrorInfo> error) {
//                               if (result)
//                               {
//                                   NSLog(@"fsdfsd");
//                                   [item setObject:[userInfo nickname] forKey:@"username"];
//                                   [_shareTypeArray writeToFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()] atomically:YES];
//                               }
//                               NSLog(@"%d:%@",[error errorCode], [error errorDescription]);
//                               
//                           }];
//    [_viewDelegate release];

}

+ (BOOL)IsIpad {
    NSString *devicename = [UIDevice currentDevice].model;
    if (devicename) {
        NSRange range = [devicename rangeOfString:@"iPad" options:NSCaseInsensitiveSearch];
        if (range.length>0) {
            return YES;
        }
    }
    return NO;
}

@end
