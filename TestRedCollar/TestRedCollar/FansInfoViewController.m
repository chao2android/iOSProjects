//
//  FansInfoViewController.m
//  TestRedCollar
//
//  Created by dreamRen on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "FansInfoViewController.h"
#import "CoolDetailViewController.h"
#import "JSON.h"
#import "CoolListModel.h"
#import "AutoAlertView.h"
#import "NetImageView.h"
#import "OthersFansListViewController.h"
#import "OthersAttListViewController.h"
#import "UserList.h"

@interface FansInfoViewController ()

@end

@implementation FansInfoViewController
{
    UIImageView *backgroundImage;
    UIImageView *tImageView;
    UserList *user;
    BOOL iSelectType;
}

@synthesize mDownManager;

- (void)Cancel
{
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (void)OnLoadFail:(ImageDownManager *)sender
{
    [self Cancel];
}

//粉丝
-(void)onFansClick
{
    OthersFansListViewController *tViewCtr = [[OthersFansListViewController alloc] init];
    tViewCtr.theTitleText = @"粉丝";
    tViewCtr.isAdded = NO;
    tViewCtr.userID = _userID;
    [self.navigationController pushViewController:tViewCtr animated:YES];
}

//关注
-(void)onGuanZhuClick
{
    OthersAttListViewController *tViewCtr = [[OthersAttListViewController alloc] init];
    tViewCtr.theTitleText = @"关注";
    tViewCtr.userID = _userID;
    tViewCtr.isAdded = YES;
    [self.navigationController pushViewController:tViewCtr animated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.mArray = [[NSMutableArray alloc] init];
        self.pageIndex = 1;
        iSelectType = NO;
    }
    return self;
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
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.91 alpha:1.0];
    self.title = @"他的主页";
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
    
    backgroundImage = [[UIImageView alloc] init];
    backgroundImage.frame = CGRectMake(0, 0, self.view.frame.size.width, 95);
    backgroundImage.backgroundColor = [UIColor clearColor];
    backgroundImage.image = [UIImage imageNamed:@"s_02.png"];
    [self.view addSubview:backgroundImage];
    
    tImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, backgroundImage.frame.size.height, self.view.frame.size.width, 44)];
    tImageView.userInteractionEnabled = YES;
    tImageView.image = [UIImage imageNamed:@"my_39.png"];
    [self.view addSubview:tImageView];
    
    UIImageView *sepImage = [[UIImageView alloc] initWithFrame:CGRectMake(160,95+8, 1, 28)];
    sepImage.image = [UIImage imageNamed:@"my_40.png"];
    [self.view addSubview:sepImage];
    
    UIImageView *sepImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 139, 320, 1)];
    sepImageView.image = [UIImage imageNamed:@"my_32.png"];
    [self.view addSubview:sepImageView];
    
    int iWidth = self.view.frame.size.width/2;
    for (int i = 0; i < 2; i ++)
    {
        NSString *imagename = [NSString stringWithFormat:@"my%d1", 35+i];
        NSString *imagename2 = [NSString stringWithFormat:@"my%d.png", 35+i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(iWidth*i+(iWidth-92)/2, 0, 92, 44);
        btn.tag = i;
        btn.backgroundColor = [UIColor clearColor];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [btn setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imagename2] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(OnTabSelect:) forControlEvents:UIControlEventTouchUpInside];
        [tImageView addSubview:btn];
        if (i == 0) {
            mSelectBtn = btn;
            [mSelectBtn setSelected:YES];
        }
    }
    
    iCurType = 0;
    [self loadUserInfoData];
}

- (void)loadUserInfoData
{
    if (self.mDownManager) {
        return;
    }
    [self StartLoading];
    
    self.mDownManager = [[ImageDownManager alloc] init];
    self.mDownManager.delegate = self;
    self.mDownManager.OnImageDown = @selector(OnLoadUserInfoFinish:);
    self.mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *urlstr = [NSString stringWithFormat:@"%@club.php", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"getUserInfo" forKey:@"act"];
    [dict setObject:_userID forKey:@"userid"];
    [dict setObject:kkUserID forKey:@"mineuserid"];
    
    [self.mDownManager PostHttpRequest:urlstr :dict];
}

- (void)OnLoadUserInfoFinish:(ImageDownManager *)sender
{
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSDictionary *sonDict = [dict objectForKey:@"list"];
        if (sonDict && [sonDict isKindOfClass:[NSDictionary class]]) {
            user = [UserList CreateWithDict:sonDict];
        }
    }
    
    [self loadMyInfoView];
    [self downLoadPhoto];
}

