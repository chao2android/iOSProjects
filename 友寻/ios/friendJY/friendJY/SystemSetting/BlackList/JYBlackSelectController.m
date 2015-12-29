//
//  JYBlackSelectController.m
//  friendJY
//
//  Created by chenxiangjing on 15/4/30.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYBlackSelectController.h"
#import "JYCreatGroupFriendModel.h"
#import "JYHttpServeice.h"
#import "ChineseString.h"
#import "JYManageFriendCell.h"
#import "JYSelectedFriendAvatarView.h"
#import "JYManageFriendData.h"
#import "JYAppDelegate.h"
#import "JYShareData.h"

@interface JYBlackSelectController ()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *friendCountLab;
//    UIButton *groupBtn;
//    NSMutableArray *groupList;
    UILabel *groupLab;
    JYSelectedFriendAvatarView *selectAvatarView;
    NSMutableArray *sourceArr;
    NSMutableArray *secondFriendSourceArr;
    
    BOOL hasLoadFriend;
    BOOL hasLoadSecondFriend;
    BOOL isFilter;
}
@end

@implementation JYBlackSelectController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"添加到黑名单"];
        
        //        _friendList = [[NSMutableArray alloc] init];
        _nameList = [[NSMutableArray alloc] init];
        _indexArr = [[NSMutableArray alloc] init];
        //        groupList = [[NSMutableArray alloc] init];
        _selectedListArr = [[NSMutableArray alloc] init];
        _friendList = [ NSMutableArray array];
        
        hasLoadFriend = NO;
        hasLoadSecondFriend = NO;
        isFilter = NO;
        
        sourceArr = [NSMutableArray array];
//        [sourceArr addObjectsFromArray:[[JYManageFriendData sharedInstance] friendList]];
        secondFriendSourceArr = [NSMutableArray array];
//        [secondFriendSourceArr addObjectsFromArray:[[JYManageFriendData sharedInstance] secondFriendList]];
        //        numOfGetMutualNum = 0;
    }
    
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubviews];
//    if ([JYManageFriendData sharedInstance].friendList.count > 0) {
//        NSLog(@"=======================")
//        NSLog(@"本地读取一度好友数据！")
//        NSLog(@"=======================")
//        hasLoadFriend = YES;
////        [_friendList addObjectsFromArray:[JYManageFriendData sharedInstance].friendList];
////        [self handleFriendsList];
//    }else{
        NSLog(@"=======================")
        NSLog(@"下载一度好友数据！")
        NSLog(@"=======================")
        [self loadFriendDataWithNum:300];
//    }
    
//    if ([JYManageFriendData sharedInstance].secondFriendList.count > 0) {
//        NSLog(@"=======================")
//        NSLog(@"本地读取二度好友数据！")
//        NSLog(@"=======================")
////        [_friendList addObjectsFromArray:[JYManageFriendData sharedInstance].secondFriendList];
//        hasLoadSecondFriend = YES;
//        if (sourceArr.count > 0) {
//            [self handleFriendsList];
//        }
//    }else{
        NSLog(@"=======================")
        NSLog(@"下载二度好友数据！")
        NSLog(@"=======================")
        [self loadSecondFriendData];
//    }
    _selectedListArr = [NSMutableArray array];
    
}
#pragma mark - request
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

    NSDictionary *paraDic = @{@"mod":@"friends",
                              @"func":@"friends_get_myfriends_all"
                              };
    
    NSDictionary *postDic = @{@"uid":ToString([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]),
                              @"start":@"0",
                              @"nums":[NSString stringWithFormat:@"%ld",(long)num]
                              };
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            NSLog(@"成功获取一度好友信息")
            hasLoadFriend = YES;
            if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dataDic = [responseObject objectForKey:@"data"];
                NSMutableArray *mobileFriendArr = [NSMutableArray array];
                NSMutableArray *dataArr = [NSMutableArray array];
                
                for (NSString *key in dataDic.allKeys) {
                    if([dataDic[key] count] > 3){
                        JYCreatGroupFriendModel *model = [[JYCreatGroupFriendModel alloc] initWithDataDic:dataDic[key]];
                        [model setIs_friend:@"1"];
                        [model setAvatar:dataDic[key][@"avatars"][@"100"]];
                        if (![JYHelpers isEmptyOfString:model.friendUid]) {
                            [dataArr addObject:model];
                        }
                    }else{
                        [mobileFriendArr addObject:dataDic[key]];
                    }
                }
//                [[JYManageFriendData sharedInstance] setFriendList:dataArr];
                [sourceArr addObjectsFromArray:dataArr];
                [_friendList addObjectsFromArray:dataArr];
//                [[JYManageFriendData sharedInstance] setMobileFriendList:mobileFriendArr];
                
            }
            if (hasLoadSecondFriend && hasLoadFriend) {//没有下载完成不处理
                [self handleFriendsList];
            }
        }
    } failure:^(id error) {
        [self dismissProgressHUDtoView:self.view];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];
}

