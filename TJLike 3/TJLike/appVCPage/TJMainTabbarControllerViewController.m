//
//  TJMainTabbarControllerViewController.m
//  TJLike
//
//  Created by IPTV_MAC on 15/3/29.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJMainTabbarControllerViewController.h"

#import "TJNewsNaviController.h"
#import "TJForumNaviController.h"
#import "TJFoundNaviController.h"
#import "TJMineNaviController.h"

#define ItemsImageName @[@"news_bottom",@"bbs_bottom",@"found_bottom",@"mine_bottom"]
#define ItemsSelectedImageName @[@"news_bottom_secelted",@"bbs_bottom_selected",@"found_bottom_selected",@"mine_bottom_selected"]
#define ItemsTitle @[@"资讯",@"论坛",@"发现",@"我的"]


@interface TJMainTabbarControllerViewController ()

@end

@implementation TJMainTabbarControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    TJNewsNaviController *newsNavi = [[TJNewsNaviController alloc] initWithRootViewController:[[TJNewsViewController alloc] init]];
    TJForumNaviController *forumNavi = [[TJForumNaviController alloc] initWithRootViewController:[[TJForumViewController alloc] init]];
    TJFoundNaviController *foundNavi = [[TJFoundNaviController alloc] initWithRootViewController:[[TJFoundViewController alloc] init]];
    TJMineNaviController *mineNavi = [[[TJMineNaviController alloc] init] initWithRootViewController:[[TJMineViewController alloc] init]];
    self.viewControllers = @[newsNavi,forumNavi,foundNavi,mineNavi];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabbarViewModel.models = [self initialBusPageTabBarItems];
}



/**
 *  设置按钮图片
 *
 *  @return tabbar item 的数据模型数组
 */
-(NSArray *)initialBusPageTabBarItems
{
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i< ItemsImageName.count; i++) {
        TJBaseTabbarItem *model = [[TJBaseTabbarItem alloc] init];
        model.itemImageName = ItemsImageName[i];
        model.itemSelectedImageName = ItemsSelectedImageName[i];
        model.itemTitle = ItemsTitle[i];
        model.itemEnable = YES;
        model.itemTag = i;
        [arr addObject:model];
    }
    
    return arr;
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
