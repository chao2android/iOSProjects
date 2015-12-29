//
//  JYFindController.m
//  friendJY
//
//  Created by 高斌 on 15/3/9.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYFindController.h"
#import "JYAddFriendController.h"
#import "JYFindFirendController.h"
#import "JYManageFirendController.h"
#import "JYHttpServeice.h"
#import "JYManageFriendData.h"
#import "JYAppDelegate.h"

@interface JYFindController ()
{
//    NSInteger friendNum;//一度好友数量
//    NSInteger fsfriendNum;//二度好友数量
}
@end

@implementation JYFindController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"发现"];
        
    }
    
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getNumOfFriend];
//    UITableViewCell *cell =  [_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
//    UILabel *countLab = (UILabel*)[cell.contentView viewWithTag:102];
//    [countLab setText:[NSString stringWithFormat:@"(%ld)",(long)[JYManageFriendData sharedInstance].friendNums]];
//    
//    UITableViewCell *cell00 =  [_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
//    UILabel *countLab00 = (UILabel*)[cell00.contentView viewWithTag:102];
//    [countLab00 setText:[NSString stringWithFormat:@"(%ld)",(long)[JYManageFriendData sharedInstance].fsFriendNums]];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableView];
}
- (void)initTableView{
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    [_table setRowHeight:44];
    //    [_table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_table setDelegate:self];
    [_table setScrollEnabled:NO];
    [_table setDataSource:self];
    [_table setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_table];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(-1, 0, kScreenWidth + 2, 34)];
    headerView.layer.borderWidth = 1;
    headerView.layer.borderColor = [[JYHelpers setFontColorWithString:@"#cccccc"] CGColor];
    headerView.backgroundColor = [UIColor clearColor];
    _table.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] init];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, -1, kScreenWidth, 1)];
    line.layer.borderColor = [[JYHelpers setFontColorWithString:@"#cccccc"] CGColor];
    line.layer.borderWidth = 1;
    [footerView addSubview:line];
    [footerView setBackgroundColor:[UIColor clearColor]];
    _table.tableFooterView = footerView;
    
}
//获取一度二度好友数量
- (void)getNumOfFriend{
//    this->uid - 自己UID
//    this->is_myfriends - 1:获取1度;2:获取2度
//    this->is_reg - 是否已注册 1：已注册(默认1);0：未注册
//    这是获取1度好友  还需要获取二度好友数量。。。 需要发送两个请求？！
//    [self showProgressHUD:@"加载中..." toView:self.view];
    NSDictionary *paraDic = @{@"mod":@"friends",
                              @"func":@"friends_get_friendsnums"
                              };
    NSString *uid = ToString([[NSUserDefaults standardUserDefaults] stringForKey:@"uid"]);
    NSDictionary *postDic = @{@"uid":uid,
                              @"is_myfriends":@"1",
                              @"is_reg":@"1"
                              };
//    获取一度好友数量
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            NSLog(@"获取成功")
            NSInteger num = [JYHelpers integerValueOfAString:[responseObject objectForKey:@"data"]];
            [self didGetFriendNum:num andIsClose:YES];
//            [self dismissProgressHUDtoView:self.view];
        }else{
            NSLog(@"获取失败");
        }
            
    } failure:^(id error) {
//        [self dismissProgressHUDtoView:self.view];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];
    
    NSDictionary *postDict = @{@"uid":uid,
                               @"is_myfriends":@"2",
                               @"is_reg":@"1"
                               };
    //获取二度好友数量
    [JYHttpServeice requestWithParameters:paraDic postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            NSLog(@"获取成功")
            NSInteger num = [[responseObject objectForKey:@"data"] integerValue];
            [self didGetFriendNum:num andIsClose:NO];
        }else{
            NSLog(@"获取失败");
        }
        
    } failure:^(id error) {
        [self dismissProgressHUDtoView:self.view];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];
}
//成功获取好友数量刷新UI
- (void)didGetFriendNum:(NSInteger)num andIsClose:(BOOL)isClose{
    NSInteger index;
    if (isClose) {//一度
        index = 2;
        [[JYManageFriendData sharedInstance] setFriendNums:num];
    }else{//二度
        index = 1;
        [[JYManageFriendData sharedInstance] setFsFriendNums:num];
    }
    UITableViewCell *cell =  [_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    UILabel *countLab = (UILabel*)[cell.contentView viewWithTag:102];
    [countLab setText:[NSString stringWithFormat:@"(%ld)",(long)num]];
}
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 6, 30, 30)];
        [iconImage setTag:100];
//        [iconImage setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView addSubview:iconImage];
        NSString *text = @"管理 一度好友";
        CGFloat width = [text sizeWithFont:[UIFont systemFontOfSize:15.0f]].width;
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(iconImage.right+10, 12, width, 20)];
//        [titleLab setBackgroundColor:[UIColor lightGrayColor]];
        [titleLab setFont:[UIFont systemFontOfSize:15.0f]];
        [titleLab setTextColor:[UIColor blackColor]];
        [titleLab setTextAlignment:NSTextAlignmentLeft];
        [titleLab setTag:101];
        [cell.contentView addSubview:titleLab];
        
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLab.right + 5, 12, 80, 20)];
        [countLabel setTextAlignment:NSTextAlignmentLeft];
        [countLabel setTextColor:[JYHelpers setFontColorWithString:@"#848484"]];
        [countLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [countLabel setTag:102];
        [cell.contentView addSubview:countLabel];
    }
    
    UIImageView *iconImage = (UIImageView *)[cell.contentView viewWithTag:100];
    UILabel *titleLab = (UILabel *)[cell.contentView viewWithTag:101];
//    UILabel *countLabel = (UILabel*)[cell.contentView viewWithTag:102];
    switch (indexPath.row) {
        case 0:
        {
            [titleLab setText:@"添加好友"];
            [iconImage setImage:[UIImage imageNamed:@"find_add_friends"]];
        }
            break;
        case 1:
        {
            [titleLab setText:@"发现 二度好友"];
            [iconImage setImage:[UIImage imageNamed:@"find_friend_type_two"]];
//            [countLabel setText:@"(1834)"];
        }
            break;
        case 2:
        {
            [titleLab setText:@"管理 一度好友"];
            [iconImage setImage:[UIImage imageNamed:@"find_friend_type_one"]];
//            [countLabel setText:@"(123)"];
        }
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    switch (indexPath.row) {
        case 0:
        {
            JYAddFriendController *addFriendController = [[JYAddFriendController alloc] init];
            [self.navigationController pushViewController:addFriendController animated:YES];
        }
            break;
        case 1:
        {
            JYFindFirendController *findFirendController = [[JYFindFirendController alloc] init];
            [self.navigationController pushViewController:findFirendController animated:YES];
        }
            break;
        case 2:
        {
            JYManageFirendController *manageFirendController = [[JYManageFirendController alloc] init];
            manageFirendController.type = JYFriendManageTypeManage;
            [self.navigationController pushViewController:manageFirendController animated:YES];
        }
            break;
            
        default:
            break;
    }
}


@end
