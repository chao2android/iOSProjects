//
//  JYShareToMyFriendController.m
//  friendJY
//
//  Created by chenxiangjing on 15/4/27.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYShareToMyFriendController.h"
#import "JYManageFriendData.h"
#import "JYHttpServeice.h"
#import "JYCreatGroupFriendModel.h"
#import "JYFriendGroupModel.h"
#import "ChineseString.h"
#import "JYShareToFriendCell.h"
#import "JYAppDelegate.h"
#import "JYAddFriendController.h"

@interface JYShareToMyFriendController ()<UITableViewDataSource,UITableViewDelegate>
{
//    UILabel *friendCountLab;
//    UIButton *groupBtn;
    NSMutableArray *groupList;
    UIView *haveNoFriendBg;
    NSMutableArray *_selectedListArr;
    __block NSInteger sendCount;
//    UILabel *groupLab;
//    JYSelectedFriendAvatarView *selectAvatarView;

}
@property (nonatomic, strong) NSMutableArray *friendList;
@property (nonatomic, strong) NSMutableArray *nameList;
@property (nonatomic, strong) NSMutableArray *indexArr;
@property (nonatomic, strong) UITableView *table;
@end

@implementation JYShareToMyFriendController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"分享给好友"];
        
        //        _friendList = [[NSMutableArray alloc] init];
        _nameList = [[NSMutableArray alloc] init];
        _indexArr = [[NSMutableArray alloc] init];
        //        groupList = [[NSMutableArray alloc] init];
        //        numOfGetMutualNum = 0;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubviews];
    [self initHaveNoFriendView];
    _friendList = [NSMutableArray array];
    _selectedListArr = [NSMutableArray array];
    [self loadFriendDataWithNum:300];
    
//        if ([JYManageFriendData sharedInstance].groupListArr.count > 0) {
//            NSLog(@"=======================")
//            NSLog(@"本地读取好友分组数据！")
//            NSLog(@"=======================")
//            groupList = [NSMutableArray arrayWithArray:[JYManageFriendData sharedInstance].groupListArr];
//        }else{
//            NSLog(@"=======================")
//            NSLog(@"网络下载好友分组数据！")
//            NSLog(@"=======================")
//            groupList = [NSMutableArray array];
//            [self loadGroupData];
//        }
    
}
- (void)loadGroupData{
    
//    NSDictionary *paraDic = @{@"mod":@"friends",
//                              @"func":@"friends_get_grouplist"
//                              };
//    NSString *uid = ToString([[NSUserDefaults standardUserDefaults] stringForKey:@"uid"]);
//    NSDictionary *postDic = @{@"uid":uid};
//    
//    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
//        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
//        if (iRetcode == 1) {
//            NSArray *dataArr = [responseObject objectForKey:@"data"];
//            for (NSArray *arr in dataArr) {
//                JYFriendGroupModel *model = [JYFriendGroupModel groupModelWithDataArr:arr];
//                [groupList addObject:model];
//            }
//            [[JYManageFriendData sharedInstance] setGroupListArr:groupList];
//        }
//    } failure:^(id error) {
//        [self dismissProgressHUDtoView:self.view];
//        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
//    }];
    
}
//获取一度好友列表
- (void)loadFriendDataWithNum:(NSInteger)num{
    [self showProgressHUD:@"加载中..." toView:self.view];
    NSDictionary *paraDic = @{@"mod":@"friends",
                              @"func":@"friends_get_myfriends_all"
                              };
    
    NSDictionary *postDic = @{@"uid":ToString([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]),
                              @"start":@"0",
                              @"nums":[NSString stringWithFormat:@"%ld",(long)num]
                              };
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        [self dismissProgressHUDtoView:self.view];
        if (iRetcode == 1) {
            NSLog(@"成功获取一度好友信息")
            if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dataDic = [responseObject objectForKey:@"data"];
                NSMutableArray *mobileFriendArr = [NSMutableArray array];
                for (NSString *key in dataDic.allKeys) {
                    if([dataDic[key] count] > 3){
                        JYCreatGroupFriendModel *model = [[JYCreatGroupFriendModel alloc] initWithDataDic:dataDic[key]];
                        [model setAvatar:dataDic[key][@"avatars"][@"100"]];
                        if (![JYHelpers isEmptyOfString:model.friendUid]) {
                            [_friendList addObject:model];
                        }
                    }else{
                        [mobileFriendArr addObject:dataDic[key]];
                    }
                }
                [[JYManageFriendData sharedInstance] setFriendList:_friendList];
                [[JYManageFriendData sharedInstance] setMobileFriendList:mobileFriendArr];
                [self handleFriendsList];
 
            }else if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSArray class]]){
                [haveNoFriendBg setHidden:NO];
            }
            [self dismissProgressHUDtoView:self.view];
        }
    } failure:^(id error) {
        [self dismissProgressHUDtoView:self.view];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];
}

