//
//  HowGetMoneyViewController.m
//  TestRedCollar
//
//  Created by dreamRen on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "HowGetMoneyViewController.h"
#import "HowGetMoneyCell.h"

@interface HowGetMoneyViewController ()

@end

@implementation HowGetMoneyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)GoBack{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.91 alpha:1.0];
    self.title = @"如何快速获取酷特币";
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
    
    _theList=[[NSMutableArray alloc] init];
    
    [_theList addObject:@{@"one":@"动作",@"two":@"酷特币"}];
    [_theList addObject:@{@"one":@"手机邮箱认证成功",@"two":@"20"}];
    [_theList addObject:@{@"one":@"每日登录",@"two":@"10"}];
    [_theList addObject:@{@"one":@"邀请好友注册",@"two":@"50"}];
    [_theList addObject:@{@"one":@"拍照上传",@"two":@"60"}];
    [_theList addObject:@{@"one":@"设计被推荐",@"two":@"200"}];
    
    _theTable=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _theTable.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    _theTable.backgroundColor=[UIColor clearColor];
    _theTable.delegate=self;
    _theTable.dataSource=self;
    _theTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_theTable];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _theList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //行高
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell03";
    HowGetMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HowGetMoneyCell" owner:self options:nil] lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    [cell resetInfoDict:_theList[indexPath.row]];
    if (indexPath.row%2) {
        //白色
        cell.backgroundColor=[UIColor whiteColor];
    }else{
        cell.backgroundColor=[UIColor colorWithWhite:0.83 alpha:1.0];
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

@end