- (void)loadSecondFriendData{
    
    [self showProgressHUD:@"加载中..." toView:self.view];
    NSDictionary *paraDic = @{@"mod":@"friends",
                              @"func":@"friends_get_fsfriends"
                              };
    
    NSDictionary *postDic = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],
                          @"is_reg":@"1",
                          @"start":@"0",
                          @"nums":@"300"
                          };
   
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            //do any addtion here...
            hasLoadSecondFriend = YES;
            NSDictionary *dataDic = [responseObject objectForKey:@"data"];
            if (dataDic.count != 0) {
                NSMutableArray *dataArr = [NSMutableArray array];
                [dataDic.allKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
                    if (key.length > 7) {
                        //key 13800138012
                    }else{
                        JYCreatGroupFriendModel *model = [[JYCreatGroupFriendModel alloc] initWithDataDic:dataDic[key]];
                        [model setIs_friend:@"2"];
                        [model setAvatar:dataDic[key][@"avatars"][@"100"]];
                        [dataArr addObject:model];
                    }
                }];
                
//                [[JYManageFriendData sharedInstance] setSecondFriendList:dataArr];
//                [_friendList addObjectsFromArray:dataArr];
                [secondFriendSourceArr addObjectsFromArray:dataArr];
                [_friendList addObjectsFromArray:dataArr];
//                [self handleFriendsList];
                //                [self getMutualNums];
            }
            if (hasLoadSecondFriend && hasLoadFriend) {//没有下载完成不处理
                [self handleFriendsList];
            }
//            }else{
//                [_friendList removeAllObjects];
//                [self handleFriendsList];
//            }
            [self dismissProgressHUDtoView:self.view];
        }else{
            [self dismissProgressHUDtoView:self.view];
        }
    } failure:^(id error) {
        [self dismissProgressHUDtoView:self.view];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];
}

//添加黑名单
- (void)addFriendToBlackList{
//    public array( add_black(int uid, int fuid, array fuid_arr)
//                 添加黑名单
//                 Parameters:
//                 uid - 自己UID
//                 fuid - 好友UID
//                 fuid_arr - 好友UIDS
//                 Returns:
//                 "retcode":1(参数编号), "retmean":"参数含义", "data":true:成功;false:失败
    if (_selectedListArr.count == 0) {
        return;
    }
    NSDictionary *paraDic = @{@"mod":@"relation",
                              @"func":@"add_black"
                              };
    NSMutableString *muStr = [NSMutableString string];
    for (JYCreatGroupFriendModel *model in _selectedListArr) {
        [muStr appendFormat:@"%@,",model.friendUid];
    }

    NSDictionary *postDic = @{@"uid":ToString([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]),
                              @"fuid_arr":[muStr substringToIndex:muStr.length - 1]
                              };
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            //do any addtion here...
            if (self.selectDone) {
//                NSMutableArray *dataArr = [NSMutableArray array];
//                for (NSIndexPath *indexPath in _selectedListArr) {
//                    JYCreatGroupFriendModel *model = [[_friendList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
//                    [dataArr addObject:model];
//                }
                self.selectDone(_selectedListArr);
            }
            [self.navigationController popViewControllerAnimated:YES];

        }
    } failure:^(id error) {
        [self dismissProgressHUDtoView:self.view];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];

}
                                                                    
