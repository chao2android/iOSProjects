//
//  BaseNewsListView.m
//  TJLike
//
//  Created by MC on 15-3-30.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "BaseNewsListView.h"
#import "NewsBannerInfo.h"
#import "NewsListInfo.h"
#import "NewsListCell.h"
#import "NewsImageListCell.h"
#import "NewsBannerCell.h"
#import "TJNewsNormalDetailController.h"
#import "TJNewsImageDetailController.h"
#import "TjNewsZTListViewController.h"

@implementation BaseNewsListView
{
    int mPage;
    NSMutableArray *bannerArray;
    NSMutableArray *listArray;
}


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        mPage = 0;
        bannerArray = [[NSMutableArray alloc]init];
        listArray = [[NSMutableArray alloc]init];
        
        mTableView = [[RefreshTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-114)];
        mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        mTableView.backgroundColor = [UIColor clearColor];
        mTableView.mDelegate = self;
        mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        mTableView.mbMoreHidden = YES;
        [self addSubview:mTableView];
        
    }
    return self;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (bannerArray.count>0 && indexPath.row==0) {
        return 165.f;
    }
    NewsListInfo *info = nil;
    if (bannerArray.count>0) {
        info = [listArray objectAtIndex:(indexPath.row-1)];
    }else info = [listArray objectAtIndex:indexPath.row];
    if([info.property isEqualToString:@"图文"]){
        return 155.f;
    }
    return 84.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (bannerArray.count>0) {
        return listArray.count+1;
    }
    return listArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (bannerArray.count>0 && indexPath.row==0) {
        static NSString *CellIdentifier = @"CellIdentifier";
        NewsBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[NewsBannerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.mRootCtrl = self.mRootCtrl;
        }
        [cell LoadContent:bannerArray];
        return cell;
    }
    else {
        NewsListInfo *info = nil;
        if (bannerArray.count>0) {
            info = [listArray objectAtIndex:(indexPath.row-1)];
        }else info = [listArray objectAtIndex:indexPath.row];
        if ([info.property isEqualToString:@"图文"]) {
            static NSString *CellIdentifier = @"CellIdentifierImage";
            NewsImageListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[NewsImageListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            [cell LoadContent:info];
            return cell;
        }
        else{
            static NSString *CellIdentifier = @"CellIdentifierList";
            NewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[NewsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            [cell LoadContent:info];
            return cell;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsListInfo *info = nil;
    if (bannerArray.count>0) {
        if (indexPath.row==0) {
            return;
        }
        else{
            info = listArray[indexPath.row-1];
        }
    }
    else{
        info = listArray[indexPath.row];
    }
    if ([info.property isEqualToString:@"图文"]) {
        TJNewsImageDetailController *Ctrl = [[TJNewsImageDetailController alloc]init];
        Ctrl.mlInfo = info;
        Ctrl.hidesBottomBarWhenPushed = YES;
        [self.mRootCtrl.naviController pushViewController:Ctrl animated:YES];
    }else if([info.property isEqualToString:@"专题"]) {
        TjNewsZTListViewController *Ctrl = [[TjNewsZTListViewController alloc]init];
        Ctrl.mlInfo = info;
        Ctrl.hidesBottomBarWhenPushed = YES;
        [self.mRootCtrl.naviController pushViewController:Ctrl animated:YES];
    }
    else{
        TJNewsNormalDetailController *Ctrl = [[TJNewsNormalDetailController alloc]init];
        Ctrl.mlInfo = info;
        Ctrl.hidesBottomBarWhenPushed = YES;
        [self.mRootCtrl.naviController pushViewController:Ctrl animated:YES];
    }
    
}
- (void)ReloadList:(RefreshTableView *)sender {
    mPage = 0;
    [self requestBannerInfo];
}

- (void)LoadMoreList:(RefreshTableView *)sender {
    [self requestRegionsInfo];
}
- (BOOL)CanRefreshTableView:(RefreshTableView *)sender{
    return YES;
}
- (void)requestBannerInfo {
    NSString *urlStr = [NSString stringWithFormat:@"http://www.zounai.com/index.php/api/NewFocus"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%d",self.cid] forKey:@"cid"];
    [[HttpClient postRequestWithPath:urlStr para:dict] subscribeNext:^(NSDictionary *info) {
        
        if (mPage == 0) {
            [bannerArray removeAllObjects];
        }
        NSArray *data = info[@"data"];
        for (int i = 0; i<data.count; i++) {
            NewsBannerInfo *info = [NewsBannerInfo CreateWithDict:data[i]];
            [bannerArray addObject:info];
        }
        
        [self requestRegionsInfo];
    } error:^(NSError *error) {
        HttpClient.failBlock(error);
        //[self executeStateBlock];
    }];
}

- (void)requestRegionsInfo {
    NSString *urlStr = [NSString stringWithFormat:@"http://www.zounai.com/index.php/api/NewsList"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%d",self.cid] forKey:@"cid"];
    [dict setObject:[NSString stringWithFormat:@"%d",mPage] forKey:@"page"];
    [[HttpClient postRequestWithPath:urlStr para:dict] subscribeNext:^(NSDictionary *info) {
        NSLog(@"--------->%@",info);
        
        NSArray *data = info[@"data"];
        if (mPage == 0) {
            [listArray removeAllObjects];
        }
        int iCount = data.count;
        for (int i = 0; i<data.count; i++) {
            NewsListInfo *info = [NewsListInfo CreateWithDict:data[i]];
            [listArray addObject:info];
        }
        mTableView.mbMoreHidden = (iCount < 20);
        [mTableView FinishLoading];
        [mTableView reloadData];
        mPage ++;
    } error:^(NSError *error) {
        HttpClient.failBlock(error);
        //[self executeStateBlock];
    }];
    
}


@end
