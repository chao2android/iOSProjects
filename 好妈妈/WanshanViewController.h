//
//  WanshanViewController.h
//  好妈妈
//
//  Created by iHope on 13-9-25.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnalysisClass.h"
@class TishiView;
@interface WanshanViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,AnalysisClassDelegate>
{
    BOOL pickerBool;
    UIButton * riqiButton;
    int selectNum;
    int xingbieNum;
    AnalysisClass * analysis;
}
@property (retain,nonatomic)TishiView * tishiView;
@property (retain,nonatomic) UITextField * mcTextFeild;
@property (retain,nonatomic) UIPickerView * myPickerView;
@property (retain,nonatomic) NSMutableDictionary * oldDictionary;
@property (retain,nonatomic) NSMutableDictionary * loginDictionary;
@end
