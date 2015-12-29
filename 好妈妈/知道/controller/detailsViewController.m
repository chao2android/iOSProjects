//
//  detailsViewController.m
//  好妈妈
//
//  Created by liuguozhu on 13-10-17.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "detailsViewController.h"
#import "UIImageView+WebCache.h"

#import "contentViewController.h"
#import "ImageTextLabel.h"

@interface UIView (ss)
-(void)removeAllSubviewss;

@end

@implementation UIView (ss)

-(void)removeAllSubviewss{
  for (id cc in [self subviews]) {
    [cc removeFromSuperview];
  }
}
@end

@interface detailsViewController ()

@end

@implementation detailsViewController
@synthesize key;
- (void)viewWillAppear:(BOOL)animated
{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"hidesTabBar" object:nil];
}

-(void)dealloc{
  [super dealloc];
  [_muArr release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
  page = 1;
  _muArr = [[NSMutableArray alloc]init];
  
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
  
  UILabel * navigationLabel=[[UILabel alloc]initWithFrame:CGRectMake(100, KUIOS_7(11), (Screen_Width-200), 22)];
  navigationLabel.backgroundColor=[UIColor clearColor];
  //    navigationLabel.font=[UIFont systemFontOfSize:22];
  navigationLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:22];
  navigationLabel.textAlignment=NSTextAlignmentCenter;
  navigationLabel.textColor=[UIColor whiteColor];
  navigationLabel.text=@"分类详情";
  [navigation addSubview:navigationLabel];
  [navigationLabel release];
  
  
  UIButton * leftBut=[UIButton buttonWithType:UIButtonTypeCustom];
  leftBut.frame=CGRectMake(5, KUIOS_7(6), 45, 30.5);
  [leftBut addTarget:self action:@selector(clicked_leftBut) forControlEvents:UIControlEventTouchUpInside];
  [leftBut setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"001_4" ofType:@"png"]] forState:UIControlStateNormal];
  [navigation addSubview:leftBut];
  
  _uitable = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, KUIOS_7(44), Screen_Width, Screen_Height - 44-20) pullingDelegate:(id<PullingRefreshTableViewDelegate>)self];
  _uitable.delegate = self;
  _uitable.dataSource = self;
  _uitable.backgroundColor = [UIColor clearColor];
  _uitable.separatorStyle=UITableViewCellSeparatorStyleNone;
  [self.view addSubview:_uitable];
  [_uitable release];
  
  

  
  
  [self loadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
  return _muArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
  
  if (ISIPAD) {
    return 90;
  }else{
    return 90;
    
  }
  
}
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
  UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"detailsCellID"];
  if ( cell == nil) {
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detailsCellID"];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
   

  }
  
  [cell.contentView removeAllSubviewss];
  NSDictionary *dic = _muArr[indexPath.row];
  
  if ([dic isKindOfClass:[NSDictionary class]]) {
    UIImageView *bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 90)];
    bg.image = [UIImage imageNamed:@"bg-cell666.png"];
    [cell.contentView addSubview:bg];
    [bg release];
    
    
    
    NSString *tiString1 = dic[@"title"];
    if (tiString1.length > 25) {
      tiString1 = [tiString1 substringToIndex:25];
    }
    
    
    ImageTextLabel *titLab = [[ImageTextLabel alloc]initWithFrame:CGRectMake(15, 10, 300, 30)];
    titLab.backgroundColor = [UIColor clearColor];
    titLab.m_Font = [UIFont systemFontOfSize:16];

    if (ISIPAD) {
//      titLab.frame = CGRectMake(20, 30, Screen_Width - 50, 40);
//      titLab.m_Font = [UIFont systemFontOfSize:40];
//      //      titLab.m_DrawWidth = 2;
////      titLab.m_FontSize = 40;
//      titLab.m_RowHeigh = 40;
//      titLab.m_EmoWidth = 40;
//      titLab.m_EmoHeight = 40;

    }else{

    }
      NSLog(@"%@",tiString1);
    [titLab LoadContent:tiString1];
    [cell.contentView addSubview:titLab];
    [titLab release];
    
    
    
    UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 40, 30, 30)];
    iconView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"30_30.png"]];
    [iconView setImageWithURL:[NSURL URLWithString:dic[@"icon"]]];
    [cell.contentView addSubview:iconView];
    [iconView release];
    
    
    
    UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(55, 40, 100, 15)];
    nameLab.backgroundColor = [UIColor clearColor];
    nameLab.textColor = [UIColor colorWithRed:97/255.0f green:196/255.0f blue:218/255.0f alpha:1];
    nameLab.font = [UIFont systemFontOfSize:12];
    nameLab.text = dic[@"name"];
    [cell.contentView addSubview:nameLab];
    [nameLab release];
    
    UILabel *statusLab = [[UILabel alloc]initWithFrame:CGRectMake(55, 55, 100, 15)];
    statusLab.backgroundColor = [UIColor clearColor];
    statusLab.textColor = [UIColor grayColor];
    statusLab.font = [UIFont systemFontOfSize:12];
    statusLab.text = dic[@"status"];
    [cell.contentView addSubview:statusLab];
    [statusLab release];
    
    
    
    UILabel *timeLab = [[UILabel alloc]initWithFrame:CGRectMake(150,50, 100, 15)];
    timeLab.backgroundColor = [UIColor clearColor];
    timeLab.textAlignment = 2;
    timeLab.textColor = [UIColor grayColor];
    timeLab.font = [UIFont systemFontOfSize:12];
    timeLab.text = dic[@"time"];
    [cell.contentView addSubview:timeLab];
    [timeLab release];
    
    
    
    
    UIImageView *commentnumView = [[UIImageView alloc]initWithFrame:CGRectMake(270, 40, 30, 20)];
    commentnumView.image = [UIImage imageNamed:@"001_10.png"];
    [cell.contentView addSubview:commentnumView];
    [commentnumView release];
    
    UILabel *commentnumLab = [[UILabel alloc]initWithFrame:CGRectMake(270, 60, 30, 20)];
    commentnumLab.backgroundColor = [UIColor clearColor];
    commentnumLab.textAlignment = 1;
    commentnumLab.textColor = [UIColor blackColor];
    commentnumLab.font = [UIFont systemFontOfSize:12];
    commentnumLab.text = dic[@"commentnum"];
    [cell.contentView addSubview:commentnumLab];
    [commentnumLab release];
    
    
    
    if (ISIPAD) {
      bg.frame = CGRectMake(0, 0, Screen_Width,90);
      //
      //      titLab.frame = CGRectMake(20, 20, Screen_Width - 50, 60);
      //      titLab.m_Font = [UIFont systemFontOfSize:40];
      //      titLab.m_EmoWidth = 55;
      //      titLab.m_EmoHeight = 55;
      //
      //      iconView.frame = CGRectMake(20, 90, 80, 80);
      //      nameLab.frame = CGRectMake(140, 90, 250, 40);
      //      nameLab.font = [UIFont systemFontOfSize:35];
      //      statusLab.frame = CGRectMake(140, 135, 250, 40);
      //      statusLab.font = [UIFont systemFontOfSize:35];
      timeLab.frame =CGRectMake(550,50, 100, 15);
      //      timeLab.font = [UIFont systemFontOfSize:30];
      commentnumView.frame = CGRectMake(680, 40, 30, 20);
      commentnumLab.frame = CGRectMake(680, 60, 30, 20);
      //      commentnumLab.font = [UIFont systemFontOfSize:26];
      
      
    }
    
    
  }
  
  return cell;
  
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  NSDictionary *dic = _muArr[indexPath.row];
  
  contentViewController *ctrl = [[contentViewController alloc]init];
  ctrl.contentID = dic[@"id"];
  [self.navigationController pushViewController:ctrl animated:YES];
  [ctrl release];

  
}

