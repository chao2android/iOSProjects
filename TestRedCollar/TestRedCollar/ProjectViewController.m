//
//  ProjectViewController.m
//  TestRedCollar
//
//  Created by miracle on 14-7-10.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ProjectViewController.h"
#import "JSON.h"
#import "ProjectList.h"
#import "UpLoadProjectViewController.h"
#import "CoolListModel.h"
#import "CoolDetailViewController.h"

@interface ProjectViewController ()
{
    NSString *str;
    BOOL iType;
}
@end

@implementation ProjectViewController

@synthesize mDownManager;

- (void)Cancel
{
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (void)loadData
{
    if (self.mDownManager)
    {
        return;
    }
    [self StartLoading];
    
    self.mDownManager = [[ImageDownManager alloc] init];
    self.mDownManager.delegate = self;
    self.mDownManager.OnImageDown = @selector(OnLoadFinish:);
    self.mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *urlstr = [NSString stringWithFormat:@"%@flow.php",SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"myDesignList" forKey:@"act"];
    [dict setObject:@"10" forKey:@"pageSize"];
    [dict setObject:[NSNumber numberWithInt:self.pageIndex] forKey:@"pageIndex"];
    [dict setObject:kkUserID forKey:@"uid"];
    
    [self.mDownManager PostHttpRequest:urlstr :dict];
}

- (void)OnLoadFinish:(ImageDownManager *)sender
{
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]])
    {
        if (!iType) {
            if (self.pageIndex == 1) {
                [_mArray removeAllObjects];
            }
            NSDictionary *list = [dict objectForKey:@"photo_list"];
            NSArray *array = [UserInfoManager DictionaryToArray:list];
            if (array) {
                for (NSDictionary *tmpDict in array) {
                    CoolListModel *list = [CoolListModel CreateWithDict:tmpDict];
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
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
    UpLoadProjectViewController *upLoadPhoto = [[UpLoadProjectViewController alloc] init];
    upLoadPhoto.theTitleText = @"设计上传";
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
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.91 alpha:1.0];
    self.title = @"个人设计";
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
    self.pageIndex++;
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
	return 220;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"CellIdentifier%d", indexPath.section];
    ProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[ProjectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
    [cell projectCellLeftName:leftimage RightName:rightimage];
    [cell projectCellLeftID:leftid RightID:rightid];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)projectCellSelect:(NSString *)selectID
{
    UIActionSheet *actView = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: @"图片详情", @"删除", nil];
    str = selectID;
    [actView showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        CoolDetailViewController *ctrl = [[CoolDetailViewController alloc] init];
        for (int i = 0; i < _mArray.count; i++) {
            CoolListModel *model = [_mArray objectAtIndex:i];
            if ([model._id isEqualToString:str]) {
                ctrl.model = model;
            }
        }
        ctrl.type = 1;
        [self.navigationController pushViewController:ctrl animated:YES];
    }else if (buttonIndex == 1) {
        iType = YES;
        if (self.mDownManager){
            return;
        }
        [self StartLoading];
        
        self.mDownManager = [[ImageDownManager alloc] init];
        self.mDownManager.delegate = self;
        self.mDownManager.OnImageDown = @selector(OnLoadFinish:);
        self.mDownManager.OnImageFail = @selector(OnLoadFail:);
        
        NSString *urlstr = [NSString stringWithFormat:@"%@flow.php",SERVER_URL];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"delPhoto" forKey:@"act"];
        [dict setObject:str forKey:@"id"];
        
        [self.mDownManager PostHttpRequest:urlstr :dict];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
