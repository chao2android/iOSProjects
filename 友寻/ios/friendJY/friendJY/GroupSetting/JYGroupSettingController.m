//
//  JYGroupSettingController.m
//  friendJY
//
//  Created by 高斌 on 15/4/16.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYGroupSettingController.h"
#import "JYHttpServeice.h"
#import "JYShareData.h"
#import "JYGroupNameController.h"
#import "JYGroupIntroController.h"
#import "JYGroupPrivilegeController.h"
#import "JYAppDelegate.h"
#import "JYCreatGroupController.h"
#import "JYMyGroupController.h"
#import "JYChatDataBase.h"
#import "JYShareData.h"
#import "JYMessageModel.h"
#import "JYGroupMemberViewController.h"
#import "UIImageView+WebCache.h"
#import "JYCreatGroupFriendModel.h"
#import "JYGroupMemberShowView.h"
#import "JYGroupMemberManager.h"

@interface JYGroupSettingController ()

@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *introLab;
@property (nonatomic, strong) UILabel *privilegeLab;
@property (nonatomic, strong) UILabel *countLab;
@property (nonatomic, strong) UILabel *statusLab;
@property (nonatomic, strong) UILabel *hintLab;
@property (nonatomic, strong) UILabel *showLab;
@property (nonatomic, strong) UISwitch *statusSwitch;
@property (nonatomic, strong) UISwitch *nickSwitch;
@property (nonatomic, strong) UISwitch *hintSwitch;
@property (nonatomic, strong) UISwitch *showSwitch;

@property (nonatomic, strong) JYGroupMemberShowView *ShowMembreView;

@end

