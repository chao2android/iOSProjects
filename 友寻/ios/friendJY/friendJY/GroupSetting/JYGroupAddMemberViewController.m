//
//  JYGroupAddMemberViewController.m
//  friendJY
//
//  Created by aaa on 15/5/28.
//  Copyright (c) 2015年 友寻. All rights reserved.
//

#import "JYGroupAddMemberViewController.h"
#import "JYCreatGroupFriendModel.h"
#import "ChineseString.h"
#import "JYCreatGroupFriendCell.h"

@interface JYGroupAddMemberViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UILabel *selectedCountLab;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *nameList;
@property (nonatomic, strong) NSMutableArray *indexArray;
@property (nonatomic, strong) NSMutableArray *friendsList;
@property (nonatomic, strong) NSMutableArray *selectedFriendsList;
@property (nonatomic, assign) int friendsCount;

@end

@implementation JYGroupAddMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"添加成员"];
    
    _friendsList = [[NSMutableArray alloc] init];
    _nameList = [[NSMutableArray alloc] init];
    _selectedFriendsList = [[NSMutableArray alloc] init];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setFrame:CGRectMake(0, 0, 65, 44)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [saveBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
    [saveBtn setTitleColor:kTextColorBlue forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveBarBtn = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    [self.navigationItem setRightBarButtonItem:saveBarBtn];
    
    UIImageView *selectedCountBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    [selectedCountBg setBackgroundColor:kTextColorWhite];
    [selectedCountBg setUserInteractionEnabled:YES];
    [self.view addSubview:selectedCountBg];
    
    _selectedCountLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, 200, 16)];
    [_selectedCountLab setTextAlignment:NSTextAlignmentLeft];
    [_selectedCountLab setTextColor:kTextColorGray];
    [_selectedCountLab setFont:[UIFont systemFontOfSize:14.0f]];
    [selectedCountBg addSubview:_selectedCountLab];
    //    NSString *selectedCountStr = [NSString stringWithFormat:@"群成员上限为100人（%lu/100）", (unsigned long)_selectedFriendsList.count];
    [_selectedCountLab setText:[NSString stringWithFormat:@"群成员上限为100人（%lu/100）",(unsigned long)self.oldMemberArray.count]];
    
    UIButton *allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [allBtn setBackgroundColor:[UIColor clearColor]];
    [allBtn setFrame:CGRectMake(kScreenWidth-65, 0, 50, 30)];
    [allBtn setTitleColor:kTextColorBlue forState:UIControlStateNormal];
    [allBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [allBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [allBtn setTitle:@"全选" forState:UIControlStateNormal];
    [allBtn setTitle:@"取消全选" forState:UIControlStateSelected];
    allBtn.selected = NO;
    [allBtn addTarget:self action:@selector(allBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [selectedCountBg addSubview:allBtn];
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, selectedCountBg.height, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavigationBarHeight-selectedCountBg.height) style:UITableViewStylePlain];
    [_table setRowHeight:44];
    [_table setBounces:YES];
    [_table setBackgroundColor:[UIColor clearColor]];
    [_table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_table setDelegate:self];
    [_table setDataSource:self];
    [self.view addSubview:_table];
    
    [self requestGetFriendsNums];
}

- (void)handleFriendsList
{
    for (JYCreatGroupFriendModel *friendModel in _friendsList)
    {
        [_nameList addObject:friendModel.nick];
    }
    
    [self setIndexArray:[ChineseString indexArray:_nameList]];
    
    [self setNameList:[ChineseString returnSortChineseArrar:_nameList]];
    //    [self setPhoneContactsArray:[ChineseString letterSortArray:nameList]];
    [self sortFriendsList];
}

- (void)sortFriendsList
{
    
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    
    NSString *tempStr = @"";
    NSMutableArray *tempList = [[NSMutableArray alloc] init];
    
    for (int i=0; i<_nameList.count; i++) {
        if (((ChineseString*)_nameList[i]).pinYin.length < 1) {
            continue;
        }
        NSString *py = [((ChineseString*)_nameList[i]).pinYin substringToIndex:1];
        NSString *nick = ((ChineseString*)_nameList[i]).string;
        
        if(![tempStr isEqualToString:py]) {
            //不同
            [resultList addObject:tempList];
            
            tempList = [[NSMutableArray alloc] init];
            for (int i=0; i<_friendsList.count; i++) {
                
                JYCreatGroupFriendModel *friendModel = _friendsList[i];
                [friendModel setIsSelected:NO];
                if ([friendModel.nick isEqualToString:nick])
                {
                    [tempList addObject:friendModel];
                    [_friendsList removeObject:friendModel];
                    break;
                }
            }
            
            tempStr = py;
            
        } else {
            
            //相同
            for (int i=0; i<_friendsList.count; i++) {
                
                JYCreatGroupFriendModel *friendModel = _friendsList[i];
                [friendModel setIsSelected:NO];
                if ([friendModel.nick isEqualToString:nick])
                {
                    [tempList addObject:friendModel];
                    [_friendsList removeObject:friendModel];
                    break;
                }
            }
        }
        
    }
    [resultList addObject:tempList];
    
    [resultList removeObjectAtIndex:0];
    
    //    for (ChineseString* str in _nameList) {
    //        NSLog(@"%@", str.string);
    //    }
    
    NSLog(@"############");
    
    for (NSArray *list in resultList) {
        for (JYCreatGroupFriendModel *model in list) {
            
            NSLog(@"%@", model.nick);
        }
    }
    //计算一共有多少个好友
    _friendsCount = 0;
    for (int i = 0 ; i<resultList.count; i++) {
        NSArray *arr = resultList[i];
        for (int j = 0; j<arr.count; j++) {
            _friendsCount++;
        }
    }
    
    [self setFriendsList:resultList];
}

//取消全选
- (void)allBtnClick:(UIButton *)btn
{
    if (!btn.selected) {//全选
        NSLog(@"全选");
        btn.width = 60;
        [_selectedFriendsList removeAllObjects];
        int i = 0;
        for (NSArray *list in _friendsList) {
            if (_selectedFriendsList.count >= 99) {
                break;
            }
            int j = 0;
            for (JYCreatGroupFriendModel *friendModel in list) {
                if (_selectedFriendsList.count >= 99) {
                    break;
                }
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                JYCreatGroupFriendCell * tempCell = (JYCreatGroupFriendCell *)[_table cellForRowAtIndexPath:indexPath];
                friendModel.image = tempCell.avatarView.image;
                friendModel.isSelected = YES;
                [_selectedFriendsList addObject:friendModel];
                j++;
            }
            i++;
        }
    }else{
        //取消全选
        btn.width = 30;
        for (int i=0; i<_selectedFriendsList.count; i++) {
            JYCreatGroupFriendModel *friendModel =_selectedFriendsList[i];
            friendModel.isSelected = NO;
        }
        [_selectedFriendsList removeAllObjects];
    }
    btn.selected = !btn.selected;
    
    [_table reloadData];
    [self updateSelectedCountLab];
    /*
    if (_selectedFriendsList.count == _friendsCount) {
        //取消全选
        NSLog(@"取消全选")
        btn.width = 30;
        [btn setTitle:@"全选" forState:UIControlStateNormal];
        for (int i=0; i<_selectedFriendsList.count; i++) {
            JYCreatGroupFriendModel *friendModel =_selectedFriendsList[i];
            friendModel.isSelected = NO;
        }
        [_selectedFriendsList removeAllObjects];
    } else {
        //全选
        NSLog(@"全选");
        btn.width = 60;
        [btn setTitle:@"取消全选" forState:UIControlStateNormal];
        [_selectedFriendsList removeAllObjects];
        int i = 0;
        for (NSArray *list in _friendsList) {
            if (_selectedFriendsList.count >= 99) {
                break;
            }
            int j = 0;
            for (JYCreatGroupFriendModel *friendModel in list) {
                if (_selectedFriendsList.count >= 99) {
                    break;
                }
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                JYCreatGroupFriendCell * tempCell = (JYCreatGroupFriendCell *)[_table cellForRowAtIndexPath:indexPath];
                friendModel.image = tempCell.avatarView.image;
                friendModel.isSelected = YES;
                [_selectedFriendsList addObject:friendModel];
                j++;
            }
            i++;
        }
    }
    
    */
}

- (void)updateSelectedCountLab
{
    NSString *selectedCountStr = [NSString stringWithFormat:@"群成员上限为100人（%lu/100）", (unsigned long)_selectedFriendsList.count+self.oldMemberArray.count];
    [_selectedCountLab setText:selectedCountStr];
}

//获取好友数量
- (void)requestGetFriendsNums
{
    [self showProgressHUD:@"加载中..." toView:self.view];
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"friends" forKey:@"mod"];
    [parametersDict setObject:@"friends_get_friendsnums" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] forKey:@"uid"];
    [postDict setObject:@"1" forKey:@"is_myfriends"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        //        [_table doneLoadingTableViewData];
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            
            int friendsCount = [[responseObject objectForKey:@"data"] intValue];
            [self requestGetMyfriends:friendsCount];
            
        } else {
            
        }
        
    } failure:^(id error) {
        
        
    }];
}

