//
//  JYMessageTableView.m
//  friendJY
//
//  Created by 高斌 on 15/4/14.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYMessageTableView.h"
#import "JYMessageTableViewCell.h"
#import "JYMessageModel.h"
#import "JYChatDataBase.h"

@implementation JYMessageTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"JYMessageTableViewCell";
    
    JYMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[JYMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    JYMessageModel *model = self.data[indexPath.row];
    [cell layoutWithModel:model];
    
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
        return YES;
  
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        JYMessageModel *model = (JYMessageModel *)[self.data objectAtIndex:indexPath.row];
        
        DeleteSuccessCallBackBlock block = ^(NSString *oid,NSString *group_id) {
            BOOL isOidExist = NO;
            for (JYMessageModel *temp in self.data) {
                if ([group_id integerValue] >0) {
                    if ([oid isEqualToString:temp.oid]) {
                        isOidExist = YES;
                        break;
                    }
                }else{
                    if ([oid isEqualToString:temp.oid]) {
                        isOidExist = YES;
                        break;
                    }
                }
            }
            if (!isOidExist) {
                return;
            }
          
            [(NSMutableArray *)self.data removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
           
            if ([group_id integerValue] >0) { //删除群组聊天
                [[JYChatDataBase sharedInstance] deleteOneGroupUser:group_id];
               
            }else{ //删除普通个人聊天
                [[JYChatDataBase sharedInstance] deleteOneUser:oid];
            }
            
            //刷新tabbar的数字
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshTabBarUnreadNumberNotification object:nil];
        };
        
        if (model.oid == nil) {
            model.oid=@"";
        }
        if (model.group_id == nil) {
            model.group_id=@"";
        }
       
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjects:@[model.oid,model.group_id, block] forKeys:@[@"oid",@"group_id", @"callBackBlock"]];
       
        //发送删除的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteOneMessageUserNotification object:nil userInfo:userInfo];
        
    }
}


@end
