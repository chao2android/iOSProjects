//
//  HaoYouViewController.m
//  好妈妈
//
//  Created by iHope on 13-10-15.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "HaoYouViewController.h"
#import "TishiView.h"
#import "QzcyCell.h"
#import "WoViewController.h"
@interface HaoYouViewController ()

@end

@implementation HaoYouViewController
@synthesize myTableView,tishiView;
@synthesize dataArray,oldDictionary;
@synthesize navigationButton;
@synthesize tiaojianImageView;
- (void)dealloc
{
    [tiaojianImageView release];
    [navigationButton release];
    [dataArray release];
    [oldDictionary release];
    [myTableView release];
    [tishiView release];
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
    if (analysis) {
        [analysis CancelMenthrequst];
        analysis=nil;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayTabBar" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    page=1;
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

   self.navigationButton=[UIButton buttonWithType:UIButtonTypeCustom];
     self.navigationButton.frame=CGRectMake((Screen_Width-200)/2, KUIOS_7(2), 200, 40);
     self.navigationButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:22];
     self.navigationButton.titleLabel.textColor=[UIColor whiteColor];
    [ self.navigationButton addTarget:self action:@selector(NavigationbuttonMenth) forControlEvents:UIControlEventTouchUpInside];
    [ self.navigationButton setTitle:[self.oldDictionary valueForKey:@"title"] forState:UIControlStateNormal];
    [navigation addSubview: self.navigationButton];
    

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

    self.tishiView=[TishiView tishiViewMenth];
    [self.view addSubview:self.tishiView];
    self.dataArray=[[[NSMutableArray alloc]initWithCapacity:1] autorelease];
    [self.oldDictionary setValue:[self.oldDictionary valueForKey:@"targetid"] forKey:@"targetid1"];
    [self.oldDictionary setValue:[self.oldDictionary valueForKey:@"aUrl1"] forKey:@"aUrl"];
    [self.oldDictionary setValue:@"haoyouleibiao" forKey:@"oldName"];
    [self analyUrl:self.oldDictionary];
    self.tiaojianImageView=[[[UIImageView alloc]initWithFrame:CGRectMake((Screen_Width-60)/2, KUIOS_7(38), 80, 70)] autorelease];
    self.tiaojianImageView.userInteractionEnabled=YES;
    self.tiaojianImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"003_17" ofType:@"png"]];
    self.tiaojianImageView.hidden=YES;
    [self.view addSubview:self.tiaojianImageView];
    NSLog(@"%@",self.oldDictionary);
    for (int i=0; i<2; i++) {
        UIButton * tiaojianButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [tiaojianButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        tiaojianButton.titleLabel.font=[UIFont systemFontOfSize:12];
        tiaojianButton.tag=i+1;
        [tiaojianButton addTarget:self action:@selector(TiaojianButtonMenth:) forControlEvents:UIControlEventTouchUpInside];
        tiaojianButton.frame=CGRectMake(5, 15+28*i, 70, 20);
        if (i==0)
        {
            [tiaojianButton setTitle:@"粉丝" forState:UIControlStateNormal];
        }
        else
        {
            [tiaojianButton setTitle:@"关注" forState:UIControlStateNormal];
        }
        if ([[self.oldDictionary valueForKey:@"type"] intValue]-1==i) {
            [tiaojianButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"003_18" ofType:@"png"]] forState:UIControlStateNormal];
 
        }

        [self.tiaojianImageView addSubview:tiaojianButton];
    }

}
- (void)TiaojianButtonMenth:(UIButton *)sender
{
    NSLog(@"%@  %d",self.oldDictionary,sender.tag);
    NSString * titleString=[[NSString stringWithFormat:@"%@",navigationButton.titleLabel.text] substringToIndex:[navigationButton.titleLabel.text length]-2];
    if (sender.tag==1) {
        
        [navigationButton setTitle:[NSString stringWithFormat:@"%@粉丝",titleString] forState:UIControlStateNormal];
    }
    else
    {
        [navigationButton setTitle:[NSString stringWithFormat:@"%@关注",titleString]  forState:UIControlStateNormal];
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
    [self.oldDictionary setValue:[NSString stringWithFormat:@"%d",sender.tag] forKey:@"type"];
    [self.oldDictionary setValue:[self.oldDictionary valueForKey:@"aUrl1"] forKey:@"aUrl"];
    [self.oldDictionary setValue:@"haoyouleibiao" forKey:@"oldName"];
    [self analyUrl:self.oldDictionary];
    self.tiaojianImageView.hidden=YES;
}
- (void)NavigationbuttonMenth
{
    self.tiaojianImageView.hidden=!self.tiaojianImageView.hidden;
}
- (void)backup
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)analyUrl:(NSMutableDictionary *)urlString
{
    NSLog(@"urlString  %@",urlString);
    _uitable.userInteractionEnabled=NO;
    [self.tishiView StartMenth];
    if (analysis) {
        [analysis CancelMenthrequst];
    }
    NSURL * aUrl=[[NSURL alloc]initWithString:[self.oldDictionary valueForKey:@"aUrl"]];
    analysis=[[AnalysisClass alloc]initWithIdentifier:aUrl DataName:Nil ControllerName:[self.oldDictionary valueForKey:@"oldName"] delegate:self];
    [aUrl release];
    [analysis PostMenth:urlString];
    
}
- (void)Asihttp:(AnalysisClass *)asi DataArray:(NSMutableDictionary *)array
{
    [self.tishiView StopMenth];
   _uitable.userInteractionEnabled=YES;
    if ([asi.ControllerName isEqualToString:@"haoyouleibiao"]) {
        
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
        
        NSLog(@"%@",[[array valueForKey:asi.ControllerName] valueForKey:@"msg"]);
        if ([[[array valueForKey:asi.ControllerName] valueForKey:@"code"] intValue])
        {
            if ([asi.ControllerName isEqualToString:@"guanzhu"]) {
                [[self.dataArray objectAtIndex:guanzhuNum] setValue:@"0" forKey:@"flag"];
            }
            else
            {
                if ([[self.oldDictionary valueForKey:@"targetid1"] isEqualToString:[self.oldDictionary valueForKey:@"uid"]]&&[[self.oldDictionary valueForKey:@"type"] intValue]==1)
                {
                    [[self.dataArray objectAtIndex:guanzhuNum] setValue:@"2" forKey:@"flag"];
                }
                else
                {

                [[self.dataArray objectAtIndex:guanzhuNum] setValue:@"1" forKey:@"flag"];
                }
                
            }
        }

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
    QzcyCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ID123"];
    if (cell == nil) {
        cell = [[[QzcyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID123"] autorelease];
    }
    if (self.dataArray.count>indexPath.row)
    {
    cell.mainImageView.urlString=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"icon"];
    cell.titleLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"name"];
    cell.timeLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"status"];
    cell.subLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"sign"];
    cell.qzLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"approvalnum"];
    cell.gzLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"attentions"];
    cell.fsLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"fans"];
    cell.scLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"collection"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.cellButton.tag=indexPath.row;
        NSLog(@"%@  %@",[self.oldDictionary valueForKey:@"targetid1"],[self.oldDictionary valueForKey:@"uid"]);
    if ([[self.oldDictionary valueForKey:@"targetid1"] isEqualToString:[self.oldDictionary valueForKey:@"uid"]])
    {
        NSLog(@"%d",[[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"flag"] intValue]);
        if ([[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"flag"] intValue]==2)
        {
             [cell.guanzhuButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"已关注1" ofType:@"png"]] forState:UIControlStateNormal];
                
            
        }
        else
        {
            
            [cell.guanzhuButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"关注1" ofType:@"png"]] forState:UIControlStateNormal];
            if ([navigationButton.titleLabel.text hasSuffix:@"粉丝"]) {
                [cell.guanzhuButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"关注2" ofType:@"png"]] forState:UIControlStateNormal];

            }
        }
        if ([[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"flag"] intValue])
        {
            cell.guanzhuButton.opaque=NO;
        }
        else
        {
            cell.guanzhuButton.opaque=YES;
 
        }

    }
    else
    {
        if ([[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"flag"] intValue]) {
                           [cell.guanzhuButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"已关注" ofType:@"png"]] forState:UIControlStateNormal];
                       cell.guanzhuButton.opaque=NO;
        }
        else
        {
                           [cell.guanzhuButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"关注" ofType:@"png"]] forState:UIControlStateNormal];
            
        
            cell.guanzhuButton.opaque=YES;
        }

        
    }
    
    cell.guanzhuButton.tag=indexPath.row;
        NSLog(@"%@  %@  %d",[self.oldDictionary valueForKey:@"targetid1"],[self.oldDictionary valueForKey:@"uid"],[[self.oldDictionary valueForKey:@"type"] intValue]);
        if ([[self.oldDictionary valueForKey:@"targetid1"] isEqualToString:[self.oldDictionary valueForKey:@"uid"]]&&[[self.oldDictionary valueForKey:@"type"] intValue]==2)
        {
            
            [cell.guanzhuButton addTarget:self action:@selector(CellButtonMenth:) forControlEvents:UIControlEventTouchUpInside];

        }
        else
        {
            [cell.guanzhuButton addTarget:self action:@selector(GuanZhuMenth:) forControlEvents:UIControlEventTouchUpInside];

            
        }
    [cell.cellButton addTarget:self action:@selector(CellButtonMenth:) forControlEvents:UIControlEventTouchUpInside];
        if ([[self.oldDictionary valueForKey:@"uid"] intValue]==[[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"id"] intValue]) {
            cell.guanzhuButton.hidden=YES;
        }
        else
        {
            cell.guanzhuButton.hidden=NO;
        }
    }
    return cell;
    
}
- (void)GuanZhuMenth:(UIButton *)sender
{
    guanzhuNum=sender.tag;
    NSLog(@"dataArray  %@",[self.dataArray objectAtIndex:sender.tag]);
    [self.oldDictionary setValue:[[self.dataArray objectAtIndex:sender.tag] valueForKey:@"id"] forKey:@"targetid"];
    if (sender.opaque) {
        [self.oldDictionary setValue:@"quxiaoguanzhu" forKey:@"oldName"];
        [self.oldDictionary setValue:@"http://apptest.mum360.com/web/home/index/addfriend" forKey:@"aUrl"];
        [self analyUrl:self.oldDictionary];

    }
    else
    {
        UIAlertView * alertview=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"取消关注将扣除5个积分，您确定吗？" delegate:self cancelButtonTitle:@"取 消" otherButtonTitles:@"确定", nil];
        alertview.tag=0;
        [alertview show];
        [alertview release];

        
        
    }
    NSLog(@"%@",self.oldDictionary);
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        [self.oldDictionary setValue:@"guanzhu" forKey:@"oldName"];
        
        [self.oldDictionary setValue:@"http://apptest.mum360.com/web/home/index/deletefriend" forKey:@"aUrl"];
        [self analyUrl:self.oldDictionary];

    }
}
- (void)CellButtonMenth:(UIButton *)sender
{
    NSLog(@"%d %@",sender.tag,[self.dataArray objectAtIndex:sender.tag]);
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
    [self.oldDictionary setValue:@"haoyouleibiao" forKey:@"oldName"];
    [self.oldDictionary setValue:[self.oldDictionary objectForKey:@"aUrl1"] forKey:@"aUrl"];
    [self analyUrl:self.oldDictionary];
}



- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    page++;
    [self.oldDictionary setValue:@"haoyouleibiao" forKey:@"oldName"];
    [self.oldDictionary setValue:[self.oldDictionary objectForKey:@"aUrl1"] forKey:@"aUrl"];
    [self.oldDictionary setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [self analyUrl:self.oldDictionary];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