@implementation JYGroupSettingController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"群组设置"];
        
        [self setGroupPrivilegeList:[[JYShareData sharedInstance].profile_dict objectForKey:@"group_privilege"]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _imageArr = [NSMutableArray array];

    UIScrollView * groupList = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTabBarViewHeight)];
    groupList.backgroundColor = [UIColor clearColor];
    groupList.scrollEnabled = YES;
    [self.view addSubview:groupList];
    
    for (int i=0; i<8; i++) {
        
        CGFloat height = i<3?(34+i*44):(68+i*44);
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, height, kScreenWidth, 44)];
        [bgView setTag:100+i];
        bgView.clipsToBounds = YES;
        [bgView setUserInteractionEnabled:YES];
        [bgView setBackgroundColor:kTextColorWhite];
        [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewTap:)]];
        [groupList addSubview:bgView];
        
        UILabel *nameTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 13, 65, 18)];
        [nameTitleLab setFont:[UIFont systemFontOfSize:16.0f]];
        [nameTitleLab setTextColor:kTextColorGray];
        [nameTitleLab setBackgroundColor:[UIColor clearColor]];
        [bgView addSubview:nameTitleLab];
        
        UILabel *detailLab = [[UILabel alloc] initWithFrame:CGRectMake(nameTitleLab.right+20, 14, kScreenWidth-15-nameTitleLab.width-20-80, 16)];
        [detailLab setFont:[UIFont systemFontOfSize:14.0f]];
        [detailLab setTextColor:kTextColorBlack];
        [detailLab setBackgroundColor:[UIColor clearColor]];
        [bgView addSubview:detailLab];
        
        if (i<3) {
            [detailLab setFont:[UIFont systemFontOfSize:12]];
        }
        
        if (i>3) {
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            [switchView setOrigin:CGPointMake(kScreenWidth-65, 6)];
            [switchView setTag:1000+i];
            [switchView addTarget:self action:@selector(switchViewChanged:) forControlEvents:UIControlEventValueChanged];
            [bgView addSubview:switchView];
            
            switch (i) {
                case 4:
                {
                    [self setStatusSwitch:switchView];
                }
                    break;
                case 5:
                {
                    [self setNickSwitch:switchView];
                }
                    break;
                case 6:
                {
                    [self setHintSwitch:switchView];
                }
                    break;
                case 7:
                {
                    [self setShowSwitch:switchView];
                }
                    break;
                default:
                    break;
            }
        } else {
            
            UIImageView *moreIcon = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-15-8, 15.5, 8, 13)];
            [moreIcon setImage:[UIImage imageNamed:@"find_more.png"]];
            [bgView addSubview:moreIcon];
        }
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(15, bgView.height-1, kScreenWidth-15, 1)];
        [line setBackgroundColor:kBorderColorGray];
        [bgView addSubview:line];
        
        switch (i) {
            case 0:
            {
                [nameTitleLab setText:@"群组成员"];
                [self setCountLab:detailLab];
                [_countLab setText:[NSString stringWithFormat:@"%@人", self.groupModel.total]];
                
                //加一个显示头像的view
                _ShowMembreView = [[JYGroupMemberShowView alloc]initWithFrame:CGRectMake(detailLab.left+40, 0, kScreenWidth-detailLab.left-40-23, 44)];
                _ShowMembreView.backgroundColor = [UIColor clearColor];
                [bgView addSubview:_ShowMembreView];
            }
                break;
            case 1:
            {
                [nameTitleLab setText:@"群组名称"];
                [detailLab setText:self.groupModel.title];
                [self setNameLab:detailLab];
            }
                break;
            case 2:
            {
                [nameTitleLab setText:@"群组简介"];
                [detailLab setText:self.groupModel.intro];
                [self setIntroLab:detailLab];
            }
                break;
            case 3:
            {
                [nameTitleLab setText:@"权限设置"];
                [self setPrivilegeLab:detailLab];
            }
                break;
            
            case 4:
            {
                [nameTitleLab setText:@"群组状态"];
                [self setStatusLab:detailLab];
                [_statusLab setText:@"公开(将被推荐给好友)"];
            }
                break;
            case 5:
            {
                [nameTitleLab setText:@"显示昵称"];
                [self setStatusLab:detailLab];
                [_statusLab setText:@"群聊显示昵称"];
            }
                break;
            case 6:
            {
                [nameTitleLab setText:@"消息提醒"];
                [self setHintLab:detailLab];
                [_hintLab setText:@"消息免打扰"];
            }
                break;
            case 7:
            {
                [nameTitleLab setText:@"是否展示"];
                [self setShowLab:detailLab];
                [_showLab setText:@"在资料页展示给其他人"];
            }
                break;
            default:
                break;
        }

    }
    
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    exitBtn.tag = 110;
    [exitBtn setFrame:CGRectMake(15, 34+2*44+34+6*44+34, kScreenWidth-30, 60)];
    [exitBtn setBackgroundColor:kTextColorWhite];
    [exitBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [exitBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [exitBtn setTitle:@"退出群组" forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(exitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [groupList addSubview:exitBtn];
    
    groupList.contentSize = CGSizeMake(kScreenWidth, exitBtn.bottom + 20);
    [self requestGetGroupUserList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadData];
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

- (void)bgViewTap:(UITapGestureRecognizer *)tap
{
    NSInteger index = tap.view.tag-100;
    
    switch (index) {
        case 0:
        {
            JYGroupMemberViewController *controller = [[JYGroupMemberViewController alloc] init];
            controller.memberData = [_groupInfoModel.userlist mutableCopy];
            controller.groupId = self.groupModel.group_id;
            controller.isMy = _isMyGroup;
            controller.addFinishBlock = ^(NSArray *haveJionUsers){
                //刷新我的群组列表的头像
                [_imageArr removeAllObjects];
                NSMutableArray *mImageArray = [[NSMutableArray alloc]initWithArray:haveJionUsers];
                [mImageArray addObjectsFromArray:_groupInfoModel.userlist];
                if (mImageArray.count > 0) {
                    for (int i = 0; i< (mImageArray.count>4?4:mImageArray.count); i++) {
                        
                        if ([[mImageArray objectAtIndex:i] objectForKey:@"uid"]) {
                            NSDictionary * temp = [[mImageArray objectAtIndex:i] objectForKey:@"avatars"] ;
                            if(![JYHelpers isEmptyOfString:[temp objectForKey:@"150"]]){
                                UIImageView * iv = [[UIImageView alloc] init];
                                iv.clipsToBounds = YES;
                                [iv sd_setImageWithURL:[NSURL URLWithString:[temp objectForKey:@"150"]]];
                                [_imageArr addObject:iv];
                            }
                        }
                    }
                }
                //发出一个通知 更新我的群组列表头像
                UIImage * groupImg = [self imageMergeToNewOne];
                [[NSNotificationCenter defaultCenter] postNotificationName:kGroupSettingRefreshAvatarNotification object:groupImg];
                [self uploadAddUserGroupAvatar];
                
                //别刷新了，  重新下载数据吧
                [self performSelector:@selector(requestGetGroupUserList) withObject:nil afterDelay:2];
            };
            controller.deleFinishBlock = ^(JYCreatGroupFriendModel *model){
                //1.刷新人数
                [self RefreshCountLab:(-1)];
                //2.去除数据源
                for (int i = 0; i<_groupInfoModel.userlist.count; i++) {
                    NSDictionary *dict = [_groupInfoModel.userlist objectAtIndex:i];
                    if ([dict[@"uid"] intValue] == [model.uid intValue]) {
                        [_groupInfoModel.userlist removeObjectAtIndex:i];
                        break;
                    }
                }
                
                //3.刷新头像
                //把列表中头像取出来,但不包括自已
                
                [_ShowMembreView LoadContent:_groupInfoModel.userlist];
                
                [_imageArr removeAllObjects];
                if (_groupInfoModel.userlist.count > 0) {
                    for (int i = 0; i< (_groupInfoModel.userlist.count>4?4:_groupInfoModel.userlist.count); i++) {
                        
                        if ([[_groupInfoModel.userlist objectAtIndex:i] objectForKey:@"uid"]) {
                            NSDictionary * temp = [[_groupInfoModel.userlist objectAtIndex:i] objectForKey:@"avatars"] ;
                            if(![JYHelpers isEmptyOfString:[temp objectForKey:@"150"]]){
                                UIImageView * iv = [[UIImageView alloc] init];
                                iv.clipsToBounds = YES;
                                [iv sd_setImageWithURL:[NSURL URLWithString:[temp objectForKey:@"150"]]];
                                [_imageArr addObject:iv];
                            }
                        }
                    }
                }
                //发出一个通知 更新我的群组列表头像
                UIImage * groupImg = [self imageMergeToNewOne];
                [[NSNotificationCenter defaultCenter] postNotificationName:kGroupSettingRefreshAvatarNotification object:groupImg];
                
                [self uploadAddUserGroupAvatar];
            };
            
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 1:
        {
            JYGroupNameController *controller = [[JYGroupNameController alloc] init];
            controller.infoModel = _groupInfoModel;
            controller.groupModel = _groupModel;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 2:
        {
            JYGroupIntroController *controller = [[JYGroupIntroController alloc] init];
            controller.infoModel = _groupInfoModel;
            controller.groupModel = _groupModel;
            controller.finishBlick = ^(NSString *content){
                _introLab.text = content;
            };
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 3:
        {
            JYGroupPrivilegeController *controller = [[JYGroupPrivilegeController alloc] init];
            controller.infoModel = _groupInfoModel;
            controller.groupModel = _groupModel;
            controller.privilegeList = self.groupPrivilegeList;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        
        case 4:
        {
            
        }
            break;
        case 5:
        {
            
        }
            break;
        case 6:
        {
            
        }
            break;
        default:
            break;
    }
}

-(void)RefreshHeaderImage:(NSMutableArray *)haveJionUsers{
    if (_imageArr.count>=4) {
        return;
    }
    
    for (int i = 0; i< haveJionUsers.count; i++) {
        JYCreatGroupFriendModel * temp = [haveJionUsers objectAtIndex:i];
        if(![JYHelpers isEmptyOfString:temp.avatar]){
            UIImageView * iv = [[UIImageView alloc] init];
            iv.clipsToBounds = YES;
            iv.image = temp.image;
            [_imageArr addObject:iv];
        }
        if (_imageArr.count>=4) {
            break;
        }
    }
    [self uploadAddUserGroupAvatar];
}

- (void)reloadData
{
    if (_groupInfoModel == nil) {
        return;
    }
    NSLog(@"%@",_groupInfoModel.title);
    if ([_groupInfoModel.hint boolValue]) {
        NSLog(@"yes");
        
    }else{
        NSLog(@"no");
    }
    
    NSLog(@"title---%@",_groupInfoModel.title);
    [_nameLab setText:_groupInfoModel.title];
    [_introLab setText:_groupInfoModel.intro];
    [_privilegeLab setText:[self.groupPrivilegeList objectAtIndex:[_groupInfoModel.privilege integerValue]]];
    [_countLab setText:[NSString stringWithFormat:@"%lu人", (unsigned long)_groupInfoModel.userlist.count]];
    [_statusSwitch setOn:[_groupInfoModel.status boolValue] animated:YES];
    [_nickSwitch setOn:![_groupInfoModel.shownick boolValue] animated:YES];
    [_hintSwitch setOn:[_groupInfoModel.hint boolValue] animated:YES];
    [_showSwitch setOn:![_groupInfoModel.show boolValue] animated:YES];
    if ([_groupInfoModel.status intValue] ==0) {
        _showSwitch.enabled = NO;
    }else{
        _showSwitch.enabled = YES;
    }
    
}

- (void)switchViewChanged:(UISwitch *)switchView
{
    NSLog(@"switch changed");
    
    if (switchView.on) {
        NSLog(@"YES");
    } else {
        NSLog(@"NO");
    }
    
    NSLog(@"%ld", switchView.tag-1000);
    
    switch (switchView.tag-1000) {
        case 4:
        {
            //公开(将被推荐给好友) 只有群主能设置
            if(_isMyGroup){
            NSString *status = switchView.on?@"1":@"0";
            [self requestUpdateGroupWithStatus:status];
            }
        }
            break;
        case 5: //接受群组消息
        {
            [self requestShowNickGroupWithSwitchTag:switchView.tag];
        }
            break;
        case 6: //接受群组消息
        {
            [self requestUpdateUserGroupWithSwitchTag:switchView.tag];
        }
            break;
        case 7: //在资料页展示给其他人呢
        {
            [self requestIsShowMsgWithSwitchTag:switchView.tag];
        }
            break;
        default:
            break;
    }
}

- (void)exitBtnClick:(UIButton *)btn
{
    NSLog(@"退出");
    [self requestExitGroup];
}

- (void)refreshTableUI{
    if (!_isMyGroup) {
//        UIView * tempView = [self.view viewWithTag:102];
//        tempView.height = 0;
        
        UIView * tempView3 = [self.view viewWithTag:103];
        tempView3.frame = CGRectZero;
        
        
        UIView * tempView4 = [self.view viewWithTag:104];
        tempView4.top = tempView4.top - 44;
        
        UIView * tempView5 = [self.view viewWithTag:105];
        tempView5.top = tempView5.top - 44;
        
        UIView * tempView6 = [self.view viewWithTag:106];
        tempView6.top = tempView6.top - 44;
        
        UIView * tempView7 = [self.view viewWithTag:107];
        tempView7.top = tempView7.top - 44;
        
        //退出
        UIButton * tempView8 = (UIButton *)[self.view viewWithTag:110];
        tempView8.top = tempView8.top - 44;
        
        //群主是否公开
        UISwitch * tempView9 = (UISwitch *)[self.view viewWithTag:1004];
        tempView9.enabled = NO;
    }
    
}
#pragma mark - request

//获取群组信息
//- (void)requestGetGroup
//{
//    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
//    [parametersDict setObject:@"chat" forKey:@"mod"];
//    [parametersDict setObject:@"get_group" forKey:@"func"];
//    
//    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
//    [postDict setObject:self.groupModel.group_id forKey:@"group_id"];
//    
//    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
//        
//        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
//        if (iRetcode == 1) {
//            
//            _groupInfoModel = [[JYGroupInfoModel alloc] initWithDataDic:[responseObject objectForKey:@"data"]];
//            
//            NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
//            if ([_groupInfoModel.uid isEqualToString:uid]) {
//                _isMyGroup = YES;
//            } else {
//                _isMyGroup = NO;
//            }
//            [self reloadData];
//            
//        } else {
//            
//        }
//        
//    } failure:^(id error) {
//        
//        
//    }];
//}


#pragma -mark 新加入的成员刷新人数
- (void)RefreshCountLab:(int) count{
    int oldNum = [_countLab.text intValue];
    [_countLab setText:[NSString stringWithFormat:@"%d人", oldNum+count]];
}

- (void)requestGetGroupUserList{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"chat" forKey:@"mod"];
    [parametersDict setObject:@"group_user_list" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:self.groupModel.group_id forKey:@"group_id"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            
            _groupInfoModel = [[JYGroupInfoModel alloc] initWithDataDic:[responseObject objectForKey:@"data"]];
            _groupInfoModel.userlist = [[responseObject objectForKey:@"data"][@"userlist"] mutableCopy];
//           排序 时间越大的在前边
            [_groupInfoModel.userlist sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                int time1 = [obj1[@"jointime"] intValue];
                int time2 = [obj2[@"jointime"] intValue];
                
                if (time1>time2) {
                    return NSOrderedAscending;
                }else{
                    return NSOrderedDescending;
                }
            }];
            
            NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
            //把列表中头像取出来,但不包括自已
            if (_groupInfoModel.userlist.count > 0) {
                for (int i = 0; i< (_groupInfoModel.userlist.count>4?4:_groupInfoModel.userlist.count); i++) {
                 
                    if ([[_groupInfoModel.userlist objectAtIndex:i] objectForKey:@"uid"]) {
                        NSDictionary * temp = [[_groupInfoModel.userlist objectAtIndex:i] objectForKey:@"avatars"] ;
                        if(![JYHelpers isEmptyOfString:[temp objectForKey:@"150"]]){
                            UIImageView * iv = [[UIImageView alloc] init];
                            iv.clipsToBounds = YES;
                            [iv sd_setImageWithURL:[NSURL URLWithString:[temp objectForKey:@"150"]]];
                            [_imageArr addObject:iv];
                        }
                    }
                }
            }
            
            //头像显示出来
            [_ShowMembreView LoadContent:_groupInfoModel.userlist];
            
            if ([_groupInfoModel.uid isEqualToString:uid]) {
                _isMyGroup = YES;
            } else {
                _isMyGroup = NO;
            }
            [self refreshTableUI];
            [self reloadData];
            
        } else {
            
        }
        
    } failure:^(id error) {
        
        
    }];
}

#pragma mark - request

//更新群组信息
- (void)requestUpdateGroupWithStatus:(NSString *)status
{
    if (_groupInfoModel == nil) {
        return;
    }
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"chat" forKey:@"mod"];
    [parametersDict setObject:@"update_group_status" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:self.groupModel.group_id forKey:@"group_id"];
    [postDict setObject:status forKey:@"status"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        
        if (iRetcode == 1) {
            
            BOOL result = [[[responseObject objectForKey:@"data"] objectForKey:@"result"] boolValue];
            if (result) {
                //成功
//                [[JYAppDelegate sharedAppDelegate] showTip:@"成功"];
                [_groupInfoModel setStatus:status];
                [self reloadData];
                
            } else {
                //失败
//                [[JYAppDelegate sharedAppDelegate] showTip:@"失败"];
                if ([status isEqualToString:@"1"]) {
                    [_statusSwitch setOn:NO animated:YES];
                } else {
                    [_statusSwitch setOn:YES animated:YES];
                }
            }
            
        } else {
            //失败
//            [[JYAppDelegate sharedAppDelegate] showTip:@"失败"];
            if ([status isEqualToString:@"1"]) {
                [_statusSwitch setOn:NO animated:YES];
            } else {
                [_statusSwitch setOn:YES animated:YES];
            }
        }
        
        
        
    } failure:^(id error) {
        
        //失败
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        if ([status isEqualToString:@"1"]) {
            [_statusSwitch setOn:NO animated:YES];
        } else {
            [_statusSwitch setOn:YES animated:YES];
        }
    }];
}

//群组设置，是否展示
- (void)requestIsShowMsgWithSwitchTag:(NSInteger)tag
{
    if (_groupInfoModel == nil) {
        return;
    }
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"chat" forKey:@"mod"];
    [parametersDict setObject:@"update_user_group_show" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:_groupInfoModel.uid forKey:@"uid"];
    [postDict setObject:self.groupModel.group_id forKey:@"group_id"];
    
    NSString *show = _showSwitch.on?@"0":@"1";
    [postDict setObject:show forKey:@"show"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        NSLog(@"%@", [responseObject objectForKey:@"retmean"]);
        
        if (iRetcode == 1) {
            
            NSString * result = [[responseObject objectForKey:@"data"] objectForKey:@"result"] ;
            if ([result intValue] ==  2) {
                //成功
//                [[JYAppDelegate sharedAppDelegate] showTip:@"成功"];
                [self.groupModel setShow:show];
                [_groupInfoModel setShow:show];
                [self reloadData];
                
            } else if ([result intValue] ==  1){
                [[JYAppDelegate sharedAppDelegate] showTip:@"群主已关闭该功能"];
                UISwitch *switchV = (UISwitch *)[self.view viewWithTag:tag];
                [switchV setOn:NO animated:YES];
            }else {
                //失败
//                [[JYAppDelegate sharedAppDelegate] showTip:@"失败"];
                UISwitch *switchV = (UISwitch *)[self.view viewWithTag:tag];
                [switchV setOn:!switchV.on animated:YES];
            }
            
        } else {
            //失败
//            [[JYAppDelegate sharedAppDelegate] showTip:@"失败"];
            UISwitch *switchV = (UISwitch *)[self.view viewWithTag:tag];
            [switchV setOn:!switchV.on animated:YES];
        }
        
        
        
    } failure:^(id error) {
        
        //失败
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        UISwitch *switchV = (UISwitch *)[self.view viewWithTag:tag];
        [switchV setOn:!switchV.on animated:YES];
    }];
}

