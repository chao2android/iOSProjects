//
//  FavorableViewController.m
//  TestRedCollar
//
//  Created by miracle on 14-7-10.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "FavorableViewController.h"
#import "JSON.h"
#import "FavorableCell.h"
#import "FavorableList.h"

@interface FavorableViewController ()

@end

@implementation FavorableViewController
{
    NSMutableArray *listArray;
}
@synthesize mDownManager;

- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (void)LoginToServer:(int)status
{
    if (mDownManager) {
        return;
    }
    [self StartLoading];
    
    self.mDownManager = [[ImageDownManager alloc] init];
    mDownManager.delegate = self;
    mDownManager.OnImageDown = @selector(OnLoadFinish:);
    mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *urlstr = [NSString stringWithFormat:@"%@user.php", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:@"coupon" forKey:@"act"];
    [dict setObject:[NSNumber numberWithInt:1] forKey:@"pageIndex"];
    [dict setObject:[NSNumber numberWithInt:10] forKey:@"pageSize"];
    [dict setObject:kkToken forKey:@"token"];
    [dict setObject:[NSNumber numberWithInt:status] forKey:@"status"];
    
    [mDownManager PostHttpRequest:urlstr :dict];
}

- (void)OnLoadFinish:(ImageDownManager *)sender
{
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *sonDict = [dict objectForKey:@"datalist"];
        if (sonDict && [sonDict isKindOfClass:[NSDictionary class]])
        {
            for (NSString *key in sonDict.allKeys)
            {
                NSDictionary *dataDict = [sonDict objectForKey:key];
                
                FavorableList *fav = [[FavorableList alloc] init];
                
                fav.coupon_sn = [dataDict objectForKey:@"coupon_sn"];
                fav.status = [dataDict objectForKey:@"status"];
                fav.create_time = [dataDict objectForKey:@"create_time"];
                fav.up_time = [dataDict objectForKey:@"up_time"];
                [listArray addObject:fav];
            }
        }
    }
    [myTableView reloadData];
    [self.view addSubview:myTableView];
}

- (void)OnLoadFail:(ImageDownManager *)sender
{
    [self Cancel];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        listArray = [[NSMutableArray alloc] init];
        [self LoginToServer:0];
    }
    return self;
}

- (void)GoBack
{
    if (delegate && _onSaveClick)
    {
        SafePerformSelector([delegate performSelector:_onSaveClick]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"我的优惠券";
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
    
    int leftSide = 15;
    int iWidth = 97;
    for (int i = 0; i < 3; i++)
    {
        NSString *imagename = [NSString stringWithFormat:@"my7_0%d.png",i+1];
        NSString *imagename2 = [NSString stringWithFormat:@"my8_0%d.png",i+1];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(15+(iWidth-1)*i, 15, iWidth, 35);
        btn.tag = i;
        btn.backgroundColor = [UIColor clearColor];
        [btn setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imagename2] forState:UIControlStateSelected];
        btn.adjustsImageWhenHighlighted = NO;
        [btn addTarget:self action:@selector(OnTabSelect:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        if (i == 0)
        {
            mSelectBtn = btn;
            [mSelectBtn setSelected:YES];
        }
    }
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(leftSide, 60, self.view.frame.size.width-leftSide*2, self.view.frame.size.height) style:UITableViewStylePlain];
    myTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:myTableView];
}

- (void)OnTabSelect:(UIButton *)sender
{
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITableView class]]) {
            [view removeFromSuperview];
            listArray = [[NSMutableArray alloc] init];
        }
    }
    
    [mSelectBtn setSelected:NO];
    mSelectBtn = sender;
    [mSelectBtn setSelected:YES];
    [self LoginToServer:sender.tag];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FavorableList *list = [listArray objectAtIndex:indexPath.row];
    NSString *title = [NSString stringWithFormat:@"RCTALOR 优惠券-NO.%@",list.coupon_sn];
    NSString *price = [NSString stringWithFormat:@"￥%@",@"120.00"];
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:[list.create_time integerValue]];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:[list.up_time integerValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    NSString *time = [NSString stringWithFormat:@"有效期：%@-%@",[formatter stringFromDate:createDate],[formatter stringFromDate:endDate]];
    
    if (mSelectBtn.tag == 0)
    {
        static NSString *CellIdentifier = @"Cell00";
        FavorableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[FavorableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier Type:mSelectBtn.tag];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.backgroundColor = [UIColor clearColor];
        
        cell.titleLabel.text = title;
        cell.priceLabel.text = price;
        cell.timeLabel.text = time;
        
        return cell;
    }
    else if (mSelectBtn.tag == 1)
    {
        static NSString *CellIdentifier = @"Cell01";
        FavorableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[FavorableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier Type:mSelectBtn.tag];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.titleLabel.text = title;
        cell.priceLabel.text = price;
        cell.timeLabel.text = time;
        
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"Cell02";
        FavorableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[FavorableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier Type:mSelectBtn.tag];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.titleLabel.text = title;
        cell.priceLabel.text = price;
        cell.timeLabel.text = time;
        
        return cell;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
