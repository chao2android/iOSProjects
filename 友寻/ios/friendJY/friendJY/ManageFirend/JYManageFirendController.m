//
//  JYManageFirendController.m
//  friendJY
//
//  Created by 高斌 on 15/3/11.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYManageFirendController.h"
#import "JYFriendGroupController.h"
#import "JYCreatGroupFriendModel.h"
#import "JYHttpServeice.h"
#import "ChineseString.h"
#import "JYManageFriendCell.h"
#import "JYSelectedFriendAvatarView.h"
#import "JYOtherProfileController.h"
#import "JYManageFriendData.h"
#import "JYFriendGroupModel.h"
#import "JYAppDelegate.h"
#import "JYManageMobileFriendCell.h"
#import <MessageUI/MessageUI.h>
#import "JYShareData.h"
#import "JYAddFriendController.h"
#import "JYSaveGroupController.h"
#import "JYShareContentController.h"



@interface JYManageFirendController ()<MFMessageComposeViewControllerDelegate>
{
    UILabel *friendCountLab;
    UIButton *groupBtn;
    NSMutableArray *groupList;
    UILabel *groupLab;
    JYSelectedFriendAvatarView *selectAvatarView;
    NSMutableArray *sourceFriendArr;
    //没有好友时
    UIView *haveNoFriendBg;
}
@end

@implementation JYManageFirendController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"管理一度好友"];
        
//        _friendList = [[NSMutableArray alloc] init];
        _nameList = [[NSMutableArray alloc] init];
        _indexArr = [[NSMutableArray alloc] init];
//        groupList = [[NSMutableArray alloc] init];
        _selectedListArr = [[NSMutableArray alloc] init];
        sourceFriendArr = [NSMutableArray array];
        [sourceFriendArr addObjectsFromArray:[[JYManageFriendData sharedInstance] friendList]];
//        numOfGetMutualNum = 0;
    }
    
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.type == JYFriendManageTypeManage) {
        [groupLab setText:[NSString stringWithFormat:@"好友分组（%ld）",(long)[JYManageFriendData sharedInstance].groupListArr.count]];
    }
