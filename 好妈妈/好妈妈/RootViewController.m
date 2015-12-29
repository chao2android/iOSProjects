//
//  RootViewController.m
//  好妈妈
//
//  Created by iHope on 13-9-22.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "RootViewController.h"


#import "ZhiDaoViewController.h"
#import "QuanZiViewController.h"
#import "WoViewController.h"
#import "GongjuViewController.h"
#import "GengduoViewController.h"


#import <QuartzCore/QuartzCore.h>
#import <ShareSDK/ShareSDK.h>
#import "LoginViewController.h"
#import "AutoAlertView.h"
#import "ADLoadManager.h"

@interface RootViewController ()

@end

@implementation RootViewController
@synthesize tabbarImageView;
@synthesize num;
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [tabbarImageView release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    numnum=[nibNameOrNil intValue];
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
    }
    return self;
}
- (void)DismissTishiMenth:(NSNotification *)sender
{
    if ([[sender.object valueForKey:@"hide"] intValue]) {
        tishiLabel.hidden=NO;
        tishiLabel.text=[sender.object valueForKey:@"content"];
    }
    else
    {
        tishiLabel.hidden=YES;
    }
    
}


-(void) viewDidAppear:(BOOL)animated
{
    [self.selectedViewController endAppearanceTransition];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [self.selectedViewController beginAppearanceTransition: NO animated: animated];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [self.selectedViewController endAppearanceTransition];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.selectedViewController beginAppearanceTransition: YES animated: animated];
    
    [self AsiMenth];
    
    
}
- (void)AsiMenth1
{
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
    NSMutableDictionary * urlString=[[NSMutableDictionary alloc]initWithObjectsAndKeys:appVersion,@"ver",@"1",@"flag", nil];
    NSURL * aUrl=[[NSURL alloc]initWithString:@"http://apptest.mum360.com/web/home/index/version"];
    AnalysisClass *  analysis=[[AnalysisClass alloc]initWithIdentifier:aUrl DataName:nil ControllerName:@"banben" delegate:self];
    [aUrl release];
    [analysis PostMenth:urlString];
    [urlString release];
}
// http://apptest.mum360.com/web/home/index/getuserstate

