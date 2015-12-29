//
//  AlbumViewController.m
//  TestRedCollar
//
//  Created by miracle on 14-7-10.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "AlbumViewController.h"
#import "JSON.h"
#import "PhotoList.h"
#import "UpLoadPhotoViewController.h"
#import "PicturesViewController.h"

@interface AlbumViewController () {
    NSString *str;
    BOOL iType;
}

@end

@implementation AlbumViewController

@synthesize mDownManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.mArray = [[NSMutableArray alloc] init];
        self.pageIndex = 1;
        iType = NO;
    }
    return self;
}

- (void)refreshView
{
    _mArray = [[NSMutableArray alloc] init];
    [self loadData];
}

- (void)addPhoto
{
    UpLoadPhotoViewController *upLoadPhoto = [[UpLoadPhotoViewController alloc] init];
    upLoadPhoto.theTitleText = @"街拍上传";
    upLoadPhoto.delegate = self;
    upLoadPhoto.onSaveClick = @selector(refreshView);
    [self.navigationController pushViewController:upLoadPhoto animated:YES];
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
    
    self.title = @"街拍相册";
    self.view.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1.0];
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:[UIImage imageNamed:@"my_44.png"] target:self action:@selector(addPhoto)];
    
    mTableView = [[RefreshTableView alloc] initWithFrame:self.view.bounds];
    mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    mTableView.delegate = self;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mTableView];
    
    [self loadData];
}

- (void)ReloadList:(RefreshTableView *)sender {
    self.pageIndex = 1;
    [self loadData];
}

- (void)LoadMoreList:(RefreshTableView *)sender {
    [self loadData];
}

- (BOOL)CanRefreshTableView:(RefreshTableView *)sender {
    return !mDownManager;
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
        
    NSString *leftimage = ((PhotoList *)[_mArray objectAtIndex:index]).top_url;
    NSString *leftid = ((PhotoList *)[_mArray objectAtIndex:index]).ID;
    NSString *rightimage = nil;
    NSString *rightid = nil;
    if (index+1 < _mArray.count)
    {
        rightimage = ((PhotoList *)[_mArray objectAtIndex:index+1]).top_url;
        rightid = ((PhotoList *)[_mArray objectAtIndex:index+1]).ID;
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
    UIActionSheet *actView = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"图片列表", @"删除", nil];
    str = selectID;
    [actView showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        PicturesViewController *pictures = [[PicturesViewController alloc] init];
        pictures.albumID = str;
        [self.navigationController pushViewController:pictures animated:YES];
    }else if (buttonIndex == 1) {
        iType = YES;
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
        [dict setObject:@"delAlbum" forKey:@"act"];
        [dict setObject:str forKey:@"id"];
        [self.mDownManager PostHttpRequest:urlstr :dict];
    }
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
    [dict setObject:@"getAlbum" forKey:@"act"];
    [dict setObject:@"10" forKey:@"pageSize"];
    [dict setObject:[NSNumber numberWithInt:self.pageIndex] forKey:@"pageIndex"];
    [dict setObject:kkToken forKey:@"token"];
    
    [self.mDownManager PostHttpRequest:urlstr :dict];
}

- (void)OnLoadFinish:(ImageDownManager *)sender
{
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    NSLog(@"dict--->%@",dict);
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        if (!iType) {
            if (self.pageIndex == 1) {
                [_mArray removeAllObjects];
            }
            NSDictionary *list = [dict objectForKey:@"list"];
            NSArray *array = [UserInfoManager DictionaryToArray:list];
            if (array) {
                for (NSDictionary *tmpDict in array) {
                    PhotoList *list = [PhotoList CreateWithDict:tmpDict];
                    if (list) {
                        [_mArray addObject:list];
                    }
                }
            }
            mTableView.mbMoreHidden = (array.count < 10);
            [mTableView FinishLoading];
            [mTableView reloadData];
        }else {
            if ([[dict objectForKey:@"statusCode"] intValue] == 0) {
                [self showMsg:[dict objectForKey:@"msg"]];
                _mArray = [[NSMutableArray alloc] init];
                [self loadData];
                iType = NO;
            }
        }
    }
}

- (void)OnLoadFail:(ImageDownManager *)sender
{
    [self Cancel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
