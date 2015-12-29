//
//  FavouriteViewController.m
//  TestRedCollar
//
//  Created by miracle on 14-7-10.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "FavouriteViewController.h"
#import "FavouriteCell.h"
#import "JSON.h"
#import "FavouriteList.h"
#import "MyCustomDetailViewController.h"
#import "AutoAlertView.h"

@interface FavouriteViewController ()

@end

@implementation FavouriteViewController
{
    NSMutableArray *totalArr;
}

@synthesize mDownManager;

- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (void)LoginToServer
{
    if (mDownManager) {
        return;
    }
    [self StartLoading];
    
    self.mDownManager = [[ImageDownManager alloc] init];
    mDownManager.delegate = self;
    mDownManager.OnImageDown = @selector(OnLoadFinish:);
    mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *urlstr = [NSString stringWithFormat:@"%@goods.php", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"getCstCollect" forKey:@"act"];
    [dict setObject:kkToken forKey:@"token"];
    
    [mDownManager PostHttpRequest:urlstr :dict];
}

- (void)OnLoadFinish:(ImageDownManager *)sender
{
    NSArray *array = [sender.mWebStr JSONValue];
    NSLog(@"array--->%@",array);
    [self Cancel];
    if (array && [array isKindOfClass:[array class]])
    {
        totalArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < array.count; i++)
        {
            NSDictionary *dict = [array objectAtIndex:i];
            FavouriteList *favList = [[FavouriteList alloc] init];
            favList.imageURL = [dict objectForKey:@"image"];
            favList.title = [dict objectForKey:@"cst_name"];
            favList.price = [dict objectForKey:@"price"];
            favList.time = [dict objectForKey:@"add_time"];
            favList.favourite = [dict objectForKey:@"collectnum"];
            favList.cstId = [dict objectForKey:@"id"];
            
            [totalArr addObject:favList];
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
        [self LoginToServer];
        
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
    
    self.title = @"我的收藏";
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
    return totalArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    FavouriteCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[FavouriteCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    FavouriteList *fav = [totalArr objectAtIndex:indexPath.section];
    [cell.fImageView GetImageByStr:fav.imageURL];
    
    CGRect rect = cell.backgroundView.frame;
    rect.origin.x = cell.fImageView.frame.origin.x+cell.fImageView.frame.size.width+15;
    rect.size.width = cell.frame.size.width-rect.origin.x;
    cell.backgroundView.frame = rect;
    
    cell.fTitle.text = fav.title;
    float price = [fav.price floatValue];
    int d = (int)(price * 10) % 10;
    if (d>=5) {
        price = price+1;
    }
    float jPrice = (int)price;
    cell.fPrice.text = [NSString stringWithFormat:@"￥%.2f",jPrice];
    cell.fFavourite.text = [NSString stringWithFormat:@"收藏人气 %@",fav.favourite];
    cell.cancelBtn.tag = indexPath.section;
    [cell.cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDate *timestamp = [NSDate dateWithTimeIntervalSince1970:[fav.time integerValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    cell.fTime.text = [NSString stringWithFormat:@"时间：%@",[formatter stringFromDate:timestamp]];
    return cell;
}
- (void)cancelBtnClick:(UIButton *)sender{
    NSLog(@"%d",sender.tag);
    FavouriteList *model = [totalArr objectAtIndex:sender.tag];
    [self deleteCst:model.cstId];
}
- (void)deleteCst:(NSString *)cstId
{
    if (mDownManager) {
        return;
    }
    [self StartLoading];
    
    self.mDownManager = [[ImageDownManager alloc] init];
    mDownManager.delegate = self;
    mDownManager.OnImageDown = @selector(OnDeleFinish:);
    mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    //http://www.rctailor.com/soaapi/soap/goods.php?act=delCstCollect&cstId=100&token=abcdefghijk
    NSString *urlstr = [NSString stringWithFormat:@"%@goods.php", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"delCstCollect" forKey:@"act"];
    [dict setObject:kkToken forKey:@"token"];
    [dict setObject:cstId forKey:@"cstId"];
    
    [mDownManager PostHttpRequest:urlstr :dict];
}
- (void)OnDeleFinish:(ImageDownManager *)senser{
    NSDictionary *dict = [senser.mWebStr JSONValue];
    [self Cancel];
    NSLog(@"dict--->%@",dict);
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        [AutoAlertView ShowAlert:@"提示" message:dict[@"msg"]];
        if ([dict[@"statusCode"] intValue] == 0) {
            [self LoginToServer];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FavouriteList *fav = [totalArr objectAtIndex:indexPath.section];
    MyCustomDetailViewController *detail = [[MyCustomDetailViewController alloc] init];
    detail.IDStr = fav.cstId;
    [detail StartDownload];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
