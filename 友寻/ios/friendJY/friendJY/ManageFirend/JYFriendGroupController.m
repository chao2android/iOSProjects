//
//  JYFriendGroupController.m
//  friendJY
//
//  Created by 高斌 on 15/3/12.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYFriendGroupController.h"
//#import "JYSelectFriendController.h"
#import "JYNavigationController.h"
#import "JYSaveGroupController.h"
#import "JYHttpServeice.h"
#import "JYAppDelegate.h"
#import "JYFriendGroupModel.h"
#import "JYManageFriendData.h"

@interface JYFriendGroupController ()
//分组信息
//@property (nonatomic, strong) NSMutableArray *groupList;

@end

@implementation JYFriendGroupController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"好友分组"];
    }

    return self;
}

- (void)backAction{
    [super backAction];
    if (self.backBlock) {
        self.backBlock();
    }
}
- (void)setGroupList:(NSMutableArray *)groupList{
    if (_groupList == nil) {
        _groupList = [NSMutableArray arrayWithArray:groupList];
    }
}
//每一次当视图将要显示的时候刷新一下 组列表
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([[[JYManageFriendData sharedInstance] groupListArr] count] > 0) {
        _groupList = [NSMutableArray arrayWithArray:[[JYManageFriendData sharedInstance] groupListArr]];
        [_noGroupBg setHidden:YES];
        [_table reloadData];
    }else{
        [_groupList removeAllObjects];
        [_noGroupBg setHidden:NO];
        [_table reloadData];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutSubviews];

}
- (void)layoutSubviews{
    UIButton *createGroupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [createGroupBtn setFrame:CGRectMake(0, 0, 65, 44)];
    [createGroupBtn setTitle:@"创建" forState:UIControlStateNormal];
    [createGroupBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [createGroupBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
    [createGroupBtn setTitleColor:kTextColorBlue forState:UIControlStateNormal];
    [createGroupBtn addTarget:self action:@selector(createBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:createGroupBtn]];
     
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavigationBarHeight) style:UITableViewStylePlain];
    [_table setRowHeight:44];
    //    [_table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_table setDelegate:self];
    [_table setDataSource:self];
    [self.view addSubview:_table];
    [_table setBackgroundColor:[UIColor clearColor]];
    [_table setTableFooterView:[[UIView alloc] init]];
    
    //没有分组
    _noGroupBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavigationBarHeight)];
    [_noGroupBg setUserInteractionEnabled:YES];
    [_noGroupBg setBackgroundColor:[UIColor clearColor]];
//    [_noGroupBg setBackgroundColor:[JYHelpers setFontColorWithString:@"#FFFFFF"]];
    [self.view addSubview:_noGroupBg];
    
    UILabel *promptLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 87, kScreenWidth - 30, 20*self.autoSizeScaleY)];
    [promptLab setText:@"你还没有添加任何分组"];
    [promptLab setFont:[UIFont systemFontOfSize:15.0f]];
    [promptLab setTextAlignment:NSTextAlignmentCenter];
    [promptLab setTextColor:kTextColorGray];
    [_noGroupBg addSubview:promptLab];
    
    _createGroupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_createGroupBtn setFrame:CGRectMake(15, promptLab.bottom+75, kScreenWidth-30, 40)];
