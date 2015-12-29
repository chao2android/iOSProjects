//
//  HtqbViewController.m
//  好妈妈
//
//  Created by iHope on 13-9-30.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "HtqbViewController.h"
#import "HuatiCell.h"
#import "TishiView.h"
#import "ImageTextLabel.h"
#import "ZuiXinFaBu_ViewController.h"
#import "contentViewController.h"
@interface HtqbViewController ()

@end

@implementation HtqbViewController
@synthesize myTableView;
@synthesize oldDictionary,dataArray;
@synthesize navigationButton,tiaojianImageView;
- (void)dealloc
{
    [tiaojianImageView release];
    [navigationButton release];
    [dataArray release];
    [oldDictionary release];
    [myTableView release];
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
- (void)NavigationbuttonMenth
{
    self.tiaojianImageView.hidden=!self.tiaojianImageView.hidden;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@",self.oldDictionary);
    page=1;

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
    self.navigationButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.navigationButton.frame=CGRectMake((Screen_Width-100)/2, KUIOS_7(2), 100, 40);
    self.navigationButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:22];
    
    self.navigationButton.titleLabel.textColor=[UIColor whiteColor];
    [ self.navigationButton addTarget:self action:@selector(NavigationbuttonMenth) forControlEvents:UIControlEventTouchUpInside];
    [ self.navigationButton setTitle:[self.oldDictionary valueForKey:@"nvTitle"] forState:UIControlStateNormal];
    [navigation addSubview: self.navigationButton];
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(5, KUIOS_7(7), 51, 33);
    [back setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backup) forControlEvents:UIControlEventTouchUpInside];
    [navigation addSubview:back];
    NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
    if ([[userDic valueForKey:@"uid"] intValue]==[[self.oldDictionary valueForKey:@"targetid"] intValue]) {
        
    
//    rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBut.frame = CGRectMake(Screen_Width-52, 7, 47, 30);
//    [rightBut setBackgroundImage:[UIImage imageNamed:@"钮.png"] forState:UIControlStateNormal];
//    [rightBut addTarget:self action:@selector(RightMenth:) forControlEvents:UIControlEventTouchUpInside];
//    [rightBut setTitle:@"编辑" forState:UIControlStateNormal];
//    rightBut.tag=1;
//    rightBut.titleLabel.font=[UIFont systemFontOfSize:13];
//    [navigation addSubview:rightBut];
    }
//    if ([navigationButton.titleLabel.text isEqualToString:@"回复"]) {
//        rightBut.hidden=YES;
//    }
    self.dataArray=[[[NSMutableArray alloc]initWithCapacity:1] autorelease];
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
    [self.oldDictionary setValue:@"http://apptest.mum360.com/web/home/index/themelist" forKey:@"aUrl"];
    [self.oldDictionary setValue:@"huatiquanbu" forKey:@"controname"];
    [self analyUrl:self.oldDictionary];
    self.tiaojianImageView=[[[UIImageView alloc]initWithFrame:CGRectMake((Screen_Width-70)/2, KUIOS_7(38), 70, 80)] autorelease];
    self.tiaojianImageView.userInteractionEnabled=YES;
    self.tiaojianImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"003_17" ofType:@"png"]];
    self.tiaojianImageView.hidden=YES;
    [self.view addSubview:self.tiaojianImageView];
    for (int i=0; i<2; i++) {
        UIButton * tiaojianButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [tiaojianButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        tiaojianButton.titleLabel.font=[UIFont systemFontOfSize:12];
        tiaojianButton.tag=i;
        [tiaojianButton addTarget:self action:@selector(TiaojianButtonMenth:) forControlEvents:UIControlEventTouchUpInside];
        tiaojianButton.frame=CGRectMake(5, 15+28*i, 60, 20);
        if (i==0)
        {
            [tiaojianButton setTitle:@"话题" forState:UIControlStateNormal];
        }
        else
        {
            [tiaojianButton setTitle:@"回复" forState:UIControlStateNormal];
        }
       
        if ([tiaojianButton.titleLabel.text isEqualToString:[self.oldDictionary valueForKey:@"nvTitle"]]) {
            [tiaojianButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"003_18" ofType:@"png"]] forState:UIControlStateNormal];
        }
        [self.tiaojianImageView addSubview:tiaojianButton];
    }
   
}

