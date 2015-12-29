//
//  JYGuideController.m
//  friendJY
//
//  Created by 高斌 on 15/3/2.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYGuideController.h"
#import "JYLoginController.h"
#import "JYProfileController.h"
#import "JYRegisterController.h"
#import "JYGuidePageControl.h"

@interface JYGuideController ()<UIScrollViewDelegate>
{
    JYGuidePageControl *pageControl;
}
@end

@implementation JYGuideController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    [self.view setBackgroundColor:[UIColor whiteColor]];
//    self.navigationItem
    UIScrollView *myScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [myScrollView setPagingEnabled:YES];
    [myScrollView setShowsHorizontalScrollIndicator:NO];
    [myScrollView setShowsVerticalScrollIndicator:NO];
    [myScrollView setContentSize:CGSizeMake(kScreenWidth*4, kScreenHeight)];
    [myScrollView setBounces:NO];
    [myScrollView setDelegate:self];
    [self.view addSubview:myScrollView];
    
    for (int i = 0; i < 4; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth*i, 0, kScreenWidth, kScreenHeight)];
        [imageView setUserInteractionEnabled:YES];
        NSString *imageName = [NSString stringWithFormat:@"guide_%ld",(long)i+1];
        [imageView setImage:[UIImage imageNamed:imageName]];
        if (i == 3) {
//            UIImageView *joinImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-95*self.autoSizeScaleX)/2,kScreenHeight - (115 +24)*self.autoSizeScaleY, 95*self.autoSizeScaleX, 24*self.autoSizeScaleY)];
            UIImageView *joinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-15-95*self.autoSizeScaleX,kScreenHeight - (115 +24)*self.autoSizeScaleY, 95*self.autoSizeScaleX, 24*self.autoSizeScaleY)];

            [joinImageView setImage:[UIImage imageNamed:@"guide_login"]];
            [joinImageView setUserInteractionEnabled:YES];
//            [joinImageView setBackgroundColor:[UIColor orangeColor]];
            [joinImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginBtnClick)]];
            [imageView addSubview:joinImageView];
            
            UIImageView *registerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2+15, joinImageView.top, joinImageView.width, joinImageView.height)];
            [registerImageView setUserInteractionEnabled:YES];
            [registerImageView setImage:[UIImage imageNamed:@"guide_register"]];
            [registerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(registBtnClick)]];
            [imageView addSubview:registerImageView];
        }
        [myScrollView addSubview:imageView];
    }
    
    pageControl = [[JYGuidePageControl alloc] initWithFrame:CGRectMake(kScreenWidth/2 - 95*self.autoSizeScaleX/2, kScreenHeight - 60*self.autoSizeScaleY, 95*self.autoSizeScaleX, 10)];
    [pageControl setPageImage:[UIImage imageNamed:@"guide_point_normal"]];
    [pageControl setCurrentPageImage:[UIImage imageNamed:@"guide_point_select"]];
    [pageControl setNumberOfPages:4];
    [pageControl setCurrentPage:0];
    [self.view addSubview:pageControl];
    
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

- (void)loginBtnClick
{
    NSLog(@"登录");
    JYLoginController *loginController = [[JYLoginController alloc] init];
    [self.navigationController pushViewController:loginController animated:YES];
    
}

- (void)registBtnClick
{
    NSLog(@"注册");
    JYRegisterController *registerController = [[JYRegisterController alloc] init];
    [self.navigationController pushViewController:registerController animated:YES];

}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger page = scrollView.contentOffset.x/kScreenWidth;
    [pageControl setCurrentPage:page];
}
@end
