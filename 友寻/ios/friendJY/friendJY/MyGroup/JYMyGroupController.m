//
//  JYMyGroupController.m
//  friendJY
//
//  Created by 高斌 on 15/4/14.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYMyGroupController.h"
#import "JYHttpServeice.h"
#import "JYMyGroupModel.h"
#import "JYMyGroupCell.h"
#import "JYChatController.h"

@interface JYMyGroupController ()

@end

@implementation JYMyGroupController{
    NSMutableArray *_groupList;
    NSMutableArray *_recommendGroupList;
    UITableView *_table;
    NSMutableArray *_totalGroupList;//只针对推荐 好友有用
    int page;//点击刷新计算页数
    
    int isNill;//判断两个接口都没有数据
    
    NSIndexPath *haveSeleIndexpath;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"我的群组"];
        page = 0;
        isNill = 0;
        _groupList = [[NSMutableArray alloc] init];
        _recommendGroupList = [NSMutableArray array];
        _totalGroupList = [NSMutableArray array];
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kExitGroupSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kMyGroupEnjoinSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGroupSettingRefreshAvatarNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)GroupSettingRefreshAvatar:(NSNotification *)not{
    JYMyGroupCell *cell = (JYMyGroupCell *)[_table cellForRowAtIndexPath:haveSeleIndexpath];
    [cell RefreshLogoImage:not.object];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitGroupSuccess:) name:kExitGroupSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EnjoinSuccessBtnClick:) name:kMyGroupEnjoinSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GroupSettingRefreshAvatar:) name:kGroupSettingRefreshAvatarNotification object:nil];
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavigationBarHeight ) style:UITableViewStylePlain];
    [_table setRowHeight:65];
    [_table setBackgroundColor:[UIColor clearColor]];
    [_table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_table setDelegate:self];
    [_table setDataSource:self];
    [self.view addSubview:_table];
    
    [self requestFriendsGetGroupList];
    [self requestGetRecommendGroupList];
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

#pragma mark - notification

- (void)exitGroupSuccess:(NSNotification *)notification
{
    NSString *group_id = [notification.userInfo objectForKey:@"group_id"];
    for (int i=0; i<_groupList.count; i++) {
        JYMyGroupModel *groupModel = _groupList[i];
        if ([groupModel.group_id isEqualToString:group_id]) {
            
            [_groupList removeObject:groupModel];
            break;
        }
    }
    
    [_table reloadData];
}

#pragma mark - request

- (void)requestFriendsGetGroupList
{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"chat" forKey:@"mod"];
    [parametersDict setObject:@"group_list" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] forKey:@"uid"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            NSArray *dataList = [responseObject objectForKey:@"data"];
            
            for (NSDictionary *dict in dataList) {
                
                JYMyGroupModel *groupModel = [[JYMyGroupModel alloc] initWithDataDic:dict];
                groupModel.isRecommand = @"0"; //普通群组
                [_groupList addObject:groupModel];
            }
            
            [_table reloadData];
            
            isNill++;
            if (isNill==2 && _groupList.count==0 && _totalGroupList.count == 0) {
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"暂无群组" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            }
        } else {
            
        }
        
    } failure:^(id error) {
        
        
    }];
}

- (void)requestGetRecommendGroupList
{
    [self showProgressHUD:@"数据加载中" toView:self.view];
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"chat" forKey:@"mod"];
    [parametersDict setObject:@"recommend_group_list" forKey:@"func"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:nil httpMethod:@"POST" success:^(id responseObject) {
        [self dismissProgressHUDtoView:self.view];
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            
            NSArray *dataList = [responseObject objectForKey:@"data"];
            [_totalGroupList removeAllObjects];
            for (NSDictionary *dict in dataList) {
                
                JYMyGroupModel *groupModel = [[JYMyGroupModel alloc] initWithDataDic:dict];
                groupModel.isRecommand = @"1";  //推荐群组
                [_totalGroupList addObject:groupModel];
            }
            [self countRecommendList];
            [_table reloadData];
            
            isNill++;
            if (isNill==2 && _groupList.count==0 && _totalGroupList.count == 0) {
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"暂无群组" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            }
        } else {
            [self dismissProgressHUDtoView:self.view];
        }
        
    } failure:^(id error) {
        
        
    }];
}

