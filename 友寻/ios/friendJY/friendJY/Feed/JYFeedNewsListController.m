//
//  JYFeedNewsListController.m
//  friendJY
//
//  Created by ouyang on 4/18/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//

#import "JYFeedNewsListController.h"
#import "JYHttpServeice.h"
#import "JYFeedNewsListTableView.h"
#import "JYFeedNewsListModel.h"
#import "JYAppDelegate.h"
#import "JYFeedDetailController.h"

@interface JYFeedNewsListController ()

@end

@implementation JYFeedNewsListController{
    JYFeedNewsListTableView *myTableView ;
    NSMutableArray *dataList;
    NSString *page;
    UIButton *navRightBtn;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"熟人圈"];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    navRightBtn.hidden = dataList.count==0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    page = @"1";
    dataList = [NSMutableArray array];
    myTableView = [[JYFeedNewsListTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight -kStatusBarHeight) style:UITableViewStylePlain];
    myTableView.refreshFooterDelegate = self;
    [self.view addSubview:myTableView];
    
    //右上角添加动态
    navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navRightBtn.backgroundColor = [UIColor clearColor];
    [navRightBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [navRightBtn setTitleColor:[JYHelpers setFontColorWithString:@"#2695ff"] forState:UIControlStateNormal];
    [navRightBtn setTitle:@"全部标记为已读" forState:UIControlStateNormal];
    [navRightBtn setFrame:CGRectMake(0, 0, 105, 20)];
    [navRightBtn addTarget:self action:@selector(_clickRightTopButton) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:navRightBtn]];
    
    [self formHttpGetSysList];
}

- (void)backAction
{
    [self _clickRightTopButton];
    [super backAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * 获取系统消息提醒列表
 *
 * type - sys 系统消息 group所有群消息 crgroup 建群消息 addgroup 申请加入群消息 qtgroup 退群消息 photo
 * 照片赞 reply 照片评论 reject 拒绝好友加入群 accept 接受好友加入群 del 群主踢人 invite 所有人可以邀请好友加入(一度)
 * like 动态被赞 rebroadcast 动态被转播 comment 动态被评论 reply 被回复评论
 *
 * page - 页码 @default 1 @min 1
 *
 * pageSize - 页码 @default 10 @min 1 @max 20
 *
 * avatarSize - 图像尺寸 @default 50
 *
 * status - 消息状态 0未读 1已读 -1全部 100全部含已删除
 *
 * autostatus - 自动设置已读 0/1 @default 1
 *
 * @author likai
 * @date 2015-3-25 上午10:42:16
 *
 */
- (void) formHttpGetSysList{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"msg" forKey:@"mod"];
    [parametersDict setObject:@"listsys" forKey:@"func"];

    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:page forKey:@"page"];
    [postDict setObject:@"20" forKey:@"pageSize"];
    [postDict setObject:@"0" forKey:@"status"];
    [postDict setObject:@"dynamic" forKey:@"type"];
    [postDict setObject:@"0" forKey:@"autostatus"];

    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {

        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
         if (iRetcode == 1) {
             if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                 NSArray *rArray = [responseObject objectForKey:@"data"];
                 NSLog(@"rArray--->%@",rArray);
                 if (rArray.count < 20) {
                     page = [NSString stringWithFormat:@"%d",[page intValue]-1];
                     myTableView.isMore = NO;
                 }else{
                     myTableView.isMore = YES;
                 }
                 for (NSDictionary * temp in rArray) {
                     JYFeedNewsListModel * feedModel = [[JYFeedNewsListModel alloc] initWithDataDic:temp];
                     [dataList addObject:feedModel];
                 }
                 myTableView.data = dataList;
                 if (dataList.count < 20) {
                     [myTableView showOrHiddenTextView:@"" showOrHidden:YES];
                 }
                 [myTableView reloadData];
             }else{
                 NSLog(@"数据为空");
             }
             
         }else{
             [[JYAppDelegate sharedAppDelegate] showTip:[responseObject objectForKey:@"retmean"]];
         }
        navRightBtn.hidden = dataList.count==0;

    } failure:^(id error) {
        
        NSLog(@"%@", error);
        
    }];
}

//点击进入动态详情
- (void)didSelectRowAtIndexPath:(JYBaseFooterTableView *)tabelView indexPath:(NSIndexPath *)indexPath{
    JYFeedNewsListModel * temp = (JYFeedNewsListModel *)[dataList objectAtIndex:indexPath.row];
    JYFeedDetailController * _profileVC = [[JYFeedDetailController alloc] init];
    _profileVC.bcakBlock =  ^ int {
        return (int)dataList.count;
    };
    _profileVC.feedid = temp.fid;
    [self.navigationController pushViewController:_profileVC animated:YES];
    [dataList removeObjectAtIndex:indexPath.row];
    tabelView.data = dataList;
    [tabelView reloadData];
    [self setHaveReade:temp];
}
- (void)setHaveReade:(JYFeedNewsListModel *)model{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"msg" forKey:@"mod"];
    [parametersDict setObject:@"del_sysmsg" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:model.type forKey:@"type"];
    [postDict setObject:model.iid forKey:@"iid"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            
        }else{
        }
        
    } failure:^(id error) {
        
        NSLog(@"%@", error);
        
    }];
}


- (void) _clickRightTopButton{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"msg" forKey:@"mod"];
    [parametersDict setObject:@"set_onread_allsysmsg" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:@"dynamic" forKey:@"type"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            
            
        }else{
            [[JYAppDelegate sharedAppDelegate] showTip:[responseObject objectForKey:@"retmean"]];
        }
        
        
    } failure:^(id error) {
        
        NSLog(@"%@", error);
        
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

// 上拉事件
- (void)pullUp:(JYBaseFooterTableView *)tableView{
    page = [NSString stringWithFormat:@"%d",[page intValue]+1];
    [self formHttpGetSysList];
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
