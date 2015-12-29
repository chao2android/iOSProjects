//
//  CoolThemeViewController.m
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-5.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "CoolThemeViewController.h"
#import "BottomDetailView.h"

@interface CoolThemeViewController ()

@end

@implementation CoolThemeViewController

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
    self.view.backgroundColor = [UIColor colorWithWhite:0.91 alpha:1.0];
    self.title = @"主题详情";
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
    
    mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    mScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:mScrollView];

    int iTop = 4;
    
    for (int i = 0; i < 4; i ++) {
        NSString *imagename = [NSString stringWithFormat:@"%d.png", i+123];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, iTop, mScrollView.frame.size.width-4, 122)];
        imageView.image = [UIImage imageNamed:imagename];
        imageView.tag = i+1300;
        [mScrollView addSubview:imageView];
        
        iTop += (imageView.frame.size.height+2);
    }
    
    BottomDetailView *detailView = [[BottomDetailView alloc] initWithFrame:CGRectMake(0, iTop, mScrollView.frame.size.width, 444)];
    detailView.mRootCtrl = self;
    [mScrollView addSubview:detailView];
    
    iTop += detailView.frame.size.height;
    
    mScrollView.contentSize = CGSizeMake(mScrollView.frame.size.width, iTop);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
