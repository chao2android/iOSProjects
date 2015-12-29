//
//  GrowingInfoView.h
//  好妈妈
//
//  Created by Hepburn Alex on 14-5-16.
//  Copyright (c) 2014年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TishiView.h"
#import "MBProgressHUD.h"

@interface GrowingInfoView : UIView<UIWebViewDelegate ,UIScrollViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate> {
    MBProgressHUD *myHUD;
    UIImageView *webBgView;
    UIWebView *myWebView;
    UIButton *animBut;
    
    UIButton *leftBut;
    UIButton *rightBut;
    UIButton *goBut;
    
    UIToolbar *topBar;
    UIPickerView * pickerView;
    
    UIImageView *dingBgView;
}

@property(nonatomic ,retain)NSString *sam_day;

@property(nonatomic,assign) NSInteger sam_age;
@property(nonatomic,assign) NSInteger sam_month;
@property(nonatomic,assign) NSInteger sam_date;
@property(nonatomic,assign) NSInteger sam_zhou;
@property(nonatomic,assign) NSInteger sam_tian;



@property(nonatomic ,retain) NSString *sam_type;

@property (nonatomic, assign) UIViewController *mRootCtrl;

@end
