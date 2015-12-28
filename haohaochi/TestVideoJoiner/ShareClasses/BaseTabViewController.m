//
//  BaseTabViewController.m
//  TestHebei
//
//  Created by Hepburn Alex on 14-6-4.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseTabViewController.h"
#import "SelectTabBar.h"

@interface BaseTabViewController ()

@end

@implementation BaseTabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.mTopImage = [UIImage imageNamed:@"topbar-w"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    UIView *supview = [SelectTabBar Share].superview;
    [supview bringSubviewToFront:[SelectTabBar Share]];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    NSLog(@"viewDidAppear2");
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSLog(@"viewWillAppear");
    [SelectTabBar Share].hidden = NO;
    UIView *supview = [SelectTabBar Share].superview;
    [supview bringSubviewToFront:[SelectTabBar Share]];
    [self RefreshNavColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
