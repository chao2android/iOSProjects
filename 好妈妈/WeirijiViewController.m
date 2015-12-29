//
//  WeirijiViewController.m
//  好妈妈
//
//  Created by iHope on 13-9-25.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "WeirijiViewController.h"
#import "ShangChuanViewController.h"
#import "RiliMoshiView.h"
@interface WeirijiViewController ()
{
    RiliMoshiView *riliMoshiView;
}
@end

@implementation WeirijiViewController
@synthesize navigationButton;
@synthesize tiaojianImageView;
//@synthesize riliMoshiView;
@synthesize typeString;
@synthesize targetidString;
- (void)dealloc
{
    [typeString release];
    if (riliMoshiView) {
        riliMoshiView=nil;
    }
    [targetidString release];
//    [riliMoshiView release];
        [tiaojianImageView release];
    [navigationButton release];
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
- (void)LongPressGestureMenth:(NSNotification *)sender
{
    NSLog(@"%@",sender.object);
    [self ShangChuanMenth:sender.object];
}
- (void)ShangChuanMenth:(NSMutableDictionary *)sender
{
    [sender setValue:@"http://apptest.mum360.com/web/home/index/createtopic" forKey:@"aUrl"];
    ShangChuanViewController * shangchuan=[[ShangChuanViewController alloc]init];
    shangchuan.oldDictionary=sender;
    [self presentModalViewController:shangchuan animated:NO];
    [shangchuan release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(analyUrl) name:@"analyUrl" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LongPressGestureMenth:) name:@"LongPressGesture" object:nil];

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
    
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(5, KUIOS_7(7), 51, 33);
    [back setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backup) forControlEvents:UIControlEventTouchUpInside];
    [navigation addSubview:back];

    self.navigationButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.navigationButton.frame=CGRectMake((Screen_Width-100)/2, KUIOS_7(2), 100, 40);
    self.navigationButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:22];
    self.navigationButton.titleLabel.textColor=[UIColor whiteColor];
    //    [navigationButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"haoyou" ofType:@"png"]] forState:UIControlStateNormal];
    [ self.navigationButton addTarget:self action:@selector(NavigationbuttonMenth) forControlEvents:UIControlEventTouchUpInside];
    backView=[[UIView alloc]initWithFrame:CGRectMake(0, KUIOS_7(44), Screen_Width, 415)];
    if (ISIPAD) {
        backView.frame=CGRectMake(0, KUIOS_7(44), Screen_Width, Screen_Height-100);
    }
    [self.view addSubview:backView];
    [backView release];
    NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];

    if ([self.targetidString intValue]==[[userDic valueForKey:@"uid"] intValue]) {
        UIButton* rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBut.frame = CGRectMake(Screen_Width-52, KUIOS_7(7), 45, 30.5);
        [rightBut setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"003_1" ofType:@"png"]] forState:UIControlStateNormal];
        [navigation addSubview:rightBut];
        
        UILongPressGestureRecognizer * longpress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(TapGestureMenth)];
        [rightBut addGestureRecognizer:longpress];
        [longpress release];
        
        UITapGestureRecognizer * tapges=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(LongPressGestureMenth)];
        [rightBut addGestureRecognizer:tapges];
        [tapges release];

    }
    if ([self.typeString intValue]) {
        [ self.navigationButton setTitle:@"照片模式" forState:UIControlStateNormal];
        zhaopianView=[[ZhaopianView alloc]initWithFrame:CGRectMake(0, 0, backView.frame.size.width, backView.frame.size.height)];
        zhaopianView.targetid =self.targetidString;
        [zhaopianView loadData];
        [backView addSubview:zhaopianView];
        [zhaopianView release];

    }
    else
    {
    [ self.navigationButton setTitle:@"日历模式" forState:UIControlStateNormal];
        riliMoshiView=[[RiliMoshiView alloc]initWithFrame:CGRectMake(0, 0, backView.frame.size.width, backView.frame.size.height)ID:self.targetidString];
        riliMoshiView.temp=self;
        [backView addSubview:riliMoshiView];
        [riliMoshiView release];
    }
    [navigation addSubview: self.navigationButton];
    
   
    NSLog(@"%@",self.targetidString);
    
  
    self.tiaojianImageView=[[[UIImageView alloc]initWithFrame:CGRectMake((Screen_Width-90)/2, KUIOS_7(38), 90, 70)] autorelease];
    self.tiaojianImageView.userInteractionEnabled=YES;
    self.tiaojianImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"003_17" ofType:@"png"]];
    self.tiaojianImageView.hidden=YES;
    [self.view addSubview:self.tiaojianImageView];
    for (int i=0; i<2; i++) {
        UIButton * tiaojianButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [tiaojianButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        tiaojianButton.titleLabel.font=[UIFont systemFontOfSize:12];
        tiaojianButton.tag=i+1;
        [tiaojianButton addTarget:self action:@selector(TiaojianButtonMenth:) forControlEvents:UIControlEventTouchUpInside];
        tiaojianButton.frame=CGRectMake(7.5, 15+28*i, 75, 20);
        if (i==0) {
            [tiaojianButton setTitle:@"照片模式" forState:UIControlStateNormal];
        }
        else
        {
            [tiaojianButton setTitle:@"日历模式" forState:UIControlStateNormal];
        }
        if ([self.typeString intValue]&&i==0) {
            [tiaojianButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"003_18" ofType:@"png"]] forState:UIControlStateNormal];
            
            [ self.navigationButton setTitle:@"照片模式" forState:UIControlStateNormal];
        }
        else if(![self.typeString intValue]&&i==1)
        {
            [tiaojianButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"003_18" ofType:@"png"]] forState:UIControlStateNormal];
            [ self.navigationButton setTitle:@"日历模式" forState:UIControlStateNormal];
        }
        
        [self.tiaojianImageView addSubview:tiaojianButton];
    }
    
    
