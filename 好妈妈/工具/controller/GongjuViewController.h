//
//  GongjuViewController.h
//  好妈妈
//
//  Created by iHope on 13-9-22.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GongjuViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    UITableView *mTableView;
    NSArray *mArray;
}

@end
