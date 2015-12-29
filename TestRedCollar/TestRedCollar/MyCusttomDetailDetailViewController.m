//
//  MyCusttomDetailDetailViewController.m
//  TestRedCollar
//
//  Created by MC on 14-8-15.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "MyCusttomDetailDetailViewController.h"

@interface MyCusttomDetailDetailViewController ()

@end

@implementation MyCusttomDetailDetailViewController

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
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
    
    UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    web.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    web.scalesPageToFit = YES;
    [self.view addSubview:web];
    [web loadHTMLString:self.urlString baseURL:nil];
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
