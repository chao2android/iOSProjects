//
//  BangzhuViewController.m
//  好妈妈
//
//  Created by iHope on 13-11-4.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "BangzhuViewController.h"

@interface BangzhuViewController ()

@end

@implementation BangzhuViewController
@synthesize shouming;
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
    UIScrollView *  mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, IOS_7?0:20, Screen_Width, Screen_Height-(IOS_7?0:20))];
    mainScrollView.backgroundColor=[UIColor whiteColor];
    mainScrollView.showsHorizontalScrollIndicator=NO;
//    if (shouming) {
//        
//        mainScrollView.frame=CGRectMake(0, 44, Screen_Width, Screen_Height-20-44);
//    UIImageView * backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, KUIOS_7(Screen_Height-20))];
//    backImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"底" ofType:@"png"]];
//    [self.view addSubview:backImageView];
//    [backImageView release];
//    UIImageView * navigation=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 44)];
//    navigation.userInteractionEnabled=YES;
//    navigation.backgroundColor=[UIColor blackColor];
//    navigation.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nav_background" ofType:@"png"]];
//    [self.view addSubview:navigation];
//    [navigation release];
//    UILabel * navigationLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 11, (Screen_Width-160), 22)];
//    navigationLabel.backgroundColor=[UIColor clearColor];
//    //    navigationLabel.font=[UIFont systemFontOfSize:22];
//    navigationLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:22];
//    navigationLabel.textAlignment=NSTextAlignmentCenter;
//    navigationLabel.textColor=[UIColor whiteColor];
//    navigationLabel.text=@"使用帮助";
//    [navigation addSubview:navigationLabel];
//    [navigationLabel release];
//    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
//    back.frame = CGRectMake(5, 7, 51, 33);
//    [back setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
//    [back addTarget:self action:@selector(backup) forControlEvents:UIControlEventTouchUpInside];
//    [navigation addSubview:back];
//    }
    mainScrollView.pagingEnabled=YES;
    mainScrollView.userInteractionEnabled=YES;
    [self.view addSubview:mainScrollView];
    [mainScrollView release];
    for (int i=0; i<4; i++) {
        UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake(i*mainScrollView.frame.size.width, -20, mainScrollView.frame.size.width, mainScrollView.frame.size.height)];
        imageView.userInteractionEnabled=YES;
        imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"欢迎%d",i+1]];
        [mainScrollView addSubview:imageView];
        [imageView release];
        if (i==3) {
            if (shouming) {
                //        UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
                //        [button addTarget:self action:@selector(RemoveView) forControlEvents:UIControlEventTouchUpInside];
                //        button.frame=mainScrollView.frame;
                //        [mainScrollView addSubview:button];
                UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(RemoveView)];
                [imageView addGestureRecognizer:tap];
                [tap release];
            }
            else{
            
            
//            imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"注释%d1",i+1]];
            
            UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backup)];
            [imageView addGestureRecognizer:tap];
            [tap release];
            }
        }
    }
    [mainScrollView setContentSize:CGSizeMake(4*mainScrollView.frame.size.width, 0)];
   
}
- (void)RemoveView
{
    [self.view removeFromSuperview];
    [self release];
//    [self dismissModalViewControllerAnimated:NO];
}
- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hidesTabBar" object:nil];
}

- (void)backup
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
