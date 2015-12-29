//
//  FansListViewController.m
//  TestRedCollar
//
//  Created by dreamRen on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "FansListViewController.h"
#import "FansListCell.h"
#import "FansInfoViewController.h"
#import "JSON.h"
#import "FansList.h"

@interface FansListViewController ()
{
    NSMutableArray *theList;
    int iDiff;
}
@end

@implementation FansListViewController

@synthesize mDownManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        theList = [[NSMutableArray alloc] init];
        iDiff = -1;
        self.pageIndex = 1;
    }
    return self;
}

- (void)connectToServer
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
    [dict setObject:@"fansList" forKey:@"act"];
    [dict setObject:[NSNumber numberWithInt:self.pageIndex] forKey:@"pageIndex"];
    [dict setObject:[NSNumber numberWithInt:10] forKey:@"pageSize"];
    [dict setObject:_userID forKey:@"userid"];
    
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
    if (dict && [dict isKindOfClass:[NSDictionary class]])
    {
        if (self.pageIndex == 1) {
            [theList removeAllObjects];
        }
        NSDictionary *sonDict = [dict objectForKey:@"list"];
        NSArray *array = [UserInfoManager DictionaryToArray:sonDict];
        if (array) {
            for (NSDictionary *tmpDict in array) {
                FansList *list = [FansList CreateWithDict:tmpDict];
                if (list) {
                    [theList addObject:list];
                }
            }
        }
        mTableView.mbMoreHidden = (array.count < 15);
        [mTableView FinishLoading];
        [mTableView reloadData];
    }
}

- (void)OnLoadFail:(ImageDownManager *)sender
{
    [self Cancel];
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
    
    [self connectToServer];
}

- (void)ReloadList:(RefreshTableView *)sender {
    self.pageIndex = 1;
    [self connectToServer];
}

- (void)LoadMoreList:(RefreshTableView *)sender {
    self.pageIndex++;
    [self connectToServer];
}

- (BOOL)CanRefreshTableView:(RefreshTableView *)sender {
    return !mDownManager;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return theList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //行高
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell00";
    FansListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[FansListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.delegate = self;
        cell.onButtonClick = @selector(fansList:);
        //cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row == 0){
        UIImageView *sepImage = [[UIImageView alloc] init];
        sepImage.frame = CGRectMake(0, 0, self.view.frame.size.width, 1);
        sepImage.image = [UIImage imageNamed:@"my_32.png"];
        [cell addSubview:sepImage];
    }
    
    FansList *list = [theList objectAtIndex:indexPath.row];

    [cell.aImageView GetImageByStr:list.headImageUrl];
    cell.aImageView.layer.masksToBounds = YES;
    cell.aImageView.layer.cornerRadius = cell.aImageView.bounds.size.width/2;
    cell.aTextLabel.text = [UserInfoManager GetSecretName:list.nickName username:list.user_name];
    cell.aDetailLabel.text = list.signature;
    
    if ([list.mutually intValue] == 1) {
        [cell.cancelAttBtn setImage:[UIImage imageNamed:@"mguanzhu_06.png"] forState:UIControlStateNormal];
    } else if ([list.mutually intValue] == 0) {
        [cell.cancelAttBtn setImage:[UIImage imageNamed:@"m2_03.png"] forState:UIControlStateNormal];
    }
    
    for (UIView *view in cell.contentView.subviews) {
        if ([view isKindOfClass:[UIButton class]]){
            view.tag = indexPath.row;
        }
    }
    return cell;
}

- (void)fansList:(id)sender
{
    int mutually = [((FansList *)[theList objectAtIndex:[sender intValue]]).mutually intValue];
    NSString *othersID = ((FansList *)[theList objectAtIndex:[sender intValue]]).ID;
    [self fansListOperation:mutually withID:othersID];
    iDiff = mutually;
}

- (void)fansListOperation:(int)mutually withID:(NSString *)othersID
{
    if (mDownManager) {
        return;
    }
    [self StartLoading];
    
    self.mDownManager = [[ImageDownManager alloc] init];
    mDownManager.delegate = self;
    mDownManager.OnImageDown = @selector(OperationFinish:);
    mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *urlstr = [NSString stringWithFormat:@"%@club.php", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"noticeuser" forKey:@"act"];
    [dict setObject:kkToken forKey:@"token"];
    [dict setObject:othersID forKey:@"targetid"];
    [dict setObject:[NSString stringWithFormat:@"%d",mutually+1] forKey:@"state"];
    [mDownManager PostHttpRequest:urlstr :dict];
}

- (void)OperationFinish:(ImageDownManager *)sender
{
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        if ([[dict objectForKey:@"statusCode"] intValue] == 0) {
            if (iDiff == 1) {
                [self showMsg:@"取消关注"];
            } else {
                [self showMsg:@"成功关注"];
            }
            theList = [[NSMutableArray alloc] init];
            [self connectToServer];
        }
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    FansInfoViewController *tViewCtr = [[FansInfoViewController alloc] init];
    tViewCtr.isAdded = _isAdded;
    tViewCtr.userID = ((FansList *)[theList objectAtIndex:indexPath.row]).ID;
    tViewCtr.delegate = self;
    tViewCtr.onSaveClick = @selector(refreshView);
    [self.navigationController pushViewController:tViewCtr animated:YES];
}

- (void)refreshView
{
    theList = [[NSMutableArray alloc] init];
    [self connectToServer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
