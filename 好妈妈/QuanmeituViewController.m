//
//  QuanmeituViewController.m
//  好妈妈
//
//  Created by liuguozhu on 13-10-27.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "QuanmeituViewController.h"
#import "contentViewController.h"

#import "QuanmeituCell.h"

@interface QuanmeituViewController ()

@end

@implementation QuanmeituViewController
- (void)viewDidUnload
{
  [self setStream:nil];
  [super viewDidUnload];
  
}

-(void)dealloc{
  [super dealloc];
  [_muArr release];
  [_tsView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  UIImageView *backgroundIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
  backgroundIV.image =[UIImage imageNamed:@"底.png"];
  [self.view addSubview:backgroundIV ];
  [backgroundIV release];
  
  UIImageView * navigation=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, KUIOS_7(44))];
  navigation.backgroundColor=[UIColor blackColor];
  navigation.userInteractionEnabled=YES;
  navigation.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nav_background" ofType:@"png"]];
  [self.view addSubview:navigation];
  [navigation release];
  
  UIButton * backBut=[UIButton buttonWithType:UIButtonTypeCustom];
  backBut.frame=CGRectMake(5, KUIOS_7(6), 45, 30.5);
  [backBut addTarget:self action:@selector(clicked_backBut) forControlEvents:UIControlEventTouchUpInside];
  [backBut setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"001_4" ofType:@"png"]] forState:UIControlStateNormal];
  [navigation addSubview:backBut];
  
  UILabel *titLab = [[UILabel alloc]initWithFrame:CGRectMake(100, KUIOS_7(0), Screen_Width-200, 44)];
  titLab.text = @"圈美图";
  titLab.textAlignment = 1;
  titLab.backgroundColor = [UIColor clearColor];
  titLab.textColor = [UIColor whiteColor];
  titLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
  [navigation addSubview:titLab];
  [titLab release];
  
  page = 1;
  
  _muArr = [[NSMutableArray alloc]init];
  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"底.png"]];
  
  
  
  
  
  _stream = [[EKStreamView alloc]initWithFrame:CGRectMake(0, KUIOS_7(44), Screen_Width, Screen_Height-64)];
  _stream.delegate = self;
  _stream.scrollsToTop = YES;
  _stream.backgroundColor=[UIColor clearColor];
  _stream.cellPadding = 5.0f;
  _stream.columnPadding = 5.0f;
  
  [self.view addSubview:_stream];
  [_stream release];
  
  [_stream reloadData];
  
  RefreshHeaderView=[[EGORefreshTableHeaderView alloc]initWithFrame:CGRectMake(0, -460, Screen_Width, 460) ];
	RefreshHeaderView.delegate = self;
	[_stream addSubview:RefreshHeaderView];
	[RefreshHeaderView release];
  
  //	4.显示上次刷新时间
	[RefreshHeaderView refreshLastUpdatedDate];

  _tsView  =  [TishiView tishiViewMenth] ;
  [self.view addSubview:_tsView];

  [self loadData];

}

-(void)loadData{
  [footlab setTitle:@"加载中.." forState:UIControlStateNormal];

  [_tsView StartMenth];

   NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
  
  NSMutableDictionary * asiDictiong=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"http://apptest.mum360.com/web/home/index/circleimage",@"aUrl",self.cid,@"cid",[userDic objectForKey:@"uid"],@"uid",[userDic objectForKey:@"token"],@"token",@"20",@"limit",[NSString stringWithFormat:@"%d",page],@"page",@"quanmeitu",@"Controller",nil];
  [self analyUrl:asiDictiong];
  [asiDictiong release];
  

}

- (void)analyUrl:(NSMutableDictionary *)urlString
{
  if (analysis) {
    [analysis CancelMenthrequst];
  }
  
  NSURL * aUrl=[[NSURL alloc]initWithString:[urlString valueForKey:@"aUrl"]];
  analysis=[[AnalysisClass alloc]initWithIdentifier:aUrl DataName:nil ControllerName:[urlString valueForKey:@"Controller"] delegate:self];
  [aUrl release];
  [analysis PostMenth:urlString];
  
}
- (void)Asihttp:(AnalysisClass *)asi DataArray:(NSMutableDictionary *)array
{
  NSDictionary * arr = [array valueForKey:asi.ControllerName];
  if (page == 1) {
    isJiazai = NO;
    [_muArr removeAllObjects];
  }

  if (arr.count < 20) {
    isJiazai = YES;
  }
  

  
  for (NSDictionary *dic in arr) {
    [_muArr addObject:dic];
  }
  
  [_stream reloadData];
  
  [RefreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_stream];

  [activityIndicator stopAnimating];
  
  
  [_tsView StopMenth];
  
}


