//
//  ChatListViewController.m
//  MicroVideo
//
//  Created by iHope on 12-11-19.
//  Copyright (c) 2012年 wei. All rights reserved.
//

#import "ChatListViewController.h"
//#import "UserDetailViewController.h"
//#import "PublishRecordController.h"
#import "TouchImageView.h"
#import "ChatTableCell.h"
#import "AutoAlertView.h"
#import "LargeImageView.h"
#import "WoViewController.h"
@interface ChatListViewController ()

@end

@implementation ChatListViewController

@synthesize mUserID, mType;
@synthesize oldDictionary;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        miPlayIndex = -1;
        mbGPSHidden = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hidesTabBar" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayTabBar" object:nil];
}

- (void)GoBack {
    if (mNewManager) {
        mNewManager.delegate = nil;
        [mNewManager StopCheck];
        [mNewManager release];
        mNewManager = nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@",self.oldDictionary);
    UIImageView * navigation=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, KUIOS_7(44))];
    navigation.userInteractionEnabled=YES;
    navigation.backgroundColor=[UIColor blackColor];
    navigation.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nav_background" ofType:@"png"]];
    [self.view addSubview:navigation];
    [navigation release];
    UILabel * navigationLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, KUIOS_7(11), (Screen_Width-160), 22)];
    navigationLabel.backgroundColor=[UIColor clearColor];
    //    navigationLabel.font=[UIFont systemFontOfSize:22];
    navigationLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:22];
    navigationLabel.textAlignment=NSTextAlignmentCenter;
    navigationLabel.textColor=[UIColor whiteColor];
    navigationLabel.text=@"聊天";
    [navigation addSubview:navigationLabel];
    [navigationLabel release];
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(5, KUIOS_7(7), 51, 33);
    [back setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(GoBack) forControlEvents:UIControlEventTouchUpInside];
    [navigation addSubview:back];

    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, KUIOS_7(44), self.view.frame.size.width, self.view.frame.size.height-44)];
    imageView.backgroundColor=[UIColor blackColor];
    imageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"track-recordback.png"]];
    [self.view addSubview:imageView];
    [imageView release];

    mArray = [[NSMutableArray alloc] initWithCapacity:10];
    
    mTableView = [[RefreshTableView alloc] initWithFrame:CGRectMake(0, KUIOS_7(44), self.view.frame.size.width, self.view.frame.size.height-88)];
    mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    mTableView.delegate = self;
    mTableView.backgroundColor = [UIColor clearColor];
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mTableView];
    [self.view sendSubviewToBack:mTableView];
    [mTableView release];
    
    [self.view sendSubviewToBack:imageView];
    mActView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    mActView.center = mTableView.center;
    [self.view addSubview:mActView];
    [mActView release];
    
    [self HideBotBar];
    miPage = 0;
    [self ReloadList:mTableView];
    
    mNewManager = [[ChatNewManager alloc] init];
    mNewManager.delegate = self;
    mNewManager.OnNewCheck = @selector(OnNewCheck:);
    mNewManager.mBelongID = self.mUserID;
    mNewManager.mType = mType;
    
    mAudioRecorder.OnPlayFinish = @selector(OnPlayAudioFinish);
}

- (void)OnNewCheck:(ChatNewManager *)sender {
    if (sender.miNewNum>0 && !mDownManager) {
        miPage = 0;
        [self ReloadList:mTableView];
    }
}

- (void)OnPlayAudioFinish {
    miPlayIndex = -1;
    [mTableView reloadData];
}

- (void)ReloadList:(RefreshTableView *)sender {
    [self LoadChatList];
}

- (void)LoadMoreList:(RefreshTableView *)sender {
    [self LoadChatList];
}

- (BOOL)CanRefreshTableView:(RefreshTableView *)sender {
    return !mDownManager;
}

