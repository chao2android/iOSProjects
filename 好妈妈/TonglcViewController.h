//
//  TonglcViewController.h
//  好妈妈
//
//  Created by iHope on 13-10-14.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
#import "AnalysisClass.h"
#import "TishiView.h"
#import <CoreLocation/CoreLocation.h>

@interface TonglcViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate,AnalysisClassDelegate,UIPickerViewDataSource,UIPickerViewDelegate,CLLocationManagerDelegate,UIAlertViewDelegate>
{
    int page;
    PullingRefreshTableView *_uitable;
    AnalysisClass * analysis;
    UIImageView * pickerImageView;
    int seleNum;
    int selectcNum;
    UIButton* rightBut;
    BOOL butBool;
}
@property (retain,nonatomic) TishiView * tishiView;
@property (retain,nonatomic) NSMutableDictionary * oldDictionary;
@property (retain,nonatomic) NSMutableArray * dataArray;
@property (retain,nonatomic) NSMutableDictionary * dataDictionary;
@property (retain,nonatomic) UIPickerView * myPickerView;
@end
