//
//  TestViewController.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-12-4.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"本地";
    
    [self AddLeftImageBtn:[UIImage imageNamed:@"f_citybtn"] target:self action:@selector(OnLeftClick)];
    [self AddRightTextBtn:@"搜索" target:self action:@selector(OnSearchClick)];
    
    UIButton *rightBtn = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
    rightBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}

- (void)OnLeftClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_ShowLeft object:nil];
}

- (void)OnSearchClick {
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sina.5211818556240bc9ee01db2f://"]];
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