- (void)AsiMenth
{
    NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
    if ([[NSString stringWithFormat:@"%@",[userDic valueForKey:@"uid"]] length]&&[[userDic valueForKey:@"token"] length])
    {
        NSMutableDictionary * urlString=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[userDic valueForKey:@"uid"],@"uid",[userDic valueForKey:@"token"],@"token", nil];
        NSURL * aUrl=[[NSURL alloc]initWithString:@"http://apptest.mum360.com/web/home/index/messagelist"];
        AnalysisClass *  analysis=[[AnalysisClass alloc]initWithIdentifier:aUrl DataName:nil ControllerName:@"tishi" delegate:self];
        [aUrl release];
        [analysis PostMenth:urlString];
        [urlString release];
    }
}
- (void)chongxindenglu
{
    for (int i=1; i<4; i++)
    {
        if (i==3) {
            i=6;
        }
        [ShareSDK  cancelAuthWithType:i];
    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"logindata"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"shifoulogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    LoginViewController * loginCotroller=[[LoginViewController alloc]init];
    UINavigationController * loginNavigation=[[UINavigationController alloc]initWithRootViewController:loginCotroller];
    [loginCotroller release];
    [self presentModalViewController:loginNavigation animated:NO];
    [loginNavigation release];
    
}

- (void)Asihttp:(AnalysisClass *)asi DataArray:(NSMutableDictionary *)array
{
    
    NSDictionary * asiDic=[array valueForKey:asi.ControllerName];
    if ([asi.ControllerName isEqualToString:@"tishi"]) {
        
        if ([[asiDic valueForKey:@"count"] intValue]) {
            tishiLabel.hidden=NO;
            tishiLabel.text=[NSString stringWithFormat:@"%d",[[asiDic valueForKey:@"count"] intValue]];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"xiaoshishu"];
            [[NSUserDefaults standardUserDefaults] setObject:[asiDic valueForKey:@"count"] forKey:@"xiaoshishu"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"woxiaoxi" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"wosixintishi" object:nil];
        }
    }
    else if ([asi.ControllerName isEqualToString:@"huoquzhuangtai"])
    {
        
        NSMutableDictionary * asiDiction=[[NSMutableDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"]];
        [asiDiction addEntriesFromDictionary:[array valueForKey:asi.ControllerName]];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"logindata"];
        [asiDiction setValue:[asiDic valueForKey:@"age"] forKey:@"age"];
        [asiDiction setValue:[asiDic valueForKey:@"day"] forKey:@"dayday"];
        [[NSUserDefaults standardUserDefaults] setValue:asiDiction forKey:@"logindata"];
        [asiDiction release];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        if ([[asiDic valueForKey:@"code"] intValue]) {
            UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"发现新版本" message:[asiDic valueForKey:@"msg"] delegate:self cancelButtonTitle:@"下次再说" otherButtonTitles:@"立即体验", nil];
            [alertView show];
            [alertView release];
            banbenString=[[NSString alloc]initWithFormat:@"%@",[asiDic valueForKey:@"url"]];
        }
    }
    [asi release];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        if (banbenString.length) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:banbenString]];
        }
        else
        {
            [AutoAlertView ShowAlert:@"温馨提示" message:@"无更新连接..."];
        }
        [banbenString release];
    }
    else
    {
        [NSTimer scheduledTimerWithTimeInterval:24*60*60 target:self selector:@selector(AsiMenth1) userInfo:nil repeats:NO];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(AsiMenth1) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(AsiMenth) userInfo:nil repeats:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chongxindenglu) name:@"chongxindenglu" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidesTabBar) name:@"hidesTabBar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DisplayTabBar) name:@"DisplayTabBar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DismissTishiMenth:) name:@"xiaoxitishi" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TuisongMenth:) name:@"Tuisongtishi" object:nil];
    
	// Do any additional setup after loading the view.
    ZhiDaoViewController * mainVC = [[ZhiDaoViewController alloc] init];
    UINavigationController * nav1 = [[UINavigationController alloc] initWithRootViewController:mainVC];
    [mainVC release];
    [nav1.tabBarItem setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"@2x_02" ofType:@"png"]]];
    
    QuanZiViewController * circleVC = [[QuanZiViewController alloc] init];
    UINavigationController * nav2 = [[UINavigationController alloc] initWithRootViewController:circleVC];
    [circleVC release];
    
    WoViewController * personalVC = [[WoViewController alloc] init];
    UINavigationController * nav3 = [[UINavigationController alloc] initWithRootViewController:personalVC];
    [personalVC release];
    
    GongjuViewController * toolVC = [[GongjuViewController alloc] init];
    UINavigationController * nav4 = [[UINavigationController alloc] initWithRootViewController:toolVC];
    [toolVC release];
    
    GengduoViewController * moreVC = [[GengduoViewController alloc] init];
    UINavigationController * nav5 = [[UINavigationController alloc] initWithRootViewController:moreVC];
    [moreVC release];
    NSArray * array=[[NSArray alloc]initWithObjects:nav1,nav2,nav3,nav4,nav5, nil];
    self.viewControllers=array;
    [nav1 release];
    [nav2 release];
    [nav3 release];
    [nav4 release];
    [nav5 release];
    [array release];
    self.tabBar.hidden=YES;
    [[self.view.subviews objectAtIndex:0] setFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    
    self.tabbarImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, Screen_Height-47, Screen_Width, 47)] autorelease];
    if (ISIPAD)
    {
        self.tabbarImageView.frame=CGRectMake(0, Screen_Height-64, Screen_Width, 64);
    }
    self.tabbarImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"000_28" ofType:@"png"]];
    self.tabbarImageView.userInteractionEnabled=YES;
    [self.view addSubview:self.tabbarImageView];
    int juli=0;
    int iWidth = Screen_Width/5;
    int iHeight = 43.5;
    if (ISIPAD) {
        juli=(Screen_Width-425)/2;
        iWidth=85;
        iHeight=64-4.9;
    }
    for (int i=0; i<5; i++)
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(juli+iWidth*i, self.tabbarImageView.frame.size.height-iHeight, iWidth, iHeight);
        [button addTarget:self action:@selector(selectButtonMenth:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [self.tabbarImageView addSubview:button];
        UIImage *aImage =nil;
        if (ISIPAD)
        {
            aImage = [UIImage imageNamed:[NSString stringWithFormat:@"%d_2.png",i+1]];
        }
        else
        {
            aImage = [UIImage imageNamed:[NSString stringWithFormat:@"000_%dz.png",i]];
        }
        UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake((iWidth-aImage.size.width/2)/2, (iHeight-aImage.size.height/2)/2, aImage.size.width/2, aImage.size.height/2)];
        imageview.image = aImage;
        [button addSubview:imageview];
        [imageview release];
        
        if (i==numnum) {
            if (ISIPAD) {
                imageview.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d",i+1] ofType:@"png"]];
            }
            else
                
            {
                imageview.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"000_%d",i] ofType:@"png"]];
            }
            [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"000_s" ofType:@"png"]] forState:UIControlStateNormal];
        }
        
    }
    tishiLabel=[[UILabel alloc]initWithFrame:CGRectMake(juli+iWidth*3-30, -5, 20, 20)];
    tishiLabel.backgroundColor=[UIColor redColor];
    [tishiLabel.layer setCornerRadius:10];
    tishiLabel.textAlignment=UITextAlignmentCenter;
    tishiLabel.textColor=[UIColor whiteColor];
    tishiLabel.font=[UIFont systemFontOfSize:16];
    [tishiLabel.layer setMasksToBounds:YES];
    [self.tabbarImageView addSubview:tishiLabel];
    [tishiLabel release];
    tishiLabel.hidden=YES;
    
    NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
    if ([[NSString stringWithFormat:@"%@",[userDic valueForKey:@"uid"]] length]&&[[userDic valueForKey:@"token"] length])
    {
        NSMutableDictionary * urlString=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[userDic valueForKey:@"uid"],@"userid", nil];
        NSURL * aUrl=[[NSURL alloc]initWithString:@"http://apptest.mum360.com/web/home/index/getuserstate"];
        AnalysisClass *  analysis=[[AnalysisClass alloc]initWithIdentifier:aUrl DataName:nil ControllerName:@"huoquzhuangtai" delegate:self];
        [aUrl release];
        [analysis PostMenth:urlString];
        [urlString release];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnLocationFinish) name:kMsg_Location object:nil];
    [[UserLocationManager Share] StartLocation];
}

