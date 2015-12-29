//
//  WeirijiViewController.h
//  好妈妈
//
//  Created by iHope on 13-9-25.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnalysisClass.h"
#import "ZhaopianView.h"
@interface WeirijiViewController : UIViewController<AnalysisClassDelegate>
{
    AnalysisClass * analysis;
    ZhaopianView * zhaopianView;
    UIView * backView;
}
@property (retain,nonatomic)NSString * typeString;
@property (retain,nonatomic)NSString * targetidString;
@property (retain,nonatomic)UIButton * navigationButton;
@property (retain,nonatomic) UIImageView * tiaojianImageView;

@end