-(void)loadMyInfoView
{
    if ([user.isfollow intValue] == 1) {
        [self AddRightTextBtn:@"取消关注" target:self action:@selector(cancelAttButtonClick)];
    }else {
        [self AddRightTextBtn:@"      关注" target:self action:@selector(addAttButtonClick)];
    }
    
    UIButton *backgroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backgroundBtn.frame = CGRectMake(0, 0, self.view.frame.size.width, 95);
    backgroundBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backgroundBtn];
    
    NetImageView *netImage = [[NetImageView alloc] initWithFrame:CGRectMake(20, 20, 57, 57)];
    netImage.mDefaultImage = [UIImage imageNamed:@"default_avatar"];
    netImage.backgroundColor = [UIColor clearColor];
    netImage.userInteractionEnabled = NO;
    [backgroundBtn addSubview:netImage];
    
    if (user.portrait && user.portrait.length > 0) {
        NSRange range = [user.portrait rangeOfString:@"http://"];
        if (range.length == 0) {
            user.portrait = [NSString stringWithFormat:@"%@%@",URL_HEADER,user.portrait];
        }
    }
    
    [netImage GetImageByStr:user.portrait];
    netImage.layer.masksToBounds = YES;
    netImage.layer.cornerRadius = netImage.bounds.size.width/2;
    
    theNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(netImage.frame.origin.x+netImage.frame.size.width+15, netImage.frame.origin.y+2, 135, 23)];
    theNameLabel.backgroundColor = [UIColor clearColor];
    theNameLabel.textColor = [UIColor whiteColor];
    theNameLabel.font = [UIFont boldSystemFontOfSize:18];
    theNameLabel.text = [UserInfoManager GetSecretName:user.nickname username:user.user_name];
    CGSize size = [theNameLabel.text sizeWithFont:[UIFont systemFontOfSize:18]];
    if (size.width <= 150) {
        [theNameLabel sizeToFit];
    }
    [backgroundBtn addSubview:theNameLabel];
    
    //关注
    UIButton *followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    followBtn.frame = CGRectMake(theNameLabel.frame.origin.x, 53, 80, 20);
    if (user.follows == nil) {
        user.follows = @"0";
        
    }
    [followBtn setTitle:[NSString stringWithFormat:@"%@ 关注",user.follows] forState:UIControlStateNormal];
    followBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [followBtn addTarget:self action:@selector(onGuanZhuClick) forControlEvents:UIControlEventTouchUpInside];
    followBtn.backgroundColor = [UIColor clearColor];
    followBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backgroundBtn addSubview:followBtn];
    
    //粉丝
    UIButton *fanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fanBtn.frame = CGRectMake(theNameLabel.frame.origin.x+80, 53, 80, 20);
    if (user.fans == nil) {
        user.fans = @"0";
    }
    [fanBtn setTitle:[NSString stringWithFormat:@"%@ 粉丝",user.fans] forState:UIControlStateNormal];
    fanBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [fanBtn addTarget:self action:@selector(onFansClick) forControlEvents:UIControlEventTouchUpInside];
    fanBtn.backgroundColor = [UIColor clearColor];
    fanBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backgroundBtn addSubview:fanBtn];
}

//加关注
-(void)addAttButtonClick
{
    if (self.mDownManager) {
        return;
    }
    [self StartLoading];
    
    self.mDownManager = [[ImageDownManager alloc] init];
    self.mDownManager.delegate = self;
    self.mDownManager.OnImageDown = @selector(OnLoadFinishAddAtt:);
    self.mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *urlstr = [NSString stringWithFormat:@"%@club.php",SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"noticeuser" forKey:@"act"];
    [dict setObject:kkToken forKey:@"token"];
    [dict setObject:self.userID forKey:@"targetid"];
    [dict setObject:@"1" forKey:@"state"];
    [self.mDownManager PostHttpRequest:urlstr :dict];
}

- (void)OnLoadFinishAddAtt:(ImageDownManager *)sender {
    
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        if ([[dict objectForKey:@"statusCode"] intValue] == 0) {
            [AutoAlertView ShowAlert:@"提示" message:@"关注成功"];
            [self AddRightTextBtn:@"取消关注" target:self action:@selector(cancelAttButtonClick)];
        }
    }
}

//取消关注
- (void)cancelAttButtonClick
{
    if (self.mDownManager) {
        return;
    }
    [self StartLoading];
    
    self.mDownManager = [[ImageDownManager alloc] init];
    self.mDownManager.delegate = self;
    self.mDownManager.OnImageDown = @selector(OnLoadFinishCancelAtt:);
    self.mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *urlstr = [NSString stringWithFormat:@"%@club.php", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"noticeuser" forKey:@"act"];
    [dict setObject:kkToken forKey:@"token"];
    [dict setObject:self.userID forKey:@"targetid"];
    [dict setObject:@"2" forKey:@"state"];
    [self.mDownManager PostHttpRequest:urlstr :dict];
}

