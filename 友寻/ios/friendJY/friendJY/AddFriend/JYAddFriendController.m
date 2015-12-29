//
//  JYAddFriendController.m
//  friendJY
//
//  Created by 高斌 on 15/3/9.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYAddFriendController.h"
#import "JYPhoneContactsController.h"
#import "JYAppDelegate.h"
#import "JYAddSinaFriendController.h"
#import <ShareSDK/ShareSDK.h>
#import "JYHttpServeice.h"
#import <ShareSDK/ShareSDK.h>
#import "JYShareData.h"
#import "JYQRCodeReaderController.h"
#import "JYOtherProfileController.h"
#import "JYAuthInfoModel.h"

@interface JYAddFriendController ()<UIActionSheetDelegate,UIAlertViewDelegate,JYQRCodeReaderControllerDelegate>
{
    UIView *gotoSystemSettringBox;
    NSDictionary *profileDataDic;
    NSMutableArray *authInfoArr;
    BOOL canOper;
    BOOL isFirstTimeLoaded;
}
@property (nonatomic, copy) NSString *codeContent;

@end

@implementation JYAddFriendController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"添加好友"];
//        canOper = YES;
        isFirstTimeLoaded = YES;
        profileDataDic = [JYShareData sharedInstance].myself_profile_dict;
        
    }
    
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    canOper = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.navigationController.viewControllers.count > 2) {
        NSArray *viewControllers = [NSArray arrayWithObjects:self.navigationController.viewControllers[0],self,nil];
        [self.navigationController setViewControllers:viewControllers];
    }
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    [_table setRowHeight:44];
    [_table setBackgroundColor:[UIColor clearColor]];
