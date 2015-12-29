//
//  CoolCommentListViewController.m
//  TestRedCollar
//
//  Created by dreamRen on 14-7-21.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "CoolCommentListViewController.h"
#import "JSON.h"
#import "CommentModel.h"
#import "CoolCommentModel.h"
#import "NewCommentView.h"
#import "FansInfoViewController.h"
#import "CommentListView.h"

@interface CoolCommentListViewController ()

@end

@implementation CoolCommentListViewController

@synthesize mDownManager;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.dataArray = [NSMutableArray arrayWithCapacity:0];
        self.pageIndex = 1;
        self.olderArrayNum = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.91 alpha:1.0];

    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];

    mTableView = [[RefreshTableView alloc] initWithFrame:self.view.bounds];
    mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    mTableView.backgroundColor = self.view.backgroundColor;
    mTableView.delegate = self;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mTableView];
    
    [self ReloadList:nil];
}

- (void)ReloadList:(RefreshTableView *)sender {
    self.pageIndex = 1;
    [self LoadCommentList];
}

- (void)LoadMoreList:(RefreshTableView *)sender {
    [self LoadCommentList];
}

- (BOOL)CanRefreshTableView:(RefreshTableView *)sender {
    return !mDownManager;
}

#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CoolCommentModel *model = self.dataArray[indexPath.row];
    CGSize size = [model.content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(190, 999) lineBreakMode:NSLineBreakByWordWrapping];
    
	return size.height+20+20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CoolCommentModel *model2  = self.dataArray[indexPath.row];
    NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        CGSize size = [model2.content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(190, 999) lineBreakMode:NSLineBreakByWordWrapping];
        int width = mTableView.frame.size.width-20;
        CommentListView *comView = [[CommentListView alloc] initWithFrame:CGRectMake(10, 0, width, size.height+30)];
        comView.delegate = self;
        comView.didSelected = @selector(didClickComment:);
        comView.tag = 3000;
        [cell.contentView addSubview:comView];
    }
    
    
    CommentListView *comView = (CommentListView *)[cell.contentView viewWithTag:3000];
    if (comView) {
        [comView loadCoolCommentContent:model2];
    }
    return cell;
}

#pragma mark 点击评论的用户头像,进入该用户的详情页
- (void)didClickComment:(CoolCommentModel *)model
{
    FansInfoViewController *ctrl = [[FansInfoViewController alloc] init];
    ctrl.isAdded = YES;
    ctrl.userID = model.uid;
    [self.navigationController pushViewController:ctrl animated:YES];
}

#pragma mark 数据下载
#pragma mark - ImageDownManager

- (void)Cancel{
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (void)LoadCommentList {
    if (self.mDownManager) {
        return;
    }
    [self StartLoading];
    
    self.mDownManager = [[ImageDownManager alloc] init];
    self.mDownManager.delegate = self;
    self.mDownManager.OnImageDown = @selector(OnLoadFinish:);
    self.mDownManager.OnImageFail = @selector(OnLoadFail:);
    ////rctailor.ec51.com.cn/soaapi/soap/goods.php?act=getThemeComment&pageSize=1&pageIndex=1&id=23
    NSString *urlstr = [NSString stringWithFormat:@"%@flow.php", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.isTheme && self.isTheme == YES) {
        [dict setObject:@"getThemeComment" forKey:@"act"];
        urlstr = [NSString stringWithFormat:@"%@goods.php",SERVER_URL];
    }else{
        [dict setObject:@"getCommentList" forKey:@"act"];
    }
    [dict setObject:@"15" forKey:@"pageSize"];
    [dict setObject:[NSString stringWithFormat:@"%d",self.pageIndex] forKey:@"pageIndex"];
    [dict setObject:self.urlID forKey:@"id"];
    [self.mDownManager PostHttpRequest:urlstr :dict];
}

- (void)OnLoadFinish:(ImageDownManager *)sender {
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    NSLog(@"dict--->%@",dict);
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        if (self.pageIndex == 1) {
            [self.dataArray removeAllObjects];
        }
        if (self.isTheme == NO) {
            NSDictionary *comment_list = [dict objectForKey:@"comment_list"];
            NSArray *array = [UserInfoManager DictionaryToArray:comment_list desc:YES];
            if (array) {
                for (NSDictionary *tmpdict in array) {
                    CoolCommentModel *model = [CoolCommentModel CreateWithDict:tmpdict];
                    [self.dataArray addObject:model];
                }
            }
            mTableView.mbMoreHidden = !(array.count == 15);
        }
        else if(self.isTheme){
            NSDictionary *comment_list = [dict objectForKey:@"list"];
            if (comment_list && comment_list.count > 0 && [comment_list isKindOfClass:[NSDictionary class]]) {
                for (NSString *key in comment_list) {
                    NSDictionary *keyDict = comment_list[key];
                    if (keyDict && [keyDict isKindOfClass:[NSDictionary class]]) {
                        CoolCommentModel *model = [CoolCommentModel CreateWithDict:keyDict];
                        [self.dataArray addObject:model];
                    }
                }
            }
            mTableView.mbMoreHidden = !(comment_list.count == 15);
        }
        
        [mTableView FinishLoading];
        [mTableView reloadData];
        
        self.pageIndex ++;
    }
}

- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  dealloc;
- (void)dealloc {
    [self Cancel];
    self.dataArray = nil;
}

@end
