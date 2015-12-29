//
//  JYFeedPromissionController.m
//  
//
//  Created by ouyang on 4/23/15.
//
//

#import "JYFeedPromissionController.h"
#import "JYHttpServeice.h"
#import "JYAppDelegate.h"
#import "JYFeedPromissionCell.h"
#import "JYFeedGroupController.h"
#import "JYManageFriendData.h"
#import "JYFriendGroupController.h"
#import "JYFriendGroupModel.h"

@implementation JYFeedPromissionController{
    NSMutableArray * dataArr;
    UITableView * myTable;
    BOOL isExpandGroup;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"查看权限"];
        
    }
    
    return self;
}
- (void)initDataArr{
    [dataArr removeAllObjects];
    dataArr = nil;
    dataArr = [NSMutableArray array] ;
    JYFriendGroupModel *model1 = [[JYFriendGroupModel alloc] init];
    [model1 setGroup_id:@"0"];
    [model1 setGroup_name:@"所有好友"];
    [model1 setSelected:YES];
    [model1 setMember_nums:@"0"];

    JYFriendGroupModel *model2 = [[JYFriendGroupModel alloc] init];
    [model2 setGroup_id:@"0"];
    [model2 setGroup_name:@"指定分组"];
    [model2 setSelected:0];
    [model2 setMember_nums:@"0"];

    [dataArr addObject:model1];
    [dataArr addObject:model2];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    isExpandGroup = YES;
    //右上角添加动态
    UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navRightBtn.backgroundColor = [UIColor clearColor];
    [navRightBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [navRightBtn setTitleColor:[JYHelpers setFontColorWithString:@"#2695ff"] forState:UIControlStateNormal];
    [navRightBtn setTitle:@"设置分组" forState:UIControlStateNormal];
    [navRightBtn setFrame:CGRectMake(0, 0, 75, 20)];
    [navRightBtn addTarget:self action:@selector(_clickRightTopButton) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:navRightBtn]];
    
    
    
    
    myTable =  [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight)];
    myTable.delegate = self;
    myTable.dataSource = self;
    [myTable setBackgroundColor:[UIColor clearColor]];
    [myTable setTableFooterView:[[UIView alloc] init]];
    [self.view addSubview:myTable];
    
    [self initDataArr];
    [self _getFriendGroups];
    

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void) dealloc {
    
}

- (void) backAction{

    NSMutableArray * mStr = [NSMutableArray array];
    NSMutableArray * mTitleStr = [NSMutableArray array];
    for (int i = 2 ; i<dataArr.count; i++) {
        if ([(JYFriendGroupModel*)dataArr[i] selected]) {
            [mStr addObject:((JYFriendGroupModel*)dataArr[i]).group_id];
            [mTitleStr addObject:((JYFriendGroupModel*)dataArr[i]).group_name];
        }
    }
    //过滤什么都没选的情况
    if (mStr.count == 0 && ((JYFriendGroupModel*)dataArr[0]).selected == NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请至少选择一个选项！" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kFeedSetPromissionNotification object:nil userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:[mStr componentsJoinedByString:@","],@"groupId",[mTitleStr componentsJoinedByString:@","],@"title",nil]];
    
    [super backAction];

}

- (void)_clickRightTopButton{
    JYFriendGroupController * _groupVC = [[JYFriendGroupController alloc] init];
    _groupVC.backBlock = ^{
        [self initDataArr];
        [self _getFriendGroups];
    };
    [self.navigationController pushViewController:_groupVC animated:YES];
}

- (void) _getFriendGroups{
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"friends" forKey:@"mod"];
    [parametersDict setObject:@"friends_get_grouplist" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] forKey:@"uid"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        [self dismissProgressHUDtoView:self.view];
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1 && [[responseObject objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
            
            for (NSArray *arr in [responseObject objectForKey:@"data"]) {
                    JYFriendGroupModel *model = [JYFriendGroupModel groupModelWithDataArr:arr];
                    [dataArr addObject:model];
            }
            NSMutableArray *groupList = [NSMutableArray arrayWithArray:dataArr];
            [groupList removeObjectAtIndex:0];
            [groupList removeObjectAtIndex:0];
            [[JYManageFriendData sharedInstance] setGroupListArr:groupList];
            [myTable reloadData];
        } else {
            [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        }
        
    } failure:^(id error) {
        
        NSLog(@"%@", error);
        
    }];
}
#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isExpandGroup) {
        return dataArr.count;
    }else{
        return  2;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *reuseIdetify = @"SvTableViewCell";
    JYFeedPromissionCell *cell = [[JYFeedPromissionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.mydata = [dataArr objectAtIndex:indexPath.row];
    cell.cRow = indexPath.row;
    cell.isExpand = isExpandGroup;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JYFriendGroupModel *group = [dataArr objectAtIndex:indexPath.row];
        
    if (group.selected == NO) {//当前未选择
       [group setSelected:YES];

        if (indexPath.row == 0 && dataArr.count > 2) { //全部时，取消其它对勾
            for (int i = 2; i<dataArr.count; i++) {
                JYFriendGroupModel *model = [dataArr objectAtIndex:i];
                [model setSelected:NO];
            }
        }
        //点击分组是 设置所有分组不选择
        if (indexPath.row >= 2) {
            [((JYFriendGroupModel*)dataArr[0]) setSelected:NO];
        }
    }else{//当前已选择
        [(JYFriendGroupModel*)dataArr[indexPath.row] setSelected:NO];
    }
    //点击展开分组
    if(indexPath.row == 1){
        if (isExpandGroup) {
            isExpandGroup = NO;
        }else{
            isExpandGroup = YES;
        }
    }
    
    [tableView reloadData];
//    NSString *msg = [[NSString alloc] initWithFormat:@"你选择的是:%@",[dataArr objectAtIndex:[indexPath row]] ];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alert show];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
@end
