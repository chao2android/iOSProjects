//
//  XiuGaibaobaoViewController.h
//  好妈妈
//
//  Created by iHope on 13-11-1.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XiuGaibaobaoViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
{
    BOOL pickerBool;
    UIButton * riqiButton;
    int selectNum;
    int xingbieNum;
}
@property (retain,nonatomic)id temp;
@property (retain,nonatomic) UIPickerView * myPickerView;
@property (retain,nonatomic) NSMutableDictionary * oldDictionary;
@property (retain,nonatomic) NSMutableDictionary * loginDictionary;
@end
