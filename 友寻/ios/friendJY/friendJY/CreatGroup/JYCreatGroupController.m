//
//  JYCreatGroupController.m
//  friendJY
//
//  Created by 高斌 on 15/4/14.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYCreatGroupController.h"
#import "JYHttpServeice.h"
#import "JYCreatGroupFriendModel.h"
#import "ChineseString.h"
#import "JYCreatGroupFriendCell.h"
#import "JYAppDelegate.h"
#import "JYManageFriendData.h"
#import "JYChatController.h"
#import "JYChatDataBase.h"
#import "JYShareData.h"
#import "UIImageView+WebCache.h"
#import "JYProfileModel.h"

@interface JYCreatGroupController ()

@end

@implementation JYCreatGroupController{
    UIButton *allBtn;
    UIImageView * myavatarImg ;
    JYProfileModel * pmodel;
    UIButton *saveBtn;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"创建群组"];
        
        _friendsList = [[NSMutableArray alloc] init];
        _nameList = [[NSMutableArray alloc] init];
        _selectedFriendsList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
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
    [_selectedCountLab setText:@"群成员上限为100人（1/100）"];

    allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [allBtn setBackgroundColor:[UIColor clearColor]];
    [allBtn setFrame:CGRectMake(kScreenWidth-65, 0, 50, 30)];
    [allBtn setTitleColor:kTextColorBlue forState:UIControlStateNormal];
    [allBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [allBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [allBtn setTitle:@"全选" forState:UIControlStateNormal];
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
    
    if ([JYManageFriendData sharedInstance].friendList.count > 0) {
        NSLog(@"=======================")
        NSLog(@"本地读取好友数据！")
        NSLog(@"=======================")
        _friendsList = [NSMutableArray arrayWithArray:[JYManageFriendData sharedInstance].friendList];
        _friendsCount = _friendsList.count;
        [self handleFriendsList];
    }else{
        NSLog(@"=======================")
        NSLog(@"下载好友数据！")
        NSLog(@"=======================")
        _friendsList = [NSMutableArray array];
        [self requestGetFriendsNums];
    }

    //下载我自已的头像，用于合成群组照片
    pmodel = [JYShareData sharedInstance].myself_profile_model;
    if (![JYHelpers isEmptyOfString:[pmodel.avatars objectForKey:@"150"]]) {
        myavatarImg = [[UIImageView alloc] init];
        myavatarImg.clipsToBounds = YES;
        [myavatarImg sd_setImageWithURL:[NSURL URLWithString:[pmodel.avatars objectForKey:@"150"]]];
    }

}

- (void)dealloc{
    NSLog(@"test");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    [self setFriendsList:resultList];
}

- (void)updateSelectedCountLab
{
    NSString *selectedCountStr = [NSString stringWithFormat:@"群成员上限为100人（%lu/100）", (unsigned long)_selectedFriendsList.count+1];
    [_selectedCountLab setText:selectedCountStr];
}

- (void)allBtnClick:(UIButton *)btn
{

    if (_selectedFriendsList.count == _friendsCount) {
        //取消全选
        NSLog(@"取消全选")
        allBtn.width = 30;
        [allBtn setTitle:@"全选" forState:UIControlStateNormal];
        for (int i=0; i<_selectedFriendsList.count; i++) {
            JYCreatGroupFriendModel *friendModel =_selectedFriendsList[i];
            friendModel.isSelected = NO;
        }
        [_selectedFriendsList removeAllObjects];
    } else {
        //全选
        NSLog(@"全选");
        allBtn.width = 60;
        [allBtn setTitle:@"取消全选" forState:UIControlStateNormal];
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
    
    [_table reloadData];
    [self updateSelectedCountLab];
}

- (void)saveBtnClick:(UIButton *)btn
{
    NSLog(@"保存");
    if (_selectedFriendsList.count>0) {
        saveBtn.enabled = NO;
        [self requestFriendsCreateGroup];
    } else {
        [[JYAppDelegate sharedAppDelegate] showTip:@"还没选择好友"];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - request

//获取好友数量
- (void)requestGetFriendsNums
{
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
            
            _friendsCount = [[responseObject objectForKey:@"data"] integerValue];
            [self requestGetMyfriends];
            
        } else {
            
        }
        
    } failure:^(id error) {
        
        
    }];
}

//获取好友列表
- (void)requestGetMyfriends
{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"friends" forKey:@"mod"];
    [parametersDict setObject:@"friends_get_myfriends_all" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] forKey:@"uid"];
    [postDict setObject:@"0" forKey:@"start"];
    [postDict setObject:[NSString stringWithFormat:@"%ld", (long)_friendsCount] forKey:@"nums"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        //        [_table doneLoadingTableViewData];
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
 
        if (iRetcode == 1) {
            
            NSDictionary *dataDict = [responseObject objectForKey:@"data"];
            for (NSString *key in dataDict) {
                NSDictionary *dict = [dataDict objectForKey:key];
                if (dict.count > 2) {
                    JYCreatGroupFriendModel *friendModel = [[JYCreatGroupFriendModel alloc] initWithDataDic:dict];
                    [friendModel setAvatar:dict[@"avatars"][@"100"]];
                    
                    [_friendsList addObject:friendModel];
                }
            }
            
            [self handleFriendsList];
            
            [_table reloadData];
            
        } else {
            
        }
        
    } failure:^(id error) {
        
        
    }];
}

