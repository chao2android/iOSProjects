//
//  ShouCangViewController.m
//  好妈妈
//
//  Created by iHope on 13-10-15.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "ShouCangViewController.h"
#import "TishiView.h"
#import "newCell.h"
#import "WoViewController.h"
#import "ImageTextLabel.h"
#import "contentViewController.h"
@interface ShouCangViewController ()

@end

@implementation ShouCangViewController
@synthesize tishiView;
@synthesize dataArray,oldDictionary;
- (void)dealloc
{
    [dataArray release];
    [oldDictionary release];
    [tishiView release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tishiView=[TishiView tishiViewMenth];
        [self.view addSubview:self.tishiView];
        self.dataArray=[[[NSMutableArray alloc]initWithCapacity:1] autorelease];

        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.dataArray removeAllObjects];
    
    [self analyUrl:self.oldDictionary];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hidesTabBar" object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    if (analysis) {
        [analysis CancelMenthrequst];
        analysis=nil;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayTabBar" object:nil];
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
    navigationLabel.text=@"收藏";
    [navigation addSubview:navigationLabel];
    [navigationLabel release];
    
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(5, KUIOS_7(7), 51, 33);
    [back setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backup) forControlEvents:UIControlEventTouchUpInside];
    [navigation addSubview:back];
    
    _uitable = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, KUIOS_7(44), Screen_Width, Screen_Height-20-44) pullingDelegate:(id<PullingRefreshTableViewDelegate>)self];
    _uitable.backgroundColor = [UIColor clearColor];
    _uitable.delegate = self;
    _uitable.dataSource = self;
    _uitable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_uitable];
    [_uitable release];
    _uitable.rowHeight=54;
    if (ISIPAD) {
        _uitable.rowHeight=54*1.4;
    }
}
- (void)backup
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)analyUrl:(NSMutableDictionary *)urlString
{
    [self.tishiView StartMenth];
    if (analysis) {
        [analysis CancelMenthrequst];
    }
    _uitable.userInteractionEnabled=NO;
    NSURL * aUrl=[[NSURL alloc]initWithString:@"http://apptest.mum360.com/web/home/index/collectionlist"];
    analysis=[[AnalysisClass alloc]initWithIdentifier:aUrl DataName:Nil ControllerName:@"shoucangcontroller" delegate:self];
    [aUrl release];
    [analysis PostMenth:urlString];
    
}
- (void)Asihttp:(AnalysisClass *)asi DataArray:(NSMutableDictionary *)array
{
    _uitable.userInteractionEnabled=YES;
    [self.tishiView StopMenth];
    if ([[array valueForKey:asi.ControllerName] count]) {
        
    
    [self.dataArray addObjectsFromArray:[array valueForKey:asi.ControllerName]];
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

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    newCell* cell=[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell==nil) {

    cell = [[[newCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"] autorelease];
      }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (self.dataArray.count>indexPath.row) {
        
        NSDictionary * celldic=[self.dataArray objectAtIndex:indexPath.row];
        
        cell.mainImageView.urlString=[celldic valueForKey:@"icon"];
        cell.mainImageView.tag=indexPath.row;
        [cell.mainImageView addTarget:self action:@selector(Gerenzhongxin:) forControlEvents:UIControlEventTouchUpInside];
        if (cell.titleLabel) {
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            [cell.titleLabel removeFromSuperview];
            cell.titleLabel = nil;
            [pool release];
        }
        cell.titleLabel=[[[ImageTextLabel alloc]initWithFrame:CGRectMake(53, 8, [[celldic valueForKey:@"title"] length]*16, 8)] autorelease];
        cell.titleLabel.textColor=[UIColor blackColor];
        cell.titleLabel.hangshu=YES;
        [cell.titleLabel LoadContent:[celldic valueForKey:@"title"]];
        int titSize=[[celldic valueForKey:@"title"] length]*16>220?220:[[celldic valueForKey:@"title"] length]*16;
        cell.titleLabel.frame=CGRectMake(53, 8, titSize, 20);
        cell.titleLabel.backgroundColor=[UIColor clearColor];
        [cell.backImageView addSubview:cell.titleLabel];
        cell.tupianImageView.frame=CGRectMake(cell.titleLabel.frame.size.width+cell.titleLabel.frame.origin.x+5, cell.titleLabel.frame.origin.y+3, 17.5, 13);
        if ([[celldic valueForKey:@"image"] intValue])
        {
            cell.tupianImageView.hidden=NO;
            
        }
        cell.areaLabel.text=[celldic valueForKey:@"name"];
        cell.timeLabel.text=[celldic valueForKey:@"status"];
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
        }
        
    }
    if (ISIPAD)
    {
        cell.titleLabel.frame=CGRectMake(cell.titleLabel.frame.origin.x*1.4, cell.titleLabel.frame.origin.y*1.4, cell.titleLabel.frame.size.width*1.4, cell.titleLabel.frame.size.height*1.4);
        cell.tupianImageView.frame=CGRectMake(cell.titleLabel.frame.size.width+cell.titleLabel.frame.origin.x+5, cell.titleLabel.frame.origin.y+3, 17.5, 13);

    }
    return cell;


}
- (void)MainImageMenth:(AsyncImageView *)sender
{
    NSMutableDictionary * diction=[[NSMutableDictionary alloc]initWithCapacity:1];
    [diction setValue:[[self.dataArray objectAtIndex:sender.tag] valueForKey:@"uid"] forKey:@"id"];
    [diction setObject:@"YES" forKey:@"bool"];
    [diction setValue:@"0" forKey:@"type"];
    WoViewController * woview=[[WoViewController alloc]init];
    woview.oldDictionary=diction;
    [diction release];
    [self.navigationController pushViewController:woview animated:YES];
    [woview release];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    contentViewController *ctrl = [[contentViewController alloc]init];
    ctrl.contentID = self.dataArray[indexPath.row][@"id"];
    [self.navigationController pushViewController:ctrl animated:YES];
    [ctrl release];

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

    _uitable .reachedTheEnd  = NO;
    [self analyUrl:self.oldDictionary];
}
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    page++;
    [self.oldDictionary setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];

    [self analyUrl:self.oldDictionary];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
