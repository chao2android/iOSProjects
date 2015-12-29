//
//  JYProfileEditGroupTableView.h
//  friendJY
//
//  Created by chenxiangjing on 15/5/5.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JYGroupModel;
@class JYProfileEditGroupCell;

@protocol JYProfileEditGroupTableViewDelegate<NSObject>
@required

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)requestChangeGroupInfoWithDataModel:(JYGroupModel*)model inCell:(JYProfileEditGroupCell*)cell;

@end


@interface JYProfileEditGroupTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) BOOL hasEdit;

@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, assign) id<JYProfileEditGroupTableViewDelegate>editDelegate;

@end
