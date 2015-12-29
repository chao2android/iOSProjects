//
//  ZuiXinFaBu_ViewController.m
//  好妈妈
//
//  Created by liuguozhu on 17/9/13.
//  Copyright (c) 2013 1510Cloud. All rights reserved.
//

#import "ZuiXinFaBu_ViewController.h"
#import "QuanZiChengYuan_ViewController.h"
#import "FabuViewController.h"
#import "AsyncImageView.h"
#import "WoViewController.h"
#import "contentViewController.h"
#import "ImageTextLabel.h"
#import "newCell.h"
#import "QuanmeituViewController.h"
@interface ZuiXinFaBu_ViewController ()

@end

@implementation ZuiXinFaBu_ViewController
@synthesize mainScrollView;
@synthesize myTableview;
@synthesize oldDictionary;
@synthesize dataArray;
@synthesize asiInfoDictionary;
@synthesize tishiView;
@synthesize biaoqianImageView,quanziDintionary;
@synthesize allDataArray;
@synthesize navigationButton;
@synthesize tiaojianImageView;
- (void)dealloc
{
    [tiaojianImageView release];
    [navigationButton release];
    [allDataArray release];
    [quanziDintionary release];
    [biaoqianImageView release];
    [tishiView release];
    [asiInfoDictionary release];
    [dataArray release];
    [oldDictionary release];
    [myTableview release];
    [mainScrollView release];
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
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayTabBar" object:nil];

    [self.asiInfoDictionary setValue:[NSString stringWithFormat:@"%d",isJoin] forKey:@"flag"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadQuanziMenht" object:self.asiInfoDictionary];
    if (analysis) {
    [analysis CancelMenthrequst];
    }
}
- (void)TiaojianButtonMenth:(UIButton *)sender
{
    NSLog(@"%@",[self.tiaojianImageView subviews]);
    if (sender.tag-1==0) {
        [navigationButton setTitle:@"最新发布" forState:UIControlStateNormal];
    }
    else if (sender.tag-1==1)
    {
        [navigationButton setTitle:@"最后回复" forState:UIControlStateNormal];
    }
    else
    {
        [navigationButton setTitle:@"只看精华" forState:UIControlStateNormal];
    }
    for (int i=0; i<[[self.tiaojianImageView subviews] count]; i++) {
        if (i==sender.tag-1) {
            [[[self.tiaojianImageView subviews] objectAtIndex:i] setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"003_18" ofType:@"png"]] forState:UIControlStateNormal];
        }
        else
        {
            [[[self.tiaojianImageView subviews] objectAtIndex:i] setBackgroundImage:nil forState:UIControlStateNormal];
        }
    }
    
    [self.dataArray removeAllObjects];
    page=1;
    [self.oldDictionary setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [self.oldDictionary setValue:[NSString stringWithFormat:@"%d",sender.tag] forKey:@"type"];
    [self analyUrl:self.oldDictionary];
    self.tiaojianImageView.hidden=YES;
}
- (void)NavigationbuttonMenth
{
    self.tiaojianImageView.hidden=!self.tiaojianImageView.hidden;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AsihttpMenth) name:@"zuixinAsihttpMenth" object:nil];
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
    self.navigationButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.navigationButton.frame=CGRectMake((Screen_Width-100)/2, KUIOS_7(2), 100, 40);
    self.navigationButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:22];
    
    self.navigationButton.titleLabel.textColor=[UIColor whiteColor];
    [ self.navigationButton addTarget:self action:@selector(NavigationbuttonMenth) forControlEvents:UIControlEventTouchUpInside];
    [ self.navigationButton setTitle:@"最新发布" forState:UIControlStateNormal];
    [navigation addSubview: self.navigationButton];

    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(5, KUIOS_7(7), 51, 33);
    [back setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backup) forControlEvents:UIControlEventTouchUpInside];
    [navigation addSubview:back];
    //    UIBarButtonItem* backItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    //    self.navigationItem.leftBarButtonItem = backItem;
    //    [backItem release];
    UIButton* rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBut.frame = CGRectMake(Screen_Width-52,KUIOS_7(7), 47, 30);
    [rightBut setImage:[UIImage imageNamed:@"002_9.png"] forState:UIControlStateNormal];
    [rightBut addTarget:self action:@selector(RightMenth) forControlEvents:UIControlEventTouchUpInside];
    [navigation addSubview:rightBut];
    self.mainScrollView=[[[UIScrollView alloc]initWithFrame:CGRectMake(0, KUIOS_7(44), Screen_Width, Screen_Height-44-20)] autorelease];
    self.mainScrollView.delegate=self;
    self.mainScrollView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.mainScrollView];
    self.myTableview = [[[UITableView alloc]initWithFrame:CGRectMake(0, 107, self.view.bounds.size.width, Screen_Height-20-44-107)] autorelease];
    self.myTableview.delegate = self;
    self.myTableview.dataSource = self;
    self.myTableview.scrollEnabled=NO;
    self.myTableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.myTableview.backgroundColor=[UIColor clearColor];
    [self.mainScrollView addSubview:self.myTableview];
    if (ISIPAD) {
        self.myTableview.frame=CGRectMake(0, 150, self.view.bounds.size.width, Screen_Height-20-44-150);
    }
   
    self.biaoqianImageView=[[[UIImageView alloc]initWithFrame:CGRectMake(0,-44, Screen_Width, 44)] autorelease];
    self.biaoqianImageView.userInteractionEnabled=YES;
    self.biaoqianImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"biaoqian@2x (2)" ofType:@"png"]];
    [self.myTableview addSubview:self.biaoqianImageView];
    
   
    self.tiaojianImageView=[[[UIImageView alloc]initWithFrame:CGRectMake((Screen_Width-90)/2, 38, 90, 100)] autorelease];
    self.tiaojianImageView.userInteractionEnabled=YES;
    self.tiaojianImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"003_17" ofType:@"png"]];
    self.tiaojianImageView.hidden=YES;
    [self.view addSubview:self.tiaojianImageView];
    for (int i=0; i<3; i++) {
        UIButton * tiaojianButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [tiaojianButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        tiaojianButton.titleLabel.font=[UIFont systemFontOfSize:12];
        tiaojianButton.tag=i+1;
        [tiaojianButton addTarget:self action:@selector(TiaojianButtonMenth:) forControlEvents:UIControlEventTouchUpInside];
        tiaojianButton.frame=CGRectMake(7.5, 15+28*i, 75, 20);
        if (i==0) {
            [tiaojianButton setTitle:@"最新发布" forState:UIControlStateNormal];
        }
        else if (i==1)
        {
            [tiaojianButton setTitle:@"最后回复" forState:UIControlStateNormal];
        }
        else
        {
            [tiaojianButton setTitle:@"只看精华" forState:UIControlStateNormal];
        }
        if ([tiaojianButton.titleLabel.text isEqualToString:@"最新发布"]) {
            [tiaojianButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"003_18" ofType:@"png"]] forState:UIControlStateNormal];
            
        }
        [self.tiaojianImageView addSubview:tiaojianButton];
    }

    if (_refreshHeaderView == nil) {
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0-mainScrollView.bounds.size.height, mainScrollView.frame.size.width, mainScrollView.bounds.size.height)];
        _refreshHeaderView.delegate = self;
        [self.mainScrollView addSubview:_refreshHeaderView];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    self.allDataArray=[[[NSMutableArray alloc]initWithCapacity:1] autorelease];
    self.dataArray=[[[NSMutableArray alloc]initWithCapacity:1] autorelease];
    self.tishiView=[TishiView tishiViewMenth];
    [self.view addSubview:self.tishiView];
    
    [self AsihttpMenth];
    UIImageView * headerBackImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 107)];
    headerBackImageView.userInteractionEnabled=YES;
    headerBackImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"002_15" ofType:@"png"]];
    [self.mainScrollView addSubview:headerBackImageView];
    [headerBackImageView release];
   
    
    
    headImage = [[AsyncImageView alloc]initWithFrame:CGRectMake(10, (107-85)/2,85 , 85)];
    headImage.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"85" ofType:@"png"]]];
    [headerBackImageView addSubview:headImage];
    [headImage release];
    
   titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(headImage.frame.origin.x+headImage.frame.size.width+10, headImage.frame.origin.y, self.view.frame.size.width-110, 20)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
   [headerBackImageView addSubview:titleLabel];
   [titleLabel release];
  
  
   huifu1 = [[UILabel alloc]initWithFrame:CGRectMake(100, titleLabel.frame.origin.y+titleLabel.frame.size.height+3, Screen_Width-110, 11)];
   huifu1.text = @"话题                  回复              ";
    huifu1.textAlignment=NSTextAlignmentRight;
    huifu1.backgroundColor=[UIColor clearColor];
  huifu1.font = [UIFont systemFontOfSize:10];
  [headerBackImageView addSubview:huifu1];
  [huifu1 release];
  
  UIButton* chengyuan = [[UIButton alloc]initWithFrame:CGRectMake(headImage.frame.origin.x+headImage.frame.size.width+10, huifu1.frame.size.height+huifu1.frame.origin.y+5, 37, 37)];
  [chengyuan setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"002_10" ofType:@"png"]] forState:UIControlStateNormal];
  [chengyuan addTarget:self action:@selector(gotoQuanZiChengYuan) forControlEvents:UIControlEventTouchUpInside];
  [headerBackImageView addSubview:chengyuan];
  [chengyuan release];
  
  chengyuanNUm = [[UILabel alloc]initWithFrame:CGRectMake(chengyuan.frame.origin.x, chengyuan.frame.origin.y+chengyuan.frame.size.height, chengyuan.frame.size.width, 12)];
  chengyuanNUm.textAlignment=NSTextAlignmentCenter;
  chengyuanNUm.backgroundColor=[UIColor clearColor];
  chengyuanNUm.font = [UIFont systemFontOfSize:10];
  [headerBackImageView addSubview:chengyuanNUm];
  [chengyuanNUm release];
  
  UIButton* quantu = [[UIButton alloc]initWithFrame:CGRectMake(chengyuan.frame.origin.x+chengyuan.frame.size.width+8, huifu1.frame.size.height+huifu1.frame.origin.y+5, 37, 37)];
  [quantu setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"002_11" ofType:@"png"]] forState:UIControlStateNormal];
  quantu.userInteractionEnabled = YES;
  [headerBackImageView addSubview:quantu];
    [quantu addTarget:self action:@selector(gotoQuanMeiTu) forControlEvents:UIControlEventTouchUpInside];
  [quantu release];
  
  UILabel* quantuNum = [[UILabel alloc]initWithFrame:CGRectMake(quantu.frame.origin.x, quantu.frame.origin.y+quantu.frame.size.height, quantu.frame.size.width, 12)];
  quantuNum.text = @"圈美图";
    quantuNum.backgroundColor=[UIColor clearColor];
  quantuNum.font = [UIFont systemFontOfSize:10];
  quantuNum.textAlignment=NSTextAlignmentCenter;
  [headerBackImageView addSubview:quantuNum];
  [quantuNum release];
