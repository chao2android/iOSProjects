//
//  SiXinViewController.m
//  好妈妈
//
//  Created by iHope on 13-9-27.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "SiXinViewController.h"
#import "TuijianquanziCell.h"
#import "ChatListViewController.h"
@interface SiXinViewController ()

@end

@implementation SiXinViewController
@synthesize dataArray;
- (void)dealloc
{
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
- (void)viewWillAppear:(BOOL)animated
{
    tishinum=0;
    [myTableView reloadData];
   
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
    navigationLabel.text=@"消息提示";
    [navigation addSubview:navigationLabel];
    [navigationLabel release];
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(5, KUIOS_7(7), 51, 33);
    [back setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backup) forControlEvents:UIControlEventTouchUpInside];
    [navigation addSubview:back];
    self.dataArray=[[[NSMutableArray alloc]initWithCapacity:1] autorelease];
    myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, KUIOS_7(44), Screen_Width, Screen_Height-20-44)];
    myTableView.delegate=self;
    myTableView.dataSource=self;
    myTableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:myTableView];
    [myTableView release];
    myTableView.rowHeight=55;
    if (ISIPAD) {
        myTableView.rowHeight=55*1.4;
    }
    myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tishiView=[TishiView tishiViewMenth];
    [self.view addSubview:tishiView];
    [tishiView StartMenth];
    NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
    NSMutableDictionary * urlString=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[userDic valueForKey:@"uid"],@"uid",[userDic valueForKey:@"token"],@"token", nil];
    
    NSURL * aUrl=[[NSURL alloc]initWithString:@"http://apptest.mum360.com/web/home/index/messagenumlist"];
    analysis=[[AnalysisClass alloc]initWithIdentifier:aUrl DataName:nil ControllerName:@"tishi" delegate:self];
    [aUrl release];
    [analysis PostMenth:urlString];
    [urlString release];
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TuijianquanziCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cellid"];
    if (cell==nil) {
        cell=[[[TuijianquanziCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"] autorelease];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (self.dataArray.count>indexPath.row)
    {
        [cell.mainImageView addTarget:self action:@selector(MainImageMenth:) forControlEvents:UIControlEventTouchUpInside];
        cell.mainImageView.tag=indexPath.row;
    
        cell.mainImageView.urlString=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"icon"];
        cell.mainImageView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"001_默认" ofType:@"png"]]];
        [cell.titleLabel LoadContent:[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"name"]];
        if (cell.synopsisLabel) {
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            [cell.synopsisLabel removeFromSuperview];
            cell.synopsisLabel = nil;
            [pool release];
        }
        
        cell.synopsisLabel=[[[ImageTextLabel alloc]initWithFrame:CGRectMake(58, 33, Screen_Width-130, 10)] autorelease];
        cell.synopsisLabel.m_RowHeigh=10;
        cell.synopsisLabel.m_EmoWidth=10;
        cell.synopsisLabel.m_EmoHeight=10;
        cell.synopsisLabel.hangshu=YES;
        cell.synopsisLabel.backgroundColor=[UIColor clearColor];
        cell.synopsisLabel.m_Font=[UIFont systemFontOfSize:10];
        [cell.contentView addSubview:cell.synopsisLabel];
        [cell.synopsisLabel LoadContent:[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"theme"]];
        cell.numLabel.text=[NSString stringWithFormat:@"消息数:  %@",[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"count"]];
        if (tishinum>indexPath.row) {
            cell.tishiImageView.hidden=NO;
        }
        else
        {
            cell.tishiImageView.hidden=YES;
        }
    }
    
    return cell;
}
- (void)AsiMenth:(NSMutableDictionary *)sender
{
    ChatListViewController * siXinController=[[ChatListViewController alloc]init];
    siXinController.oldDictionary=sender;
    [self.navigationController pushViewController:siXinController animated:YES];
    [siXinController release];

}
- (void)MainImageMenth:(AsyncImageView *)sender
{
    NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
    NSMutableDictionary * Dictionary=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[userDic valueForKey:@"uid"],@"uid",[userDic valueForKey:@"token"],@"token",[[self.dataArray objectAtIndex:sender.tag] valueForKey:@"id"],@"targetid",nil];
    [self AsiMenth:Dictionary];
    [Dictionary release];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
    NSMutableDictionary * Dictionary=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[userDic valueForKey:@"uid"],@"uid",[userDic valueForKey:@"token"],@"token",[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"id"],@"targetid",nil];
    [self AsiMenth:Dictionary];
    [Dictionary release];
    
    
}

- (void)Asihttp:(AnalysisClass *)asi DataArray:(NSMutableDictionary *)array
{
    [tishiView StopMenth];
//    if ([[array valueForKey:asi.ControllerName] count]) {
    
    tishinum=[[array valueForKey:asi.ControllerName] count];
    [self.dataArray removeAllObjects];
        NSMutableArray * liaotianArray=[[NSMutableArray alloc]initWithCapacity:1];
    [liaotianArray addObjectsFromArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"liaotian"]];
    for (int i=0; i<liaotianArray.count;)
    {
        int yyyy=0;
        for (int j=0; j<[[[[array valueForKey:asi.ControllerName] reverseObjectEnumerator] allObjects] count]; j++) {
            if ([[[liaotianArray objectAtIndex:i] valueForKey:@"id"] intValue]==[[[[[[array valueForKey:asi.ControllerName] reverseObjectEnumerator] allObjects] objectAtIndex:j] valueForKey:@"id"] intValue]) {
                [liaotianArray removeObjectAtIndex:i];
                yyyy=1;
                break;
            }
        }
        if (!yyyy) {
            i++;
        }
    }
    [liaotianArray addObjectsFromArray:[array valueForKey:asi.ControllerName]];
    [[NSUserDefaults standardUserDefaults] setValue:liaotianArray forKey:@"liaotian"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.dataArray addObjectsFromArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"liaotian"]];
  self.dataArray=[[self.dataArray reverseObjectEnumerator] allObjects];
    [liaotianArray release];
//    }
    [myTableView reloadData];
    [asi release];
    analysis=nil;
}
-(void)sendTextAction:(NSString *)inputText{
    NSLog(@"sendTextAction%@",inputText);
}
- (void)backup
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)RightMenth
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