//    [_table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_table setDelegate:self];
    [_table setScrollEnabled:NO];
    [_table setDataSource:self];
    [self.view addSubview:_table];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(-1, 0, kScreenWidth + 2, 34)];
    headerView.layer.borderWidth = 1;
    headerView.layer.borderColor = [[JYHelpers setFontColorWithString:@"#cccccc"] CGColor];
    headerView.backgroundColor = [UIColor clearColor];
    _table.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] init];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, -1, kScreenWidth, 1)];
    line.layer.borderColor = [[JYHelpers setFontColorWithString:@"#cccccc"] CGColor];
    line.layer.borderWidth = 1;
    [footerView addSubview:line];
    [footerView setBackgroundColor:[UIColor clearColor]];
    _table.tableFooterView = footerView;

    [self requestGetAuthInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadMobileListSuccess) name:kRegisterAndUpMobileListSuccessNotification object:nil];
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
- (void)showPromptBoxView:(BOOL)isEmpty{
    
    [gotoSystemSettringBox removeFromSuperview];
    //大层的，容器
    gotoSystemSettringBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [[JYAppDelegate sharedAppDelegate].window addSubview:gotoSystemSettringBox];
    
    //黑色，80%透明
    UIView * noFriendInviteBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    noFriendInviteBg.backgroundColor = [UIColor blackColor];
    noFriendInviteBg.alpha = 0.8;
    [gotoSystemSettringBox addSubview:noFriendInviteBg];
    
    //要显示的正文内容
    UIView * noFriendInviteShow = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth-270)/2,(kScreenHeight - 330)/2,270 ,330)];
    noFriendInviteShow.backgroundColor = [UIColor whiteColor];
    [gotoSystemSettringBox addSubview:noFriendInviteShow];
    
    //删除不显示
    UIButton *newsDelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [newsDelBtn setFrame:CGRectMake(noFriendInviteShow.right-20,noFriendInviteShow.top-20, 40, 40)];
    [newsDelBtn setImage:[UIImage imageNamed:@"feedGetPhoneClose"] forState:UIControlStateNormal];
    [newsDelBtn addTarget:self action:@selector(closePostView) forControlEvents:UIControlEventTouchUpInside];
    [gotoSystemSettringBox addSubview:newsDelBtn];
    
    //标题蓝色背景
    UIImageView *noFriendTopBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, noFriendInviteShow.width, 45)];
    noFriendTopBg.image = [UIImage imageNamed:@"feedExportPhoneListBg"];
    [noFriendInviteShow addSubview:noFriendTopBg];
    
    //标题
    UILabel *noFriendTopTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, noFriendInviteShow.width, 20)];
    noFriendTopTitle.text = @"同步通讯录";
    noFriendTopTitle.textAlignment = NSTextAlignmentCenter;
    noFriendTopTitle.textColor = [UIColor whiteColor];
    noFriendTopTitle.font = [UIFont systemFontOfSize:16];
    [noFriendInviteShow addSubview:noFriendTopTitle];
    
    UIImageView *noFriendPhoneListIcon = [[UIImageView alloc] initWithFrame:CGRectMake((noFriendInviteShow.width-100)/2, noFriendTopBg.bottom + 25, 100, 100)];
    noFriendPhoneListIcon.image = [UIImage imageNamed:@"feedPhoneListIcon"];
    [noFriendInviteShow addSubview:noFriendPhoneListIcon];
    
    //中间的字
    UILabel *noFriendTopContent = [[UILabel alloc] initWithFrame:CGRectMake(10, noFriendPhoneListIcon.bottom+15, noFriendInviteShow.width-20, 60)];
    if (isFirstTimeLoaded == NO) {
        noFriendTopContent.text = @"更新完成，没有更多好友了。";
    }else if (isEmpty) {
        noFriendTopContent.text = @"没有需要邀请的好友了，请尝试更新通讯录给你带来更多的好友，请确保已打开通讯录权限。";
    }else{
        noFriendTopContent.text = @"友寻需要同步你的通讯录，用来查找您的好友。请放心，友寻不会保存您的任何通讯录资料。";
    }
    noFriendTopContent.textAlignment = NSTextAlignmentLeft;
    noFriendTopContent.textColor = [JYHelpers setFontColorWithString:@"#303030"];
    noFriendTopContent.font = [UIFont systemFontOfSize:14];
    noFriendTopContent.numberOfLines = 0;
    [noFriendInviteShow addSubview:noFriendTopContent];
    
    //蓝色背景-查找通讯好友按钮
    UIButton *noFriendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [noFriendButton setBackgroundImage:[UIImage imageNamed:@"feedExportPhoneListBg"] forState:UIControlStateNormal];
    [noFriendButton setBackgroundColor:[UIColor clearColor]];
    if (!isFirstTimeLoaded) {
        [noFriendButton setTitle:@"确定" forState:UIControlStateNormal];
    }else if (isEmpty) {
        [noFriendButton setTitle:@"立即更新" forState:UIControlStateNormal];
    }else{
        [noFriendButton setTitle:@"查找通讯录好友" forState:UIControlStateNormal];
    }
    [noFriendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [noFriendButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [noFriendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [noFriendButton setFrame:CGRectMake((noFriendInviteShow.width - 250)/2, noFriendTopContent.bottom + 10, 250, 44)];
    noFriendButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    if (isFirstTimeLoaded) {
        [noFriendButton addTarget:self action:@selector(uploadContacts) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [noFriendButton addTarget:self action:@selector(updateFinishedAndNoFriend) forControlEvents:UIControlEventTouchUpInside];
    }
    [noFriendInviteShow addSubview:noFriendButton];
    
}

- (void)showShareWeiChatActionSeet{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信好友",@"微信朋友圈",nil];
    [actionSheet showInView:self.view];
    
}
#pragma mark - click handler && gesture
//关闭提示弹层。
- (void)closePostView{
    canOper = YES;
    [gotoSystemSettringBox removeFromSuperview];
}
- (void)updateFinishedAndNoFriend{
    canOper = YES;
    [self closePostView];
}
//上传通讯录
- (void)uploadContacts{
    
    [self closePostView];
    isFirstTimeLoaded = NO;
    [[JYShareData sharedInstance] upListAndShowProgress:YES];
    
}
//扫描二维码
- (void)codeScanAction{
    
    JYQRCodeReaderController *codeReader = [[JYQRCodeReaderController alloc] init];
    [codeReader setDelegate:self];
    JYNavigationController *nav = [[JYNavigationController alloc] initWithRootViewController:codeReader];
    [self presentViewController:nav animated:YES completion:^{
        
    }];

}
#pragma mark - Notification
//通讯录上传成功 加载通讯录
- (void)uploadMobileListSuccess{
    [self requestGetUploadList];
}
#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 30.0;
    }
    return 0.0;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(-1, 0, kScreenWidth+2, 30)];
        [view setBackgroundColor:[UIColor clearColor]];
        [view.layer setBorderColor:[kTextColorLightGray CGColor]];
        [view.layer setBorderWidth:1.0];
        return view;
    }else return nil;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else return 3;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 6, 30, 30)];
        [iconImage setTag:100];
