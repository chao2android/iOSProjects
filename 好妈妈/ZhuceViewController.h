//
//  ZhuceViewController.h
//  好妈妈
//
//  Created by iHope on 13-9-24.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnalysisClass.h"
@class TishiView;
@interface ZhuceViewController : UIViewController<AnalysisClassDelegate>
{
    UIButton * huoquButton;
    NSTimer * huoquTimer;
    AnalysisClass * analysis;
}
@property (retain,nonatomic) NSMutableDictionary * oldDictionary;
@property (retain,nonatomic) UITextField * shoujihaoTextfield;
@property (retain,nonatomic) UITextField * yanzhengmaTextfield;
@property (retain,nonatomic) TishiView * tishiView;
@end
