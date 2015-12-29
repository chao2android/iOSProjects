//
//  JYSaveGroupController.m
//  friendJY
//
//  Created by 高斌 on 15/3/12.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYSaveGroupController.h"
#import "JYSaveGroupFriendCell.h"
#import "JYSaveGroupUpdateCell.h"
#import "JYCreatGroupFriendModel.h"
#import "JYHttpServeice.h"
#import "JYAppDelegate.h"
#import "JYManageFriendData.h"
#import "JYFriendGroupModel.h"

@interface JYSaveGroupController ()<JYBaseTextFieldDelegate,UIAlertViewDelegate>
{
    UIButton *cancleBtn;
    BOOL isEdited;
}
@property (nonatomic, strong) UILabel *memberCountLab;
//本来的成员
@property (nonatomic, strong) NSMutableArray *lastMemberList;
//要删除的成员数组
//@property (nonatomic, strong) NSMutableArray *deleteMemberList;

@property (nonatomic, assign) BOOL canDelete;

@end

@implementation JYSaveGroupController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"编辑分组"];
        _membersList = [NSMutableArray array];
//        _groupInfo = [NSMutableArray array];
//        _deleteMemberList = [NSMutableArray array];
        _canDelete = NO;
        isEdited = NO;
    }
    
    return self;
}
- (void)keyboardWillShow{
    [[UIApplication sharedApplication].keyWindow addSubview:cancleBtn];
}
- (void)keyboardWillHidden{
    [cancleBtn removeFromSuperview];
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden) name:UIKeyboardWillHideNotification object:nil];
    
    [self layoutSubviews];
    if (self.groupEditType == JYFriendGroupEditTypeCreate) {
        [self setTitle:@"创建分组"];
    }else{
        _lastMemberList = [NSMutableArray array];
        [self loadMembersData];//获取分组下用户信息
    }

    //返回
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.backgroundColor = [UIColor clearColor];
//    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    backBtn.frame = CGRectMake(0, 0, 60, 44);
//    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = backBarBtn;
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

#pragma mark - gesture && action

- (void)backAction{
    if (![_groupNameTF.text isEqualToString:_groupInfo.group_name] || isEdited) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"保存本次编辑吗?" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"保存", nil];
        [alertView show];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//保存
- (void)saveGroup{
    //创建分组
    if (self.groupEditType == JYFriendGroupEditTypeCreate) {
        if (_groupNameTF.text.length < 1) {
            [[JYAppDelegate sharedAppDelegate] showTip:@"请输入分组名"];
            return;
        }
        [self showProgressHUD:@"保存中..." toView:self.view];
        
        //判断是否有选择好友
        NSMutableString *fuidStr = [NSMutableString string];
        for (JYCreatGroupFriendModel *model in _membersList) {
            [fuidStr appendFormat:@",%@",model.friendUid];
        }
        //当没有需要添加的好友时直接返回
        if (fuidStr.length == 0) {
            [self dismissProgressHUDtoView:self.view];
            [[JYAppDelegate sharedAppDelegate] showTip:@"没有选择好友，保存不成功"];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        //*************************//
        
        NSDictionary *paraDic = @{@"mod":@"friends",
                                  @"func":@"friends_create_group"
                                  };
        NSDictionary *postDic = @{@"uid":ToString([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]),
                                  @"group_name":_groupNameTF.text
                                  };
        [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
            NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
            if (iRetcode == 1) {
                JYFriendGroupModel *model = [[JYFriendGroupModel alloc] init];
                [model setGroup_id:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"group_id"]]];
                [model setGroup_name:_groupNameTF.text];
                self.groupInfo = model;
                [[JYManageFriendData sharedInstance] addAGroupIntoGroupList:model];
                
                [self requestAddMembersToGroup:[[responseObject objectForKey:@"data"] objectForKey:@"group_id"]];
            }
        } failure:^(id error) {
            [self dismissProgressHUDtoView:self.view];
            [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        //编辑分组 包括添加成员和修改分组名字
    }else{
        
//        [_membersList removeObjectsInArray:_lastMemberList];
        if ([_groupInfo.group_name isEqualToString:_groupNameTF.text]) {
            [self requestDeleteMembersInGroup];
        }else{
            NSDictionary *paraDic = @{@"mod":@"friends",
                                      @"func":@"friends_mod_group"
                                      };
            NSDictionary *postDic = @{@"uid":ToString([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]),
                                      @"group_id":_groupInfo.group_id,
                                      @"group_name":_groupNameTF.text
                                      };
            [self showProgressHUD:@"保存中..." toView:self.view];
            [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
                NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
                if (iRetcode == 1) {
                    
                    [[JYManageFriendData sharedInstance] modifyGroupNameWithGroupID:_groupInfo.group_id andGroupName:_groupNameTF.text];
                    [self requestDeleteMembersInGroup];
                    
                }
            } failure:^(id error) {
                [self dismissProgressHUDtoView:self.view];
            }];
        }
        
    }
}


