//
//  JYGroupMemberViewController.m
//  friendJY
//
//  Created by aaa on 15/5/28.
//  Copyright (c) 2015年 友寻. All rights reserved.
//

#import "JYGroupMemberViewController.h"
#import "ChineseString.h"
#import "JYCreatGroupFriendCell.h"
#import "JYGroupAddMemberViewController.h"
#import "JYOtherProfileController.h"

@interface JYGroupMemberViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *selectedCountLab;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *nameList;
@property (nonatomic, strong) NSMutableArray *indexArray;
@property (nonatomic, strong) NSMutableArray *friendsList;

@property (nonatomic, copy) NSMutableArray *deleUserArr;

@end

@implementation JYGroupMemberViewController

#pragma -mark viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"群组成员"];
    self.friendsList = [[NSMutableArray alloc]initWithCapacity:10];
    self.nameList = [[NSMutableArray alloc]initWithCapacity:10];
    self.indexArray = [[NSMutableArray alloc]initWithCapacity:10];
    
    _deleUserArr = [[NSMutableArray alloc]init];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setFrame:CGRectMake(0, 0, 65, 44)];
    [saveBtn setTitle:@"添加成员" forState:UIControlStateNormal];
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
    [_selectedCountLab setText:[NSString stringWithFormat:@"群成员上限为100人（%lu/100）",(unsigned long)self.memberData.count]];
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, selectedCountBg.height, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavigationBarHeight-selectedCountBg.height) style:UITableViewStylePlain];
    [_table setRowHeight:44];
    [_table setBounces:YES];
    [_table setBackgroundColor:[UIColor clearColor]];
    [_table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_table setDelegate:self];
    [_table setDataSource:self];
    [self.view addSubview:_table];
    
    [self DataToModel];
    
    [self handleFriendsList];
}
- (void)DataToModel{
    for (int i = 0; i<self.memberData.count; i++) {
        NSDictionary *dataDict = [self.memberData objectAtIndex:i];
        JYCreatGroupFriendModel *friendModel = [[JYCreatGroupFriendModel alloc] initWithDataDic:dataDict];
        [friendModel setAvatar:dataDict[@"avatars"][@"150"]];
        [friendModel setMfriend_num:[dataDict[@"mfriend_num"] intValue]];
        [self.friendsList addObject:friendModel];
    }
}
//
- (void)handleFriendsList
{
    [_nameList removeAllObjects];
    [_indexArray removeAllObjects];
    
    for (JYCreatGroupFriendModel *friendModel in _friendsList)
    {
        if (friendModel.nick.length==0) {
            [_nameList addObject:@"1"];
            friendModel.nick = @"1";
        }else{
            [_nameList addObject:friendModel.nick];
        }
    }
    
    [self setIndexArray:[ChineseString indexArray:_nameList]];
    
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
    
    [self setFriendsList:resultList];
    
    [_table reloadData];
}


- (void)saveBtnClick:(UIButton *)btn
{
    //添加好友
    JYGroupAddMemberViewController *controller = [[JYGroupAddMemberViewController alloc] init];
    controller.oldMemberArray = self.memberData;
    controller.groupId = self.groupId;
    controller.finishBlock = ^(NSMutableArray *haveJionUsers){
        [self addHaveJionUser:haveJionUsers];
        self.addFinishBlock(haveJionUsers);
    };
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)addHaveJionUser:(NSMutableArray *)haveJionUsers
{
    [self.friendsList removeAllObjects];
    //原self.memberData 里加入
    
    NSMutableArray *newMemberData = [[NSMutableArray alloc]init];
    for (int i = 0; i<self.memberData.count; i++) {
        NSDictionary *dict = self.memberData[i];
        [newMemberData addObject:dict];
    }
    for (int i = 0; i<haveJionUsers.count; i++) {
        NSDictionary *dict = haveJionUsers[i];
        [newMemberData addObject:dict];
    }
    
    self.memberData = newMemberData;
    
    for (int i = 0; i<self.memberData.count; i++) {
        NSDictionary *dataDict = [self.memberData objectAtIndex:i];
        JYCreatGroupFriendModel *friendModel = [[JYCreatGroupFriendModel alloc] initWithDataDic:dataDict];
        [friendModel setAvatar:dataDict[@"avatars"][@"150"]];
        [friendModel setMfriend_num:[dataDict[@"mfriend_num"] intValue]];
        [self.friendsList addObject:friendModel];
    }
    [_selectedCountLab setText:[NSString stringWithFormat:@"群成员上限为100人（%lu/100）",(unsigned long)self.friendsList.count]];
    [self handleFriendsList];
}


#pragma mark - UITableViewDel。。e。。。。。gate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JYCreatGroupFriendModel *friendModel = _friendsList[indexPath.section][indexPath.row];
    if(![JYHelpers isEmptyOfString:friendModel.friendUid]){
        JYOtherProfileController * _profileVC = [[JYOtherProfileController alloc] init];
        _profileVC.show_uid =  friendModel.friendUid;
        [self.navigationController pushViewController:_profileVC animated:YES];
    }
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

- (void)backAction{
    [super backAction];
    [_table reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section<_friendsList.count) {
        NSArray *subArr = _friendsList[indexPath.section];
        if (indexPath.row<subArr.count) {
            
            JYCreatGroupFriendModel *model = [subArr objectAtIndex:indexPath.row];
            NSString * myId = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
            return self.isMy && [model.uid intValue]!= [myId intValue];
        }
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSMutableArray *subArr = [_friendsList[indexPath.section] mutableCopy];
        
        JYCreatGroupFriendModel *model = [subArr objectAtIndex:indexPath.row];
        [_deleUserArr addObject:model];
//        
//        [subArr removeObjectAtIndex:indexPath.row];
//        
//        if (subArr.count>0) {
//            [_friendsList replaceObjectAtIndex:indexPath.section withObject:subArr];
//        }
//        else{
//            [_friendsList removeObjectAtIndex:indexPath.section];
//            [_indexArray removeObjectAtIndex:indexPath.section];
//        }
        
        [self DeleteMember:model];
    }
}

- (void)DeleteMember:(JYCreatGroupFriendModel *)model{
    //需要把 服务端 删除
    //需要把上个页面的人数刷新
    //需要把memberData 对应的删除
    
//    首先删除服务端
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"chat" forKey:@"mod"];
    [parametersDict setObject:@"group_master_del_person" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:self.groupId forKey:@"group_id"];
    [postDict setObject:model.uid forKey:@"touid"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        
        if (iRetcode == 1) {
            //需要把memberData 对应的删除
            
            NSMutableArray *muArray = [[NSMutableArray alloc]initWithArray:self.memberData];
            
            
            for (int i = 0; i<muArray.count; i++) {
                NSDictionary *dataDict = [muArray objectAtIndex:i];
                if ([model.uid intValue] == [dataDict[@"uid"] intValue]) {
                    [muArray removeObjectAtIndex:i];
                    break;
                }
            }
            self.memberData = muArray;
            
            [self.friendsList removeAllObjects];
            [self DataToModel];
            [self handleFriendsList];
            
            //刷新上个页面的人数 和 数组里对应的数据
            if (self.deleFinishBlock) {
                self.deleFinishBlock(model);
            }
            
            NSLog(@"--->%lu---->%lu",(unsigned long)_indexArray.count,(unsigned long)[[self.friendsList objectAtIndex:0] count]);
            
            
            [[JYAppDelegate sharedAppDelegate] showTip:@"删除成功"];
        }
        
    } failure:^(id error) {
        
        //失败
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        
    }];
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