//获取好友列表
- (void)requestGetMyfriends:(int)friendsCount
{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"friends" forKey:@"mod"];
    [parametersDict setObject:@"friends_get_myfriends_all" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] forKey:@"uid"];
    [postDict setObject:@"0" forKey:@"start"];
    [postDict setObject:[NSString stringWithFormat:@"%d",friendsCount] forKey:@"nums"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        //        [_table doneLoadingTableViewData];
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        
        if (iRetcode == 1) {
            
            NSDictionary *dataDict = [responseObject objectForKey:@"data"];
            for (NSString *key in dataDict) {
                NSDictionary *dict = [dataDict objectForKey:key];
                if (dict.count > 2) {
                    //把上个页面有的人去掉
                    BOOL have = NO;
                    for (int i = 0; i<self.oldMemberArray.count; i++) {
                        NSDictionary *oldDict = self.oldMemberArray[i];
                        if ([oldDict[@"uid"] intValue] == [dict[@"uid"] intValue]) {
                            have = YES;
                            break;
                        }
                    }
                    if (!have) {
                        JYCreatGroupFriendModel *friendModel = [[JYCreatGroupFriendModel alloc] initWithDataDic:dict];
                        [friendModel setAvatar:dict[@"avatars"][@"100"]];
                        [friendModel setFriendUid:dict[@"uid"]];
                        [friendModel setRelation:@"1"];
                        [_friendsList addObject:friendModel];
                    }
                }
            }
            
            
            [self handleFriendsList];
            
            [_table reloadData];
            [self dismissProgressHUDtoView:self.view];
            
        } else {
            
        }
        
    } failure:^(id error) {
        [self dismissProgressHUDtoView:self.view];
        
    }];
}


