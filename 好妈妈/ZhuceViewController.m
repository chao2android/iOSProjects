//
//  ZhuceViewController.m
//  好妈妈
//
//  Created by iHope on 13-9-24.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "ZhuceViewController.h"
#import "ZhucexbViewController.h"
#import "FenxiangView.h"
#import "TishiView.h"
#import "AutoAlertView.h"
@interface ZhuceViewController ()

@end

@implementation ZhuceViewController
@synthesize shoujihaoTextfield,yanzhengmaTextfield;
@synthesize oldDictionary;
@synthesize tishiView;
- (void)dealloc
{
    [tishiView release];
    [oldDictionary release];
    [shoujihaoTextfield release];
    [yanzhengmaTextfield release];
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
    navigationLabel.text=@"注册";
    [navigation addSubview:navigationLabel];
    [navigationLabel release];
    
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(5, KUIOS_7(7), 51, 33);
    [back setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backup) forControlEvents:UIControlEventTouchUpInside];
    [navigation addSubview:back];
    UIButton* rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBut.frame = CGRectMake(Screen_Width-52, KUIOS_7(7), 47, 30);
    [rightBut setImage:[UIImage imageNamed:@"006_4.png"] forState:UIControlStateNormal];
    [rightBut addTarget:self action:@selector(RightMenth) forControlEvents:UIControlEventTouchUpInside];
    [navigation addSubview:rightBut];
    
    UILabel * shoujihaoLabel=[[UILabel alloc]initWithFrame:CGRectMake((Screen_Width-310)/2, (KUIOS_7(44))+40, 75, 18)];
    shoujihaoLabel.textAlignment=NSTextAlignmentRight;
    shoujihaoLabel.textColor=[UIColor blackColor];
    shoujihaoLabel.backgroundColor=[UIColor clearColor];
    shoujihaoLabel.text=@"手机号:";
    [self.view addSubview:shoujihaoLabel];
    [shoujihaoLabel release];
    
    UILabel * yanzhengmaLabel=[[UILabel alloc]initWithFrame:CGRectMake((Screen_Width-310)/2, shoujihaoLabel.frame.size.height+shoujihaoLabel.frame.origin.y+25, 75, 18)];
    yanzhengmaLabel.textAlignment=NSTextAlignmentRight;
    yanzhengmaLabel.textColor=[UIColor blackColor];
    yanzhengmaLabel.backgroundColor=[UIColor clearColor];
    yanzhengmaLabel.text=@"验证码:";
    [self.view addSubview:yanzhengmaLabel];
    [yanzhengmaLabel release];
    
    UIImageView * textImageView=[[UIImageView alloc]initWithFrame:CGRectMake(shoujihaoLabel.frame.size.width+shoujihaoLabel.frame.origin.x+5, (KUIOS_7(44))+30, 214, 37)];
    textImageView.userInteractionEnabled=YES;
    textImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"006_6" ofType:@"png"]];
    [self.view addSubview:textImageView];
    [textImageView release];
    
    self.shoujihaoTextfield=[[[UITextField alloc]initWithFrame:CGRectMake(shoujihaoLabel.frame.origin.x+shoujihaoLabel.frame.size.width+8, (KUIOS_7(44))+30, 208, 37)] autorelease];
    self.shoujihaoTextfield.keyboardType=UIKeyboardTypePhonePad;
    self.shoujihaoTextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:self.shoujihaoTextfield];
    UIImageView * textImageView1=[[UIImageView alloc]initWithFrame:CGRectMake(yanzhengmaLabel.frame.size.width+yanzhengmaLabel.frame.origin.x+5, self.shoujihaoTextfield.frame.size.height+self.shoujihaoTextfield.frame.origin.y+5, 214, 37)];
    textImageView1.userInteractionEnabled=YES;
    textImageView1.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"006_6" ofType:@"png"]];
    [self.view addSubview:textImageView1];
    [textImageView1 release];
    self.yanzhengmaTextfield=[[[UITextField alloc]initWithFrame:CGRectMake(yanzhengmaLabel.frame.size.width+yanzhengmaLabel.frame.origin.x+8, self.shoujihaoTextfield.frame.size.height+self.shoujihaoTextfield.frame.origin.y+5, 208, 37)] autorelease];
    self.yanzhengmaTextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:self.yanzhengmaTextfield];
    
    
    huoquButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [huoquButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"006_8" ofType:@"png"]] forState:UIControlStateNormal];
    [huoquButton addTarget:self action:@selector(HuoQuyzMenth) forControlEvents:UIControlEventTouchUpInside];
    huoquButton.frame=CGRectMake((Screen_Width-278.5)/2, KUIOS_7(180), 278.5, 36);
    [self.view addSubview:huoquButton];
    
