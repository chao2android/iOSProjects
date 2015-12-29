//
//  MyCustomListView.m
//  TestRedCollar
//
//  Created by MC on 14-7-15.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "MyCustomListView.h"
#import "MyCustomTableCell.h"
#import "TypeSelectView.h"
#import "ImageDownManager.h"
#import "JSON.h"
#import "GoodsListModel.h"

#import "MyCustomDetailViewController.h"

@implementation MyCustomListView
{
    int _selected;
    NSMutableArray *_dataArray;
    ImageDownManager *_mDownManager;
    ImageDownManager *_addCartDownManager;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        NSArray *typeArray = [[NSArray alloc]initWithObjects:@"西装",@"衬衣",@"马甲",@"西裤",@"大衣", nil];
        TypeSelectView *selectView = [[TypeSelectView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 41)];
        selectView.mArray = typeArray;
        selectView.delegate = self;
        selectView.OnTypeSelect = @selector(OnTypeSelect:);
        selectView.miIndex = 0;
        [selectView reloadData];
        [self addSubview:selectView];
        _selected = selectView.miIndex;
        
        [self StartDownload];
        
        mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 41, self.frame.size.width, self.frame.size.height-41)];
        mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        mTableView.delegate = self;
        mTableView.dataSource = self;
        mTableView.backgroundColor = [UIColor clearColor];
        mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:mTableView];
    }
    
    return self;
}
- (void)dealloc {
    [self StopLoading];
    SAFE_CANCEL_ARC(_mDownManager);
    SAFE_CANCEL_ARC(_addCartDownManager);
}
#pragma mark - 下载

- (void)StartDownload
{
    _dataArray = [[NSMutableArray alloc]init];
    [self StartLoading];
    _mDownManager = [[ImageDownManager alloc] init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    //rctailor.ec51.com.cn//soaapi/soap/goods.php?act=getGoodsList&type=3&pageSize=10&pageIndex=1
    //http://www.rctailor.com/soaapi/soap/goods.php?act=getGoodsListNew&type=3&pageSize=10&pageIndex=1
    NSString *urlstr = [NSString stringWithFormat:@"%@goods.php",SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *typeStr = [NSString string];
    NSLog(@"_selected===--->%d",_selected);
    if (_selected == 0) {
        typeStr = @"3";
    }
    else if(_selected == 1){
        typeStr = @"3000";
    }
    else if(_selected == 2){
        typeStr = @"4000";
    }
    else if(_selected == 3){
        typeStr = @"2000";
    }
    else if(_selected == 4){
        typeStr = @"6000";
    }
    NSLog(@"type---->%@",typeStr);
    
    [dict setObject:@"1" forKey:@"pageIndex"];
    [dict setObject:@"60" forKey:@"pageSize"];
    [dict setObject:@"getGoodsListNew" forKey:@"act"];
    [dict setObject:typeStr  forKey:@"type"];
    [_mDownManager PostHttpRequest:urlstr :dict];
}
- (void)OnLoadFinish:(ImageDownManager *)sender {
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self StopLoading];
    SAFE_CANCEL_ARC(_mDownManager);
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSLog(@"custtomgoodslist---->%@", dict);
        if ([[dict objectForKey:@"goodslist"] isKindOfClass:[NSArray class]]) {
            NSArray *goodsArr =[dict objectForKey:@"goodslist"];
            for (int i = 0; i<goodsArr.count; i++) {
                NSDictionary *goodDict = goodsArr[i];
                GoodsListModel *model = [[GoodsListModel alloc]init];
                for (NSString *key in goodDict) {
                    [model setValue:goodDict[key] forKey:key];
                }
                [_dataArray addObject:model];
            }
        }
        else if ([[dict objectForKey:@"goodslist"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *goodsDict =[dict objectForKey:@"goodslist"];
            for (NSString *key in goodsDict) {
                NSDictionary *dict = goodsDict[key];
                GoodsListModel *model = [[GoodsListModel alloc]init];
                for (NSString *key1 in dict) {
                    [model setValue:dict[key1] forKey:key1];
                }
                [_dataArray addObject:model];
            }
        }
        [mTableView reloadData];
        NSLog(@"_dataArray--->%@",_dataArray);
    }
}

- (void)OnLoadFail:(ImageDownManager *)sender {
    [self StopLoading];
    if (sender == _mDownManager) {
        SAFE_CANCEL_ARC(_mDownManager);
    }
    else if(sender == _addCartDownManager){
        SAFE_CANCEL_ARC(_addCartDownManager);
    }
}
- (void)OnTypeSelect:(TypeSelectView *)sender
{
    NSLog(@"%d",sender.miIndex);
    if (_selected != sender.miIndex) {
        _selected =sender.miIndex;
        NSLog(@"下载刷新数据");
        [_dataArray removeAllObjects];
        [mTableView reloadData];
        [self StartDownload];
    }
}
- (void)LoadCustomList
{
    
}

#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"_dataArray--->%d",_dataArray.count);
    if (_dataArray.count%2 == 0) {
        return _dataArray.count/2;
    }
    return _dataArray.count/2+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 280;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellId = @"CellIdentifier";
    MyCustomTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (cell == nil) {
        cell = [[MyCustomTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.OnCustomSelect = @selector(OnCustomSelect:);
    }
    cell.imgView2.hidden = NO;
    cell.tag = indexPath.row+5000;
    
    NSMutableArray *modelArr = [NSMutableArray arrayWithCapacity:10];
    GoodsListModel *model1 = _dataArray[2*indexPath.row];
    [modelArr addObject:model1];
    
    if (2*indexPath.row+1<_dataArray.count) {
        GoodsListModel *model2 = _dataArray[2*indexPath.row+1];
        [modelArr addObject:model2];
    }
    else {
        cell.imgView2.hidden = YES;
    }
    
    [cell loadContent:modelArr];
    
    return cell;
}

- (void)OnCustomSelect:(MyCustomTableCell *)sender {
    int index = (sender.tag-5000)*2+sender.miIndex;
    
    MyCustomDetailViewController *mcdvc = [[MyCustomDetailViewController alloc] init];
    GoodsListModel *model = _dataArray[index];
    mcdvc.IDStr = model.cst_id;
    [mcdvc StartDownload];
    [self.mRootCtrl.navigationController pushViewController:mcdvc animated:YES];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
