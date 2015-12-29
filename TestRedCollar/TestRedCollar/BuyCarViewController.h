//
//  BuyCarViewController.h
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-5.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseADViewController.h"

@interface BuyCarViewController : BaseADViewController {
    UIScrollView *mScrollView;
    UIButton *mSelectBtn;
    UIButton *mDecBtn;
    UIButton *mIncBtn;
    UILabel *mlbCount;
    int miCount;
}

@end
