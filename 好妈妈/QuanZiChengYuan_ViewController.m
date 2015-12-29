//
//  QuanZiChengYuan_ViewController.m
//  好妈妈
//
//  Created by liuguozhu on 17/9/13.
//  Copyright (c) 2013 1510Cloud. All rights reserved.
//

#import "QuanZiChengYuan_ViewController.h"
#import "QzcyCell.h"
#import "WoViewController.h"
@interface QuanZiChengYuan_ViewController ()

@end

@implementation QuanZiChengYuan_ViewController
@synthesize oldDictionary;
@synthesize dataArray;
@synthesize tishiView;
@synthesize dataDictionary;
- (void)dealloc
{
    [dataDictionary release];
    [dataArray release];
    [tishiView release];
    [oldDictionary release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        page=1;
        self.dataArray=[[[NSMutableArray alloc]initWithCapacity:1] autorelease];

        self.dataDictionary=[[[NSMutableDictionary alloc]initWithCapacity:1] autorelease];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    navigationLabel.text=[self.oldDictionary valueForKey:@"Title"];
    [navigation addSubview:navigationLabel];
    [navigationLabel release];
    
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(5, KUIOS_7(7), 51, 33);
    [back setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backup) forControlEvents:UIControlEventTouchUpInside];
    [navigation addSubview:back];
   
    UIButton* rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBut.frame = CGRectMake(Screen_Width-52, KUIOS_7(7), 47, 30);
    [rightBut setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"钮" ofType:@"png"]] forState:UIControlStateNormal];
    [rightBut addTarget:self action:@selector(RightMenth:) forControlEvents:UIControlEventTouchUpInside];
    rightBut.titleLabel.font=[UIFont systemFontOfSize:14];
    [rightBut setTitle:@"按位置" forState:UIControlStateNormal];
    [navigation addSubview:rightBut];
    
    _uitable = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, KUIOS_7(44), Screen_Width, Screen_Height-20-44) pullingDelegate:(id<PullingRefreshTableViewDelegate>)self];
    _uitable .reachedTheEnd  = NO;
    _uitable.backgroundColor = [UIColor clearColor];
    _uitable.delegate = self;
    _uitable.dataSource = self;
    _uitable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_uitable];
    [_uitable release];
    _uitable.rowHeight=71.5;
    if (ISIPAD) {
        _uitable.rowHeight=71.5*1.4;

    }

    [self.dataArray removeAllObjects];
    self.tishiView=[TishiView tishiViewMenth];
    [self.view addSubview:self.tishiView];
    page=1;
    _uitable.contentOffset=CGPointMake(0, 0);
    NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
    [self.dataDictionary setValue:[self.oldDictionary valueForKey:@"id"] forKey:@"cid"];
    [self.dataDictionary setValue:[userDic valueForKey:@"uid"] forKey:@"uid"];
    [self.dataDictionary setValue:[userDic valueForKey:@"token"] forKey:@"token"];
    [self.dataDictionary setValue:@"0" forKey:@"type"];
    [self.dataDictionary setValue:@"http://apptest.mum360.com/web/home/index/circlemember" forKey:@"aUrl"];
    [self.dataDictionary setValue:@"http://apptest.mum360.com/web/home/index/circlemember" forKey:@"aUrl1"];
    [self.dataDictionary setValue:@"yuanzichengyuan" forKey:@"controllername"];
    [self.dataDictionary setValue:[self.oldDictionary valueForKey:@"lat"] forKey:@"lat"];
    [self.dataDictionary setValue:[self.oldDictionary valueForKey:@"lng"] forKey:@"lng"];
    [self.dataDictionary setValue:@"15" forKey:@"limit"];
    [self.dataDictionary setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [self analyUrl:self.dataDictionary];
}
- (void)analyUrl:(NSMutableDictionary *)urlString
{
    _uitable.userInteractionEnabled=NO;
    [self.tishiView StartMenth];
    if (analysis) {
    [analysis CancelMenthrequst];
    }
    NSLog(@"%@",urlString);
    NSURL * aUrl=[[NSURL alloc]initWithString:[urlString valueForKey:@"aUrl"]];
    analysis=[[AnalysisClass alloc]initWithIdentifier:aUrl DataName:nil ControllerName:[urlString valueForKey:@"controllername"] delegate:self];
    [aUrl release];
    [analysis PostMenth:urlString];
    
}
- (void)Asihttp:(AnalysisClass *)asi DataArray:(NSMutableDictionary *)array
{
    _uitable.userInteractionEnabled=YES;

    [self.tishiView StopMenth];
    if ([asi.ControllerName isEqualToString:@"yuanzichengyuan"]) {
        
    
    if ([[array valueForKey:asi.ControllerName] count]) {
        
    [self.dataArray addObjectsFromArray:[array valueForKey:asi.ControllerName]];
    }
    else
    {
        [_uitable tableViewDidFinishedLoading];
        _uitable .reachedTheEnd  = YES;
    }
   
    }
    else
    {
        if ([[[array valueForKey:asi.ControllerName] valueForKey:@"code"] intValue]) {
            if ([asi.ControllerName isEqualToString:@"guanzhu"]) {
                [[self.dataArray objectAtIndex:guanzhuNum] setValue:@"0" forKey:@"flag"];
            }
            else
            {
                [[self.dataArray objectAtIndex:guanzhuNum] setValue:@"1" forKey:@"flag"];

            }
        }

        NSLog(@"array  %@",array);
        
    }
    [_uitable reloadData];
    [_uitable tableViewDidFinishedLoading];
    [asi release];
    analysis=nil;

}
- (void)RightMenth:(UIButton *)sender
{
    page=1;
    [self.dataDictionary setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];

    [self.dataArray removeAllObjects];
     _uitable .reachedTheEnd  = NO;
    [_uitable setContentOffset:CGPointMake(0, 0)animated:YES];
    [self.dataDictionary setValue:@"yuanzichengyuan" forKey:@"controllername"];
    [self.dataDictionary setValue:[self.dataDictionary objectForKey:@"aUrl1"] forKey:@"aUrl"];
        if ([sender.titleLabel.text isEqualToString:@"默认"]) {
        [sender setTitle:@"按位置" forState:UIControlStateNormal];
        [self.dataDictionary setObject:@"0" forKey:@"type"];
    }
    else
    {
        [sender setTitle:@"默认" forState:UIControlStateNormal];
        [self.dataDictionary setObject:@"1" forKey:@"type"];
    }
    
    [self analyUrl:self.dataDictionary];
}
- (void)backup
{
    [self.navigationController popViewControllerAnimated:YES];
}
//-(void)memberSort
//{
//  if (isSort == YES) {
//    NSLog(@"按经验");
//    [memberSort setImage:[UIImage imageNamed:@"002_23.png"] forState:UIControlStateNormal];
//  }
//  if (isSort == NO) {
//    NSLog(@"按位置");
////    [memberSort setImage:[UIImage imageNamed:@"002_23.png"] forState:UIControlStateNormal];
//  }
//  isSort = !isSort;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId=@"ID123";
    QzcyCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
  if (cell == nil) {
   cell = [[[QzcyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
  }
    if (self.dataArray.count>indexPath.row) {
        
    cell.mainImageView.urlString=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"icon"];
    cell.titleLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"name"];
    int titleLengh=cell.titleLabel.text.length*16>160?160:cell.titleLabel.text.length*16;
    cell.titleLabel.frame=CGRectMake(72.5, 6, titleLengh, 20);
    cell.timeLabel.frame=CGRectMake(cell.titleLabel.frame.origin.x+cell.titleLabel.frame.size.width+5, cell.titleLabel.frame.origin.y+5, 80, 13);
    cell.timeLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"status"];
    cell.subLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"sign"];
    cell.qzLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"approvalnum"];
    cell.gzLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"attentions"];
    cell.fsLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"fans"];
    cell.scLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"collection"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.cellButton.tag=indexPath.row;
        [cell.cellButton addTarget:self action:@selector(CellButtonMenth:) forControlEvents:UIControlEventTouchUpInside];
        if ([[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"flag"] intValue]) {
            
            [cell.guanzhuButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"已关注" ofType:@"png"]] forState:UIControlStateNormal];
            cell.guanzhuButton.opaque=NO;
        }
        else
        {
            [cell.guanzhuButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"关注" ofType:@"png"]] forState:UIControlStateNormal];
            cell.guanzhuButton.opaque=YES;
        }
        
        cell.guanzhuButton.tag=indexPath.row;
        [cell.guanzhuButton addTarget:self action:@selector(GuanZhuMenth:) forControlEvents:UIControlEventTouchUpInside];
        if ([[self.dataDictionary valueForKey:@"uid"] intValue]==[[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"id"] intValue]) {
            cell.guanzhuButton.hidden=YES;
        }
        else
        {
            cell.guanzhuButton.hidden=NO;
        }
    }
    if (ISIPAD) {
        cell.titleLabel.frame=CGRectMake(cell.titleLabel.frame.origin.x*1.4, cell.titleLabel.frame.origin.y*1.4, cell.titleLabel.frame.size.width*1.4, cell.titleLabel.frame.size.height*1.4);
        
        cell.timeLabel.frame=CGRectMake(cell.timeLabel.frame.origin.x*1.4, cell.timeLabel.frame.origin.y, cell.subLabel.frame.size.width*1.4, cell.subLabel.frame.size.height*1.4);

    }
    return cell;
}
- (void)GuanZhuMenth:(UIButton *)sender
{
    guanzhuNum=sender.tag;
    [self.dataDictionary setValue:[[self.dataArray objectAtIndex:sender.tag] valueForKey:@"id"] forKey:@"targetid"];
    if (sender.opaque) {
        [self.dataDictionary setValue:@"quxiaoguanzhu" forKey:@"controllername"];
        [self.dataDictionary setValue:@"http://apptest.mum360.com/web/home/index/addfriend" forKey:@"aUrl"];
        [self analyUrl:self.dataDictionary];

    }
    else
    {
        UIAlertView * alertview=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"取消关注将扣除5个积分，您确定吗？" delegate:self cancelButtonTitle:@"取 消" otherButtonTitles:@"确定", nil];
        [alertview show];
        [alertview release];
        
      
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        [self.dataDictionary setValue:@"guanzhu" forKey:@"controllername"];
        
        [self.dataDictionary setValue:@"http://apptest.mum360.com/web/home/index/deletefriend" forKey:@"aUrl"];
        [self analyUrl:self.dataDictionary];
    }
}
- (void)CellButtonMenth:(UIButton *)sender
{
    NSMutableDictionary * diction=[[NSMutableDictionary alloc]initWithCapacity:1];
    [diction addEntriesFromDictionary:[self.dataArray objectAtIndex:sender.tag]];
    [diction setObject:@"YES" forKey:@"bool"];
    [diction setValue:@"0" forKey:@"type"];
    WoViewController * woview=[[WoViewController alloc]init];
    woview.oldDictionary=diction;
    [diction release];
    [self.navigationController pushViewController:woview animated:YES];
    [woview release];

}
- (void)viewWillDisappear:(BOOL)animated
{
    if (analysis) {
      [analysis CancelMenthrequst];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hidesTabBar" object:nil];
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
    [self.dataDictionary setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    _uitable .reachedTheEnd  = NO;
    [self.dataDictionary setValue:@"yuanzichengyuan" forKey:@"controllername"];
    [self.dataDictionary setValue:[self.dataDictionary objectForKey:@"aUrl1"] forKey:@"aUrl"];
    [self analyUrl:self.dataDictionary];
}



- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    page++;
    [self.dataDictionary setValue:@"yuanzichengyuan" forKey:@"controllername"];
    [self.dataDictionary setValue:[self.dataDictionary objectForKey:@"aUrl1"] forKey:@"aUrl"];
    [self.dataDictionary setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [self analyUrl:self.dataDictionary];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
