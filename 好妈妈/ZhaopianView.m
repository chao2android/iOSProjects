//
//  ZhaopianView.m
//  好妈妈
//
//  Created by iHope on 13-10-27.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "ZhaopianView.h"
#import "ZhidaoCell.h"
#import "RijiXiangqingViewController.h"

#import "MBProgressHUD.h"
@implementation ZhaopianView
- (void)dealloc
{
//  if (analysis) {
//    
//    
//    [analysis CancelMenthrequst];
//    analysis=nil;
//  }
  [_muArr release];
  [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
      page = 1;
      
      _muArr = [[NSMutableArray alloc]init];
      UIImageView *backgroundIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
      backgroundIV.image =[UIImage imageNamed:@"底.png"];
      [self addSubview:backgroundIV ];
      [backgroundIV release];
      
      
      
      
      
      _stream = [[EKStreamView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-64)];
      _stream.delegate = self;
      _stream.scrollsToTop = YES;
      _stream.backgroundColor=[UIColor clearColor];
      _stream.cellPadding = 5.0f;
      _stream.columnPadding = 5.0f;
      
      [self addSubview:_stream];
      [_stream release];
      
      [_stream reloadData];
      
      RefreshHeaderView=[[EGORefreshTableHeaderView alloc]initWithFrame:CGRectMake(0, -Screen_Height, Screen_Width, Screen_Height) ];
      RefreshHeaderView.delegate = self;
      [_stream addSubview:RefreshHeaderView];
      [RefreshHeaderView release];
      
      //	4.显示上次刷新时间
      [RefreshHeaderView refreshLastUpdatedDate];

    
    }
    return self;
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
  static NSString *CellID2 = @"QuanmeituCell";
  
  ZhidaoCell *cell;
  
  cell = (ZhidaoCell *)[streamView dequeueReusableCellWithIdentifier:CellID2];
  
  if (cell == nil) {
    cell = [[ZhidaoCell alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    cell.backgroundColor = [UIColor whiteColor];
    cell.reuseIdentifier = CellID2;
    
    
  }
  
  
  NSDictionary *dic = _muArr[index];
  
  NSString * private = [NSString stringWithFormat:@"%@",dic[@"private"]];
  
  if (isSuo) {
    cell.suoIV.hidden = YES;
  }
  
  if ([private isEqualToString:@"0"]) {
      cell.suoIV.opaque=NO;
    [cell.suoIV addTarget:self action:@selector(suo:) forControlEvents:UIControlEventTouchUpInside];
    [cell.suoIV setImage:[UIImage imageNamed:@"lock_2.png"] forState:UIControlStateNormal];
  }else{
      cell.suoIV.opaque=YES;
    [cell.suoIV addTarget:self action:@selector(suo:) forControlEvents:UIControlEventTouchUpInside];
    [cell.suoIV setImage:[UIImage imageNamed:@"lock_1.png"] forState:UIControlStateNormal];
  }
    cell.suoIV.tag=index;
  NSString * imageStr = [NSString stringWithFormat:@"%@", dic[@"image"]];
  if ([imageStr isEqualToString:@""]) {
       cell.picView_.image =[UIImage imageNamed:@"文本-1.png"];
    
  }else{
    cell.picView_.urlString = dic[@"image"];

  }

  cell.picView_.tag = index +1000;
  [cell.picView_ addTarget:self action:@selector(clicked_picView:) forControlEvents:UIControlEventTouchUpInside];
  
  cell.timeLab.text = dic[@"text"];
  
  return cell;
}

-(void)kaisuo:(UIButton *)send{

}
-(void)suo:(UIButton *)send{
    
    NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
    
    
    NSMutableDictionary * asiDictiong=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[userDic valueForKey:@"uid"],@"uid",[userDic valueForKey:@"token"],@"token",@"http://apptest.mum360.com/web/home/index/updatetopicprivate",@"aUrl",@"jiesuo",@"Controller",[NSString stringWithFormat:@"%@",[[_muArr objectAtIndex:send.tag] valueForKey:@"id"]],@"id",[NSString stringWithFormat:@"%d",!send.opaque],@"privates",nil];
    NSLog(@"asiDic    %@",asiDictiong);
    
    [self analyUrl:asiDictiong];
    [asiDictiong release];

    NSDictionary *dic = _muArr[send.tag];
    
    if (send.opaque == NO) {
        send.opaque = YES;
        [dic setValue:@"1" forKey:@"private"];
        [send setImage:[UIImage imageNamed:@"lock_1.png"] forState:UIControlStateNormal];
        
    }else{
        send.opaque = NO;
        [dic setValue:@"0" forKey:@"private"];
        [send setImage:[UIImage imageNamed:@"lock_2.png"] forState:UIControlStateNormal];
        
    }
  


}
- (CGFloat)streamView:(EKStreamView *)streamView heightForCellAtIndex:(NSInteger)index
{
  NSDictionary *dic = _muArr[index];
  NSString * imageStr = [NSString stringWithFormat:@"%@", dic[@"image"]];
  if ([imageStr isEqualToString:@""]) {
    return (Screen_Width - 20)/2;
  }else{
    int width = [dic[@"width"] intValue];
    int height = [dic[@"height"] intValue];
    
    int viewWidth = (Screen_Width - 20)/2;
    return viewWidth * height /width;
}
  
  
  
  
}
- (UIView *)footerForStreamView:(EKStreamView *)streamView
{
  UIView * footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width - _stream.columnPadding * 2, 60)];
  footView.backgroundColor=[UIColor clearColor];
  
  footlab=[UIButton buttonWithType:UIButtonTypeCustom];
  footlab.backgroundColor = [UIColor whiteColor];
  footlab.frame = CGRectMake(5, 10, self.frame.size.width - _stream.columnPadding * 2-10, 40);
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

