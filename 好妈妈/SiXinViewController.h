//
//  SiXinViewController.h
//  好妈妈
//
//  Created by iHope on 13-9-27.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnalysisClass.h"
#import "TishiView.h"

@interface SiXinViewController : UIViewController<AnalysisClassDelegate,UITableViewDelegate,UITableViewDataSource>
{
    AnalysisClass * analysis;
    UITableView * myTableView;
    TishiView * tishiView;
    int tishinum;
}
@property (retain,nonatomic)NSMutableArray * dataArray;
@end
