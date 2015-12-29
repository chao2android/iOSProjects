//
//  MyHomeView.m
//  TestRedCollar
//
//  Created by dreamRen on 14-5-5.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "MyHomeView.h"
#import "JiePaiListCell.h"
#import "OrderListCell.h"
#import "LikeSubView.h"
#import "CoolDetailViewController.h"
#import "LikeListViewController.h"
#import "FansListViewController.h"
#import "OrderInfoViewController.h"
#import "UserInfoViewController.h"
#import "MyHomeCell.h"
#import "ProjectViewController.h"
#import "AlbumViewController.h"
#import "IntegralViewController.h"
#import "CoinViewController.h"
#import "FavouriteViewController.h"
#import "OrderViewController.h"
#import "FavorableViewController.h"
#import "ShopCarViewController.h"
#import "JSON.h"
#import "AutoAlertView.h"
#import "AttentionViewController.h"
#import "UserList.h"
#import "NetImageView.h"
#import "MyHistoryDataViewController.h"

@implementation MyHomeView
{
    UserList *user;
    UIButton *tButton;
    NetImageView *netImage;
    UIImageView *backgroundImage;
    NSMutableDictionary *numDict;
    UILabel *projectLabel;
    UILabel *albumLabel;
    UILabel *favorableLabel;
    UILabel *integralLabel;
    UILabel *coinLabel;
    UILabel *favouriteLabel;
    UILabel *orderLabel;
    UILabel *shopCarLabel;
}

@synthesize mDownManager;

- (void)refreshHeadImage
{
    for (UIView *view in self.subviews){
        if ([view isKindOfClass:[UIButton class]]){
            [view removeFromSuperview];
        }
    }
    [self connectToServer];
}

//个人信息
-(void)onMyButtonClick
{
    UserInfoViewController *tViewCtr = [[UserInfoViewController alloc] init];
    tViewCtr.userList = user;
    tViewCtr.delegate = self;
    tViewCtr.onSaveClick = @selector(refreshHeadImage);
    [self.mRootCtrl.navigationController pushViewController:tViewCtr animated:YES];
}

//粉丝
-(void)onFansClick
{
    FansListViewController *tViewCtr = [[FansListViewController alloc] init];
    tViewCtr.theTitleText = @"粉丝";
    tViewCtr.isAdded = NO;
    tViewCtr.userID = kkUserID;
    tViewCtr.delegate = self;
    tViewCtr.onSaveClick = @selector(refreshHeadImage);
    [self.mRootCtrl.navigationController pushViewController:tViewCtr animated:YES];
}

//关注
-(void)onGuanZhuClick
{
    AttentionViewController *tViewCtr = [[AttentionViewController alloc] init];
    tViewCtr.theTitleText = @"关注";
    tViewCtr.userID = kkUserID;
    tViewCtr.isAdded = YES;
    tViewCtr.delegate = self;
    tViewCtr.onSaveClick = @selector(refreshHeadImage);
    [self.mRootCtrl.navigationController pushViewController:tViewCtr animated:YES];
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
    [dict setObject:@"getUserInfo" forKey:@"act"];
    [dict setObject:kkUserID forKey:@"userid"];
    
    [mDownManager PostHttpRequest:urlstr :dict];
}

- (void)getDataFromServer
{
    if (mDownManager){
        return;
    }
    [self StartLoading];
    
    self.mDownManager = [[ImageDownManager alloc] init];
    mDownManager.delegate = self;
    mDownManager.OnImageDown = @selector(OnLoadFinishReceiveData:);
    mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *urlstr = [NSString stringWithFormat:@"%@base.php", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"getCount" forKey:@"act"];
    [dict setObject:kkToken forKey:@"token"];
    
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
    if (dict && [dict isKindOfClass:[NSDictionary class]]){
        NSDictionary *sonDict = [dict objectForKey:@"list"];
        if (sonDict && [sonDict isKindOfClass:[NSDictionary class]]){
            user = [UserList CreateWithDict:sonDict];
        }
    }
    //个人信息
    [self loadMyInfoView];
}

- (void)OnLoadFinishReceiveData:(ImageDownManager *)sender
{
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    NSLog(@"dict--->%@",dict);
    if (dict && [dict isKindOfClass:[NSDictionary class]]){
        for (NSString *key in dict.allKeys){
            [numDict setObject:[dict objectForKey:key] forKey:key];
        }
    }
    [_theTable reloadData];
}

- (void)OnLoadFail:(ImageDownManager *)sender
{
    [self Cancel];
}

