//
//  JYSetMessageRemindController.m
//  friendJY
//
//  Created by chenxiangjing on 15/4/3.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYSetMessageRemindController.h"

@interface JYSetMessageRemindController ()

//@property (nonatomic, strong) NSMutableDictionary *remindStatusDict;

@end

@implementation JYSetMessageRemindController

- (NSArray *)cellTitleArr{
    if (_cellTitleArr == nil) {
        _cellTitleArr = @[@[@"接受消息提醒"],@[@"声音",@"振动"]];
    }
    return _cellTitleArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"消息提醒"];
    // Do any additional setup after loading the view.
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSettingCellID];
    cell.textLabel.text = self.cellTitleArr[indexPath.section][indexPath.row];
    [cell.textLabel setFont:kSettingDefaultFont];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.section == 0) {
        
        [cell.textLabel setTextColor:[UIColor darkGrayColor]];
        UILabel *swhLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - kSettingCellXPadding - 60, 0, 60, kSettingCellHeight)];
//        [UIApplication sharedApplication] currentUserNotificationSettings
        if ([self getRemoteNotificationStatus]) {
            [swhLab setText:@"已开启"];
        }else{
            [swhLab setText:@"已关闭"];
        }
        [swhLab setTextAlignment:NSTextAlignmentRight];
        [swhLab setTextColor:[UIColor darkGrayColor]];
        [swhLab setFont:kSettingDefaultFont];
        [cell addSubview:swhLab];
        
    }else{
        
        [cell.textLabel setTextColor:[UIColor darkTextColor]];
        UISwitch *swh = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenWidth - kSettingCellXPadding - 50, 7, 50, 30)];
        [swh setTag:123+indexPath.row];
        [swh addTarget:self action:@selector(messageStatusChanged:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:swh];
        if (indexPath.row == 0 && [self getRemoteNotificationStatus]) {//声音
            if ([SharedDefault boolForKey:kUDPushSoundOption]) {
                [swh setOn:YES];
            }
        }else{//振动
            if ([SharedDefault boolForKey:kUDPushShakeOption] && [self getRemoteNotificationStatus]) {
                [swh setOn:YES];
            }
        }
    }
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return section == 0 ? kSettingFirstHeaderViewHeight : kSettingHeaderViewHeight*2;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    CGFloat height = section == 0 ? kSettingFirstHeaderViewHeight : kSettingHeaderViewHeight*2;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(-1, 0, kScreenWidth + 2, height)];
    view.layer.borderWidth = 1;
    view.layer.borderColor = [[JYHelpers setFontColorWithString:@"#cccccc"] CGColor];
    view.backgroundColor = kSettingDefaultBgColor;
    if (section == 1) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(kSettingCellXPadding, 0, kScreenWidth - kSettingCellXPadding*2, 40)];
        [lab setNumberOfLines:2];
        lab.text = @"消息提示设置：请在iPhone手机“设置-通知”功能中进行开启或关闭";
        [lab setTextColor:[UIColor darkGrayColor]];
        [lab setFont:[UIFont systemFontOfSize:12.0f]];
        [view addSubview:lab];
    }
    return view;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)getRemoteNotificationStatus{
    
    //    UIUserNotificationTypeNone
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        UIUserNotificationType myTypes = [settings types];
        if (myTypes == UIUserNotificationTypeNone) {
            return NO;
        }
    }else{
        
        UIRemoteNotificationType myType = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if (myType == UIRemoteNotificationTypeNone) {
            return NO;
        }
    }
    return YES;
}

- (void)messageStatusChanged:(UISwitch*)aSwitch{
    if (![self getRemoteNotificationStatus]) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"当前提醒功能未打开，设置无效"];
        return;
    }
    NSInteger index = aSwitch.tag - 123;
    if (index == 0) {//声音
        [SharedDefault setBool:aSwitch.on forKey:kUDPushSoundOption];
    }else{//振动
        [SharedDefault setBool:aSwitch.on forKey:kUDPushShakeOption];
    }
    [SharedDefault synchronize];
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
