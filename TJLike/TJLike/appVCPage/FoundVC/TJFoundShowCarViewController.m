//
//  TJFoundShowCarViewController.m
//  TJLike
//
//  Created by MC on 15/4/18.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJFoundShowCarViewController.h"

@interface TJFoundShowCarViewController ()
{
    UILabel *nameLabel;
}
@end

@implementation TJFoundShowCarViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.naviController setNaviBarTitle:@"违章查询"];
    [self.naviController setNavigationBarHidden:NO];
    [self.naviController setNaviBarDefaultLeftBut_Back];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:240/250.f green:240/250.f blue:240/250.f alpha:1];
    
    UIView *mView = [[UIView alloc]initWithFrame:CGRectMake(10, 70, SCREEN_WIDTH-20, 70)];
    mView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mView];
    
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 28, 28)];
    icon.image = [UIImage imageNamed:@"fonud_8_"];
    [mView addSubview:icon];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 13, 200, 20)];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:18];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = [NSString stringWithFormat:@"津：%@",self.CarId];
    [mView addSubview:nameLabel];
    
    UILabel *mLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 43, 200, 20)];
    mLabel.textColor = [UIColor blackColor];
    mLabel.font = [UIFont systemFontOfSize:18];
    mLabel.text = @"未处理违章次数0次";
    [mView addSubview:mLabel];
    
    mLabel = [[UILabel alloc]initWithFrame:CGRectMake(mView.bounds.size.width-60, 0, 50, 70)];
    mLabel.backgroundColor = [UIColor clearColor];
    mLabel.textColor = [UIColor blackColor];
    mLabel.font = [UIFont systemFontOfSize:30];
    mLabel.text = @"0";
    mLabel.textAlignment = NSTextAlignmentRight;
    [mView addSubview:mLabel];
    
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
