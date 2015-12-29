//
//  ExchangeInfoViewController.m
//  TestRedCollar
//
//  Created by dreamRen on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ExchangeInfoViewController.h"
#import "HowGetMoneyViewController.h"

@interface ExchangeInfoViewController ()

@end

@implementation ExchangeInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)onExchangeClick{
    [self showMsg:@"兑换成功"];
}

-(void)onHowClick{
    HowGetMoneyViewController *tViewCtr=[[HowGetMoneyViewController alloc] init];
    UINavigationController *tNav=[[UINavigationController alloc] initWithRootViewController:tViewCtr];
    [self presentModalViewController:tNav animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.91 alpha:1.0];
    self.title = _theInfoName;
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
    
    UIImageView *tImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 504)];
    tImageView.image=[UIImage imageNamed:@"tExchangeInfo.jpg"];
    [self.view addSubview:tImageView];
    
    UIButton *tButton=[UIButton buttonWithType:UIButtonTypeCustom];
    tButton.frame=CGRectMake(14, 262, 97, 32);
    [tButton setBackgroundImage:[UIImage imageNamed:@"149"] forState:UIControlStateNormal];
    [tButton addTarget:self action:@selector(onExchangeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tButton];
    
    
    CGRect tRect=tButton.frame;
    tRect.origin.x=tButton.frame.origin.x+tButton.frame.size.width+10;
    tRect.size.width=140;
    tButton=[UIButton buttonWithType:UIButtonTypeCustom];
    tButton.frame=tRect;
    [tButton addTarget:self action:@selector(onHowClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
