//
//  JYManageThirdLoginController.m
//  friendJY
//
//  Created by chenxiangjing on 15/4/3.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYManageThirdLoginController.h"
#import <ShareSDK/ShareSDK.h>
#import "JYAppDelegate.h"
//#import "JYViewDelegate.h"

#define kLoginInfoPath [NSString stringWithFormat:@"%@/Preferences/login_help.plist",NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)]

@interface JYManageThirdLoginController ()<UIActionSheetDelegate>

{
    NSMutableArray *_shareTypeArray;
    NSMutableArray *_bindStatusArr;
    UIActionSheet *deleteBindSheet;
    NSInteger deleteIndex;
}

@end
// 1 wechat 2 sina 3 qq
@implementation JYManageThirdLoginController
- (NSArray *)cellTitleArr{
    if (_cellTitleArr == nil) {
        _cellTitleArr = @[@[@"微信",@"新浪微博",@"QQ"]];
    }
    return _cellTitleArr;
}
- (instancetype)init{
    if (self = [super init]) {
   
        _shareTypeArray = [[NSMutableArray alloc] init];
        [_shareTypeArray addObject:[NSNumber numberWithInteger:ShareTypeWeixiSession]];
        [_shareTypeArray addObject:[NSNumber numberWithInteger:ShareTypeSinaWeibo]];
        [_shareTypeArray addObject:[NSNumber numberWithInteger:ShareTypeQQSpace]];
        _bindStatusArr = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0"]];
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"第三方账户"];
    [self loadUserOauthsInfo];
    [self initActionSheet];
}
- (void)initActionSheet{
    deleteBindSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"解除绑定",nil];
}
- (void)loadUserOauthsInfo{

    NSDictionary *paraDic = @{@"mod":@"login",
                              @"func":@"get_user_oauths"
                              };
    NSDictionary *postDic = @{@"uid":ToString([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"])
                              };
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            //do any addtion here...
            if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                NSArray *arr = [responseObject objectForKey:@"data"];
                if (arr.count == 0) {
                    _bindStatusArr = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0"]];
                }else{
                    NSString *bindWechat = @"0";
                    NSString *bindSina = @"0";
                    NSString *bindQQ = @"0";
                    for (NSDictionary*dic in arr) {
                        NSInteger bindType = [[dic objectForKey:@"type"] integerValue];
                        switch (bindType) {
                            case 1:
                                bindWechat = @"1";
                                break;
                            case 2:
                                bindSina = @"1";
                                break;
                            case 3:
                                bindQQ = @"1";
                                break;
                            default:
                                break;
                        }
                    }
                    _bindStatusArr = [NSMutableArray arrayWithObjects:bindWechat,bindSina,bindQQ,nil];
                    [_tableView reloadData];
                }
 
            }
        }
    } failure:^(id error) {
        [self dismissProgressHUDtoView:self.view];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kSettingCellID];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    NSString *imgName = nil;
    NSString *text = @"未绑定";
    switch (indexPath.row) {
        case 0:{
            if ([[_bindStatusArr objectAtIndex:indexPath.row] boolValue]) {
                imgName = @"set_weixin_disconnect";
                text = @"已绑定";
            }else{
                imgName = @"set_weixin_connect";
            }
        }
            break;
        case 1:{
            if ([[_bindStatusArr objectAtIndex:indexPath.row] boolValue]) {
                imgName = @"set_sina_disconnect";
                text = @"已绑定";
            }else{
                imgName = @"set_sina_connect";
            }
        }
            break;
        case 2:{
            if ([[_bindStatusArr objectAtIndex:indexPath.row] boolValue]) {
                imgName = @"set_qq_disconnect";
                text = @"已绑定";
            }else{
                imgName = @"set_qq_connect";
            }

        }
            break;
        default:
            break;
    }
    
    UILabel *connectLab = [[UILabel alloc] initWithFrame:CGRectMake(tableView.width - 26.0 - 60.0, 0, 60.0, cell.height)];
    [connectLab setFont:kSettingDefaultFont];
    [connectLab setTextAlignment:NSTextAlignmentRight];
    [connectLab setText:text];
    [cell addSubview:connectLab];
    
    cell.imageView.image = [UIImage imageNamed:imgName];
    cell.textLabel.text = self.cellTitleArr[indexPath.section][indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
//    [ShareSDK cancelAuthWithType:ShareTypeQQSpace];
//    JYViewDelegate *viewDelegate = [[JYViewDelegate alloc] init];
//
    if (![JYHttpServeice NetworkStatues]) {
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        return;
    }
    NSInteger index = indexPath.row;
    BOOL isBind = [[_bindStatusArr objectAtIndex:index] boolValue];
    deleteIndex = index;
    switch (indexPath.row) {
        case 0:{
            if (isBind) {//解绑
                [deleteBindSheet showInView:self.view];
//                [self cancelBindWithType:ShareTypeWeixiSession];
            }else{//绑定
                [self bindWithType:ShareTypeWeixiSession];
            }
        }
            break;
        case 1:{//微博
            if (isBind) {//解绑
                [deleteBindSheet showInView:self.view];
//                [self cancelBindWithType:ShareTypeSinaWeibo];
            }else{//绑定
                [self bindWithType:ShareTypeSinaWeibo];
            }

        }
            break;
        case 2:{
            if (isBind) {//解绑
                [deleteBindSheet showInView:self.view];
//                [self cancelBindWithType:ShareTypeQQSpace];
            }else{//绑定
                [self bindWithType:ShareTypeQQSpace];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    NSLog(@"%d",buttonIndex);
    NSLog(@"%d",deleteIndex)
    if (buttonIndex == 0) {
        [self cancelBindWithType:(ShareType)[[_shareTypeArray objectAtIndex:deleteIndex] integerValue]];
    }
}
#pragma mark - 绑定与解除绑定
//public void is_bind_openid()
//根据第三方登录帐号判断用户是否验证过() - 已完成
//Example:
//http://client.friendly.dev/cmiajax/?mod=login&func=is_bind_openid&openid=11&type=22
- (void)requestIsBindIDWithCredential:(id<ISSPlatformCredential>)credential type:(ShareType)type{
    
    NSString *openid_type = @"";
    switch (type) {
        case ShareTypeWeixiSession:
            openid_type = @"1";
            break;
        case ShareTypeSinaWeibo:
            openid_type = @"2";
            break;
        case ShareTypeQQSpace:
            openid_type = @"3";
            break;
        default:
            break;
    }
    
    NSDictionary *paraDic = @{@"mod":@"login",
                              @"func":@"is_bind_openid"
                              };
    NSDictionary *postDic = @{
                              @"type":openid_type,
                              @"openid":[credential uid]
                              };
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            //do any addtion here...
            [self dismissProgressHUDtoView:self.view];
            if ([[[responseObject objectForKey:@"data"] objectForKey:@"success"] boolValue]) {
                //已绑定过
                [[JYAppDelegate sharedAppDelegate] showTip:@"绑定失败：该账号已经绑定过友寻账号。"];
            }else{
                //未绑定过
                [self requestBindWithType:type andcredential:credential];
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
        if (result) {
            
//            [self requestBindWithType:type andcredential:[userInfo credential]];
            [self requestIsBindIDWithCredential:[userInfo credential] type:type];

        }else{
            if ([error errorCode] == - 6004) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"授权失败！" message:@"尚未安装QQ！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                [alertView show];
    
            }
        }
    }];
}
- (void)requestBindWithType:(ShareType)type andcredential:(id<ISSPlatformCredential>)credential{

    NSString *openid_type = @"";
    switch (type) {
        case ShareTypeWeixiSession:
            openid_type = @"1";
            break;
        case ShareTypeSinaWeibo:
            openid_type = @"2";
            break;
        case ShareTypeQQSpace:
            openid_type = @"3";
            break;
        default:
            break;
    }

//    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
//    [fomatter setDateFormat:@"yyyyMMdd"];
    NSDictionary *paraDic = @{@"mod":@"login",
                              @"func":@"bind"
                              };

//    NSString *jsonStr = [NSString stringWithFormat:@"{\"openid\":\"%@\",\"refresh_token\":\"\",\"access_token\":\"%@\",\"openid_type\":\"%@\"}",[credential uid],[credential token],openid_type];
//    NSLog(@"jsonStr -> %@",jsonStr);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[credential uid] forKey:@"openid"];
    [dic setObject:[credential token] forKey:@"access_token"];
    [dic setObject:[credential token] forKey:@"refresh_token"];
    [dic setObject:openid_type forKey:@"openid_type"];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]] forKey:@"expires_in"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSJSONWritingPrettyPrinted];
    NSLog(@"jsonStr -> %@",jsonStr);
    
    NSDictionary *postDic = [NSDictionary dictionaryWithObject:jsonStr forKey:@"dat"];

    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            //do any addtion here...
            [[JYAppDelegate sharedAppDelegate] showTip:@"绑定成功"];
            [_bindStatusArr replaceObjectAtIndex:deleteIndex withObject:@"1"];
            [_tableView reloadData];
        }
    } failure:^(id error) {
        [self dismissProgressHUDtoView:self.view];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];
}

//取消授权
- (void)cancelBindWithType:(ShareType)type{
    [self showProgressHUD:@"请稍等..." toView:self.view];
    [ShareSDK cancelAuthWithType:type];
    [self requestCancelBindWithType:type];
}
- (void)requestCancelBindWithType:(ShareType)type{
    NSString *typeStr =@"";
    switch (type) {
        case ShareTypeWeixiSession:
            typeStr = @"1";
            break;
        case ShareTypeSinaWeibo:
            typeStr = @"2";
            break;
        case ShareTypeQQSpace:
            typeStr = @"3";
            break;
        default:
            break;
    }
    NSDictionary *paraDic = @{@"mod":@"login",
                              @"func":@"del_bind"
                              };
    NSDictionary *postDic = @{
                              @"type":typeStr
                              };
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        [self dismissProgressHUDtoView:self.view];
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            //do any addtion here...
            [_bindStatusArr replaceObjectAtIndex:[typeStr integerValue] - 1 withObject:@"0"];
            [_tableView reloadData];
        }
    } failure:^(id error) {
        [self dismissProgressHUDtoView:self.view];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];
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
