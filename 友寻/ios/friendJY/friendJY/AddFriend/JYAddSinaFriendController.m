//
//  JYAddSinaFriendController.m
//  friendJY
//
//  Created by chenxiangjing on 15/4/10.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYAddSinaFriendController.h"
#import <ShareSDK/ShareSDK.h>
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import "JYShareContentController.h"
#import "JYHttpServeice.h"

//#import "JYHttpServeice.h"
//#import <ShareSDK/iss>
@interface JYAddSinaFriendController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    UILabel *friendCountLab;
    NSMutableArray *_dataArr;
    NSMutableArray *_selectIndexs;
    
}
@end

@implementation JYAddSinaFriendController
- (instancetype)init{
    if (self == [super init]) {
        [self setTitle:@"新浪微博好友"];
        _dataArr = [NSMutableArray array];
//        for (int i = 0; i < 10 ; i ++) {
//            NSString *name = [NSString stringWithFormat:@"新浪好友%d",i];
//            [_dataArr addObject:name];
//        }
        _selectIndexs = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubviews];
    [self loadFriendData];
}
#pragma mark - 视图
- (void)initSubviews{
//    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"邀请" style:UIBarButtonItemStylePlain target:self action:@selector(inviteAction)]];
    
    friendCountLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth -15, 29)];
    [friendCountLab setFont:[UIFont systemFontOfSize:14.0f]];
    [friendCountLab setTextColor:[JYHelpers setFontColorWithString:@"#848484"]];
//    [friendCountLab setText:@"可选新浪好友(10)"];
    [self.view addSubview:friendCountLab];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, friendCountLab.bottom, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - 29) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setRowHeight:44];
    [_tableView setBackgroundColor:[UIColor clearColor]];
//    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.view addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] init]];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_dataArr count];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"sinaFriendcellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 6, 30, 30)];
        [icon setTag:1111];
        [icon setUserInteractionEnabled:YES];
        [icon setBackgroundColor:[UIColor lightGrayColor]];
        [icon.layer setMasksToBounds:YES];
        [icon.layer setCornerRadius:15];
        [cell.contentView addSubview:icon];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(icon.right + 10, 6, 100, 30)];
        [titleLab setTextColor:[JYHelpers setFontColorWithString:@"#848484"]];
        [titleLab setFont:[UIFont systemFontOfSize:15.0f]];
        [titleLab setTag:2222];
        [cell.contentView addSubview:titleLab];
        
        UIButton *inviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [inviteBtn setTitle:@"邀请" forState:UIControlStateNormal];
        [inviteBtn setTitleColor:kTextColorBlue forState:UIControlStateNormal];
        [inviteBtn setBackgroundColor:[UIColor whiteColor]];
        [inviteBtn setFrame:CGRectMake(kScreenWidth - 15 - 40, 0, 40, 44)];
        [inviteBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [inviteBtn addTarget:self action:@selector(inviteAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:inviteBtn];
    }
    UIImageView *icon = (UIImageView*)[cell.contentView viewWithTag:1111];
    UILabel *titleLab = (UILabel*)[cell.contentView viewWithTag:2222];
    NSDictionary *dataDic = [_dataArr objectAtIndex:indexPath.row];

    NSString *nameStr = dataDic[@"name"];
    CGFloat width = [nameStr boundingRectWithSize:CGSizeMake(kScreenWidth - 55 - titleLab.left, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0f]} context:nil].size.width;
    [titleLab setWidth:width];
    [icon sd_setImageWithURL:[NSURL URLWithString:dataDic[@"avatar"]] placeholderImage:[UIImage imageNamed:@"pic_morentouxiang_man"]];
    [titleLab setText:nameStr];
    [cell.contentView setTag:100+indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
//#pragma mark UITableViewDelegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
//
//}
#pragma mark - myRequest
//获取新浪好友数据

- (void)loadFriendData{

    
    NSDictionary *paraDic = @{
                              @"uid":_sinaUid,
                              @"access_token":_sinaToken,
                              @"count":@"50",
                              @"page":@"1"
                              };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:@"https://api.weibo.com/2/friendships/friends/bilateral.json" parameters:paraDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject---->%@",responseObject)

        NSArray *users = [responseObject objectForKey:@"users"];
        [users enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:[obj objectForKey:@"idstr"] forKey:@"id"];
            [dic setObject:[obj objectForKey:@"name"] forKey:@"name"];
            [dic setObject:[obj objectForKey:@"profile_image_url"] forKey:@"avatar"];
//            [dic setObject:@"0" forKey:@"selected"];
            [_dataArr addObject:dic];
        }];
        //微博api限定 只能获取30%的互相关注列表。
        [friendCountLab setText:[NSString stringWithFormat:@"可邀请新浪好友（%ld）",(long)_dataArr.count]];
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"errorDescription---->%@",[error localizedDescription])
    }];

}
//邀请微博好友
- (void)inviteAction:(UIButton*)button{
    NSInteger index = button.superview.tag - 100;
    NSLog(@"%ld",(long)index)
    NSString *content = [NSString stringWithFormat:@"快来【友寻】和我一起认识更多靠谱的朋友，朋友的朋友一秒变好友。和朋友的朋友谈恋爱，顺手解救身边的单身朋友，变身朋友圈丘比特。@%@http://m.iyouxun.com/wechat/friend_invite/?uid=%@",_dataArr[index][@"name"],ToString([SharedDefault objectForKey:@"uid"])];
//     = [NSString stringWithFormat:@"小伙伴，快来加入友寻吧.@%@http://www.baidu.com",_dataArr[index][@"name"]];
    
    JYShareContentController *shareContentVC = [[JYShareContentController alloc] init];
    //    UIPinchGestureRecognizer
    [shareContentVC setContent:content];
//    [shareContentVC setImageUrl:_dataArr[index][@"avatar"]];
    [self.navigationController pushViewController:shareContentVC animated:YES];
}

//#pragma mark - UIScrollViewDelegate 
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
//
//
//}
@end





