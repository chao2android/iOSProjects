//
//  ShopCarViewController.m
//  TestRedCollar
//
//  Created by miracle on 14-7-14.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ShopCarViewController.h"
#import "ShopCarCell.h"
#import "ImageDownManager.h"
#import "JSON.h"
#import "ShoppingCarModel.h"
#import "AutoAlertView.h"
#import "CheckListViewController.h"
#import "MyCustomDetailViewController.h"
@interface ShopCarViewController ()
{
    ImageDownManager *_getCartManager;
    ImageDownManager *_delCarManager;
    NSMutableArray *_dataArray;
}
@end

@implementation ShopCarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.91 alpha:1.0];
    self.title = @"购物车";
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
    
    [self getCart];
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-70) style:UITableViewStylePlain];
    myTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:myTableView];
    
    UIButton *checkListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    checkListBtn.frame = CGRectMake(180, self.view.bounds.size.height-125, 112.5, 41.5);
    [checkListBtn setBackgroundImage:[UIImage imageNamed:@"car_checklist.png"] forState:UIControlStateNormal];
    [checkListBtn addTarget:self action:@selector(CheckList) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: checkListBtn];
}
- (void)dealloc {
    [self Cancel];
}
- (void)Cancel {
    [self StopLoading];
}
- (void)getCart
{
    _dataArray = [[NSMutableArray alloc]init];
    [self StartLoading];
    _getCartManager = [[ImageDownManager alloc] init];
    _getCartManager.delegate = self;
    _getCartManager.OnImageDown = @selector(OnGetCartFinish:);
    _getCartManager.OnImageFail = @selector(OnLoadFail:);
    NSString *urlstr = [NSString stringWithFormat:@"%@flow.php",SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //rctailor.ec51.com.cn/soaapi/soap/flow.php?act=getCart&pageSize=1&pageIndex=1&token=639d8b5b131b90e28b3e66ca2b86c800
    [dict setObject:kkToken forKey:@"token"];
    [dict setObject:@"getCart" forKey:@"act"];
    [dict setObject:@"1" forKey:@"pageSize"];
    [dict setObject:@"1" forKey:@"pageIndex"];
    [_getCartManager PostHttpRequest:urlstr :dict];
}
- (void)OnGetCartFinish:(ImageDownManager *)sender
{
    NSDictionary *dict = [sender.mWebStr JSONValue];
    NSLog(@"购物车里----->%@",dict);
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSArray *listArray = [[NSArray alloc]init];
        listArray = [dict objectForKey:@"goods_list"];
        for (NSDictionary *listDict in listArray) {
            ShoppingCarModel *model = [[ShoppingCarModel alloc]init];
            for (NSString *key in listDict) {
                [model setValue:listDict[key] forKey:key];
            }
            [_dataArray addObject:model];
        }
        [myTableView reloadData];
    }
    if (_dataArray.count == 0) {
        [AutoAlertView ShowMessage:@"您的购物车没有商品"];
    }
    NSLog(@"购物车里一共有--->%d件商品",_dataArray.count);
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    NSLog(@"下载失败");
    [self Cancel];
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
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ShopCarCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[ShopCarCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    ShoppingCarModel *model = _dataArray[indexPath.section];
    [cell LoadContent:model];
    cell.index = indexPath.section;
    cell.delegate = self;
    cell.onDelete = @selector(DeleteGoods:);
    cell.onDesign = @selector(DesiginGoods:);
    cell.addBtnClick = @selector(addBtnClick:);
    cell.cutBtnClick = @selector(cutBtnClick:);
    if ([cell.sNumber.text intValue]==1) {
        cell.cutBtn.selected = NO;
    }
    else{
        cell.cutBtn.selected = YES;
    }
    return cell;
}
- (void)addBtnClick:(ShopCarCell *)sender
{
    NSLog(@"增加购物车里第 %d 个商品的数量",sender.index);
    ShoppingCarModel *model = [_dataArray objectAtIndex:sender.index];
    model.quantity++;
    [_dataArray removeObjectAtIndex:sender.index];
    [_dataArray insertObject:model atIndex:sender.index];
}
- (void)cutBtnClick:(ShopCarCell *)sender
{
    NSLog(@"减少购物车里第 %d 个商品的数量",sender.index);
    ShoppingCarModel *model = [_dataArray objectAtIndex:sender.index];
    model.quantity--;
    [_dataArray removeObjectAtIndex:sender.index];
    [_dataArray insertObject:model atIndex:sender.index];
}
- (void)CheckList
{
    if (_dataArray.count == 0) {
        [AutoAlertView ShowMessage:@"您的购物车没有商品"];
    }
    else{
        CheckListViewController *clvc = [[CheckListViewController alloc]init];
        clvc.goodsArray = _dataArray;
        [self.navigationController pushViewController:clvc animated:YES];
    }
}
- (void)DesiginGoods:(ShopCarCell *)sender
{
    NSLog(@"设计第 %d 个商品",sender.index);
   
    MyCustomDetailViewController *mcdvc = [[MyCustomDetailViewController alloc] init];
    ShoppingCarModel *model = _dataArray[sender.index];
    NSLog(@"model.rec_id---->%d",model.rec_id);
    mcdvc.IDStr = model.goods_id;
    mcdvc.rec_id = [NSString stringWithFormat:@"%d",model.rec_id];
    [mcdvc StartDownload];
    [self.navigationController pushViewController:mcdvc animated:YES];
}

- (void)DeleteGoods:(ShopCarCell *)sender;
{
    NSLog(@"删除第 %d 商品",sender.index);
    [self delCart:sender];
}
- (void)delCart:(ShopCarCell *)sender
{
    int index = sender.index;
    [self StartLoading];
    ShoppingCarModel *model = _dataArray[index];
    NSString *idStr = [NSString stringWithFormat:@"%d",model.rec_id];
    _delCarManager = [[ImageDownManager alloc] init];
    _delCarManager.tag = index;
    _delCarManager.delegate = self;
    _delCarManager.OnImageDown = @selector(OnDelCartFinish:);
    _delCarManager.OnImageFail = @selector(OnLoadFail:);
    NSString *urlstr = [NSString stringWithFormat:@"%@flow.php",SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //rctailor.ec51.com.cn/soaapi/soap/flow.php?act=delCart&recId=3&token=639d8b5b131b90e28b3e66ca2b86c800
    [dict setObject:kkToken forKey:@"token"];
    [dict setObject:@"delCart" forKey:@"act"];
    [dict setObject:idStr forKey:@"recId"];
    [_delCarManager PostHttpRequest:urlstr :dict];
}
- (void)OnDelCartFinish:(ImageDownManager *)sender
{
    [self Cancel];
    NSDictionary *dict = [sender.mWebStr JSONValue];
    NSLog(@"删除结果----->%@",[dict objectForKey:@"statusCode"]);
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        if ([[dict objectForKey:@"statusCode"] intValue] == 0) {
            [_dataArray removeObjectAtIndex:sender.tag];
            [myTableView reloadData];
            [AutoAlertView ShowMessage:@"删除成功"];
        }
        else{
            [AutoAlertView ShowMessage:@"删除失败"];
        }
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
