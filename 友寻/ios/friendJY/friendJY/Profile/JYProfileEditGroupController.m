//
//  JYProfileEditGroupController.m
//  friendJY
//
//  Created by chenxiangjing on 15/5/5.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYProfileEditGroupController.h"
#import "JYProfileEditGroupTableView.h"
#import "JYGroupModel.h"
#import "JYHttpServeice.h"
#import "JYProfileEditGroupCell.h"

@interface JYProfileEditGroupController ()<JYProfileEditGroupTableViewDelegate>
{
    JYProfileEditGroupTableView *tableView;
}
@end

@implementation JYProfileEditGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"群组"];
    // Do any additional setup after loading the view.
    [self initSubviews];
}
- (void)backAction{
    if (tableView.hasEdit) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshProfileInfoNotification object:nil];
    }
    [super backAction];
}
#pragma mark - init subviews
- (void)initSubviews{
    tableView = [[JYProfileEditGroupTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight-kStatusBarHeight) style:UITableViewStylePlain];
    [tableView setDataArr:_groupList];
    [tableView setEditDelegate:self];
    [tableView setTableFooterView:[[UIView alloc] init]];
    [self.view addSubview:tableView];
}
#pragma mark - delegate
- (void)requestChangeGroupInfoWithDataModel:(JYGroupModel *)model inCell:(JYProfileEditGroupCell *)cell{
    NSString *show = @"0";
    if ([model.show isEqualToString:@"0"]) {
        show = @"1";
    }
    [self showProgressHUD:@"加载中..." toView:self.view];
    NSDictionary *paraDic = @{@"mod":@"chat",
                              @"func":@"update_user_group_show"
                              };
    NSDictionary *postDic = @{@"uid":ToString([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]),
                              @"group_id":model.group_id,
                              @"show":show
                              };
    
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        [self dismissProgressHUDtoView:self.view];
        if (iRetcode == 1) {
            //do any addtion here...
            NSInteger result = [[[responseObject objectForKey:@"data"] objectForKey:@"result"] integerValue];
            //            'result' 1 群组关闭 2 修改成功
            
            if (result == 1) {
                [[JYAppDelegate sharedAppDelegate] showTip:@"群主已经修改群组状态为不公开，修改失败"];
            }else if (result == 2){//成功
                
                if ([model.show isEqualToString:@"0"]) {
                    [model setShow:@"1"];
                    [cell.selectedView setHidden:YES];
                }else{
                    [model setShow:@"0"];
                    [cell.selectedView setHidden:NO];
                    
                }
            }
        }
    } failure:^(id error) {
        [self dismissProgressHUDtoView:self.view];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];


}
//#pragma mark - Delegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    JYGroupModel *group = (JYGroupModel*)[_groupList objectAtIndex:indexPath.row];
//    [self requestChangeGroupInfoWithDataModel:group];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
