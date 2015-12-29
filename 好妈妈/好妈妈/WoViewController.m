//
//  WoViewController.m
//  好妈妈
//
//  Created by iHope on 13-9-22.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "WoViewController.h"
#import "QuanZiChengYuan_ViewController.h"
#import "HuatiCell.h"
#import "SiXinViewController.h"
#import "HtqbViewController.h"
#import "WriqbViewController.h"
#import "TishiView.h"
#import "AsyncImageView.h"
#import "ShouCangViewController.h"
#import "TuijianquanziViewController.h"
#import "HaoYouViewController.h"
#import "contentViewController.h"
#import "MRZoomScrollView.h"
#import "ImageTextLabel.h"
#import "ChatListViewController.h"
#import "ZuiXinFaBu_ViewController.h"
#import "WeirijiViewController.h"
#import "BaobaoJintianViewController.h"
#import "PhotoSelectManager.h"
#import "GerzxViewController.h"
#import "GuiDang.h"
#import "NetImageView.h"

@interface WoViewController ()

@end

@implementation WoViewController
@synthesize tishiView;
@synthesize myScrollView;
@synthesize oldDictionary,imageScrollView;
@synthesize dataDictionary;
@synthesize dataArray;
@synthesize dArray;
@synthesize idString;
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"woxiaoxi" object:nil];
    [idString release];
    [dataArray release];
    [dArray release];
    [dataDictionary release];
    [tishiView release];
    [imageScrollView release];
    [oldDictionary release];
    [myScrollView release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(XiaoxiMenth) name:@"woxiaoxi" object:nil];
        
        // Custom initialization
    }
    return self;
}
- (void)XiaoxiMenth
{
    sixinBool=YES;
}
- (void)SiXinTiShiMEnth
{
    
    if ([[self.dataDictionary valueForKey:@"targetid"] intValue]==[[self.dataDictionary valueForKey:@"uid"] intValue]&&[[[NSUserDefaults standardUserDefaults] objectForKey:@"xiaoshishu"] intValue])
    {
        tishiLabel.hidden=NO;
        tishiLabel.text=[NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"xiaoshishu"] intValue]];
    }
    
}
- (void)viewDidLoad
{
    NSLog(@"%d",sixinBool);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidse) name:@"wohidse" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SiXinTiShiMEnth) name:@"wosixintishi" object:nil];
    
    
    [super viewDidLoad];
    self.dArray=[[[NSMutableArray alloc]initWithCapacity:1] autorelease];
    self.dataDictionary=[[[NSMutableDictionary alloc]initWithCapacity:1] autorelease];
    self.dataArray=[[[NSMutableArray alloc]initWithCapacity:1] autorelease];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden=YES;
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
    navigationLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, KUIOS_7(11), (Screen_Width-115), 22)];
    navigationLabel.backgroundColor=[UIColor clearColor];
    //    navigationLabel.font=[UIFont systemFontOfSize:22];
    navigationLabel.text=@"正在加载...";
    navigationLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:22];
    navigationLabel.textAlignment=NSTextAlignmentCenter;
    navigationLabel.textColor=[UIColor whiteColor];
    [navigation addSubview:navigationLabel];
    [navigationLabel release];
    
    
    
    
    if ([oldDictionary valueForKey:@"bool"]) {
        
        self.myScrollView.frame = CGRectMake(0, KUIOS_7(44), Screen_Width, Screen_Height-44-20);
        UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
        back.frame = CGRectMake(5, KUIOS_7(7), 51, 33);
        [back setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
        [back addTarget:self action:@selector(backup) forControlEvents:UIControlEventTouchUpInside];
        [navigation addSubview:back];
        
    }
    UIButton * rightBut=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBut.frame=CGRectMake(Screen_Width-50, (44-30.5)/2+(KUIOS_7(0)), 45, 30.5);
    [rightBut addTarget:self action:@selector(SixinMenth) forControlEvents:UIControlEventTouchUpInside];
    [rightBut setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"003_20" ofType:@"png"]] forState:UIControlStateNormal];
    [navigation addSubview:rightBut];
    
    tishiLabel=[[UILabel alloc]initWithFrame:CGRectMake(28, -5, 20, 20)];
    tishiLabel.backgroundColor=[UIColor redColor];
    [tishiLabel.layer setCornerRadius:10];
    tishiLabel.textAlignment=UITextAlignmentCenter;
    tishiLabel.textColor=[UIColor whiteColor];
    tishiLabel.font=[UIFont systemFontOfSize:16];
    [tishiLabel.layer setMasksToBounds:YES];
    tishiLabel.text=[NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"xiaoshishu"] intValue]];
    [rightBut addSubview:tishiLabel];
    [tishiLabel release];
    tishiLabel.hidden=YES;
    
    if ([[self.dataDictionary valueForKey:@"targetid"] intValue]==[[self.dataDictionary valueForKey:@"uid"] intValue]&&[[[NSUserDefaults standardUserDefaults] objectForKey:@"xiaoshishu"] intValue])
    {
        tishiLabel.hidden=NO;
    }
    
}
- (void)ASiMenth
{
    [self.dataDictionary setValue:@"http://apptest.mum360.com/web/home/index/userinfo" forKey:@"aUrl"];
    [self.dataDictionary setValue:@"yonghuliebiao" forKey:@"asiName"];
    NSLog(@"%@",self.dataDictionary);
    [self analyUrl:self.dataDictionary];
}
- (void)analyUrl:(NSMutableDictionary *)urlString
{
    [self.tishiView StartMenth];
    self.myScrollView.userInteractionEnabled=NO;
    NSURL * aUrl=[[NSURL alloc]initWithString:[urlString valueForKey:@"aUrl"]];
    analysis=[[AnalysisClass alloc]initWithIdentifier:aUrl DataName:nil ControllerName:[urlString valueForKey:@"asiName"] delegate:self];
    [aUrl release];
    [analysis PostMenth:urlString];
    
}
- (void)DataMenth:(NSDictionary *)asiDic
{
    self.idString=[asiDic valueForKey:@"uid"];
    if (self.myScrollView) {
        [self.myScrollView removeFromSuperview];
        self.myScrollView=nil;
    }
    if (self.myScrollView ==nil) {
        self.myScrollView=[[[UIScrollView alloc]init] autorelease];
        self.myScrollView.delegate=self;
        self.myScrollView.userInteractionEnabled=YES;
        self.myScrollView.backgroundColor=[UIColor clearColor];
        [self.view addSubview:self.myScrollView];
        self.tishiView=[TishiView tishiViewMenth];
        [self.view addSubview:self.tishiView];
        if ([oldDictionary valueForKey:@"bool"])
        {
            navigationLabel.text=[NSString stringWithFormat:@"%@的主页",[asiDic valueForKey:@"name"]];
            titles=[[NSString alloc]initWithString:[asiDic valueForKey:@"name"]];
            self.myScrollView.frame = CGRectMake(0, KUIOS_7(44), Screen_Width, Screen_Height-44-20);
            if ([[self.dataDictionary valueForKey:@"uid"] intValue]!=[[self.dataDictionary valueForKey:@"targetid"] intValue]) {
                
                
                guanzhuButton=[UIButton buttonWithType:UIButtonTypeCustom];
                guanzhuButton.frame=CGRectMake(Screen_Width-70,35, 45, 30);
                [guanzhuButton addTarget:self action:@selector(GuanzhuButtonMenth:) forControlEvents:UIControlEventTouchUpInside];
                if ([[asiDic valueForKey:@"flag"] intValue]==1) {
                    [guanzhuButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"已关注" ofType:@"png"]] forState:UIControlStateNormal];
                    guanzhuButton.tag=1;
                }
                else
                {
                    [guanzhuButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"关注" ofType:@"png"]] forState:UIControlStateNormal];
                    guanzhuButton.tag=0;
                }
                [self.myScrollView addSubview:guanzhuButton];
            }
            
        }
        else
        {
            navigationLabel.text=@"我的主页";
            self.myScrollView.frame = CGRectMake(0, KUIOS_7(44), Screen_Width, Screen_Height-44-49-20);
            if (ISIPAD) {
                self.myScrollView.frame = CGRectMake(0, KUIOS_7(44), Screen_Width, Screen_Height-44-65-20);
            }
            
        }
        
        
        if (_refreshHeaderView) {
            [_refreshHeaderView removeFromSuperview];
            _refreshHeaderView=nil;
        }
        if (_refreshHeaderView == nil) {
            _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0-myScrollView.bounds.size.height, myScrollView.frame.size.width, myScrollView.bounds.size.height)];
            _refreshHeaderView.delegate = self;
            [self.myScrollView addSubview:_refreshHeaderView];
        }
        [_refreshHeaderView refreshLastUpdatedDate];
        NSLog(@"%@", asiDic);
        NSDictionary * userDic=[[NSUserDefaults standardUserDefaults]valueForKey:@"logindata"];
        NSLog(@"%@",userDic);
        
        imageV = [[AsyncImageView alloc]initWithFrame:CGRectMake(10, 8, 75, 75)];
        
        //
        imageV.urlString=[asiDic valueForKey:@"icon"];
        NSLog(@"%@",[asiDic valueForKey:@"icon"]);
        imageV.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"聊天_3" ofType:@"png"]]];
        
        [self.myScrollView addSubview:imageV];
        if ([[asiDic valueForKey:@"badge"] intValue])
        {
            UIImageView * xunzhangImageView=[[UIImageView alloc]initWithFrame:CGRectMake(imageV.frame.size.width-15, imageV.frame.size.height-16.5, 21.5, 21.5)];
            if (ISIPAD) {
                xunzhangImageView.frame=CGRectMake(xunzhangImageView.frame.origin.x*1.4, xunzhangImageView.frame.origin.y*1.4, xunzhangImageView.frame.size.width*1.4, xunzhangImageView.frame.size.height*1.4);
            }
            xunzhangImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"标签_3" ofType:@"png"]];
            [imageV addSubview:xunzhangImageView];
            [xunzhangImageView release];
            
        }
        //妈妈和宝宝
        UILabel* label10  = [[UILabel alloc]initWithFrame:CGRectMake(imageV.frame.size.width+imageV.frame.origin.x+10, imageV.frame.origin.y+3, 200, 18)];
        if ([[asiDic valueForKey:@"name"] length]>9) {
            label10.font=[UIFont fontWithName:@"Helvetica-Bold" size:15];
        }
        else
        {
            label10.font=[UIFont fontWithName:@"Helvetica-Bold" size:16];
        }
        
        label10.text = [asiDic valueForKey:@"name"];
        label10.backgroundColor = [UIColor clearColor];
        [self.myScrollView addSubview:label10];
        [label10 release];
        
        UILabel* label11  = [[UILabel alloc]initWithFrame:CGRectMake(label10.frame.origin.x, label10.frame.origin.y+label10.frame.size.height+5, 300, 15)];
        label11.text =[asiDic valueForKey:@"status"];
        label11.textColor=[UIColor colorWithRed:147/255.0 green:191/255.0 blue:6/255.0 alpha:1.0];
        label11.font=[UIFont systemFontOfSize:12];
        label11.backgroundColor = [UIColor clearColor];
        [self.myScrollView addSubview:label11];
        [label11 release];
        if ([[userDic valueForKey:@"uid"] intValue]==[[asiDic valueForKey:@"uid"] intValue])
        {
            [imageV addTarget:self action:@selector(XiuGaiTouxiangMenth) forControlEvents:UIControlEventTouchUpInside];
            if ([[asiDic valueForKey:@"icon"] length]) {
                NSMutableDictionary * asiDic1=[[NSMutableDictionary alloc]initWithCapacity:1];
                NSDictionary * dic=[[NSUserDefaults standardUserDefaults]valueForKey:@"logindata"];
                if (![[dic valueForKey:@"icon"] isEqualToString:[asiDic valueForKey:@"icon"]])
                {
                    [asiDic1 addEntriesFromDictionary:dic];
                    [asiDic1 setValue:[asiDic valueForKey:@"icon"] forKey:@"icon"];
                    NSLog(@"%@ ",asiDic1);
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"logindata"];
                    [[NSUserDefaults standardUserDefaults] setValue:asiDic1 forKey:@"logindata"];
                    [asiDic1 release];
                    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"]);
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                }
            }
            UIButton * gerenzibutton=[UIButton buttonWithType:UIButtonTypeCustom];
            gerenzibutton.frame=CGRectMake(label10.frame.origin.x-5, label10.frame.origin.y-5, 200, 45);
            [gerenzibutton addTarget:self action:@selector(GetenMenth) forControlEvents:UIControlEventTouchUpInside];
            [self.myScrollView addSubview:gerenzibutton];
            if (ISIPAD) {
                gerenzibutton.frame=CGRectMake(gerenzibutton.frame.origin.x*1.4, gerenzibutton.frame.origin.y*1.4, gerenzibutton.frame.size.width*1.4, gerenzibutton.frame.size.height*1.4);
            }
        }
        UILabel* label12  = [[UILabel alloc]initWithFrame:CGRectMake(label11.frame.origin.x, label11.frame.origin.y+5+label11.frame.size.height, 50, 15)];
        label12.text = [NSString stringWithFormat:@"LV.%@",[asiDic valueForKey:@"level"]];
        label12.font=[UIFont systemFontOfSize:13];
        label12.backgroundColor = [UIColor clearColor];
        [self.myScrollView addSubview:label12];
        [label12 release];
        if (ISIPAD) {
            label12.frame=CGRectMake(label12.frame.origin.x*1.4, label12.frame.origin.y*1.4, label12.frame.size.width*1.4, label12.frame.size.height*1.4);
            label12.font=[UIFont systemFontOfSize:13*1.4];
        }
        CGSize sizeLabel12Text = [label12.text sizeWithFont:label12.font constrainedToSize:CGSizeMake(320, 50)];
        label12.frame = CGRectMake(label12.frame.origin.x, label12.frame.origin.y, sizeLabel12Text.width, sizeLabel12Text.height);
        
        UILabel* label13  = [[UILabel alloc]initWithFrame:CGRectMake(label12.frame.origin.x+5+label12.frame.size.width, label11.frame.origin.y+8+label11.frame.size.height, 50, 12)];
        label13.text = [NSString stringWithFormat:@"(%@)",[asiDic valueForKey:@"scorenum"]];
        label13.font=[UIFont systemFontOfSize:10];
        label13.backgroundColor = [UIColor clearColor];
        [self.myScrollView addSubview:label13];
        [label13 release];
        if (ISIPAD) {
            label13.frame=CGRectMake(label13.frame.origin.x, label13.frame.origin.y*1.4, label13.frame.size.width*1.4, label13.frame.size.height*1.4);
            label13.font=[UIFont systemFontOfSize:10*1.4];
        }
        UILabel* label14  = [[UILabel alloc]initWithFrame:CGRectMake(label13.frame.size.width+label13.frame.origin.x, label11.frame.origin.y+5+label11.frame.size.height, 50, 15)];
        label14.text = @"话题:";
        label14.font=[UIFont systemFontOfSize:13];
        
        label14.backgroundColor = [UIColor clearColor];
        [self.myScrollView addSubview:label14];
        [label14 release];
        if (ISIPAD) {
            label14.frame=CGRectMake(label14.frame.origin.x, label14.frame.origin.y*1.4, label14.frame.size.width*1.4, label14.frame.size.height*1.4);
            label14.font=[UIFont systemFontOfSize:13*1.4];
        }
        
        CGSize sizeLabel14Text = [label14.text sizeWithFont:label14.font constrainedToSize:CGSizeMake(320, 50)];
        label14.frame = CGRectMake(label14.frame.origin.x, label14.frame.origin.y, sizeLabel14Text.width, sizeLabel14Text.height);
        
        UILabel* label15  = [[UILabel alloc]initWithFrame:CGRectMake(label14.frame.size.width+label14.frame.origin.x, label11.frame.origin.y+5+label11.frame.size.height, 50, 15)];
        label15.text = [NSString stringWithFormat:@"(%@)",[asiDic valueForKey:@"sendtheme"]];
        label15.font=[UIFont systemFontOfSize:13];
        label15.textColor=[UIColor colorWithRed:107/255.0 green:6/255.0 blue:131/255.0 alpha:1.0];
        
        label15.backgroundColor = [UIColor clearColor];
        [self.myScrollView addSubview:label15];
        [label15 release];
        if (ISIPAD) {
            label15.frame=CGRectMake(label15.frame.origin.x, label15.frame.origin.y*1.4, label15.frame.size.width*1.4, label15.frame.size.height*1.4);
            label15.font=[UIFont systemFontOfSize:13*1.4];
        }
        
        
        UIImageView* image4 = [[UIImageView alloc]initWithFrame:CGRectMake(0, imageV.frame.origin.y+imageV.frame.size.height+10, Screen_Width, 42)];
        [image4 setImage:[UIImage imageNamed:@"003_19.png"]];
        image4.userInteractionEnabled = YES;
        [self.myScrollView addSubview:image4];
        [image4 release];
        if (ISIPAD) {
            image4.frame=CGRectMake(image4.frame.origin.x, image4.frame.origin.y*1.4, image4.frame.size.width, image4.frame.size.height*1.4);
        }
        
        
        if (ISIPAD) {
            imageV.frame=CGRectMake(imageV.frame.origin.x*1.4, imageV.frame.origin.y*1.4, imageV.frame.size.width*1.4, imageV.frame.size.height*1.4);
            
            imageV.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"默认105" ofType:@"png"]]];
            
            label10.frame=CGRectMake(label10.frame.origin.x*1.4, label10.frame.origin.y*1.4, label10.frame.size.width*1.4, label10.frame.size.height*1.4);
            if ([[asiDic valueForKey:@"name"] length]>9) {
                
                label10.font=[UIFont fontWithName:@"Helvetica-Bold" size:15];
                if (ISIPAD) {
                    label10.font=[UIFont fontWithName:@"Helvetica-Bold" size:15*1.4];
                    
                }
            }
            else
            {
                label10.font=[UIFont fontWithName:@"Helvetica-Bold" size:16];
                if (ISIPAD) {
                    label10.font=[UIFont fontWithName:@"Helvetica-Bold" size:15*1.4];
                    
                }
            }
            
            label11.frame=CGRectMake(label11.frame.origin.x*1.4, label11.frame.origin.y*1.4, label11.frame.size.width*1.4, label11.frame.size.height*1.4);
            label11.font=[UIFont systemFontOfSize:12*1.4];
            
            
            
            
        }
        
        for (int i=0; i<4; i++) {
            UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake((Screen_Width/4)*i, 0, (Screen_Width/4), 42);
            button.tag=i;
            [button addTarget:self action:@selector(ButtonMenth:) forControlEvents:UIControlEventTouchUpInside];
            [image4 addSubview:button];
            UILabel * butnumlabel=[[UILabel alloc]initWithFrame:CGRectMake((button.frame.size.width-60)/2, 2.5, 60, 15)];
            if (ISIPAD) {
                butnumlabel.frame=CGRectMake((button.frame.size.width-60*1.4)/2, 2.5*1.4, 60*1.4, 15*1.4);
            }
            if (i==0) {
                butnumlabel.text=[asiDic valueForKey:@"circlenum"];
                butnumlabel.textColor=[UIColor colorWithRed:182/255.0 green:24/255.0 blue:38/255.0 alpha:1.0];
            }
            else if (i==1)
            {
                butnumlabel.text=[asiDic valueForKey:@"attentions"];
                butnumlabel.textColor=[UIColor colorWithRed:1/255.0 green:103/255.0 blue:169/255.0 alpha:1.0];
            }
            else if (i==2)
            {
                butnumlabel.text=[asiDic valueForKey:@"fans"];
                butnumlabel.textColor=[UIColor colorWithRed:147/255.0 green:191/255.0 blue:6/255.0 alpha:1.0];
            }
            else
            {
                butnumlabel.text=[asiDic valueForKey:@"collection"];
                butnumlabel.textColor=[UIColor colorWithRed:107/255.0 green:6/255.0 blue:131/255.0 alpha:1.0];
            }
            
            butnumlabel.backgroundColor=[UIColor clearColor];
            butnumlabel.textAlignment=NSTextAlignmentCenter;
            butnumlabel.font=[UIFont systemFontOfSize:13];
            [button addSubview:butnumlabel];
            [butnumlabel release];
            UILabel * buttonlabel=[[UILabel alloc]initWithFrame:CGRectMake((button.frame.size.width-30)/2, 20, 30, 15)];
            if (ISIPAD) {
                buttonlabel.frame=CGRectMake((button.frame.size.width-30*1.4)/2, 20*1.4, 30*1.4, 15*1.4);
                
            }
            if (i==0) {
                buttonlabel.text=@"圈子";
            }
            else if (i==1)
            {
                buttonlabel.text=@"关注";
            }
            else if (i==2)
            {
                buttonlabel.text=@"粉丝";
            }
            else
            {
                buttonlabel.text=@"收藏";
            }
            
            buttonlabel.backgroundColor=[UIColor clearColor];
            buttonlabel.textAlignment=NSTextAlignmentCenter;
            buttonlabel.font=[UIFont systemFontOfSize:13];
            [button addSubview:buttonlabel];
            [buttonlabel release];
            if (ISIPAD) {
                button.frame=CGRectMake(button.frame.origin.x, button.frame.origin.y, button.frame.size.width, button.frame.size.height*1.4);
                buttonlabel.font=[UIFont systemFontOfSize:13*1.4];
                butnumlabel.font=[UIFont systemFontOfSize:13*1.4];
                
            }
        }
        CGRect aRect=CGRectMake(10,image4.frame.size.height+image4.frame.origin.y+5, 80, 15);
        
        if ([[asiDic valueForKey:@"todaynew"] length])
        {
            UILabel * baobaoLabel=[[UILabel alloc]initWithFrame:aRect];
            baobaoLabel.alpha=0.8;
            baobaoLabel.textColor=[UIColor blackColor];
            baobaoLabel.font=[UIFont systemFontOfSize:15];
            baobaoLabel.backgroundColor=[UIColor clearColor];
            baobaoLabel.text=@"宝宝今天";
            [self.myScrollView addSubview:baobaoLabel];
            [baobaoLabel release];
            
            UIImageView * xinImageView=[[UIImageView alloc]initWithFrame:CGRectMake(aRect.origin.x, aRect.origin.y+30, 16, 14)];
            xinImageView.image=[UIImage imageNamed:@"004_心.png"];
            [self.myScrollView addSubview:xinImageView];
            [xinImageView release];
            NSLog(@"%@",asiDic);
            UILabel * baobaojintianLabel=[[UILabel alloc]initWithFrame:CGRectMake(xinImageView.frame.size.width+xinImageView.frame.origin.x+5, aRect.origin.y+25.5, Screen_Width-40, 25)];
            //            baobaoJintianstring=[[NSString alloc]initWithFormat:@"%@",[asiDic valueForKey:@"day"]];
            
            baobaojintianLabel.userInteractionEnabled=YES;
            baobaojintianLabel.text=[asiDic valueForKey:@"status"];
            baobaojintianLabel.font=[UIFont systemFontOfSize:16];
            baobaojintianLabel.textColor=[UIColor grayColor];
            baobaojintianLabel.backgroundColor=[UIColor clearColor];
            [self.myScrollView addSubview:baobaojintianLabel];
            [baobaojintianLabel release];
            
            
            if (ISIPAD) {
                baobaoLabel.frame=CGRectMake(baobaoLabel.frame.origin.x*1.4, baobaoLabel.frame.origin.y, baobaoLabel.frame.size.width*1.4, baobaoLabel.frame.size.height*1.4);
                baobaoLabel.font=[UIFont systemFontOfSize:15*1.4];
                xinImageView.frame=CGRectMake(xinImageView.frame.origin.x*1.4, xinImageView.frame.origin.y, xinImageView.frame.size.width*1.4, xinImageView.frame.size.height*1.4);
                baobaojintianLabel.frame=CGRectMake(baobaojintianLabel.frame.origin.x*1.4, baobaojintianLabel.frame.origin.y, baobaojintianLabel.frame.size.width*1.4, baobaojintianLabel.frame.size.height*1.4);
            }
            UITapGestureRecognizer * tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BaobaobuMenht)];
            [baobaojintianLabel addGestureRecognizer:tapGesture];
            [tapGesture release];
            aRect=CGRectMake(aRect.origin.x, aRect.origin.y+55, aRect.size.width, aRect.size.height);
            if (ISIPAD) {
                aRect=CGRectMake(aRect.origin.x, aRect.origin.y+10, aRect.size.width, aRect.size.height);
                
            }
        }
        NSLog(@"%@",[asiDic valueForKey:@"todaynew"]);
        if ([[asiDic valueForKey:@"topics"] count]) {
            
            
            UILabel * weirijiLabel=[[UILabel alloc]initWithFrame:aRect];
            weirijiLabel.alpha=0.8;
            weirijiLabel.textColor=[UIColor blackColor];
            weirijiLabel.font=[UIFont systemFontOfSize:15];
            weirijiLabel.backgroundColor=[UIColor clearColor];
            
            weirijiLabel.text=[NSString stringWithFormat:@"微日记 (%@)",[asiDic valueForKey:@"topicnum"]];
            [self.myScrollView addSubview:weirijiLabel];
            [weirijiLabel release];
            
            UILabel * wrjqbLabel=[[UILabel alloc]initWithFrame:CGRectMake(Screen_Width-80, weirijiLabel.frame.origin.y, 75, 15)];
            wrjqbLabel.textColor=[UIColor blackColor];
            wrjqbLabel.userInteractionEnabled=YES;
            wrjqbLabel.text=@"查看全部";
            wrjqbLabel.alpha=0.8;
            wrjqbLabel.font=[UIFont systemFontOfSize:15];
            wrjqbLabel.backgroundColor=[UIColor clearColor];
            [self.myScrollView addSubview:wrjqbLabel];
            [wrjqbLabel release];
            UIImageView * wrijImageView=[[UIImageView alloc]initWithFrame:CGRectMake(65, 0.75, 9, 12)];
            wrijImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"003_26" ofType:@"png"]];
            wrijImageView.userInteractionEnabled=YES;
            [wrjqbLabel addSubview:wrijImageView];
            [wrijImageView release];
            if (ISIPAD) {
                weirijiLabel.frame=CGRectMake(weirijiLabel.frame.origin.x*1.4, weirijiLabel.frame.origin.y, weirijiLabel.frame.size.width*1.4, weirijiLabel.frame.size.height*1.4);
                weirijiLabel.font=[UIFont systemFontOfSize:15*1.4];
                wrjqbLabel.frame=CGRectMake(wrjqbLabel.frame.origin.x-35, wrjqbLabel.frame.origin.y, wrjqbLabel.frame.size.width*1.4, wrjqbLabel.frame.size.height*1.4);
                wrjqbLabel.font=[UIFont systemFontOfSize:15*1.4];
                wrijImageView.frame=CGRectMake(wrijImageView.frame.origin.x*1.4, wrijImageView.frame.origin.y, wrijImageView.frame.size.width*1.4, wrijImageView.frame.size.height*1.4);
            }
            
            UITapGestureRecognizer * tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(WrjQubuMenht)];
            [wrjqbLabel addGestureRecognizer:tapGesture];
            [tapGesture release];
            int topcount=([[asiDic valueForKey:@"topics"] count]>4)?4:[[asiDic valueForKey:@"topics"] count];
            for (int i=0; i<topcount; i++) {
                
                NetImageView * _bigImageView = [[NetImageView alloc]initWithFrame:CGRectMake(15+76.25*i, wrjqbLabel.frame.origin.y+wrjqbLabel.frame.size.height+10, 61.25, 65)];
                if (ISIPAD) {
                    _bigImageView.frame=CGRectMake(_bigImageView.frame.origin.x*1.4, _bigImageView.frame.origin.y, _bigImageView.frame.size.width*1.4, _bigImageView.frame.size.height*1.4);
                }
                _bigImageView.mImageType = TImageType_CutFill;
                _bigImageView.mImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"001_35" ofType:@"png"]];
                [_bigImageView GetImageByStr:[[[asiDic valueForKey:@"topics"] objectAtIndex:i] valueForKey:@"image"]];
                [self.myScrollView addSubview:_bigImageView];
                [_bigImageView release];
                
                //                AsyncImageView * asyncImageView=[[AsyncImageView alloc]initWithFrame:CGRectMake(15+76.25*i, wrjqbLabel.frame.origin.y+wrjqbLabel.frame.size.height+10, 61.25, 65)];
                //
                //                asyncImageView.urlString=[[[asiDic valueForKey:@"topics"] objectAtIndex:i] valueForKey:@"image"];
                //                [asyncImageView addTarget:self action:@selector(FdImageView:) forControlEvents:UIControlEventTouchUpInside];
                //                [self.myScrollView addSubview:asyncImageView];
                //                [asyncImageView release];
                UIButton * newimageButon=[UIButton buttonWithType:UIButtonTypeCustom];
                newimageButon.frame=_bigImageView.bounds;
                [newimageButon addTarget:self action:@selector(NetImageViewButton:) forControlEvents:UIControlEventTouchUpInside];
                [_bigImageView addSubview:newimageButon];
                AsyncImageView * asyncImageView=[[AsyncImageView alloc]initWithFrame:CGRectZero];
                asyncImageView.urlString=[[[asiDic valueForKey:@"topics"] objectAtIndex:i] valueForKey:@"image"];
                [newimageButon addSubview:asyncImageView];
                [asyncImageView release];
                
            }
            aRect=CGRectMake(aRect.origin.x, aRect.origin.y+85, aRect.size.width, aRect.size.height);
            if (ISIPAD) {
                aRect=CGRectMake(aRect.origin.x, aRect.origin.y+35, aRect.size.width, aRect.size.height);
            }
        }
        if ([[asiDic valueForKey:@"themes"]count]) {
            [self.dataArray addObjectsFromArray:[asiDic valueForKey:@"themes"]];
            NSLog(@"%@",self.dataArray);
            UILabel * htLabel=[[UILabel alloc]initWithFrame:CGRectMake(aRect.origin.x, aRect.origin.y+aRect.size.height, 160, 15)];
            htLabel.textColor=[UIColor blackColor];
            htLabel.userInteractionEnabled=YES;
            htLabel.text= [NSString stringWithFormat:@"话题 (%@)",[asiDic valueForKey:@"sendtheme"]];
            htLabel.alpha=0.8;
            htLabel.font=[UIFont systemFontOfSize:15];
            htLabel.backgroundColor=[UIColor clearColor];
            [self.myScrollView addSubview:htLabel];
            [htLabel release];
            UILabel * htqbLabel=[[UILabel alloc]initWithFrame:CGRectMake(Screen_Width-80, htLabel.frame.origin.y, 75, 15)];
            htqbLabel.textColor=[UIColor blackColor];
            htqbLabel.userInteractionEnabled=YES;
            htqbLabel.text=@"查看全部";
            htqbLabel.alpha=0.8;
            htqbLabel.font=[UIFont systemFontOfSize:15];
            htqbLabel.backgroundColor=[UIColor clearColor];
            [self.myScrollView addSubview:htqbLabel];
            [htqbLabel release];
            UIImageView *  wrijImageView=[[UIImageView alloc]initWithFrame:CGRectMake(65, 0.75, 9, 12)];
            wrijImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"003_26" ofType:@"png"]];
            wrijImageView.userInteractionEnabled=YES;
            [htqbLabel addSubview:wrijImageView];
            [wrijImageView release];
            if (ISIPAD) {
                htLabel.frame=CGRectMake(htLabel.frame.origin.x*1.4, htLabel.frame.origin.y, htLabel.frame.size.width*1.4, htLabel.frame.size.height*1.4);
                htLabel.font=[UIFont systemFontOfSize:15*1.4];
                htqbLabel.frame=CGRectMake(htqbLabel.frame.origin.x-35, htqbLabel.frame.origin.y, htqbLabel.frame.size.width*1.4, htqbLabel.frame.size.height*1.4);
                htqbLabel.font=[UIFont systemFontOfSize:15*1.4];
                wrijImageView.frame=CGRectMake(wrijImageView.frame.origin.x*1.4, wrijImageView.frame.origin.y, wrijImageView.frame.size.width*1.4, wrijImageView.frame.size.height*1.4);
            }
            
            UITapGestureRecognizer * tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(HtQubuMenht)];
            [htqbLabel addGestureRecognizer:tapGesture];
            [tapGesture release];
            myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, htqbLabel.frame.origin.y+htqbLabel.frame.size.height+10, self.myScrollView.frame.size.width, self.myScrollView.frame.size.height-htqbLabel.frame.origin.y+htqbLabel.frame.size.height+10)];
            myTableView.backgroundColor=[UIColor clearColor];
            myTableView.delegate=self;
            myTableView.dataSource=self;
            myTableView.tag=0;
            myTableView.scrollEnabled=NO;
            myTableView.rowHeight=54;
            myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
            [self.myScrollView addSubview:myTableView];
            [myTableView release];
            if (ISIPAD) {
                myTableView.rowHeight=54*1.4;
                aRect=CGRectMake(aRect.origin.x, aRect.origin.y+(self.dataArray.count*54*1.4)+45, aRect.size.width, aRect.size.height);
                
            }
            else
            {
                aRect=CGRectMake(aRect.origin.x, aRect.origin.y+(self.dataArray.count*54)+35, aRect.size.width, aRect.size.height);
            }
            
            
        }
        if ([[asiDic valueForKey:@"comment"] count]) {
            [self.dArray addObjectsFromArray:[asiDic valueForKey:@"comment"]];
            UILabel * htLabel1=[[UILabel alloc]initWithFrame:CGRectMake(aRect.origin.x, aRect.origin.y+10, 180, 15)];
            htLabel1.textColor=[UIColor blackColor];
            htLabel1.userInteractionEnabled=YES;
            htLabel1.text=[NSString stringWithFormat:@"回复 (%@)",[asiDic valueForKey:@"replaytheme"]];
            htLabel1.alpha=0.8;
            htLabel1.font=[UIFont systemFontOfSize:15];
            htLabel1.backgroundColor=[UIColor clearColor];
            [self.myScrollView addSubview:htLabel1];
            [htLabel1 release];
            UILabel * htqbLabel=[[UILabel alloc]initWithFrame:CGRectMake(Screen_Width-80, htLabel1.frame.origin.y, 75, 15)];
            htqbLabel.textColor=[UIColor blackColor];
            htqbLabel.userInteractionEnabled=YES;
            htqbLabel.text=@"查看全部";
            htqbLabel.alpha=0.8;
            htqbLabel.font=[UIFont systemFontOfSize:15];
            htqbLabel.backgroundColor=[UIColor clearColor];
            [self.myScrollView addSubview:htqbLabel];
            [htqbLabel release];
            UIImageView *  wrijImageView=[[UIImageView alloc]initWithFrame:CGRectMake(65, 0.75, 9, 12)];
            wrijImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"003_26" ofType:@"png"]];
            wrijImageView.userInteractionEnabled=YES;
            [htqbLabel addSubview:wrijImageView];
            [wrijImageView release];
            if (ISIPAD) {
                htLabel1.frame=CGRectMake(htLabel1.frame.origin.x*1.4, htLabel1.frame.origin.y, htLabel1.frame.size.width*1.4, htLabel1.frame.size.height*1.4);
                htLabel1.font=[UIFont systemFontOfSize:15*1.4];
                htqbLabel.frame=CGRectMake(htqbLabel.frame.origin.x-35, htqbLabel.frame.origin.y, htqbLabel.frame.size.width*1.4, htqbLabel.frame.size.height*1.4);
                htqbLabel.font=[UIFont systemFontOfSize:15*1.4];
                wrijImageView.frame=CGRectMake(wrijImageView.frame.origin.x*1.4, wrijImageView.frame.origin.y, wrijImageView.frame.size.width*1.4, wrijImageView.frame.size.height*1.4);
            }
            UITapGestureRecognizer * tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(HuiFuMenht)];
            [htqbLabel addGestureRecognizer:tapGesture];
            [tapGesture release];
            dTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, htLabel1.frame.size.height+htLabel1.frame.origin.y+10, Screen_Width,54*self.dArray.count)];
            dTableView.backgroundColor=[UIColor clearColor];
            dTableView.tag=1;
            dTableView.delegate=self;
            dTableView.dataSource=self;
            dTableView.scrollEnabled=NO;
            dTableView.rowHeight=54;
            dTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
            [self.myScrollView addSubview:dTableView];
            [dTableView release];
            if (ISIPAD) {
                dTableView.rowHeight=54*1.4;
                dTableView.frame=CGRectMake(0, htLabel1.frame.size.height+htLabel1.frame.origin.y+10, Screen_Width,54*1.4*self.dArray.count);
                
            }
            
            
            
            
        }
    }
    //    [self performSelector:@selector(loadMenth) withObject:self afterDelay:0.1];
}
- (void)NetImageViewButton:(UIButton *)sender
{
    if ([[sender subviews] count]) {
        NetImageView * netImageView=(NetImageView *)[sender superview];
        AsyncImageView * ayImageView=[[sender subviews] objectAtIndex:0];
        [self FdImageView:ayImageView :netImageView.frame];
    }
}
- (void)Asihttp:(AnalysisClass *)asi DataArray:(NSMutableDictionary *)array
{
    [self.tishiView StopMenth];
    self.myScrollView.userInteractionEnabled=YES;
    
    NSLog(@"array  %@",[array valueForKey:asi.ControllerName]);
    NSMutableDictionary * asiDic=[array valueForKey:asi.ControllerName];
    if ([asi.ControllerName isEqualToString:@"yonghuliebiao"]) {
        //
        if ([array valueForKey:asi.ControllerName]) {
            [GuiDang ChuCunMenth:[array valueForKey:asi.ControllerName] LJstring:@"wo"];
            [self DataMenth:asiDic];
            NSLog(@"%@",[array valueForKey:asi.ControllerName]);
            
        }
        else
        {
            [self DataMenth:[GuiDang DuquMenth1:@"wo"]];
            
        }
        
        
        
    }
    else if ([asi.ControllerName isEqualToString:@"xiugai"])
    {
        if ([[[array valueForKey:asi.ControllerName] valueForKey:@"code"] intValue]) {
            [self.dArray removeAllObjects];
            [self.dataArray removeAllObjects];
            [self ASiMenth];
        }
    }
    else
    {
        if ([[asiDic valueForKey:@"code"] intValue]) {
            if ([asi.ControllerName isEqualToString:@"guanzhu"]) {
                [guanzhuButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"已关注" ofType:@"png"]] forState:UIControlStateNormal];
            }
            else
            {
                [guanzhuButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"关注" ofType:@"png"]] forState:UIControlStateNormal];
            }
        }
        NSLog(@"asiDic  %@",asiDic);
    }
    [asi release];
    analysis=nil;
}
- (void)GetenMenth
{
    GerzxViewController * gerzxController=[[GerzxViewController alloc]init];
    [self.navigationController pushViewController:gerzxController animated:YES];
    [gerzxController release];
    
}
- (void)XiuGaiTouxiangMenth
{
    UIActionSheet * actionSheet=[[UIActionSheet alloc]initWithTitle:@"请选择照相来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"选取", nil];
    actionSheet.tag=3;
    [actionSheet showInView:self.view];
    [actionSheet release];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==3) {
        if (buttonIndex!=2) {
            PhotoSelectManager * mPhotoManager = [[PhotoSelectManager alloc] init];
            mPhotoManager.mRootCtrl = self;
            mPhotoManager.delegate = self;
            mPhotoManager.mbEdit = YES;
            mPhotoManager.OnPhotoSelect = @selector(OnPhotoSelect:);
            if (buttonIndex) {
                [mPhotoManager TakePhoto:NO];
            }
            else
            {
                [mPhotoManager TakePhoto:YES];
            }
            
        }
        
    }
    
}
- (void)OnPhotoSelect:(PhotoSelectManager *)sender {
    controllerBool=YES;
    NSMutableDictionary * asiDic=[[NSMutableDictionary alloc]initWithCapacity:1];
    [asiDic setValue:[sender mLocalPath] forKey:@"file"];
    NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
    NSLog(@"%@",userDic);
    [asiDic setValue:[userDic valueForKey:@"name"] forKey:@"name"];
    [asiDic setValue:[userDic valueForKey:@"sign"] forKey:@"sign"];
    [asiDic setValue:[userDic valueForKey:@"city"] forKey:@"city"];
    [asiDic setValue:[userDic valueForKey:@"type"] forKey:@"type"];
    [asiDic setValue:[userDic valueForKey:@"babysex"] forKey:@"babysex"];
    [asiDic setValue:[userDic valueForKey:@"uid"] forKey:@"uid"];
    [asiDic setValue:[userDic valueForKey:@"token"] forKey:@"token"];
    imageV.image=[UIImage imageWithContentsOfFile:[sender mLocalPath]];
    [asiDic setValue:@"http://apptest.mum360.com/web/home/index/updateuserinfo" forKey:@"aUrl"];
    [asiDic setValue:@"xiugai" forKey:@"asiName"];
    [self analyUrl:asiDic];
    [asiDic release];
}
- (void)HuiFuMenht
{
    controllerBool=YES;
    NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
    NSMutableDictionary * Dictionary=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[userDic valueForKey:@"uid"],@"uid",[userDic valueForKey:@"token"],@"token",self.idString,@"targetid",@"15",@"limit",@"1",@"page",@"1",@"type", nil];
    [Dictionary setValue:@"回复" forKey:@"nvTitle"];
    HtqbViewController * htqbController=[[HtqbViewController alloc]init];
    htqbController.oldDictionary=Dictionary;
    [Dictionary release];
    [self.navigationController pushViewController:htqbController animated:YES];
    [htqbController release];
}
- (void)BaobaobuMenht
{
    controllerBool=YES;
    NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
    //    NSLog(@"baobaoJintianstring  %@  %@",baobaoJintianstring,userDic);
    
    BaobaoJintianViewController * baobaojiantin=[[BaobaoJintianViewController alloc]init];
    baobaojiantin.webViewString=[NSString stringWithFormat:@"http://apptest.mum360.com/web/home/index/todaynew?uid=%@&token=%@&type=%@",[userDic valueForKey:@"uid"],[userDic valueForKey:@"token"],[userDic valueForKey:@"type"]];
    NSLog(@"%@",baobaojiantin.webViewString);
    [self.navigationController pushViewController:baobaojiantin animated:YES];
    [baobaojiantin release];
    
}
- (void)GuanzhuButtonMenth:(UIButton *)sender
{
    NSLog(@"%@",self.dataDictionary);
    if (sender.tag) {
        UIAlertView * alertview=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"取消关注将扣除5个积分，您确定吗？" delegate:self cancelButtonTitle:@"取 消" otherButtonTitles:@"确定", nil];
        [alertview show];
        [alertview release];
        
    }
    else
    {
        
        [self.dataDictionary setValue:@"guanzhu" forKey:@"asiName"];
        
        [self.dataDictionary setValue:@"http://apptest.mum360.com/web/home/index/addfriend" forKey:@"aUrl"];
        [self analyUrl:self.dataDictionary];
        
    }
    
    
    //    NSLog(@"%d",sender);
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        [self.dataDictionary setValue:@"quxiaoguanzhu" forKey:@"asiName"];
        
        [self.dataDictionary setValue:@"http://apptest.mum360.com/web/home/index/deletefriend" forKey:@"aUrl"];
        [self analyUrl:self.dataDictionary];
        
    }
}
- (void)FdImageView:(AsyncImageView *)sender :(CGRect )aRect
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hidesTabBar" object:nil];
    
    MRZoomScrollView * _zoomScrollView = [[MRZoomScrollView alloc]initWithFrame:aRect viewImage:sender.image heti:self.myScrollView.contentOffset.y];
    _zoomScrollView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:_zoomScrollView];
    [_zoomScrollView release];
    
}
- (void)hidse
{
    if ([oldDictionary valueForKey:@"bool"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hidesTabBar" object:nil];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    
    NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
    NSMutableDictionary * Dictionary=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[userDic valueForKey:@"uid"],@"uid",[userDic valueForKey:@"token"],@"token",[userDic valueForKey:@"uid"],@"targetid", nil];
    if ([[self.dataDictionary valueForKey:@"targetid"] intValue]==[[userDic valueForKey:@"uid"] intValue]&&[[[NSUserDefaults standardUserDefaults] objectForKey:@"xiaoshishu"] intValue])
    {
        tishiLabel.hidden=NO;
        tishiLabel.text=[NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"xiaoshishu"] intValue]];
    }
    [self.dataDictionary addEntriesFromDictionary:Dictionary];
    [Dictionary release];
    self.tishiView=[TishiView tishiViewMenth];
    [self.view addSubview:self.tishiView];
    if ([oldDictionary valueForKey:@"bool"])
    {
        [self.dataDictionary setValue:[self.oldDictionary valueForKey:@"id"] forKey:@"targetid"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hidesTabBar" object:nil];
    }
    if (!controllerBool) {
        
        [self.dArray removeAllObjects];
        [self.dataArray removeAllObjects];
        [self ASiMenth];
    }
    controllerBool=NO;
}
- (void)FanhuiqingziuMenth
{
    [self.dArray removeAllObjects];
    [self.dataArray removeAllObjects];
    [self ASiMenth];
}
- (void)viewWillDisappear:(BOOL)animated
{
    if (analysis) {
        [analysis CancelMenthrequst];
        analysis=nil;
    }
    if ([oldDictionary valueForKey:@"bool"]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayTabBar" object:nil];
    }
}
- (void)backup
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (self.dataArray.count) {
        if (ISIPAD) {
            [self.myScrollView setContentSize:CGSizeMake(self.myScrollView.frame.size.width, myTableView.frame.origin.y+self.dataArray.count*54*1.4)];
        }
        else
        {
            [self.myScrollView setContentSize:CGSizeMake(self.myScrollView.frame.size.width, myTableView.frame.origin.y+self.dataArray.count*54)];
            
        }
        myTableView.frame=CGRectMake(0, myTableView.frame.origin.y, self.view.bounds.size.width, self.myScrollView.contentSize.height);
        
    }
    if (self.dArray.count) {
        if (ISIPAD) {
            [self.myScrollView setContentSize:CGSizeMake(self.myScrollView.frame.size.width, dTableView.frame.origin.y+54*1.4*self.dArray.count)];
            
        }
        else
        {
            [self.myScrollView setContentSize:CGSizeMake(self.myScrollView.frame.size.width, dTableView.frame.origin.y+54*self.dArray.count)];
            
        }
        
    }
    
    if (tableView.tag) {
        
        return self.dArray.count;
    }
    
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellString=@"fier";
    HuatiCell * cell=[tableView dequeueReusableCellWithIdentifier:cellString];
    if (cell==nil) {
        cell=[[[HuatiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString] autorelease];
    }
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (tableView.tag) {
        if (self.dArray.count>indexPath.row) {
            
            
            [cell.titleLabel LoadContent:[[self.dArray objectAtIndex:indexPath.row] valueForKey:@"content"]];
            cell.titleLabel.frame = CGRectMake(5, 5, 250, 20);
            
            NSLog(@"dArray  dArray  %@",[self.dArray objectAtIndex:indexPath.row ]);
            cell.timeLabel.text=[[self.dArray objectAtIndex:indexPath.row] valueForKey:@"time"];
            cell.qzNameLabel.text=[[self.dArray objectAtIndex:indexPath.row] valueForKey:@"cname"];
            cell.qzNameLabel.frame=CGRectMake(cell.qzNameLabel.frame.origin.x, cell.qzNameLabel.frame.origin.y, 180, cell.qzNameLabel.frame.size.height);
            cell.mainImageView.tag=indexPath.row;
            if ([[[self.dArray objectAtIndex:indexPath.row] valueForKey:@"image"] length]) {
                
                
                cell.mainImageView.urlString=[[self.dArray objectAtIndex:indexPath.row] valueForKey:@"image"];
            }
            else
            {
                cell.imageView.image=[UIImage imageNamed:@"默认.png"];
            }
            cell.mainImageView.opaque=NO;
            [cell.mainImageView addTarget:self action:@selector(MainImageMenth:) forControlEvents:UIControlEventTouchUpInside];
            cell.xingImageView.hidden=YES;
            cell.pinglunImageView.hidden=YES;
        }
    }
    else
    {
        if (self.dataArray.count>indexPath.row) {
            
            NSLog(@"%@",[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"title"]);
            
            cell.titleLabel.hangshu=YES;
            [cell.titleLabel LoadContent:[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"title"]];
            cell.titleLabel.frame = CGRectMake(5, 5, 250, 20);
            
            cell.timeLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"time"];
            cell.qzNameLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"cname"];
            cell.mainImageView.tag=indexPath.row;
            
            if ([[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"image"] length]) {
                
                cell.mainImageView.urlString=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"image"];
            }
            else
            {
                cell.imageView.image=[UIImage imageNamed:@"默认.png"];
            }
            cell.mainImageView.opaque=YES;
            [cell.mainImageView addTarget:self action:@selector(MainImageMenth:) forControlEvents:UIControlEventTouchUpInside];
            cell.xingLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"approval"];
            cell.pinglunLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"comment"];
        }
    }
    return cell;
}
- (void)MainImageMenth:(AsyncImageView *)sender
{
    controllerBool=YES;
    ZuiXinFaBu_ViewController* faBuVC = [[ZuiXinFaBu_ViewController alloc]init];
    if (sender.opaque) {
        faBuVC.oldDictionary=[self.dataArray objectAtIndex:sender.tag];
    }
    else
    {
        faBuVC.oldDictionary=[self.dArray objectAtIndex:sender.tag];
    }
    [self.navigationController pushViewController:faBuVC animated:YES];
    [faBuVC release];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    controllerBool=YES;
    contentViewController *ctrl = [[contentViewController alloc]init];
    if (tableView.tag) {
        ctrl.contentID = self.dArray[indexPath.row][@"tid"];
        
    }
    else
    {
        ctrl.contentID = self.dataArray[indexPath.row][@"id"];
    }
    
    [self.navigationController pushViewController:ctrl animated:YES];
    [ctrl release];
}
- (void)SixinMenth
{
    NSLog(@"oldDictionary  %@",self.oldDictionary);
    controllerBool=YES;
    NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
    
    if ([[self.oldDictionary valueForKey:@"id"] intValue]!=[[userDic valueForKey:@"uid"] intValue]&&self.oldDictionary)
    {
        NSMutableDictionary * Dictionary=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[userDic valueForKey:@"uid"],@"uid",[userDic valueForKey:@"token"],@"token",[self.oldDictionary valueForKey:@"id"],@"targetid",nil];
        ChatListViewController * siXinController=[[ChatListViewController alloc]init];
        siXinController.oldDictionary=Dictionary;
        [self.navigationController pushViewController:siXinController animated:YES];
        [siXinController release];
        [Dictionary release];
        
    }
    else
    {
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"xiaoshishu"] intValue]) {
            tishiLabel.hidden=YES;
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"xiaoshishu"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        SiXinViewController * sixinController=[[SiXinViewController alloc]init];
        [self.navigationController pushViewController:sixinController animated:YES];
        [sixinController release];
    }
}
- (void)WrjQubuMenht
{
    
    controllerBool=YES;
    WeirijiViewController * weiriji=[[WeirijiViewController alloc]init];
    weiriji.typeString=@"1";
    weiriji.targetidString=self.idString;
    [self.navigationController pushViewController:weiriji animated:YES];
    [weiriji release];
}
- (void)HtQubuMenht
{
    controllerBool=YES;
    NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
    NSMutableDictionary * Dictionary=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[userDic valueForKey:@"uid"],@"uid",[userDic valueForKey:@"token"],@"token",self.idString,@"targetid",@"15",@"limit",@"1",@"page",@"0",@"type", nil];
    [Dictionary setValue:@"话题" forKey:@"nvTitle"];
    HtqbViewController * htqbController=[[HtqbViewController alloc]init];
    htqbController.oldDictionary=Dictionary;
    [Dictionary release];
    [self.navigationController pushViewController:htqbController animated:YES];
    [htqbController release];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)loadMenth
{
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:myScrollView];
}
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    [self.dataArray removeAllObjects];
    [self.dArray removeAllObjects];
    [self ASiMenth];
	[self performSelector:@selector(loadMenth) withObject:self afterDelay:1];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
}


