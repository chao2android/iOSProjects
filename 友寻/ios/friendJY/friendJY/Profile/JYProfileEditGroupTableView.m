//
//  JYProfileEditGroupTableView.m
//  friendJY
//
//  Created by chenxiangjing on 15/5/5.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYProfileEditGroupTableView.h"
#import "JYProfileEditGroupCell.h"
#import "JYGroupModel.h"

#define JYProfileEditGroupCellID @"JYProfileEditGroupCellID"
@implementation JYProfileEditGroupTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self setDelegate:self];
        [self setDataSource:self];
        [self registerClass:[JYProfileEditGroupCell class] forCellReuseIdentifier:JYProfileEditGroupCellID];
        [self setBackgroundColor:[UIColor clearColor]];
        _hasEdit = NO;
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 29)];
        [headerView setBackgroundColor:[UIColor clearColor]];
        [self setTableHeaderView:headerView];
        
        UIView *footerView = [[ UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, kScreenWidth - 30, 40)];
        [label setText:@"取消勾选后，群组将不会在资料页进行展示。"];
        [label setTextColor:kTextColorGray];
        [label setFont:[UIFont systemFontOfSize:14]];
        [label setBackgroundColor:[UIColor clearColor]];
        [footerView addSubview:label];
        
        [footerView setBackgroundColor:[UIColor clearColor]];
        [self setTableHeaderView:footerView];
        
    }
    return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JYProfileEditGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:JYProfileEditGroupCellID];
    if (cell == nil) {
        cell = [[JYProfileEditGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JYProfileEditGroupCellID];
    }
//    if (indexPath.row == _dataArr.count) {
//        [cell.groupNameLabel setText:@"取消勾选后，群组将不会在资料页进行展示"];
//        [cell setBackgroundColor:[UIColor clearColor]];
//        [cell.selectedView setHidden:YES];
//    }else{
        [cell relayoutSubviewsWithData:_dataArr[indexPath.row]];
//    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    _hasEdit = YES;
    JYProfileEditGroupCell *cell = (JYProfileEditGroupCell*)[tableView cellForRowAtIndexPath:indexPath];
    
//    cell.selectedView.hidden = !cell.selectedView.hidden;
    
    JYGroupModel *model = (JYGroupModel*)[_dataArr objectAtIndex:indexPath.row];
    if ([self.editDelegate respondsToSelector:@selector(requestChangeGroupInfoWithDataModel:inCell:)]) {
        [self.editDelegate requestChangeGroupInfoWithDataModel:model inCell:cell];
    }
//    [self requestChangeGroupInfoWithDataModel:model inCell:cell];
}
//- (void)requestChangeGroupInfoWithDataModel:(JYGroupModel*)model inCell:(JYProfileEditGroupCell*)cell{
//    NSString *show = @"0";
//    if ([model.show isEqualToString:@"0"]) {
//        show = @"1";
//    }
//
//    NSDictionary *paraDic = @{@"mod":@"chat",
//                              @"func":@"update_user_group_show"
//                              };
//    NSDictionary *postDic = @{@"uid":ToString([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]),
//                              @"group_id":model.group_id,
//                              @"show":show
//                             };
//    
//    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
//        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
//        if (iRetcode == 1) {
//            //do any addtion here...
//            NSInteger result = [[[responseObject objectForKey:@"data"] objectForKey:@"result"] integerValue];
////            'result' 1 群组关闭 2 修改成功
//
//            if (result == 1) {
//                [[JYAppDelegate sharedAppDelegate] showTip:@"群主已经修改群组状态为不公开，修改失败"];
//            }else if (result == 2){//成功
//                
//                if ([model.show isEqualToString:@"0"]) {
//                    [model setShow:@"1"];
//                    [cell.selectedView setHidden:YES];
//                }else{
//                    [model setShow:@"0"];
//                    [cell.selectedView setHidden:NO];
//                    
//                }
//            }
//        }
//    } failure:^(id error) {
//        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
//    }];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