#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _groupList.count;
    }
    
    return _recommendGroupList.count;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(_recommendGroupList.count > 0){ //有推荐数据，显示2段
        return  2;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"JYMyGroupCell";
    
    JYMyGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[JYMyGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    JYMyGroupModel *groupModel;
    if (indexPath.section == 0) {
        groupModel= _groupList[indexPath.row];
    }else{
        groupModel= _recommendGroupList[indexPath.row];
    }
    
    [cell layoutWithModel:groupModel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        haveSeleIndexpath = indexPath;
        JYChatController *chatController = [[JYChatController alloc] init];
        [chatController setIsGroupChat:YES];
        [chatController setFromGroupModel:_groupList[indexPath.row]];
        [self.navigationController pushViewController:chatController animated:YES];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    int sectionH = 0;
    if (section == 1 && _recommendGroupList.count > 0) {
        sectionH = 40.0;
    }
    return sectionH;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionHeader = [[UIView alloc] initWithFrame:CGRectZero];
    sectionHeader.clipsToBounds = YES;
    if (section == 1) {
        sectionHeader.frame = CGRectMake(0, 0, kScreenWidth, 40);
        sectionHeader.backgroundColor = [JYHelpers setFontColorWithString:@"#edf1f4"];
        
        UILabel *ctitle = [[UILabel alloc] initWithFrame:CGRectMake(15,10,200,20)];
        
        [ctitle setTextColor:kTextColorGray];
        [ctitle setFont:[UIFont systemFontOfSize:16.0f]];
        ctitle.text = @"群组推荐";
        [sectionHeader addSubview:ctitle];
        
        if(_totalGroupList.count > 2){
            UIButton *refresh = [UIButton buttonWithType:UIButtonTypeCustom];
            refresh.frame = CGRectMake(kScreenWidth -60, 10, 40, 20);
            refresh.backgroundColor = [UIColor clearColor];
            refresh.titleLabel.font = [UIFont systemFontOfSize:14.0];
            [refresh setTitle:@"刷新" forState:UIControlStateNormal];
            [refresh setTitleColor:kTextColorBlue forState:UIControlStateNormal];
            [refresh addTarget:self action:@selector(myRefreshBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [sectionHeader addSubview:refresh];
        }
    }
    return sectionHeader;
}

- (void) myRefreshBtnClick{
    [self requestGetRecommendGroupList];
}

- (void) countRecommendList{
    if (_totalGroupList.count > 0) {
        [_recommendGroupList removeAllObjects];
        int i = arc4random()%_totalGroupList.count;
        NSLog(@"rand_num:%d",i);
        [_recommendGroupList addObject:[_totalGroupList objectAtIndex:i]];
        if (i+1 == _totalGroupList.count) { //i是最后一个，i+1大于数组，则跳回第0个
            [_recommendGroupList addObject:[_totalGroupList objectAtIndex:0]];
        }else{
            [_recommendGroupList addObject:[_totalGroupList objectAtIndex:i+1]];
        }
    }
}

- (void) EnjoinSuccessBtnClick:(NSNotification *)noti{
    [self showProgressHUD:@"数据发送中" toView:self.view];
    NSDictionary *uinfo = noti.userInfo;
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"chat" forKey:@"mod"];
    [parametersDict setObject:@"add_group" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:[uinfo objectForKey:@"group_id"] forKey:@"group_id"];
    [postDict setObject:[uinfo objectForKey:@"touid"] forKey:@"touid"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        [self dismissProgressHUDtoView:self.view];
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            switch ([[[responseObject objectForKey:@"data"] objectForKey:@"result"]  intValue]) {
                case -1:
                    [[JYAppDelegate sharedAppDelegate] showTip:@"禁止加入"];
                    break;
                case 1:
                    [[JYAppDelegate sharedAppDelegate] showTip:@"恭喜，加入成功"];
                    break;
                case 2:
                    [[JYAppDelegate sharedAppDelegate] showTip:@"请等待群主审核"];
                    break;
                case 3:
                    [[JYAppDelegate sharedAppDelegate] showTip:@"该群已申请过"];
                    break;
            }
            [self requestGetRecommendGroupList];
        } else {
            
        }
        
    } failure:^(id error) {
        
        
    }];
    
}
@end
