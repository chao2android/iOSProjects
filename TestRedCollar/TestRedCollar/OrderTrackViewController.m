//
//  OrderTrackViewController.m
//  TestRedCollar
//
//  Created by dreamRen on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "OrderTrackViewController.h"

@interface OrderTrackViewController (){
    UIScrollView *mScrollView;
}

@end

@implementation OrderTrackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:0.91 alpha:1.0];
    self.title = @"订单跟踪";
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
    
    mScrollView=[[UIScrollView alloc] initWithFrame:self.view.bounds];
    mScrollView.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    mScrollView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:mScrollView];
    
    UIImageView *tImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 502)];
    tImageView.image=[UIImage imageNamed:@"tTrack"];
    [mScrollView addSubview:tImageView];
    
    mScrollView.contentSize=CGSizeMake(320, tImageView.frame.size.height);
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
