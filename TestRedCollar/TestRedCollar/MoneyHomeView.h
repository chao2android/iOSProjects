//
//  MoneyHomeView.h
//  TestRedCollar
//
//  Created by dreamRen on 14-5-5.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseListView.h"

@interface MoneyHomeView : BaseListView<UITableViewDataSource,UITableViewDelegate>{
    UIImageView *theTopImageView;
    UILabel *theFansCount;
    UILabel *theAttentionCount;
    UILabel *theNameLabel;
    UIImageView *theLogoImageView;
    
    UIButton *mSelectBtn;
    UITableView *_theTable;
    NSMutableArray *_theList;
    int iCurType;
    //    UIScrollView *mScrollView;
    
    UIButton *_moneyButton;
    UIButton *_integralButton;
    BOOL isShowMoney;
}

@end
