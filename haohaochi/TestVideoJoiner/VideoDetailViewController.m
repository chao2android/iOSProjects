//
//  VideoDetailViewController.m
//  TestVideoJoiner
//
//  Created by MC on 14-12-2.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "VideoDetailViewController.h"
#import "TouchView.h"

@interface VideoDetailViewController ()

@end

@implementation VideoDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    
    self.hidesBottomBarWhenPushed = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    self.hidesBottomBarWhenPushed = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"字里行间";
    [self AddLeftImageBtn:[UIImage imageNamed:@"3_03.png"] target:self action:@selector(GoBack)];
    
    for (int i = 0; i<2; i++) {
        TouchView *touchView = [[TouchView alloc]initWithFrame:CGRectMake(0+ i*KscreenWidth*0.5, KscreenHeigh-125, KscreenWidth*0.5, 65)];
        touchView.backgroundColor = [UIColor clearColor];
//        UILabel *mLabel = [UILabel alloc]initWithFrame:CGRectMake(25, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
//        [self.view addSubview:touchView];
    }
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
