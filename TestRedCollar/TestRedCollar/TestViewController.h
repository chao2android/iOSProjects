//
//  TestViewController.h
//  TestRedCollar
//
//  Created by dreamRen on 14-7-20.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocial.h"
@interface TestViewController : UIViewController<UMSocialDataDelegate>{
    UIAlertView *_alertView;

}
@property(nonatomic,strong)UIImage *screenshotsImage;

@end