//    [_table reloadData];
//    ABNewPersonViewController
    [_friendList removeAllObjects];
    [_friendList addObjectsFromArray:[JYManageFriendData sharedInstance].friendList];
    [self handleFriendsList];
    [self loadFriendDataWithNum:300];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initSubviews];
    [self initHaveNoFriendView];

 
    _friendList = [NSMutableArray array];
    
    if (self.type == JYFriendManageTypeManage) {
        if ([JYManageFriendData sharedInstance].groupListArr.count > 0) {
            NSLog(@"=======================")
            NSLog(@"本地读取好友分组数据！")
            NSLog(@"=======================")
            groupList = [NSMutableArray arrayWithArray:[JYManageFriendData sharedInstance].groupListArr];
        }else{
            NSLog(@"=======================")
            NSLog(@"网络下载好友分组数据！")
            NSLog(@"=======================")
            groupList = [NSMutableArray array];
            [self loadGroupData];
        }
    }
    _selectedListArr = [NSMutableArray array];
        
}
- (void)loadGroupData{

    NSDictionary *paraDic = @{@"mod":@"friends",
                              @"func":@"friends_get_grouplist"
                              };
    NSString *uid = ToString([[NSUserDefaults standardUserDefaults] stringForKey:@"uid"]);
    NSDictionary *postDic = @{@"uid":uid};
  
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            NSArray *dataArr = [responseObject objectForKey:@"data"];
            for (NSArray *arr in dataArr) {
                JYFriendGroupModel *model = [JYFriendGroupModel groupModelWithDataArr:arr];
                [groupList addObject:model];
            }
            [[JYManageFriendData sharedInstance] setGroupListArr:groupList];
            [groupLab setText:[NSString stringWithFormat:@"好友分组（%ld）",(long)groupList.count]];
        }
    } failure:^(id error) {
        [self dismissProgressHUDtoView:self.view];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];

}
//获取一度好友列表
//- (void)getNumOfFriend{
//    [self showProgressHUD:@"加载中..." toView:self.view];
//    NSDictionary *paraDic = @{@"mod":@"friends",
//                              @"func":@"friends_get_friendsnums"
//                              };
//    NSString *uid = ToString([[NSUserDefaults standardUserDefaults] stringForKey:@"uid"]);
//    NSDictionary *postDic = @{@"uid":uid,
//                              @"is_myfriends":@"1",
//                              @"is_reg":@"1"
//                              };
//    //    获取一度好友数量
//    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
//        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
//        if (iRetcode == 1) {
//            NSLog(@"获取成功")
//            NSInteger num = [[responseObject objectForKey:@"data"] integerValue];
//            [self loadFriendDataWithNum:num];
//        }else{
//            NSLog(@"获取失败");
//        }
//        
//    } failure:^(id error) {
//        
//    }];
//}
//获取一度好友列表
- (void)loadFriendDataWithNum:(NSInteger)num{
    
    if (_friendList.count == 0) {
        [self showProgressHUD:@"加载中..." toView:self.view];
    }
    [[JYManageFriendData sharedInstance] loadMyFriendsAllWithNums:num SuccessBlock:^(NSArray *arr) {
        
        [self dismissProgressHUDtoView:self.view];
        [_friendList removeAllObjects];
        [sourceFriendArr removeAllObjects];
        
        [_friendList addObjectsFromArray:[JYManageFriendData sharedInstance].friendList];
        [sourceFriendArr addObjectsFromArray:self.friendList];
        
        [self handleFriendsList];
        
    } failureBlock:^(NSError *error) {
        [self dismissProgressHUDtoView:self.view];
        [haveNoFriendBg setHidden:NO];
    }];
//    [self showProgressHUD:@"加载中..." toView:self.view];
//
//    NSDictionary *paraDic = @{@"mod":@"friends",
//                              @"func":@"friends_get_myfriends_all"
//                              };
//    
//    NSDictionary *postDic = @{@"uid":ToString([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]),
//                              @"start":@"0",
//                              @"nums":[NSString stringWithFormat:@"%ld",(long)num]
//                              };
//    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
//        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
//        [self dismissProgressHUDtoView:self.view];
//        if (iRetcode == 1) {
//            NSLog(@"成功获取一度好友信息")
//            if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
//                NSDictionary *dataDic = [responseObject objectForKey:@"data"];
//                NSMutableArray *mobileFriendArr = [NSMutableArray array];
//                for (NSString *key in dataDic.allKeys) {
//                    if([dataDic[key] count] > 3){
//                        JYCreatGroupFriendModel *model = [[JYCreatGroupFriendModel alloc] initWithDataDic:dataDic[key]];
//                        [model setAvatar:dataDic[key][@"avatars"][@"100"]];
//                        [model setIs_friend:@"1"];
//                        if (![JYHelpers isEmptyOfString:model.friendUid]) {
//                            [_friendList addObject:model];
//                        }
//                    }else{
//                        [mobileFriendArr addObject:dataDic[key]];
//                    }
//                }
//                [[JYManageFriendData sharedInstance] setFriendList:_friendList];
//                [sourceFriendArr removeAllObjects];
//                [sourceFriendArr addObjectsFromArray:[[JYManageFriendData sharedInstance] friendList]];
//                [[JYManageFriendData sharedInstance] setMobileFriendList:mobileFriendArr];
//                [self handleFriendsList];
//            }else if([[responseObject objectForKey:@"data"] isKindOfClass:[NSArray class]]){
//                if (((NSArray*)[responseObject objectForKey:@"data"]).count > 0) {
//                    [[JYManageFriendData sharedInstance] setMobileFriendList:[responseObject objectForKey:@"data"]];
//                    if (_type == JYFriendManageTypeManage) {
//                        [self handleFriendsList];
//                    }else{
//                        [haveNoFriendBg setHidden:NO];
//                    }
//                }else{
//                    [haveNoFriendBg setHidden:NO];
//                }
//            }
//        }
//    } failure:^(id error) {
//        
//        [self dismissProgressHUDtoView:self.view];
//        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
//
//    }];
}
//需要对获取下来的数据进行处理
- (void)removeSameModelInFriendList{
    //选择好友进分组的时候 当好友已经被选择 则不显示
    NSMutableArray *sameArr = [NSMutableArray array];
    for (int i = 0; i < _friendList.count; i++) {
        
        JYCreatGroupFriendModel *friendModel = [_friendList objectAtIndex:i];
        
        for (int j = 0; j < _selectMembers.count; j++) {
            
            JYCreatGroupFriendModel *selectFriendModel = [_selectMembers objectAtIndex:j];
//            NSString *str = [NSString stringWithFormat:@"%@ -- %@",selectFriendModel.nick,friendModel.nick];
//            NSLog(@"%@",str);
            if ([selectFriendModel.friendUid isEqualToString:friendModel.friendUid]) {
//                NSLog(@"%@已删除",friendModel.nick);
                [sameArr addObject:friendModel];
                break;
            }
        }
    }
    
    [_friendList removeObjectsInArray:sameArr];


}
- (void)handleFriendsList
{
    
    //过滤
    if (self.type == JYFriendManageTypeSelect) {
        [self removeSameModelInFriendList];
    }
    //筛选完成之后刷新 好友数量
    [friendCountLab setText:[NSString stringWithFormat:@"共%ld个好友", (long)_friendList.count]];
    
    [_nameList removeAllObjects];
    [_indexArr removeAllObjects];
    
//    NSLog(@"%@",_friendList)
//    NSLog(@"%@",_friendList)
    for (JYCreatGroupFriendModel *friendModel in _friendList)
    {
        [_nameList addObject:friendModel.nick];
    }
    
    [self setIndexArr:[ChineseString indexArray:_nameList]];
    [self setNameList:[ChineseString returnSortChineseArrar:_nameList]];
    [self sortFriendsList];
}