- (void)dealloc {
    [oldDictionary release];
    [mArray release];
    self.mUserID = nil;
    [self Cancel];
    [super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [mArray objectAtIndex:indexPath.row];
    int iHeight = [ChatTableCell HeightOfCell:dict :YES];
    //NSLog(@"iHeight=%d", iHeight);
    return iHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"CellIdentifier%d", indexPath.section];
    ChatTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[ChatTableCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.OnHeadSelect = @selector(OnHeadSelect:);
        cell.OnAudioPlay = @selector(OnAudioPlay:);
        cell.OnImageSelect = @selector(OnImageSelect:);
    }
    cell.tag = indexPath.row+1000;
    NSDictionary *dict = [mArray objectAtIndex:indexPath.row];
    [cell ShowContent:dict :YES];
    if (miPlayIndex != indexPath.row) {
        [cell.mAudioView StopAnimate];
    }
    return cell;
}

- (void)OnImageSelect:(ChatTableCell *)sender
{
    int index = sender.tag-1000;
    NSDictionary *dict = [mArray objectAtIndex:index];
    if (dict) {
        LargeImageView *largeView = [[LargeImageView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:largeView];
        [largeView release];
        [largeView ShowImage:[dict objectForKey:@"bigimage"]];
    }
}

- (void)OnHeadSelect:(ChatTableCell *)sender {
    int index = sender.tag-1000;
    NSDictionary *dict = [mArray objectAtIndex:index];
    NSLog(@"dict  %@",dict);
    if (dict) {
        NSMutableDictionary * diction=[[NSMutableDictionary alloc]initWithCapacity:1];
        [diction setObject:[dict valueForKey:@"targetid"] forKey:@"id"];
        [diction setObject:@"YES" forKey:@"bool"];
        [diction setValue:@"0" forKey:@"type"];
        WoViewController * woview=[[WoViewController alloc]init];
        woview.oldDictionary=diction;
        [diction release];
        [self.navigationController pushViewController:woview animated:YES];
        [woview release];

    }
}

- (void)OnAudioPlay:(ChatTableCell *)sender {
    miPlayIndex = sender.tag-1000;
    [mAudioRecorder StartPlayAudio:[NSURL fileURLWithPath:sender.mAudioPath]];
    [mTableView reloadData];
}

- (BOOL)CanShowDate:(int)index {
    NSDictionary *dict = [mArray objectAtIndex:index];
    BOOL bShowDate = NO;
    if (index == 0) {
        bShowDate = YES;
    }
    else {
        NSDictionary *dict2 = [mArray objectAtIndex:index-1];
        NSTimeInterval interval1 = [[dict objectForKey:@"created_at"] intValue];
        NSTimeInterval interval2 = [[dict2 objectForKey:@"created_at"] intValue];
        NSLog(@"CanShowDate:%d %f", index,  interval1-interval2);
        if (interval1-interval2>300) {
            bShowDate = YES;
        }
    }
    return bShowDate;
}

- (NSString *)DateToStr:(int)interval {
   
    if (interval == 0) {
        return @"";
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter stringFromDate:date];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)Cancel {
    if (mDownManager) {
        mDownManager.delegate = nil;
        [mDownManager Cancel];
        [mDownManager release];
        mDownManager = nil;
    }
}

- (void)OnLoadSuccess:(ASIHttpDownManager *)sender {
    NSMutableDictionary *dict = [sender.mWebStr JSONValue];
    NSLog(@"OnLoadSuccess:%@",dict);
    [self Cancel];
    if (miPage == 0) {
        [mArray removeAllObjects];
    }
    NSArray *array =(NSArray *) dict;
    NSLog(@"%@",array);
    if (array && ![array isKindOfClass:[NSNull class]]) {
        for (NSDictionary *tmpdict in array) {
            [mArray insertObject:tmpdict atIndex:0];
        }
    }
//    int iMaxID = -1;;
//    for (NSMutableDictionary *tmp in mArray) {
//        for (NSString *key in tmp.allKeys) {
//            NSString *value = [tmp objectForKey:key];
//            if ([value isKindOfClass:[NSNull class]]) {
//                [tmp setObject:@"" forKey:key];
//            }
//        }
//        int iTmpid = [[tmp objectForKey:@"id"] intValue];
//        if (iMaxID < iTmpid) {
//            iMaxID = iTmpid;
//        }
//    }
//    if (iMaxID >= 0) {
//        mNewManager.mLastID = [NSString stringWithFormat:@"%d", iMaxID];
//    }
    [mActView stopAnimating];
    [mTableView FinishLoading];
    [mTableView reloadData];
    if (miPage == 0) {
        int iTop = mTableView.mTableView.contentSize.height-mTableView.frame.size.height;
        if (iTop > 0) {
            mTableView.mTableView.contentOffset = CGPointMake(0, iTop);
        }
    }
    miPage ++;
    mNewManager.mbCanCheck = YES;
}

- (void)OnLoadFail:(ASIHttpDownManager *)sender {
    [self Cancel];
    [mTableView FinishLoading];
    [mActView stopAnimating];
    mNewManager.mbCanCheck = YES;
}

- (void)LoadChatList {
    [self Cancel];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict addEntriesFromDictionary:self.oldDictionary];
    [dict setObject:@"http://apptest.mum360.com/web/home/index/historymessagelistinfo" forKey:@"aUrl"];
    [dict setObject:[NSString stringWithFormat:@"%d", miPage+1] forKey:@"page"];
    [dict setObject:@"20" forKey:@"limit"];
    NSLog(@"%@",dict);

    [mActView startAnimating];
    
    mNewManager.mbCanCheck = NO;
    mDownManager = [[ASIHttpDownManager alloc] init];
    mDownManager.delegate = self;
    mDownManager.OnImageDown = @selector(OnLoadSuccess:);
    mDownManager.OnImageFail = @selector(OnLoadFail:);
    [mDownManager PostHttpRequest:dict :nil :nil];
}

