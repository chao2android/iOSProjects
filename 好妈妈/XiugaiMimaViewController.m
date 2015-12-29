//
//  XiugaiMimaViewController.m
//  好妈妈
//
//  Created by iHope on 13-10-17.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "XiugaiMimaViewController.h"
#import "TishiView.h"
#import "AutoAlertView.h"
#import "RootViewController.h"
@interface XiugaiMimaViewController ()

@end

@implementation XiugaiMimaViewController
@synthesize mimaTextField,quedingTextField;
@synthesize tishiView;
@synthesize yuanTextField;
@synthesize biaotiBool;
- (void)dealloc
{
    [yuanTextField release];
    [tishiView release];
    [mimaTextField release];
    [quedingTextField release];
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
    navigationLabel.text=@"修改密码";
    
    [navigation addSubview:navigationLabel];
    [navigationLabel release];
    
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(5, KUIOS_7(7), 51, 33);
    [back setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backup) forControlEvents:UIControlEventTouchUpInside];
    [navigation addSubview:back];
    UILabel * shoujihaoLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, (KUIOS_7(44))+40, 90, 18)];
    shoujihaoLabel.textAlignment=NSTextAlignmentRight;
    shoujihaoLabel.textColor=[UIColor blackColor];
    shoujihaoLabel.backgroundColor=[UIColor clearColor];
    shoujihaoLabel.text=@"原密码:";
    [self.view addSubview:shoujihaoLabel];
    [shoujihaoLabel release];
    
    UILabel * yanzhengmaLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, shoujihaoLabel.frame.size.height+shoujihaoLabel.frame.origin.y+25, 90, 18)];
    yanzhengmaLabel.textAlignment=NSTextAlignmentRight;
    yanzhengmaLabel.textColor=[UIColor blackColor];
    yanzhengmaLabel.backgroundColor=[UIColor clearColor];
    yanzhengmaLabel.text=@"新密码:";
    [self.view addSubview:yanzhengmaLabel];
    [yanzhengmaLabel release];
    UILabel * quedingLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, yanzhengmaLabel.frame.size.height+yanzhengmaLabel.frame.origin.y+25, 90, 18)];
    quedingLabel.textAlignment=NSTextAlignmentRight;
    quedingLabel.textColor=[UIColor blackColor];
    quedingLabel.backgroundColor=[UIColor clearColor];
    quedingLabel.text=@"确定密码:";
    [self.view addSubview:quedingLabel];
    [quedingLabel release];
    if (self.biaotiBool) {
        shoujihaoLabel.text=@"请输入验证码:";
        yanzhengmaLabel.text=@"设置新密码:";
        quedingLabel.text=@"请再输入一次:";
        navigationLabel.text=@"找回密码";
        shoujihaoLabel.font=[UIFont systemFontOfSize:13.5];
        yanzhengmaLabel.font=[UIFont systemFontOfSize:13.5];
        quedingLabel.font=[UIFont systemFontOfSize:13.5];
    }
    self.yuanTextField=[[[UITextField alloc]initWithFrame:CGRectMake(95, (KUIOS_7(44))+30, 214, 37)] autorelease];
    self.yuanTextField.borderStyle=UITextBorderStyleRoundedRect;
    self.yuanTextField.secureTextEntry=YES;
    [self.yuanTextField setBackground:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"006_6" ofType:@"png"]]];
    self.yuanTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:self.yuanTextField];
    
    
    self.mimaTextField=[[[UITextField alloc]initWithFrame:CGRectMake(95, self.yuanTextField.frame.origin.y+self.yuanTextField.frame.size.height+5, 214, 37)] autorelease];
    self.mimaTextField.borderStyle=UITextBorderStyleRoundedRect;
    self.mimaTextField.secureTextEntry=YES;
    [self.mimaTextField setBackground:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"006_6" ofType:@"png"]]];
    self.mimaTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:self.mimaTextField];
    if (ISIPAD) {
        shoujihaoLabel.frame=CGRectMake(0, 84*1.4, 80*1.4, 18*1.4);
        yanzhengmaLabel.frame=CGRectMake(0, shoujihaoLabel.frame.size.height+shoujihaoLabel.frame.origin.y+25*1.4, 80*1.4, 18*1.4);
        quedingLabel.frame=CGRectMake(0, yanzhengmaLabel.frame.size.height+yanzhengmaLabel.frame.origin.y+25*1.4, 80*1.4, 18*1.4);
        shoujihaoLabel.font=[UIFont systemFontOfSize:17*1.4];
        yanzhengmaLabel.font=[UIFont systemFontOfSize:17*1.4];
        quedingLabel.font=[UIFont systemFontOfSize:17*1.4];
        self.yuanTextField.frame=CGRectMake(85*1.4, 74*1.4, 214*1.4, 37*1.4);
        self.yuanTextField.font=[UIFont systemFontOfSize:17*1.4];
        self.mimaTextField.frame=CGRectMake(85*1.4, self.yuanTextField.frame.origin.y+self.yuanTextField.frame.size.height+5*1.4, 214*1.4, 37*1.4);
        self.mimaTextField.font=[UIFont systemFontOfSize:17*1.4];
        
    }
    
    self.quedingTextField=[[[UITextField alloc]initWithFrame:CGRectMake(95, self.mimaTextField.frame.size.height+self.mimaTextField.frame.origin.y+5, 214, 37)] autorelease];
    self.quedingTextField.borderStyle=UITextBorderStyleRoundedRect;
    self.quedingTextField.secureTextEntry=YES;
    self.quedingTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.quedingTextField setBackground:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"006_6" ofType:@"png"]]];
    [self.view addSubview:self.quedingTextField];
    
    UIButton * tuichuBut=[UIButton buttonWithType:UIButtonTypeCustom];
    tuichuBut.frame=CGRectMake((Screen_Width-298.5)/2, self.quedingTextField.frame.origin.y+self.quedingTextField.frame.size.height+25, 298.5, 39);
    [tuichuBut addTarget:self action:@selector(QdMenth) forControlEvents:UIControlEventTouchUpInside];
    [tuichuBut setTitle:@"确 定" forState:UIControlStateNormal];
    [tuichuBut setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"长按钮" ofType:@"png"]] forState:UIControlStateNormal];
    [self.view addSubview:tuichuBut];
    self.tishiView=[TishiView tishiViewMenth];
    [self.view addSubview:self.tishiView];
    if (ISIPAD) {
        shoujihaoLabel.frame=CGRectMake((Screen_Width-298.5*1.4)/2, 84*1.4, 80*1.4, 18*1.4);
        yanzhengmaLabel.frame=CGRectMake((Screen_Width-298.5*1.4)/2, shoujihaoLabel.frame.size.height+shoujihaoLabel.frame.origin.y+25*1.4, 80*1.4, 18*1.4);
        quedingLabel.frame=CGRectMake((Screen_Width-298.5*1.4)/2, yanzhengmaLabel.frame.size.height+yanzhengmaLabel.frame.origin.y+25*1.4, 80*1.4, 18*1.4);
        shoujihaoLabel.font=[UIFont systemFontOfSize:17*1.4];
        yanzhengmaLabel.font=[UIFont systemFontOfSize:17*1.4];
        quedingLabel.font=[UIFont systemFontOfSize:17*1.4];
        self.yuanTextField.frame=CGRectMake((Screen_Width-298.5*1.4)/2+85*1.4, 74*1.4, 214*1.4, 37*1.4);
        self.yuanTextField.font=[UIFont systemFontOfSize:17*1.4];
        self.mimaTextField.frame=CGRectMake((Screen_Width-298.5*1.4)/2+85*1.4, self.yuanTextField.frame.origin.y+self.yuanTextField.frame.size.height+5*1.4, 214*1.4, 37*1.4);
        self.mimaTextField.font=[UIFont systemFontOfSize:17*1.4];
        self.quedingTextField.frame=CGRectMake((Screen_Width-298.5*1.4)/2+85*1.4, self.mimaTextField.frame.size.height+self.mimaTextField.frame.origin.y+5*1.4, 214*1.4, 37*1.4);
        self.quedingTextField.font=[UIFont systemFontOfSize:17*1.4];
        tuichuBut.frame=CGRectMake((Screen_Width-298.5*1.4)/2, self.quedingTextField.frame.origin.y+self.quedingTextField.frame.size.height+25*1.4, 298.5*1.4, 39*1.4);
        tuichuBut.titleLabel.font=[UIFont systemFontOfSize:17*1.4];
    }
    
    
}
- (void)QdMenth
{
    [self.mimaTextField resignFirstResponder];
    [self.quedingTextField resignFirstResponder];
    if (!self.yuanTextField.text.length||!self.mimaTextField.text.length||!self.quedingTextField.text.length)
    {
        [AutoAlertView ShowAlert:@"温馨提示" message:@"请输入完整"];
        return;
    }
    if (self.mimaTextField.text.length&&self.quedingTextField.text.length&&[self.mimaTextField.text isEqualToString:self.quedingTextField.text]) {
        NSMutableDictionary * aDictionary=[[NSMutableDictionary alloc]initWithCapacity:1];
        NSString * urlString=nil;
        NSString * controllerName=nil;
        if (self.biaotiBool) {
            [aDictionary removeAllObjects];
            [aDictionary setValue:self.mimaTextField.text forKey:@"pwd"];
            [aDictionary setValue:self.yuanTextField.text forKey:@"code"];
            urlString=[[NSString alloc]initWithString:@"http://apptest.mum360.com/web/home/index/usecodesetpwd"];
            controllerName=@"wangjimima";
            
        }
        else
        {
            NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
            [aDictionary removeAllObjects];
            [aDictionary setValue:[userDic valueForKey:@"uid"] forKey:@"uid"];
            [aDictionary setValue:[userDic valueForKey:@"token"] forKey:@"token"];
            [aDictionary setValue:self.mimaTextField.text forKey:@"password"];
            [aDictionary setValue:self.yuanTextField.text forKey:@"oldpwd"];
            urlString=[[NSString alloc]initWithString:@"http://apptest.mum360.com/web/home/index/updatepassword"];
            controllerName=@"xiugaimima";
        }
        self.mPassword = self.mimaTextField.text;
        NSURL * aUrl=[[NSURL alloc]initWithString:urlString];
        [urlString release];
        [self.tishiView StartMenth];
        analysis=[[AnalysisClass alloc]initWithIdentifier:aUrl DataName:nil ControllerName:controllerName delegate:self];
        [aUrl release];
        [analysis PostMenth:aDictionary];
        [aDictionary release];
    }
    else
    {
        UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"两次密码不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        
    }
}
- (void)Asihttp:(AnalysisClass *)asi DataArray:(NSMutableDictionary *)array
{
    NSLog(@"%@",[array valueForKey:asi.ControllerName]);
    
    NSString * tishiString=nil;
    if ([[[array valueForKey:asi.ControllerName] valueForKey:@"code"] intValue]==1) {
        tishiString=@"修改成功";
        if ([asi.ControllerName isEqualToString:@"xiugaimima"]) {
            
            [[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"] setValue:self.mimaTextField.text forKey:@"password"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            if (self.mPassword && self.mMobile) {
                NSDictionary *newdict = [NSDictionary dictionaryWithObjectsAndKeys:self.mMobile, @"username",self.mPassword,@"password", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kMsgLogin" object:nil userInfo:newdict];
            }
            //            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"shifoulogin"];
            //            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"logindata"];
            //            [[array valueForKey:asi.ControllerName] setValue:self.mimaTextField.text forKey:@"password"];
            //            [[NSUserDefaults standardUserDefaults] setObject:[array valueForKey:asi.ControllerName] forKey:@"logindata"];
            //            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        [self performSelector:@selector(backup1) withObject:self afterDelay:0.5];
    }
    else
    {
        tishiString=@"修改失败";
        [self performSelector:@selector(ShibaiMenth) withObject:self afterDelay:0.5];
        
    }
    self.tishiView.titlelabel.text=tishiString;
    
    [asi release];
    analysis=nil;
}
- (void)viewWillDisappear:(BOOL)animated
{
    if (analysis) {
        [analysis CancelMenthrequst];
    }
}
- (void)ShibaiMenth
{
    [self.tishiView StopMenth];
}
- (void)backup1
{
    [self.tishiView StopMenth];
    if (self.biaotiBool) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        //        RootViewController * root=[[RootViewController alloc]init];
        //        [self.navigationController pushViewController:root animated:YES];
        //        [root release];
        return;
    }
    [self backup];
}
- (void)backup
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.mimaTextField resignFirstResponder];
    [self.quedingTextField resignFirstResponder];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
