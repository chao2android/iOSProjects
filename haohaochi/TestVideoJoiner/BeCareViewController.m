//
//  BeCareViewController.m
//  TestVideoJoiner
//
//  Created by MC on 14-12-3.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BeCareViewController.h"
#import "GuanZhuTableViewCell.h"
#import "ImageDownManager.h"
#import "JSON.h"
#import "BeCareListModel.h"

@interface BeCareViewController ()

@end

@implementation BeCareViewController
{
    UITableView *_mTableView;
    NSMutableArray *_dataArray;
    ImageDownManager *_mDownManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mTopImage = [UIImage imageNamed:@"Image-2"];
    self.mTitleColor = [UIColor whiteColor];
    [self RefreshNavColor];
    
    self.title = @"被关注";
    [self AddLeftImageBtn:[UIImage imageNamed:@"2(7).png"] target:self action:@selector(GoBack)];

    
    _mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth,  KscreenHeigh-61)];
    _mTableView.backgroundColor = [UIColor clearColor];
    _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    [self.view addSubview:_mTableView];
    
    _dataArray = [[NSMutableArray alloc]init];
    
    [self StartDownload];
}

#pragma mark - ImageDownManager
- (void)dealloc {
    [self Cancel];
}
- (void)Cancel{
    [self StopLoading];
    SAFE_CANCEL_ARC(_mDownManager);
}
- (void)StartDownload{
    if(_mDownManager){
        return;
    }
    [self StartLoading];
    
    _mDownManager = [[ImageDownManager alloc] init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *urlstr = [NSString stringWithFormat:@"%@/mobileapi/user/concern_beiguan", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.uId forKey:@"u_id"];
    [_mDownManager GetHttpRequest:urlstr :dict];
}
- (void)OnLoadFinish:(ImageDownManager *)sender {
    
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSLog(@"%@", dict);
        [self HideMsgLabel];
        int iStatus = [[dict objectForKey:@"status"] intValue];
        if (iStatus == 1001) {
            NSArray *array = [dict objectForKey:@"lst"];
            for (int i = 0; i<array.count; i++) {
                NSDictionary *dDict = array[i];
                BeCareListModel *model = [[BeCareListModel alloc]init];
                for (NSString *key in dDict.allKeys) {
                    [model setValue:dDict[key] forKey:key];
                }
                [_dataArray addObject:model];
            }
        }
        else {
            mlbMsg.text = @"没有数据";
            [self ShowMsgLabel];
        }
        NSLog(@"_dataArray---%@",_dataArray);
        [_mTableView reloadData];
    }
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"_dataArray--%@",_dataArray);
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 63.0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellID";
    GuanZhuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[GuanZhuTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row%2==0) {
        cell.contentView.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1];
    }
    else{
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    BeCareListModel *model = _dataArray[indexPath.row];
    [cell LoadView:model];
    return cell;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