//    self.riliImageView=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 44, Screen_Width, 371.5)] autorelease];
//    self.riliImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"003_6" ofType:@"png"]];
//    [self.view addSubview:self.riliImageView];
    
}
- (void)NavigationbuttonMenth
{
    self.tiaojianImageView.hidden=!self.tiaojianImageView.hidden;
}
- (void)TiaojianButtonMenth:(UIButton *)sender
{ if (riliMoshiView) {
//    [riliMoshiView release];
    riliMoshiView=nil;
    
}
    if (zhaopianView) {
//        [zhaopianView release];
        zhaopianView=nil;
        
    }
    NSLog(@"%@",backView.subviews);
    for (int i=0; i<backView.subviews.count; i++) {
       
        [[backView.subviews objectAtIndex:i] removeFromSuperview];
    }
    if (sender.tag==2) {
        riliMoshiView=[[RiliMoshiView alloc]initWithFrame:CGRectMake(0, 0, backView.frame.size.width, backView.frame.size.height)ID:self.targetidString];
        riliMoshiView.temp=self;
        [backView addSubview:riliMoshiView];
        [riliMoshiView release];
    }
    else
    {
        zhaopianView=[[ZhaopianView alloc]initWithFrame:CGRectMake(0, 0, backView.frame.size.width, backView.frame.size.height)];
        zhaopianView.targetid =self.targetidString;
        [zhaopianView loadData];
        [backView addSubview:zhaopianView];
        [zhaopianView release];

        
    }
    
    for (int i=0; i<[[self.tiaojianImageView subviews] count]; i++) {
        if (i==sender.tag-1) {
          
            [ self.navigationButton setTitle:@"日历模式" forState:UIControlStateNormal];
            [[[self.tiaojianImageView subviews] objectAtIndex:i] setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"003_18" ofType:@"png"]] forState:UIControlStateNormal];
        }
        else
        {
           
            
            [ self.navigationButton setTitle:@"照片模式" forState:UIControlStateNormal];
            [[[self.tiaojianImageView subviews] objectAtIndex:i] setBackgroundImage:nil forState:UIControlStateNormal];
        }
    }

    self.tiaojianImageView.hidden=YES;
}
- (void)analyUrl
{
    NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
    NSMutableDictionary * Dictionary=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[userDic valueForKey:@"uid"],@"uid",[userDic valueForKey:@"token"],@"token",self.targetidString,@"targetid",@"15",@"limit",@"1",@"page", nil];
    
    NSURL * aUrl=[[NSURL alloc]initWithString:@"http://apptest.mum360.com/web/home/index/topiclist"];
    analysis=[[AnalysisClass alloc]initWithIdentifier:aUrl DataName:Nil ControllerName:@"weiriji" delegate:self];
    [aUrl release];
    [analysis PostMenth:Dictionary];
    [Dictionary release];
    
}
- (void)Asihttp:(AnalysisClass *)asi DataArray:(NSMutableDictionary *)array
{
    NSLog(@"ControllerName  %@",[array valueForKey:asi.ControllerName]);
    [asi release];
    analysis=nil;
}
- (void)LongPressGestureMenth
{
    NSMutableDictionary * asiDiction=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"发表图片",@"title", nil];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString* date = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    [asiDiction setValue:date forKey:@"date"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LongPressGesture" object:asiDiction];
    [asiDiction release];
}
- (void)TapGestureMenth
{
    NSMutableDictionary * asiDiction=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"发表文字",@"title", nil];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString* date = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    [asiDiction setValue:date forKey:@"date"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LongPressGesture" object:asiDiction];
    [asiDiction release];
}

- (void)backup
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%@",riliMoshiView);
    if (riliMoshiView) {
    [riliMoshiView analyUrl];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:@"hidesTabBar" object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayTabBar" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
