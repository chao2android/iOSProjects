//
//  JYProfileSystemSetAccountViewController.m
//  friendJY
//
//  Created by coder_zhang on 15/4/1.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYProfileSystemSetAccountViewController.h"
#import "JYProfileSetGetBackPwdViewController.h"
#import "JYModifyPwdController.h"
#import "JYModifyPhoneNumController.h"

@interface JYProfileSystemSetAccountViewController ()
{
    UILabel *lastLab;
}
@end

@implementation JYProfileSystemSetAccountViewController
- (NSArray *)cellTitleArr{
    if (_cellTitleArr == nil) {
        _cellTitleArr = @[@[@"账号信息"],@[@"找回密码",@"修改密码",@"修改登录手机号"]];
    }
    return _cellTitleArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"账号安全";
//    NSLog(@"%@",NSHomeDirectory());
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingCellID];
    if (cell == nil) {
        if (indexPath.section == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"FirstView"];
            
            UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 60, 20)];
            [titleLab setFont:[UIFont systemFontOfSize:14.0f]];
            [titleLab setText:@"账号信息"];
            [titleLab setTextColor:kTextColorBlack];
            [cell addSubview:titleLab];
            
           
            NSString *str = @"当前登录账号";
            CGFloat width = [JYHelpers getTextWidthAndHeight:str fontSize:15].width;
            
            UILabel *accountLab = [[UILabel alloc] initWithFrame:CGRectMake(15, titleLab.bottom+5, width, 20)];
            [accountLab setFont:[UIFont systemFontOfSize:14]];
            [accountLab setTextColor:kTextColorGray];
            [accountLab setText:str];
            [cell addSubview:accountLab];
            if (self.phoneNum) {
                NSMutableString *phoneNum = [NSMutableString stringWithString:self.phoneNum];
                NSString *repStr = @"****";
                [phoneNum replaceCharactersInRange:NSMakeRange(3, 4) withString:repStr];
                
                lastLab = [[UILabel alloc] initWithFrame:CGRectMake(accountLab.right, accountLab.top, 200, 20)];
                [lastLab setTextColor:kTextColorBlack];
                [lastLab setFont:[UIFont systemFontOfSize:14]];
                [lastLab setText:phoneNum];
                [cell addSubview:lastLab];
            }else{
                width = [JYHelpers getTextWidthAndHeight:@"您使用的是第三方登录" fontSize:14].width;
                UILabel *preLab = [[UILabel alloc] initWithFrame:CGRectMake(accountLab.right, accountLab.top, width,20)];
                [preLab setText:@"您使用的是第三方登录"];
                [preLab setFont:[UIFont systemFontOfSize:14]];
                [preLab setTextAlignment:NSTextAlignmentRight];
                [preLab setTextColor:kTextColorBlack];
                [cell addSubview:preLab];
            }

//            width
//            cell.detailTextLabel.text = [NSString stringWithFormat:@"当前登录账号 %@",phoneNum];
//            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }else{
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSettingCellID];
            cell.textLabel.text = self.cellTitleArr[indexPath.section][indexPath.row];
            //    cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 75.0f;
    }
    return kSettingCellHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            if (self.phoneNum) {
                
                JYProfileSetGetBackPwdViewController *backPwd = [[JYProfileSetGetBackPwdViewController alloc] init];
                [self.navigationController pushViewController:backPwd animated:YES];

            }else{
                [[JYAppDelegate sharedAppDelegate] showTip:@"请尝试用手机号登录"];
            }

        }else if (indexPath.row == 1){
//            if (self.phoneNum) {
            
                JYModifyPwdController *modifyPwd = [[JYModifyPwdController alloc] init];
//                modifyPwd.style = JYModifyPwdStyleChange;
                [self.navigationController pushViewController:modifyPwd animated:YES];
//            }else{
//                [[JYAppDelegate sharedAppDelegate] showTip:@"请尝试用手机号登陆"];
//            }
           
        }else{
            if (self.phoneNum) {
                JYModifyPhoneNumController *modifyPhoneNum = [[JYModifyPhoneNumController alloc] init];
                modifyPhoneNum.finishBlock = ^{
//                    self.phoneNum = [SharedDefault objectForKey:@"phone"];
                    NSMutableString *phoneNum = [NSMutableString stringWithString:self.phoneNum];
                    NSString *repStr = @"****";
                    [phoneNum replaceCharactersInRange:NSMakeRange(3, 4) withString:repStr];
                    [lastLab setText:phoneNum];
                };
                [self.navigationController pushViewController:modifyPhoneNum animated:YES];
   
            }else{
                [[JYAppDelegate sharedAppDelegate] showTip:@"请尝试用手机号登录"];
            }
        }
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
