//
//  TJMineViewController.m
//  TJLike
//
//  Created by IPTV_MAC on 15/3/29.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJMineViewController.h"
#import "MineCateButton.h"
#import "MainInformationViewController.h"
#import "MainSettingViewController.h"
#import "TJMineFeedbackView.h"
#import "TJUserAuthorManager.h"
#import "UIImageView+WebCache.h"

@interface TJMineViewController ()
{
    UIImageView *topBack;
    UIImageView *headIcon;
    UILabel *nameLabel;
    UILabel *signLabel;
    UIButton *outBtn;
}
@end

@implementation TJMineViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.naviController setNaviBarTitle:@"我"];
    [self.naviController setNavigationBarHidden:NO];
}
- (void)InitUserData{
    NSLog(@"UserManager.userInfor.nickName---->%@",UserManager.userInfor.nickName);
    [outBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [headIcon sd_setImageWithURL:[NSURL URLWithString:UserManager.userInfor.icon]];
    nameLabel.text = UserManager.userInfor.nickName;
    signLabel.text = UserManager.userInfor.signature;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:240/250.f green:240/250.f blue:240/250.f alpha:1];
    
    topBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 180)];
    topBack.image = [UIImage imageNamed:@"11-1_09"];
    [self.view addSubview:topBack];
    
    headIcon = [[UIImageView alloc]initWithFrame:CGRectMake(15, 72.5, 70, 70)];
    headIcon.layer.masksToBounds = YES;
    headIcon.layer.cornerRadius = 72.5*0.5;
    [topBack addSubview:headIcon];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(94, 70+30, SCREEN_WIDTH-120, 19)];
    nameLabel.font = [UIFont systemFontOfSize:18];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor = [UIColor whiteColor];
    [topBack addSubview:nameLabel];
    
    //白色半透明
    UIView *mView = [[UIView alloc]initWithFrame:CGRectMake(0, 150, SCREEN_WIDTH, 20)];
    mView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    [topBack addSubview:mView];
    
    signLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 20)];
    signLabel.backgroundColor = [UIColor clearColor];
    signLabel.textColor = [UIColor blackColor];
    signLabel.font = [UIFont systemFontOfSize:12];
    [mView addSubview:signLabel];
    
    mView = [[UIView alloc]initWithFrame:CGRectMake(0, 170+64, SCREEN_WIDTH, 43)];
    mView.backgroundColor = [UIColor colorWithWhite:0.80 alpha:1];
    [self.view addSubview:mView];
    
    UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.5, 5, 0.7, 43-10)];
    lineView.backgroundColor = [UIColor darkGrayColor];
    [mView addSubview:lineView];
    
    for (int i = 0; i<2; i++) {
        MineCateButton *btn = [MineCateButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*SCREEN_WIDTH*0.5, 0, SCREEN_WIDTH*0.5, 43);
        btn.backgroundColor = [UIColor clearColor];
        [btn setImage:i==0?[UIImage imageNamed:@"my_ziliao_"]:[UIImage imageNamed:@"my_sixin_"] forState:UIControlStateNormal];
        [btn setTitle:i==0?@"资料":@"私信" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
        btn.tag = 1000+i;
        [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [mView addSubview:btn];
    }
    
    for (int i = 0; i<2; i++) {
        UIView *sView = [[UIView alloc]initWithFrame:CGRectMake(0, 170+64+43+10+i*53, SCREEN_WIDTH, 43)];
        sView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:sView];
        
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10.25, 22.5, 22.5)];
        icon.image = [UIImage imageNamed:i==0?@"my_sixin_":@"my_shezhi_"];
        [sView addSubview:icon];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(52.5, 0, 100, 43)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:20];
        label.textColor = [UIColor blackColor];
        label.text = i==0?@"提交反馈":@"设置";
        [sView addSubview:label];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 43);
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 2000+i;
        [sView addSubview:btn];
    }
    
    outBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    outBtn.frame = CGRectMake(30, 170+64+43+10+140, SCREEN_WIDTH-60, 37.5);
    outBtn.backgroundColor = [UIColor colorWithWhite:0.80 alpha:1];
    [outBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [outBtn addTarget:self action:@selector(UserLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:outBtn];
    
    
    if ([[TJUserAuthorManager registerPageManager]gainCurrentStateForUserLoginAndBind]==0) {
        [outBtn setTitle:@"登录" forState:UIControlStateNormal];

    }else{
        [self InitUserData];
    }
}
- (void)UserLogin{
    NSLog(@"----");
    if ([UserAuthorManager gainCurrentStateForUserLoginAndBind]==0){
        [UserAuthorManager authorizationLogin:self EnterPage:EnterPresentMode_push andSuccess:^{
            NSLog(@"成功");
            [self InitUserData];
        }andFaile:^{
            NSLog(@"失败");
        }];
    }else{
        [UserManager quitUserSuccess:^{
            headIcon.image = nil;
            nameLabel.text = @"";
            signLabel.text = @"";
            [outBtn setTitle:@"登录" forState:UIControlStateNormal];
        }];
    }
}
- (void)BtnClick:(UIButton *)sender{
    if (sender.tag == 1000) {
        MainInformationViewController *ctrl = [[MainInformationViewController alloc]init];
        __weak __typeof(self)weakSelf = self;
        ctrl.mBlock = ^{
            [weakSelf InitUserData];
        };
        [self.naviController pushViewController:ctrl animated:YES];
    }else if(sender.tag == 1001){
        
    }
    else if(sender.tag == 2000){
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        TJMineFeedbackView *commentView = [[TJMineFeedbackView alloc] initWithFrame:window.bounds];
        [window addSubview:commentView];
    }
    else if(sender.tag == 2001){
        MainSettingViewController *ctrl = [[MainSettingViewController alloc]init];
        [self.naviController pushViewController:ctrl animated:YES];
    }
}
- (void)sendClick:(NSString *)sender{
    
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
