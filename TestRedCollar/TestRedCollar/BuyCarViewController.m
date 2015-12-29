//
//  BuyCarViewController.m
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-5.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BuyCarViewController.h"
#import "TouchView.h"
#import "AutoAlertView.h"
#import "HistoryDataViewController.h"
#import "ServiceViewController.h"

@interface BuyCarViewController ()

@end

@implementation BuyCarViewController

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
    self.title = @"购物车";
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
    
    mScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    mScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:mScrollView];
    
    int iTop = 10;
    TouchView *touchView = [[TouchView alloc] initWithFrame:CGRectMake(0, iTop, mScrollView.frame.size.width, 110)];
    touchView.image = [[UIImage imageNamed:@"f_whiteback"] stretchableImageWithLeftCapWidth:50 topCapHeight:30];
    touchView.delegate = self;
    touchView.OnViewClick = @selector(OnTopClick);
    [mScrollView addSubview:touchView];
    
    UILabel *lbName = [[UILabel alloc] initWithFrame:CGRectMake(10, (touchView.frame.size.height-30)/2, 100, 30)];
    lbName.backgroundColor = [UIColor clearColor];
    lbName.font = [UIFont systemFontOfSize:16];
    lbName.text = @"定制品";
    [touchView addSubview:lbName];
    
    UIImageView *flagView = [[UIImageView alloc] initWithFrame:CGRectMake(touchView.frame.size.width-17, (touchView.frame.size.height-12)/2, 7, 12)];
    flagView.image = [UIImage imageNamed:@"52.png"];
    [touchView addSubview:flagView];
    
    UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake((touchView.frame.size.width-90)/2, (touchView.frame.size.height-90)/2, 90, 90)];
    headView.image = [UIImage imageNamed:@"62.png"];
    [touchView addSubview:headView];
    
    iTop += (touchView.frame.size.height+10);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, iTop, mScrollView.frame.size.width, 200)];
    imageView.image = [[UIImage imageNamed:@"f_whiteback"] stretchableImageWithLeftCapWidth:50 topCapHeight:30];
    imageView.userInteractionEnabled = YES;
    [mScrollView addSubview:imageView];
    
    NSArray *names = @[@"量体数据", @"上门量取", @"选择已有数据", @"标准码"];
    for (int i = 0; i < names.count; i ++) {
        int iLeft = (i == 0)?15:30;
        int iFontSize = (i == 0)?16:14;
        UILabel *lbName = [[UILabel alloc] initWithFrame:CGRectMake(iLeft, 10+i*50, 150, 30)];
        lbName.backgroundColor = [UIColor clearColor];
        lbName.font = [UIFont systemFontOfSize:iFontSize];
        lbName.text = [names objectAtIndex:i];
        [imageView addSubview:lbName];
        
        if (i > 0) {
            UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(15, i*50, imageView.frame.size.width-15, 1)];
            lineView.image = [UIImage imageNamed:@"51.png"];
            [imageView addSubview:lineView];
        }
    }
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(imageView.frame.size.width-50, 50, 50, 50);
    [selectBtn setImage:[UIImage imageNamed:@"53_2"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"53"] forState:UIControlStateSelected];
    selectBtn.tag = 1500;
    [selectBtn addTarget:self action:@selector(OnSelectClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:selectBtn];
    
    mSelectBtn = selectBtn;
    [mSelectBtn setSelected:YES];
    
    selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(imageView.frame.size.width-50, 100, 50, 50);
    [selectBtn setImage:[UIImage imageNamed:@"53_2"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"53"] forState:UIControlStateSelected];
    selectBtn.tag = 1501;
    [selectBtn addTarget:self action:@selector(OnSelectClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:selectBtn];
    
    lbName = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.size.width-150, 100, 100, 50)];
    lbName.backgroundColor = [UIColor clearColor];
    lbName.font = [UIFont systemFontOfSize:12];
    lbName.textColor = [UIColor grayColor];
    lbName.textAlignment = NSTextAlignmentRight;
    lbName.text = @"2014-03-03数据";
    [imageView addSubview:lbName];
    
    NSArray *array = @[@"L", @"XL", @"XXL"];
    for (int i = 0; i < 3; i ++) {
        selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.frame = CGRectMake(155+55*i, 159, 42, 32);
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"63"] forState:UIControlStateNormal];
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"64"] forState:UIControlStateSelected];
        [selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [selectBtn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        selectBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [selectBtn addTarget:self action:@selector(OnSelectClick:) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:selectBtn];
    }
    
    iTop += (imageView.frame.size.height+10);
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, iTop, mScrollView.frame.size.width, 50)];
    imageView.image = [[UIImage imageNamed:@"f_whiteback"] stretchableImageWithLeftCapWidth:50 topCapHeight:30];
    imageView.userInteractionEnabled = YES;
    [mScrollView addSubview:imageView];
    
    lbName = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 150, 30)];
    lbName.backgroundColor = [UIColor clearColor];
    lbName.font = [UIFont systemFontOfSize:16];
    lbName.text = @"数量";
    [imageView addSubview:lbName];
    
    miCount = 1;
    mlbCount = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.size.width-90, 10, 40, 30)];
    mlbCount.backgroundColor = [UIColor clearColor];
    mlbCount.font = [UIFont systemFontOfSize:18];
    mlbCount.textAlignment = UITextAlignmentCenter;
    mlbCount.text = @"1";
    [imageView addSubview:mlbCount];
    
    mDecBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mDecBtn.frame = CGRectMake(imageView.frame.size.width-142, 0, 50, 50);
    [mDecBtn setImage:[UIImage imageNamed:@"65_2"] forState:UIControlStateNormal];
    [mDecBtn addTarget:self action:@selector(OnDecClick) forControlEvents:UIControlEventTouchUpInside];
    mDecBtn.enabled = NO;
    [imageView addSubview:mDecBtn];
    
    mIncBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mIncBtn.frame = CGRectMake(imageView.frame.size.width-52, 0, 50, 50);
    [mIncBtn setImage:[UIImage imageNamed:@"66"] forState:UIControlStateNormal];
    [mIncBtn addTarget:self action:@selector(OnIncClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:mIncBtn];
    
    iTop += (imageView.frame.size.height+35);
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame = CGRectMake((self.view.frame.size.width-252)/2, iTop, 252, 42);
    [commitBtn setImage:[UIImage imageNamed:@"67"] forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(OnCommitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];
}

- (void)OnCommitClick {
    [AutoAlertView ShowAlert:@"提示" message:@"下单成功"];
    [self GoBack];
}

- (void)OnDecClick {
    miCount --;
    if (miCount<1) {
        miCount = 1;
    }
    mlbCount.text = [NSString stringWithFormat:@"%d", miCount];
    mDecBtn.enabled = (miCount > 1);
}

- (void)OnIncClick {
    miCount++;
    mlbCount.text = [NSString stringWithFormat:@"%d", miCount];
    mDecBtn.enabled = (miCount > 1);
}

- (void)OnTopClick {
    
}

- (void)OnSelectClick:(UIButton *)sender {
    [mSelectBtn setSelected:NO];
    [sender setSelected:YES];
    mSelectBtn = sender;
    
    if (sender.tag == 1500) {
        ServiceViewController *ctrl = [[ServiceViewController alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    else if (sender.tag == 1501) {
        HistoryDataViewController *ctrl = [[HistoryDataViewController alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
