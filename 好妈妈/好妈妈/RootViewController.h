//
//  RootViewController.h
//  好妈妈
//
//  Created by iHope on 13-9-22.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnalysisClass.h"
@interface RootViewController : UITabBarController<AnalysisClassDelegate,UIAlertViewDelegate>
{
    UILabel * tishiLabel;
    int numnum;
    NSString * banbenString;
}
@property (assign,nonatomic) int num;
@property (retain,nonatomic) UIImageView * tabbarImageView;
@end