- (void)RightMenth:(UIButton *)sender
{
    if (sender.tag) {
        [rightBut setTitle:@"完成" forState:UIControlStateNormal];

    }
    else
    {
        [rightBut setTitle:@"编辑" forState:UIControlStateNormal];

    }
    _uitable.editing=sender.tag;
    sender.tag=!sender.tag;
}
- (void)TiaojianButtonMenth:(UIButton *)sender
{
    NSLog(@"%@",[self.tiaojianImageView subviews]);
    if (sender.tag==0) {
        rightBut.hidden=NO;
        [navigationButton setTitle:@"话题" forState:UIControlStateNormal];
    }
    else
    {
        rightBut.hidden=YES;
        [navigationButton setTitle:@"回复" forState:UIControlStateNormal];
    }
    [rightBut setTitle:@"编辑" forState:UIControlStateNormal];
    rightBut.tag=1;
    _uitable.editing=NO;
  
    for (int i=0; i<[[self.tiaojianImageView subviews] count]; i++) {
        if (sender.tag==i) {
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
    [self.oldDictionary setValue:@"http://apptest.mum360.com/web/home/index/themelist" forKey:@"aUrl"];
    [self.oldDictionary setValue:@"huatiquanbu" forKey:@"controname"];

    [self analyUrl:self.oldDictionary];
    self.tiaojianImageView.hidden=YES;
}

- (void)analyUrl:(NSMutableDictionary *)urlString
{
    tishiView=[TishiView tishiViewMenth];
    [self.view addSubview:tishiView];
    NSLog(@"%@",self.oldDictionary);

    [tishiView StartMenth];
    _uitable.userInteractionEnabled=NO;
    NSURL * aUrl=[[NSURL alloc]initWithString:[self.oldDictionary valueForKey:@"aUrl"]];
    analysis=[[AnalysisClass alloc]initWithIdentifier:aUrl DataName:Nil ControllerName:[self.oldDictionary valueForKey:@"controname"] delegate:self];
    [aUrl release];
    [analysis PostMenth:urlString];
    
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
    [self.oldDictionary setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [self.oldDictionary setValue:@"http://apptest.mum360.com/web/home/index/themelist" forKey:@"aUrl"];
    [self.oldDictionary setValue:@"huatiquanbu" forKey:@"controname"];
    [self analyUrl:self.oldDictionary];
}
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    page++;
    [self.oldDictionary setValue:@"http://apptest.mum360.com/web/home/index/themelist" forKey:@"aUrl"];
    [self.oldDictionary setValue:@"huatiquanbu" forKey:@"controname"];
    [self.oldDictionary setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [self analyUrl:self.oldDictionary];
}
- (void)Asihttp:(AnalysisClass *)asi DataArray:(NSMutableDictionary *)array
{

    [tishiView StopMenth];
    _uitable.userInteractionEnabled=YES;
    
    NSLog(@"%@",[array valueForKey:asi.ControllerName]);
    if ([asi.ControllerName isEqualToString:@"huatiquanbu"]) {
        
    
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
    }
    else
    {
        NSLog(@"%@",[[array valueForKey:asi.ControllerName] valueForKey:@"msg"]);
        if ([[[array valueForKey:asi.ControllerName] valueForKey:@"code"] intValue])
        {
        [self.dataArray removeObjectAtIndex:selNum];
        }
        
    }
    [_uitable reloadData];
    [_uitable tableViewDidFinishedLoading];
    [asi release];
    analysis=nil;

    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.oldDictionary setValue:@"http://apptest.mum360.com/web/home/index/deltheme" forKey:@"aUrl"];
    [self.oldDictionary setValue:@"shanchu" forKey:@"controname"];
    [self.oldDictionary setValue:[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"id"] forKey:@"id"];
    [self analyUrl:self.oldDictionary];
    selNum=indexPath.row;
    NSLog(@"%d",indexPath.row);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellString=@"fier";
    HuatiCell * cell=[tableView dequeueReusableCellWithIdentifier:cellString];
    if (cell==nil) {
        cell=[[[HuatiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString] autorelease];
    }
    if (self.dataArray.count>indexPath.row) {
        NSLog(@"%@",[self.dataArray objectAtIndex:indexPath.row]);
      cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell.titleLabel) {
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            [cell.titleLabel removeFromSuperview];
            cell.titleLabel = nil;
            [pool release];
        }
        cell.titleLabel=[[[ImageTextLabel alloc]initWithFrame:CGRectMake(5, 5, 250, 20)] autorelease];
        cell.titleLabel.textColor=[UIColor blackColor];
        cell.titleLabel.backgroundColor=[UIColor clearColor];
        [cell.backImageView addSubview:cell.titleLabel];
        cell.titleLabel.hangshu=YES;

        if ([navigationButton.titleLabel.text isEqualToString:@"回复"]) {

            [cell.titleLabel LoadContent:[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"content"]];
        }
        else
        {

         [cell.titleLabel LoadContent:[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"title"]];
        }
    cell.timeLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"time"];
    cell.qzNameLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"cname"];
    cell.mainImageView.urlString=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"image"];
    cell.mainImageView.tag=indexPath.row;
    [cell.mainImageView addTarget:self action:@selector(MainImageMenth:) forControlEvents:UIControlEventTouchUpInside];
//    cell.mainImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"002_22" ofType:@"png"]];
        if ([navigationButton.titleLabel.text isEqualToString:@"回复"]) {
            cell.contentLabel.frame=CGRectMake(cell.contentLabel.frame.origin.x, cell.contentLabel.frame.origin.y, 180, cell.contentLabel.frame.size.height);
            cell.xingImageView.hidden=YES;
            cell.pinglunImageView.hidden=YES;
            cell.xingLabel.hidden=YES;
            cell.pinglunLabel.hidden=YES;
        }
        else
        {
            cell.xingImageView.hidden=NO;
            cell.pinglunImageView.hidden=NO;
            cell.xingLabel.hidden=NO;
            cell.pinglunLabel.hidden=NO;

       cell.xingLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"approval"];
       cell.pinglunLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"comment"];
        }
    }
    return cell;
}
- (void)MainImageMenth:(AsyncImageView *)sender
{
    ZuiXinFaBu_ViewController* faBuVC = [[ZuiXinFaBu_ViewController alloc]init];
    
    faBuVC.oldDictionary=[self.dataArray objectAtIndex:sender.tag];
    [self.navigationController pushViewController:faBuVC animated:YES];
    [faBuVC release];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",[self.dataArray objectAtIndex:indexPath.row]);

    contentViewController *ctrl = [[contentViewController alloc]init];
    ctrl.contentID = self.dataArray[indexPath.row][@"id"];
    [self.navigationController pushViewController:ctrl animated:YES];
    [ctrl release];
}
- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hidesTabBar" object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayTabBar" object:nil];
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
