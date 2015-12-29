//
//  JYNavigationController.m
//  friendJY
//
//  Created by 高斌 on 15/2/28.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYNavigationController.h"
#import "JYNavigationBar.h"

@interface JYNavigationController ()

@end

@implementation JYNavigationController

- (id)initWithRootViewController:(UIViewController *)rootViewController {

    self = [super initWithNavigationBarClass:[JYNavigationBar class] toolbarClass:nil];
    if (self) {
        
        self.viewControllers = @[rootViewController];
        
//        UIColor *barTintColor = [JYHelpers setFontColorWithString:@"#E14F64"];
//        UIColor *tintColor = [JYHelpers setFontColorWithString:@"#FFFFFF"];
//        UIColor *textColor = [JYHelpers setFontColorWithString:@"#FFFFFF"];

        UIColor *barTintColor = [UIColor whiteColor]; //NavigationBar背景色
//        UIColor *tintColor = [UIColor yellowColor];
        UIColor *textColor = [UIColor blackColor];
        
        UIColor *textShadowColor = [UIColor whiteColor];
        
        if (SYSTEM_VERSION >= 7.0f) {
            
            // 设置导航栏字体颜色
            self.navigationBar.barTintColor = barTintColor;
//            self.navigationBar.tintColor = tintColor;
            
        } else {
            // iOS6 设置导航栏背景
            [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
        }
        
        [self.navigationBar setTitleTextAttributes:[NSDictionary
                                                    dictionaryWithObjectsAndKeys:textColor, UITextAttributeTextColor,
                                                    textShadowColor,UITextAttributeTextShadowColor,
                                                    [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],UITextAttributeTextShadowOffset,nil]];
        
        
    }
    
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self.navigationBar setHidden:YES];
    
//    [self initNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavigationBar
{
    NSLog(@"%f", kScreenWidth);
    
    UIImageView *navigationBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarHeight+kNavigationBarHeight)];
    [navigationBar setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:navigationBar];
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(100, kStatusBarHeight, kScreenWidth-200, kNavigationBarHeight)];
    [_titleLab setFont:[UIFont systemFontOfSize:kNavigationBarTitleFontSize]];
    [_titleLab setTextColor:[UIColor whiteColor]];
    [_titleLab setTextAlignment:NSTextAlignmentCenter];
    [_titleLab setBackgroundColor:[UIColor darkGrayColor]];
    [navigationBar addSubview:_titleLab];
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
