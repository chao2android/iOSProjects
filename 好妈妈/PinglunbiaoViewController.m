//
//  PinglunbiaoViewController.m
//  好妈妈
//
//  Created by iHope on 13-10-30.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "PinglunbiaoViewController.h"
#import "PinglunCell.h"
#import "AsyncImageView.h"
#import "ImageTextLabel.h"
#import "PlViewController.h"
#import "WoViewController.h"
@interface PinglunbiaoViewController ()

@end

@implementation PinglunbiaoViewController
@synthesize dataArray;
@synthesize oldDictionary;
- (void)dealloc
{
    [oldDictionary release];
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
        analysis=nil;
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden=YES;

    tishiView=[TishiView tishiViewMenth];
    [self.view addSubview:tishiView];
    [self.dataArray removeAllObjects];
    page=1;
    [self.oldDictionary setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    _uitable .reachedTheEnd  = NO;
    [self analyUrl];

//    uid=&token=&id=&limit=&page=
}
- (void)analyUrl
{
    [tishiView StartMenth];
    _uitable.userInteractionEnabled=NO;
    NSURL * aUrl=[[NSURL alloc]initWithString:@"http://apptest.mum360.com/web/home/index/topiccommentlist"];
    analysis=[[AnalysisClass alloc]initWithIdentifier:aUrl DataName:Nil ControllerName:@"wodequanzi" delegate:self];
    [aUrl release];
    [analysis PostMenth:self.oldDictionary];
    
}
- (void)Asihttp:(AnalysisClass *)asi DataArray:(NSMutableDictionary *)array
{
    [tishiView StopMenth];
    _uitable.userInteractionEnabled=YES;
    
    (@"%@",[array valueForKey:asi.ControllerName]);
    
    if ([[array valueForKey:asi.ControllerName] count])
    {
        
        if ([[[array valueForKey:asi.ControllerName] valueForKey:@"msg"] objectAtIndex:0]==nil)
        {
        }
        else
        {
            [self.dataArray addObjectsFromArray:[array valueForKey:asi.ControllerName]];
            
        }
    }
    else
    {
        [_uitable tableViewDidFinishedLoading];
        _uitable .reachedTheEnd  = YES;
    }
    [_uitable reloadData];
    [_uitable tableViewDidFinishedLoading];
    [asi release];
    analysis=nil;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count>indexPath.row) {
        
    
    NSDictionary * cellDic=[self.dataArray objectAtIndex:indexPath.row];
        (@"%d", [ImageTextLabel HeightOfContent:[cellDic valueForKey:@"content"] :CGSizeMake(255, 20)]+50);
    return  [ImageTextLabel HeightOfContent:[cellDic valueForKey:@"content"] :CGSizeMake(255, 20)]+62.5;
    }
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PinglunCell* cell = [tableView1 dequeueReusableCellWithIdentifier:@"ID"];
    
    if (cell == nil) {
        cell = [[[PinglunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"] autorelease];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (self.dataArray.count) {
        cell.backImageView.frame=CGRectMake(0, 2.5, Screen_Width, [self tableView:tableView1 heightForRowAtIndexPath:indexPath]-2.5);
        cell.backImageView.image=[UIImage imageNamed:@"002_3.png"];
        (@"tableView1.rowHeight%f",tableView1.rowHeight);
        NSDictionary * cellDic=[self.dataArray objectAtIndex:indexPath.row];
        if ([[cellDic valueForKey:@"icon"] length]) {
            cell.touxiangImageView.urlString=[cellDic valueForKey:@"icon"];
        }
        else
        {
            cell.touxiangImageView.image=[UIImage imageNamed:@"默认.png"];
        }
        cell.touxiangImageView.tag=indexPath.row;
        [cell.touxiangImageView addTarget:self action:@selector(TouXiangMenth:) forControlEvents:UIControlEventTouchUpInside];
        cell.titleLabel.text=[cellDic valueForKey:@"name"];
        
        cell.titleLabel.frame=CGRectMake(cell.titleLabel.frame.origin.x, cell.titleLabel.frame.origin.y, cell.titleLabel.text.length*18>180?180:cell.titleLabel.text.length*18, cell.titleLabel.frame.size.height);
        cell.typeLabel.text=[cellDic valueForKey:@"status"];
        cell.typeLabel.frame=CGRectMake(cell.titleLabel.frame.size.width+cell.titleLabel.frame.origin.x, cell.titleLabel.frame.origin.y+(cell.titleLabel.frame.size.height-cell.typeLabel.frame.size.height)/2, 80,cell.typeLabel.frame.size.height);
        if ([[cellDic valueForKey:@"status"] isEqualToString:@"备孕中"]) {
            cell.typeLabel.textColor=[UIColor colorWithRed:101/255.0 green:149/255.0 blue:7/255.0 alpha:1];
        }
        else if ([[cellDic valueForKey:@"status"] hasPrefix:@"宝宝"])
        {
            cell.typeLabel.textColor=[UIColor colorWithRed:214/255.0 green:40/255.0 blue:39/255.0 alpha:1];
        }
        else
        {
            cell.typeLabel.textColor=[UIColor colorWithRed:36/255.0 green:161/255.0 blue:188/255.0 alpha:1];
        }
        if (cell.contentLabel) {
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            [cell.contentLabel removeFromSuperview];
            cell.contentLabel = nil;
            [pool release];
        }
        cell.contentLabel=[[[ImageTextLabel alloc]initWithFrame:CGRectMake(cell.titleLabel.frame.origin.x, cell.titleLabel.frame.origin.y+cell.titleLabel.frame.size.height+10, 255, 20)] autorelease];
        cell.contentLabel.textColor=[UIColor colorWithRed:126/255.0 green:125/255.0 blue:120/255.0 alpha:1];
        [cell.contentLabel LoadContent:[cellDic valueForKey:@"content"]];
        cell.contentLabel.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:cell.contentLabel];
        (@"contentLabel  %f  %f",cell.contentLabel.frame.origin.y,cell.contentLabel.frame.size.height);
        cell.timeLabel.frame=CGRectMake(cell.timeLabel.frame.origin.x, cell.contentLabel.frame.origin.y+cell.contentLabel.frame.size.height+5, 230, cell.timeLabel.frame.size.height);
        cell.timeLabel.text=[cellDic valueForKey:@"time"];
        
    }
    return cell;
}
- (void)TouXiangMenth:(AsyncImageView *)sender
{
   
    NSMutableDictionary * diction=[[NSMutableDictionary alloc]initWithCapacity:1];
    [diction setObject:@"YES" forKey:@"bool"];
    [diction setValue:@"0" forKey:@"type"];
    [diction setObject:[[self.dataArray objectAtIndex:sender.tag] valueForKey:@"uid"] forKey:@"id"];
    WoViewController * woview=[[WoViewController alloc]init];
    woview.oldDictionary=diction;
    [diction release];
    [self.navigationController pushViewController:woview animated:YES];
    [woview release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
    navigationLabel.text=@"评论列表";
    [navigation addSubview:navigationLabel];
    [navigationLabel release];
    UIButton* rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBut.frame = CGRectMake(Screen_Width-52, KUIOS_7(7), 45, 30.5);
    rightBut.titleLabel.font=[UIFont systemFontOfSize:13];
    [rightBut setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"钮" ofType:@"png"]] forState:UIControlStateNormal];
    [rightBut setTitle:@"评论" forState:UIControlStateNormal];
    [rightBut addTarget:self action:@selector(PLMenth) forControlEvents:UIControlEventTouchUpInside];
    [navigation addSubview:rightBut];
    _uitable = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, KUIOS_7(44), Screen_Width, Screen_Height-20-44) pullingDelegate:(id<PullingRefreshTableViewDelegate>)self];
    _uitable.backgroundColor = [UIColor clearColor];
    _uitable.delegate = self;
    _uitable.dataSource = self;
    _uitable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_uitable];
    [_uitable release];
    _uitable.rowHeight=70;
}
- (void)PLMenth
{
    (@"%@",self.oldDictionary);
    PlViewController * pLView=[[PlViewController alloc]init];
    pLView.idString=[self.oldDictionary valueForKey:@"id"];
    [self presentModalViewController:pLView animated:NO];
    [pLView release];
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
    [self.oldDictionary setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [self analyUrl];
}
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    page++;
    [self.oldDictionary setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];

    [self analyUrl];
}

- (void)backup
{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
