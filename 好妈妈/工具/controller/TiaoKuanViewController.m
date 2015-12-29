//
//  TiaoKuanViewController.m
//  好妈妈
//
//  Created by iHope on 14-2-17.
//  Copyright (c) 2014年 iHope. All rights reserved.
//

#import "TiaoKuanViewController.h"
#import "JSON.h"
@interface TiaoKuanViewController ()

@end

@implementation TiaoKuanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hidesTabBar" object:nil];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayTabBar" object:nil];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImageView * backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, KUIOS_7(Screen_Height-20))];
    backImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"底" ofType:@"png"]];
    [self.view addSubview:backImageView];
    [backImageView release];
    UIImageView * navigation=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, KUIOS_7(44))];
    navigation.backgroundColor=[UIColor blackColor];
    navigation.userInteractionEnabled=YES;
    navigation.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nav_background" ofType:@"png"]];
    [self.view addSubview:navigation];
    [navigation release];
    
    UIButton * backBut=[UIButton buttonWithType:UIButtonTypeCustom];
    backBut.frame=CGRectMake(5, KUIOS_7(6), 45, 30.5);
    [backBut addTarget:self action:@selector(clicked_backBut) forControlEvents:UIControlEventTouchUpInside];
    [backBut setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"001_4" ofType:@"png"]] forState:UIControlStateNormal];
    [navigation addSubview:backBut];
    
    UILabel *titLab = [[UILabel alloc]initWithFrame:CGRectMake(80, KUIOS_7(0), navigation.frame.size.width-120, 44)];
    titLab.text = @"好妈妈会员服务条款";
    titLab.textAlignment = 1;
    titLab.backgroundColor = [UIColor clearColor];
    titLab.textColor = [UIColor whiteColor];
    titLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    [navigation addSubview:titLab];
    [titLab release];
    NSString *txtPath = [[NSBundle mainBundle] pathForResource:@"haomamaquanxian" ofType:@"txt"];
    NSString *text = [NSString stringWithContentsOfFile:txtPath encoding:NSUTF8StringEncoding error:nil];
//    self.citeArray=[[[NSMutableArray alloc] initWithArray:[text JSONValue]] autorelease];

    //    将txt到string对象中，编码类型为NSUTF8StringEncoding
//    NSString *string = [[NSString  alloc] initWithContentsOfFile:txtPath encoding:NSUTF8StringEncoding error:nil];
//    (@"%@",[string componentsSeparatedByString:@" "]);
//    (@"%@",[[[NSBundle mainBundle] pathForResource:@"haomamaquanxin" ofType:@"txt"] JSONValue]);
    UITextView * textView=[[UITextView alloc]initWithFrame:CGRectMake(5, 10+(KUIOS_7(44)), Screen_Width-10, Screen_Height-20-44-20)];
    textView.font=[UIFont systemFontOfSize:16];
    textView.text=text;
    textView.editable=NO;
    [self.view addSubview:textView];
    [textView release];
    
    

}
- (void)clicked_backBut{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
