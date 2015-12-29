//
//  PayViewController.m
//  TestRedCollar
//
//  Created by MC on 14-8-16.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "PayViewController.h"
#import "AutoAlertView.h"
@interface PayViewController ()

@end

@implementation PayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)Home{
    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_Logout object:nil userInfo:nil];
    [self GoHome];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单支付";
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    //[self AddLeftImageBtn:nil target:nil action:nil];
    [self AddRightTextBtn:@"关闭" target:self action:@selector(Home)];
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    [webView loadRequest:[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.payURL]]];
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
