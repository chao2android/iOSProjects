//
//  JYBlackListController.m
//  friendJY
//
//  Created by chenxiangjing on 15/4/3.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYBlackListController.h"
#import "JYBlackListCell.h"
#import "JYHttpServeice.h"
#import "JYBlackSelectController.h"
#import "JYCreatGroupFriendModel.h"
#import "ChineseString.h"
#import "JYAppDelegate.h"

@interface JYBlackListController ()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *noListLab;
}

@property (nonatomic, strong) NSMutableArray *sourceDataArr;

@property (nonatomic, strong) UITableView *tableView;
//黑名单
@property (nonatomic, strong) NSMutableArray *friendList;

@property (nonatomic, strong) NSMutableArray *nameList;

@property (nonatomic, strong) NSMutableArray *indexArr;

@end

@implementation JYBlackListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"黑名单"];
    _friendList = [NSMutableArray array];
    _nameList = [NSMutableArray array];
    _indexArr = [NSMutableArray array];
    _sourceDataArr = [NSMutableArray array];
    [self initTableView];
    [self loadBlackList];
    UIButton *createGroupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [createGroupBtn setFrame:CGRectMake(0, 0, 65, 44)];
    [createGroupBtn setTitle:@"添加成员" forState:UIControlStateNormal];
    [createGroupBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [createGroupBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
    [createGroupBtn setTitleColor:kTextColorBlue forState:UIControlStateNormal];
    [createGroupBtn addTarget:self action:@selector(addMemberToBlackList) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:createGroupBtn]];

//    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"添加成员" style:UIBarButtonItemStylePlain target:self action:@selector(addMemberToBlackList)]];
    // Do any additional setup after loading the view.
    
}
- (void)initTableView{
    
    noListLab = [[UILabel alloc] initWithFrame:CGRectMake(0,(kScreenHeight - kNavigationBarHeight - kStatusBarHeight -kTabBarViewHeight - 20)/2, kScreenWidth, 20)];
//    [noListLab setNumberOfLines:2];
    [noListLab setTextColor:kTextColorGray];
    [noListLab setTextAlignment:NSTextAlignmentCenter];
    [noListLab setText:@"暂无黑名单"];
    [noListLab setFont:[UIFont systemFontOfSize:14]];
    [noListLab setHidden:YES];
    [self.view addSubview:noListLab];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setRowHeight:44.0f];
    [_tableView setTableFooterView:[[UIView alloc] init]];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    
//    [_tableView setBackgroundColor:[UIColor colorWithRed:240./255. green:240./255. blue:245./255. alpha:1]];
    [self.view addSubview:_tableView];
    
}
#pragma mark - myRequest
//黑名单
- (void)loadBlackList{
    [self showProgressHUD:@"加载中..." toView:self.view];
    NSDictionary *paraDic = @{@"mod":@"relation",
                              @"func":@"get_black_list"
                              };
    NSDictionary *postDic = @{@"uid":ToString([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]),
                              @"page":@"1",
                              @"nums":@"50"
                              };
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        [self dismissProgressHUDtoView:self.view];
        if (iRetcode == 1) {
            //do any addtion here...
            if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                [noListLab setHidden:NO];
                [self.view bringSubviewToFront:noListLab];
                return;
            }
            if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dataDic =  [responseObject objectForKey:@"data"];
                NSMutableArray *dataArr = [NSMutableArray array];
                for (NSString *key in dataDic.allKeys) {
                    NSDictionary *dic = [dataDic objectForKey:key];
                    JYCreatGroupFriendModel *model = [[JYCreatGroupFriendModel alloc] initWithDataDic:dic];
                    [model setAvatar:[[dic objectForKey:@"avatars"] objectForKey:@"200"]];
                    [model setMutualNums:[NSString stringWithFormat:@"%@",[dic objectForKey:@"mutualmus"]]];
                    [dataArr addObject:model];
                }
                [self setSourceDataArr:dataArr];
//                [self setFriendList:dataArr];
                [self handleFriendsList];
            }
        }
    } failure:^(id error) {
        [self dismissProgressHUDtoView:self.view];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];
}
- (void)addMemberToBlackList{
    
    JYBlackSelectController *blackSelectVC = [[JYBlackSelectController alloc] init];
    [blackSelectVC setSelectMembers:_friendList];
    [blackSelectVC setSelectDone:^(NSArray *list) {
        [_sourceDataArr addObjectsFromArray:list];
        [noListLab setHidden:YES];
        [self handleFriendsList];
    }];
    [self.navigationController pushViewController:blackSelectVC animated:YES];
//    manageFrdVC s
}

- (void)removeFriendFormList:(JYCreatGroupFriendModel*)model{
//    public array( del_black_list(int uid, int fuid)
//                 从黑名单中删除
//                 Parameters:
//                 uid - 自己UID
//                 fuid - 页数
//                 Returns:
//                 "retcode":1(参数编号), "retmean":"参数含义", "data":boolean
    NSDictionary *paraDic = @{@"mod":@"relation",
                              @"func":@"del_black_list"
                              };
    NSDictionary *postDic = @{@"uid":ToString([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]),
                              @"fuid":model.friendUid
                              };
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        [self dismissProgressHUDtoView:self.view];
        if (iRetcode == 1) {
            //do any addtion here...
            [_sourceDataArr removeObject:model];
            if ([_sourceDataArr count] == 0) {
                [noListLab setHidden:NO];
            }
            [self handleFriendsList];
            [[JYAppDelegate sharedAppDelegate] showTip:@"删除成功"];
            
        }
    } failure:^(id error) {
        [self dismissProgressHUDtoView:self.view];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];
}
#pragma mark - DataHandler
- (void)handleFriendsList
{
    //过滤
    
    //筛选完成之后刷新 好友数量
    [_nameList removeAllObjects];
    [_indexArr removeAllObjects];
    
    //    NSLog(@"%@",_friendList)
    //    NSLog(@"%@",_friendList)
    for (JYCreatGroupFriendModel *friendModel in _sourceDataArr)
    {
        [_nameList addObject:friendModel.nick];
    }
    
    [self setIndexArr:[ChineseString indexArray:_nameList]];
    [self setNameList:[ChineseString returnSortChineseArrar:_nameList]];
    [self sortFriendsList];
}

- (void)sortFriendsList
{
    [_friendList removeAllObjects];
    _friendList = nil;
    _friendList = [NSMutableArray arrayWithArray:_sourceDataArr];
//    [self setFriendList:_sourceDataArr];
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
    
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource&&UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ((NSArray*)self.friendList[section]).count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.friendList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   static NSString *cellID = @"cellID";
    JYBlackListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[JYBlackListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell layoutSubviewsWithModel:self.friendList[indexPath.section][indexPath.row]];
    //    分隔线
//    if (indexPath.row == ((NSArray*)self.friendList[indexPath.section]).count - 1) {
//        
//    }else{
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15.0, 43, kScreenWidth - 15.0, 1.0)];
//        [line setBackgroundColor:[UIColor lightGrayColor]];
//        [cell addSubview:line];
//    }
    return cell;
}
//配置页头
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
    return 22.0;
}
//配置索引
- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return _indexArr;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self removeFriendFormList:_friendList[indexPath.section][indexPath.row]];
    }
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
