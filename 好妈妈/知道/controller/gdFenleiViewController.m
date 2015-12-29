//
//  gdFenleiViewController.m
//  好妈妈
//
//  Created by liuguozhu on 13-10-20.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "gdFenleiViewController.h"

#import "detailsViewController.h"

@interface gdFenleiViewController ()

@end

@implementation gdFenleiViewController

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
  titLab.text = @"更多分类";
  titLab.textAlignment = 1;
  titLab.backgroundColor = [UIColor clearColor];
  titLab.textColor = [UIColor whiteColor];
  titLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
  [navigation addSubview:titLab];
  [titLab release];
  
  
  [self loadData];
  
}

-(void)loadData{
  
  [self makeHUD];
  NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
  
  NSMutableDictionary * asiDictiong=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[userDic valueForKey:@"uid"],@"uid",[userDic valueForKey:@"token"],@"token",self.dtype,@"id",@"http://apptest.mum360.com/web/home/index/styleinfo",@"aUrl",@"gdfenlei",@"Controller", nil];
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
  [self remHUD];
  NSDictionary *dic = [array valueForKey:asi.ControllerName];
  
  NSLog(@"fenlei dic%@ ",dic);
  self._muDic = [NSDictionary dictionaryWithDictionary:dic];
  
  [self makeUI:__muDic];

}

-(void)makeUI:(NSDictionary *)dic{
  UIImageView *xIV = [[UIImageView alloc]initWithFrame:CGRectMake(5, 55, 20, 20)];
  xIV.image = [UIImage imageNamed:@"001_39.png"];
  [self.view addSubview:xIV];
  [xIV release];
  
  UILabel *tLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 55, 200, 20)];
  tLab.backgroundColor = [UIColor clearColor];
  tLab.textColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_background"]];
  tLab.font = [UIFont systemFontOfSize:14];
  tLab.text = dic[@"title"];
  [self.view addSubview:tLab];
  [tLab release];
  
  
  if (ISIPAD) {
    xIV.frame = CGRectMake((Screen_Width - 300)/2, 65, 20, 20);
    tLab.frame = CGRectMake((Screen_Width - 300)/2 +35, 65, 200, 20);
  
  }
//  if (ISIPAD) {
//    xinIV.frame = CGRectMake((Screen_Width - 300)/2, 5, 20, 20);
//    titlab.frame = CGRectMake((Screen_Width - 300)/2 +35, 5, 200, 20);
//  }

  
  NSArray *arr = dic[@"children"];
  
  for (int i = 0; i < arr.count; i++) {
    NSDictionary *chDic = arr[i];
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (ISIPAD) {
      but.frame = CGRectMake((Screen_Width - 300)/2 + i%2*149 , 140 + i/2*49, 150, 50);
      but.titleLabel.font = [UIFont systemFontOfSize:14];

    }else{
      but.frame = CGRectMake(10 + i%2*149 , 140 + i/2*49, 150, 50);
      but.titleLabel.font = [UIFont systemFontOfSize:14];

    }
    [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    but.tag = [chDic[@"id"] intValue];
    [but addTarget:self action:@selector(clicked_but:) forControlEvents:UIControlEventTouchUpInside];
    
    [but setTitle:chDic[@"title"] forState:UIControlStateNormal];
    [but setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [but setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:but];
    
    CALayer* l1=[but layer];
    [l1 setMasksToBounds:YES];
    [l1 setBorderWidth:1];
    [l1 setBorderColor:[[UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1]CGColor] ];

    
  }
  
  
}
-(void)clicked_but:(UIButton *)but{
  detailsViewController *ctrl = [[[detailsViewController alloc]init]autorelease];
  ctrl.type =self.dtype;
  ctrl.subType =[NSString  stringWithFormat:@"%d",but.tag];
  [self.navigationController pushViewController:ctrl animated:YES];

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