- (void)sortFriendsList
{
    
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    
    NSString *tempStr = @"";
    NSMutableArray *tempList = [[NSMutableArray alloc] init];
    
    for (int i=0; i<_nameList.count; i++) {
        NSString *py = [((ChineseString*)_nameList[i]).pinYin substringToIndex:1];
        NSString *nick = ((ChineseString*)_nameList[i]).string;
        
        if(![tempStr isEqualToString:py]) {
            //不同
            [resultList addObject:tempList];
            
            tempList = [[NSMutableArray alloc] init];
            for (int i=0; i<_friendList.count; i++) {
                
                JYCreatGroupFriendModel *friendModel = _friendList[i];
                if ([[ChineseString RemoveSpecialCharacter:friendModel.nick] isEqualToString:nick])
                {
                    [tempList addObject:friendModel];
                    [_friendList removeObject:friendModel];
                    break;
                }
            }
            
            tempStr = py;
            
        } else {
            
            //相同
            for (int i=0; i<_friendList.count; i++) {
                
                JYCreatGroupFriendModel *friendModel = _friendList[i];
                if ([[ChineseString RemoveSpecialCharacter:friendModel.nick] isEqualToString:nick])
                {
                    [tempList addObject:friendModel];
                    [_friendList removeObject:friendModel];
                    break;
                }
            }
            
            
        }
        
    }
    [resultList addObject:tempList];
    
    [resultList removeObjectAtIndex:0];
    
    [self setFriendList:resultList];
    if (_type == JYFriendManageTypeManage && [[JYManageFriendData sharedInstance] mobileFriendList].count != 0) {
        [_indexArr addObject:@"$"];
        [_friendList addObject:[[JYManageFriendData sharedInstance] mobileFriendList]];
    }
    [_table reloadData];
}
- (void)initHaveNoFriendView{
    
    haveNoFriendBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight)];
    [haveNoFriendBg setBackgroundColor:[JYHelpers setFontColorWithString:@"#edf1f4"]];
    [self.view addSubview:haveNoFriendBg];
    [self.view bringSubviewToFront:haveNoFriendBg];
    [haveNoFriendBg setHidden:YES];
    
    UILabel *noListLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 87, kScreenWidth - 30, 20*self.autoSizeScaleY)];
//    [noListLab setNumberOfLines:2];
    [noListLab setTextColor:kTextColorGray];
    [noListLab setTextAlignment:NSTextAlignmentCenter];
    [noListLab setText:@"你还没有好友，是不是有点寂寞呢？"];
    [noListLab setFont:[UIFont systemFontOfSize:15]];
