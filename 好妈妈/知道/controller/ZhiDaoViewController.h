//
//  ZhiDaoViewController.h
//  好妈妈
//
//  Created by iHope on 13-9-22.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
//#import "NavTabBar.h"

@interface ZhiDaoViewController : UIViewController<CLLocationManagerDelegate>//, NavTabBarDelegate>
{
    UIImageView *memu;
    UIImageView *bgMemu;
    int memuTag;
    
    UIImageView * mNavView;
    UIButton *mLeftBtn;
    UIButton *mRightBtn;
    
    //NavTabBar *mNavTabBar;
}
@end