//    
//    FenxiangView * fenxiang=[[FenxiangView alloc]initWithFrame:CGRectMake(0, Screen_Height-100-20, Screen_Width, 100)cont:self];
//    [self.view addSubview:fenxiang];
//    [fenxiang release];
    
    
    self.tishiView=[TishiView tishiViewMenth];
    [self.view addSubview:self.tishiView];
    if (ISIPAD) {
        shoujihaoLabel.frame=CGRectMake((Screen_Width-310*1.4)/2, shoujihaoLabel.frame.origin.y*1.4, shoujihaoLabel.frame.size.width*1.4, shoujihaoLabel.frame.size.height*1.4);
        shoujihaoLabel.font=[UIFont systemFontOfSize:17*1.4];

        yanzhengmaLabel.frame=CGRectMake((Screen_Width-310*1.4)/2, yanzhengmaLabel.frame.origin.y*1.4, yanzhengmaLabel.frame.size.width*1.4, yanzhengmaLabel.frame.size.height*1.4);
        yanzhengmaLabel.font=[UIFont systemFontOfSize:17*1.4];


        textImageView.frame=CGRectMake(shoujihaoLabel.frame.size.width+shoujihaoLabel.frame.origin.x+5, textImageView.frame.origin.y*1.4, textImageView.frame.size.width*1.4, textImageView.frame.size.height*1.4);
        textImageView1.frame=CGRectMake(textImageView.frame.origin.x, textImageView1.frame.origin.y*1.4, textImageView1.frame.size.width*1.4, textImageView1.frame.size.height*1.4);

        self.shoujihaoTextfield.frame=CGRectMake(shoujihaoLabel.frame.size.width+shoujihaoLabel.frame.origin.x+10, self.shoujihaoTextfield.frame.origin.y*1.4, self.shoujihaoTextfield.frame.size.width*1.4, self.shoujihaoTextfield.frame.size.height*1.4);
        self.shoujihaoTextfield.font=[UIFont systemFontOfSize:17*1.4];
        self.yanzhengmaTextfield.frame=CGRectMake(yanzhengmaLabel.frame.size.width+yanzhengmaLabel.frame.origin.x+10, self.yanzhengmaTextfield.frame.origin.y*1.4, self.yanzhengmaTextfield.frame.size.width*1.4, self.yanzhengmaTextfield.frame.size.height*1.4);
        self.yanzhengmaTextfield.font=[UIFont systemFontOfSize:17*1.4];
        huoquButton.frame=CGRectMake((Screen_Width-278.5*1.4)/2, huoquButton.frame.origin.y*1.4, huoquButton.frame.size.width*1.4, huoquButton.frame.size.height*1.4);
//        fenxiang.frame=CGRectMake(0, Screen_Height-100*1.4-20*1.4, Screen_Width, 100*1.4);

    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    if (huoquTimer) {
        [huoquTimer invalidate];
        huoquTimer=nil;
    }
    if (analysis) {
        [analysis CancelMenthrequst];
        analysis=nil;
    }
}
- (void)HuoQuJiHuoMenth
{
    if (huoquTimer) {
        [huoquTimer invalidate];
        huoquTimer=nil;
    }
    huoquButton.userInteractionEnabled=YES;
    [huoquButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"006_8" ofType:@"png"]] forState:UIControlStateNormal];
}
- (void)HuoQuyzMenth
{
    if (!self.shoujihaoTextfield.text.length) {
        [AutoAlertView ShowAlert:@"温馨提示" message:@"请输入手机号"];
        return;
    }
    
    [self.shoujihaoTextfield resignFirstResponder];
    [self.yanzhengmaTextfield resignFirstResponder];
    NSMutableDictionary * dictionary=[[NSMutableDictionary alloc]initWithObjectsAndKeys:self.shoujihaoTextfield.text,@"mobile", nil];
    [self AnalysisMenth:@"huoquyanzhengma" analyUrl:@"http://apptest.mum360.com/web/home/index/mobileregist" analyDic:dictionary];
    [dictionary release];
}
- (void)AnalysisMenth:(NSString *)controllername analyUrl:(NSString *)urlString analyDic:(NSMutableDictionary *)aDictionary
{
    [self.tishiView StartMenth];
    NSURL * aUrl=[[NSURL alloc]initWithString:urlString];
    analysis=[[AnalysisClass alloc]initWithIdentifier:aUrl DataName:nil ControllerName:controllername delegate:self];
    [aUrl release];
    [analysis PostMenth:aDictionary];
}
- (void)alertViewMenth:(NSString *)sender
{
    
    [AutoAlertView ShowAlert:@"温馨提示" message:sender];


}
- (void)Asihttp:(AnalysisClass *)asi DataArray:(NSMutableDictionary *)array
{
    [self.tishiView StopMenth];

    NSMutableDictionary * hqDic=[array valueForKey:asi.ControllerName];
    NSLog(@"hqDic  %@",hqDic);
    if ([asi.ControllerName isEqualToString:@"huoquyanzhengma"]) {

        [self alertViewMenth:[hqDic valueForKey:@"msg"]];
        if ([[hqDic valueForKey:@"code"] intValue]) {
            
        
        huoquButton.userInteractionEnabled=NO;
        [huoquButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"006_8_" ofType:@"png"]] forState:UIControlStateNormal];
        if (huoquTimer) {
            [huoquTimer invalidate];
            huoquTimer=nil;
        }
        if (huoquTimer==nil) {
            huoquTimer=[NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(HuoQuJiHuoMenth) userInfo:nil repeats:NO];
        }
        }
    }
    else if ([asi.ControllerName isEqualToString:@"yanzhengyanzhengma"])
    {
         if ([[hqDic valueForKey:@"code"] intValue]) {
            NSMutableDictionary * zheceDic=[[NSMutableDictionary alloc]initWithCapacity:1];
            [zheceDic addEntriesFromDictionary:self.oldDictionary];
            [zheceDic setValue:self.shoujihaoTextfield.text forKey:@"shoujihao"];
            ZhucexbViewController * zhucexbController=[[ZhucexbViewController alloc] init];
            zhucexbController.oldDictionary=zheceDic;
            [zheceDic release];
            [self.navigationController pushViewController:zhucexbController animated:YES];
            [zhucexbController release];
        }
        else
        {
            [self alertViewMenth:[hqDic valueForKey:@"msg"]];
        }
    }
    analysis=nil;
    [asi release];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.shoujihaoTextfield resignFirstResponder];
    [self.yanzhengmaTextfield resignFirstResponder];
}
- (void)backup
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)RightMenth
{
    if (!self.yanzhengmaTextfield.text.length) {
        [AutoAlertView ShowAlert:@"温馨提示" message:@"请输入验证码，谢谢!!!"];
        return;
    }
    NSMutableDictionary * dictionary=[[NSMutableDictionary alloc]initWithObjectsAndKeys:self.shoujihaoTextfield.text,@"mobile",self.yanzhengmaTextfield.text,@"code", nil];
    [self AnalysisMenth:@"yanzhengyanzhengma" analyUrl:@"http://apptest.mum360.com/web/home/index/iscode" analyDic:dictionary];
    [dictionary release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
