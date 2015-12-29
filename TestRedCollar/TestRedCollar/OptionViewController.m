//
//  OptionViewController.m
//  TestRedCollar
//
//  Created by dreamRen on 14-5-5.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "OptionViewController.h"
#import "OptionListCell.h"
#import "AboutViewController.h"
#import "FeedbackViewController.h"
#import "FansListViewController.h"
#import "JSON.h"
#import "AmendPasswordViewController.h"

@interface OptionViewController ()
{
    UITableView *_theTable;
    NSMutableArray *_theList;
}
@end

@implementation OptionViewController
@synthesize mDownManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    
}


//退出
-(void)onLogoutClick
{
    NSLog(@"重新登录");
    kkUserDict = nil;
    [self GoBack];
    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_Logout object:nil userInfo:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLogoutClick) name:@"ToHome" object:nil];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    
    self.title = @"设置";
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
    
    _theList = [[NSMutableArray alloc] initWithObjects:@[@"检查更新",@"清空缓存",@"修改密码"],@[@"关于我们",@"意见反馈",@"给我们评分"], nil];
    
    _theTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _theTable.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _theTable.backgroundColor = [UIColor clearColor];
    _theTable.delegate = self;
    _theTable.dataSource = self;
    _theTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _theTable.scrollEnabled = NO;
    [self.view addSubview:_theTable];
    
    UIButton *tButton=[UIButton buttonWithType:UIButtonTypeCustom];
    tButton.frame=CGRectMake(20, 340, 280, 44);
    [tButton setBackgroundImage:[UIImage imageNamed:@"my_52.png"] forState:UIControlStateNormal];
    tButton.titleLabel.font=[UIFont systemFontOfSize:15];
    [tButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tButton addTarget:self action:@selector(onLogoutClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0)
    {
        return 3;
    }
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //行高
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell00";
    OptionListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[OptionListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
    }
    
    NSString *tName = [NSString stringWithFormat:@"%d",180+indexPath.row+indexPath.section*3];
    cell.myImage.image = [UIImage imageNamed:tName];
    NSArray *tList = _theList[indexPath.section];
    cell.myLabel.text = tList[indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //更新
            [self connectToServer];
        }else if(indexPath.row == 1){
            //缓存
            [self showMsg:@"缓存已清空"];
        }else if (indexPath.row == 2) {
            AmendPasswordViewController *amendPW = [[AmendPasswordViewController alloc] init];
            [self.navigationController pushViewController:amendPW animated:YES];
        }
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            //关于
            AboutViewController *tViewCtr=[[AboutViewController alloc] init];
            [self.navigationController pushViewController:tViewCtr animated:YES];
        }else if(indexPath.row == 1){
            //反馈
            FeedbackViewController *tViewCtr=[[FeedbackViewController alloc] init];
            [self.navigationController pushViewController:tViewCtr animated:YES];
        }else if(indexPath.row == 2){
            //评分
            
        }
    }
}

- (void)connectToServer
{
    if (mDownManager) {
        return;
    }
    
    self.mDownManager = [[ImageDownManager alloc] init];
    mDownManager.delegate = self;
    mDownManager.OnImageDown = @selector(OnLoadFinish:);
    mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *urlstr = [NSString stringWithFormat:@"%@club.php", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:@"checkVersion" forKey:@"act"];
    [dict setObject:@"1" forKey:@"devicetype"];
    [dict setObject:@"2" forKey:@"version"];
    
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
        NSNumber *statusCode = [dict objectForKey:@"statusCode"];
        if ([statusCode isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            [self showMsg:@"已是最新版本"];
        }
    }
}

- (void)OnLoadFail:(ImageDownManager *)sender
{
    [self Cancel];
}

@end