#pragma mark - DataHandler
//需要对获取下来的数据进行处理
- (void)removeSameModelInFriendList{
    //选择好友进分组的时候 当好友已经被选择 则不显示
    NSMutableArray *sameArr = [NSMutableArray array];
    NSMutableArray *dataArr = [NSMutableArray array];
    for (NSArray *arr in _selectMembers) {
        for (JYCreatGroupFriendModel *model in arr) {
            [dataArr addObject:model];
        }
    }
//    [self setSelectMembers:dataArr];
    
    for (int i = 0; i < _friendList.count; i++) {
        
        JYCreatGroupFriendModel *friendModel = [_friendList objectAtIndex:i];
        
        for (int j = 0; j < dataArr.count; j++) {
            
            JYCreatGroupFriendModel *selectFriendModel = [dataArr objectAtIndex:j];
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

    if (!isFilter) {//刚进来的时候
        [_friendList removeAllObjects];
        [_friendList addObjectsFromArray:sourceArr];
        [_friendList addObjectsFromArray:secondFriendSourceArr];
    }
   
    //过滤
    [self removeSameModelInFriendList];
    
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
    
    [_table reloadData];
}

- (void)initSubviews{
    //好友分组
    CGFloat bottom = 0;
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
    CGFloat width = [myStr sizeWithFont:[UIFont systemFontOfSize:15]].width;
    UIButton *filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [filterBtn setFrame:CGRectMake(kScreenWidth-15-width, 0, width, 40)];
    //    [filterBtn setBackgroundColor:[UIColor blueColor]];
    //    [filterBtn setTextColor:[JYHelpers setFontColorWithString:@"#2695ff"]];
    [filterBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [filterBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
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
    [_filterBg setBackgroundColor:[UIColor clearColor]];
    [_filterBg setHidden:YES];
    [self.view addSubview:_filterBg];
    //    [self.navigationController.view addSubview:_filterBg];
    //    [self.view insertSubview:_filterBg aboveSubview:_table];
    for (int i=0; i<3; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0, 8+i*(filterBtn.height - 15), filterBtn.width+15+15+10, filterBtn.height - 15)];
        [btn setTag:1000+i];
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
        
    }

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
    [_inviteBtn setTitle:@"添加" forState:UIControlStateNormal];
    [_inviteBtn setBackgroundImage:[UIImage imageNamed:@"find_contact_btnBg"] forState:UIControlStateNormal];
    [_inviteBtn addTarget:self action:@selector(inviteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [selectedNameBg addSubview:_inviteBtn];
    
    UIView *line_3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    [line_3.layer setBorderColor:[[JYHelpers setFontColorWithString:@"#cccccc"] CGColor]];
    [line_3.layer setBorderWidth:1];
    [selectedNameBg addSubview:line_3];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - btn点击事件
//筛选
- (void)filterBtnClick:(UIButton *)btn
{
    NSLog(@"筛选");
    _filterBg.hidden = !_filterBg.hidden;

}
//筛选详情点击
- (void)genderBtnClick:(UIButton *)btn
{
    [_filterBg setHidden:YES];
    isFilter = YES;
    NSInteger tag = btn.tag-1000;
    NSLog(@"%ld", (long)tag);
    switch (tag) {
        case 0:{
            [_friendList removeAllObjects];
            [_friendList addObjectsFromArray:sourceArr];
            [_friendList addObjectsFromArray:secondFriendSourceArr];
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
    NSMutableArray *dataArr = [NSMutableArray arrayWithArray:sourceArr];
    [dataArr addObjectsFromArray:secondFriendSourceArr];
    
    for (JYCreatGroupFriendModel *model in dataArr) {
        if ([model.sex isEqualToString:sex]) {
            [_friendList addObject:model];
        }
    }
    [self handleFriendsList];
}
//筛选单身
- (void)siftFriendsWhoIsSingle{
    [_friendList removeAllObjects];
    NSMutableArray *dataArr = [NSMutableArray arrayWithArray:sourceArr];
    [dataArr addObjectsFromArray:secondFriendSourceArr];

    for (JYCreatGroupFriendModel *model in dataArr) {
        if ([model.marriage isEqualToString:@"1"]) {
            [_friendList addObject:model];
        }
    }
    [self handleFriendsList];
}
//邀请点击
- (void)inviteBtnClick:(UIButton*)btn{
    
    [self addFriendToBlackList];
}

#pragma mark - 刷新邀请名单lab和邀请按钮
- (void)relayoutInviteBtnAndLab{
   
//    NSMutableArray *selectFriendModelArr = [NSMutableArray array];
//    for (NSIndexPath *indexPath in _selectedListArr) {
//        JYCreatGroupFriendModel *model = _friendList[indexPath.section][indexPath.row];
//        [selectFriendModelArr addObject:model];
//    }
    [selectAvatarView setSelectedFriendList:_selectedListArr];
    [selectAvatarView reloadData];
    
    [_inviteBtn setTitle:[NSString stringWithFormat:@"添加(%ld)",(long)_selectedListArr.count] forState:UIControlStateNormal];
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
    
    JYManageFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[JYManageFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    JYCreatGroupFriendModel *friendModel = [((NSArray*)[_friendList objectAtIndex:indexPath.section]) objectAtIndex:indexPath.row];
    [cell layoutCellWithModel:friendModel];
    //    for (JYCreatGroupFriendModel *model in self.selectMembers) {
    //        if ([model.friendUid isEqualToString:friendModel.friendUid]) {
    //            [_selectedListArr addObject:indexPath];
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
    
    JYManageFriendCell *cell = (JYManageFriendCell*)[tableView cellForRowAtIndexPath:indexPath];
    JYCreatGroupFriendModel *model  = _friendList[indexPath.section][indexPath.row];
    if (cell.selectView.hidden) {//选中
        //        CGRect frame = bgView.frame;
        [_selectedListArr addObject:model];
        [UIView animateWithDuration:.3 animations:^{
            [cell.personInfoBg setFrame:CGRectMake(15+17, 0, kScreenWidth, 54)];
        } completion:^(BOOL finished) {
            [cell.selectView setHidden:NO];
        }];
    }else{//移除
        [_selectedListArr removeObject:model];
        [cell.selectView setHidden:YES];
        [UIView animateWithDuration:.3 animations:^{
            [cell.personInfoBg setFrame:CGRectMake(0, 0, kScreenWidth, 54)];
        }];
    }
    [self relayoutInviteBtnAndLab];
    
}
@end
