//
//  PicturesViewController.m
//  TestRedCollar
//
//  Created by miracle on 14-8-9.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "PicturesViewController.h"
#import "JSON.h"
#import "PicturesViewController.h"
#import "CoolListModel.h"
#import "CoolDetailViewController.h"

@interface PicturesViewController ()

@end

@implementation PicturesViewController

@synthesize mDownManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _mArray = [[NSMutableArray alloc] init];
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
    
    self.title = @"图片列表";
    self.view.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1.0];
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
    
    mTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mTableView.backgroundColor = [UIColor clearColor];
    mTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:mTableView];
    
    [self loadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int iCount = _mArray.count/2;
    if (_mArray.count%2)
    {
        iCount ++;
    }
    return iCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"CellIdentifier%d", indexPath.section];
    PhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[PhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.delegate = self;
    }
    
    int index = indexPath.row*2;
    NSString *leftimage = ((CoolListModel *)[_mArray objectAtIndex:index]).url;
    NSString *leftid = ((CoolListModel *)[_mArray objectAtIndex:index])._id;
    NSString *rightimage = nil;
    NSString *rightid = nil;
    if (index+1 < _mArray.count)
    {
        rightimage = ((CoolListModel *)[_mArray objectAtIndex:index+1]).url;
        rightid = ((CoolListModel *)[_mArray objectAtIndex:index+1])._id;
    }
    [cell photoCellLeftName:leftimage RightName:rightimage];
    [cell photoCellLeftID:leftid RightID:rightid];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)photoCellSelect:(NSString *)selectID
{
    CoolDetailViewController *ctrl = [[CoolDetailViewController alloc] init];
    for (int i = 0; i < _mArray.count; i++) {
        CoolListModel *model = [_mArray objectAtIndex:i];
        if ([model._id isEqualToString:selectID]) {
            ctrl.model = model;
        }
    }
    ctrl.type = 3;
    [self.navigationController pushViewController:ctrl animated:YES];
}

#pragma mark - ImageDownManager

- (void)Cancel
{
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (void)loadData
{
    if (self.mDownManager) {
        return;
    }
    [self StartLoading];
    
    self.mDownManager = [[ImageDownManager alloc] init];
    self.mDownManager.delegate = self;
    self.mDownManager.OnImageDown = @selector(OnLoadFinish:);
    self.mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *urlstr = [NSString stringWithFormat:@"%@flow.php",SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"getAlbumDetail" forKey:@"act"];
    [dict setObject:_albumID forKey:@"album_id"];
    [dict setObject:kkToken forKey:@"token"];
    
    [self.mDownManager PostHttpRequest:urlstr :dict];
}

- (void)OnLoadFinish:(ImageDownManager *)sender
{
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSDictionary *listDict = [dict objectForKey:@"list"];
        for (NSString *key in listDict.allKeys) {
            NSDictionary *sonDict = [listDict objectForKey:key];
            CoolListModel *list = [CoolListModel CreateWithDict:sonDict];
            if (list){
                [_mArray addObject:list];
            }
        }
    }
    [mTableView reloadData];
}

- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
