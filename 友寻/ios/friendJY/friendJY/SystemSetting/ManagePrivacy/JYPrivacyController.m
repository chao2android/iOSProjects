//
//  JYPrivacyController.m
//  friendJY
//
//  Created by coder_zhang on 15/4/1.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYPrivacyController.h"
#import "JYSetFriendChatController.h"
#import "JYShareData.h"
#import "JYAppDelegate.h"

#define kPrivacyDetailLabTag 17892


@interface JYPrivacyController ()
{
    //隐私value
    NSMutableArray *privacyArr;
//聊天选项
    NSArray *chatOptions;
//资料展示选项
    NSArray *profileShowOptions;
}

@end

@implementation JYPrivacyController

//- (NSArray *)cellTitleArr{
//    if (_cellTitleArr == nil) {
//        _cellTitleArr = @[@[@"在熟人圈显示二度好友动态",@"允许二度好友查看我的动态"],@[@"好友与聊天",@"资料展示"]];
//    }
//    return _cellTitleArr;
//}
- (void)viewDidLoad {
    
    [self setTitle:@"隐私设置"];
    [self getPrivicyInfo];
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}
#pragma mark - request
//获取隐私信息
- (void)getPrivicyInfo{
    [self showProgressHUD:@"请稍后..." toView:self.view];
    [privacyArr removeAllObjects];
    privacyArr = nil;
    privacyArr = [NSMutableArray array];
    NSDictionary *paraDic = @{@"mod":@"profile",
                              @"func":@"get_private_info"
                              };
    NSDictionary *postDic = @{
                              @"uid":ToString([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"])
                              };
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        [self dismissProgressHUDtoView:self.view];
        if (iRetcode == 1) {
            //do any addtion here...
            _cellTitleArr = @[@[@"在熟人圈显示二度好友动态",@"允许二度好友查看我的朋友圈"],@[@"好友与聊天",@"资料展示"]];
            
            NSDictionary *profileDict = [responseObject objectForKey:@"data"];
            [privacyArr addObject:[profileDict objectForKey:kShowSecondFriendDync]];
            [privacyArr addObject:[profileDict objectForKey:kAllowSecondLook]];
//            [privacyArr addObject:[profileDict objectForKey:kAllowAcceptSecondInvite]];
            
            [privacyArr addObject:[profileDict objectForKey:kAllowAddWithChat]];
            [privacyArr addObject:[profileDict objectForKey:kAllowProfileShow]];
//            dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
//            });
            
        }
    } failure:^(id error) {
        
        [self dismissProgressHUDtoView:self.view];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    
    }];

    
    chatOptions = [[[[JYShareData sharedInstance] profile_dict] objectForKey:@"privacy"] objectForKey:@"chat"];
    profileShowOptions = [[[[JYShareData sharedInstance] profile_dict] objectForKey:@"privacy"] objectForKey:@"profile_show"];
    
}
//request update privacy
- (void)requestUpdatePrivacyWithDic:(NSDictionary*)dic{
//    http://c.friendly.dev/cmiajax/?mod=profile&func=update_private_info&uid=2086550&fields={"show_second_friend_dync":0}
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *fieldStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *paraDic = @{@"mod":@"profile",
                              @"func":@"update_private_info"
                              };
    NSDictionary *postDic = @{@"uid":ToString([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]),
                              @"fields":fieldStr
                              };
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            //do any addtion here...
        }
    } failure:^(id error) {
        [self dismissProgressHUDtoView:self.view];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];
}
- (void)switchAction:(UISwitch*)sender{
    NSLog(@"switch value changed");
    NSString *key = @"";
    switch (sender.tag - 100) {
        case 0:{
            key = kShowSecondFriendDync;
        }
            break;
        case 1:{
            key = kAllowSecondLook;
        }
            break;
//        case 2:{
//            key = kAllowAcceptSecondInvite;
//        }
//            break;
        default:
            break;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (sender.on) {
        [dic setObject:@"1" forKey:key];
    }else{
        [dic setObject:@"0" forKey:key];
    }
    [self requestUpdatePrivacyWithDic:dic];
    if (sender.tag - 100 == 1) {
        [privacyArr replaceObjectAtIndex:1 withObject:(sender.on?@"1":@"0")];
        [_tableView reloadData];
    }
}
#pragma mark - UITableViewDataSource and UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    cell.textLabel.text = self.cellTitleArr[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    [cell.textLabel setTextColor:[UIColor darkGrayColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setSelected:NO];
    NSInteger value = 0;
    if (privacyArr.count > indexPath.section*2 + indexPath.row) {
        value = [[privacyArr objectAtIndex:indexPath.section*2 + indexPath.row] integerValue];
    }
    if (indexPath.section == 0) {
        UISwitch *swh = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenWidth - 70, 5, 45, 30)];
//        swh.backgroundColor = [UIColor greenColor];
        swh.tag = 100 + indexPath.row;
        if (value == 1) {
            [swh setOn:YES];
        }
        [swh addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:swh];
    }else{
        NSString *str = @"好友与聊天";
        CGFloat width = [str sizeWithFont:[UIFont systemFontOfSize:14.0f]].width;
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15 + width + 5, 0, kScreenWidth - 25 - width - 20, 44)];
        lab.tag = kPrivacyDetailLabTag;
        if (indexPath.row == 0) {
            [lab setText:[chatOptions objectAtIndex:value]];
        }else{// 1 ->0 2 3 //0 ->0 1 3
            NSInteger secondLook = [[privacyArr objectAtIndex:1] integerValue];
            if (secondLook == 1) {
                if (value == 1) {
                    value = 0;
                    [privacyArr replaceObjectAtIndex:3 withObject:@"2"];
                    [self performSelectorInBackground:@selector(requestUpdatePrivacyWithDic:) withObject:@{kAllowProfileShow:@"2"}];
                }
            }else{
            
                if (value == 2) {
                    value = 0;
                    [privacyArr replaceObjectAtIndex:3 withObject:@"1"];
                    [self performSelectorInBackground:@selector(requestUpdatePrivacyWithDic:) withObject:@{kAllowProfileShow:@"1"}];
                }
            }
            
            [lab setText:[profileShowOptions objectAtIndex:value]];
        }
        [lab setTextColor:[UIColor darkGrayColor]];
        [lab setFont:[UIFont systemFontOfSize:13.0f]];
        [cell addSubview:lab];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        if (privacyArr.count < 1) {
            [[JYAppDelegate sharedAppDelegate] showTip:@"数据获取错误"];
            return;
        }
        JYPrivacyDetailStyle style = (indexPath.row == 0) ? JYPrivacyDetailStyleFriendChat : JYPrivacyDetailStyleShowMaterial;
        JYSetFriendChatController *frdChat = [[JYSetFriendChatController alloc] init];
        frdChat.style = style;
        
        if ([[privacyArr objectAtIndex:1] integerValue] == 1) {
            [frdChat setAllow_second_friend_look_my_dync:YES];
        }
        
        [frdChat setCurrentIndex:[[privacyArr objectAtIndex:2+indexPath.row] integerValue]];
        [frdChat setChangeBlock:^(NSString *text,NSInteger index) {
        
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [privacyArr replaceObjectAtIndex:2+indexPath.row withObject:[NSString stringWithFormat:@"%ld",(long)index]];
            UILabel *label = (UILabel*)[cell viewWithTag:kPrivacyDetailLabTag];
            label.text = text;
        }];
        [self.navigationController pushViewController:frdChat animated:YES];
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