//    [_createGroupBtn setCenter:_noGroupBg.center];
//    [_createGroupBtn setBackgroundColor:[JYHelpers setFontColorWithString:@"#DDDDDD"]];
    [_createGroupBtn setBackgroundImage:[UIImage imageNamed:@"check_nomal"] forState:UIControlStateNormal];
    [_createGroupBtn setTitle:@"创建分组" forState:UIControlStateNormal];
    [_createGroupBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [_createGroupBtn addTarget:self action:@selector(createBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_noGroupBg addSubview:_createGroupBtn];
    
}
#pragma mark - 点击事件
- (void)createBtnClick
{
    NSLog(@"创建分组");
    
    JYManageFirendController *manageController = [[JYManageFirendController alloc] init];
    [manageController setType:JYFriendManageTypeSelect];
    [self.navigationController pushViewController:manageController animated:YES];
    
//    JYSaveGroupController *saveGroupController = [[JYSaveGroupController alloc] init];
//    [saveGroupController setGroupEditType:JYFriendGroupEditTypeCreate];
//    [self.navigationController pushViewController:saveGroupController animated:YES];

}
#pragma mark - 删除好友分组的请求
- (void)removeGroupWithData:(JYFriendGroupModel*)groupModel{
//    [[JYManageFriendData sharedInstance] removeAGroupWithGroupID:groupModel.group_id];
    [[JYManageFriendData sharedInstance] removeAGroupInSever:groupModel.group_id];

//    [self showProgressHUD:@"正在删除" toView:self.view];
//    NSDictionary *paraDic = @{
//                              @"mod":@"friends",
//                              @"func":@"friends_del_group"
//                              };
//    NSDictionary *postDic = @{
//                              @"uid":ToString([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]),
//                              @"group_id":groupModel.group_id
//                              };
//    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
//        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
//        if (iRetcode == 1) {
//            [[JYAppDelegate sharedAppDelegate] showTip:@"删除成功"];
//            [self dismissProgressHUDtoView:self.view];
//        }
//    } failure:^(id error) {
//        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
//        [self dismissProgressHUDtoView:self.view];
//    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_groupList count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendGroupCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"friendGroupCell"];
//        [cell.textLabel setFont:[UIFont systemFontOfSize:15.0f]];
        
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
        [nameLab setFont:[UIFont systemFontOfSize:15]];
        [nameLab setTextColor:kTextColorBlack];
        [nameLab setLineBreakMode:NSLineBreakByTruncatingTail];
        [nameLab setTag:111];
        [cell.contentView addSubview:nameLab];
        
        UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectZero];
        [numLab setFont:[UIFont systemFontOfSize:15]];
        [numLab setTextColor:kTextColorBlack];
        [numLab setLineBreakMode:NSLineBreakByTruncatingTail];
        [numLab setTag:222];
        [cell.contentView addSubview:numLab];


    }
    UILabel *nameLab = (UILabel*)[cell.contentView viewWithTag:111];
    UILabel *numLab = (UILabel*)[cell.contentView viewWithTag:222];

    JYFriendGroupModel *groupModel = _groupList[indexPath.row];
    NSString *nameStr = ToString(groupModel.group_name);
    NSString *numStr = [NSString stringWithFormat:@"(%@)",groupModel.member_nums];
    CGFloat nameWidth = [JYHelpers getTextWidthAndHeight:nameStr fontSize:15].width;
    CGFloat numWidth = [JYHelpers getTextWidthAndHeight:numStr fontSize:15].width;
    
    if (numWidth+nameWidth+30 > kScreenWidth) {
        [numLab setFrame:CGRectMake(kScreenWidth - 15 - numWidth, 0, numWidth, cell.height)];
        [nameLab setFrame:CGRectMake(15, 0, numLab.left - 15, cell.height)];
    }else{
        [nameLab setFrame:CGRectMake(15, 0, nameWidth, cell.height)];
        [numLab setFrame:CGRectMake(nameLab.right, 0, numWidth, nameLab.height)];
    }
    [nameLab setText:nameStr];
    [numLab setText:numStr];
//    NSString *text = [NSString stringWithFormat:@"%@ (%@)",groupModel.group_name,groupModel.member_nums];
//    [cell.textLabel setText:text];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

#pragma mark - UITableViewDelegate
//进入分组详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
    JYSaveGroupController *groupVC = [[JYSaveGroupController alloc] init];
    [groupVC setGroupEditType:JYFriendGroupEditTypeEdit];
    [groupVC setGroupInfo:self.groupList[indexPath.row]];
    [self.navigationController pushViewController:groupVC animated:YES];
}
//设置编辑模式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
//处理编辑事件
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger index = indexPath.row;
        JYFriendGroupModel *groupModel = [_groupList objectAtIndex:index];
        [_groupList removeObjectAtIndex:index];
        if (_groupList.count == 0) {
            [_noGroupBg setHidden:NO];
        }
        [_table reloadData];
        [self removeGroupWithData:groupModel];
    }
}
//设置删除编辑模式下 btn 的title
- (NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
//默认yes 可写可不写
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//    return YES;
//}
@end
