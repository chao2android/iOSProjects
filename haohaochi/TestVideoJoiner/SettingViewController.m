//
//  SettingViewController.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-12-13.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "SettingViewController.h"
#import "DWUploadViewController.h"
#import "ReplyViewController.h"
#import "AboutViewController.h"

@interface SettingViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@end

@implementation SettingViewController

- (void)viewDidLoad {
    self.mTopImage = [UIImage imageNamed:@"Image-2"];
    self.mTitleColor = [UIColor whiteColor];
    [super viewDidLoad];
    self.title = @"设置";
    
    [self AddLeftImageBtn:[UIImage imageNamed:@"p_backbtn3"] target:self action:@selector(GoBack) scale:1.0];
    [self AddRightTextBtn:@"退出" target:self action:@selector(OnQuitClick)];
    
    // Do any additional setup after loading the view.
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

- (void)OnQuitClick {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定要退出登录？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        kkUserDict = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_Logout object:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        return 2;
    }
    else if (section == 2) {
        return 3;
    }
    else if (section == 3) {
        return 5;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = [NSString stringWithFormat:@"SettingCellID%ld", indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        
        if (indexPath.section == 2) {
            UISwitch *selectbtn = [[UISwitch alloc] init];
            selectbtn.frame = CGRectMake(cell.frame.size.width-selectbtn.frame.size.width-10, (44-selectbtn.frame.size.height)/2, selectbtn.frame.size.width, selectbtn.frame.size.height);
            selectbtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            [selectbtn addTarget:self action:@selector(OnSwitchChanged:) forControlEvents:UIControlEventValueChanged];
            selectbtn.tag = 2000+indexPath.row;
            [cell.contentView addSubview:selectbtn];
        }
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"查看视频上传进度";
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"教学视频";
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = @"观看片头动画";
        }
    }
    else if (indexPath.section == 2) {
        UISwitch *selectbtn = (UISwitch *)[cell.contentView viewWithTag:2000+indexPath.row];
        if (indexPath.row == 0) {
            cell.textLabel.text = @"仅在WIFI条件下上传";
            selectbtn.on = kUserInfoManager.mbWifiUpload;
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = @"自动储存至手机";
            selectbtn.on = kUserInfoManager.mbAutoSave;
        }
        else if (indexPath.row == 2) {
            cell.textLabel.text = @"推送消息设置";
            selectbtn.on = kUserInfoManager.mbPush;
        }
    }
    else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"关于我们，关于美食";
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = @"检查版本";
        }
        else if (indexPath.row == 2) {
            cell.textLabel.text = @"求评分";
        }
        else if (indexPath.row == 3) {
            cell.textLabel.text = @"求反馈";
        }
        else if (indexPath.row == 4) {
            cell.textLabel.text = @"版权协议";
        }
    }
    return cell;
}

- (double)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (double)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *titles = @[@"后台", @"个人", @"偏好", @"好好吃团队"];
    return [titles objectAtIndex:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        DWUploadViewController *ctrl = [[DWUploadViewController alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            AboutViewController *ctrl = [[AboutViewController alloc] init];
            ctrl.title = @"关于";
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        else if (indexPath.row == 1) {
            NSString *appurl = @"https://itunes.apple.com/cn/app/tastemade-video-city-guide/id635281031?mt=8";
            NSURL *url = [NSURL URLWithString:appurl];
            [[UIApplication sharedApplication] openURL:url];
        }
        else if (indexPath.row == 2) {
            NSString *appurl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", APP_ID];
            NSURL *url = [NSURL URLWithString:appurl];
            [[UIApplication sharedApplication] openURL:url];
        }
        else if (indexPath.row == 3) {
            ReplyViewController *ctrl = [[ReplyViewController alloc] init];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        else if (indexPath.row == 4) {
            AboutViewController *ctrl = [[AboutViewController alloc] init];
            ctrl.title = @"版权协议";
            [self.navigationController pushViewController:ctrl animated:YES];
        }
    }
}

- (void)OnSwitchChanged:(UISwitch *)sender {
    NSInteger index = sender.tag-2000;
    if (index == 0) {
        kUserInfoManager.mbWifiUpload = sender.on;
    }
    else if (index == 1) {
        kUserInfoManager.mbAutoSave = sender.on;
    }
    else if (index == 2) {
        kUserInfoManager.mbPush = sender.on;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.mTopImage = [UIImage imageNamed:@"Image-2"];
    [self RefreshNavColor];
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