- (void)ButtonMenth:(UIButton *)sender
{
    NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
    controllerBool=YES;
    if (sender.tag==3) {
        
        NSMutableDictionary * Dictionary=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[userDic valueForKey:@"uid"],@"uid",[userDic valueForKey:@"token"],@"token",self.idString,@"targetid",@"15",@"limit",@"1",@"page", nil];
        ShouCangViewController * shoucanController=[[ShouCangViewController alloc]init];
        shoucanController.oldDictionary=Dictionary;
        [Dictionary release];
        [self.navigationController pushViewController:shoucanController animated:YES];
        [shoucanController release];
    }
    else if (sender.tag==0)
    {
        NSLog(@"%@",self.idString);
        NSMutableDictionary * dataDictionary1=[[NSMutableDictionary alloc]initWithCapacity:1];
        
        [dataDictionary1 setValue:@"圈子" forKey:@"Title"];
        [dataDictionary1 setValue:@"http://apptest.mum360.com/web/home/index/usercirclelist" forKey:@"aUrl1"];
        [dataDictionary1 setValue:@"YES" forKey:@"bool"];
        [dataDictionary1 setValue:self.idString forKey:@"targetid"];
        TuijianquanziViewController * tuijianquanzi=[[TuijianquanziViewController alloc]init];
        tuijianquanzi.oldDictionary=dataDictionary1;
        [dataDictionary1 release];
        [self.navigationController pushViewController:tuijianquanzi animated:YES];
        [tuijianquanzi release];
    }
    else
    {
        
        NSMutableDictionary * Dictionary=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[userDic valueForKey:@"uid"],@"uid",[userDic valueForKey:@"token"],@"token",self.idString,@"targetid",@"15",@"limit",@"http://apptest.mum360.com/web/home/index/friendslist",@"aUrl1",nil];
        if (sender.tag==1) {
            [Dictionary setValue:@"2" forKey:@"type"];
            
            if (titles.length) {
                
                
                [Dictionary setValue:[NSString stringWithFormat:@"%@关注",titles] forKey:@"title"];
            }
            else
            {
                [Dictionary setValue:[NSString stringWithFormat:@"我的关注"] forKey:@"title"];
                
            }
        }
        else
        {
            if (titles.length) {
                
                [Dictionary setValue:[NSString stringWithFormat:@"%@粉丝",titles] forKey:@"title"];
            }
            else
            {
                [Dictionary setValue:[NSString stringWithFormat:@"我的粉丝"] forKey:@"title"];
                
            }
            [Dictionary setValue:@"1" forKey:@"type"];
        }
        HaoYouViewController * haoyouController=[[HaoYouViewController alloc]init];
        haoyouController.oldDictionary=Dictionary;
        [Dictionary release];
        [self.navigationController pushViewController:haoyouController animated:YES];
        [haoyouController release];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
