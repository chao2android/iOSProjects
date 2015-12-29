//
//  JYSetFriendChatController.m
//  friendJY
//
//  Created by chenxiangjing on 15/4/3.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYSetFriendChatController.h"
#import "JYShareData.h"
#import "JYAppDelegate.h"

@interface JYSetFriendChatController ()
{
    UIImageView *chooseView;
}

@end

@implementation JYSetFriendChatController
- (NSArray *)cellTitleArr{
    if (_cellTitleArr == nil) {
        
        if (_style == JYPrivacyDetailStyleFriendChat) {
            NSArray *tmpArr = [[[[JYShareData sharedInstance] profile_dict] objectForKey:@"privacy"] objectForKey:@"chat"];
            _cellTitleArr = @[tmpArr];
        }else{
            // 1 ->0 2 3 //0 ->0 1 3
            NSArray *tmpArr = [[[[JYShareData sharedInstance] profile_dict] objectForKey:@"privacy"] objectForKey:@"profile_show"];
            NSMutableArray *arr = [NSMutableArray arrayWithArray:tmpArr];
            if (_allow_second_friend_look_my_dync) {
                [arr removeObjectAtIndex:1];
                
            }else{
                [arr removeObjectAtIndex:2];
            }
            
            _cellTitleArr = @[arr];
        }
    }
    return _cellTitleArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = (_style == JYPrivacyDetailStyleFriendChat) ? @"好友与聊天" : @"资料展示";
    
    if (_allow_second_friend_look_my_dync) {
        if (_currentIndex > 1) {
            _currentIndex --;
        }
    }else{
        if (_currentIndex > 2) {
            _currentIndex --;
        }
    }
    
    chooseView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 35, 34+_currentIndex*44+15, 17, 14)];
    [chooseView setImage:[UIImage imageNamed:@"set_choose"]];
    [self.view addSubview:chooseView];
    
    // Do any additional setup after loading the view.
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    cell.textLabel.text = self.cellTitleArr[indexPath.section][indexPath.row];
    [cell.textLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [cell.textLabel setTextColor:[UIColor darkGrayColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row != _currentIndex) {
        _currentIndex = indexPath.row;
        [chooseView setFrame:CGRectMake(kScreenWidth - 35, 34+_currentIndex*44+15, 17, 14)];
        NSString *key = @"";
        if (_style == JYPrivacyDetailStyleFriendChat) {
            key = kAllowAddWithChat;
        }else{
            key = kAllowProfileShow;
        }
        // 1 ->0 2 3 //0 ->0 1 3
        
        NSInteger postValue = _currentIndex;
        if (_style == JYPrivacyDetailStyleShowMaterial) {
            if (_allow_second_friend_look_my_dync) {
                if (postValue > 0) {
                    postValue ++;
                }
            }else{
                if (postValue > 1) {
                    postValue ++;
                }
            }
        }
        
        NSDictionary *dic = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%ld",(long)postValue] forKey:key];
        [self requestUpdatePrivacyWithDic:dic];
    }
    self.ChangeBlock(cell.textLabel.text,_currentIndex);
    
}
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
