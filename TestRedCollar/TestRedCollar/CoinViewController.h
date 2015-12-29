//
//  CoinViewController.h
//  TestRedCollar
//
//  Created by miracle on 14-7-10.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"
#import "ImageDownManager.h"

@interface CoinViewController : BaseADViewController <UITableViewDelegate, UITableViewDataSource>
{
    UIButton *mSelectBtn;
}
@property (nonatomic, copy) NSString *theTitleText;
@property (nonatomic, retain) ImageDownManager *mDownManager;
@property (nonatomic, assign) SEL onSaveClick;
@end