- (void)requestFriendsCreateGroup
{
    NSMutableString *mStr = [[NSMutableString alloc] initWithFormat:@""];
    NSMutableString *oids = [[NSMutableString alloc] initWithFormat:@""];
    NSMutableArray *imgArr = [NSMutableArray array];
    if (myavatarImg.image != nil) {
        [imgArr addObject:myavatarImg.image];
        [mStr appendFormat:@"%@、", pmodel.nick];
    }
    if (_selectedFriendsList.count>0) {
        int i = 0;
        for (JYCreatGroupFriendModel *friendModel in _selectedFriendsList) {
            [oids appendFormat:@"%@,", friendModel.friendUid];
            [mStr appendFormat:@"%@、", friendModel.nick];
            if (i<4 && friendModel.image != nil) {
                [imgArr addObject:friendModel.image];
                i++;
            }
        }
    }
    if (mStr.length> 14) {
        [mStr setString:[mStr substringToIndex:14]];
    }else{
        [mStr setString:[mStr substringToIndex:mStr.length-1]];
    }
    
    [oids setString:[oids substringToIndex:oids.length-1]];
    
    
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"chat" forKey:@"mod"];
    [parametersDict setObject:@"create_group" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:oids forKey:@"oids"];
    [postDict setObject:mStr forKey:@"title"];
    
    UIImage *image = [self imageMergeToNewOne:imgArr];

    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:imageData forKey:@"upload"];

    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict dataDict:dataDict formDict:nil success:^(id responseObject) {
        saveBtn.enabled = YES;
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1 && [[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
            //保存成功
//            [[JYAppDelegate sharedAppDelegate] showTip:@"保存成功"];
//            [self.navigationController popViewControllerAnimated:YES];
            JYChatController *chatController = [[JYChatController alloc] init];
            JYMyGroupModel *groupModel = [[JYMyGroupModel alloc] init];
            
            JYMessageModel *msgModel = [[JYMessageModel alloc] init];
            msgModel.oid = @"0";
            msgModel.avatar = @"";
            msgModel.content = @"";
            msgModel.hint = @"";
            msgModel.logo = [[responseObject objectForKey:@"data"] objectForKey:@"logo"];
            msgModel.iid = @"";
            msgModel.group_id = [JYHelpers stringValueWithObject:[[responseObject objectForKey:@"data"] objectForKey:@"group_id"]];
            msgModel.msgtype = @"";
            msgModel.newcount = @"";
            msgModel.nick = @"";
            msgModel.sendtime = [JYHelpers currentDateTimeInterval];
            msgModel.sex = @"";
            msgModel.status = @"";
            msgModel.title = mStr;
            
            groupModel.friend_num = @"0";
            groupModel.group_id = [[responseObject objectForKey:@"data"] objectForKey:@"group_id"];
            groupModel.hint = @"0";
            groupModel.intro = @"";
            groupModel.logo = [[responseObject objectForKey:@"data"] objectForKey:@"logo"];
            groupModel.show = @"0";
            groupModel.title = mStr;
            groupModel.total = @"0";
            groupModel.from = @"2"; //2是从创建群组过来的
            [chatController setIsGroupChat:YES];
            [chatController setFromGroupModel:groupModel];
            [self.navigationController pushViewController:chatController animated:YES];
          
            
            [[JYChatDataBase sharedInstance] insertOneUser:msgModel]; //插入本地数据库
//            [[JYShareData sharedInstance].messageUserList addObject:msgModel]; //更新共享数据列表
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshMessageTableViewNotification object:nil userInfo:nil];
        } else {
            [[JYAppDelegate sharedAppDelegate] showTip:@"创建失败"];
        }
        
    } failure:^(id error) {
        
        
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

-(UIImage *)imageMergeToNewOne:(NSArray *) imgArr{
    
    UIGraphicsBeginImageContext(CGSizeMake(100, 100)); //合成的图片尺寸为200x200
    
    switch (imgArr.count) {
        case 1:
        {
            // Draw image2
            [imgArr[0] drawInRect:CGRectMake(25, 25, 50, 50)];
        }
            break;
            
        case 2:
        {
            // Draw image1
            [imgArr[0] drawInRect:CGRectMake(3.3, 27.5, 45, 45)];
            
            // Draw image2
            [imgArr[1] drawInRect:CGRectMake(51.6, 27.5, 45, 45)];
        }
            break;
            
        case 3:
        {
            // Draw image1
            [imgArr[0] drawInRect:CGRectMake(27.5, 3.3, 45, 45)];
            
            // Draw image2
            [imgArr[1] drawInRect:CGRectMake(3.3, 51.6, 45, 45)];
            
            // Draw image2
            [imgArr[2] drawInRect:CGRectMake(51.6, 51.6, 45, 45)];
        }
            break;
            
        default:
        {
            // Draw image1
            [imgArr[0] drawInRect:CGRectMake(3.3, 3.3, 45, 45)];
            
            // Draw image2
            [imgArr[1] drawInRect:CGRectMake(51.6, 3.3, 45, 45)];
            
            // Draw image1
            [imgArr[2] drawInRect:CGRectMake(3.3, 51.6, 45, 45)];
            
            // Draw image2
            [imgArr[3] drawInRect:CGRectMake(51.6, 51.6, 45, 45)];
        }
            break;
    }
    
    [[UIImage imageNamed:@"bg_create_group_avatar"] drawInRect:CGRectMake(0 , 0, 100, 100)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return  resultingImage;
}

@end
