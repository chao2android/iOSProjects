//
//  JYPhoneContactsController.m
//  friendJY
//
//  Created by 高斌 on 15/3/9.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYPhoneContactsController.h"
#import "JYShareData.h"
#import "JYPhoneContactsModel.h"
#import "ChineseString.h"
#import "JYHttpServeice.h"
#import "JYContactSearchView.h"
#import "JYContactNameCollectionView.h"

@interface JYPhoneContactsController ()<JYContactSearchViewDelegate>
{
    JYContactSearchView *_searchView;
}
@property (nonatomic, strong) NSArray *indexArray;
@property (nonatomic, strong) NSArray *phoneContactsArray;

@property (nonatomic, strong) NSMutableArray *sourceArr;

@property (nonatomic, strong) JYContactNameCollectionView *nameCollectionView;

@end

@implementation JYPhoneContactsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        [self setTitle:@"手机联系人"];
        _selectedContactsIndexList = [[NSMutableArray alloc] init];

    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    if (!_isUpList) {
//        [self setTitle:@"同步通讯录"];
//        [self initIsUpListNo];
//    }else{
    [self setTitle:@"手机联系人"];
    _sourceArr = [NSMutableArray array];
    [self handleContactsList];
    [self initIsUpListYes];
    [self initSearchView];
    
}
- (void)initSearchView{
    
    _searchView = [[JYContactSearchView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [_searchView setDelegate:self];
    [[JYAppDelegate sharedAppDelegate].window addSubview:_searchView];
    [_searchView setHidden:YES];
    
}
//已上传通讯录则这样初始化
- (void)initIsUpListYes{
    UIView *searchBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    [searchBg setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:searchBg];
    //searchBar 设置为button  因为点击以后回显示新图层
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn.layer setCornerRadius:5];
    [searchBtn.layer setMasksToBounds:YES];
    [searchBtn setFrame:CGRectMake(10, 5, kScreenWidth - 20, 30)];
    [searchBtn setTitle:@"搜索:输入姓名或手机号" forState:UIControlStateNormal];
    [searchBtn setTitleColor:kTextColorGray forState:UIControlStateNormal];
    [searchBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [searchBtn addTarget:self action:@selector(intoSearchView) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setBackgroundColor:[JYHelpers setFontColorWithString:@"#edf1f4"]];
    [searchBg addSubview:searchBtn];

    
    UIView *line_1 = [[UIView alloc] initWithFrame:CGRectMake(0, searchBg.bottom, kScreenWidth, 1)];
    [line_1.layer setBorderColor:[[JYHelpers setFontColorWithString:@"#cccccc"] CGColor]];
    [line_1.layer setBorderWidth:1];
    [self.view addSubview:line_1];
    
    UIView *promptView = [[UIView alloc] initWithFrame:CGRectMake(0, line_1.bottom, kScreenWidth, 40)];
    [promptView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:promptView];
    UILabel *promptLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, 40)];
    [promptLab setText:@"选择你要邀请的好友"];
    [promptLab setFont:[UIFont systemFontOfSize:14.0f]];
    [promptLab setTextColor:[JYHelpers setFontColorWithString:@"#848484"]];
    [promptView addSubview:promptLab];
    UIButton *chooseAll = [UIButton buttonWithType:UIButtonTypeSystem];
    [chooseAll setTitle:@"全选" forState:UIControlStateNormal];
    [chooseAll setFrame:CGRectMake(kScreenWidth - 15 - 40, 0, 40, 40)];
    [chooseAll.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [chooseAll addTarget:self action:@selector(chooseAllAction) forControlEvents:UIControlEventTouchUpInside];
    [promptView addSubview:chooseAll];
    
    UIView *line_2 = [[UIView alloc] initWithFrame:CGRectMake(0, promptView.bottom - 1, kScreenWidth, 1)];
    [line_2.layer setBorderColor:[[JYHelpers setFontColorWithString:@"#cccccc"] CGColor]];
    [line_2.layer setBorderWidth:1];
    [self.view addSubview:line_2];
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, promptView.bottom, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavigationBarHeight-kTabBarViewHeight-promptView.bottom) style:UITableViewStylePlain];
    [_table setRowHeight:44];
    [_table setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_table setDelegate:self];
    [_table setDataSource:self];
    [self.view addSubview:_table];
    [_table setTableFooterView:[[UIView alloc] init]];
    
    UIImageView *selectedNameBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, _table.bottom, kScreenWidth, kTabBarViewHeight)];
    [selectedNameBg setUserInteractionEnabled:YES];
    [selectedNameBg setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:selectedNameBg];
    
