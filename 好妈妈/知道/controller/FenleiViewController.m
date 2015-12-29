//
//  FenleiViewController.m
//  好妈妈
//
//  Created by liuguozhu on 13-10-10.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "FenleiViewController.h"
#import "fenleiCell.h"
#import "detailsViewController.h"
#import "gdFenleiViewController.h"


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


@interface FenleiViewController ()

@end

@implementation FenleiViewController

-(void)dealloc{
  [super dealloc];
  [_muArr release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  _muArr = [[NSMutableArray alloc]init];
  
  UIImageView *backgroundIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
  backgroundIV.image =[UIImage imageNamed:@"底.png"];
  [self.view addSubview:backgroundIV ];
  [backgroundIV release];
  
  
  _uitable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - 44-64) style:UITableViewStylePlain];
  _uitable.delegate = self;
  _uitable.dataSource = self;
  _uitable.contentInset = UIEdgeInsetsMake(40.0f, 0.0f, 0, 0.0f);

  if (ISIPAD) {
      _uitable.frame = CGRectMake(0, 0, Screen_Width, Screen_Height - 44-84);
  }else{

  }

  _uitable.backgroundColor = [UIColor clearColor];
  _uitable.separatorStyle=UITableViewCellSeparatorStyleNone;
  [self.view addSubview:_uitable];
  [_uitable release];
  
  
 UIScrollView * _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -40, Screen_Width,35)];
  _scrollView.backgroundColor = [UIColor clearColor];
  _scrollView.showsHorizontalScrollIndicator = NO;
  _scrollView.bounces = NO;
  [_uitable addSubview:_scrollView];
  [_scrollView release];
  
  
  NSArray *colorArr = [NSArray arrayWithObjects:[UIColor colorWithRed:255/255.0f green:181/255.0f blue:181/255.0f alpha:1],[UIColor colorWithRed:189/255.0f green:225/255.0f blue:250/255.0f alpha:1],[UIColor colorWithRed:204/255.0f green:248/255.0f blue:233/255.0f alpha:1],[UIColor colorWithRed:206/255.0f green:195/255.0f blue:245/255.0f alpha:1],[UIColor colorWithRed:176/255.0f green:234/255.0f blue:255/255.0f alpha:1],[UIColor colorWithRed:212/255.0f green:248/255.0f blue:190/255.0f alpha:1],[UIColor colorWithRed:250/255.0f green:194/255.0f blue:238/255.0f alpha:1],[UIColor colorWithRed:144/255.0f green:185/255.0f blue:253/255.0f alpha:1],[UIColor colorWithRed:255/255.0f green:228/255.0f blue:181/255.0f alpha:1],[UIColor colorWithRed:214/255.0f green:204/255.0f blue:182/255.0f alpha:1],[UIColor colorWithRed:255/255.0f green:187/255.0f blue:157/255.0f alpha:1],[UIColor redColor], nil];
  
  
  arr1 = [NSArray arrayWithObjects:@"备孕",@"孕早期",@"孕中期",@"孕晚期",@"0-1月",@"1-3月",@"3-6月",@"6-12月",@"12-24月",@"24-36月",@"36月以上", nil];
    [arr1 retain];
  for (int i = 0 ; i< arr1.count; i++) {
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(70*i, 0, 70, 35);
    but.titleLabel.font = [UIFont boldSystemFontOfSize:16];

//    if (ISIPAD) {
//      but.frame = CGRectMake(140*i , 0, 140, 70);
//      but.titleLabel.font = [UIFont boldSystemFontOfSize:30];
//
//    }else{
//      but.frame = CGRectMake(70*i, 0, 70, 35);
//      but.titleLabel.font = [UIFont boldSystemFontOfSize:16];
//
//    }
    but.backgroundColor = colorArr[i];
    [but addTarget:self action:@selector(click_sBut:) forControlEvents:UIControlEventTouchUpInside];
    but.tag = 1000+i;
    [but setTitle:arr1[i] forState:UIControlStateNormal];
    [_scrollView addSubview:but];
  }
  
  UIImageView *scBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, -40, Screen_Width, 35)];
  scBg.image = [UIImage imageNamed:@"分类_1选项阴影.png"];
  [_uitable addSubview:scBg];
  [scBg release];

  _scrollView.contentSize = CGSizeMake(70*arr1.count, 35);
  if (ISIPAD) {
//    scBg.frame =CGRectMake(0, -70, Screen_Width, 70);
//    _scrollView.frame =CGRectMake(0, -70, Screen_Width,70);
//    _scrollView.contentSize = CGSizeMake(140*arr.count, 70);

  }


  [self loadData];

}
-(void)click_sBut:(UIButton *)But{
    NSLog(@"%d",But.tag-1000+13);
  detailsViewController *ctrl = [[[detailsViewController alloc]init]autorelease];
  ctrl.key =[arr1 objectAtIndex:But.tag-1000];
  [self.nav pushViewController:ctrl animated:YES];
}
- (void)analyUrl:(NSMutableDictionary *)urlString
{
  [self makeHUD];
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
    for (NSDictionary *dic in arr ) {
        [_muArr addObject:dic];
    }
  NSLog(@"fenlei arr%@ ",_muArr);
    
    [_uitable reloadData];
}
-(void)loadData{
    NSString *urlstr = [NSString stringWithFormat:@"%@stylelist", SERVER_URL];
    NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
    
    NSMutableDictionary * asiDictiong=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[userDic valueForKey:@"uid"],@"uid",[userDic valueForKey:@"token"],@"token",urlstr,@"aUrl", @"fenlei",@"Controller", nil];
    [self analyUrl:asiDictiong];
    [asiDictiong release];

  
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
  return _muArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _muArr[indexPath.row];
    NSArray *arr = dic[@"children"];

    int tmp = arr.count;
    if (tmp > 0 && tmp < 3) {
        return 100;

    }else if (tmp > 2&& tmp < 5 ){
    
        return 150;
    }else{
        return 200;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
  NSString *CellIdentifier = @"fenleiCellID";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if(cell == nil){    
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];

  }
    [cell.contentView removeAllSubviewss];
  NSDictionary *dic = _muArr[indexPath.row];
  
  if (dic) {
    
    UIImageView *xinIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 20, 20)];
    xinIV.image = [UIImage imageNamed:@"001_39.png"];
    [cell.contentView addSubview:xinIV];
    [xinIV release];

     UILabel  *titlab = [[UILabel alloc]initWithFrame:CGRectMake(43, 5, 200, 20)];
    titlab.backgroundColor = [UIColor clearColor];
    titlab.textColor = [UIColor colorWithRed:223/255.0f green:47/255.0f blue:66/255.0f alpha:1];
    titlab.text = dic[@"title"];
    titlab.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:titlab];
    [titlab release];
    
    if (ISIPAD) {
      xinIV.frame = CGRectMake((Screen_Width - 300)/2, 5, 20, 20);
      titlab.frame = CGRectMake((Screen_Width - 300)/2 +35, 5, 200, 20);
    }
    NSArray *arr = dic[@"children"];
    
    for (int i = 0 ; i <arr.count; i++) {
      NSDictionary *chDic = arr[i];
      UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
      but.titleLabel.font = [UIFont systemFontOfSize:14];
      if (ISIPAD) {
        but.frame = CGRectMake((Screen_Width - 300)/2 + i%2*149 , 40 + i/2*49, 150, 50);
        
      }else{
        but.frame = CGRectMake(10 + i%2*149 , 40 + i/2*49, 150, 50);
        
      }
      [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     
      
      [but setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
      [but setBackgroundColor:[UIColor whiteColor]];
      [cell.contentView addSubview:but];
      
      CALayer* l1=[but layer];
      [l1 setMasksToBounds:YES];
      [l1 setBorderWidth:1];
      [l1 setBorderColor:[[UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1]CGColor] ];
      if (i == 5) {
        [but setTitle:@"更多" forState:UIControlStateNormal];
        but.tag = [dic[@"id"] intValue];
        [but addTarget:self action:@selector(clicked_gdBut:) forControlEvents:UIControlEventTouchUpInside];
        break;
      }else{
        [but setTitle:chDic[@"title"] forState:UIControlStateNormal];

        but.tag = [dic[@"id"] intValue]*1000000 +[chDic[@"id"]  intValue];
        [but addTarget:self action:@selector(clickbut:) forControlEvents:UIControlEventTouchUpInside];
      }

    }
    

  }
    return cell;
  
  
}

-(void)clicked_gdBut:(UIButton *)but{
  gdFenleiViewController *ctrl = [[[gdFenleiViewController alloc]init]autorelease];
  ctrl.dtype = [NSString stringWithFormat:@"%d",but.tag];
  [self.nav pushViewController:ctrl animated:YES];


}

-(void)clickbut:(UIButton *)but{
  int butTag = but.tag;
  NSLog(@"tg == %d d === %d x  == %d",butTag,butTag/1000000,butTag%1000000);
  
  
  detailsViewController *ctrl = [[[detailsViewController alloc]init]autorelease];
  ctrl.type = [NSString stringWithFormat:@"%d",butTag/1000000];
  ctrl.subType =[NSString stringWithFormat:@"%d",butTag%1000000];
  [self.nav pushViewController:ctrl animated:YES];
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


@end
