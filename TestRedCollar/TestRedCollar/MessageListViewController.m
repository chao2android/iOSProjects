//
//  MessageListViewController.m
//  TestRedCollar
//
//  Created by dreamRen on 14-5-5.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "MessageListViewController.h"
#import "MessageListCell.h"
#import "JSON.h"
#import "MessageList.h"
#import "AutoAlertView.h"

@interface MessageListViewController ()
{
    NSMutableArray *_theList;
}

@end

@implementation MessageListViewController

@synthesize mDownManager;

- (void)Cancel
{
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (void)OnLoadFinish:(ImageDownManager *)sender
{
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        if ([[dict objectForKey:@"statusCode"] intValue] == 0) {
            NSDictionary *listDict = [dict objectForKey:@"list"];
            
            NSArray *array = [UserInfoManager DictionaryToArray:listDict];
            if (array) {
                for (NSDictionary *sonDict in array) {
                    MessageList *mList = [[MessageList alloc] init];
                    mList.content = [sonDict objectForKey:@"content"];
                    mList.add_time = [sonDict objectForKey:@"add_time"];
                    [_theList addObject:mList];
                }
            }
            mTableView.mbMoreHidden = (array.count < 10);
            [mTableView FinishLoading];
            [mTableView reloadData];
        }
    }
}

- (void)OnLoadFail:(ImageDownManager *)sender
{
    [self Cancel];
}

- (void)connectToServer
{
    if (mDownManager){
        return;
    }
    [self StartLoading];
    
    self.mDownManager = [[ImageDownManager alloc] init];
    mDownManager.delegate = self;
    mDownManager.OnImageDown = @selector(OnLoadFinish:);
    mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *urlstr = [NSString stringWithFormat:@"%@club.php", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"messageList" forKey:@"act"];
    [dict setObject:kkToken forKey:@"token"];
    [dict setObject:[NSString stringWithFormat:@"%@",@"10"] forKey:@"pageSize"];
    [dict setObject:[NSString stringWithFormat:@"%d",self.pageIndex] forKey:@"pageIndex"];
    [mDownManager PostHttpRequest:urlstr :dict];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _theList = [[NSMutableArray alloc] init];
        self.pageIndex = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    
    self.title = @"系统消息";
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

- (void)ReloadList:(RefreshTableView *)sender
{
    self.pageIndex = 1;
    [self connectToServer];
}

- (void)LoadMoreList:(RefreshTableView *)sender
{
    self.pageIndex++;
    [self connectToServer];
}

- (BOOL)CanRefreshTableView:(RefreshTableView *)sender
{
    return !mDownManager;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _theList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell00";
    MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[MessageListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    MessageList *mList = [_theList objectAtIndex:indexPath.section];
    cell.titleLabel.text = mList.content;
    NSDate *timestamp = [NSDate dateWithTimeIntervalSince1970:[mList.add_time integerValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    cell.timeLabel.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:timestamp]];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
