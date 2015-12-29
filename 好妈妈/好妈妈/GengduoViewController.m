//
//  GengduoViewController.m
//  好妈妈
//
//  Created by iHope on 13-9-22.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "GengduoViewController.h"
#import "WeirijiViewController.h"
#import "TuijianquanziViewController.h"
#import "JingPinViewController.h"
#import "ShezhiViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "AGViewDelegate.h"
#import "GerzxViewController.h"
#import "TonglcViewController.h"
#import "Share.h"
#import "ShareView.h"
@interface GengduoViewController ()

@end

@implementation GengduoViewController
@synthesize fenxiangArray;
- (void)dealloc
{
    [fenxiangArray release];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayTabBar" object:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden=YES;
//    self.fenxiangArray=[[[NSMutableArray alloc]initWithObjects:ShareTypeSMS,ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeSinaWeibo,ShareTypeTencentWeibo, nil] autorelease];
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
    UILabel * navigationLabel=[[UILabel alloc]initWithFrame:CGRectMake(100, KUIOS_7(11), (Screen_Width-200), 22)];
    navigationLabel.backgroundColor=[UIColor clearColor];
    //    navigationLabel.font=[UIFont systemFontOfSize:22];
    navigationLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:22];
    navigationLabel.textAlignment=NSTextAlignmentCenter;
    navigationLabel.textColor=[UIColor whiteColor];
    navigationLabel.text=@"更多";
    [navigation addSubview:navigationLabel];
    [navigationLabel release];
    float butX=35;
    float butY=40+(KUIOS_7(44))+15;
    if (ISIPAD) {
        butX=((Screen_Width-180)/4)/2+40;
        butY=(Screen_Width-44-46-20-240)/4+80;
    }
    for (int i=0; i<9; i++) {
        UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.tag=i;
        [button addTarget:self action:@selector(ButtonMenth:) forControlEvents:UIControlEventTouchUpInside];
        UIImage * butimage=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"005_%d",i+13] ofType:@"png"]];
        button.frame=CGRectMake(butX, butY, butimage.size.width/2, butimage.size.height/2);
        if (ISIPAD) {
            button.frame=CGRectMake(butX, butY, butimage.size.width*2/3, butimage.size.height*2/3)
            ;        }
        [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"005_%d",i+13] ofType:@"png"]] forState:UIControlStateNormal];
        [self.view addSubview:button];
        butX+=105;
        if (ISIPAD) {
            butX+=130;
        }
        if (i%3==2) {
            
            butX=35;
            butY+=30+65.5;
            if (ISIPAD) {
                butX=((Screen_Width-180)/4)/2+40;
                butY+=(Screen_Width-44-46-20-240)/4+30;
            }
        }
    }

}
- (void)ButtonMenth:(UIButton *)sender
{
    
    if (sender.tag==0) {
        MOBCLICK(kMob_Tools6);
        NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
        WeirijiViewController * weiriji=[[WeirijiViewController alloc]init];
        weiriji.typeString=@"0";
        weiriji.targetidString=[userDic valueForKey:@"uid"];
        [self.navigationController pushViewController:weiriji animated:YES];
        [weiriji release];
    }else if (sender.tag==1||sender.tag==5)
    {
        
        
        NSMutableDictionary * dataDictionary=[[NSMutableDictionary alloc]initWithCapacity:1];
        if (sender.tag==1) {
            MOBCLICK(kMob_MoreLove);
           [dataDictionary setValue:@"猜你喜欢" forKey:@"Title"];
           [dataDictionary setValue:@"http://apptest.mum360.com/web/home/index/youlike" forKey:@"aUrl1"];
            NSArray * typeArr=[[NSArray alloc]initWithObjects:@"圈子",@"好妈妈",nil];
            [dataDictionary setValue:typeArr forKey:@"typeArr"];
            [typeArr release];

        }else
        {
            MOBCLICK(kMob_MoreHot);
            [dataDictionary setValue:@"热门推荐" forKey:@"Title"];
            [dataDictionary setValue:@"http://apptest.mum360.com/web/home/index/hotcirclelist" forKey:@"aUrl1"];
            NSArray * typeArr=[[NSArray alloc]initWithObjects:@"圈子",@"话题",nil];
            [dataDictionary setValue:typeArr forKey:@"typeArr"];
            [typeArr release];
        }
        TuijianquanziViewController * tuijianquanzi=[[TuijianquanziViewController alloc]init];
        tuijianquanzi.oldDictionary=dataDictionary;
        [dataDictionary release];
        [self.navigationController pushViewController:tuijianquanzi animated:YES];
        [tuijianquanzi release];
    }
    else if (sender.tag==2)
    {
        MOBCLICK(kMob_MoreFriend);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hidesTabBar" object:nil];

       IBActionSheet * customIBAS = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"短信邀请",@"微信邀请",@"朋友圈邀请",@"新浪微博邀请",@"腾讯微博邀请",nil];
        [customIBAS showInView:self.view];
        [customIBAS release];
    }
    else if (sender.tag==3||sender.tag==4)
    {
        NSMutableDictionary * daDictionary=[[NSMutableDictionary alloc]initWithCapacity:1];
        if (sender.tag==3) {
            MOBCLICK(kMob_MoreAge);
            [daDictionary setValue:@"同龄宝宝" forKey:@"Title"];
            [daDictionary setObject:@"1" forKey:@"type"];
        }
        else
        {
            MOBCLICK(kMob_MoreCity);
            [daDictionary setValue:@"同城宝宝" forKey:@"Title"];
            [daDictionary setObject:@"2" forKey:@"type"];
        }
        TonglcViewController* vc = [[TonglcViewController alloc]init];
        vc.oldDictionary=daDictionary;
        [daDictionary release];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
    else if (sender.tag==6)
    {
        MOBCLICK(kMob_MoreRec);
        JingPinViewController* vc = [[JingPinViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
    else if (sender.tag==7)
    {
        MOBCLICK(kMob_MoreInfo);
        GerzxViewController * gerzxController=[[GerzxViewController alloc]init];
        [self.navigationController pushViewController:gerzxController animated:YES];
        [gerzxController release];
    }
    else
    {
        MOBCLICK(kMob_MoreSetting);
        ShezhiViewController* vc = [[ShezhiViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=5)
    {

    int fenxiangType=1;
    if (buttonIndex==0) {
        fenxiangType=19;
    }
    else if (buttonIndex==1)
    {
    fenxiangType=22;
    }else if (buttonIndex==2)
    {
    fenxiangType=23;
    }else if (buttonIndex==3)
    {
    fenxiangType=1;
    }
    else
    {

        fenxiangType=2;
    }
        
        if (ISIPAD&&fenxiangType==2) {
            if ([ShareSDK hasAuthorizedWithType:2]) {
                [Share SharecontentMenth:@"亲，我正在使用好妈妈客户端，里面有专家问答、宝宝每日成长提醒，还有好多妈妈在八卦，你也来试试吧！" shareImagePath:@"" biaoti:@"好妈妈" fenxiangleixing:fenxiangType];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayTabBar" object:nil];
            }
            else
            {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hidesTabBar" object:nil];
     
        ShareView * shareView=[[ShareView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, KUIOS_7(Screen_Height-20))];
        [shareView SharecontentMenth:@"亲，我正在使用好妈妈客户端，里面有专家问答、宝宝每日成长提醒，还有好多妈妈在八卦，你也来试试吧！" shareImagePath:@"" biaoti:@"好妈妈" fenxiangleixing:fenxiangType];
        [self.view addSubview:shareView];
        [shareView release];
            }
        }
        else
        {
        [Share SharecontentMenth:@"亲，我正在使用好妈妈客户端，里面有专家问答、宝宝每日成长提醒，还有好多妈妈在八卦，你也来试试吧！" shareImagePath:@"" biaoti:@"好妈妈" fenxiangleixing:fenxiangType];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayTabBar" object:nil];

        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayTabBar" object:nil];

    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