//
   mark = [[UIButton alloc]initWithFrame:CGRectMake(quantu.frame.origin.x+quantu.frame.size.width+8, huifu1.frame.size.height+huifu1.frame.origin.y+5, 37, 37)];
  [mark setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"002_12" ofType:@"png"]] forState:UIControlStateNormal];
  [mark addTarget:self action:@selector(selectMark:) forControlEvents:UIControlEventTouchUpInside];
//    mark.hidden=YES;
  [headerBackImageView addSubview:mark];
  [mark release];
  
  markNum = [[UILabel alloc]initWithFrame:CGRectMake(mark.frame.origin.x, mark.frame.origin.y+mark.frame.size.height, mark.frame.size.width, 12)];
  markNum.text = @"标签";
//    markNum.hidden=YES;
    markNum.backgroundColor=[UIColor clearColor];
  markNum.textAlignment = NSTextAlignmentCenter;
  markNum.font = [UIFont systemFontOfSize:10];
  [headerBackImageView addSubview:markNum];
  [markNum release];


    isJoin=NO;
  join = [[UIButton alloc]initWithFrame:CGRectMake(Screen_Width-47, huifu1.frame.size.height+huifu1.frame.origin.y+5, 37, 37)];
  [join setImage:[UIImage imageNamed:@"002_14.png"] forState:UIControlStateNormal];
  [headerBackImageView addSubview:join];
  [join release];
  
  join1 = [[UILabel alloc]initWithFrame:CGRectMake(join.frame.origin.x, join.frame.origin.y+join.frame.size.height, join.frame.size.width, 15)];
  join1.text = @"加入";
  join1.backgroundColor=[UIColor clearColor];
  join1.textAlignment = NSTextAlignmentCenter;
  [join addTarget:self action:@selector(join_jiaru) forControlEvents:UIControlEventTouchUpInside];
  join1.font = [UIFont systemFontOfSize:10];
  [headerBackImageView addSubview:join1];
  [join1 release];
  isJoin = NO;
    
   
    gengduoButton=[UIButton buttonWithType:UIButtonTypeCustom];
    gengduoButton.backgroundColor=[UIColor whiteColor];
    [gengduoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [gengduoButton setTitle:@"加载更多..." forState:UIControlStateNormal];
    [gengduoButton addTarget:self action:@selector(GengDuoMenth) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView addSubview:gengduoButton];
    activityView=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(20, 5, 20, 20)];
    [activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型

    [gengduoButton addSubview:activityView];
    gengduoButton.hidden=YES;
    tagNum=0;
   
    if (ISIPAD) {
        headerBackImageView.frame=CGRectMake(0, 0, Screen_Width, 107*1.4);
        headImage.frame=CGRectMake(headImage.frame.origin.x*1.4, headImage.frame.origin.y*1.4, headImage.frame.size.width*1.4, headImage.frame.size.height*1.4);
        headImage.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"119" ofType:@"png"]]];

        titleLabel.frame=CGRectMake(titleLabel.frame.origin.x*1.4, titleLabel.frame.origin.y*1.4, titleLabel.frame.size.width*1.4, titleLabel.frame.size.height*1.4);
