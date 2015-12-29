//
//  ThemeCatgoryViewController.h
//  TestRedCollar
//
//  Created by MC on 14-7-10.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"

@interface ThemeCatgoryViewController : BaseADViewController
{
    UIScrollView *mScrollView;
    UIButton *mSelectBtn;
}
@property (assign,nonatomic)int didSelectedNumber;
@property (assign,nonatomic)int typeID;
@end