//        [iconImage setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView addSubview:iconImage];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(iconImage.right+10, 12, 120, 20)];
//        [titleLab setBackgroundColor:[UIColor lightGrayColor]];
        [titleLab setFont:[UIFont systemFontOfSize:15.0f]];
        [titleLab setTextColor:[UIColor blackColor]];
        [titleLab setTextAlignment:NSTextAlignmentLeft];
        [titleLab setTag:101];
        [cell.contentView addSubview:titleLab];
    }
    
    UIImageView *iconImage = (UIImageView *)[cell.contentView viewWithTag:100];
    UILabel *titleLab = (UILabel *)[cell.contentView viewWithTag:101];
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    [titleLab setText:@"添加通讯录好友"];
                    [iconImage setImage:[UIImage imageNamed:@"find_address_book_icon"]];
                }
                    break;
                case 1:
                {
                    [titleLab setText:@"扫描二维码"];
                    [iconImage setImage:[UIImage imageNamed:@"find_qrcode_icon"]];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    [titleLab setText:@"添加微信好友"];
                    [iconImage setImage:[UIImage imageNamed:@"find_weixin_icon"]];

                }
                    break;
                case 1:
                {
                    [titleLab setText:@"添加微博好友"];
                    [iconImage setImage:[UIImage imageNamed:@"find_weibo_icon"]];
                }
                    break;
                case 2:
                {
                    [titleLab setText:@"添加QQ好友"];
                    [iconImage setImage:[UIImage imageNamed:@"find_qq_icon"]];
                }
                    break;
                default:
                    break;
            }
        
        }
            break;
        default:
            break;
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击 %ld",(long)indexPath.row);
    if (!canOper) {
        return;
    }
    NSLog(@"执行 %ld",(long)indexPath.row);
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                canOper = NO;
                
                NSString *uid = [SharedDefault objectForKey:@"uid"];
                
                BOOL isUpList = [SharedDefault boolForKey:[NSString stringWithFormat:@"%@_IsUpList", uid]];
                if (isUpList) {
                    [self requestGetUploadList];
                }else{
                    [self showPromptBoxView:NO];
                }
                //            [self performSelector:@selector(makeCellCanSelected) withObject:nil afterDelay:1.0];
                
            }
                break;
            case 1:{
                //            canOper = NO;
                [self codeScanAction];
            }
                break;
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:
            {
                canOper = NO;
                if (authInfoArr.count > 0) {
                    JYAuthInfoModel *weChatAuth;
                    //                BOOL needAuth = YES;
                    for (JYAuthInfoModel *model in authInfoArr) {
                        if ([model.type integerValue] == 1) {
                            //                        needAuth = NO;
                            weChatAuth = model;
                        }
                    }
                    if (!weChatAuth) {
                        [self bindWithType:ShareTypeWeixiSession];
                    }else{
                        [self showShareWeiChatActionSeet];
                    }
                }else{
                    [self bindWithType:ShareTypeWeixiSession];
                }
            }
                break;
            case 1:
            {
                canOper = NO;
                if (authInfoArr.count > 0) {
                    BOOL needAuth = YES;
                    JYAuthInfoModel *sinaAuth;
                    for (JYAuthInfoModel *model in authInfoArr) {
                        if ([model.type integerValue] == 2) {
                            needAuth = NO;
                            sinaAuth = model;
                        }
                    }
                    if (needAuth) {
                        [self bindWithType:ShareTypeSinaWeibo];
                    }else{
                        JYAddSinaFriendController *sinaFrdVC = [[JYAddSinaFriendController alloc] init];
                        [sinaFrdVC setSinaToken:sinaAuth.token];
                        [sinaFrdVC setSinaUid:sinaAuth.openid];
                        [self dismissProgressHUDtoView:self.view];
                        [self.navigationController pushViewController:sinaFrdVC animated:YES];
                    }
                }else{
                    [self bindWithType:ShareTypeSinaWeibo];
                }
                
                //            [self requestGetAuthInfo];
            }
                break;
            case 2:{
                canOper = NO;
                if (authInfoArr.count > 0) {
                    JYAuthInfoModel *sinaAuth;
                    BOOL needAuth = YES;
                    for (JYAuthInfoModel *model in authInfoArr) {
                        if ([model.type integerValue] == 3) {
                            needAuth = NO;
                            sinaAuth = model;
                        }
                    }
                    if (needAuth) {
                        [self bindWithType:ShareTypeQQSpace];
                    }else{
                        [self shareContentWithShareType:ShareTypeQQ];
                    }
                }else{
                    [self bindWithType:ShareTypeQQSpace];
                }
            }
                break;
            default:
                break;
        }

    }
}
//- (void)makeCellCanSelected{
//    canOper = YES;
//}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    canOper = YES;
    if (buttonIndex == 0) {//微信好友
        [self shareContentWithShareType:ShareTypeWeixiSession];
    }else if (buttonIndex == 1){//微信朋友圈
        [self shareContentWithShareType:ShareTypeWeixiTimeline];
    }
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {//打开
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:_codeContent]]) {
            NSLog(@"content --> %@",_codeContent);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_codeContent]];
        }
    }

}
#pragma mark - JYQRCodeReaderControllerDelegate

