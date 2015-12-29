//
//  LikeListViewController.m
//  TestRedCollar
//
//  Created by dreamRen on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "LikeListViewController.h"
#import "LikeSubView.h"
#import "CoolDetailViewController.h"

@interface LikeListViewController (){
    UIScrollView *mScrollView;
    NSMutableArray *_theList;
}

@end

@implementation LikeListViewController

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
    self.title = @"他的街拍";
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
    
    mScrollView=[[UIScrollView alloc] initWithFrame:self.view.bounds];
    mScrollView.backgroundColor=[UIColor clearColor];
    mScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:mScrollView];
    
    _theList=[[NSMutableArray alloc] init];
    [self loadLike];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//喜欢
-(void)loadLike{
    
    for (int m=30005; m<30009; m++) {
        [_theList addObject:[NSString stringWithFormat:@"t%d",m]];
    }
    
    int iHeight1 = 5;
    int iHeight2 = 5;
    for (int i = 0; i < _theList.count; i ++) {
        int iXPos = i%2;
        
        int iHeight = [LikeSubView HeightOfContent:_theList[i]];
        int iTop = 0;
        if (iXPos == 0) {
            iTop = iHeight1;
            iHeight1 += (iHeight+5);
        }
        else {
            iTop = iHeight2;
            iHeight2 += (iHeight+5);
        }
        LikeSubView *subView = [[LikeSubView alloc] initWithFrame:CGRectMake(iXPos*158+5, iTop, 153, iHeight)];
        subView.delegate = self;
        subView.OnViewClick = @selector(OnLikeClick:);
        subView.tag = i+1300;
        [mScrollView addSubview:subView];
        subView.image=[UIImage imageNamed:_theList[i]];
    }
    mScrollView.contentOffset = CGPointMake(0, 0);
    mScrollView.contentSize = CGSizeMake(mScrollView.frame.size.width, MAX(iHeight1, iHeight2));
}

//喜欢click
-(void)OnLikeClick:(LikeSubView*)sender{
    CoolDetailViewController *ctrl = [[CoolDetailViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
}

@end
