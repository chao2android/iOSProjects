//
//  XiugaiMimaViewController.h
//  好妈妈
//
//  Created by iHope on 13-10-17.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnalysisClass.h"
@class TishiView;
@interface XiugaiMimaViewController : UIViewController<AnalysisClassDelegate>
{
    AnalysisClass * analysis;
}
@property (retain,nonatomic)UITextField * yuanTextField;
@property (retain,nonatomic)UITextField * mimaTextField;
@property (retain,nonatomic)UITextField * quedingTextField;
@property (assign,nonatomic)BOOL biaotiBool;
@property (retain,nonatomic)TishiView * tishiView;

@property (retain, nonatomic) NSString *mMobile;
@property (retain, nonatomic) NSString *mPassword;

@end