- (void)qrCodeReaderDidReadContent:(NSString *)content{
    if (![JYHelpers isEmptyOfString:content]) {
        
        [self setCodeContent:content];
        
        NSRange range = [content rangeOfString:@"uid"];
        if (range.location != NSNotFound) {
            NSString *uid = [content substringFromIndex:range.location + range.length + 1];
            NSLog(@"uid -- > %@",uid);
            JYOtherProfileController *otherVC = [[JYOtherProfileController alloc] init];
            [otherVC setShow_uid:uid];
            [self.navigationController pushViewController:otherVC animated:YES];
        }else{
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"外部链接存在安全隐患，确认打开么？" message:nil delegate:self cancelButtonTitle:@"不打开" otherButtonTitles:@"打开", nil];
            [alertView show];
            
        }
        NSLog(@"=============%@==============",content);
    }else{
    
        [[JYAppDelegate sharedAppDelegate] showTip:@"扫描内容为空"];
    }

}
#pragma mark - request
- (void)requestGetUploadList{

    NSDictionary *paraDic = @{@"mod":@"friends",
                              @"func":@"friends_get_friendsnums"
                              };
    NSDictionary *postDic = @{@"uid":ToString([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]),
                              @"is_myfriends":@"1",
                              @"is_reg":@"0"
                              };
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [JYHelpers integerValueOfAString:[responseObject objectForKey:@"retcode"]];
        if (iRetcode == 1) {
            //do any addtion here...
            if ([responseObject objectForKey:@"data"]) {
                NSInteger num = [JYHelpers integerValueOfAString:[responseObject objectForKey:@"data"]];
                if (num == 0) {//没有可邀请好友
                    [self showPromptBoxView:YES];
                }else{
                    JYPhoneContactsController *phoneContactController = [[JYPhoneContactsController alloc] init];
                    [phoneContactController setFriendNum:num];
                    [self.navigationController pushViewController:phoneContactController animated:YES];
                }
            }
        }
    } failure:^(id error) {
        [self dismissProgressHUDtoView:self.view];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];
}