//http://apptest.mum360.com/web/home/index/searchknows?uid=61&token=e4032723bbdbd7e3055a17eb596c7335&text=dass&limit=20&page=1

-(void)loadData{
  
  [self makeHUD];
  NSDictionary *userDic = [[NSUserDefaults standardUserDefaults]valueForKey:@"logindata"];
  
  NSMutableDictionary *asiDic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:userDic[@"uid"],@"uid",userDic[@"token"],@"token",@"20",@"limit",[NSString stringWithFormat:@"%d",page],@"page",@"http://apptest.mum360.com/web/home/index/themelistbustyle",@"aUrl",@"details",@"Controller", nil];
    if (self.type.length) {
        [asiDic setValue:self.type forKey:@"type"];
        [asiDic setValue:self.subType forKey:@"subtype"];

    }
    else
    {
        [asiDic setValue:self.key forKey:@"key"];

    }
  [self analyUrl:asiDic];
  [asiDic release];
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
  [self remHUD];
  NSArray *arr = [array valueForKey:asi.ControllerName];
  if (page == 1) {
    [_muArr removeAllObjects];
  }
  
  for (NSDictionary *dic in arr) {
    [_muArr addObject:dic];
  }
  
  if ([arr count] < 20) {
    _uitable .reachedTheEnd  = YES;
  }else{
    _uitable .reachedTheEnd  = NO;
  }
  NSLog(@" count == %d",arr.count);
  
  [_uitable reloadData];
  [_uitable tableViewDidFinishedLoading];
  
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
  [_uitable tableViewDidEndDragging:scrollView];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
  [_uitable tableViewDidScroll:scrollView];
  
}

- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
  page = 1;
  [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}



- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
  page++;
  [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
  
}

-(void)makeHUD{
  myHUD= [[MBProgressHUD alloc] initWithView:self.view];
  [_uitable addSubview:myHUD];
  //  myHUD.dimBackground = YES;
  myHUD.labelText = @"加载中..";
  [myHUD show:YES];
  
}
-(void)remHUD{
  [myHUD removeFromSuperview];
  [myHUD release];
}

-(void)clicked_leftBut{
  if (analysis) {
    [analysis CancelMenthrequst];
  }
  [self.navigationController popViewControllerAnimated:YES];
}

@end