//    [noListLab setHidden:YES];
    [haveNoFriendBg addSubview:noListLab];
    
    UIButton *addFriendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addFriendBtn setFrame:CGRectMake(15, noListLab.bottom + 75, kScreenWidth - 30, 40)];
    [addFriendBtn setTitle:@"添加好友" forState:UIControlStateNormal];
    [addFriendBtn setBackgroundImage:[UIImage imageNamed:@"login_confirm_btn_available"] forState:UIControlStateNormal];
    [addFriendBtn setBackgroundImage:[UIImage imageNamed:@"login_confirm_btn_unavailable"] forState:UIControlStateDisabled];
    [addFriendBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [addFriendBtn addTarget:self action:@selector(addFriendAction) forControlEvents:UIControlEventTouchUpInside];
    [haveNoFriendBg addSubview:addFriendBtn];
}
- (void)initSubviews{
    //好友分组
    CGFloat bottom = 0;
    if (self.type == JYFriendManageTypeSelect) {
        [self setTitle:@"选择好友"];
    }else{
        groupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //    [groupBtn setBackgroundColor:[JYHelpers setFontColorWithString:@"#EEEEEE"]];
        [groupBtn setFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        [groupBtn.layer setBorderColor:[[JYHelpers setFontColorWithString:@"#cccccc"] CGColor]];
        [groupBtn.layer setBorderWidth:1];
        [groupBtn setBackgroundColor:[UIColor whiteColor]];
        [groupBtn addTarget:self action:@selector(groupBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:groupBtn];
        //    [groupBtn setTitle:@"好友分组" forState:UIControlStateNormal];
        UIImageView *iconImgV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 24, 24)];
        [iconImgV setImage:[UIImage imageNamed:@"find_friend_group"]];
        [iconImgV setUserInteractionEnabled:YES];
        [groupBtn addSubview:iconImgV];
        
        groupLab = [[UILabel alloc] initWithFrame:CGRectMake(iconImgV.right + 10, 10, kScreenWidth - iconImgV.right - 10, 24)];
        [groupLab setText:@"好友分组"];
        [groupLab setTextColor:[JYHelpers setFontColorWithString:@"#2695ff"]];
        [groupBtn addSubview:groupLab];
        
        //分组详情
        UIImageView *more = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 15 - 8, (44.0 - 13.0)/2.0, 8, 13)];
        [more setImage:[UIImage imageNamed:@"find_more"]];
        [groupBtn addSubview:more];
        bottom = groupBtn.bottom;
    }
    //好友数量
    UIImageView *friendCountBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, bottom, kScreenWidth, 40)];
    //    [friendCountBg setBackgroundColor:[JYHelpers setFontColorWithString:@"#DDDDDD"]];
    [friendCountBg setUserInteractionEnabled:YES];
    [friendCountBg setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:friendCountBg];
    
    friendCountLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 24)];
    [friendCountLab setText:@"共0个好友"];
    [friendCountLab setFont:[UIFont systemFontOfSize:15.0f]];
    [friendCountLab setTextColor:[JYHelpers setFontColorWithString:@"#848484"]];
    [friendCountBg addSubview:friendCountLab];
    
    UIView *line_frdBg = [[UIView alloc] initWithFrame:CGRectMake(0, friendCountBg.height - 1, kScreenWidth, 1)];
    [line_frdBg.layer setBorderWidth:1];
    [line_frdBg.layer setBorderColor:[[JYHelpers setFontColorWithString:@"#cccccc"] CGColor]];
    [friendCountBg addSubview:line_frdBg];
    //筛选Btn
    NSString *myStr = @"筛选";
    CGFloat width = [myStr sizeWithFont:[UIFont systemFontOfSize:15.0f]].width;
    UIButton *filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [filterBtn setFrame:CGRectMake(kScreenWidth-15-width, 0, width, 40)];
    //    [filterBtn setBackgroundColor:[UIColor blueColor]];
    //    [filterBtn setTextColor:[JYHelpers setFontColorWithString:@"#2695ff"]];
    [filterBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [filterBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [filterBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
    [filterBtn setTitleColor:[JYHelpers setFontColorWithString:@"#2695ff"] forState:UIControlStateNormal];
    [filterBtn addTarget:self action:@selector(filterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [friendCountBg addSubview:filterBtn];
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, friendCountBg.bottom, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavigationBarHeight-friendCountBg.height - 44) style:UITableViewStylePlain];
    [_table setRowHeight:54];
    [_table setBackgroundColor:[UIColor clearColor]];
//    [_table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_table setDelegate:self];
    [_table setDataSource:self];
    [self.view addSubview:_table];
    [_table setTableFooterView:[[UIView alloc] init]];
    
//    [_table registerClass:[JYManageFriendCell class] forCellReuseIdentifier:@"JYManageFriendCellID"];
    //筛选视图
    _filterBg = [[UIImageView alloc] initWithFrame:CGRectMake(filterBtn.left - 15 - 15 - 10 - 10, friendCountBg.bottom, filterBtn.width + 15+15+10+10, (filterBtn.height - 15)*3+10)];
    [_filterBg setBackgroundColor:[UIColor clearColor]];

    UIImage *backImg = [[UIImage imageNamed:@"find_filter_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 5, 25)];

    [_filterBg setImage:backImg];
    [_filterBg setUserInteractionEnabled:YES];
    [_filterBg setTag:4567];
//    [_filterBg setBackgroundColor:[UIColor whiteColor]];
//    [_filterBg setAlpha:0];
    [_filterBg setHidden:YES];
    [self.view addSubview:_filterBg];
    [self.view bringSubviewToFront:_filterBg];
//    [self.navigationController.view addSubview:_filterBg];
//    [self.view insertSubview:_filterBg aboveSubview:_table];
    for (int i=0; i<3; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(5, 8+i*(filterBtn.height - 15), filterBtn.width+15+15+10, filterBtn.height - 15)];
        [btn setTag:1000+i];
        [btn setBackgroundColor:[UIColor clearColor]];
//        [btn.layer setBorderWidth:1];
//        [btn.layer setBorderColor:[[JYHelpers setFontColorWithString:@"#cccccc"] CGColor]];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [btn setTitleColor:[JYHelpers setFontColorWithString:@"#2695ff"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(genderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_filterBg addSubview:btn];
        switch (i) {
            case 0:
            {
                [btn setTitle:@"全部" forState:UIControlStateNormal];
            }
                break;
            case 1:
            {
                [btn setTitle:@"只看单身" forState:UIControlStateNormal];
            }
                break;
            case 2:
            {
                [btn setTitle:@"只看异性" forState:UIControlStateNormal];
            }
                break;
            default:
                break;
        }
        
        if (i < 2) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(btn.left, btn.bottom - 0.5, btn.width, 1)];
//            [line.layer setBackgroundColor:[[JYHelpers setFontColorWithString:@"#ffffff"] CGColor]];
//            [line.layer setBorderWidth:1];
            [line setBackgroundColor:kTextColorLightGray];
            [_filterBg addSubview:line];
        }
    }
    
    if (self.type == JYFriendManageTypeSelect) {
//        NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(<#selector#>) userInfo:<#(id)#> repeats:<#(BOOL)#>
        UIImageView *selectedNameBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, _table.bottom, kScreenWidth, 44)];
        [selectedNameBg setUserInteractionEnabled:YES];
        [selectedNameBg setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:selectedNameBg];
        
//        _selectedNameLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth-80-15, kTabBarViewHeight)];
//        //    [_selectedNameLab setBackgroundColor:[UIColor whiteColor]];
//        [_selectedNameLab setFont:[UIFont systemFontOfSize:15.0f]];
//        //    [_selectedNameLab setNumberOfLines:0];
//        //    [_selectedNameLab sizeToFit];
//        [_selectedNameLab setTextColor:[JYHelpers setFontColorWithString:@"#2695ff"]];
//        [selectedNameBg addSubview:_selectedNameLab];
        selectAvatarView = [[JYSelectedFriendAvatarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 80, 44)];
        [selectedNameBg addSubview:selectAvatarView];
        
        _inviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_inviteBtn setFrame:CGRectMake(selectAvatarView.right, 0, 80, 44)];
        //    [_inviteBtn setBackgroundColor:[UIColor greenColor]];
        [_inviteBtn setTitle:@"邀请" forState:UIControlStateNormal];
        [_inviteBtn setBackgroundImage:[UIImage imageNamed:@"find_contact_btnBg"] forState:UIControlStateNormal];
        [_inviteBtn setEnabled:NO];
        
        [_inviteBtn addTarget:self action:@selector(inviteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [selectedNameBg addSubview:_inviteBtn];
        
        UIView *line_3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        [line_3.layer setBorderColor:[[JYHelpers setFontColorWithString:@"#cccccc"] CGColor]];
        [line_3.layer setBorderWidth:1];
        [selectedNameBg addSubview:line_3];
        
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - btn点击事件
//没有好友时添加好友
- (void)addFriendAction{
    JYAddFriendController *addController = [[JYAddFriendController alloc] init];
    [self.navigationController pushViewController:addController animated:YES];
}
//查看分组
- (void)groupBtnClick:(UIButton *)btn
{
    NSLog(@"分组好友");

    JYFriendGroupController *friendGroupController = [[JYFriendGroupController alloc] init];
    [friendGroupController setGroupList:groupList];
    [self.navigationController pushViewController:friendGroupController animated:YES];
    
}
//筛选
- (void)filterBtnClick:(UIButton *)btn
{
    [self.view bringSubviewToFront:_filterBg];
    NSLog(@"筛选");
    _filterBg.hidden = ! _filterBg.hidden;
//    if (_filterBg.alpha == 0) {
//      [UIView animateWithDuration:.3 animations:^{
//          [_filterBg setAlpha:1];
//      }];
//    }else{
//        [UIView animateWithDuration:.3 animations:^{
//            [_filterBg setAlpha:0];
//        }];
//    }
//    [UIView animateWithDuration:.5 animations:^{
//        _filterBg.hidden = !_filterBg.hidden;
//    }];
}
//筛选详情点击
- (void)genderBtnClick:(UIButton *)btn
{
    [_filterBg setHidden:YES];
    NSInteger tag = btn.tag-1000;
    NSLog(@"%ld", (long)tag);
    switch (tag) {
        case 0:{
            [_friendList removeAllObjects];
            [_friendList addObjectsFromArray:[[JYManageFriendData sharedInstance] friendList]];
            [self handleFriendsList];
        }
            break;
        case 1:{//只看单身
            [self siftFriendsWhoIsSingle];
        }
            break;
        case 2:{//只看异性
            NSString *genderStr = [[JYShareData sharedInstance].myself_profile_dict objectForKey:@"sex"];
            if ([genderStr isEqualToString:@"1"]) {
                genderStr = @"0";
                NSLog(@"筛选女性")
            }else{
                genderStr = @"1";
                NSLog(@"筛选男性")
            }
            [self siftFriendsWithSex:genderStr];
        }
            break;
        default:
            break;
    }
    [[JYAppDelegate sharedAppDelegate] showTip:@"筛选完成"];
}
//点击男女筛选
- (void)siftFriendsWithSex:(NSString*)sex{
    
//    NSArray *friendArr = [JYManageFriendData sharedInstance].friendList;
    [_friendList removeAllObjects];
    for (JYCreatGroupFriendModel *model in sourceFriendArr) {
        if ([model.sex isEqualToString:sex]) {
            [_friendList addObject:model];
        }
    }
    [self handleFriendsList];
}
//筛选单身
- (void)siftFriendsWhoIsSingle{
    [_friendList removeAllObjects];
    for (JYCreatGroupFriendModel *model in sourceFriendArr) {
        if ([model.marriage isEqualToString:@"1"]) {
            [_friendList addObject:model];
        }
    }
    [self handleFriendsList];
}
//邀请点击
- (void)inviteBtnClick:(UIButton*)btn{
    if ([self.delegate respondsToSelector:@selector(confirmBtnActionWithFriendList:)]) {
//        NSMutableArray *dataArr = [NSMutableArray array];
//        for (NSIndexPath *indexPath in _selectedListArr) {
//            JYCreatGroupFriendModel *model = [[_friendList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
//            [dataArr addObject:model];
//        }
        [self.delegate confirmBtnActionWithFriendList:_selectedListArr];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
    //创建的时候 先选择好友再跳转到保存分组界面
        JYSaveGroupController *saveVC = [[JYSaveGroupController alloc] init];
        saveVC.groupEditType = JYFriendGroupEditTypeCreate;
        [saveVC setMembersList:_selectedListArr];//选好的好友
        [self.navigationController pushViewController:saveVC animated:YES];
        
        //push到下一个界面将此界面从self.navigationController.viewControllers中删除
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [viewControllers removeObjectAtIndex:(viewControllers.count - 2)];
        [self.navigationController setViewControllers:viewControllers];
        
    }
}
//邀请手机好友加入
//- (void)inviteMobileFriendJoin:(UIButton*)button{
//    NSInteger index = button.superview.tag - 100;
//    NSDictionary *dic = [[_friendList lastObject] objectAtIndex:index];
//    
//    NSString *mobile = [dic objectForKey:@"mobile"];
//    if ([MFMessageComposeViewController canSendText]) {
//        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
//        controller.recipients = @[mobile];
//        controller.body = @"我在XXX，快来这里认识更多靠谱的朋友，通过好友圈拓展好友圈，朋友的朋友一秒变好友。下载：http://friendly.jianyuan.com";
//        controller.messageComposeDelegate = self;
//        [self presentViewController:controller animated:YES completion:nil];
//    }
//}
#pragma mark - 刷新邀请名单lab和邀请按钮
- (void)relayoutInviteBtnAndLab{


    [selectAvatarView setSelectedFriendList:_selectedListArr];
    [selectAvatarView reloadData];
    if (_selectedListArr.count == 0) {
        [_inviteBtn setEnabled:NO];
    }else{
    
        if (!_inviteBtn.enabled) {
            _inviteBtn.enabled = YES;
        }
    }
    [_inviteBtn setTitle:[NSString stringWithFormat:@"邀请(%ld)",(long)_selectedListArr.count] forState:UIControlStateNormal];
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
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{

    return _indexArr;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [((NSArray*)_friendList[section]) count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _friendList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    
    if (indexPath.section == _friendList.count - 1 && _type == JYFriendManageTypeManage && [JYManageFriendData sharedInstance].mobileFriendList.count != 0) {
        static NSString *mobileCellID = @"mobileCellID";
        JYManageMobileFriendCell *mobileCell = [tableView dequeueReusableCellWithIdentifier:mobileCellID];
        if (mobileCell == nil) {
            mobileCell = [[JYManageMobileFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mobileCellID];
            [mobileCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        [mobileCell layoutSubviewsWithMobileFriendInfoDic:_friendList[indexPath.section][indexPath.row]];
        return mobileCell;
    }
    
    JYManageFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[JYManageFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    JYCreatGroupFriendModel *friendModel = [((NSArray*)[_friendList objectAtIndex:indexPath.section]) objectAtIndex:indexPath.row];
    [cell layoutCellWithModel:friendModel];

//    for (int i = 0 ; i < _selectedListArr.count; i++) {
//        JYCreatGroupFriendModel *model = _selectedListArr[i];
//        if ([model.friendUid isEqualToString:friendModel.friendUid]) {
//            [cell.personInfoBg setFrame:CGRectMake(15+17, 0, kScreenWidth, cell.height)];
//            [cell.selectView setHidden:NO];
//            break;
//        }else if(i == _selectedListArr.count - 1){
//            [cell.personInfoBg setFrame:CGRectMake(0, 0, kScreenWidth, cell.height)];
//            [cell.selectView setHidden:YES];
//        }
//    }
    if ([_selectedListArr containsObject:friendModel]) {
        [cell.personInfoBg setFrame:CGRectMake(15+17, 0, kScreenWidth, cell.height)];
        [cell.selectView setHidden:NO];
    }else{
        [cell.personInfoBg setFrame:CGRectMake(0, 0, kScreenWidth, cell.height)];
        [cell.selectView setHidden:YES];
    }
    
    return cell;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(-1, 0, kScreenWidth+2, 22)];
    [headerView setBackgroundColor:[JYHelpers setFontColorWithString:@"edf1f4"]];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 40, 22)];
    [lab setBackgroundColor:[UIColor clearColor]];
    [lab setTextColor:[JYHelpers setFontColorWithString:@"#303030"]];
    [lab setText:_indexArr[section]];
    
    [headerView addSubview:lab];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 22;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_filterBg.hidden == NO) {
        [_filterBg setHidden:YES];
    }
    JYCreatGroupFriendModel *model = [[_friendList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (self.type == JYFriendManageTypeManage) {
        if (indexPath.section == _friendList.count - 1 && [JYManageFriendData sharedInstance].mobileFriendList.count != 0) {
            
            
            NSDictionary *dic = [[_friendList lastObject] objectAtIndex:indexPath.row];
            
            NSString *mobile = [dic objectForKey:@"mobile"];
            if ([JYHelpers isPhoneNumber:mobile]) {
                JYContactProfileController *contactProfile = [[JYContactProfileController alloc] init];
                [contactProfile setName:[dic objectForKey:@"truename"]];
                [contactProfile setPhone:mobile];
                [self.navigationController pushViewController:contactProfile animated:YES];
                return;
            }else{
            //否则为微博好友
                
                NSString *content = [NSString stringWithFormat:@"快来【友寻】和我一起认识更多靠谱的朋友，朋友的朋友一秒变好友。和朋友的朋友谈恋爱，顺手解救身边的单身朋友，变身朋友圈丘比特。@%@http://m.iyouxun.com/wechat/friend_invite/?uid=%@",[dic objectForKey:@"truename"],ToString([SharedDefault objectForKey:@"uid"])];
                //     = [NSString stringWithFormat:@"小伙伴，快来加入友寻吧.@%@http://www.baidu.com",_dataArr[index][@"name"]];
                
                JYShareContentController *shareContentVC = [[JYShareContentController alloc] init];
                //    UIPinchGestureRecognizer
                [shareContentVC setContent:content];
                //    [shareContentVC setImageUrl:_dataArr[index][@"avatar"]];
                [self.navigationController pushViewController:shareContentVC animated:YES];
 
                return;
            }
       }
        if ([JYHelpers integerValueOfAString:model.gid] == 100) {
            JYContactProfileController *contactProfile = [[JYContactProfileController alloc] init];
            [contactProfile setName:model.nick];
            [contactProfile setPhone:model.mobile];
            [self.navigationController pushViewController:contactProfile animated:YES];
        }else{
            JYOtherProfileController *profileVC = [[JYOtherProfileController alloc] init];
            [profileVC setShow_uid:model.friendUid];
            [profileVC setFriendModel:model];
            [self.navigationController pushViewController:profileVC animated:YES];
        }
        
    }else{
        JYManageFriendCell *cell = (JYManageFriendCell*)[tableView cellForRowAtIndexPath:indexPath];
 
        if (cell.selectView.hidden) {//选中
    //        CGRect frame = bgView.frame;
            [_selectedListArr addObject:model];
//            [_selectedListArr addObject:indexPath];
            [UIView animateWithDuration:.3 animations:^{
                [cell.personInfoBg setFrame:CGRectMake(15+17, 0, kScreenWidth, 54)];
            } completion:^(BOOL finished) {
                [cell.selectView setHidden:NO];
            }];
        }else{//移除
            
//            for (JYCreatGroupFriendModel *friendModel in sourceFriendArr) {
//                if ([friendModel.friendUid isEqualToString:model.friendUid]) {
//                    [friendModel setIsSelected:NO];
//                }
//            }
            [_selectedListArr removeObject:model];
            [cell.selectView setHidden:YES];
            
            [UIView animateWithDuration:.3 animations:^{
                [cell.personInfoBg setFrame:CGRectMake(0, 0, kScreenWidth, 54)];
            }];
        }
        [self relayoutInviteBtnAndLab];
    }
}
#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    NSString *promptText = @"";
    
    switch (result) {
        case MessageComposeResultSent:
            promptText = @"发送成功！";
            break;
            case MessageComposeResultCancelled:
//            promptText = @"已取消发送！";
            break;
            case MessageComposeResultFailed:
            promptText = @"发送失败！";
        default:
            break;
    }
    if (result != MessageComposeResultCancelled) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:promptText delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert show];    
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
    
}
//是手机号 进入发短信界面
//                if ([MFMessageComposeViewController canSendText]) {
//                    [self showProgressHUD:@"加载中..." toView:self.view];
//                    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
//                    controller.recipients = @[mobile];
//                    controller.body = [NSString stringWithFormat:@"快来【友寻】和我一起认识更多靠谱的朋友，朋友的朋友一秒变好友。和朋友的朋友谈恋爱，顺手解救身边的单身朋友，变身朋友圈丘比特。http://m.iyouxun.com/wechat/friend_invite/?uid=%@",ToString([SharedDefault objectForKey:@"uid"])];
//                    controller.messageComposeDelegate = self;
//                    [self presentViewController:controller animated:YES completion:^{
//                        [self dismissProgressHUDtoView:self.view];
//                    }];
//                }else{
//                    [[JYAppDelegate sharedAppDelegate] showTip:@"抱歉，当前设备不支持发短信功能。"];
//                }

@end