- (void)handleFriendsList
{
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

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 60, 40)];
    [button setTitleColor:kTextColorBlue forState:UIControlStateNormal];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [button addTarget:self action:@selector(cancelShare) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:leftBarItem];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 60, 40)];
    [rightButton setTitleColor:kTextColorBlue forState:UIControlStateNormal];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [rightButton addTarget:self action:@selector(shareToFriend) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightButtonBarItem];

//    [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(cancelShare)
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavigationBarHeight) style:UITableViewStylePlain];
    [_table setRowHeight:44];
    [_table setBackgroundColor:[UIColor clearColor]];
    //    [_table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_table setDelegate:self];
    [_table setDataSource:self];
    [self.view addSubview:_table];
    [_table setTableFooterView:[[UIView alloc] init]];
    
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
//没有好友时添加好友
- (void)addFriendAction{
    JYAddFriendController *addController = [[JYAddFriendController alloc] init];
    [self.navigationController pushViewController:addController animated:YES];
}

- (void)cancelShare{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareToFriend{
    if (_selectedListArr.count == 0) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"请先选择好友"];
        return;
    }
    sendCount = 0;
    [self showProgressHUD:@"发送中..." toView:self.view];
    for (JYCreatGroupFriendModel *model in _selectedListArr) {
        //    public array() send_text_msg(json form)
        //    发送一条文本聊天信息
        //Parameters:
        //    form - touid 接收人id content 聊天内容
        
        if (_isShareImage){
            [self shareImageToFriendWithFriendUID:model.friendUid];
        }else{
            [self shareTextToFriendWithFriendUID:model.friendUid];
        }
    }
//    [self.navigationController popViewControllerAnimated:YES];

}
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
    static NSString *cellID = @"JYShareToFriendCell";
    JYShareToFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[JYShareToFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    JYCreatGroupFriendModel *friendModel = [((NSArray*)[_friendList objectAtIndex:indexPath.section]) objectAtIndex:indexPath.row];
    [cell layoutSubviewsWithData:_friendList[indexPath.section][indexPath.row]];

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
    
    JYShareToFriendCell *cell = (JYShareToFriendCell*)[tableView cellForRowAtIndexPath:indexPath];
    JYCreatGroupFriendModel *model = [_friendList objectAtIndex:indexPath.section][indexPath.row];
    
    if (cell.selectView.hidden) {//选中
        //        CGRect frame = bgView.frame;
        [_selectedListArr addObject:model];
        //            [_selectedListArr addObject:indexPath];
        [UIView animateWithDuration:.3 animations:^{
            [cell.personInfoBg setFrame:CGRectMake(15+17, 0, kScreenWidth, 44)];
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
            [cell.personInfoBg setFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        }];
    }
}
#pragma mark - 发送分享信息
//发送文字信息
- (void)shareTextToFriendWithFriendUID:(NSString*)uid{
    
    NSDictionary *paraDic = @{@"mod":@"chat",
                              @"func":@"send_text_msg"
                              };
    NSDictionary *formDic = @{
                              @"touid":uid,
                              @"content":_shareContent
                              };
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:formDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *postDic = @{
                              @"form":jsonStr
                              };
    
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
//        [self dismissProgressHUDtoView:self.view];
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            //do any addtion here...
            sendCount ++;
            if (sendCount == _selectedListArr.count) {
                [self dismissProgressHUDtoView:self.view];
                [[JYAppDelegate sharedAppDelegate] showTip:@"发送成功！"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    } failure:^(id error) {
        [self dismissProgressHUDtoView:self.view];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];
}
//发送图片信息
- (void)shareImageToFriendWithFriendUID:(NSString*)uid{
    
//    [self showProgressHUD:@"发送中..." toView:self.view];
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"chat" forKey:@"mod"];
    [parametersDict setObject:@"send_pic_msg" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:uid forKey:@"touid"];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:UIImagePNGRepresentation(_shareImage) forKey:@"upload"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict dataDict:dataDict formDict:nil success:^(id responseObject) {
//        [self dismissProgressHUDtoView:self.view];
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
    
        NSLog(@"%@", [responseObject objectForKey:@"retmean"]);
        
        if (iRetcode == 1) {
            sendCount ++;
            if (sendCount == _selectedListArr.count) {
                [self dismissProgressHUDtoView:self.view];
                [[JYAppDelegate sharedAppDelegate] showTip:@"发送成功！"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } else {
            [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        }
//        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } failure:^(id error) {
        [self dismissProgressHUDtoView:self.view];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
//        [self.navigationController popViewControllerAnimated:YES];

    }];

}

@end