- (void)requestGetAuthInfo{
//    [self showProgressHUD:@"请稍后..." toView:self.view];
    authInfoArr = [NSMutableArray array];
    NSDictionary *paraDic = @{@"mod":@"login",
                              @"func":@"get_user_oauths"
                              };
    NSDictionary *postDic = @{@"uid":ToString([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"])
                              };
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [JYHelpers integerValueOfAString:[responseObject objectForKey:@"retcode"]];
        if (iRetcode == 1) {
            //do any addtion here...
            if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                NSArray *arr = [responseObject objectForKey:@"data"];
                if (arr.count > 0) {
                    for (NSDictionary *dic in arr) {
                        JYAuthInfoModel *model = [JYAuthInfoModel authInfoModelWithDic:dic];
                        [authInfoArr addObject:model];
                    }
                }
            }
        }
    } failure:^(id error) {
//        [self dismissProgressHUDtoView:self.view];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];
}
- (void)shareContentWithShareType:(ShareType)shareType{
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"test_img" ofType:@"jpeg"];
    id<ISSCAttachment>image;
    NSString *imageUrl = [[profileDataDic objectForKey:@"avatars"] objectForKey:@"200"];
    if (imageUrl.length != 0) {
        image = [ShareSDK imageWithUrl:imageUrl];
    }else{
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"pic_morentouxiang_man" ofType:@"png"];
        image = [ShareSDK imageWithPath:imagePath];
    }
    NSString *shareTitle = [NSString stringWithFormat:@"我是%@，我在友寻。",[profileDataDic objectForKey:@"nick"]];
    if (shareType == ShareTypeWeixiTimeline) {
        shareTitle = [shareTitle stringByAppendingString:@"快来【友寻】和我一起认识更多靠谱的朋友，朋友的朋友一秒变好友。和朋友的朋友谈恋爱，顺手解救身边的单身朋友，变身朋友圈丘比特！"];
    }
    id<ISSContent>content = [ShareSDK content:@"快来【友寻】和我一起认识更多靠谱的朋友，朋友的朋友一秒变好友。和朋友的朋友谈恋爱，顺手解救身边的单身朋友，变身朋友圈丘比特！"
                               defaultContent:@""
                                        image:image
                                        title:shareTitle
                                          url:[NSString stringWithFormat:@"http://m.iyouxun.com/wechat/friend_invite/?uid=%@",ToString([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"])]
                                  description:@"友寻"
                                    mediaType:SSPublishContentMediaTypeNews];
    
    id<ISSAuthOptions>authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                        allowCallback:YES
                                                        authViewStyle:SSAuthViewStyleFullScreenPopup
                                                         viewDelegate:nil
                                              authManagerViewDelegate:nil];
    
    [ShareSDK shareContent:content type:shareType authOptions:authOptions statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        if (state != SSResponseStateBegan) {
            canOper = YES;
        }
        if (state == SSResponseStateSuccess) {
            [[JYAppDelegate sharedAppDelegate] showTip:@"发送完成！"];
        }else if(state == SSResponseStateFail){
            [[JYAppDelegate sharedAppDelegate] showTip:@"发送失败！"];
        }else if(state == SSResponseStateCancel){
//            [[JYAppDelegate sharedAppDelegate] showTip:@"已取消发送！"];
        }
    }];
    
}

//- (void)getSinaWeiboFriendData{
//    [self dismissProgressHUDtoView:self.view];
//    id<ISSAuthOptions>authOption = [ShareSDK authOptionsWithAutoAuth:YES
//                                                       allowCallback:YES
//                                                              scopes:nil
//                                                       powerByHidden:YES
//                                                      followAccounts:nil
//                                                       authViewStyle:SSAuthViewStyleFullScreenPopup
//                                                        viewDelegate:nil
//                                             authManagerViewDelegate:nil];
//
//    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:authOption result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
//        if (result) {
//            [self requestIsBindOrNotWithOpenId:[userInfo uid] token:[[userInfo credential] token]];
//        }else{
////            [[JYAppDelegate sharedAppDelegate] showTip:@""];
//        }
//    }];
//    
//}

