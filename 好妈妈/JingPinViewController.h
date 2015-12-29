//
//  JingPinViewController.h
//  好妈妈
//
//  Created by iHope on 13-9-25.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnalysisClass.h"
@interface JingPinViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,AnalysisClassDelegate>
{
    AnalysisClass * analysis;
    UITableView * myTableView;
}
@property (retain,nonatomic)NSMutableArray * dataArray;

@end
