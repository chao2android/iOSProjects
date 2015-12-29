//
//  JingPinViewController.m
//  好妈妈
//
//  Created by iHope on 13-9-25.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "JingPinViewController.h"
#import "JingPinCell.h"
@interface JingPinViewController ()

@end

@implementation JingPinViewController
@synthesize dataArray;
- (void)dealloc
{
    self.dataArray=nil;
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
    navigationLabel.text=@"精品推荐";
    [navigation addSubview:navigationLabel];
    [navigationLabel release];
    
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(5, KUIOS_7(7), 51, 33);
    [back setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backup) forControlEvents:UIControlEventTouchUpInside];
    [navigation addSubview:back];
    
    myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, KUIOS_7(44), Screen_Width, Screen_Height-20-44)];
    myTableView.dataSource=self;
    myTableView.delegate=self;
    [self.view addSubview:myTableView];
    [myTableView release];
    myTableView.rowHeight=104;
    myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    myTableView.backgroundColor=[UIColor clearColor];
    self.dataArray=[[[NSMutableArray alloc]initWithCapacity:1] autorelease];
    if (analysis) {
        [analysis CancelMenthrequst];
    }
    
    NSURL * aUrl=[[NSURL alloc]initWithString:@"http://apptest.mum360.com/web/home/index/jingpin"];
    analysis=[[AnalysisClass alloc]initWithIdentifier:aUrl DataName:nil ControllerName:@"jingpintuijian" delegate:self];
    [aUrl release];
    [analysis PostMenth:nil];
}
- (void)Asihttp:(AnalysisClass *)asi DataArray:(NSMutableDictionary *)array
{
    [self.dataArray addObjectsFromArray:[array valueForKey:asi.ControllerName]];
    [myTableView reloadData];
    [asi release];
    analysis=nil;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int iline=self.dataArray.count/3;
    if (self.dataArray.count % 3 > 0) {
        iline++;
    }
    return  iline;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *CellIdentifier=@"cell";
    
        JingPinCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[JingPinCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
       int curIndex=indexPath.row*3;
        cell.iconImageView1.urlString=[[self.dataArray objectAtIndex:curIndex] valueForKey:@"image"];
    cell.iconImageView1.tag=curIndex;
    [cell.iconImageView1 addTarget:self action:@selector(AsyImageManth:) forControlEvents:UIControlEventTouchUpInside];
        cell.titleLabel1.text=[[self.dataArray objectAtIndex:curIndex] valueForKey:@"name"];
    curIndex++;
    
    if (curIndex > self.dataArray.count-1) {
        cell.iconImageView2.alpha=0.0;
        cell.titleLabel2.alpha=0.0;
    }else{
        cell.iconImageView2.urlString=[[self.dataArray objectAtIndex:curIndex] valueForKey:@"image"];
        cell.iconImageView2.tag=curIndex;
        [cell.iconImageView2 addTarget:self action:@selector(AsyImageManth:) forControlEvents:UIControlEventTouchUpInside];
        cell.titleLabel2.text=[[self.dataArray objectAtIndex:curIndex] valueForKey:@"name"];
        curIndex++;
    }
    if (curIndex>self.dataArray.count-1) {
        cell.iconImageView3.alpha=0.0;
        cell.titleLabel3.alpha=0.0;
    }
    else
    {
        cell.iconImageView3.urlString=[[self.dataArray objectAtIndex:curIndex] valueForKey:@"image"];
        cell.iconImageView3.tag=curIndex;
        [cell.iconImageView3 addTarget:self action:@selector(AsyImageManth:) forControlEvents:UIControlEventTouchUpInside];
        cell.titleLabel3.text=[[self.dataArray objectAtIndex:curIndex] valueForKey:@"name"];
    }

    return cell;
}
- (void)AsyImageManth:(AsyncImageView *)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[self.dataArray objectAtIndex:sender.tag] valueForKey:@"download"]]];
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