//更新群组聊天时是否显示名称
- (void)requestShowNickGroupWithSwitchTag:(NSInteger)tag
{
    if (_groupInfoModel == nil) {
        return;
    }
    NSString *shownick = _nickSwitch.on?@"0":@"1";
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"chat" forKey:@"mod"];
    [parametersDict setObject:@"update_user_group_shownick" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:_groupInfoModel.uid forKey:@"uid"];
    [postDict setObject:self.groupModel.group_id forKey:@"group_id"];
    [postDict setObject:shownick forKey:@"shownick"];
    
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        
        if (iRetcode == 1) {
            
            BOOL result = [[[responseObject objectForKey:@"data"] objectForKey:@"result"] boolValue];
            if (result ) {
                _groupInfoModel.shownick = shownick;
                [self reloadData];
                
            } else {
                //失败
                [[JYAppDelegate sharedAppDelegate] showTip:@"失败"];
                UISwitch *switchV = (UISwitch *)[self.view viewWithTag:tag];
                [switchV setOn:!switchV.on animated:YES];
            }
            
        } else {
            //失败
            [[JYAppDelegate sharedAppDelegate] showTip:@"失败"];
            UISwitch *switchV = (UISwitch *)[self.view viewWithTag:tag];
            [switchV setOn:!switchV.on animated:YES];
        }
        
        
        
    } failure:^(id error) {
        
        //失败
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        UISwitch *switchV = (UISwitch *)[self.view viewWithTag:tag];
        [switchV setOn:!switchV.on animated:YES];
    }];
}


