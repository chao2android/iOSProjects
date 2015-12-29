//
//  PlViewController.m
//  好妈妈
//
//  Created by iHope on 13-10-30.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "PlViewController.h"
#import "AutoAlertView.h"
@interface PlViewController ()

@end

@implementation PlViewController
@synthesize idString;
- (void)dealloc
{
    [idString release];
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
    backImageView.userInteractionEnabled=YES;
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
    UILabel * navigationLabel=[[UILabel alloc]initWithFrame:CGRectMake(100, KUIOS_7(11), (Screen_Width-200), 22)];
    navigationLabel.backgroundColor=[UIColor clearColor];
    //    navigationLabel.font=[UIFont systemFontOfSize:22];
    navigationLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:22];
    navigationLabel.textAlignment=NSTextAlignmentCenter;
    navigationLabel.textColor=[UIColor whiteColor];
    navigationLabel.text=@"评论";
    [navigation addSubview:navigationLabel];
    [navigationLabel release];
    UIImageView * contentImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 20+(KUIOS_7(44)), Screen_Width-20, 130)];
    contentImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"001_22" ofType:@"png"]];
    contentImageView.userInteractionEnabled=YES;
    [backImageView addSubview:contentImageView];
    [contentImageView release];
    
    contentTextView=[[UITextView alloc]initWithFrame:CGRectMake(5, KUIOS_7(5), Screen_Width-30, 120)];
    contentTextView.backgroundColor=[UIColor clearColor];
    contentTextView.userInteractionEnabled=YES;
    contentTextView.delegate=self;
    [contentImageView addSubview:contentTextView];
    [contentTextView release];
    inputView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 200)];
    inputView.backgroundColor=LIGHTBACK_COLOR;
    
    //    emokeyView.OnSendClick = @selector(OnSendClick);
    //     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UITextViewTextDidEndEditingNotification object:nil];
    
    UIView * AccessoryView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 40)];
    AccessoryView.backgroundColor=[UIColor clearColor];
    [contentTextView setInputAccessoryView:AccessoryView];
    [AccessoryView release];
    UIImageView * AccessoryImageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, -1, Screen_Width, 1)];
    AccessoryImageview.userInteractionEnabled=YES;
    AccessoryImageview.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"jianpan8" ofType:@"png"]];
    [AccessoryView addSubview:AccessoryImageview];
    [AccessoryImageview release];
    for (int i=0; i<2; i++) {
        UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
        if (i) {
            [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"fabiao%d",2] ofType:@"png"]] forState:UIControlStateNormal];

        }
        else
        {
            [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chattextback@2x" ofType:@"png"]] forState:UIControlStateNormal];
        }
        button.frame=CGRectMake(64*i+15, (40-20.5)/2, 24, 20.5);
        button.tag=i;
        [button addTarget:self action:@selector(ButtonMenth:) forControlEvents:UIControlEventTouchUpInside];
        [AccessoryView addSubview:button];
    }
    UIButton* rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBut.frame = CGRectMake(Screen_Width-52, KUIOS_7(7), 47, 30);
    [rightBut setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"002_39" ofType:@"png"]] forState:UIControlStateNormal];
    [rightBut addTarget:self action:@selector(RightMenth) forControlEvents:UIControlEventTouchUpInside];
    [navigation addSubview:rightBut];
    tishiView=[TishiView tishiViewMenth];
    [self.view addSubview:tishiView];

}
- (void)RightMenth
{
    if (!contentTextView.text.length) {
        [AutoAlertView ShowAlert:@"温馨提示" message:@"请输入发布内容"];
        return;
    }
    
    [tishiView StartMenth];
    [contentTextView resignFirstResponder];
    NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
    
    NSMutableDictionary * asiDic=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[userDic valueForKey:@"uid"],@"uid",[userDic valueForKey:@"token"],@"token", self.idString,@"tid",nil];
    [asiDic setValue:contentTextView.text forKey:@"text"];
    NSURL * aUrl=[[NSURL alloc]initWithString:@"http://apptest.mum360.com/web/home/index/createtopiccomment"];
    analysis=[[AnalysisClass alloc]initWithIdentifier:aUrl DataName:Nil ControllerName:@"fabuxinxiaoxi" delegate:self];
    [aUrl release];
    [analysis PostMenth:asiDic];
    [asiDic release];
}
- (void)Asihttp:(AnalysisClass *)asi DataArray:(NSMutableDictionary *)array
{
    [tishiView StopMenth];
    if ([[[array valueForKey:asi.ControllerName] valueForKey:@"code"] intValue]) {
        [self backup];
    }
    else
    {
        [AutoAlertView ShowAlert:@"温馨提示" message:[[array valueForKey:asi.ControllerName] valueForKey:@"msg"]];
    }
    [asi release];
    analysis=nil;
}
- (void)ButtonMenth:(UIButton *)sender
{
    if (sender.tag) {
        
    
    if (inputView.subviews.count) {
        for (int i=0; i<inputView.subviews.count; i++) {
            [[inputView.subviews objectAtIndex:i] removeFromSuperview];
        }
    }
        emokeyView = [[EmoKeyboardView alloc]initWithFrame:CGRectMake(0, 0, inputView.frame.size.width, inputView.frame.size.height)button:YES];
        emokeyView.delegate = self;
        emokeyView.OnEmoSelect = @selector(OnEmoSelect:);
        [inputView addSubview:emokeyView];
        [emokeyView release];
    [contentTextView resignFirstResponder];
    contentTextView.inputView=inputView;
    [contentTextView becomeFirstResponder];
    }
    else
    {
        [contentTextView resignFirstResponder];
        contentTextView.inputView=nil;
        [contentTextView becomeFirstResponder];
    }

}
- (void)OnEmoSelect:(NSString *)text {
    if (!contentTextView.text) {
        contentTextView.text = @"";
    }
    
    contentTextView.text = [contentTextView.text stringByAppendingString:text];
}
- (void)backup
{
    [self dismissModalViewControllerAnimated:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
