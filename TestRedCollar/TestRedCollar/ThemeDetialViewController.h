//
//  ThemeDetialViewController.h
//  TestRedCollar
//
//  Created by MC on 14-7-10.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"
#import "ThemeCateListModel.h"
@interface ThemeDetialViewController : BaseADViewController<UIScrollViewDelegate>


@property (nonatomic, assign) int mThemeID;
@property (nonatomic, strong) NSDictionary *mDict;

@end