-(void)clicked_picView:(AsyncImageView *)view{
    
    NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
    NSMutableDictionary * Dictionary=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[userDic valueForKey:@"uid"],@"uid",[userDic valueForKey:@"token"],@"token",[[_muArr objectAtIndex:view.tag-1000] valueForKey:@"id"],@"tid",[[_muArr objectAtIndex:view.tag-1000] valueForKey:@"time"],@"date", nil];
    [Dictionary setValue:@"http://apptest.mum360.com/web/home/index/topicinfo" forKey:@"aUrl1"];

//
//    
    RijiXiangqingViewController * rijixiangqing=[[RijiXiangqingViewController alloc]init];
    rijixiangqing.oldDictionary=Dictionary;
    [Dictionary release];
    [self.window.rootViewController presentModalViewController:rijixiangqing animated:NO];
    [rijixiangqing release];

}

-(void)loadData{
//  targetid=&limit=&page=

  NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
  
  
  NSMutableDictionary * asiDictiong=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[userDic valueForKey:@"uid"],@"uid",[userDic valueForKey:@"token"],@"token",@"20",@"limit",[NSString stringWithFormat:@"%d",page],@"page",@"http://apptest.mum360.com/web/home/index/topiclist",@"aUrl",@"zhaopian",@"Controller",self.targetid,@"targetid",nil];
  NSLog(@"asiDic    %@",asiDictiong);

  if (![userDic[@"uid"] isEqualToString:self.targetid]) {
    isSuo = YES;
  }
  
  [self analyUrl:asiDictiong];
  [asiDictiong release];

}
- (void)analyUrl:(NSMutableDictionary *)urlString
{
  if (analysis) {
    [analysis CancelMenthrequst];
  }
  
  NSURL * aUrl=[[NSURL alloc]initWithString:[urlString valueForKey:@"aUrl"]];
    NSLog(@"%@",aUrl);
  analysis=[[AnalysisClass alloc]initWithIdentifier:aUrl DataName:nil ControllerName:[urlString valueForKey:@"Controller"] delegate:self];
  [aUrl release];
  [analysis PostMenth:urlString];
  
}
- (void)Asihttp:(AnalysisClass *)asi DataArray:(NSMutableDictionary *)array
{
    if ([asi.ControllerName isEqualToString:@"jiesuo"]) {
        MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:self];
        [self addSubview:HUD];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = @"修改成功";
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [HUD removeFromSuperview];
            [HUD release];
        }];
    }
    else
    {
  NSDictionary * arr = [array valueForKey:asi.ControllerName];
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
  
  NSLog(@"arr %@ count === %d",arr,_muArr.count);
  [_stream reloadData];
  
  [RefreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_stream];
  
  [activityIndicator stopAnimating];
    }
  
  
}

@end