#pragma mark - subviews

- (void)layoutSubviews{
    UIButton *createGroupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [createGroupBtn setFrame:CGRectMake(0, 0, 65, 44)];
    [createGroupBtn setTitle:@"保存" forState:UIControlStateNormal];
    [createGroupBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [createGroupBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
    [createGroupBtn setTitleColor:kTextColorBlue forState:UIControlStateNormal];
    [createGroupBtn addTarget:self action:@selector(saveGroup) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:createGroupBtn]];
//    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveGroup)]];
    
    UIView *sectionGroupName = [[UIView alloc] initWithFrame:CGRectMake(-1, 34, kScreenWidth+2, 44)];
    [sectionGroupName.layer setBorderColor:[[JYHelpers setFontColorWithString:@"#cccccc"] CGColor]];
    [sectionGroupName.layer setBorderWidth:1];
    [sectionGroupName setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:sectionGroupName];
    //分组名
    CGSize size = [JYHelpers getTextWidthAndHeight:@"分组名" fontSize:15];
    UILabel *groupNameLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, size.width, 44)];
    [groupNameLab setBackgroundColor:[UIColor clearColor]];
    [groupNameLab setFont:[UIFont systemFontOfSize:15.0f]];
    [groupNameLab setTextColor:[JYHelpers setFontColorWithString:@"#848484"]];
    [groupNameLab setText:@"分组名"];
    [sectionGroupName addSubview:groupNameLab];
    
    _groupNameTF = [[JYBaseTextField alloc] initWithFrame:CGRectMake(groupNameLab.right+5, groupNameLab.top, kScreenWidth-groupNameLab.right-15-5, 44)];
    [_groupNameTF setBackgroundColor:[UIColor clearColor]];
    //    [_groupNameTF setPlaceholder:@"请输入分组名"];
    [_groupNameTF setReturnKeyType:UIReturnKeyDone];
    [_groupNameTF setTextColor:[JYHelpers setFontColorWithString:@"#303030"]];
    [_groupNameTF setBaseDelegate:self];
    [_groupNameTF setLimitedLength:14];
    [_groupNameTF setFont:[UIFont systemFontOfSize:15.0f]];
    [_groupNameTF setPlaceholder:@"分组名为1~14个字符"];
    if (self.groupEditType != JYFriendGroupEditTypeCreate) {
        [_groupNameTF setText:_groupInfo.group_name];
    }
    [sectionGroupName addSubview:_groupNameTF];
    
    UIView *sectionMember = [[UIView alloc] initWithFrame:CGRectMake(0, sectionGroupName.bottom + 22, kScreenWidth, 30)];
    [sectionMember setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:sectionMember];
    
    UIView *line_1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    [line_1.layer setBorderWidth:1];
    [line_1.layer setBorderColor:[[JYHelpers setFontColorWithString:@"#cccccc"] CGColor]];
    [sectionMember addSubview:line_1];
    _memberCountLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 6, 120, 24)];
    [_memberCountLab setTextColor:[JYHelpers setFontColorWithString:@"#848484"]];
    [_memberCountLab setFont:[UIFont systemFontOfSize:15]];
    [_memberCountLab setText:[NSString stringWithFormat:@"成员（%ld）",(long)_membersList.count]];
    
    [sectionMember addSubview:_memberCountLab];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(50, 70)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, sectionMember.bottom, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavigationBarHeight-sectionMember.bottom) collectionViewLayout:flowLayout];
    [_collectionView setContentInset:UIEdgeInsetsMake(5, 19, 0, 19)];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    [_collectionView registerClass:[JYSaveGroupFriendCell class] forCellWithReuseIdentifier:@"JYSaveGroupFriendCell"];
    [_collectionView registerClass:[JYSaveGroupUpdateCell class] forCellWithReuseIdentifier:@"JYSaveGroupUpdateCell"];
    [self.view addSubview:_collectionView];
    
    //[self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgClicked)]];
    cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.backgroundColor = [UIColor clearColor];
    [cancleBtn addTarget:self action:@selector(bgClicked) forControlEvents:UIControlEventTouchUpInside];
    cancleBtn.frame = [UIApplication sharedApplication].keyWindow.bounds;
}


