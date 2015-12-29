//
//  IntegralViewController.m
//  TestRedCollar
//
//  Created by miracle on 14-7-10.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "IntegralViewController.h"
#import "JSON.h"
#import "IntegralCell.h"
#import "IntegralList.h"

@interface IntegralViewController ()

@end

@implementation IntegralViewController
{
    NSNumber *point;
    UITableView *myTableView;
    NSMutableArray *mArray;
    UILabel *usedPoint;
}

@synthesize mDownManager;

- (void)Cancel
{
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (void)connectToServer:(NSString *)type
{
    if (mDownManager)
    {
        return;
    }
    [self StartLoading];
    
    self.mDownManager = [[ImageDownManager alloc] init];
    mDownManager.delegate = self;
    mDownManager.OnImageDown = @selector(OnLoadFinish:);
    mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *urlstr = [NSString stringWithFormat:@"%@user.php", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"point" forKey:@"act"];
    [dict setObject:[NSNumber numberWithInt:1] forKey:@"pageIndex"];
    [dict setObject:[NSNumber numberWithInt:10] forKey:@"pageSize"];
    [dict setObject:type forKey:@"type"];
    [dict setObject:kkToken forKey:@"token"];
    
    [mDownManager PostHttpRequest:urlstr :dict];
}

- (void)OnLoadFinish:(ImageDownManager *)sender
{
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]){
        point = [dict objectForKey:@"point"];
        NSDictionary *sonDict = [dict objectForKey:@"scoreItemList"];
        if (sonDict && [sonDict isKindOfClass:[NSDictionary class]]){
            for (NSString *key in sonDict.allKeys){
                NSDictionary *tmpDict = [sonDict objectForKey:key];
                IntegralList *list = [[IntegralList alloc] init];
                list.integralNum = [tmpDict objectForKey:@"num"];
                list.integralStatus = [tmpDict objectForKey:@"status"];
                list.integralType = [tmpDict objectForKey:@"type"];
                list.integralMsg = [tmpDict objectForKey:@"msg"];
                [mArray addObject:list];
            }
        }
        [self initView];
    }
}

- (void)OnLoadFail:(ImageDownManager *)sender
{
    [self Cancel];
}

- (void)GoBack
{
    if (delegate && _onSaveClick){
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

- (void)OnTabSelect:(UIButton *)sender
{
    if (mSelectBtn.tag == sender.tag)
    {
        return;
    }
    
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[UITableView class]])
        {
            [view removeFromSuperview];
            mArray = [[NSMutableArray alloc] init];
        }
        if (view.tag == 1001 || view.tag == 1000)
        {
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
        usedPoint = [[UILabel alloc] init];
        [self connectToServer:@"order"];
    }
    else if (index == 2)
    {
        [self connectToServer:@"comment"];
    }
    else if (index == 3)
    {
        [self connectToServer:@"hudong"];
    }
}

- (void)initView
{
    for (int i = 0 ; i < 2; i++)
    {
        usedPoint = [[UILabel alloc] initWithFrame:CGRectMake(15+140*i, 45, 140, 45)];
        if (i == 0)
        {
            usedPoint.text = [NSString stringWithFormat:@"可用积分:%@",point];
            usedPoint.tag = 1000;
        }
        else
        {
            usedPoint.text = [NSString stringWithFormat:@"冻结积分:%d",0];
            usedPoint.tag = 1001;
        }
        
        usedPoint.backgroundColor = [UIColor clearColor];
        usedPoint.font = [UIFont systemFontOfSize:16];
        usedPoint.textColor = WORDREDCOLOR;
        usedPoint.textAlignment = NSTextAlignmentLeft;
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
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (mSelectBtn.tag == 0)
    {
        static NSString *CellIdentifier = @"Cell00";
        IntegralCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[IntegralCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        IntegralList *list = [mArray objectAtIndex:indexPath.section];
        
        cell.getIntegral.text = list.integralNum;
        cell.loseIntegral.text = list.integralStatus;
        //cell.integralType.text = list.integralType;
        cell.integralDetail.text = list.integralMsg;
        return cell;
    }
    else if (mSelectBtn.tag == 1)
    {
        static NSString *CellIdentifier = @"Cell01";
        IntegralCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[IntegralCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        IntegralList *list = [mArray objectAtIndex:indexPath.section];
        
        cell.getIntegral.text = list.integralNum;
        cell.loseIntegral.text = list.integralStatus;
        //cell.integralType.text = list.integralType;
        cell.integralDetail.text = list.integralMsg;
        return cell;
    }
    else if (mSelectBtn.tag == 2)
    {
        static NSString *CellIdentifier = @"Cell02";
        IntegralCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[IntegralCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        IntegralList *list = [mArray objectAtIndex:indexPath.section];
        
        cell.getIntegral.text = list.integralNum;
        cell.loseIntegral.text = list.integralStatus;
        //cell.integralType.text = list.integralType;
        cell.integralDetail.text = list.integralMsg;
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"Cell03";
        IntegralCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[IntegralCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        IntegralList *list = [mArray objectAtIndex:indexPath.section];
        
        cell.getIntegral.text = list.integralNum;
        cell.loseIntegral.text = list.integralStatus;
        //cell.integralType.text = list.integralType;
        cell.integralDetail.text = list.integralMsg;
        return cell;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"我的积分";
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
    
    UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
    topView.userInteractionEnabled = YES;
    topView.image = [UIImage imageNamed:@"82.png"];
    [self.view addSubview:topView];
    
    int iWidth = (self.view.frame.size.width-40)/4;
    for (int i = 0; i < 4; i++)
    {
        NSString *imagename = [NSString stringWithFormat:@"my1_0%d.png",i+1];
        NSString *imagename2 = [NSString stringWithFormat:@"my2_0%d.png",i+1];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(5+(iWidth+10)*i, 0, iWidth, 44);
        btn.tag = i;
        btn.backgroundColor = [UIColor clearColor];
        [btn setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imagename2] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(OnTabSelect:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        if (i == 0)
        {
            mSelectBtn = btn;
            [mSelectBtn setSelected:YES];
        }
    }
    [self connectToServer:@"all"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
