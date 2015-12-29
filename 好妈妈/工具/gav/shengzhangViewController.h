//
//  shengzhangViewController.h
//  好妈妈
//
//  Created by liuguozhu on 13-10-14.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "LineLabelView.h"

typedef enum {
    TLineFormType_Weight,
    TLineFormType_Height,
    TLineFormType_BMI
} TLineFormType;

@interface shengzhangViewController : UIViewController<CPTPlotDataSource, CPTAxisDelegate, CPTPlotSpaceDelegate> {
    UIView *mContentView;
    NSMutableDictionary *mDict;
    TLineFormType miType;
    BOOL mbMale;
    UILabel *mlbTitle;
    LineLabelView *mLabelView;
}

@property (nonatomic, assign) BOOL mbMale;

@end
