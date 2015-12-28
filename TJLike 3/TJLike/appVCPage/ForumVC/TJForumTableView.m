//
//  TJForumTableView.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/4.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJForumTableView.h"
#import "TJForumViewCell.h"




@interface TJForumTableView ()


@end

@implementation TJForumTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.showsHorizontalScrollIndicator = NO;

    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    TJBbsCatagoryModel *model = [self.forumTitles objectAtIndex:section];
    
    return model.subclassList.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.forumTitles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    view.backgroundColor = COLOR(242, 244, 248, 1);
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH -10, 30)];
    [lblTitle setTextAlignment:NSTextAlignmentLeft];
    [lblTitle setTextColor:[UIColor blackColor]];
    [lblTitle setFont:[UIFont systemFontOfSize:14.0f]];
    TJBbsCatagoryModel *model = [self.forumTitles objectAtIndex:section];
    [lblTitle setText:model.name];
    [view addSubview:lblTitle];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strCellID = @"TJForumViewCell";
    TJForumViewCell *cell = (TJForumViewCell *)[tableView dequeueReusableCellWithIdentifier:strCellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:strCellID owner:self options:nil] lastObject];
        
    }
     TJBbsCatagoryModel *model = [self.forumTitles objectAtIndex:indexPath.section];
    TJBBSCateSubModel  *subModel = [model.subclassList objectAtIndex:indexPath.row];
    [cell bindModel:subModel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TJBbsCatagoryModel *model = (TJBbsCatagoryModel *)[self.forumTitles objectAtIndex:indexPath.section];
    TJBBSCateSubModel *item = (TJBBSCateSubModel *)[model.subclassList objectAtIndex:indexPath.row];
    if (self.tapFuromCell) {
        self.tapFuromCell(item);
    }
    
}


@end