- (void)OnSendChatSuccess:(ASIHttpDownManager *)sender {
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    NSLog(@"%@", dict);
    NSString *msg = [dict objectForKey:@"msg"];
    if ([[dict objectForKey:@"code"] intValue]==1) {
        miPage = 0;
        [self LoadChatList];
    }
    else {
        [AutoAlertView ShowAlert:@"提示" message:msg];
    }
}

- (void)PublishChat:(NSString *)content :(NSString *)filepath :(int)index {
    if (index == 0 && (!content || content.length == 0)) {
        [AutoAlertView ShowAlert:@"提示" message:@"内容不能为空"];
        return;
    }
    [self Cancel];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict addEntriesFromDictionary:self.oldDictionary];
    [dict setObject:@"http://apptest.mum360.com/web/home/index/sendmessage" forKey:@"aUrl"];
    if (!content) {
        content = @" ";
    }
    [dict setObject:content forKey:@"content"];
    [dict setObject:[NSString stringWithFormat:@"%d", index+1] forKey:@"type"];

    [mActView startAnimating];

    mDownManager = [[ASIHttpDownManager alloc] init];
    mDownManager.delegate = self;
    mDownManager.OnImageDown = @selector(OnSendChatSuccess:);
    mDownManager.OnImageFail = @selector(OnLoadFail:);
    [mDownManager PostHttpRequest:dict :filepath :@"file"];
}

- (void)OnInputImageFinish:(NSString *)imagename {
    [self PublishChat:nil :imagename :1];
    [self HideBotBar];
}

- (void)OnInputTextFinish:(NSString *)text {
    [self PublishChat:text :nil :0];
    [self HideBotBar];
}

- (void)OnInputLocationFinish:(NSDictionary *)dict {
    [self HideBotBar];
}

- (void)OnInputAudioFinish:(NSString *)audiopath {
    [self PublishChat:nil :audiopath :2];
    [self HideBotBar];
}

- (void)OnBottomBarChange:(UIView *)botview {
    //int iTop = botview.frame.origin.y-self.view.frame.size.height+88;
    int iHeight = mTableView.mTableView.contentSize.height;
    if (iHeight>mTableView.mTableView.frame.size.height) {
        iHeight = mTableView.mTableView.frame.size.height;
    }
    int iTop = botview.frame.origin.y-iHeight;
    if (iTop>44) {
        iTop = 44;
    }
    mTableView.frame = CGRectMake(0, KUIOS_7(iTop), self.view.frame.size.width, self.view.frame.size.height-88);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//  参数  userid:用户id
//  Token 用户token
//  Targetid:对方id
//  Content:内容
//  Type    类型 1文本 2图片 3语音
//  Type 为 2图片3语音时 上传文件用name = file

@end