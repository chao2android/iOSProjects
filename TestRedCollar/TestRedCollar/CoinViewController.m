//
//  CoinViewController.m
//  TestRedCollar
//
//  Created by miracle on 14-7-10.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "CoinViewController.h"
#import "JSON.h"
#import "CoinCell.h"
#import "CoinList.h"

@interface CoinViewController ()

@end

@implementation CoinViewController
{
    NSNumber *coin;
    UITableView *myTableView;
    NSMutableArray *mArray;
}

@synthesize mDownManager;

- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (void)connectToServer:(NSString *)type
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
    
    [dict setObject:type forKey:@"type"];
    [dict setObject:@"coin" forKey:@"act"];
    [dict setObject:[NSNumber numberWithInt:1] forKey:@"pageIndex"];
    [dict setObject:[NSNumber numberWithInt:10] forKey:@"pageSize"];
    [dict setObject:kkToken forKey:@"token"];
    
    [mDownManager PostHttpRequest:urlstr :dict];
}

- (void)OnLoadFinish:(ImageDownManager *)sender
{
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]])
    {
        coin = [dict objectForKey:@"coin"];
        NSDictionary *sonDict = [dict objectForKey:@"scoreItemList"];
        if (sonDict && [sonDict isKindOfClass:[NSDictionary class]]) {
            for (NSString *key in sonDict.allKeys) {
                NSDictionary *tmpDict = [sonDict objectForKey:key];
                NSArray *arr = @[@"num",@"status",@"type",@"msg"];
                
                for (int i = 0; i < arr.count; i++) {
                    id target = [tmpDict objectForKey:[arr objectAtIndex:i]];
                    if ([target isKindOfClass:[NSNull class]]) {
                        [tmpDict setValue:@"" forKey:[arr objectAtIndex:i]];
                    }
                }
                CoinList *list = [[CoinList alloc] init];
                list.coinNum = [tmpDict objectForKey:@"num"];
                list.coinStatus = [tmpDict objectForKey:@"status"];
                list.coinType = [tmpDict objectForKey:@"type"];
                list.coinMsg = [tmpDict objectForKey:@"msg"];
                
                [mArray addObject:list];
            }
        }
        [self initView];
    }
}

- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}

- (void)GoBack
{
    if (delegate && _onSaveClick)
    {
        SafePerformSelector([delegate performSelector:_onSaveClick]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        mArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"我的酷特币";
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
    
    UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
    topView.userInteractionEnabled = YES;
    topView.image = [UIImage imageNamed:@"82.png"];
    [self.view addSubview:topView];
    
    int iWidth = (self.view.frame.size.width-40)/4;
    for (int i = 0; i < 4; i++)
    {
        NSString *imagename = [NSString stringWithFormat:@"my3_0%d.png",i+1];
        NSString *imagename2 = [NSString stringWithFormat:@"my4_0%d.png",i+1];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(5+(iWidth+10)*i, 0, iWidth, 44);
        btn.tag = i;
        [btn setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imagename2] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(OnTabSelect:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        if (i == 0) {
            mSelectBtn = btn;
            [mSelectBtn setSelected:YES];
        }
    }
    [self connectToServer:@"all"];
}

- (void)OnTabSelect:(UIButton *)sender
{
    if (mSelectBtn.tag == sender.tag) {
        return;
    }
    
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITableView class]]) {
            [view removeFromSuperview];
            mArray = [[NSMutableArray alloc] init];
        }
        if (view.tag == 1001 || view.tag == 1000) {
            [view removeFromSuperview];
        }
    }
    
    [mSelectBtn setSelected:NO];
    mSelectBtn = sender;
    [mSelectBtn setSelected:YES];
    int index = sender.tag;
    
    if (index == 0)
    {
        [self connectToServer:@"all"];
    }
    else if (index == 1)
    {
        [self connectToServer:@"order"];
    }
    else if (index == 2)
    {
        [self connectToServer:@"sheji"];
    }
    else if (index == 3)
    {
        [self connectToServer:@"jiepai"];
    }
}

- (void)initView
{
    for (int i = 0 ; i < 2; i++)
    {
        UILabel *usedPoint = [[UILabel alloc] initWithFrame:CGRectMake(15+125*i, 45, 120, 45)];
        if (i == 0)
        {
            usedPoint.text = [NSString stringWithFormat:@"可用酷特币：%@",coin];
            usedPoint.tag = 1000;
        }
        else
        {
            usedPoint.text = [NSString stringWithFormat:@"冻结酷特币：%d",0];
            usedPoint.tag = 1001;
        }
        usedPoint.backgroundColor = [UIColor clearColor];
        usedPoint.font = [UIFont systemFontOfSize:16];
        usedPoint.textColor = [UIColor colorWithRed:188.0/255.0 green:0.0/255.0 blue:17.0/255.0 alpha:1.0];
        [self.view addSubview:usedPoint];
    }
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 90, self.view.frame.size.width, self.view.frame.size.height-90) style:UITableViewStylePlain];
    myTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:myTableView];
    [self.view sendSubviewToBack:myTableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return mArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (mSelectBtn.tag == 0) {
        static NSString *CellIdentifier = @"Cell00";
        CoinCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[CoinCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        CoinList *list = [mArray objectAtIndex:indexPath.section];
        cell.getCoin.text = list.coinNum;
        cell.loseCoin.text = list.coinStatus;
        cell.coinType.text = list.coinType;
        cell.coinDetail.text = list.coinMsg;
        
        return cell;
    }else if (mSelectBtn.tag == 1) {
        static NSString *CellIdentifier = @"Cell01";
        CoinCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[CoinCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        CoinList *list = [mArray objectAtIndex:indexPath.section];
        cell.getCoin.text = list.coinNum;
        cell.loseCoin.text = list.coinStatus;
        cell.coinType.text = list.coinType;
        cell.coinDetail.text = list.coinMsg;
        
        return cell;
    }else if (mSelectBtn.tag == 2) {
        static NSString *CellIdentifier = @"Cell02";
        CoinCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[CoinCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        CoinList *list = [mArray objectAtIndex:indexPath.section];
        cell.getCoin.text = list.coinNum;
        cell.loseCoin.text = list.coinStatus;
        cell.coinType.text = list.coinType;
        cell.coinDetail.text = list.coinMsg;
        
        return cell;
    }else {
        static NSString *CellIdentifier = @"Cell03";
        CoinCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[CoinCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        CoinList *list = [mArray objectAtIndex:indexPath.section];
        cell.getCoin.text = list.coinNum;
        cell.loseCoin.text = list.coinStatus;
        cell.coinType.text = list.coinType;
        cell.coinDetail.text = list.coinMsg;
        return cell;
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
