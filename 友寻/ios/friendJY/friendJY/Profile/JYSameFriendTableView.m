//
//  JYSameFriendTableView.m
//  friendJY
//
//  Created by chenxiangjing on 15/4/22.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYSameFriendTableView.h"
#import "JYFindSecondFriendCell.h"
#import "JYCreatGroupFriendModel.h"
#import "ChineseString.h"

@interface JYSameFriendTableView()

@end
@implementation JYSameFriendTableView
//@synthesize _friendList;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
//        _nameList = [NSMutableArray array];
//        _indexArr = [NSMutableArray array];
        [self setDelegate:self];
        [self setDataSource:self];
        UIView *footerView = [[UIView alloc] init];
        [footerView setBackgroundColor:[UIColor clearColor]];
        [self setTableFooterView:footerView];
        [self setRowHeight:54];
//        [self setBackgroundColor:[UIColor orangeColor]];
    }
    return self;
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_friendList objectAtIndex:section] count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_friendList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    JYFindSecondFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[JYFindSecondFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [cell layoutSubviewsWithModel:[_friendList objectAtIndex:indexPath.section][indexPath.row]];
    return cell;
}
- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return _indexArr;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.selectedDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.selectedDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 29)];
    [header setBackgroundColor:[JYHelpers setFontColorWithString:@"#edf1f4"]];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 40, 29)];
    [lab setBackgroundColor:[UIColor clearColor]];
    [lab setFont:[UIFont systemFontOfSize:17.0f]];
    [lab setTextColor:[JYHelpers setFontColorWithString:@"#303030"]];
    [lab setText:_indexArr[section]];
    [header addSubview:lab];
    
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 29;
}
#pragma mark --数据处理方法

- (void)setFriendList:(NSMutableArray *)friendList{
    if(_friendList != friendList){
        _friendList = [NSMutableArray arrayWithArray:friendList];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