//    _selectedNameLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth-80-15, kTabBarViewHeight)];
//    //    [_selectedNameLab setBackgroundColor:[UIColor whiteColor]];
//    [_selectedNameLab setFont:[UIFont systemFontOfSize:15.0f]];
//    //    [_selectedNameLab setNumberOfLines:0];
//    //    [_selectedNameLab sizeToFit];
//    [_selectedNameLab setTextColor:[JYHelpers setFontColorWithString:@"#2695ff"]];
//    [selectedNameBg addSubview:_selectedNameLab];
    
    _nameCollectionView = [[JYContactNameCollectionView alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth-80-15, kTabBarViewHeight)];
//    [_nameCollectionView setBackgroundColor:[UIColor orangeColor]];
    [selectedNameBg addSubview:_nameCollectionView];
    
    _inviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_inviteBtn setFrame:CGRectMake(_nameCollectionView.right, 0, 80, kTabBarViewHeight)];
    //    [_inviteBtn setBackgroundColor:[UIColor greenColor]];
    [_inviteBtn setTitle:@"邀请" forState:UIControlStateNormal];
    [_inviteBtn setBackgroundImage:[UIImage imageNamed:@"find_contact_btnBg"] forState:UIControlStateNormal];
    [_inviteBtn setBackgroundImage:[UIImage imageNamed:@"check_selected"] forState:UIControlStateDisabled];
    [_inviteBtn addTarget:self action:@selector(inviteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_inviteBtn setEnabled:NO];
    [selectedNameBg addSubview:_inviteBtn];
    
    UIView *line_3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    [line_3.layer setBorderColor:[[JYHelpers setFontColorWithString:@"#cccccc"] CGColor]];
    [line_3.layer setBorderWidth:1];
    [selectedNameBg addSubview:line_3];

}
//点击链接通讯录
- (void)upContactList{

}
//没有上传通讯录的关闭按钮点击事件
- (void)closeContactsUp{
    [self.navigationController popViewControllerAnimated:YES];
}
//全选点击事件
- (void)chooseAllAction{
    

    if (_selectedContactsIndexList.count != self.friendNum) {
        [_selectedContactsIndexList removeAllObjects];
        for (int i = 0; i < _indexArray.count; i ++) {
            for (int j = 0; j < ((NSArray*)_phoneContactsArray[i]).count; j ++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                UITableViewCell *cell = [_table cellForRowAtIndexPath:indexPath];
                UIButton *btn = (UIButton*)[cell.contentView viewWithTag:102];
                [btn setSelected:YES];
                [_selectedContactsIndexList addObject:[[_phoneContactsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
            }
        }
    }else{
        for (int i = 0; i < _indexArray.count; i ++) {
            for (int j = 0; j < ((NSArray*)_phoneContactsArray[i]).count; j ++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                UITableViewCell *cell = [_table cellForRowAtIndexPath:indexPath];
                UIButton *btn = (UIButton*)[cell.contentView viewWithTag:102];
                [btn setSelected:NO];
            }
        }
        [_selectedContactsIndexList removeAllObjects];
    }
    [self relayoutSelectedNameLab];
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
//获取通讯录
- (void)handleContactsList
{
//    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    
//    [JYShareData sharedInstance].contactsList;
    
//    NSMutableArray *nameList = [[NSMutableArray alloc] init];
//    
//    for (NSDictionary *contactDict in [JYShareData sharedInstance].contactsList)
//    {
//        [nameList addObject:[contactDict objectForKey:@"name"]];
//    }
//    
//    NSLog(@"%@", [JYShareData sharedInstance].contactsList);
//
//    [self setIndexArray:[ChineseString indexArray:nameList]];
//    [self setPhoneContactsArray:[ChineseString letterSortArray:nameList]];
    
//    [self showProgressHUD:@"加载中..." toView:self.view];
    NSDictionary *paraDic = @{@"mod":@"friends",
                              @"func":@"friends_get_myfriends"
                              };
    NSDictionary *postDic = @{@"uid":ToString([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]),
                              @"is_reg":@"0",
                              @"start":@"0",
                              @"nums":[NSString stringWithFormat:@"%ld",(long)self.friendNum]
                              };
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            //do any addtion here...
//                NSMutableArray *resultList = [[NSMutableArray alloc] init];
            
//                [JYShareData sharedInstance].contactsList;
            if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                NSMutableArray *nameList = [[NSMutableArray alloc] init];
                NSMutableArray *handledStringArr = [NSMutableArray array];

                for (NSDictionary *contactDict in [responseObject objectForKey:@"data"])
                {
//                    NSMutableArray *nameArr = [NSMutableArray array];
                    
                        NSString *name = @"No name";
                        NSString *mobile = [contactDict objectForKey:@"mobile"];
                        
                        if (![mobile isEqualToString:@""]) {
                            
                            if (![[contactDict objectForKey:@"truename"] isKindOfClass:[NSString class]]) {
                                [nameList addObject:@"Noname"];
                            }else{
                                [nameList addObject:[contactDict objectForKey:@"truename"]];
                                name = nameList.lastObject;
                            }
                            
                            [handledStringArr addObject:@{@"truename":name,@"mobile":mobile}];
                            JYPhoneContactsModel *model = [[JYPhoneContactsModel alloc] init];
                            [model setName:name];
                            [model setMobile:mobile];
                            [_sourceArr addObject:model];
                        }
                        //        [nameArr addObject:[dic objectForKey:@"truename"]];
                    
                }
                [_searchView setContactsList:_sourceArr];
                [self setIndexArray:[ChineseString indexArray:nameList]];
                [self setPhoneContactsArray:[ChineseString letterSortContactArray:handledStringArr]];
                [_table reloadData];
//                [self dismissProgressHUDtoView:self.view];
            }
        }
//        [self dismissProgressHUDtoView:self.view];

    } failure:^(id error) {
//        [self dismissProgressHUDtoView:self.view];

    }];
    
}
//刷新已选列表lab显示
- (void)relayoutSelectedNameLab
{
    NSMutableString *nameListStr = [[NSMutableString alloc] init];

    for (int i = 0; i < _selectedContactsIndexList.count; i ++) {
        JYPhoneContactsModel *phoneContactsModel = (JYPhoneContactsModel*)_selectedContactsIndexList[i];

        if (i == _selectedContactsIndexList.count - 1) {
            [nameListStr appendFormat:@"%@", phoneContactsModel.name];
        }else{
            [nameListStr appendFormat:@"%@,", phoneContactsModel.name];
        }
        
    }
  
    [_nameCollectionView relayoutLabelWithStr:nameListStr];
    
    NSString *inviteBtnTitle = [NSString stringWithFormat:@"邀请(%ld)", (long)_selectedContactsIndexList.count];
    if (_selectedContactsIndexList.count == 0) {
        [_inviteBtn setEnabled:NO];
    }else{
        [_inviteBtn setEnabled:YES];
    }
    [_inviteBtn setTitle:inviteBtnTitle forState:UIControlStateNormal];
}
//邀请按钮点击事件
- (void)inviteBtnClick:(UIButton *)btn
{
    NSMutableArray *selectedContactsPhoneList = [[NSMutableArray alloc] init];
    for (JYPhoneContactsModel *phoneContactsModel in _selectedContactsIndexList) {
        
        [selectedContactsPhoneList addObject:phoneContactsModel.mobile];
    }
    if (![MFMessageComposeViewController canSendText]) {
        return;
    }
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    controller.recipients = selectedContactsPhoneList;
    controller.body = [NSString stringWithFormat:@"快来【友寻】和我一起认识更多靠谱的朋友，朋友的朋友一秒变好友。和朋友的朋友谈恋爱，顺手解救身边的单身朋友，变身朋友圈丘比特。http://m.iyouxun.com/wechat/friend_invite/?uid=%@",ToString([SharedDefault objectForKey:@"uid"])];
    controller.messageComposeDelegate = self;
    [self presentViewController:controller animated:YES completion:^{
        
        //nothing
    }];
}
//进入搜索图层
- (void)intoSearchView{
    if (_sourceArr.count == 0) {
        return;
    }
    
    [_searchView setHidden:NO];
    [_searchView beginEdit];
}
//- (void)dealloc{
//    UIView *view = [self.navigationController.view viewWithTag:1234];
//    if (view) {
//        [view removeFromSuperview];
//    }
//}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.indexArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.phoneContactsArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        [selectBtn setBackgroundImage:[UIImage imageNamed:@"set_choose"] forState:UIControlStateSelected];
        [selectBtn setTag:102];
        [selectBtn setFrame:CGRectMake(kScreenWidth - 20 - 17, (44 - 14)/2, 13, 14)];
        [cell.contentView addSubview:selectBtn];
    }
    
