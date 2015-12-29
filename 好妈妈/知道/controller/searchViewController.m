//
//  searchViewController.m
//  taobaoapp
//
//  Created by bycc on 13-1-5.
//  Copyright (c) 2013年 aozi. All rights reserved.
//

#import "searchViewController.h"


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


@interface searchViewController ()

@end

@implementation searchViewController
@synthesize search,delegate,searchWord;

#define HView self.view.frame.size.height

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
//    if (_array==nil) {
//        _array =[[NSMutableArray alloc]init];
//        
//    }
    
    
    NSUserDefaults *UserDefault = [NSUserDefaults standardUserDefaults];
    _array=[UserDefault objectForKey:@"searchWord"];
    
    
    UIView * backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    backView.backgroundColor=[UIColor blackColor];
    backView.alpha=0.7f;
    [self.view addSubview:backView];
    [backView release];
    
    bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_background.png"]];
    bgImage.frame=CGRectMake(0, -44, 320, 44);
    [self.view addSubview: bgImage];
    
    
    search=[[UISearchBar alloc]initWithFrame:CGRectMake(0, -44, 270, 44)];
    search.delegate=self;
    //    search.showsCancelButton=YES;
    
    search.barStyle=UIBarStyleBlack ;
    search.backgroundColor=[UIColor clearColor];
    search.placeholder=@"请输入要搜索的文字";
    search.keyboardType =  UIKeyboardTypeDefault;
    
    UIView *segment = [search.subviews objectAtIndex:0];
    [segment removeFromSuperview];
    
    
    [self.view addSubview:search];
    [search release];
    [search becomeFirstResponder];
    
    
    
    removeBut=[UIButton buttonWithType:UIButtonTypeCustom];
    removeBut.frame=CGRectMake(271, 7-44, 44, 30);
  [removeBut setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"004_钮" ofType:@"png"]] forState:UIControlStateNormal];
    [removeBut setTitle:@"取消" forState:UIControlStateNormal];
    removeBut.titleLabel.font=[UIFont systemFontOfSize:13];
    [removeBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [removeBut addTarget:self action:@selector(removeBut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:removeBut];
  
//    removeBut.backgroundColor=[UIColor whiteColor];
//    CALayer* l1=[removeBut layer];
//    [l1 setMasksToBounds:YES];
//    [l1 setCornerRadius:6];
//    [l1 setBorderWidth:1];
//    [l1 setBorderColor:[[UIColor grayColor]CGColor] ];
  
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+HView, 320, 300) style:UITableViewStylePlain];
    _tableView.backgroundColor=[UIColor whiteColor];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    //    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView release];
    
    
    
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2f];
    bgImage.frame=CGRectMake(0, 0, 320, 44);
    search.frame=CGRectMake(0, 0, 270, 44);
    removeBut.frame=CGRectMake(271, 7, 44, 30);
    _tableView.frame=CGRectMake(0, 44, 320, 200);
    [UIView commitAnimations];
    
    
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _array.count+1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        
        
                
    }
    [cell.contentView removeAllSubviewss];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if (indexPath.row!=_array.count) {
        int tmp=_array.count-indexPath.row-1;
        
        NSString * Name=[_array objectAtIndex:tmp];
        
        UILabel * nameLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 40)];;
        nameLab.backgroundColor=[UIColor clearColor];
        nameLab.textColor=[UIColor blackColor];
        nameLab.text=Name;
        [cell.contentView addSubview:nameLab];
        [nameLab release];

        
        

    }else{
        UIButton* but0=[UIButton buttonWithType:UIButtonTypeCustom];
        but0.frame=CGRectMake(80, 2, 160, 36);
        but0.tag=10;
        [but0 addTarget:self  action:@selector(click_But:) forControlEvents:UIControlEventTouchUpInside];
        [but0 setTitle:@"清除搜索记录" forState:UIControlStateNormal];
        but0.titleLabel.font=[UIFont systemFontOfSize:15];
        [but0 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [cell.contentView  addSubview:but0];
        but0.backgroundColor=[UIColor whiteColor];
        CALayer * l1=[but0 layer];
        [l1 setMasksToBounds:YES];
        [l1 setCornerRadius:5];
        [l1 setBorderWidth:1];
        [l1 setBorderColor:[[UIColor grayColor]CGColor] ];
    }
    
    
    return cell;
}
-(void)click_But:(id)sender{
    NSMutableArray * arr=[[[NSMutableArray alloc]init]autorelease];
    
    for (NSString * s in _array) {
        [arr addObject:s];
    }
    
    
    
    [arr removeAllObjects];
    
    
    
    
    NSUserDefaults *UserDefault = [NSUserDefaults standardUserDefaults];

    [UserDefault setObject:arr forKey:@"searchWord"];
    [UserDefault synchronize];//同步
    _array=[UserDefault objectForKey:@"searchWord"];

    
    [_tableView reloadData];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row!=_array.count) {
    
        int tmp=_array.count-indexPath.row-1;
        
        NSString * Name=[_array objectAtIndex:tmp];
        [delegate schLoadData:Name title:Name];
        [self removeBut];
    }
    
    
}


-(void)removeBut{
    [search resignFirstResponder];
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2f];
    bgImage.frame=CGRectMake(0, -44, 320, 44);
    search.frame=CGRectMake(0, -44, 270, 44);
    removeBut.frame=CGRectMake(271, 7-44, 44, 30);
    _tableView.frame=CGRectMake(0, 44+HView, 320, HView-44);
    [UIView commitAnimations];
    [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(rem) userInfo:nil repeats:NO];
    
    
    
}
-(void)rem{
    [self.delegate remvoeSearchView];
    
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}
- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    search.text = @"";
    [search resignFirstResponder];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    NSUserDefaults *UserDefault = [NSUserDefaults standardUserDefaults];
    NSString * str=[UserDefault objectForKey:@"macadd"];
    
    NSString * s=[NSString stringWithFormat:@"http://www.21bycc.com/jsonb.aspx?fun=upSarch&nid=%@&sword=%@",str,search.text];
    
    NSMutableURLRequest * req=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:s]];
    [req setHTTPMethod:@"GET"];
    [NSURLConnection connectionWithRequest:req delegate:self];
    
    
    [delegate schLoadData:search.text title:search.text];
    [self removeBut];
    
    
    NSMutableArray * arr=[[[NSMutableArray alloc]init]autorelease];
    
    for (NSString * s in _array) {
       
        [arr addObject:s];
        
    }

    int i=0;
    for (NSString * s in arr) {
        if ([s isEqualToString:search.text]) {
            
            [arr removeObject:s ];
//            [arr exchangeObjectAtIndex:arr.count-1 withObjectAtIndex:i];
        
//            [arr addObject:search.text];
        }
        i++;
    }


    [arr addObject:search.text ];

    
    

    
//    NSUserDefaults *UserDefault = [NSUserDefaults standardUserDefaults];
    
    [UserDefault setObject:arr forKey:@"searchWord"];
    [UserDefault synchronize];//同步
    
    
}

-(void)dealloc{
    [super dealloc];
//    [_array release];
    
    
}
@end