//更新群组信息
- (void)requestUpdateUserGroupWithSwitchTag:(NSInteger)tag
{
    if (_groupInfoModel == nil) {
        return;
    }
    NSString *hint = _hintSwitch.on?@"1":@"0";
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"chat" forKey:@"mod"];
    [parametersDict setObject:@"update_user_group" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:_groupInfoModel.uid forKey:@"uid"];
    [postDict setObject:self.groupModel.group_id forKey:@"group_id"];
    [postDict setObject:hint forKey:@"hint"];

    NSString *show = _showSwitch.on?@"0":@"1";
    [postDict setObject:show forKey:@"show"];

    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        
        if (iRetcode == 1) {
            
            BOOL result = [[[responseObject objectForKey:@"data"] objectForKey:@"result"] boolValue];
            if (result) {
                //成功
//                [[JYAppDelegate sharedAppDelegate] showTip:@"修改成功"];
                [self.groupModel setHint:hint];
                [self.groupModel setShow:show];
                [_groupInfoModel setHint:hint];
                [_groupInfoModel setShow:show];
                [[JYChatDataBase sharedInstance] updateIsShowNum:self.groupModel.group_id is_show_num:hint];
                NSMutableArray * msgList = [JYShareData sharedInstance].messageUserList;
                for (int i = 0; i<msgList.count; i++) {
                    JYMessageModel * temp = (JYMessageModel *) msgList[i];
                    if ([self.groupModel.group_id integerValue] == [temp.group_id integerValue]) {
                        temp.hint = hint;
                        temp.newcount = @"0";
                        break;
                    }
                }
                NSLog(@"%@---",self.groupModel.group_id);
                //数据库也要及时插入数据
//                NSString *hintDB ;
//                hintDB =[hint boolValue]?@"0":@"1" ;
                [[JYChatDataBase sharedInstance] updateGroupUserListHint:self.groupModel.group_id hint:hint];
                
                [self reloadData];
                
            } else {
                //失败
                [[JYAppDelegate sharedAppDelegate] showTip:@"失败"];
                UISwitch *switchV = (UISwitch *)[self.view viewWithTag:tag];
                [switchV setOn:!switchV.on animated:YES];
            }
            
        } else {
            //失败
            [[JYAppDelegate sharedAppDelegate] showTip:@"失败"];
            UISwitch *switchV = (UISwitch *)[self.view viewWithTag:tag];
            [switchV setOn:!switchV.on animated:YES];
        }
        
        
        
    } failure:^(id error) {
        
        //失败
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        UISwitch *switchV = (UISwitch *)[self.view viewWithTag:tag];
        [switchV setOn:!switchV.on animated:YES];
    }];
}

