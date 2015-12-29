//
//  AboutUsViewController.m
//  TestNewsDaLian
//
//  Created by dxy on 14/12/23.
//  Copyright (c) 2014年 zp. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.title = @"关于我们";
    [self AddLeftImageBtn:[UIImage imageNamed:@"goBack.png"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self uiConfig];
    // Do any additional setup after loading the view.
}

#pragma mark - UI布局
- (void)uiConfig{
    self.view.backgroundColor =[UIColor whiteColor];
    UIImageView * picImageView = [[UIImageView alloc] initWithFrame:CGRectMake((MainScreenWidth - 139)/2, 100, 139, 149)];
    picImageView.image = [UIImage imageNamed:@"logo.png"];
    [self.view addSubview:picImageView];

    UILabel * versionLabel = [DxyCustom creatLabelWithFrame:CGRectMake(0, MainScreenHeight - 140, MainScreenWidth, 20) text:@"版本号：V1.2" alignment:NSTextAlignmentCenter];
    versionLabel.textColor = [UIColor colorWithRed:109/255.0 green:109/255.0 blue:109/255.0 alpha:1];
    [self.view addSubview:versionLabel];
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