- (void)bgClicked{
    
    [_groupNameTF resignFirstResponder];
}
#pragma mark - request
- (void)loadMembersData{
    [self showProgressHUD:@"加载中..." toView:self.view];
    NSDictionary *paraDic = @{@"mod":@"friends",
                              @"func":@"friends_get_groupmembers"
                              };
    NSDictionary *postDic =@{@"uid":ToString([[NSUserDefaults standardUserDefaults]objectForKey:@"uid"]),
                             @"group_id":_groupInfo.group_id,
                             @"start":@"0",
                             @"nums":_groupInfo.member_nums
                             };
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        [self dismissProgressHUDtoView:self.view];
        if (iRetcode == 1) {
            NSDictionary *dataDic = [responseObject objectForKey:@"data"];
            for (NSString *key in dataDic.allKeys) {
                JYCreatGroupFriendModel *model = [[JYCreatGroupFriendModel alloc] initWithDataDic:dataDic[key]];
                [model setAvatar:[[[dataDic objectForKey:key] objectForKey:@"avatars"] objectForKey:@"100"]];
                [_membersList addObject:model];
            }
            //方便对比
            [_lastMemberList addObjectsFromArray:_membersList];
            [_memberCountLab setText:[NSString stringWithFormat:@"成员（%ld）",(long)_membersList.count]];
            [_collectionView reloadData];
        }else{
        
        }
    } failure:^(id error) {

        [self dismissProgressHUDtoView:self.view];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];

    }];

}
//添加成员
- (void)requestAddMembersToGroup:(NSString*)group_id{

    NSDictionary *paraDic = @{@"mod":@"friends",
                              @"func":@"friends_add_groupmember"
                              };
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    NSString *p_uid = ToString([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]);
    [postDic setObject:p_uid forKey:@"uid"];
    [postDic setObject:group_id forKey:@"group_id"];
    
    NSMutableString *fuidStr = [NSMutableString string];
    
    //新增成员
    NSMutableArray *newMembers = [NSMutableArray arrayWithArray:_membersList];
    [newMembers removeObjectsInArray:_lastMemberList];
    
    for (JYCreatGroupFriendModel *model in newMembers) {
        [fuidStr appendFormat:@",%@",model.friendUid];
    }
    
//    fuidStr = ;

    //当没有需要添加的好友时直接返回
    if (fuidStr.length == 0) {
        [self dismissProgressHUDtoView:self.view];
        if (_groupEditType == JYFriendGroupEditTypeCreate) {
            [[JYAppDelegate sharedAppDelegate] showTip:@"请选择好友"];
            return;
        }else{
//            [[JYAppDelegate sharedAppDelegate] showTip:@"删除成功"];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }

    [postDic setObject:[fuidStr substringFromIndex:1] forKey:@"fuid_arr"];
    
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            [[JYManageFriendData sharedInstance] addMemberInGroupWithGroupID:_groupInfo.group_id withMemberCount:newMembers.count];
            [self dismissProgressHUDtoView:self.view];
            [self.navigationController popViewControllerAnimated:YES];
//            [[JYAppDelegate sharedAppDelegate] showTip:@"添加成功!"];
            
        }else{
//            [[JYAppDelegate sharedAppDelegate] showTip:@"添加失败!"];
        }
    } failure:^(id error) {
        [self dismissProgressHUDtoView:self.view];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];
}
//删除成员
- (void)requestDeleteMembersInGroup{
    
    NSMutableArray *deleteMembers = [NSMutableArray arrayWithArray:_lastMemberList];
    [deleteMembers removeObjectsInArray:_membersList];
    if (deleteMembers.count == 0) {
        //当前组内没有好友 的容错
        if (_membersList.count == 0) {
//            [[JYManageFriendData sharedInstance] removeAGroupWithGroupID:_groupInfo.group_id];
            [[JYManageFriendData sharedInstance] removeAGroupInSever:_groupInfo.group_id];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self requestAddMembersToGroup:_groupInfo.group_id];
        }
        return;
    }
    //删除计数
    __block NSInteger count = 0;
    for (JYCreatGroupFriendModel *friendModel in deleteMembers) {
//        if ([_lastMemberList containsObject:friendModel]) {
            //删除之前分组内的好友 删除当前数组里的 并且删除服务器上的
//            [_lastMemberList removeObject:friendModel];
        NSDictionary *paraDic = @{@"mod":@"friends",
                                  @"func":@"friends_rem_groupmember"
                                  };
        NSDictionary *postDic = @{@"uid":ToString([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]),
                                  @"fuid":friendModel.friendUid,
                                  @"group_id":_groupInfo.group_id
                                  };
        [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
            NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
            if (iRetcode == 1) {
                //do any addtion here...
                [[JYManageFriendData sharedInstance] deleteMemberInGroupWithGroupID:_groupInfo.group_id];
                NSLog(@"删除成功")
                count ++;
                if (count == deleteMembers.count) {
                    [self requestAddMembersToGroup:_groupInfo.group_id];
//                    [self dismissProgressHUDtoView:self.view];
//                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        } failure:^(id error) {
            [self dismissProgressHUDtoView:self.view];
            [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        }];
//        }
    }
//    JYCreatGroupFriendModel *friendModel = [_membersList objectAtIndex:index];
    
    //    //新添加的删除 和删除之前成员都需要执行
//    [_membersList removeObject:friendModel];
//    [_memberCountLab setText:[NSString stringWithFormat:@"成员（%ld）",(long)_membersList.count]];
//    [_collectionView reloadData];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {//保存
        [self saveGroup];
    }else{//放弃
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)showPromptTip:(NSString *)tip{
    [[JYAppDelegate sharedAppDelegate] showPromptTip:tip withTipCenter:CGPointMake(kScreenWidth/2, kScreenHeight/2-30)];
}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if (textField.text.length + string.length > 14 && string.length != 0) {
//        return NO;
//    }
//    return YES;
//}
#pragma mark - UICollectionViewDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _membersList.count+2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.membersList.count) {
        JYSaveGroupFriendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JYSaveGroupFriendCell" forIndexPath:indexPath];
        JYCreatGroupFriendModel *friendModel = (JYCreatGroupFriendModel *)[_membersList objectAtIndex:indexPath.row];
        [cell layoutWithFriendModel:friendModel];
        if (_canDelete) {
            [cell.deleteFlag setHidden:NO];
        }
        return cell;
        
    } else {
        JYSaveGroupUpdateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JYSaveGroupUpdateCell" forIndexPath:indexPath];
        if (indexPath.row == self.membersList.count) {
            [cell.avatarView setImage:[UIImage imageNamed:@"find_group_add_member"]];
            [cell.titleLab setText:@"添加"];
            [cell.titleLab setTextColor:[JYHelpers setFontColorWithString:@"#2695ff"]];
        }else{
            [cell.avatarView setImage:[UIImage imageNamed:@"find_groupmember_delete"]];
            [cell.titleLab setText:@"删除"];
            [cell.titleLab setTextColor:[UIColor redColor]];
        }
        return cell;
    }
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == self.membersList.count) {
        if ([_groupNameTF isFirstResponder]) {
            [_groupNameTF resignFirstResponder];
        }
        JYManageFirendController *selectVC = [[JYManageFirendController alloc] init];
        selectVC.delegate = self;
        [selectVC setSelectMembers:self.membersList];
        [selectVC setType:JYFriendManageTypeSelect];
        [self.navigationController pushViewController:selectVC animated:YES];
    }else if (indexPath.row == self.membersList.count+1){
        _canDelete = !_canDelete;
        if ([_groupNameTF isFirstResponder]) {
            [_groupNameTF resignFirstResponder];
        }
        [_collectionView reloadData];
    }else if (_canDelete){
    //将要删除的成员添加到数组
        [self deleteMemberToDeleteList:indexPath.row];
    }
}
#pragma mark - UICollectionViewDelegateFlowLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

#pragma mark - JYSelectFriendDelegate

- (void)confirmBtnActionWithFriendList:(NSMutableArray *)friendList
{
    //已经选择进组的好友不会显示在选择好友界面上  所以直接添加进当前组就行，并且不需要过滤
    [_membersList addObjectsFromArray:friendList];
    isEdited = YES;
    [_memberCountLab setText:[NSString stringWithFormat:@"成员（%ld）",(long)_membersList.count]];
    [_collectionView reloadData];
}
#pragma mark - setter && getter
- (void)deleteMemberToDeleteList:(NSInteger)index{
    
    isEdited = YES;
    JYCreatGroupFriendModel *friendModel = [_membersList objectAtIndex:index];
    
    [_membersList removeObject:friendModel];
    [_memberCountLab setText:[NSString stringWithFormat:@"成员（%ld）",(long)_membersList.count]];
    [_collectionView reloadData];
}

@end
