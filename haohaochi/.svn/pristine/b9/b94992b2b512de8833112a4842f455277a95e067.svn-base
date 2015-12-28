//
//  AboutViewController.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-12-15.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    self.mTopImage = [UIImage imageNamed:@"Image-2"];
    self.mTitleColor = [UIColor whiteColor];
    [super viewDidLoad];
    
    [self AddLeftImageBtn:[UIImage imageNamed:@"p_backbtn3"] target:self action:@selector(GoBack) scale:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.mTopImage = [UIImage imageNamed:@"Image-2"];
    [self RefreshNavColor];
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
