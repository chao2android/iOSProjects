//
//  JYProfileSystemSetController.m
//  friendJY
//
//  Created by ouyang on 3/20/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//

#import "JYProfileSystemSetController.h"
#import "JYSetMessageRemindController.h"
#import "JYProfileSystemSetAccountViewController.h"
#import "JYPrivacyController.h"
#import "JYBlackListController.h"
#import "JYManageThirdLoginController.h"
#import "JYAppDelegate.h"
#import "JYLoginController.h"
#import <ShareSDK/ShareSDK.h>
#import "JYManageFriendData.h"
#import "JYProfileData.h"
#import "JYShareData.h"
#import "JYSettingsFeedBackController.h"
#import "JYChatDataBase.h"
#import "JYAboutUsController.h"
#import "JYMyQRCodeController.h"

@interface JYProfileSystemSetController ()<UIAlertViewDelegate>
{
    CGFloat cachesSize;
}
@end

@implementation JYProfileSystemSetController
//懒加载
- (NSArray *)cellTitleArr{
    if (_cellTitleArr == nil) {
        _cellTitleArr = @[@[@"账号安全",@"我的二维码"],@[@"隐私设置",@"消息提醒"],@[@"黑名单",@"第三方账号",@"同步手机通讯录",@"清除缓存",@"给应用打分",@"关于我们",@"反馈建议"]];
    }
    return _cellTitleArr;
}

- (void)viewDidLoad {
    cachesSize = [JYHelpers folderSizeAtCaches];
    [super viewDidLoad];
    [self setTitle:@"系统设置"];
    _tableView.scrollEnabled = YES;
    NSLog(@"%@",NSHomeDirectory());
    // Do any additional setup after loading the view.
}
- (void)initFooterView{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSettingFooterViewHeight)];
    footerView.backgroundColor = [UIColor clearColor];
    //分隔线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, -1, kScreenWidth, 1)];
    line.layer.borderColor = [[JYHelpers setFontColorWithString:@"#cccccc"] CGColor];
    line.layer.borderWidth = 1;
    [footerView addSubview:line];
    
    UIButton *logout = [UIButton buttonWithType:UIButtonTypeCustom];
    //    logout.center = footerView.center;
    logout.layer.borderWidth = 1;
    logout.layer.borderColor = [[JYHelpers setFontColorWithString:@"#cccccc"] CGColor];
    logout.frame = CGRectMake(kSettingLogoutBtnXPadding, kSettingLogoutBtnYPadding, kScreenWidth - 2*kSettingLogoutBtnXPadding, kSettingFooterViewHeight - 2*kSettingLogoutBtnYPadding);
    [logout setTitle:@"退出账号" forState:UIControlStateNormal];
    [logout addTarget:self action:@selector(logoutAction:) forControlEvents:UIControlEventTouchUpInside];
    [logout setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    logout.backgroundColor = [UIColor whiteColor];
    
    [footerView addSubview:logout];
    _tableView.tableFooterView = footerView;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSettingCellID];
        UILabel *cachesSizeLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 15 - 100, 0, 100, 44)];
        [cachesSizeLab setTag:123];
        [cachesSizeLab setTextColor:kTextColorGray];
        [cachesSizeLab setFont:[UIFont systemFontOfSize:15.0f]];
        [cachesSizeLab setTextAlignment:NSTextAlignmentCenter];
        [cell addSubview:cachesSizeLab];
    }
    UILabel *lab = (UILabel*)[cell viewWithTag:123];
    if (indexPath.section == 2 && indexPath.row == 3) {
        [lab setText:[NSString stringWithFormat:@"（%.2lfM）",cachesSize]];
    }else{
        [lab setText:@""];
    }
    cell.textLabel.text = self.cellTitleArr[indexPath.section][indexPath.row];
    //    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    用来存储将要显示的控制器
    UIViewController *vc = nil;
    if (indexPath.section == 0) {//账号安全
        if (indexPath.row == 0) {
            JYProfileSystemSetAccountViewController *accountVC = [[JYProfileSystemSetAccountViewController alloc] init];
            vc = accountVC;
        }else{
            JYMyQRCodeController *qrCodeController = [[JYMyQRCodeController alloc] init];
            vc = qrCodeController;
        }

    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {//隐私设置
            JYPrivacyController *privicy = [[JYPrivacyController alloc] init];
            vc = privicy;
        }else{//消息提醒
            JYSetMessageRemindController *setMsgVC = [[JYSetMessageRemindController alloc] init];
            vc = setMsgVC;
        }
    }else{
        switch (indexPath.row) {
            case 0://黑名单
            {
                JYBlackListController *blackListController = [[JYBlackListController alloc] init];
                vc = blackListController;
            }
                break;
            case 1:{//第三方登录
                JYManageThirdLoginController *thirdVC = [[JYManageThirdLoginController alloc] init];
                vc = thirdVC;
            }
                break;
            case 2:{//同步手机通讯录
                [[JYShareData sharedInstance] upListAndShowProgress:YES];
            }
                break;
            case 3:{//清除缓存
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确认删除缓存？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                [alert setTag:4321];
                [alert show];
            }
                break;
            case 4:{//给应用打分
                NSString *str = @"";
                if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
                {
                    str = @"itms-apps://itunes.apple.com/app/id1003151541";
                }else{
                    str = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1003151541";
                }
                NSURL *url = [NSURL URLWithString:str];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
                break;
            case 5:{//关于我们
                JYAboutUsController *aboutUs = [[JYAboutUsController alloc] init];
                [self.navigationController pushViewController:aboutUs animated:YES];
            }
                break;
            case 6:{//反馈建议
                JYSettingsFeedBackController *feedBackController = [[JYSettingsFeedBackController alloc] init];
                [self.navigationController pushViewController:feedBackController animated:YES];
            }
                break;
            default:
                break;
        }
    }
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
//退出登录
- (void)logoutAction:(UIButton*)sender{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要退出登录么？" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"确定", nil];
    [alertView show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 4321 && buttonIndex == 1) {
        [JYHelpers clearCache];
        cachesSize = [JYHelpers folderSizeAtCaches];
        [_tableView reloadData];
        return;
    }
    
    if (buttonIndex == 1) {
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isAutoLogin"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uid"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"phone"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[JYManageFriendData sharedInstance] cleanData];
        [[JYProfileData sharedInstance] cleanData];
        [ShareSDK cancelAuthWithType:ShareTypeWeixiSession];
        [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
        [ShareSDK cancelAuthWithType:ShareTypeQQSpace];
        [[JYChatDataBase sharedInstance] closeDB];
        [JYShareData sharedInstance].messageUserList = nil ;
        [JYShareData sharedInstance].currentChatLog = nil;
        
        if (!SIMULATOR) {
            
            //取消推送的绑定
            NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
            [parametersDict setObject:@"push" forKey:@"mod"];
            [parametersDict setObject:@"del_pushid" forKey:@"func"];
            
            NSDictionary *info = [[NSUserDefaults standardUserDefaults] objectForKey:@"bindBaiduPushInfomation"];
            
            NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
            [postDict setObject:[info valueForKey:BPushRequestUserIdKey] forKey:@"pushid"];
            
            [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
                
                NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
                if (iRetcode == 1 ) {
                } else {
                    
                }
                
            } failure:^(id error) {
                
                
            }];
            
        }
        
        JYLoginController *loginVC = [[JYLoginController alloc] init];
        JYNavigationController *navgationVC = [[JYNavigationController alloc] initWithRootViewController:loginVC];
        [[JYAppDelegate sharedAppDelegate].window setRootViewController:navgationVC];
        

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


