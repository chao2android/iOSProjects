//
//  OthersAttListViewController.m
//  TestRedCollar
//
//  Created by miracle on 14-8-11.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "OthersAttListViewController.h"
#import "FansInfoViewController.h"
#import "AttentionCell.h"
#import "JSON.h"
#import "AttentionList.h"

@interface OthersAttListViewController ()
{
    NSMutableArray *theList;
    BOOL changeType;
    int iDiff;
}
@end

@implementation OthersAttListViewController

@synthesize mDownManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        theList = [NSMutableArray array];
        changeType = NO;
        self.pageIndex = 1;
        iDiff = -1;
    }
    return self;
}

- (void)connectToServer:(NSString *)followID WithFans:(NSString *)is_fans
{
    if (mDownManager) {
        return;
    }
    [self StartLoading];
    
    self.mDownManager = [[ImageDownManager alloc] init];
    mDownManager.delegate = self;
    mDownManager.OnImageDown = @selector(OnLoadFinish:);
    mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *urlstr = [NSString stringWithFormat:@"%@club.php", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (!changeType) {
        [dict setObject:@"noticeList" forKey:@"act"];
        [dict setObject:[NSNumber numberWithInt:self.pageIndex] forKey:@"pageIndex"];
        [dict setObject:[NSNumber numberWithInt:10] forKey:@"pageSize"];
        [dict setObject:_userID forKey:@"userid"];
        [dict setObject:kkToken forKey:@"token"];
    }else if (changeType) {
        [dict setObject:@"noticeuser" forKey:@"act"];
        [dict setObject:kkToken forKey:@"token"];
        [dict setObject:followID forKey:@"targetid"];
        if ([is_fans intValue] == 1) {
            [dict setObject:@"2" forKey:@"state"];
        }else if ([is_fans intValue] == 0) {
            [dict setObject:@"1" forKey:@"state"];
        }
    }
    [mDownManager PostHttpRequest:urlstr :dict];
}

- (void)Cancel
{
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (void)OnLoadFinish:(ImageDownManager *)sender
{
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    NSLog(@"guanzhu dict--->%@",dict);
    if (dict && [dict isKindOfClass:[NSDictionary class]]){
        if (!changeType) {
            if (self.pageIndex == 1) {
                [theList removeAllObjects];
            }
            NSDictionary *sonDict = [dict objectForKey:@"list"];
            NSArray *array = [UserInfoManager DictionaryToArray:sonDict];
            if (array) {
                for (NSDictionary *tmpDict in array) {
                    AttentionList *list = [AttentionList CreateWithDict:tmpDict];
                    if (list) {
                        [theList addObject:list];
                    }
                }
            }
            mTableView.mbMoreHidden = (array.count < 10);
            [mTableView FinishLoading];
            [mTableView reloadData];
        }else if (changeType) {
            if ([[dict objectForKey:@"statusCode"] intValue] == 0) {
                if (iDiff == 1) {
                    [self showMsg:@"取消关注"];
                } else if (iDiff == 0) {
                    [self showMsg:@"成功关注"];
                }
                changeType = NO;
//                theList = [[NSMutableArray alloc] init];
//                [self connectToServer:nil WithFans:nil];
            }
        }
    }
    [mTableView reloadData];
}

- (void)OnLoadFail:(ImageDownManager *)sender
{
    [self Cancel];
}

- (void)GoBack
{
    if (delegate && _onSaveClick) {
        SafePerformSelector([delegate performSelector:_onSaveClick]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    
    self.title = _theTitleText;
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
    
    mTableView = [[RefreshTableView alloc] initWithFrame:self.view.bounds];
    mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    mTableView.delegate = self;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mTableView];
    
    [self connectToServer:nil WithFans:nil];
}

- (void)ReloadList:(RefreshTableView *)sender {
    self.pageIndex = 1;
    [self connectToServer:nil WithFans:nil];
}

- (void)LoadMoreList:(RefreshTableView *)sender {
    self.pageIndex++;
    [self connectToServer:nil WithFans:nil];
}

- (BOOL)CanRefreshTableView:(RefreshTableView *)sender {
    return !mDownManager;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return theList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    AttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[AttentionCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.delegate = self;
        cell.onButtonClick = @selector(cancelAttention:);
    }
    
    if (indexPath.row == 0){
        UIImageView *sepImage = [[UIImageView alloc] init];
        sepImage.frame = CGRectMake(0, 0, self.view.frame.size.width, 1);
        sepImage.image = [UIImage imageNamed:@"my_32.png"];
        [cell addSubview:sepImage];
    }
    
    AttentionList *list = [theList objectAtIndex:indexPath.row];
    [cell.aImageView GetImageByStr:list.headImageUrl];
    cell.aImageView.layer.masksToBounds = YES;
    cell.aImageView.layer.cornerRadius = cell.aImageView.bounds.size.width/2;
    cell.aTextLabel.text = [UserInfoManager GetSecretName:list.nickName username:list.user_name];
    cell.aDetailLabel.text = list.signature;
    
//    if (![list.ID isEqualToString:kkUserID]) {
//        if ([list.is_fans intValue] == 1) {
//            [cell.cancelAttBtn setImage:[UIImage imageNamed:@"mguanzhu_06.png"] forState:UIControlStateNormal];
//        }else if ([list.is_fans intValue] == 0) {
//            [cell.cancelAttBtn setImage:[UIImage imageNamed:@"my_38"] forState:UIControlStateNormal];
//        }
//    }
    
    for (UIView *view in cell.contentView.subviews) {
        if ([view isKindOfClass:[UIButton class]]){
            view.tag = indexPath.row;
        }
    }
    return cell;
}

- (void)cancelAttention:(id)sender
{
    changeType = YES;
    [self connectToServer:((AttentionList *)[theList objectAtIndex:[sender integerValue]]).ID WithFans:((AttentionList *)[theList objectAtIndex:[sender integerValue]]).is_fans];
    iDiff = [((AttentionList *)[theList objectAtIndex:[sender integerValue]]).is_fans intValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![((AttentionList *)[theList objectAtIndex:indexPath.row]).ID isEqualToString:kkUserID]) {
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
        FansInfoViewController *tViewCtr=[[FansInfoViewController alloc] init];
        tViewCtr.isAdded = _isAdded;
        tViewCtr.userID = ((AttentionList *)[theList objectAtIndex:indexPath.row]).ID;
        [self.navigationController pushViewController:tViewCtr animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
