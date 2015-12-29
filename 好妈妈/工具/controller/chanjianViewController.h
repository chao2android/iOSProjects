//
//  chanjianViewController.h
//  好妈妈
//
//  Created by liuguozhu on 13-10-14.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface chanjianViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    int miFontSize;
  UITableView *_uitable;
  
  UIView *bgL;
  
  NSMutableArray *_smArr;
  NSMutableArray *_yzArr;
    NSMutableArray *_czArr;
  UILabel *lab1;
    
    UILabel *dataLab;
    UIView *dataBgView;

    UIDatePicker *dataPicker;
    
    
    UIView *sam_bgView;
    
    UIImageView * xiacichanjianView;
    UILabel * xiacichanjianLabel;
    BOOL panduanBool;
    int huaiyunday;
    UIButton * tixingbutton;
}
- (int)HuaiYuanTianShuMenth:(NSDate *)date1 yuchanqi:(NSDate *)date;
@end
