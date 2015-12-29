//
//  JinghuaViewController.m
//  好妈妈
//
//  Created by liuguozhu on 13-10-10.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "JinghuaViewController.h"

#import "UIImageView+WebCache.h"

#import "contentViewController.h"

#import "jinghuaCell.h"
#import "MobClick.h"

@interface JinghuaViewController ()

@end

@implementation JinghuaViewController
@synthesize stream;

- (void)viewDidUnload
{
  [self setStream:nil];
  [super viewDidUnload];
  
}

-(void)dealloc{
  [super dealloc];
  [_muArr release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
  
  page = 1;
  
  _muArr = [[NSMutableArray alloc]init];
  UIImageView *backgroundIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
  backgroundIV.image =[UIImage imageNamed:@"底.png"];
  [self.view addSubview:backgroundIV ];
  [backgroundIV release];
  
  
  
  
  
  stream = [[EKStreamView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-104)];
  stream.delegate = self;
  stream.scrollsToTop = YES;
  stream.backgroundColor=[UIColor clearColor];
  stream.cellPadding = 5.0f;
  stream.columnPadding = 5.0f;
  
  
  [self.view addSubview:stream];
  [stream release];
  
  [stream reloadData];
  
  RefreshHeaderView=[[EGORefreshTableHeaderView alloc]initWithFrame:CGRectMake(0, -Screen_Height, Screen_Width, Screen_Height) ];
	RefreshHeaderView.delegate = self;
	[stream addSubview:RefreshHeaderView];
	[RefreshHeaderView release];
  
  //	4.显示上次刷新时间
	[RefreshHeaderView refreshLastUpdatedDate];

  if (ISIPAD) {
    stream.frame =CGRectMake((Screen_Width - 320*1.4)/2, 0, 320*1.4, Screen_Height-124);
    RefreshHeaderView.frame =CGRectMake(0, -Screen_Height, 320*1.4, Screen_Height);
  }

    [self loadData3];

}

- (NSInteger)numberOfCellsInStreamView:(EKStreamView *)streamView
{
  return [_muArr count];
}

- (NSInteger)numberOfColumnsInStreamView:(EKStreamView *)streamView
{
  return 2;
}

- (UIView *)streamView:(EKStreamView *)streamView cellAtIndex:(NSInteger)index
{
  static NSString *CellID2 = @"jinghuaCell";
  
  jinghuaCell *cell;
  
  cell = (jinghuaCell *)[streamView dequeueReusableCellWithIdentifier:CellID2];
  
  if (cell == nil) {
    cell = [[jinghuaCell alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    cell.reuseIdentifier = CellID2;
    
    
  }
    if (_muArr.count>index) {
        
    
  NSDictionary *dic = _muArr[index];
  
  [cell remImageTextLab:dic[@"title"]];

  [cell.tLab LoadContent:dic[@"title"]];
    cell.tLab.hangshu = YES;


//  if (ISIPAD) {
//    cell.ipadLab.text = dic[@"title"];
//  }else{
//    [cell remImageTextLab:dic[@"title"]];
//    
//    [cell.tLab LoadContent:dic[@"title"]];
//
//  }

  cell.picView_.urlString = dic[@"image"];
  cell.clickBut.tag = index +100;
  [cell.clickBut addTarget:self action:@selector(clicked_button:) forControlEvents:UIControlEventTouchUpInside];
  
    }
  
  return cell;
}
- (CGFloat)streamView:(EKStreamView *)streamView heightForCellAtIndex:(NSInteger)index
{
  NSDictionary *dic = _muArr[index];
  
  
  int width = [dic[@"width"] intValue];
  int height = [dic[@"height"] intValue];
  
  int viewWidth = (Screen_Width-20)/2;
  if (ISIPAD) {
    viewWidth = (320*1.4-20)/2;
  }
  
  
  
  return viewWidth * height /width;

}
- (UIView *)footerForStreamView:(EKStreamView *)streamView
{
  UIView * footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - stream.columnPadding * 2, 60)];
  footView.backgroundColor=[UIColor clearColor];
  
  footlab=[UIButton buttonWithType:UIButtonTypeCustom];
  footlab.backgroundColor = [UIColor whiteColor];
  footlab.frame = CGRectMake(5, 10, self.view.frame.size.width - stream.columnPadding * 2-10, 40);
  [footlab setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
  footlab.titleLabel.font = [UIFont systemFontOfSize:14];
  [footView addSubview:footlab];
  
  activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(50, 20, 20, 20)];
  activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
  [footView addSubview:activityIndicator];
  [activityIndicator startAnimating];
  
  if (ISIPAD) {
    footView.frame =CGRectMake(0, 0, 320*1.4, 60);
    footlab.frame = CGRectMake(15, 10, 300*1.4, 40);
  }
  if (isJiazai==YES) {
    [footlab setTitle:@"数据加载完毕" forState:UIControlStateNormal];
    [activityIndicator stopAnimating];
  }else{
    [footlab setTitle:@"点击加载更多" forState:UIControlStateNormal];
    [footlab addTarget:self action:@selector(click_jiazaiBut) forControlEvents:UIControlEventTouchUpInside];

  }
  
  return footView;
  
//  return nil;
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
	[self performSelector:@selector(loadData3) withObject:nil afterDelay:1.f];
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
    NSDictionary * userDic = [array valueForKey:asi.ControllerName];
  NSLog(@"arr %@",userDic);
    if (userDic.count) {
        footlab.hidden=NO;
    
  
    NSArray *arr = userDic[@"list"];
  
  if (page == 1) {
    isJiazai = NO;
    [_muArr removeAllObjects];
  }
  
  if (arr.count < 15) {
    isJiazai = YES;
  }
  
  for (NSDictionary *dic in arr) {
    [_muArr addObject:dic];
  }
    
  [stream reloadData];
  [activityIndicator stopAnimating];
  [RefreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:stream];
    }
    else
    {
        [activityIndicator stopAnimating];

        footlab.hidden=YES;
    }

     [self remHUD];
  
}

-(void)click_jiazaiBut{
  [activityIndicator startAnimating];

  page++;
  
  [self performSelector:@selector(loadData3) withObject:nil afterDelay:1.f];

}

-(void)loadData3{
    
    [footlab setTitle:@"加载中.." forState:UIControlStateNormal];
    
    MOBCLICK(kMob_KnowGood);
    NSString *urlstr = [NSString stringWithFormat:@"%@recommentknows", SERVER_URL];
    [self makeHUD];
    NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
    NSMutableDictionary * asiDictiong=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[userDic valueForKey:@"uid"],@"uid",[userDic valueForKey:@"token"],@"token",@"1",@"type",@"15",@"limit",[NSString stringWithFormat:@"%d",page],@"page",urlstr,@"aUrl",@"zhidao",@"Controller", nil];
    [self analyUrl:asiDictiong];
    [asiDictiong release];

}

-(void)makeHUD{
  myHUD= [[MBProgressHUD alloc] initWithView:self.view];
  [self.view addSubview:myHUD];
  //  myHUD.dimBackground = YES;
  
  myHUD.labelText = @"加载中..";
  [myHUD show:YES];
  
}
-(void)remHUD{
  [myHUD removeFromSuperview];
  [myHUD release];
}

-(void)clicked_button:(UIButton *)but{
  NSDictionary *dic = _muArr[but.tag-100];
  NSString * contentID = dic[@"id"];
  
  contentViewController *ctrl = [[contentViewController alloc]init];
  ctrl.contentID = contentID;
  [self.nav pushViewController:ctrl animated:YES];
  [ctrl release];
}
@end
