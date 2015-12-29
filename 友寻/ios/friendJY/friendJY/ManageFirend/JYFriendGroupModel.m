//
//  JYFriendGroupModel.m
//  friendJY
//
//  Created by chenxiangjing on 15/4/21.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYFriendGroupModel.h"

@implementation JYFriendGroupModel

+ (JYFriendGroupModel *)groupModelWithDataArr:(NSArray *)dataArr{
    JYFriendGroupModel *model = [[JYFriendGroupModel alloc] init];
    [model setGroup_id:[NSString stringWithFormat:@"%@",dataArr[0]]];
    [model setGroup_name:dataArr[1]];
    [model setMember_nums:[NSString stringWithFormat:@"%@",dataArr[2]]];
    [model setSelected:NO];
    return model;
}
- (NSDictionary *)attributeMapDictionary{
    NSDictionary *mapAtt = @{@"group_id":@"group_id",
                             @"group_name":@"group_name",
                             @"member_nums":@"member_nums"
                             };
    return mapAtt;
}
@end
