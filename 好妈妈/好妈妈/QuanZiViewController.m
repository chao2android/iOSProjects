//
//  QuanZiViewController.m
//  好妈妈
//
//  Created by iHope on 13-9-22.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "QuanZiViewController.h"
#import "TuijianquanziViewController.h"
#import "QuanZi_Cell.h"
#import "ZuiXinFaBu_ViewController.h"
#import "AsyncImageView.h"
#import "SearViewController.h"
#import "GuiDang.h"
@interface QuanZiViewController ()

@end

@implementation QuanZiViewController
@synthesize dataArray;
@synthesize tishiView;
- (void)dealloc
{
    [tishiView release];
    [dataArray release];
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
- (void)viewWillDisappear:(BOOL)animated
{
    if (analysis) {
        
    [analysis CancelMenthrequst];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayTabBar" object:nil];
    self.navigationController.navigationBar.hidden=YES;
    self.tishiView=[TishiView tishiViewMenth];
    [self.view addSubview:self.tishiView];
    [self.dataArray removeAllObjects];
    page=1;
    _uitable .reachedTheEnd  = NO;
    [self AsiMenth];

}
- (void)analyUrl:(NSMutableDictionary *)urlString
{
    [tishiView StartMenth];
    _uitable.userInteractionEnabled=NO;
    NSURL * aUrl=[[NSURL alloc]initWithString:@"http://apptest.mum360.com/web/home/index/usercirclelist"];
    analysis=[[AnalysisClass alloc]initWithIdentifier:aUrl DataName:Nil ControllerName:@"wodequanzi" delegate:self];
    [aUrl release];
    [analysis PostMenth:urlString];
    
}
- (void)Asihttp:(AnalysisClass *)asi DataArray:(NSMutableDictionary *)array
{
    [tishiView StopMenth];
     _uitable.userInteractionEnabled=YES;
    

    if ([[array valueForKey:asi.ControllerName] count])
    {
        if (page==1) {
            [GuiDang ChuCunMenth:[array valueForKey:asi.ControllerName] LJstring:@"quanzi"];
        }
        [self.dataArray addObjectsFromArray:[array valueForKey:asi.ControllerName]];
    }
    else
    {
        if (page!=1) {
            
        
        [_uitable tableViewDidFinishedLoading];
        _uitable .reachedTheEnd  = YES;
        }
        else
        {
            [self.dataArray addObjectsFromArray:[GuiDang DuquMenth:@"quanzi"]];

        }
    }
    [_uitable reloadData];
    [_uitable tableViewDidFinishedLoading];
    [asi release];
    analysis=nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
  
//    self.navigationController.navigationBar.hidden=NO;
//    self.navigationController.navigationBar.translucent = YES;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_background.png"] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }

    self.dataArray=[[[NSMutableArray alloc]initWithCapacity:1] autorelease];
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
    navigationLabel.text=@"我的圈子";
    [navigation addSubview:navigationLabel];
    [navigationLabel release];
    UIButton * leftBut=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBut.frame=CGRectMake(5, KUIOS_7(6), 45, 30.5);
    [leftBut addTarget:self action:@selector(backup) forControlEvents:UIControlEventTouchUpInside];
    [leftBut setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"001_18" ofType:@"png"]] forState:UIControlStateNormal];
    [navigation addSubview:leftBut];
    UIButton * rightBut=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBut.frame=CGRectMake(Screen_Width-65, KUIOS_7(7), 60, 30);
    [rightBut addTarget:self action:@selector(RightMenth) forControlEvents:UIControlEventTouchUpInside];
    [rightBut setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"002_1" ofType:@"png"]] forState:UIControlStateNormal];
    [navigation addSubview:rightBut];
    _uitable = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, KUIOS_7(44), Screen_Width, Screen_Height-20-44-46) pullingDelegate:(id<PullingRefreshTableViewDelegate>)self];
    if (ISIPAD) {
        _uitable.frame=CGRectMake(0, KUIOS_7(44), Screen_Width, Screen_Height-20-44-64);
    }
    _uitable.backgroundColor = [UIColor clearColor];
    _uitable.delegate = self;
    _uitable.dataSource = self;
    _uitable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_uitable];
    [_uitable release];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_uitable tableViewDidEndDragging:scrollView];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_uitable tableViewDidScroll:scrollView];
}
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    [self.dataArray removeAllObjects];
    page=1;
    _uitable .reachedTheEnd  = NO;
    [self AsiMenth];
}
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    page++;
    [self AsiMenth];
}
- (void)AsiMenth
{
    NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
    NSMutableDictionary * Dictionary=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[userDic valueForKey:@"uid"],@"uid",[userDic valueForKey:@"token"],@"token",[userDic valueForKey:@"uid"],@"targetid",@"15",@"limit",[NSString stringWithFormat:@"%d",page],@"page", nil];
    [self analyUrl:Dictionary];
    [Dictionary release];
}

