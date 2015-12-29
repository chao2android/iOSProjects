//
//  HomeViewController.h
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-4.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabbarView.h"
#import "BaseADViewController.h"

@interface HomeViewController : BaseADViewController<SelectTabbarDelegate, UIActionSheetDelegate> {
    TabbarView *mTabView;
}

@property (nonatomic, readonly) UIViewController *mRootCtrl;

@end
