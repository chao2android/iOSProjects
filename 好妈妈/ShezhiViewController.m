//
//  ShezhiViewController.m
//  好妈妈
//
//  Created by iHope on 13-9-25.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "ShezhiViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "AGViewDelegate.h"
#import "LoginViewController.h"
#import "XiugaiMimaViewController.h"
#import "YijianfankuiViewController.h"
#import "TishiView.h"
#import "BangzhuViewController.h"
#import "BanBenshuomingViewController.h"
@interface ShezhiViewController ()

@end

@implementation ShezhiViewController
@synthesize switchArray;
@synthesize tishiView;
- (void)dealloc
{
    [tishiView release];
    [ShareSDK removeNotificationWithName:SSN_USER_INFO_UPDATE target:self];

    [switchArray release];
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
    navigationLabel.text=@"设置";
    [navigation addSubview:navigationLabel];
    [navigationLabel release];
    self.switchArray=[[[NSMutableArray alloc]initWithCapacity:1] autorelease];
    [ShareSDK addNotificationWithName:SSN_USER_INFO_UPDATE
                               target:self
                               action:@selector(userInfoUpdateHandler:)];
    _shareTypeArray = [[NSMutableArray alloc] initWithObjects:
                       [NSMutableDictionary dictionaryWithObjectsAndKeys:
                        @"新浪微博",
                        @"title",
                        [NSNumber numberWithInteger:ShareTypeSinaWeibo],
                        @"type",
                        nil],
                       [NSMutableDictionary dictionaryWithObjectsAndKeys:
                        @"腾讯微博",
                        @"title",
                        [NSNumber numberWithInteger:ShareTypeTencentWeibo],
                        @"type",
                        nil],
                        [NSMutableDictionary dictionaryWithObjectsAndKeys:
                        @"QQ空间",
                        @"title",
                        [NSNumber numberWithInteger:ShareTypeQQSpace],
                        @"type",
                        nil],
                       nil];
    
    NSArray *authList = [NSArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()]];
    if (authList == nil)
    {
        [_shareTypeArray writeToFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()] atomically:YES];
    }
    else
    {
        for (int i = 0; i < [authList count]; i++)
        {
            NSDictionary *item = [authList objectAtIndex:i];
            for (int j = 0; j < [_shareTypeArray count]; j++)
            {
                if ([[[_shareTypeArray objectAtIndex:j] objectForKey:@"type"] integerValue] == [[item objectForKey:@"type"] integerValue])
                {
                    [_shareTypeArray replaceObjectAtIndex:j withObject:[NSMutableDictionary dictionaryWithDictionary:item]];
                    break;
                }
            }
        }
    }
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(5, KUIOS_7(7), 51, 33);
    [back setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backup) forControlEvents:UIControlEventTouchUpInside];
    [navigation addSubview:back];
    mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, KUIOS_7(44), Screen_Width, Screen_Height-20-44)];
    mainScrollView.showsVerticalScrollIndicator=NO;
    mainScrollView.backgroundColor=[UIColor clearColor];
    mainScrollView.userInteractionEnabled=YES;
    [self.view addSubview:mainScrollView];
    [mainScrollView release];
    UIImageView * oneImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 15, Screen_Width-20, 80)];
    oneImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"005_2" ofType:@"png"]];
    oneImageView.userInteractionEnabled=YES;
    [mainScrollView addSubview:oneImageView];
    [oneImageView release];
       for (int i=0; i<2; i++) {
        UILabel * oneImageContentLabel=[[UILabel alloc]initWithFrame:CGRectMake(20,(40-18)/2+40*i , 150, 18)];
        
        oneImageContentLabel.font=[UIFont systemFontOfSize:16];
        if (i==0) {
           oneImageContentLabel.text=@"新浪微博账号绑定";
        }
        else
        {
            oneImageContentLabel.text=@"腾讯微博账号绑定";
        }
        [oneImageView addSubview:oneImageContentLabel];
        [oneImageContentLabel release];
        UISwitch * switchoneBut=[[UISwitch alloc]initWithFrame:CGRectMake(oneImageView.frame.size.width-80, (40-26)/2+40*i , 35, 25)];
        [oneImageView addSubview:switchoneBut];
        NSDictionary *item = [_shareTypeArray objectAtIndex:i];

        switchoneBut.on=[ShareSDK hasAuthorizedWithType:[[item objectForKey:@"type"] integerValue]];
        switchoneBut.tag=i;
        [switchoneBut addTarget:self action:@selector(authSwitchChangeHandler:) forControlEvents:UIControlEventValueChanged];
        [self.switchArray addObject:switchoneBut];
        [switchoneBut release];
        if (ISIPAD) {
            oneImageContentLabel.frame=CGRectMake(20*1.4, 80*1.4/2*i+(80*1.4/2-18*1.4)/2, 150*1.4, 18*1.4);
            oneImageContentLabel.font=[UIFont systemFontOfSize:16*1.4];
            switchoneBut.frame=CGRectMake(oneImageView.frame.size.width-80*1.4, 80*1.4/2*i+(80*1.4/2-18*1.4)/2 , 35*1.4, 25*1.4);
        }
    }
    

    UIButton * twoimageBut=[UIButton buttonWithType:UIButtonTypeCustom];
    twoimageBut.frame=CGRectMake(10, oneImageView.frame.size.height+oneImageView.frame.origin.y+5, Screen_Width-20, 41);
    [twoimageBut setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"005_3" ofType:@"png"]] forState:UIControlStateNormal];
    [twoimageBut addTarget:self action:@selector(XiuGaiMima) forControlEvents:UIControlEventTouchUpInside];
    [twoimageBut setTitle:@"     修改密码" forState:UIControlStateNormal];
    twoimageBut.titleLabel.font=[UIFont systemFontOfSize:16];
    [twoimageBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    twoimageBut.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft ;
    [mainScrollView addSubview:twoimageBut];
  

//
    UIImageView * butImageView=[[UIImageView alloc]initWithFrame:CGRectMake(twoimageBut.frame.size.width-20, (twoimageBut.frame.size.height-13.5)/2, 9, 13.5)];
    butImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"003_26" ofType:@"png"]];
    [twoimageBut addSubview:butImageView];
    [butImageView release];
    
   //
    UIImageView * threeImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, twoimageBut.frame.size.height+twoimageBut.frame.origin.y+5, Screen_Width-20, 242)];
    threeImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"005_4" ofType:@"png"]];
    threeImageView.userInteractionEnabled=YES;
    [mainScrollView addSubview:threeImageView];
    [threeImageView release];
    
    NSString * butTitleString=nil;
    for (int i=0; i<6; i++) {
        UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.tag=i;
        if (i==0) {
            butTitleString=@"     清除缓存";
        }
        else if (i==1)
        {
            butTitleString=@"     推送";
        }
        else if (i==2)
        {
            butTitleString=@"     好评";
        }
        else if (i==3)
        {
            butTitleString=@"     反馈";
        }
        else if (i==4)
        {
            butTitleString=@"     使用说明";
        }
        else
        {
            butTitleString=@"     版本说明";
        }
        [button addTarget:self action:@selector(ButtonMenth:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:butTitleString forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:16];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft ;
        if (i==1)
        {

        }
        button.frame=CGRectMake(0, 40*i, twoimageBut.frame.size.width, 40);
        if (ISIPAD) {
            button.frame=CGRectMake(0, 40*i*1.4, twoimageBut.frame.size.width, 40*1.4);
            button.titleLabel.font=[UIFont systemFontOfSize:16*1.4];

        }
        [threeImageView addSubview:button];
        if (i!=1) {
            UIImageView * buttonImageView=[[UIImageView alloc]initWithFrame:CGRectMake(button.frame.size.width-20, (button.frame.size.height-13.5)/2, 9, 13.5)];
            buttonImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"003_26" ofType:@"png"]];
            [button addSubview:buttonImageView];
            [buttonImageView release];
            if (ISIPAD) {
                buttonImageView.frame=CGRectMake(button.frame.size.width-20*1.4, (button.frame.size.height-13.5*1.4)/2, 9*1.4, 13.5*1.4);
            }
        }
        else
        {
            UISwitch * switchBut=[[UISwitch alloc]initWithFrame:CGRectMake(button.frame.size.width-80, (40.4-25)/2, 35, 25)];
            if (ISIPAD) {
                switchBut.frame=CGRectMake(oneImageView.frame.size.width-80*1.4,(80*1.4/2-18*1.4)/2 , 35*1.4, 25*1.4);

            }
            if ([[NSUserDefaults standardUserDefaults]boolForKey:@"tuisong"]) {
                switchBut.tag=0;
                switchBut.on=NO;
            }
            else
            {
                switchBut.on=YES;
               switchBut.tag=1;
            }
            [switchBut addTarget:self action:@selector(TuiSongMenth:) forControlEvents:UIControlEventTouchUpInside];
            [button addSubview:switchBut];
            [switchBut release];
        }
    }
    
    UIButton * tuichuBut=[UIButton buttonWithType:UIButtonTypeCustom];
    tuichuBut.frame=CGRectMake((Screen_Width-298.5)/2, threeImageView.frame.origin.y+threeImageView.frame.size.height+15, 298.5, 39);
    
    [tuichuBut addTarget:self action:@selector(TcMenth) forControlEvents:UIControlEventTouchUpInside];
    [tuichuBut setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"005_1" ofType:@"png"]] forState:UIControlStateNormal];
    [mainScrollView addSubview:tuichuBut];
    if (ISIPAD) {
        oneImageView.frame=CGRectMake(10*1.4, 15*1.4, Screen_Width-10*1.4*2, 80*1.4);
        twoimageBut.frame=CGRectMake(10*1.4, oneImageView.frame.size.height+oneImageView.frame.origin.y+5*1.4, Screen_Width-10*1.4*2, 40*1.4);
        twoimageBut.titleLabel.font=[UIFont systemFontOfSize:16*1.4];
        butImageView.frame=CGRectMake(twoimageBut.frame.size.width-20*1.4, (twoimageBut.frame.size.height-13.5*1.4)/2, 9*1.4, 13.5*1.4);
        threeImageView.frame=CGRectMake(10*1.4, twoimageBut.frame.size.height+twoimageBut.frame.origin.y+5*1.4, Screen_Width-10*1.4*2, 242*1.4);
        tuichuBut.frame=CGRectMake((Screen_Width-298.5*1.4)/2, threeImageView.frame.origin.y+threeImageView.frame.size.height+15*1.4, 298.5*1.4, 39*1.4);
    }

    [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, tuichuBut.frame.origin.y+tuichuBut.frame.size.height+15)];
}
- (void)TuiSongMenth:(UISwitch *)sender
{
    if (sender.tag)
    {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"tuisong"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"tuisong"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    sender.tag=!sender.tag;

}
- (void)StoptishiMenth
{
    [self.tishiView StopMenth];
}
- (void)ButtonMenth:(UIButton *)sender
{
    if (sender.tag==0) {
        NSArray *cache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachePath = [cache objectAtIndex:0];
         NSFileManager *defaultManager = [NSFileManager defaultManager];
        [defaultManager removeItemAtPath:cachePath error:nil];
        self.tishiView=[TishiView tishiViewMenth];
        [self.view addSubview:self.tishiView];
        self.tishiView.titlelabel.text=@"清空中...";
        [self.tishiView StartMenth];
        [self performSelector:@selector(StoptishiMenth) withObject:self afterDelay:1];
    }
    else if (sender.tag==3) {
        YijianfankuiViewController * yijianfankui=[[YijianfankuiViewController alloc]init];
        [self.navigationController pushViewController:yijianfankui animated:YES];
        [yijianfankui release];
    }
    else if (sender.tag==4)
    {
        BangzhuViewController * bangzhu=[[BangzhuViewController alloc]init];
        bangzhu.shouming=NO;
        [self.navigationController pushViewController:bangzhu animated:YES];
        [bangzhu  release];
        
    }
    else if (sender.tag==5)
    {
        BanBenshuomingViewController * bangzhu=[[BanBenshuomingViewController alloc]init];
        [self.navigationController pushViewController:bangzhu animated:YES];
        [bangzhu  release];
    }
    NSLog(@"sender  %d",sender.tag);
}
- (void)XiuGaiMima
{
    XiugaiMimaViewController * xiugaiController=[[XiugaiMimaViewController alloc]init];
    [self.navigationController pushViewController:xiugaiController animated:YES];
    [xiugaiController release];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        for (int i=1; i<4; i++) {
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
   
    NSLog(@"buttonIndex  %d",buttonIndex);
}
- (void)TcMenth
{
    UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您确定要退出吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    [alertView release];
}
- (void)authSwitchChangeHandler:(UISwitch *)sender
{
    NSInteger index = sender.tag;
    
    if (index < [_shareTypeArray count])
    {
        NSMutableDictionary *item = [_shareTypeArray objectAtIndex:index];
        if (sender.on)
        {
            //用户用户信息
            ShareType type = [[item objectForKey:@"type"] integerValue];
            AGViewDelegate * _viewDelegate = [[AGViewDelegate alloc] init];
            
            id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                                 allowCallback:NO
                                                                 authViewStyle:SSAuthViewStyleFullScreenPopup
                                                                  viewDelegate:nil
                                                       authManagerViewDelegate:_viewDelegate];
            
            [authOptions setPowerByHidden:YES];
            
            [ShareSDK getUserInfoWithType:type
                              authOptions:authOptions
                                   result:^(BOOL result, id<ISSUserInfo> userInfo, id<ICMErrorInfo> error) {
                                       if (result)
                                       {
                                           NSLog(@"fsdfsd");
                                           [item setObject:[userInfo nickname] forKey:@"username"];
                                           [_shareTypeArray writeToFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()] atomically:YES];
                                       }
                                       NSLog(@"%d:%@",[error errorCode], [error errorDescription]);
                                       for (int i=0; i<2; i++) {
                                           NSDictionary *item = [_shareTypeArray objectAtIndex:i];
                                           UISwitch * switchBut=[self.switchArray objectAtIndex:i];
                                           switchBut.on = [ShareSDK hasAuthorizedWithType:[[item objectForKey:@"type"] integerValue]];
                                       }

//                                       [_tableView reloadData];
                                   }];
            [_viewDelegate release];
        }
        else
        {
            //取消授权
            [ShareSDK cancelAuthWithType:[[item objectForKey:@"type"] integerValue]];
            for (int i=0; i<2; i++) {
                NSDictionary *item = [_shareTypeArray objectAtIndex:i];
                UISwitch * switchBut=[self.switchArray objectAtIndex:i];
                switchBut.on = [ShareSDK hasAuthorizedWithType:[[item objectForKey:@"type"] integerValue]];
            }
//            [_tableView reloadData];
        }
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hidesTabBar" object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayTabBar" object:nil];
}
- (void)userInfoUpdateHandler:(NSNotification *)notif
{
    NSInteger plat = [[[notif userInfo] objectForKey:SSK_PLAT] integerValue];
    id<ISSUserInfo> userInfo = [[notif userInfo] objectForKey:SSK_USER_INFO];
    
    for (int i = 0; i < [_shareTypeArray count]; i++)
    {
        NSMutableDictionary *item = [_shareTypeArray objectAtIndex:i];
        ShareType type = [[item objectForKey:@"type"] integerValue];
        if (type == plat)
        {
            [item setObject:[userInfo nickname] forKey:@"username"];
            
        }
    }
    
    for (int i=0; i<2; i++) {
        NSDictionary *item = [_shareTypeArray objectAtIndex:i];
        UISwitch * switchBut=[self.switchArray objectAtIndex:i];
        switchBut.on = [ShareSDK hasAuthorizedWithType:[[item objectForKey:@"type"] integerValue]];
    }
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
