//
//  JYSameFriendTableView.h
//  friendJY
//
//  Created by chenxiangjing on 15/4/22.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYTableViewDidSelectedRowDelegate <NSObject>

@required
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface JYSameFriendTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) id<JYTableViewDidSelectedRowDelegate> selectedDelegate;
@property (nonatomic, strong) NSMutableArray *friendList;
@property (nonatomic, strong) NSMutableArray *indexArr;

@end
