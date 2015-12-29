//
//  TuijianquanziViewController.h
//  好妈妈
//
//  Created by iHope on 13-9-22.
//  Copyright (c) 2013年 1510Cloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnalysisClass.h"
#import "PullingRefreshTableView.h"
@class TishiView;
@interface TuijianquanziViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,AnalysisClassDelegate,UIAlertViewDelegate>
{
    int page;
    PullingRefreshTableView *_uitable;
    BOOL SelectBool;
    AnalysisClass * analysis;
    UIButton* rightBut;
    int selectcNum;
}

- (void)ReloadQuanziMenht:(NSMutableDictionary *)aDictionary;
@property (retain,nonatomic) TishiView * tishiView;
@property (retain,nonatomic) NSMutableDictionary * postDictionary;
@property (retain,nonatomic) NSMutableDictionary * oldDictionary;
@property (retain,nonatomic) NSMutableArray * dataArray;
@property (retain,nonatomic) UIImageView * selectImageView;
@end
