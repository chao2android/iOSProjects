//
//  JYFeedNewsListTableView.m
//  friendJY
//
//  Created by ouyang on 4/20/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//

#import "JYFeedNewsListTableView.h"
#import "JYFeedNewsListTableViewCell.h"
#import "JYFeedNewsListModel.h"

@interface JYFeedNewsListTableView ()

@end

@implementation JYFeedNewsListTableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.data.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"feednewlistCell";
    
    JYFeedNewsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[JYFeedNewsListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    JYFeedNewsListModel *model = self.data[indexPath.row];
    cell.feedModel = model;
    //    cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    
    return cell;
}


@end