//更新群组信息
- (void)requestExitGroup
{
    if (_groupInfoModel == nil) {
        return;
    }
    [self showProgressHUD:@"数据发送中" toView:self.view];
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"chat" forKey:@"mod"];
    [parametersDict setObject:@"exit_group" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:self.groupModel.group_id forKey:@"group_id"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        [self dismissProgressHUDtoView:self.view];
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        NSInteger iRdata = [[responseObject objectForKey:@"data"] integerValue];
        if (iRetcode == 1 && iRdata == 1) {
            
            //通知接收方是我的群组
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:self.groupModel.group_id, @"group_id",nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kExitGroupSuccessNotification object:nil userInfo:userInfo];
            
            //消息列表如果存在，也做清除
            NSMutableArray * msgList = [JYShareData sharedInstance].messageUserList;
            for (int i = 0 ; i< msgList.count; i++) {
                JYMessageModel * temp = msgList[i];
                if ([temp.group_id integerValue] == [self.groupModel.group_id integerValue]) {
                    [msgList removeObjectAtIndex:i];
                    [[JYChatDataBase sharedInstance] deleteOneGroupUser:self.groupModel.group_id];
                    break;
                }
            }
            
            [self uploadGroupAvatar];
            
           
        } else {
            //失败
            [[JYAppDelegate sharedAppDelegate] showTip:@"不能退出该群组"];
            
        }
        
        
        
    } failure:^(id error) {
        [self dismissProgressHUDtoView:self.view];
        //失败
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        
    }];
    
}

