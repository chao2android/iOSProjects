//
//  TJFoundCarSettingViewController.m
//  TJLike
//
//  Created by MC on 15/4/18.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJFoundCarSettingViewController.h"

@interface TJFoundCarSettingViewController ()

@end

@implementation TJFoundCarSettingViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.naviController setNaviBarTitle:@"车务提醒"];
    [self.naviController setNavigationBarHidden:NO];
    [self.naviController setNaviBarDefaultLeftBut_Back];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:240/250.f green:240/250.f blue:240/250.f alpha:1];
    
    
    NSArray *imageArray = @[@"fonud_11_",@"fonud_12_",@"fonud_13_",@"fonud_14_"];
    NSArray *titleArray = @[@"车辆限行提醒",@"车辆年检提醒",@"车辆续保提醒",@"驾照换证提醒"];
    for (int i = 0; i<4; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 74+i*70, SCREEN_WIDTH, 70)];
        view.backgroundColor = [UIColor whiteColor];
        view.userInteractionEnabled = YES;
        [self.view addSubview:view];
        
        for (int j = 0; j<2; j++) {
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, j*69.5, SCREEN_WIDTH, 0.5)];
            lineView.backgroundColor = [UIColor lightGrayColor];
            [view addSubview:lineView];
        }
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(5, 20, 30, 30)];
        icon.image = [UIImage imageNamed:imageArray[i]];
        [view addSubview:icon];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(70, 15, 200, 20)];
        title.backgroundColor = [UIColor clearColor];
        title.font = [UIFont systemFontOfSize:18];
        title.textColor = [UIColor blackColor];
        title.text = titleArray[i];
        [view addSubview:title];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(SCREEN_WIDTH-80, 25, 50, 20);
        [btn setTitle:i==0?@"关闭":@"设置" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [view addSubview:btn];
    }
    
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(15, SCREEN_HEIGHT-150, self.view.frame.size.width-30, 44);
    [loginBtn setBackgroundColor:[UIColor grayColor]];
    [loginBtn setTitle:@"删除该车辆信息" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [loginBtn addTarget:self action:@selector(OnRegisterClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
}
- (void)OnRegisterClick{
    if ([SHARE_DEFAULTS objectForKey:@"Car"] && [[SHARE_DEFAULTS objectForKey:@"Car"] isKindOfClass:[NSArray class]]) {
        NSArray *array = [SHARE_DEFAULTS objectForKey:@"Car"];
        NSMutableArray *marray = [array mutableCopy];
        [marray removeObjectAtIndex:self.indexPath];
        [SHARE_DEFAULTS setObject:marray forKey:@"Car"];
        [SHARE_DEFAULTS synchronize];
    }
    self.mBlock();
    [self.naviController popViewControllerAnimated:YES];
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