-(void)loadMyInfoView
{
    [self getDataFromServer];
    
    UIButton *backgroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backgroundBtn.frame = CGRectMake(0, 0, self.frame.size.width, 95);
    backgroundBtn.backgroundColor = [UIColor clearColor];
    [backgroundBtn addTarget:self action:@selector(onMyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    backgroundBtn.tag = 1000;
    [self addSubview:backgroundBtn];
    
    netImage = [[NetImageView alloc] initWithFrame:CGRectMake(20, 20, 57, 57)];
    netImage.mDefaultImage = [UIImage imageNamed:@"default_avatar"];
    netImage.backgroundColor = [UIColor clearColor];
    netImage.userInteractionEnabled = NO;
    netImage.mImageType = TImageType_CutFill;
    [backgroundBtn addSubview:netImage];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(self.frame.size.width - 25, 40, 7, 13);
    imageView.image = [UIImage imageNamed:@"my_08"];
    imageView.backgroundColor = [UIColor clearColor];
    [backgroundBtn addSubview:imageView];
    
    if (user.portrait && user.portrait.length > 0){
        NSRange range = [user.portrait rangeOfString:@"http://"];
        if (range.length == 0){
            user.portrait = [NSString stringWithFormat:@"%@%@",URL_HEADER,user.portrait];
        }
    }
    [netImage GetImageByStr:user.portrait];
    netImage.layer.masksToBounds = YES;
    netImage.layer.cornerRadius = netImage.bounds.size.width/2;
    
    //姓名
    theNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(netImage.frame.origin.x+netImage.frame.size.width+15, netImage.frame.origin.y+2, 135, 23)];
    theNameLabel.backgroundColor=[UIColor clearColor];
    theNameLabel.textColor=[UIColor whiteColor];
    theNameLabel.font=[UIFont boldSystemFontOfSize:18];
    if (user.nickname.length != 0) {
        theNameLabel.text = user.nickname;
    }else {
        theNameLabel.text = user.user_name;
    }
    
    CGSize size = [theNameLabel.text sizeWithFont:[UIFont systemFontOfSize:18]];
    if (size.width <= 150)
    {
        [theNameLabel sizeToFit];
    }
    [backgroundBtn addSubview:theNameLabel];
    
    //会员
//    UIImageView *VIPImage = [[UIImageView alloc]initWithFrame:CGRectMake(theNameLabel.frame.origin.x+theNameLabel.frame.size.width+5, theNameLabel.frame.origin.y+3, 60, 18)];
//    VIPImage.image = [UIImage imageNamed:@"my_53.png"];
//    [backgroundBtn addSubview:VIPImage];
    
    //关注
    tButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tButton.frame = CGRectMake(theNameLabel.frame.origin.x, 53, 80, 20);
    [tButton setTitle:[NSString stringWithFormat:@"%@ 关注",user.follows] forState:UIControlStateNormal];
    tButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [tButton addTarget:self action:@selector(onGuanZhuClick) forControlEvents:UIControlEventTouchUpInside];
    tButton.backgroundColor = [UIColor clearColor];
    tButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backgroundBtn addSubview:tButton];
    
    //粉丝
    tButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tButton.frame = CGRectMake(theNameLabel.frame.origin.x+80, 53, 80, 20);
    [tButton setTitle:[NSString stringWithFormat:@"%@ 粉丝",user.fans] forState:UIControlStateNormal];
    tButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [tButton addTarget:self action:@selector(onFansClick) forControlEvents:UIControlEventTouchUpInside];
    tButton.backgroundColor = [UIColor clearColor];
    tButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backgroundBtn addSubview:tButton];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self connectToServer];
        
        numDict = [[NSMutableDictionary alloc] init];
        self.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
        
        backgroundImage = [[UIImageView alloc] init];
        backgroundImage.frame = CGRectMake(0, 0, self.frame.size.width, 95);
        backgroundImage.backgroundColor = [UIColor clearColor];
        backgroundImage.image = [UIImage imageNamed:@"s_02.png"];
        [self addSubview:backgroundImage];
        
        int iTop = backgroundImage.frame.origin.y + backgroundImage.frame.size.height;
        int iHeight = self.frame.size.height - iTop;
        
        _theTable = [[UITableView alloc] initWithFrame:CGRectMake(0, iTop, self.frame.size.width, iHeight) style:UITableViewStylePlain];
        _theTable.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _theTable.backgroundColor = [UIColor clearColor];
        _theTable.delegate = self;
        _theTable.dataSource = self;
        _theTable.showsVerticalScrollIndicator = NO;
        _theTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_theTable];
        [self sendSubviewToBack:_theTable];
        
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if ([kkServe_type isEqualToString:@"4"]) {
            return 2;
        }else {
            return 1;
        }
    }else if (section == 1) {
        return 3;
    }else {
        return 4;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell00";
    MyHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[MyHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.contentView.tag = 1000+indexPath.row;
    
    if (indexPath.section == 0){
        if ([kkServe_type isEqualToString:@"4"]){
            if (indexPath.row == 0){
                cell.myLabel.text = @"我的设计";
                cell.myImage.image = [UIImage imageNamed:@"my_01.png"];
            }else{
                cell.myLabel.text = @"街拍相册";
                cell.myImage.image = [UIImage imageNamed:@"my_02.png"];
            }
        }else{
            if (indexPath.row == 0){
                cell.myLabel.text = @"街拍相册";
                cell.myImage.image = [UIImage imageNamed:@"my_02.png"];
            }
        }
    }else if(indexPath.section == 1){
        if (indexPath.row == 0){
            cell.myLabel.text = @"我的优惠券";
            cell.myImage.image = [UIImage imageNamed:@"my_07.png"];
        }else if (indexPath.row == 1){
            cell.myLabel.text = @"我的积分";
            cell.myImage.image = [UIImage imageNamed:@"my_03.png"];
        }else{
            cell.myLabel.text = @"我的酷特币";
            cell.myImage.image = [UIImage imageNamed:@"my_04.png"];
        }
    }else{
        if (indexPath.row == 0){
            cell.myLabel.text = @"我的收藏";
            cell.myImage.image = [UIImage imageNamed:@"my_05.png"];
        }else if(indexPath.row == 1){
            cell.myLabel.text = @"我的订单";
            cell.myImage.image = [UIImage imageNamed:@"my_06.png"];
        }else if (indexPath.row == 2){
            cell.myLabel.text = @"我的量体数据";
            cell.myImage.image = [UIImage imageNamed:@"my_m100.png"];
        }
        else{
            cell.myLabel.text = @"我的购物车";
            cell.myImage.image = [UIImage imageNamed:@"my_45.png"];
        }
    }
    [cell.myLabel sizeToFit];
    
    for (UIView *view in cell.contentView.subviews) {
        if (view.tag == 1111) {
            [view removeFromSuperview];
        }
    }
    
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.frame = CGRectMake(cell.myLabel.frame.origin.x+cell.myLabel.frame.size.width+5, cell.myLabel.frame.origin.y, 100, cell.myLabel.frame.size.height);
    numLabel.backgroundColor = [UIColor clearColor];
    numLabel.textColor = WORDGRAYCOLOR;
    numLabel.font = [UIFont systemFontOfSize:15];
    numLabel.tag = 1111;
    //[cell.contentView addSubview:numLabel];
    [cell.contentView addSubview:numLabel];
    
    if (indexPath.section == 0){
        if ([kkServe_type isEqualToString:@"4"]){
            if (indexPath.row == 0){
                projectLabel = numLabel;
                if ([[numDict objectForKey:@"sheji"] intValue] != 0){
                    projectLabel.text = [NSString stringWithFormat:@"(%@)",[numDict objectForKey:@"sheji"]];
                }
            }else{
                albumLabel = numLabel;
                if ([[numDict objectForKey:@"jiepaixiangce"] intValue] != 0){
                    albumLabel.text = [NSString stringWithFormat:@"(%@)",[numDict objectForKey:@"jiepaixiangce"]];
                }
            }
        }else{
            albumLabel = numLabel;
            if (indexPath.row == 0){
                if ([[numDict objectForKey:@"jiepaixiangce"] intValue] != 0){
                    albumLabel.text = [NSString stringWithFormat:@"(%@)",[numDict objectForKey:@"jiepaixiangce"]];
                }
            }
        }
    }else if(indexPath.section == 1){
        if (indexPath.row == 0){
            if ([[numDict objectForKey:@"youhuiquan"] intValue] != 0){
                numLabel.text = [NSString stringWithFormat:@"(%@)",[numDict objectForKey:@"youhuiquan"]];
            }
        }else if (indexPath.row == 1){
            if ([[numDict objectForKey:@"jifen"] intValue] != 0){
                numLabel.text = [NSString stringWithFormat:@"(%@)",[numDict objectForKey:@"jifen"]];
            }
        }else{
            if ([[numDict objectForKey:@"kutebi"] intValue] != 0){
                numLabel.text = [NSString stringWithFormat:@"(%@)",[numDict objectForKey:@"kutebi"]];
            }
        }
    }else{
        if (indexPath.row == 0){
            if ([[numDict objectForKey:@"shoucang"] intValue] != 0){
                numLabel.text = [NSString stringWithFormat:@"(%@)",[numDict objectForKey:@"shoucang"]];
            }
        }else if(indexPath.row == 1){
            if ([[numDict objectForKey:@"dingdan"] intValue] != 0){
                numLabel.text = [NSString stringWithFormat:@"(%@)",[numDict objectForKey:@"dingdan"]];
            }
        }else if(indexPath.row == 2){
            //量体数据
            if ([[numDict objectForKey:@"liangti"] intValue] != 0){
                numLabel.text = [NSString stringWithFormat:@"(%@)",[numDict objectForKey:@"liangti"]];
            }
        }
        else{
            if ([[numDict objectForKey:@"gouwuche"] intValue] != 0){
                numLabel.text = [NSString stringWithFormat:@"(%@)",[numDict objectForKey:@"gouwuche"]];
            }
        }
    }
    cell.myImage.frame = CGRectMake(20, (45-cell.myImage.image.size.height/2)/2, cell.myImage.image.size.width/2, cell.myImage.image.size.height/2);
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    if (indexPath.section == 0) {
        if ([kkServe_type isEqualToString:@"4"]) {
            if (indexPath.row == 0) {
                ProjectViewController *project = [[ProjectViewController alloc] init];
                //project.theTitleText = @"个人设计";
                project.delegate = self;
                project.onSaveClick = @selector(refreshView);
                [self.mRootCtrl.navigationController pushViewController:project animated:YES];
            }else {
                AlbumViewController *photo = [[AlbumViewController alloc] init];
                //photo.theTitleText = @"街拍相册";
                photo.delegate = self;
                photo.onSaveClick = @selector(refreshView);
                [self.mRootCtrl.navigationController pushViewController:photo animated:YES];
            }
        }else {
            if (indexPath.row == 0) {
                AlbumViewController *photo = [[AlbumViewController alloc] init];
                //photo.theTitleText = @"街拍相册";
                photo.delegate = self;
                photo.onSaveClick = @selector(refreshView);
                [self.mRootCtrl.navigationController pushViewController:photo animated:YES];
            }
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            FavorableViewController *favorable = [[FavorableViewController alloc] init];
            //favorable.theTitleText = @"我的优惠券";
            favorable.delegate = self;
            favorable.onSaveClick = @selector(refreshView);
            [self.mRootCtrl.navigationController pushViewController:favorable animated:YES];
        }else if (indexPath.row == 1) {
            IntegralViewController *integral = [[IntegralViewController alloc] init];
            //integral.theTitleText = @"我的积分";
            integral.delegate = self;
            integral.onSaveClick = @selector(refreshView);
            [self.mRootCtrl.navigationController pushViewController:integral animated:YES];
        }else {
            CoinViewController *coin = [[CoinViewController alloc] init];
            //coin.theTitleText = @"我的酷特币";
            coin.delegate = self;
            coin.onSaveClick = @selector(refreshView);
            [self.mRootCtrl.navigationController pushViewController:coin animated:YES];
        }
    }else {
        if (indexPath.row == 0) {
            FavouriteViewController *favourite = [[FavouriteViewController alloc] init];
            //favourite.theTitleText = @"我的收藏";
            favourite.delegate = self;
            favourite.onSaveClick = @selector(refreshView);
            [self.mRootCtrl.navigationController pushViewController:favourite animated:YES];
        }else if (indexPath.row == 1) {
            OrderViewController *indent = [[OrderViewController alloc] init];
            //indent.theTitleText = @"我的订单";
            indent.delegate = self;
            indent.onSaveClick = @selector(refreshView);
            [self.mRootCtrl.navigationController pushViewController:indent animated:YES];
        }else if (indexPath.row == 2){
            MyHistoryDataViewController *hvc = [[MyHistoryDataViewController alloc]init];
            [self.mRootCtrl.navigationController pushViewController:hvc animated:YES];
        }
        else {
            ShopCarViewController *shopCar = [[ShopCarViewController alloc] init];
            //shopCar.theTitleText = @"购物车";
            shopCar.delegate = self;
            shopCar.onSaveClick = @selector(refreshView);
            [self.mRootCtrl.navigationController pushViewController:shopCar animated:YES];
        }
    }
}

- (void)refreshHomeView
{
    for (UIView *view in self.subviews) {
        if (view.tag == 1000) {
            [view removeFromSuperview];
        }
    }
    [self connectToServer];
}

- (void)refreshView
{
    [self getDataFromServer];
}

@end