//判断当前登录账号是否已经授权
- (void)requestIsBindOrNotWithOpenId:(NSString*)uid token:(NSString *)token type:(NSString*)type{
    
    [self showProgressHUD:@"请稍等.." toView:self.view];
    NSDictionary *paraDic = @{@"mod":@"login",
                              @"func":@"is_bind_openid"
                              };
    NSDictionary *postDic = @{
                              @"type":type,
                              @"openid":uid
                              };
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [JYHelpers integerValueOfAString:[responseObject objectForKey:@"retcode"]];
        if (iRetcode == 1) {
            //do any addtion here...
            [self dismissProgressHUDtoView:self.view];
            if ([[[responseObject objectForKey:@"data"] objectForKey:@"success"] boolValue]) {
                //已绑定过
                //                判断绑定用户是否为当前用户
                NSString *userUid = [[responseObject objectForKey:@"data"] objectForKey:@"uid"];
                //当前登录用户和绑定用户为同一个用户
                if ([userUid isEqualToString:ToString([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"])]) {
                    if ([type integerValue] == 1) {
                        [self showShareWeiChatActionSeet];
                    }else if ([type integerValue] == 2){
                        JYAddSinaFriendController *sinaFrdVC = [[JYAddSinaFriendController alloc] init];
                        [sinaFrdVC setSinaToken:token];
                        [sinaFrdVC setSinaUid:uid];
                        [self dismissProgressHUDtoView:self.view];
                        [self.navigationController pushViewController:sinaFrdVC animated:YES];
                    }else{
                        [self shareContentWithShareType:ShareTypeQQ];
                    }
                    
                }else{//当前登录用户和绑定用户为不同用户
                    canOper = YES;
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"该账号已与其他友寻账号绑定，请更换或先将原账号解绑" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                    [alertView show];
                    //解除ShareSDK的绑定状态，方便下一次进入第三方应用
                    //不这样做的话会造成不会进入第三方应用，会直接调用ShareSDK的缓存
                    if ([type integerValue] == 1) {
                        [ShareSDK cancelAuthWithType:ShareTypeWeixiSession];
                    }else if ([type integerValue] == 2){
                        [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
                    }else{
                        [ShareSDK cancelAuthWithType:ShareTypeQQSpace];
                    }
                }
            }else{
                //未绑定过
                //1.后台绑定
                canOper = YES;
                dispatch_queue_t queue = dispatch_queue_create("bind", DISPATCH_QUEUE_SERIAL);
                dispatch_async(queue, ^{
                    [self requestBindWithOpenID:uid token:token type:type];
                });
                //2.加载数据
                if ([type integerValue] == 1) {
                    [self showShareWeiChatActionSeet];
                }else if ([type integerValue] == 2){
                    JYAddSinaFriendController *sinaFrdVC = [[JYAddSinaFriendController alloc] init];
                    [sinaFrdVC setSinaToken:token];
                    [sinaFrdVC setSinaUid:uid];
                    [self dismissProgressHUDtoView:self.view];
                    [self.navigationController pushViewController:sinaFrdVC animated:YES];
                }else{
                    [self shareContentWithShareType:ShareTypeQQ];
                }
                
            }
        }
    } failure:^(id error) {
        //请求失败
        [self dismissProgressHUDtoView:self.view];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];
    
}
- (void)bindWithType:(ShareType)type{
    //    [self showProgressHUD:@"加载中..." toView:self.view];
    id<ISSAuthOptions>authOption = [ShareSDK authOptionsWithAutoAuth:YES
                                                       allowCallback:YES
                                                              scopes:nil
                                                       powerByHidden:YES
                                                      followAccounts:nil
                                                       authViewStyle:SSAuthViewStyleFullScreenPopup
                                                        viewDelegate:nil
                                             authManagerViewDelegate:nil];
    
    [ShareSDK getUserInfoWithType:type authOptions:authOption result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        //        [self dismissProgressHUDtoView:self.view];
        canOper = YES;
        if (result) {
            NSString *openType = @"1";
            switch (type) {
                case ShareTypeQQSpace:{
                    openType = @"3";
                }
                    break;
                case ShareTypeWeixiSession:{
                    openType = @"1";
                }
                    break;
                case ShareTypeSinaWeibo:{
                    openType = @"2";
                    }
                    break;
                default:
                    break;
            }
            [self requestIsBindOrNotWithOpenId:[[userInfo credential] uid] token:[[userInfo credential] token] type:openType];
//            [self requestBindWithOpenID:[userInfo uid] token:[[userInfo credential] token] type:openType];
        }else{
            if ([error errorCode] == - 6004 && type == ShareTypeQQSpace) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"授权失败！" message:@"尚未安装QQ！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                [alertView show];
                
            }
        }
    }];
}
//当前未绑定则需要绑定
- (void)requestBindWithOpenID:(NSString*)uid token:(NSString*)token type:(NSString*)type{
    
    NSDictionary *paraDic = @{@"mod":@"login",
                              @"func":@"bind"
                              };
    
    NSString *jsonStr = [NSString stringWithFormat:@"{\"openid\":\"%@\",\"refresh_token\":\"\",\"access_token\":\"%@\",\"openid_type\":\"%@\"}",uid,token,type];
    NSLog(@"jsonStr -> %@",jsonStr);
    NSDictionary *postDic = [NSDictionary dictionaryWithObject:jsonStr forKey:@"dat"];
    
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [JYHelpers integerValueOfAString:[responseObject objectForKey:@"retcode"]];
        if (iRetcode == 1) {
            //do any addtion here...
            
        }
    } failure:^(id error) {
        [self dismissProgressHUDtoView:self.view];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];
    
}
//#pragma mark - UIAlertViewDelegate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex == 1) {
//        [self getSinaWeiboFriendData];
//    }else{
//        [self dismissProgressHUDtoView:self.view];
//    }
//}
@end
