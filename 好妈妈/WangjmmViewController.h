//
//  WangjmmViewController.h
//  好妈妈
//
//  Created by iHope on 13-9-29.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnalysisClass.h"
#import "TishiView.h"
@interface WangjmmViewController : UIViewController<AnalysisClassDelegate>
{
    TishiView * tishiView;
    AnalysisClass * analysis;
    UIButton * zhaohuiButton;
    NSTimer * huoquTimer;

}
@property (retain,nonatomic) NSString *mPhone;
@property (retain,nonatomic)UITextField * shoujihaoTextfield;
@end
