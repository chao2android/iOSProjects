//
//  WanShangrzlViewController.h
//  好妈妈
//
//  Created by iHope on 13-10-17.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WanShangrzlViewController : UIViewController<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIImageView * pickerImageView;
    UIPickerView * locatePicker;
}
@property (retain,nonatomic)id temp;
@property (retain,nonatomic)NSString * titleString;
@property (retain,nonatomic)UITextField * contentTextField;
@property (retain,nonatomic)NSMutableArray * citeArray;
@end