- (void)OnLocationFinish {
    [[ADLoadManager Share] GetADImage];
}

- (void)TuisongMenth:(NSNotification *)sender
{
    UIButton * butt=[UIButton buttonWithType:UIButtonTypeCustom];
    butt.tag=3;
    [self selectButtonMenth:butt];
}
- (void)selectButtonMenth:(UIButton *)sender
{
    if (sender.tag == 0) {
    }
    else if (sender.tag == 1) {
        MOBCLICK(kMob_MyGroup);
    }
    else if (sender.tag == 2) {
        MOBCLICK(kMob_HomePage);
    }
    else if (sender.tag == 3) {
        MOBCLICK(kMob_Tools);
    }
    else if (sender.tag == 4) {
        MOBCLICK(kMob_More);
    }
    self.selectedIndex=sender.tag;
    if (sender.tag==2) {
        NSDictionary * xiaoDic=[[NSDictionary alloc]initWithObjectsAndKeys:@"0",@"hide", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"xiaoxitishi" object:xiaoDic];
        [xiaoDic release];
    }
    for (int i=0; i<[[self.tabbarImageView subviews] count]-1; i++) {
        UIButton * button=[[self.tabbarImageView subviews] objectAtIndex:i];
        UIImageView * imageview=[[button subviews] lastObject];
        if (i==sender.tag) {
            
            [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"000_s" ofType:@"png"]] forState:UIControlStateNormal];
            if (ISIPAD) {
                imageview.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d",i+1] ofType:@"png"]];
                
            }
            else
            {
                imageview.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"000_%d",i] ofType:@"png"]];
            }
        }
        else
        {
            [button setImage:nil forState:UIControlStateNormal];
            if (ISIPAD) {
                imageview.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d_2",i+1] ofType:@"png"]];
                
            }
            else
            {
                imageview.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"000_%dz",i] ofType:@"png"]];
            }
        }
    }
}

//隐藏TabBar所在的视图
-(void) hidesTabBar
{
    self.tabbarImageView.hidden=YES;
}
-(void) DisplayTabBar
{
    self.tabbarImageView.hidden=NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
