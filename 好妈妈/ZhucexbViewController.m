//
//  ZhucexbViewController.m
//  好妈妈
//
//  Created by iHope on 13-9-24.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "ZhucexbViewController.h"
#import "WanshanViewController.h"
@interface ZhucexbViewController ()

@end

@implementation ZhucexbViewController
@synthesize mimaTextField,quedingTextField;
@synthesize oldDictionary;

- (void)dealloc
{
    [oldDictionary release];
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
    UILabel * shoujihaoLabel=[[UILabel alloc]initWithFrame:CGRectMake((Screen_Width-310)/2, (KUIOS_7(44))+40, 80, 18)];
    shoujihaoLabel.textAlignment=NSTextAlignmentRight;
    shoujihaoLabel.textColor=[UIColor blackColor];
    shoujihaoLabel.backgroundColor=[UIColor clearColor];
    shoujihaoLabel.text=@"设置密码:";
    [self.view addSubview:shoujihaoLabel];
    [shoujihaoLabel release];
    
    UILabel * yanzhengmaLabel=[[UILabel alloc]initWithFrame:CGRectMake((Screen_Width-310)/2, shoujihaoLabel.frame.size.height+shoujihaoLabel.frame.origin.y+25, 80, 18)];
    yanzhengmaLabel.textAlignment=NSTextAlignmentRight;
    yanzhengmaLabel.textColor=[UIColor blackColor];
    yanzhengmaLabel.backgroundColor=[UIColor clearColor];
    yanzhengmaLabel.text=@"再输一次:";
    [self.view addSubview:yanzhengmaLabel];
    [yanzhengmaLabel release];
    
    UIImageView * textImageView=[[UIImageView alloc]initWithFrame:CGRectMake(shoujihaoLabel.frame.size.width+shoujihaoLabel.frame.origin.x+5, (KUIOS_7(44))+30, 214, 37)];
    textImageView.userInteractionEnabled=YES;
    textImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"006_6" ofType:@"png"]];
    [self.view addSubview:textImageView];
    [textImageView release];
    self.mimaTextField=[[[UITextField alloc]initWithFrame:CGRectMake(shoujihaoLabel.frame.origin.x+shoujihaoLabel.frame.size.width+8, (KUIOS_7(44))+30, 208, 37)] autorelease];
    self.mimaTextField.secureTextEntry=YES;
    self.mimaTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:self.mimaTextField];
    UIImageView * textImageView1=[[UIImageView alloc]initWithFrame:CGRectMake(yanzhengmaLabel.frame.size.width+yanzhengmaLabel.frame.origin.x+5, self.mimaTextField.frame.size.height+self.mimaTextField.frame.origin.y+5, 214, 37)];
    textImageView1.userInteractionEnabled=YES;
    textImageView1.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"006_6" ofType:@"png"]];
    [self.view addSubview:textImageView1];
    [textImageView1 release];

    self.quedingTextField=[[[UITextField alloc]initWithFrame:CGRectMake(yanzhengmaLabel.frame.size.width+yanzhengmaLabel.frame.origin.x+5, self.mimaTextField.frame.size.height+self.mimaTextField.frame.origin.y+8, 208, 37)] autorelease];
    self.quedingTextField.secureTextEntry=YES;
    self.quedingTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:self.quedingTextField];
    
    
    UIButton * huoquButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [huoquButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"006_7" ofType:@"png"]] forState:UIControlStateNormal];
    [huoquButton addTarget:self action:@selector(ZhuceMenth) forControlEvents:UIControlEventTouchUpInside];
    huoquButton.frame=CGRectMake((Screen_Width-278.5)/2, KUIOS_7(180), 278.5, 36);
    [self.view addSubview:huoquButton];
    if (ISIPAD) {
        shoujihaoLabel.frame=CGRectMake((Screen_Width-310*1.4)/2, shoujihaoLabel.frame.origin.y*1.4, shoujihaoLabel.frame.size.width*1.4, shoujihaoLabel.frame.size.height*1.4);
        shoujihaoLabel.font=[UIFont systemFontOfSize:17*1.4];
        yanzhengmaLabel.frame=CGRectMake((Screen_Width-310*1.4)/2, yanzhengmaLabel.frame.origin.y*1.4, yanzhengmaLabel.frame.size.width*1.4, yanzhengmaLabel.frame.size.height*1.4);
        yanzhengmaLabel.font=[UIFont systemFontOfSize:17*1.4];
        textImageView.frame=CGRectMake(shoujihaoLabel.frame.size.width+shoujihaoLabel.frame.origin.x+5, textImageView.frame.origin.y*1.4, textImageView.frame.size.width*1.4, textImageView.frame.size.height*1.4);
        textImageView1.frame=CGRectMake(textImageView.frame.origin.x, textImageView1.frame.origin.y*1.4, textImageView1.frame.size.width*1.4, textImageView1.frame.size.height*1.4);
        
        self.mimaTextField.frame=CGRectMake(shoujihaoLabel.frame.size.width+shoujihaoLabel.frame.origin.x+10, self.mimaTextField.frame.origin.y*1.4, self.mimaTextField.frame.size.width*1.4, self.mimaTextField.frame.size.height*1.4);
        self.mimaTextField.font=[UIFont systemFontOfSize:17*1.4];
        self.quedingTextField.frame=CGRectMake(yanzhengmaLabel.frame.size.width+yanzhengmaLabel.frame.origin.x+10, textImageView1.frame.origin.y, self.quedingTextField.frame.size.width*1.4, self.quedingTextField.frame.size.height*1.4);
        self.quedingTextField.font=[UIFont systemFontOfSize:17*1.4];
        huoquButton.frame=CGRectMake((Screen_Width-278.5*1.4)/2, huoquButton.frame.origin.y*1.4, huoquButton.frame.size.width*1.4, huoquButton.frame.size.height*1.4);
    }

}
- (void)ZhuceMenth
{
    
    if ([self.mimaTextField.text isEqualToString:self.quedingTextField.text]) {
       
        NSMutableDictionary * wanshanDic=[[NSMutableDictionary alloc]initWithCapacity:1];
        if (oldDictionary.count) {
            [wanshanDic addEntriesFromDictionary:oldDictionary];
        }
        [wanshanDic setObject:self.mimaTextField.text forKey:@"mima"];
        [wanshanDic setValue:@"0" forKey:@"denglutype"];
        [wanshanDic setValue:@"完善您的信息" forKey:@"navigationTitle"];
        WanshanViewController * wanshan=[[WanshanViewController alloc]init];
        wanshan.oldDictionary=wanshanDic;
        [wanshanDic release];
        [self.navigationController pushViewController:wanshan animated:YES];
        [wanshan release];
    }
    else
    {
        UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"两次密码不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.mimaTextField resignFirstResponder];
    [self.quedingTextField resignFirstResponder];
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