- (void) uploadAddUserGroupAvatar{
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"chat" forKey:@"mod"];
    [parametersDict setObject:@"update_group_pic" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:self.groupModel.group_id forKey:@"group_id"];
    
    UIImage * groupImg = [self imageMergeToNewOne]; //合成头像
    
    NSData *imageData = UIImageJPEGRepresentation(groupImg, 1.0);
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:imageData forKey:@"upload"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict dataDict:dataDict formDict:nil success:^(id responseObject) {
        NSLog(@"%@",responseObject)
    } failure:^(id error) {
        
    }];
}

- (void) uploadGroupAvatar{
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"chat" forKey:@"mod"];
    [parametersDict setObject:@"update_group_pic" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:self.groupModel.group_id forKey:@"group_id"];
    
    UIImage * groupImg = [self imageMergeToNewOne]; //合成头像
    
    NSData *imageData = UIImageJPEGRepresentation(groupImg, 1.0);
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:imageData forKey:@"upload"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict dataDict:dataDict formDict:nil success:^(id responseObject) {
        [self dismissProgressHUDtoView:self.view];
        BOOL isFromChatEnter  = NO;
        for (UIViewController *controller in self.navigationController.viewControllers)
        {
            if ([controller isKindOfClass:[JYMyGroupController class]])
            {
                isFromChatEnter = YES;
                [self.navigationController popToViewController:controller animated:YES];
                break;
            }
        }
        
        if (!isFromChatEnter) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    } failure:^(id error) {
        
    }];
}

