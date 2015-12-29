//
//  OrderViewController.m
//  TestRedCollar
//
//  Created by miracle on 14-7-10.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderCell.h"
#import "JSON.h"
#import "OrderList.h"
#import "CartItemList.h"

@interface OrderViewController ()

@end

@implementation OrderViewController
{
    NSMutableArray *theListArr;
}

@synthesize mDownManager;

- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (void)connectToServer {
    if (mDownManager) {
        return;
    }
    [self StartLoading];
    
    self.mDownManager = [[ImageDownManager alloc] init];
    mDownManager.delegate = self;
    mDownManager.OnImageDown = @selector(OnLoadFinish:);
    mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *urlstr = [NSString stringWithFormat:@"%@order.php", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"getOrderList" forKey:@"act"];
    [dict setObject:kkToken forKey:@"token"];
    [dict setObject:[NSNumber numberWithInt:0] forKey:@"condition"];
    
    [mDownManager PostHttpRequest:urlstr :dict];
}

- (void)OnLoadFinish:(ImageDownManager *)sender
{
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    NSLog(@"dict---->%@",dict);
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        if ([dict objectForKey:@"orderList"] && [[dict objectForKey:@"orderList"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *iDict = [dict objectForKey:@"orderList"];
            for (NSString *key in iDict) {
                NSDictionary *mDict = iDict[key];
                OrderList *list = [OrderList CreateWithDict:mDict];
                if (list) {
                    [theListArr addObject:list];
                }
            }
        }
        else if ([dict objectForKey:@"orderList"] && [[dict objectForKey:@"orderList"] isKindOfClass:[NSArray class]]){
            NSArray *sonArr = [dict objectForKey:@"orderList"];
            for (NSDictionary *sonDict in sonArr) {
                OrderList *list = [OrderList CreateWithDict:sonDict];
                if (list) {
                    [theListArr addObject:list];
                }
            }
        }
    }
    [myTableView reloadData];
}

- (void)OnLoadFail:(ImageDownManager *)sender
{
    [self Cancel];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        theListArr = [[NSMutableArray alloc] init];
        
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
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    
    self.title = @"我的订单";
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
    
    myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    myTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:myTableView];
    
    [self connectToServer];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return theListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d",indexPath.section];
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[OrderCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    OrderList *list = [theListArr objectAtIndex:indexPath.section];
    CartItemList *itemList = [list.cartItemArr objectAtIndex:0];
    [cell.image GetImageByStr:itemList.goodsImage];
    
    CGRect rect = cell.backgroundView.frame;
    rect.origin.x = cell.image.frame.origin.x+cell.image.frame.size.width+15;
    rect.size.width = cell.frame.size.width-rect.origin.x;
    cell.backgroundView.frame = rect;
    
    cell.consignee.text = [NSString stringWithFormat:@"收货人：%@",list.consigneeName];
    if ([list.payWay integerValue] == 0) {
        cell.orderMoney.text = [NSString stringWithFormat:@"订单金额:￥%@(支付宝支付)",list.orderMoney];
    }else if ([list.payWay integerValue] == 1) {
        cell.orderMoney.text = [NSString stringWithFormat:@"订单金额:￥%@(银联支付)",list.orderMoney];
    }else if ([list.payWay integerValue] == 2) {
        cell.orderMoney.text = [NSString stringWithFormat:@"订单金额:￥%@(货到付款)",list.orderMoney];
    }
    
    NSDate *timestamp = [NSDate dateWithTimeIntervalSince1970:[list.orderTime integerValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    cell.time.text = [NSString stringWithFormat:@"时间：%@",[formatter stringFromDate:timestamp]];
    
    if ([list.orderStatus integerValue] == 0) {
        cell.status.text = @"状态：已付款";
    }else if ([list.orderStatus integerValue] == 1) {
        cell.status.text = @"状态：未付款";
    }else if ([list.orderStatus integerValue] == 2) {
        cell.status.text = @"状态：已取消";
    }else if ([list.orderStatus integerValue] == 3) {
        cell.status.text = @"状态：完成";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderInfoViewController *orderInfo = [[OrderInfoViewController alloc] init];
    orderInfo.list = [theListArr objectAtIndex:indexPath.section];
    [self.navigationController pushViewController:orderInfo animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
