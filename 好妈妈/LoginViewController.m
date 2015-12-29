//
//  LoginViewController.m
//  好妈妈
//
//  Created by iHope on 13-9-23.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "LoginViewController.h"
#import "JSON.h"
#import "ZhuceViewController.h"
#import "FenxiangView.h"
#import "WangjmmViewController.h"
#import "RootViewController.h"
#import "CSDataHandle.h"
#import "TishiView.h"
#import "WanshanViewController.h"
#import "UserLocationManager.h"

//#import "HQjwd.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize zhanghaoTextField,mimaTextField;
@synthesize oldDictionary;
@synthesize tishiView;
@synthesize postDictionary;
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [postDictionary release];
    [tishiView release];
    [oldDictionary release];
    [zhanghaoTextField release];
    [mimaTextField release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.oldDictionary=[[[NSMutableDictionary alloc]initWithCapacity:1] autorelease];
        self.postDictionary=[[[NSMutableDictionary alloc]initWithCapacity:1] autorelease];
        
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    //    self.navigationController.navigationBar.translucent = NO;

    [[NSNotificationCenter defaultCenter] postNotificationName:@"hidesTabBar" object:nil];
    
    [[UserLocationManager Share] StartLocation];
}

- (void)OnLocationFinish {
    [self.oldDictionary setValue:[NSString stringWithFormat:@"%lf",kLat] forKey:@"lat"];
    [self.oldDictionary setValue:[NSString stringWithFormat:@"%lf",kLng] forKey:@"lng"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnLoginClick:) name:@"kMsgLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnLocationFinish) name:kMsg_Location object:nil];
    self.navigationController.navigationBar.hidden=YES;
    
    //    [Handle abcd:self];
	// Do any additional setup after loading the view.
    //    NSLog(@"%@ %d",[[NSUserDefaults standardUserDefaults] objectForKey:@"logindata"],[[NSUserDefaults standardUserDefaults] boolForKey:@"shifoulogin"]);
    //    self.view.frame=CGRectMake(0, 20, Screen_Width, KUIOS_7(Screen_Height-20));
    UIImageView * backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, KUIOS_7(Screen_Height-20))];
    backImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"底" ofType:@"png"]];
    [self.view addSubview:backImageView];
    [backImageView release];
    
    UIImageView * titleImageView=[[UIImageView alloc]initWithFrame:CGRectMake((Screen_Width-174.5)/2, KUIOS_7(30), 174.5, 45.5)];
    titleImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"12(2)" ofType:@"png"]];
    [self.view addSubview:titleImageView];
    [titleImageView release];
    
    UIImageView * loginImageView=[[UIImageView alloc]initWithFrame:CGRectMake((Screen_Width-301.5)/2, titleImageView.frame.size.height+titleImageView.frame.origin.y+20, 301.5, 94)];
    loginImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"006_11" ofType:@"png"]];
    loginImageView.userInteractionEnabled=YES;
    [self.view addSubview:loginImageView];
    [loginImageView release];
    self.zhanghaoTextField=[[[UITextField alloc]initWithFrame:CGRectMake(40, 8.5, loginImageView.frame.size.width-50, 30)] autorelease];
    self.zhanghaoTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.zhanghaoTextField.placeholder=@"请输入账号";
    self.zhanghaoTextField.tag=0;
    self.zhanghaoTextField.keyboardType=UIKeyboardTypePhonePad;
    self.zhanghaoTextField.returnKeyType=UIReturnKeyNext;
    self.zhanghaoTextField.delegate=self;
    [loginImageView addSubview:self.zhanghaoTextField];
    
    self.mimaTextField=[[[UITextField alloc]initWithFrame:CGRectMake(40,loginImageView.frame.size.height-8.5-30, loginImageView.frame.size.width-50, 30)] autorelease];
    self.mimaTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.mimaTextField.tag=1;
    self.mimaTextField.returnKeyType=UIReturnKeyGo;
    self.mimaTextField.placeholder=@"请输入密码";
    mimaTextField.secureTextEntry = YES;
    self.mimaTextField.delegate=self;
    [loginImageView addSubview:self.mimaTextField];
    
    UIButton * wjmmButton=[[UIButton alloc]initWithFrame:CGRectMake(loginImageView.frame.origin.x+loginImageView.frame.size.width-80.5, loginImageView.frame.size.height+loginImageView.frame.origin.y+10, 70.5, 14.5)];
    [wjmmButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"000_wjmm" ofType:@"png"]] forState:UIControlStateNormal];
    [wjmmButton addTarget:self action:@selector(WangjimimaManth) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wjmmButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PushControllerMenth:) name:@"pushController" object:nil];
    
    UIButton *  zhuceButton=[UIButton buttonWithType:UIButtonTypeCustom];
    zhuceButton.frame=CGRectMake((Screen_Width-301.5)/2, loginImageView.frame.size.height+loginImageView.frame.origin.y+40, 136.5, 36);
    [zhuceButton addTarget:self action:@selector(ZhuCeMenth) forControlEvents:UIControlEventTouchUpInside];
    [zhuceButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"006_9" ofType:@"png"]] forState:UIControlStateNormal];
    [self.view addSubview:zhuceButton];
    
    UIButton * dengluButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [dengluButton addTarget:self action:@selector(DengLuMenth) forControlEvents:UIControlEventTouchUpInside];
    
    dengluButton.frame=CGRectMake(Screen_Width-136.5-(Screen_Width-301.5)/2, loginImageView.frame.size.height+loginImageView.frame.origin.y+40, 136.5, 36);
    [dengluButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"006_10" ofType:@"png"]] forState:UIControlStateNormal];
    [self.view addSubview:dengluButton];
    
    //    FenxiangView * fenxiang=[[FenxiangView alloc]initWithFrame:CGRectMake(0, Screen_Height-100-20, Screen_Width, 100)cont:self];
    //    [self.view addSubview:fenxiang];
    //    [fenxiang release];
    
    self.tishiView=[TishiView tishiViewMenth];
    [self.view addSubview:self.tishiView];
    
    if (ISIPAD) {
        titleImageView.frame=CGRectMake((Screen_Width-174.5*1.4)/2, titleImageView.frame.origin.y*1.4, titleImageView.frame.size.width*1.4, titleImageView.frame.size.height*1.4);
        loginImageView.frame=CGRectMake((Screen_Width-301.5*1.4)/2, loginImageView.frame.origin.y*1.4, loginImageView.frame.size.width*1.4, loginImageView.frame.size.height*1.4);
        self.zhanghaoTextField.frame=CGRectMake(self.zhanghaoTextField.frame.origin.x*1.4, self.zhanghaoTextField.frame.origin.y*1.4, self.zhanghaoTextField.frame.size.width*1.4, self.zhanghaoTextField.frame.size.height*1.4);
        self.zhanghaoTextField.font=[UIFont systemFontOfSize:17*1.4];
        
        self.mimaTextField.frame=CGRectMake(self.mimaTextField.frame.origin.x*1.4, self.mimaTextField.frame.origin.y*1.4, self.mimaTextField.frame.size.width*1.4, self.mimaTextField.frame.size.height*1.4);
        self.mimaTextField.font=[UIFont systemFontOfSize:17*1.4];
        
        wjmmButton.frame=CGRectMake(loginImageView.frame.origin.x+loginImageView.frame.size.width-80.5*1.4, wjmmButton.frame.origin.y*1.4, wjmmButton.frame.size.width*1.4, wjmmButton.frame.size.height*1.4);
        zhuceButton.frame=CGRectMake((Screen_Width-301.5*1.4)/2, zhuceButton.frame.origin.y*1.4, zhuceButton.frame.size.width*1.4, zhuceButton.frame.size.height*1.4);
        dengluButton.frame=CGRectMake(Screen_Width-136.5*1.4-(Screen_Width-301.5*1.4)/2, dengluButton.frame.origin.y*1.4, dengluButton.frame.size.width*1.4, dengluButton.frame.size.height*1.4);
        //        fenxiang.frame=CGRectMake(0, Screen_Height-100*1.4-20*1.4, Screen_Width, 100*1.4);
        
    }
    [self.oldDictionary setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"TokenString"] forKey:@"devicetoken"];
    
    
}
- (void)PushControllerMenth:(NSNotification *)sender
{
    for (int i=0; i<self.oldDictionary.allKeys.count; i++) {
        
        if ([[[self.oldDictionary allKeys] objectAtIndex:i] isEqualToString:@"mobile"]) {
            [self.oldDictionary removeObjectForKey:@"mobile"];
        }
        if ([[[self.oldDictionary allKeys] objectAtIndex:i] isEqualToString:@"password"]) {
            [self.oldDictionary removeObjectForKey:@"password"];
            
        }
    }
    NSLog(@"%@",sender.object);
    [self.oldDictionary setValue:[sender.object valueForKey:@"nickname"] forKey:@"nickname"];
    [self.oldDictionary setValue:[sender.object valueForKey:@"feil"] forKey:@"feil"];
    [self.oldDictionary setValue:[sender.object valueForKey:@"otherID"] forKey:@"id"];
    [self.oldDictionary setValue:[sender.object valueForKey:@"othertype"] forKey:@"type1"];
    [self AsiUrl:@"http://apptest.mum360.com/web/home/index/openplatlogin" asiControName:@"disanfanglogin"type:0];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag) {
        [textField resignFirstResponder];
        [self DengLuMenth];
    }
    else
    {
        [self.mimaTextField becomeFirstResponder];
    }
    return YES;
}
- (void)AsiUrl:(NSString *)urlString asiControName:(NSString *)controllerString type:(int)sender
{
    
    
    [self.postDictionary addEntriesFromDictionary:self.oldDictionary];
    for (int i=0; i<[[self.oldDictionary allKeys] count]; i++) {
        if ([[[self.oldDictionary allKeys] objectAtIndex: i] isEqualToString:@"feil"]) {
            [self.oldDictionary removeObjectForKey:@"feil"];
            break;
        }
    }
    NSLog(@"%@",self.oldDictionary);
    
    NSURL * aUrl=[[NSURL alloc]initWithString:urlString];
    AnalysisClass * analysis=[[AnalysisClass alloc]initWithIdentifier:aUrl DataName:Nil ControllerName:controllerString delegate:self];
    [aUrl release];
    [analysis PostMenth:self.oldDictionary];
    [self.tishiView StartMenth];
}
- (void)DengLuMenth
{
    if (self.zhanghaoTextField.text.length&&self.mimaTextField.text.length) {
        for (int i=0; i<self.oldDictionary.allKeys.count; i++) {
            
            if ([[[self.oldDictionary allKeys] objectAtIndex:i] isEqualToString:@"id"]) {
                [self.oldDictionary removeObjectForKey:@"id"];
            }
            if ([[[self.oldDictionary allKeys] objectAtIndex:i] isEqualToString:@"type1"])
            {
                [self.oldDictionary removeObjectForKey:@"type1"];
            }
        }
        
        [self.oldDictionary setValue:self.zhanghaoTextField.text forKey:@"mobile"];
        [self.oldDictionary setValue:self.mimaTextField.text forKey:@"password"];
        [self AsiUrl:@"http://apptest.mum360.com/web/home/index/login" asiControName:@"denglu"type:1];
    }
    else
    {
        NSString * tishiString=nil;
        
        if (!self.zhanghaoTextField.text||[self.zhanghaoTextField.text isEqualToString:@"请输入账号"]) {
            tishiString=@"请输入账号";
        }
        else
        {
            tishiString=@"请输入密码";
        }
        
        UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:tishiString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
    
}

- (void)OnLoginClick:(NSNotification *)noti {
    NSLog(@"OnLoginClick:%@", noti);
    NSDictionary *dict = noti.userInfo;
    if (dict) {
        zhanghaoTextField.text = [dict objectForKey:@"username"];
        mimaTextField.text = [dict objectForKey:@"password"];
        [self performSelector:@selector(DengLuMenth) withObject:nil afterDelay:0.8];
    }
}

- (void)Asihttp:(AnalysisClass *)asi DataArray:(NSMutableDictionary *)array
{
    
    [self.tishiView StopMenth];
    NSMutableDictionary * dataDic=[array valueForKey:asi.ControllerName];
    if ([[dataDic valueForKey:@"code"] intValue]==0) {
        UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:[dataDic valueForKey:@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
    else
    {
        if ([[dataDic valueForKey:@"code"] intValue]==1) {
            NSMutableDictionary * dictionary=[[NSMutableDictionary alloc]initWithCapacity:1];
            [dictionary addEntriesFromDictionary:dataDic];
            [dictionary addEntriesFromDictionary:self.oldDictionary];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"logindata"];
            [[NSUserDefaults standardUserDefaults] setValue:dictionary forKey:@"logindata"];
            [dictionary release];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"shifoulogin"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            RootViewController * root=[[RootViewController alloc]init];
            [self.navigationController pushViewController:root animated:YES];
            [root release];
        }
        else
        {
            WanshanViewController * wanshan=[[WanshanViewController alloc]init];
            [self.postDictionary setValue:@"1" forKey:@"denglutype"];
            [self.postDictionary setValue:[dataDic valueForKey:@"msg"] forKey:@"oid"];
            wanshan.oldDictionary=self.postDictionary;
            [self.navigationController pushViewController:wanshan animated:YES];
            [wanshan release];
        }
    }
    [asi release];
}



- (void)WangjimimaManth
{
    WangjmmViewController * wangjmmController=[[WangjmmViewController alloc]init];
    wangjmmController.mPhone = self.zhanghaoTextField.text;
    [self.navigationController pushViewController:wangjmmController animated:YES];
    [wangjmmController release];
}
- (void)ZhuCeMenth
{
    ZhuceViewController * zheceController=[[ZhuceViewController alloc]init];
    zheceController.oldDictionary=self.oldDictionary;
    [self.navigationController pushViewController:zheceController animated:YES];
    [zheceController release];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.mimaTextField resignFirstResponder];
    [self.zhanghaoTextField resignFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.mimaTextField resignFirstResponder];
    [self.zhanghaoTextField resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