//    UIImageView *iconImage = (UIImageView *)[cell.contentView viewWithTag:100];
//    UILabel *titleLab = (UILabel *)[cell.contentView viewWithTag:101];
    UIButton *selectBtn = (UIButton *)[cell.contentView viewWithTag:102];

    JYPhoneContactsModel *phoneContactsModel = (JYPhoneContactsModel *)[[self.phoneContactsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cell.textLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@", phoneContactsModel.name]];
//    [cell.textLabel setFrame:CGRectMake(iconImage.right+5, 12, kScreenWidth-100, 20)];
    
//    [selectBtn setFrame:CGRectMake(titleLab.right+5, 12, 20, 20)];
    BOOL isSelected = NO;
    for (JYPhoneContactsModel *phoneModel in _selectedContactsIndexList) {
        if ([phoneModel.mobile isEqualToString:phoneContactsModel.mobile]) {
            
            isSelected = YES;
            break;
        }
    }
    [selectBtn setSelected:isSelected];

    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _indexArray;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    JYPhoneContactsModel *phoneContactModel = (JYPhoneContactsModel*)[[_phoneContactsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    UIButton *selectBtn = (UIButton *)[cell.contentView viewWithTag:102];

    if (selectBtn.selected) {
        
        [selectBtn setSelected:NO];
        for (JYPhoneContactsModel *phoneModel in _selectedContactsIndexList) {
            if ([phoneModel.mobile isEqualToString:phoneContactModel.mobile]) {
                
                [_selectedContactsIndexList removeObject:phoneModel];
                
                break;
            }
        }
        
    } else {
        
        [selectBtn setSelected:YES];
        [_selectedContactsIndexList addObject:phoneContactModel];
        
    }
    
    [self relayoutSelectedNameLab];
}
#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    
    switch (result) {
        case MessageComposeResultCancelled:
        {
            NSLog(@"取消发送");
        }
            break;
        case MessageComposeResultFailed:
        {
            NSLog(@"发送失败");
        }
            break;
        case MessageComposeResultSent:
        {
            NSLog(@"发送成功");
        }
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        //nothing
    }];
}
#pragma mark - JYContactSearchViewDelegate
- (void)contactSearchView:(JYContactSearchView *)contactsView didFinishedSearchWithContactsModel:(JYPhoneContactsModel *)contact{
    BOOL isIn = NO;
    for (JYPhoneContactsModel *model  in _selectedContactsIndexList) {
        if ([model.mobile isEqualToString:contact.mobile]) {
            isIn = YES;
            break;
        }
    }
    if (!isIn) {
        [_selectedContactsIndexList addObject:contact];
        [self relayoutSelectedNameLab];
        [_table reloadData];
    }
    
}

- (void)contactSearchViewShouldCancelSearch:(JYContactSearchView *)contactSearchView{
    [UIView animateWithDuration:.2 animations:^{
        [contactSearchView setAlpha:0];
    } completion:^(BOOL finished) {
        [contactSearchView setHidden:YES];
        [contactSearchView setAlpha:1];
    }];
}

- (void)dealloc{
    [_searchView removeFromSuperview];
    _searchView = nil;
}
//#pragma mark - UISearchBarDelegate
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//    UIView *view = [self.navigationController.view viewWithTag:1234];
//    if (view) {
//        [view removeFromSuperview];
//        view = nil;
//    }
//    view = [self.navigationController.view viewWithTag:4321];
//    if (view) {
//        [view removeFromSuperview];
//        view = nil;
//    }
//
//}
@end