- (NSInteger)numberOfCellsInStreamView:(EKStreamView *)streamView
{
  return [_muArr count];
}

- (NSInteger)numberOfColumnsInStreamView:(EKStreamView *)streamView
{
  return 3;
}

- (UIView *)streamView:(EKStreamView *)streamView cellAtIndex:(NSInteger)index
{
  static NSString *CellID2 = @"QuanmeituCell";
  
  QuanmeituCell *cell;
  
  cell = (QuanmeituCell *)[streamView dequeueReusableCellWithIdentifier:CellID2];
  
  if (cell == nil) {
    cell = [[QuanmeituCell alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    cell.reuseIdentifier = CellID2;
    
    
  }
  
  
  NSDictionary *dic = _muArr[index];
  cell.picView_.urlString = dic[@"image"];
  cell.picView_.tag = index +1000;
  [cell.picView_ addTarget:self action:@selector(clicked_picView:) forControlEvents:UIControlEventTouchUpInside];
  
  return cell;
}
- (CGFloat)streamView:(EKStreamView *)streamView heightForCellAtIndex:(NSInteger)index
{
  NSDictionary *dic = _muArr[index];
  
  
  int width = [dic[@"width"] intValue];
  int height = [dic[@"height"] intValue];
  
  int viewWidth = (Screen_Width-20)/3;
  
  
  
  return viewWidth * height /width;
  
}
- (UIView *)footerForStreamView:(EKStreamView *)streamView
{
  UIView * footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - _stream.columnPadding * 2, 60)];
  footView.backgroundColor=[UIColor clearColor];
  
  footlab=[UIButton buttonWithType:UIButtonTypeCustom];
  footlab.backgroundColor = [UIColor whiteColor];
  footlab.frame = CGRectMake(5, 10, self.view.frame.size.width - _stream.columnPadding * 2-10, 40);
  [footlab setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
  footlab.titleLabel.font = [UIFont systemFontOfSize:14];
  [footView addSubview:footlab];
  
  activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(50, 20, 20, 20)];
  activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
  [footView addSubview:activityIndicator];
  [activityIndicator startAnimating];
  
  if (isJiazai==YES) {
    [footlab setTitle:@"数据加载完毕" forState:UIControlStateNormal];
    [activityIndicator stopAnimating];
  }else{
    [footlab setTitle:@"点击加载更多" forState:UIControlStateNormal];
    [footlab addTarget:self action:@selector(click_jiazaiBut) forControlEvents:UIControlEventTouchUpInside];
    
  }
  
  return footView;

  
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[RefreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
  
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
  [RefreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

//与scrollViewDidScroll相似，表格拖动就会调用
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view {
	
	return NO;
}

//拖动结束，若达到指定的高度，就会调用，来进行刷新操作
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view {
	
	[self performSelector:@selector(endRefresh) withObject:nil afterDelay:/*2.0*/0];
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view {
	return [NSDate date];	//返回刷新时间
}
- (void)endRefresh {
  page=1;
	[self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}

-(void)click_jiazaiBut{
  [activityIndicator startAnimating];

  page++;
  
  [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
  
}


-(void)clicked_picView:(AsyncImageView*)sender{
  
  NSDictionary *dic = _muArr[sender.tag - 1000];
  contentViewController *ctrl = [[contentViewController alloc]init];
  ctrl.contentID = [NSString stringWithFormat:@"%@",dic[@"id"]];
  [self.navigationController pushViewController:ctrl animated:YES];
  [ctrl release];
}

-(void)clicked_backBut{
  if (analysis) {
    [analysis CancelMenthrequst];
  }
  [self.navigationController popViewControllerAnimated:YES];
  
}
- (void)viewWillAppear:(BOOL)animated
{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"hidesTabBar" object:nil];
}


@end
