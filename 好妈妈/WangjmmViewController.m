//
//  WangjmmViewController.m
//  好妈妈
//
//  Created by iHope on 13-9-29.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "WangjmmViewController.h"
#import "AutoAlertView.h"
#import "XiugaiMimaViewController.h"
@interface WangjmmViewController ()

@end

@implementation WangjmmViewController
@synthesize shoujihaoTextfield, mPhone;

- (void)dealloc
{
    [shoujihaoTextfield release];
    self.mPhone = nil;
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
    navigationLabel.text=@"忘记密码";
    [navigation addSubview:navigationLabel];
    [navigationLabel release];
    
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(5, KUIOS_7(7), 51, 33);
    [back setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backup) forControlEvents:UIControlEventTouchUpInside];
    [navigation addSubview:back];
    
    UILabel * shoujihaoLabel=[[UILabel alloc]initWithFrame:CGRectMake((Screen_Width-310)/2, (KUIOS_7(44))+40, 75, 18)];
    shoujihaoLabel.textAlignment=NSTextAlignmentRight;
    shoujihaoLabel.textColor=[UIColor blackColor];
    shoujihaoLabel.backgroundColor=[UIColor clearColor];
    shoujihaoLabel.text=@"手机号:";
    [self.view addSubview:shoujihaoLabel];
    [shoujihaoLabel release];
    UIImageView * textImageView=[[UIImageView alloc]initWithFrame:CGRectMake(shoujihaoLabel.frame.size.width+shoujihaoLabel.frame.origin.x+5, (KUIOS_7(44))+30, 214, 37)];
    textImageView.userInteractionEnabled=YES;
    textImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"006_6" ofType:@"png"]];
    [self.view addSubview:textImageView];
    [textImageView release];
    self.shoujihaoTextfield=[[[UITextField alloc]initWithFrame:CGRectMake(shoujihaoLabel.frame.size.width+shoujihaoLabel.frame.origin.x+8, (KUIOS_7(44))+30, 206, 37)] autorelease];
    self.shoujihaoTextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.shoujihaoTextfield.keyboardType=UIKeyboardTypePhonePad;
    self.shoujihaoTextfield.text = mPhone;
    [self.view addSubview:self.shoujihaoTextfield];
    
    
    zhaohuiButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [zhaohuiButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"找回密码" ofType:@"png"]] forState:UIControlStateNormal];
    zhaohuiButton.frame=CGRectMake((Screen_Width-294)/2, self.shoujihaoTextfield.frame.size.height+self.shoujihaoTextfield.frame.origin.y+20, 294, 35);
    [zhaohuiButton addTarget:self action:@selector(ZhaohuiMenth) forControlEvents:UIControlEventTouchUpInside];
    zhaohuiButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NavigationBG" ofType:@"png"]]];
    [self.view addSubview:zhaohuiButton];
    if (ISIPAD) {
        shoujihaoLabel.frame=CGRectMake((Screen_Width-310*1.4)/2, shoujihaoLabel.frame.origin.y*1.4, shoujihaoLabel.frame.size.width*1.4, shoujihaoLabel.frame.size.height*1.4);
        shoujihaoLabel.font=[UIFont systemFontOfSize:17*1.4];
        textImageView.frame=CGRectMake(shoujihaoLabel.frame.size.width+shoujihaoLabel.frame.origin.x+5, textImageView.frame.origin.y*1.4, textImageView.frame.size.width*1.4, textImageView.frame.size.height*1.4);
        self.shoujihaoTextfield.frame=CGRectMake(shoujihaoLabel.frame.size.width+shoujihaoLabel.frame.origin.x+10, self.shoujihaoTextfield.frame.origin.y*1.4, self.shoujihaoTextfield.frame.size.width*1.4, self.shoujihaoTextfield.frame.size.height*1.4);
        self.shoujihaoTextfield.font=[UIFont systemFontOfSize:17*1.4];
        zhaohuiButton.frame=CGRectMake((Screen_Width-294*1.4)/2, zhaohuiButton.frame.origin.y*1.4, zhaohuiButton.frame.size.width*1.4, zhaohuiButton.frame.size.height*1.4);
    }
    tishiView=[TishiView tishiViewMenth];
    tishiView.titlelabel.text=@"加载中";
    [self.view addSubview:tishiView];
    

}
- (void)ZhaohuiMenth
{
    if (!self.shoujihaoTextfield.text.length) {
        [AutoAlertView ShowAlert:@"温馨提示" message:@"请输入手机号"];
    }
    else
    {
        [tishiView StartMenth];

    NSURL * aUrl=[[NSURL alloc]initWithString:@"http://apptest.mum360.com/web/home/index/getpassword"];
     analysis=[[AnalysisClass alloc]initWithIdentifier:aUrl DataName:Nil ControllerName:@"zhaohuimima" delegate:self];
    [aUrl release];
    NSMutableDictionary * aDictionary=[[NSMutableDictionary alloc]initWithObjectsAndKeys:self.shoujihaoTextfield.text,@"mobile", nil];
    [analysis PostMenth:aDictionary];
    [aDictionary release];
    
        
    }
    
}
- (void)Asihttp:(AnalysisClass *)asi DataArray:(NSMutableDictionary *)array
{
    [tishiView StopMenth];
    [AutoAlertView ShowAlert:@"温馨提示" message:[[array valueForKey:asi.ControllerName] valueForKey:@"msg"]];
    if ([[[array valueForKey:asi.ControllerName] valueForKey:@"code"] intValue]) {
        [zhaohuiButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"找回密码_" ofType:@"png"]] forState:UIControlStateNormal];
        zhaohuiButton.userInteractionEnabled=NO;
        if (huoquTimer) {
            [huoquTimer invalidate];
            huoquTimer=nil;
        }
        if (huoquTimer==nil) {
            huoquTimer=[NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(HuoQuJiHuoMenth) userInfo:nil repeats:NO];
        }

        XiugaiMimaViewController * xiugaiController=[[XiugaiMimaViewController alloc]init];
        xiugaiController.biaotiBool=YES;
        xiugaiController.mMobile = shoujihaoTextfield.text;
        [self.navigationController pushViewController:xiugaiController animated:YES];
        [xiugaiController release];
    }
    [asi release];
    analysis=nil;
}
- (void)HuoQuJiHuoMenth
{
    if (huoquTimer) {
        [huoquTimer invalidate];
        huoquTimer=nil;
    }
    zhaohuiButton.userInteractionEnabled=YES;
    [zhaohuiButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"找回密码_" ofType:@"png"]] forState:UIControlStateNormal];
}
- (void)viewWillDisappear:(BOOL)animated
{
    if (analysis) {
        [analysis CancelMenthrequst];
        analysis=nil;
    }
}
- (void)backup
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.shoujihaoTextfield resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
