//
//  JYChatTableView.m
//  friendJY
//
//  Created by 高斌 on 15/3/24.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYChatTableView.h"
#import "JYChatModel.h"
#import "JYChatTableViewCell.h"

@implementation JYChatTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        _cellCache = [[NSCache alloc] init];
    }
    return self;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    JYChatTableViewCell *cell = (JYChatTableViewCell *)[self tableView:tableView preparedCellForIndexPath:indexPath];
    
    return cell.height;
     */
    
    JYChatTableViewCell *cell = [[JYChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    JYChatModel *model = [self.data objectAtIndex:indexPath.row];
    [cell layoutWithModel:model];
    
    return cell.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /*
    JYChatTableViewCell *cell = (JYChatTableViewCell *)[self tableView:tableView preparedCellForIndexPath:indexPath];
    
    return cell;
     */
    
    static NSString *cellIdentifier= @"JYChatTableViewCell";
    JYChatTableViewCell *cell = (JYChatTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        
        cell = [[JYChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    JYChatModel *model = [self.data objectAtIndex:indexPath.row];
    [cell layoutWithModel:model];
    
    return cell;
}

@end
