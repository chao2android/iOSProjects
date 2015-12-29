//
//  JYFeedGroupController.m
//  friendJY
//
//  Created by ouyang on 4/24/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//

#import "JYFeedGroupController.h"

@interface JYFeedGroupController ()

@end

@implementation JYFeedGroupController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"好友分组"];
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //右上角添加动态
    UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navRightBtn.backgroundColor = [UIColor clearColor];
    [navRightBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [navRightBtn setTitleColor:[JYHelpers setFontColorWithString:@"#2695ff"] forState:UIControlStateNormal];
    [navRightBtn setTitle:@"新建" forState:UIControlStateNormal];
    [navRightBtn setFrame:CGRectMake(0, 0, 40, 20)];
    [navRightBtn addTarget:self action:@selector(_clickRightTopButton) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:navRightBtn]];
}

- (void)_clickRightTopButton{
}
@end