- (void)OnLoadFinishCancelAtt:(ImageDownManager *)sender
{
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        if ([[dict objectForKey:@"statusCode"] intValue] == 0) {
            [AutoAlertView ShowAlert:@"提示" message:@"取消关注"];
            [self AddRightTextBtn:@"      关注" target:self action:@selector(addAttButtonClick)];
        }
    }
}

- (void)OnTabSelect:(UIButton *)sender
{
    if (iCurType == sender.tag) {
        iSelectType = YES;
        return;
    }
    iCurType = sender.tag;
    iSelectType = NO;
    for (UIView *view in self.view.subviews){
        if ([view isKindOfClass:[RefreshTableView class]]) {
            [view removeFromSuperview];
            self.mArray = [[NSMutableArray alloc] init];
            self.pageIndex = 1;
        }
    }
    
    [mSelectBtn setSelected:NO];
    mSelectBtn = sender;
    [mSelectBtn setSelected:YES];
    
    if (sender.tag == 0) {
        [self downLoadPhoto];
    }else if (sender.tag == 1) {
        [self downLoadProject];
    }
}

- (void)addRefreshTableView
{
    int iTop = tImageView.frame.origin.y+tImageView.frame.size.height+5;
    int iHeight = self.view.frame.size.height-iTop;
    
    mTableView = [[RefreshTableView alloc] initWithFrame:CGRectMake(0, iTop, self.view.frame.size.width, iHeight)];
    mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    mTableView.delegate = self;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mTableView];
}

- (void)downLoadPhoto
{
    if (self.mDownManager) {
        return;
    }
    [self StartLoading];
    
    self.mDownManager = [[ImageDownManager alloc] init];
    self.mDownManager.delegate = self;
    self.mDownManager.OnImageDown = @selector(OnLoadFinishPhoto:);
    self.mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *urlstr = [NSString stringWithFormat:@"%@flow.php",SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"myphotoList" forKey:@"act"];
    [dict setObject:self.userID forKey:@"uid"];
    [dict setObject:@"6" forKey:@"pageSize"];
    [dict setObject:[NSString stringWithFormat:@"%d",self.pageIndex] forKey:@"pageIndex"];
    [self.mDownManager PostHttpRequest:urlstr :dict];
}

- (void)OnLoadFinishPhoto:(ImageDownManager *)sender {
    
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        if (self.pageIndex == 1) {
            [_mArray removeAllObjects];
        }
        NSDictionary *list = [dict objectForKey:@"photo_list"];
        if (list.count != 0) {
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
            if (!iSelectType) {
                [self addRefreshTableView];
                iSelectType = YES;
            }
        }else {
            [AutoAlertView ShowAlert:@"提示" message:@"他还没有街拍"];
        }
    }
}

- (void)downLoadProject
{
    if (self.mDownManager) {
        return;
    }
    [self StartLoading];
    
    self.mDownManager = [[ImageDownManager alloc] init];
    self.mDownManager.delegate = self;
    self.mDownManager.OnImageDown = @selector(OnLoadFinishProject:);
    self.mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *urlstr = [NSString stringWithFormat:@"%@flow.php",SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"myDesignList" forKey:@"act"];
    [dict setObject:self.userID forKey:@"uid"];
    [dict setObject:@"10" forKey:@"pageSize"];
    [dict setObject:[NSString stringWithFormat:@"%d",self.pageIndex] forKey:@"pageIndex"];
    [self.mDownManager PostHttpRequest:urlstr :dict];
}

- (void)OnLoadFinishProject:(ImageDownManager *)sender
{
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        if (self.pageIndex == 1) {
            [_mArray removeAllObjects];
        }
        NSDictionary *list = [dict objectForKey:@"photo_list"];
        if (list.count != 0) {
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
            if (!iSelectType) {
                [self addRefreshTableView];
                iSelectType = YES;
            }
        }else {
            [AutoAlertView ShowAlert:@"提示" message:@"他还没有设计"];
        }
    }
}

- (void)ReloadList:(RefreshTableView *)sender
{
    self.pageIndex = 1;
    if (iCurType == 0) {
        [self downLoadPhoto];
    }else if (iCurType == 1) {
        [self downLoadProject];
    }
}

- (void)LoadMoreList:(RefreshTableView *)sender
{
    self.pageIndex++;
    if (iCurType == 0) {
        [self downLoadPhoto];
    }else if (iCurType == 1) {
        [self downLoadProject];
    }
}

- (BOOL)CanRefreshTableView:(RefreshTableView *)sender
{
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

- (void)projectCellSelect:(NSString *)selectID
{
    CoolDetailViewController *ctrl = [[CoolDetailViewController alloc] init];
    for (int i = 0; i < _mArray.count; i++) {
        CoolListModel *model = [_mArray objectAtIndex:i];
        if ([model._id isEqualToString:selectID]) {
            ctrl.model = model;
        }
    }
    ctrl.type = 1;
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
