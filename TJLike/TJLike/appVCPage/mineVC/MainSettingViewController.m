//
//  MainSettingViewController.m
//  TJLike
//
//  Created by MC on 15/4/12.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "MainSettingViewController.h"
#import "MyHomeCell.h"
#import "AutoAlertView.h"

@interface MainSettingViewController ()
{
    UITableView *_theTable;
}
@end

@implementation MainSettingViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.naviController setNaviBarTitle:@"设置"];
    [self.naviController setNavigationBarHidden:NO];
    [self.naviController setNaviBarDefaultLeftBut_Back];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _theTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _theTable.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _theTable.backgroundColor = [UIColor clearColor];
    _theTable.delegate = self;
    _theTable.dataSource = self;
    _theTable.showsVerticalScrollIndicator = NO;
    _theTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_theTable];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 43;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell00";
    MyHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[MyHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if (indexPath.row==0) {
        cell.myLabel.text = @"清理缓存";
        cell.myImage.image = [UIImage imageNamed:@"181.png"];
        UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 42.5, SCREEN_WIDTH-30, 0.5)];
        lineView.backgroundColor = [UIColor darkGrayColor];
        [cell.contentView addSubview:lineView];
    }
    else if (indexPath.row == 1){
        cell.myLabel.text = @"关于奏耐天津";
        cell.myImage.image = [UIImage imageNamed:@"183.png"];
        UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 42.5, SCREEN_WIDTH, 0.5)];
        lineView.backgroundColor = [UIColor darkGrayColor];
        [cell.contentView addSubview:lineView];
    }
    
    //cell.myImage.frame = CGRectMake(20, (45-cell.myImage.image.size.height/2)/2, cell.myImage.image.size.width/2, cell.myImage.image.size.height/2);
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    if (indexPath.row == 0) {
        [AutoAlertView ShowMessage:@"缓存已清除"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