//imgarr必须是uimage
-(UIImage *)imageMergeToNewOne{
    NSMutableArray *timgArr = [NSMutableArray array];
    for (int i = 0; i<_imageArr.count; i++) {
        if (_imageArr[i] != nil) {
            UIImageView * temp = _imageArr[i];
            [timgArr addObject:temp.image];
        }
    }
    
    
    UIGraphicsBeginImageContext(CGSizeMake(100, 100)); //合成的图片尺寸为200x200
    
    switch (timgArr.count) {
        case 1:
        {
            // Draw image2
            [timgArr[0] drawInRect:CGRectMake(25, 25, 50, 50)];
        }
            break;
            
        case 2:
        {
            // Draw image1
            [timgArr[0] drawInRect:CGRectMake(3.3, 27.5, 45, 45)];
            
            // Draw image2
            [timgArr[1] drawInRect:CGRectMake(51.6, 27.5, 45, 45)];
        }
            break;
            
        case 3:
        {
            // Draw image1
            [timgArr[0] drawInRect:CGRectMake(27.5, 3.3, 45, 45)];
            
            // Draw image2
            [timgArr[1] drawInRect:CGRectMake(3.3, 51.6, 45, 45)];
            
            // Draw image2
            [timgArr[2] drawInRect:CGRectMake(51.6, 51.6, 45, 45)];
        }
            break;
            
        case 4:
        {
            // Draw image1
            [timgArr[0] drawInRect:CGRectMake(3.3, 3.3, 45, 45)];
            
            // Draw image2
            [timgArr[1] drawInRect:CGRectMake(51.6, 3.3, 45, 45)];
            
            // Draw image1
            [timgArr[2] drawInRect:CGRectMake(3.3, 51.6, 45, 45)];
            
            // Draw image2
            [timgArr[3] drawInRect:CGRectMake(51.6, 51.6, 45, 45)];
        }
            break;
    }
    
    [[UIImage imageNamed:@"bg_create_group_avatar"] drawInRect:CGRectMake(0 , 0, 100, 100)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return  resultingImage;
}

@end