#pragma -mark 保存
- (void)saveBtnClick:(UIButton *)btn
{
    NSLog(@"保存");
    if (_selectedFriendsList.count>0) {
        [self InviteFriendJoinGroup];
//        点击添加
    } else {
        [[JYAppDelegate sharedAppDelegate] showTip:@"还没选择好友"];
    }
}

- (void)InviteFriendJoinGroup{
    
    [self showProgressHUD:@"加载中..." toView:self.view];
    
    NSString *oids = @"";
    for (int i = 0; i<_selectedFriendsList.count; i++) {
        JYCreatGroupFriendModel *model = _selectedFriendsList[i];
        oids = [oids stringByAppendingString:[NSString stringWithFormat:@"%@,",model.friendUid]];
        if (i==_selectedFriendsList.count-1) {
            oids = [oids substringToIndex:oids.length-1];
        }
    }
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"chat" forKey:@"mod"];
    [parametersDict setObject:@"invite_friend_join_group" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:oids forKey:@"oids"];
    [postDict setObject:[NSNumber numberWithInt:[self.groupId intValue]] forKey:@"group_id"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            //把_selectedFriendsList里的model 转化成 dict回掉
            NSMutableArray *friendList = [[NSMutableArray alloc]initWithCapacity:10];
            for (int i = 0; i<_selectedFriendsList.count; i++) {
                JYCreatGroupFriendModel *friendModel = _selectedFriendsList[i];
                NSDictionary *dict = [JYCreatGroupFriendModel ModelToDict:friendModel];
                [friendList addObject:dict];
            }
            self.finishBlock(friendList);
            [self backAction];
        }else{
            [[JYAppDelegate sharedAppDelegate] showTip:[responseObject objectForKey:@"retmean"]];
        }
        [self dismissProgressHUDtoView:self.view];
        
    } failure:^(id error) {
        
        NSLog(@"%@", error);
        [self dismissProgressHUDtoView:self.view];
    }];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedFriendsList.count >= 99) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"已达到人数上限"];
        return;
    }
    JYCreatGroupFriendCell * tempCell = (JYCreatGroupFriendCell *)[tableView cellForRowAtIndexPath:indexPath];
    JYCreatGroupFriendModel *friendModel = _friendsList[indexPath.section][indexPath.row];
    friendModel.image = tempCell.avatarView.image;
    if (friendModel.isSelected) {
        friendModel.isSelected = NO;
        [_selectedFriendsList removeObject:friendModel];
    } else {
        friendModel.isSelected = YES;
        [_selectedFriendsList addObject:friendModel];
    }
    
    NSLog(@"%lu", (unsigned long)_selectedFriendsList.count);
    [_table reloadData];
    [self updateSelectedCountLab];
}


#pragma mark - UITableViewDataSource

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _indexArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _indexArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [[self.friendsList objectAtIndex:section] count];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    [headerView setBackgroundColor:[JYHelpers setFontColorWithString:@"edf1f4"]];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth-30, 20)];
    //    lab.backgroundColor = [UIColor grayColor];
    lab.text = [_indexArray objectAtIndex:section];
    lab.textColor = [UIColor darkTextColor];
    [headerView addSubview:lab];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"JYCreatGroupFriendCell";
    
    JYCreatGroupFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[JYCreatGroupFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    JYCreatGroupFriendModel *friendModel = _friendsList[indexPath.section][indexPath.row];
    [cell layoutWithModel:friendModel];
    
    return cell;
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

@end
