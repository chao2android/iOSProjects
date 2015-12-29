//
//  JYFeedDetailTableView.m
//  friendJY
//
//  Created by ouyang on 4/7/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//

#import "JYFeedDetailTableView.h"
#import "JYFeedDetailTableViewCell.h"
#import "JYFeedDetailModel.h"
#import "JYFeedTextView.h"

@interface JYFeedDetailTableView ()

@end

@implementation JYFeedDetailTableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"feeddetailCell";
    
    JYFeedDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[JYFeedDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        //cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    JYFeedDetailModel *model = self.data[indexPath.row];
    cell.feedModel = model;
    //    cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    [cell LoadContent];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //在此使用样本Cell计算高度。
    
    JYFeedDetailModel *myModel = self.data[indexPath.row];
    
    //计算名字高度
    NSMutableString * nickStr = [NSMutableString string];
    [nickStr appendString:myModel.nick];
    //如果存在回复信息，要加上回复人名
    if ([myModel.reply isKindOfClass:[NSDictionary class]]) {
        NSString *replyNick = [myModel.reply objectForKey:@"nick"];
        [nickStr appendFormat:@"回复%@: ",replyNick];
    }else{
        [nickStr appendString:@": "];
    }
    JYFeedTextView *nickLabel = [[JYFeedTextView alloc] initWithFrame:CGRectZero];
    nickLabel.showWidth = kScreenWidth -115;
    [nickLabel layoutWithContent:nickStr];
    NSInteger commentTempHeight = nickLabel.bounds.size.height ;
    //--------------------//
    
    //内容的高度
    JYFeedTextView *commentContent = [[JYFeedTextView alloc] initWithFrame:CGRectZero];
    commentContent.showWidth = kScreenWidth-41-20;
    [commentContent layoutWithContent:myModel.content];
    NSInteger commentTempHeigh2 = commentContent.bounds.size.height > 20?commentContent.bounds.size.height:20;
    [nickLabel setFrame:CGRectMake(nickLabel.left, nickLabel.bottom, kScreenWidth-nickLabel.left-20, commentTempHeight)];
    
    return commentTempHeight + commentTempHeigh2+10+10+10;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    JYFeedDetailModel *model = (JYFeedDetailModel *)[self.data objectAtIndex:indexPath.row];
    NSString *myuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    if ([model.uid isEqualToString:myuid] || [model.feedUid isEqualToString:myuid]) { //当只有是自已发出的评论及属于自已的动态时可以出现删除选择
        return YES;
    }else{
        return NO;
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        if (self.data.count>0) {
            JYFeedDetailModel *model = (JYFeedDetailModel *)[self.data objectAtIndex:indexPath.row];
            
            if (model) {
                DeleteSuccessCallBackBlock block = ^() {
                    [(NSMutableArray *)self.data removeObjectAtIndex:indexPath.row];
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                };
                
                NSDictionary *userInfo = [NSDictionary dictionaryWithObjects:@[model.id, block] forKeys:@[@"cid", @"callBackBlock"]];
                
                //发送删除的通知
                [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteDynamicCommentNotification object:nil userInfo:userInfo];
            }
        }
        
    }
}

@end
