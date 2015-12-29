//
//  AppDelegate.h
//  好妈妈
//
//  Created by iHope on 13-9-22.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import <CoreLocation/CoreLocation.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,WXApiDelegate>

{
    
    UIImageView * qidongImageView;
    UIImageView * donghuaImageView;
    UIImageView * butImageView;
    
}
@property (strong, nonatomic) NSString *mMsgID;
@property (strong, nonatomic) UIWindow *window;

@end
