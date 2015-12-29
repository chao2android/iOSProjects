//
//  YijianfankuiViewController.m
//  好妈妈
//
//  Created by iHope on 13-10-17.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "YijianfankuiViewController.h"
#import "TishiView.h"
@interface YijianfankuiViewController ()

@end

@implementation YijianfankuiViewController
@synthesize contentTextView;
@synthesize tishiView;
- (void)dealloc
{
    [tishiView release];
    [contentTextView release];
    [super dealloc];
}
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
    [self.contentTextView becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hidesTabBar" object:nil];
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
    navigation.userInteractionEnabled=YES;
    navigation.backgroundColor=[UIColor blackColor];
    navigation.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nav_background" ofType:@"png"]];
    [self.view addSubview:navigation];
    [navigation release];
    UILabel * navigationLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, KUIOS_7(11), (Screen_Width-160), 22)];
    navigationLabel.backgroundColor=[UIColor clearColor];
    //    navigationLabel.font=[UIFont systemFontOfSize:22];
    navigationLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:22];
    navigationLabel.textAlignment=NSTextAlignmentCenter;
    navigationLabel.textColor=[UIColor whiteColor];
    navigationLabel.text=@"意见反馈";
    [navigation addSubview:navigationLabel];
    [navigationLabel release];
    
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(5, KUIOS_7(7), 51, 33);
    [back setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fanhui" ofType:@"png"]] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backup) forControlEvents:UIControlEventTouchUpInside];
    [navigation addSubview:back];
    
    UIButton* rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBut.frame = CGRectMake(Screen_Width-52, KUIOS_7(7), 47, 30);
    [rightBut setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"002_39" ofType:@"png"]] forState:UIControlStateNormal];
    [rightBut addTarget:self action:@selector(RightMenth) forControlEvents:UIControlEventTouchUpInside];
    [navigation addSubview:rightBut];
    UIImageView * textViewBackImageview=[[UIImageView alloc]initWithFrame:CGRectMake((Screen_Width-295)/2, (KUIOS_7(44))+30, 295, 150)];
    textViewBackImageview.userInteractionEnabled=YES;
    textViewBackImageview.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"002_42" ofType:@"png"]];
    [self.view addSubview:textViewBackImageview];
    [textViewBackImageview release];
    self.contentTextView=[[[UITextView alloc]initWithFrame:CGRectMake(5,  5, textViewBackImageview.frame.size.width-10, textViewBackImageview.frame.size.height-10)] autorelease];
    self.contentTextView.backgroundColor=[UIColor clearColor];
    [textViewBackImageview addSubview:self.contentTextView];
    self.tishiView=[TishiView tishiViewMenth];
    [self.view addSubview:self.tishiView];
    if (ISIPAD) {
        textViewBackImageview.frame=CGRectMake((Screen_Width-295*1.4)/2, 74*1.4, 295*1.4, 150*1.4);
        self.contentTextView.frame=CGRectMake(5, 5, textViewBackImageview.frame.size.width-10, textViewBackImageview.frame.size.height-10);
        self.contentTextView.font=[UIFont systemFontOfSize:17*1.4];
    }
}
- (void)backup
{
    [self.tishiView StopMenth];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)RightMenth
{
    [self.contentTextView resignFirstResponder];
    if (self.contentTextView.text.length) {
        NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
        NSMutableDictionary * aDictionary=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[userDic valueForKey:@"uid"],@"uid",[userDic valueForKey:@"token"],@"token",self.contentTextView.text,@"content",@"1",@"type", nil];
        NSURL * aUrl=[[NSURL alloc]initWithString:@"http://apptest.mum360.com/web/home/index/createreport"];
        [self.tishiView StartMenth];
        analysis=[[AnalysisClass alloc]initWithIdentifier:aUrl DataName:nil ControllerName:@"yijianfankui" delegate:self];
        [aUrl release];
        [analysis PostMenth:aDictionary];
        [aDictionary release];
    }
    else
    {
        UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入反馈内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        
    }
}
- (void)Asihttp:(AnalysisClass *)asi DataArray:(NSMutableDictionary *)array
{
    NSString * tishiString=nil;
    if ([[[array valueForKey:asi.ControllerName] valueForKey:@"code"] intValue]==1) {
        tishiString=@"反馈成功";
        [self performSelector:@selector(backup) withObject:self afterDelay:0.5];
    }
    else
    {
        tishiString=@"反馈失败";
        [self performSelector:@selector(ShibaiMenth) withObject:self afterDelay:0.5];
        
    }
    self.tishiView.titlelabel.text=tishiString;
    [asi release];
    analysis=nil;
}
- (void)ShibaiMenth
{
    [self.tishiView StopMenth];
}
- (void)viewWillDisappear:(BOOL)animated
{
    if (analysis) {
        [analysis CancelMenthrequst];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