- (void)RightMenth
{
    NSMutableDictionary * dataDictionary=[[NSMutableDictionary alloc]initWithCapacity:1];
    [dataDictionary setValue:@"推荐圈子" forKey:@"Title"];
    [dataDictionary setValue:@"http://apptest.mum360.com/web/home/index/recommentcircles" forKey:@"aUrl1"];
    NSArray * typeArr=[[NSArray alloc]initWithObjects:@"推荐",@"人气",@"热度", nil];
    [dataDictionary setValue:typeArr forKey:@"typeArr"];
    [typeArr release];
    MOBCLICK(kMob_GoodGroup);
    TuijianquanziViewController * tuijianquanzi=[[TuijianquanziViewController alloc]init];
    tuijianquanzi.oldDictionary=dataDictionary;
    [dataDictionary release];
    [self.navigationController pushViewController:tuijianquanzi animated:YES];
    [tuijianquanzi release];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count+1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuanZi_Cell* cell = [tableView1 dequeueReusableCellWithIdentifier:@"ID"];
    
    if (cell == nil) {
        cell = [[[QuanZi_Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"] autorelease];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.titleLabel4.text = @"妈妈知道";
    }
    else{
        if (self.dataArray.count) {
            NSDictionary * cellDic=[self.dataArray objectAtIndex:indexPath.row-1];

            cell.headerImage.urlString=[cellDic valueForKey:@"image"];
        
        
            cell.titleLabel4.text=[cellDic valueForKey:@"name"];
            if (cell.titleLabel) {
                NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
                [cell.titleLabel removeFromSuperview];
                cell.titleLabel = nil;
                [pool release];
            }

            cell.titleLabel=[[[ImageTextLabel alloc]initWithFrame:CGRectMake(93, 35, Screen_Width-110, 13)] autorelease];
        if (ISIPAD) {
            cell.titleLabel.frame=CGRectMake(cell.titleLabel.frame.origin.x*1.4, cell.titleLabel.frame.origin.y*1.4,  Screen_Width-110*1.4, cell.titleLabel.frame.size.height*1.4);
        }
        cell.titleLabel.m_RowHeigh=13;
        cell.titleLabel.m_EmoWidth=13;
        cell.titleLabel.m_EmoHeight=13;
        cell.titleLabel.textColor=[UIColor blackColor];
        cell.titleLabel.m_Font=[UIFont systemFontOfSize:12];
        cell.titleLabel.backgroundColor=[UIColor clearColor];
        cell.titleLabel.hangshu=YES;
        [cell.contentView addSubview:cell.titleLabel];
        if (ISIPAD) {
            cell.titleLabel.m_RowHeigh=13*1.4;
            cell.titleLabel.m_EmoWidth=13*1.4;
            cell.titleLabel.m_EmoHeight=13*1.4;
            cell.titleLabel.m_Font=[UIFont systemFontOfSize:12*1.4];
            
        }
        [cell.titleLabel LoadContent:[[self.dataArray objectAtIndex:indexPath.row-1] valueForKey:@"theme"]];
    int asyConnt=[[cellDic valueForKey:@"uids"] count]>5?5:[[cellDic valueForKey:@"uids"] count];
        
//        for (int i=0; i<asyConnt; i++) {
//        AsyncImageView * cellImageView=[[AsyncImageView alloc]initWithFrame:CGRectMake(93+38*i, 53, 30, 30)];
//        cellImageView.layer.cornerRadius = 5;//设置那个圆角的有多圆
//        cellImageView.layer.masksToBounds = YES;
//        if (ISIPAD) {
//            cellImageView.frame=CGRectMake(cellImageView.frame.origin.x*1.4, cellImageView.frame.origin.y*1.4, cellImageView.frame.size.width*1.4, cellImageView.frame.size.height*1.4);
//            cellImageView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"圈子默认.png"]];
//        }
//        else
//        {
//            cellImageView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"30_30.png"]];
//
//        }
//        if (i<asyConnt) {
        if (asyConnt) {
            
            cell.subImage1.hidden=NO;
          cell.subImage1.urlString=[[[cellDic valueForKey:@"uids"] objectAtIndex:0] valueForKey:@"icon"];
        }
        else
        {
            cell.subImage1.hidden=YES;
        }
        if (asyConnt>1) {
            
            cell.subImage2.hidden=NO;
            cell.subImage2.urlString=[[[cellDic valueForKey:@"uids"] objectAtIndex:1] valueForKey:@"icon"];
        }
        else
        {
            cell.subImage2.hidden=YES;
        }

        if (asyConnt>2) {
            
            cell.subImage3.hidden=NO;
            cell.subImage3.urlString=[[[cellDic valueForKey:@"uids"] objectAtIndex:2] valueForKey:@"icon"];
        }
        else
        {
            cell.subImage3.hidden=YES;
        }

        if (asyConnt>3) {
            
            cell.subImage4.hidden=NO;
            cell.subImage4.urlString=[[[cellDic valueForKey:@"uids"] objectAtIndex:3] valueForKey:@"icon"];
        }
        else
        {
            cell.subImage4.hidden=YES;
        }

        if (asyConnt>4) {
            
            cell.subImage5.hidden=NO;
            cell.subImage5.urlString=[[[cellDic valueForKey:@"uids"] objectAtIndex:4] valueForKey:@"icon"];
        }
        else
        {
            cell.subImage5.hidden=YES;
        }
    }
    UIButton * cellButton=[UIButton buttonWithType:UIButtonTypeCustom];
    cellButton.tag=indexPath.row-1;
    [cellButton addTarget:self action:@selector(CellButtonMenth:) forControlEvents:UIControlEventTouchUpInside];
    cellButton.tag=indexPath.row-1;
       
    cellButton.frame=CGRectMake(0, 0, Screen_Width, 93.5);
        if (ISIPAD) {
            cellButton.frame=CGRectMake(0, 0, Screen_Width, cellButton.frame.size.height*1.4);
        }
    
    [cell addSubview:cellButton];
    }
    
    return cell;
}
- (void)CellButtonMenth:(UIButton *)sender
{
    NSLog(@"okokokokok");
    ZuiXinFaBu_ViewController* faBuVC = [[ZuiXinFaBu_ViewController alloc]init];
    faBuVC.oldDictionary=[self.dataArray objectAtIndex:sender.tag];
    [self.navigationController pushViewController:faBuVC animated:YES];
    [faBuVC release];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (ISIPAD) {
        return 93.5*1.4;
    }
    return 93.5;
    
}
-(void)backup{
    SearViewController *ctrl = [[[SearViewController alloc ]init]autorelease];
    [self.navigationController pushViewController:ctrl animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