//        huifu1.frame=CGRectMake(huifu1.frame.origin.x*1.4, huifu1.frame.origin.y*1.4, huifu1.frame.size.width*1.4, huifu1.frame.size.height*1.4);
        chengyuan.frame=CGRectMake(chengyuan.frame.origin.x*1.4, chengyuan.frame.origin.y*1.4, chengyuan.frame.size.width*1.4, chengyuan.frame.size.height*1.4);
        chengyuanNUm.frame=CGRectMake(chengyuanNUm.frame.origin.x*1.4, chengyuanNUm.frame.origin.y*1.4, chengyuanNUm.frame.size.width*1.4, chengyuanNUm.frame.size.height*1.4);
        quantu.frame=CGRectMake(quantu.frame.origin.x*1.4, quantu.frame.origin.y*1.4, quantu.frame.size.width*1.4, quantu.frame.size.height*1.4);
        quantuNum.frame=CGRectMake(quantuNum.frame.origin.x*1.4, quantuNum.frame.origin.y*1.4, quantuNum.frame.size.width*1.4, quantuNum.frame.size.height*1.4);
        mark.frame=CGRectMake(mark.frame.origin.x*1.4, mark.frame.origin.y*1.4, mark.frame.size.width*1.4, mark.frame.size.height*1.4);
        markNum.frame=CGRectMake(markNum.frame.origin.x*1.4, markNum.frame.origin.y*1.4, markNum.frame.size.width*1.4, markNum.frame.size.height*1.4);
        join.frame=CGRectMake(Screen_Width-47*1.4, join.frame.origin.y*1.4, join.frame.size.width*1.4, join.frame.size.height*1.4);
        join1.frame=CGRectMake(join1.frame.origin.x-15, join1.frame.origin.y*1.4, join1.frame.size.width*1.4, join1.frame.size.height*1.4);

    }
}
- (void)GengDuoMenth
{
    [activityView startAnimating];
    page++;
    [self.oldDictionary setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [self analyUrl:self.oldDictionary];
}

- (void)analyUrl:(NSMutableDictionary *)urlString
{
    if (analysis) {
    [analysis CancelMenthrequst];
    }
    [self.tishiView StartMenth];
    self.mainScrollView.userInteractionEnabled=NO;
    NSURL * aUrl=[[NSURL alloc]initWithString:[urlString valueForKey:@"aUrl"]];
     analysis=[[AnalysisClass alloc]initWithIdentifier:aUrl DataName:Nil ControllerName:[urlString valueForKey:@"oldViewController"] delegate:self];
    [aUrl release];
    [analysis PostMenth:urlString];

    
}
- (void)AsihttpMenth
{
    [self.mainScrollView setContentOffset:CGPointMake(0, 0)];
    [self.allDataArray removeAllObjects];
    [self.dataArray removeAllObjects];
    page=1;
    NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
    NSLog(@"%@",[oldDictionary valueForKey:@"id"] );
    BOOL shifouquan=NO;
    for (int i=0; i<[[self.oldDictionary allKeys] count]; i++) {
        if ([[[self.oldDictionary allKeys] objectAtIndex:i] isEqualToString:@"cid"]) {
            shifouquan=YES;
            break;
        }
    }
    if (shifouquan) {
        [self.oldDictionary setValue:[self.oldDictionary valueForKey:@"cid"] forKey:@"cid"];
        
    }
    else
    {
        [self.oldDictionary setValue:[self.oldDictionary valueForKey:@"id"] forKey:@"cid"];
        
    }
    [self.oldDictionary setValue:[userDic valueForKey:@"uid"] forKey:@"uid"];
    [self.oldDictionary setValue:[userDic valueForKey:@"token"] forKey:@"token"];
    [self.oldDictionary setValue:@"10" forKey:@"limit"];
    [self.oldDictionary setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [self.oldDictionary setValue:@"全部" forKey:@"tag"];
    [self.oldDictionary setValue:@"http://apptest.mum360.com/web/home/index/circleinfo" forKey:@"aUrl"];
    [self.oldDictionary setValue:@"1" forKey:@"type"];
    [self.oldDictionary setValue:@"wodequanzi" forKey:@"oldViewController"];
    [self analyUrl:self.oldDictionary];
}
- (void)Asihttp:(AnalysisClass *)asi DataArray:(NSMutableDictionary *)array
{
    [self.tishiView StopMenth];
    [self loadMenth];

    NSDictionary * asiDic=[array valueForKey:asi.ControllerName];
    self.mainScrollView.userInteractionEnabled=YES;

    if ([asi.ControllerName isEqualToString:@"wodequanzi"]) {
        
    self.asiInfoDictionary=[[[NSMutableDictionary alloc]initWithDictionary:[asiDic valueForKey:@"info"]] autorelease];
    if (tagScrollView==nil) {
    tagScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 44)];
    tagScrollView.userInteractionEnabled=YES;
    tagScrollView.showsHorizontalScrollIndicator=NO;
    tagScrollView.showsVerticalScrollIndicator=NO;
    [self.biaoqianImageView addSubview:tagScrollView];
    [tagScrollView release];
    float buttonY=10;
    for (int i=0; i<[[self.asiInfoDictionary valueForKey:@"tag"] count]; i++) {
        UIButton * tagButton=[UIButton buttonWithType:UIButtonTypeCustom];
        tagButton.titleLabel.font=[UIFont systemFontOfSize:13];
        tagButton.frame=CGRectMake(buttonY, 7, [[[self.asiInfoDictionary valueForKey:@"tag"]objectAtIndex:i] length]*20, 30);
        tagButton.tag=i;
        [tagButton addTarget:self action:@selector(BiaoqianMenth:) forControlEvents:UIControlEventTouchUpInside];
        buttonY+=[[[self.asiInfoDictionary valueForKey:@"tag"]objectAtIndex:i] length]*20+5;
        if (i==0) {
            [tagButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        else
        {
            [tagButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        tagButton.backgroundColor=[UIColor whiteColor];
        [tagButton setTitle:[[self.asiInfoDictionary valueForKey:@"tag"]objectAtIndex:i] forState:UIControlStateNormal];
        [tagScrollView addSubview:tagButton];
    }
    [tagScrollView setContentSize:CGSizeMake(buttonY, tagScrollView.frame.size.height)];
    }
    headImage.urlString=[asiInfoDictionary valueForKey:@"image"];
    titleLabel.text=[asiInfoDictionary valueForKey:@"name"];
    huifu1.text=[NSString stringWithFormat:@"话题 %@  回复 %@ ",[asiInfoDictionary valueForKey:@"themenum"],[asiInfoDictionary valueForKey:@"commentnum"]];
    chengyuanNUm.text=[asiInfoDictionary valueForKey:@"num"];
    if ([[asiInfoDictionary valueForKey:@"flag"]intValue]==1) {
        [join setImage:[UIImage imageNamed:@"002_13.png"] forState:UIControlStateNormal];
        join1.text = @"已加入";
        isJoin=YES;
    }
        if ([[asiDic valueForKey:@"themes"] count]<10) {
            fenyeBool=NO;
            gengduoButton.hidden=YES;
        }
        else
        {
            [activityView stopAnimating];
            fenyeBool=YES;
            gengduoButton.hidden=NO;
        }
        
    [self.dataArray addObjectsFromArray:[asiDic valueForKey:@"themes"]];
    [self.myTableview reloadData];
    }else
    {
        if ([[asiDic valueForKey:@"code"] intValue]==1) {
            
            if ([asi.ControllerName isEqualToString:@"shanquanzi"]) {
                [join setImage:[UIImage imageNamed:@"002_14.png"] forState:UIControlStateNormal];
                join1.text = @"加入";
                isJoin=NO;
            }
            else
            {
                [join setImage:[UIImage imageNamed:@"002_13"]
                      forState:UIControlStateNormal];
                join1.text = @"已加入";
                isJoin=YES;
            }

        }
        
    }
    [asi release];
    analysis=nil;

}
- (void)AddArrayMenth:(int)sender
{
    int arrayCount=self.allDataArray.count;
    if (sender) {
        for (int i=0; i<arrayCount; i++)
        {
            [self.dataArray addObject:[self.allDataArray objectAtIndex:0]];
            [self.allDataArray removeObjectAtIndex:0];
        }
 
    }
    else
    {
        
        int arrCount=arrayCount>10?10:arrayCount;
            for (int i=0; i<arrCount; i++)
            {
                [self.dataArray addObject:[self.allDataArray objectAtIndex:0]];
                [self.allDataArray removeObjectAtIndex:0];
            }
    }
    [self.myTableview reloadData];
}
- (void)BiaoqianMenth:(UIButton *)sender
{
    
    for (int i=0; i<[[tagScrollView subviews] count]; i++) {
        if (i==sender.tag) {
            [[[tagScrollView subviews] objectAtIndex:i] setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        else
        {
            [[[tagScrollView subviews] objectAtIndex:i] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self.myTableview setContentOffset:CGPointMake(0, 0) animated:YES];
        [self.mainScrollView setContentSize:CGSizeMake(self.mainScrollView.frame.size.width, 107+10*54)];
        if (ISIPAD) {
            [self.mainScrollView setContentSize:CGSizeMake(self.mainScrollView.frame.size.width, 150+10*54*1.4)];

        }
    } completion:^(BOOL finished){
        
    }];
    self.biaoqianImageView.tag=0;
    [self.dataArray removeAllObjects];
    [self.oldDictionary setValue:[[self.asiInfoDictionary valueForKey:@"tag"] objectAtIndex:sender.tag] forKey:@"tag"];
    [self analyUrl:self.oldDictionary];

    
}
- (void)RightMenth
{
    NSMutableDictionary * fbDictionary=[[NSMutableDictionary alloc]initWithCapacity:1];
    [fbDictionary setValue:[asiInfoDictionary valueForKey:@"id"] forKey:@"cid"];
    [fbDictionary setValue:[asiInfoDictionary valueForKey:@"tag"] forKey:@"tag"];
    FabuViewController * fabuView=[[FabuViewController alloc]init];
    fabuView.oldDictionary=fbDictionary;
    [fbDictionary release];
    [self.navigationController pushViewController:fabuView animated:YES];
    [fabuView release];
}
-(void)gotoQuanZiChengYuan
{
    NSMutableDictionary * daDictionary=[[NSMutableDictionary alloc]initWithCapacity:1];
    [daDictionary addEntriesFromDictionary:self.asiInfoDictionary];
    [daDictionary setValue:@"圈子成员" forKey:@"Title"];
    QuanZiChengYuan_ViewController* vc = [[QuanZiChengYuan_ViewController alloc]init];
    vc.oldDictionary=daDictionary;
    [daDictionary release];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}
-(void)gotoQuanMeiTu
{
    QuanmeituViewController *ctrl = [[[QuanmeituViewController alloc]init]autorelease];
    ctrl.cid = [NSString stringWithFormat:@"%@",[self.oldDictionary valueForKey:@"cid"]];
    [self.navigationController pushViewController:ctrl animated:YES];
}
-(void)selectMark:(UIButton *)sender
{
    sender.userInteractionEnabled=NO;
    if (self.biaoqianImageView.tag) {
        [UIView animateWithDuration:0.5 animations:^{
            
            [self.mainScrollView setContentSize:CGSizeMake(self.mainScrollView.frame.size.width, 107+self.dataArray.count*54+44)];
            if (ISIPAD) {
                [self.mainScrollView setContentSize:CGSizeMake(self.mainScrollView.frame.size.width, 150+self.dataArray.count*54*1.4+44)];

            }
            self.myTableview.frame=CGRectMake(self.myTableview.frame.origin.x, self.myTableview.frame.origin.y, self.myTableview.frame.size.width, self.mainScrollView.contentSize.height-self.myTableview.frame.origin.y);
            [self.myTableview setContentOffset:CGPointMake(0, 0) animated:YES];

            gengduoButton.frame=CGRectMake(30, self.mainScrollView.contentSize.height-40, self.myTableview.frame.size.width-60, 30);

        } completion:^(BOOL finished){
            sender.userInteractionEnabled=YES;
        }];
        

          }
    else
    {
        
        [UIView animateWithDuration:0.5 animations:^{
            [self.myTableview setContentOffset:CGPointMake(0, -44) animated:YES];
            [self.mainScrollView setContentSize:CGSizeMake(self.mainScrollView.frame.size.width, 107+self.dataArray.count*54+44+44)];
            if (ISIPAD) {
                [self.mainScrollView setContentSize:CGSizeMake(self.mainScrollView.frame.size.width, 150+self.dataArray.count*54*1.4+44+44)];

            }
            gengduoButton.frame=CGRectMake(30, self.mainScrollView.contentSize.height-40, self.myTableview.frame.size.width-60, 30);
            self.myTableview.frame=CGRectMake(self.myTableview.frame.origin.x, self.myTableview.frame.origin.y, self.myTableview.frame.size.width, self.mainScrollView.contentSize.height-self.myTableview.frame.origin.y);


        } completion:^(BOOL finished){
            sender.userInteractionEnabled=YES;
            
        }];

        
    }

    self.biaoqianImageView.tag=!self.biaoqianImageView.tag;
}
-(void)join_jiaru
{

  if (isJoin == NO) {
      [self.oldDictionary setValue:@"http://apptest.mum360.com/web/home/index/createmember" forKey:@"aUrl"];
      [self.oldDictionary setValue:@"zhengquanzi" forKey:@"oldViewController"];
      [self analyUrl:self.oldDictionary];

  }
  if (isJoin == YES) {
//      UIAlertView * alertview=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"退出圈子要还回加入时送您的5个积分呢" delegate:self cancelButtonTitle:@"取 消" otherButtonTitles:@"确定", nil];
//      [alertview show];
//      [alertview release];
      [self.oldDictionary setValue:@"http://apptest.mum360.com/web/home/index/deletemember" forKey:@"aUrl"];
      [self.oldDictionary setValue:@"shanquanzi" forKey:@"oldViewController"];
      [self analyUrl:self.oldDictionary];
  }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        
    
    [self.oldDictionary setValue:@"http://apptest.mum360.com/web/home/index/deletemember" forKey:@"aUrl"];
    [self.oldDictionary setValue:@"shanquanzi" forKey:@"oldViewController"];
        [self analyUrl:self.oldDictionary];
    }

}
-(void)rightPress
{
//  FaBuHuaTiViewController* fabu = [[FaBuHuaTiViewController alloc]init];
//  [self presentViewController:fabu animated:YES completion:nil];
//  [fabu release];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    contentViewController *ctrl = [[contentViewController alloc]init];
    ctrl.contentID = self.dataArray[indexPath.row][@"id"];
    [self.navigationController pushViewController:ctrl animated:YES];
    [ctrl release];
}
-(void)backup
{
  [self.navigationController popViewControllerAnimated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row==0) {
//        return 58;
//    }
//    else
//    {
    if (ISIPAD) {
        return 54*1.4;
    }
        return 54;
//    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     
    if (fenyeBool) {
        [self.mainScrollView setContentSize:CGSizeMake(self.mainScrollView.frame.size.width, 107+self.dataArray.count*54+40)];
        gengduoButton.frame=CGRectMake(30, self.mainScrollView.contentSize.height-40, self.myTableview.frame.size.width-60, 30);
        if (ISIPAD) {
            [self.mainScrollView setContentSize:CGSizeMake(self.mainScrollView.frame.size.width, 150+self.dataArray.count*54*1.4+40)];
            gengduoButton.frame=CGRectMake(30, self.mainScrollView.contentSize.height-40, self.myTableview.frame.size.width-60, 30);

        }

    }
    else
    {
        [self.mainScrollView setContentSize:CGSizeMake(self.mainScrollView.frame.size.width, 107+self.dataArray.count*54)];
        if (ISIPAD) {
            [self.mainScrollView setContentSize:CGSizeMake(self.mainScrollView.frame.size.width, 150+self.dataArray.count*54*1.4)];
            
        }
    }
    
    self.myTableview.frame=CGRectMake(self.myTableview.frame.origin.x, self.myTableview.frame.origin.y, self.myTableview.frame.size.width, self.mainScrollView.contentSize.height-self.myTableview.frame.origin.y);
    if (ISIPAD) {
        self.myTableview.frame=CGRectMake(self.myTableview.frame.origin.x, self.myTableview.frame.origin.y, self.myTableview.frame.size.width, self.mainScrollView.contentSize.height-self.myTableview.frame.origin.y);

    }
    
  return self.dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//  newCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
//  if (cell == nil)
//  {
    newCell* cell = [[[newCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"] autorelease];
//  }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (self.dataArray.count>indexPath.row) {
        
    NSDictionary * celldic=[self.dataArray objectAtIndex:indexPath.row];
    NSLog(@"%@",celldic);
        if ([[celldic valueForKey:@"icon"] length]) {
            cell.mainImageView.urlString=[celldic valueForKey:@"icon"];
        }
        else
        {
            cell.mainImageView.image=[UIImage imageNamed:@"默认.png"];

        }
    cell.mainImageView.tag=indexPath.row;
    [cell.mainImageView addTarget:self action:@selector(Gerenzhongxin:) forControlEvents:UIControlEventTouchUpInside];
    cell.titleLabel.frame=CGRectMake(53, 8, [[celldic valueForKey:@"title"] length]*16, 8);
    int titSize=[[celldic valueForKey:@"title"] length]*16>220?220:[[celldic valueForKey:@"title"] length]*16;
        cell.titleLabel.frame=CGRectMake(53, 8, titSize, 20);


      [cell.titleLabel LoadContent:[celldic valueForKey:@"title"]];
        
    cell.tupianImageView.frame=CGRectMake(cell.titleLabel.frame.size.width+cell.titleLabel.frame.origin.x+5, cell.titleLabel.frame.origin.y+3, 17.5, 13);
    if ([[celldic valueForKey:@"image"] intValue]) {
        cell.tupianImageView.hidden=NO;

    }
        
    int areaSize=[[celldic valueForKey:@"name"] length]*12.5>65?65:[[celldic valueForKey:@"name"] length]*13;
    cell.areaLabel.frame=CGRectMake(cell.areaLabel.frame.origin.x, cell.areaLabel.frame.origin.y, areaSize, cell.areaLabel.frame.size.height);
    cell.areaLabel.text=[celldic valueForKey:@"name"];
    cell.timeLabel.frame=CGRectMake(cell.areaLabel.frame.origin.x+cell.areaLabel.frame.size.width+2, cell.areaLabel.frame.origin.y+3, 210-cell.areaLabel.frame.origin.x-cell.areaLabel.frame.size.width-2, cell.timeLabel.frame.size.height);
    cell.timeLabel.text=[celldic valueForKey:@"status"];
        NSLog(@"%@",[celldic valueForKey:@"status"]);
        if ([[celldic valueForKey:@"status"] isEqualToString:@"备孕中"]) {
            cell.timeLabel.textColor=[UIColor colorWithRed:101/255.0 green:149/255.0 blue:7/255.0 alpha:1];
        }
        else if ([[celldic valueForKey:@"status"] hasPrefix:@"宝宝"])
        {
           cell.timeLabel.textColor=[UIColor colorWithRed:214/255.0 green:40/255.0 blue:39/255.0 alpha:1];
        }
        else
        {
            cell.timeLabel.textColor=[UIColor colorWithRed:36/255.0 green:161/255.0 blue:188/255.0 alpha:1];
        }
    cell.upTimeLabel.text=[celldic valueForKey:@"time"];
    cell.withPlacardLabel.text=[celldic valueForKey:@"commentnum"];
    if ([[celldic valueForKey:@"flag"] intValue]==1) {
        cell.backImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"002_18" ofType:@"png"]];
        if (ISIPAD) {
            cell.backImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"758" ofType:@"png"]];

        }
    }
    else
    {
        cell.tupianImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"002_19" ofType:@"png"]];
        if (ISIPAD) {
            
        }
    }
    
    }
    if (ISIPAD)
    {
        cell.titleLabel.frame=CGRectMake(cell.titleLabel.frame.origin.x*1.4, cell.titleLabel.frame.origin.y*1.4, cell.titleLabel.frame.size.width*1.4, cell.titleLabel.frame.size.height*1.4);
        cell.tupianImageView.frame=CGRectMake(cell.titleLabel.frame.size.width+cell.titleLabel.frame.origin.x+5, cell.titleLabel.frame.origin.y+3, 17.5, 13);

    }

  return cell;
}
- (void)Gerenzhongxin:(AsyncImageView *)sender
{
    NSMutableDictionary * diction=[[NSMutableDictionary alloc]initWithCapacity:1];
    [diction setObject:[[self.dataArray objectAtIndex:sender.tag] valueForKey:@"uid"] forKey:@"id"];
    [diction setObject:@"YES" forKey:@"bool"];
    [diction setValue:@"0" forKey:@"type"];
    WoViewController * woview=[[WoViewController alloc]init];
    woview.oldDictionary=diction;
    [diction release];
    [self.navigationController pushViewController:woview animated:YES];
    [woview release];
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
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:mainScrollView];
}
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    [self.allDataArray removeAllObjects];
    [self.dataArray removeAllObjects];
    page=1;
    [self.oldDictionary setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [self analyUrl:self.oldDictionary];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
