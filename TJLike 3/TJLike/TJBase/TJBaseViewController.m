//
//  TJBaseViewController.m
//  TJLike
//
//  Created by IPTV_MAC on 15/3/28.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJBaseViewController.h"

@interface TJBaseViewController()


@end

@implementation TJBaseViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (TJBaseNavigationController *)naviController
{
    return (TJBaseNavigationController *)self.navigationController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.naviController.interactivePopGestureRecognizer.enabled = NO;

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.naviController hideOriginalBarItems];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


@end
