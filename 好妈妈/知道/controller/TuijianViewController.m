
//
//  TuijianViewController.m
//  好妈妈
//
//  Created by liuguozhu on 13-10-10.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "TuijianViewController.h"
#import "contentViewController.h"
#import "UIImageView+WebCache.h"
#import "MobClick.h"
#import "ImageTextLabel.h"
#import "GuiDang.h"
@interface TuijianViewController ()

@end

@implementation TuijianViewController

-(void)dealloc{
    [super dealloc];
    //  [_tsView release];
    [_muArr release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"hidesTabBar" object:nil];
    
    page = 1;
    _muArr = [[NSMutableArray alloc]init];
    
    
    _uitable = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - 44-64) pullingDelegate:(id<PullingRefreshTableViewDelegate>)self];
    _uitable.backgroundColor = [UIColor clearColor];
    _uitable.delegate = self;
    _uitable.dataSource = self;
    _uitable.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    mTableView.contentInset = UIEdgeInsetsMake(195.0f, 0.0f, 0, 0.0f);
    [self.view addSubview:_uitable];
    [self.view sendSubviewToBack:_uitable];
    [_uitable release];
    _uitable.reaBool=YES;
    _uitable.reachedTheEnd  = NO;
    
    
    
    if (ISIPAD) {
        //      CGFloat xX =(Screen_Width - 320*1.4)/2;
        //
        _uitable.frame = CGRectMake(0, 0,Screen_Width, Screen_Height - 44-84);
        _uitable.contentOffset = CGPointMake(0, 400);
        
    }else{
        _uitable.contentOffset = CGPointMake(0, 400);
        
    }
    
    [self loadData];
    
    
}
- (void)analyUrl:(NSMutableDictionary *)urlString
{
    [self makeHUD];
    if (analysis) {
        [analysis CancelMenthrequst];
    }
    MOBCLICK(kMob_KnowNew);
    NSString *urlstr = [NSString stringWithFormat:@"%@recommentknows", SERVER_URL];
    NSURL * aUrl = [NSURL URLWithString:urlstr];
    analysis=[[AnalysisClass alloc]initWithIdentifier:aUrl DataName:Nil ControllerName:@"zhidao" delegate:self];
    [analysis PostMenth:urlString];
}
- (void)Asihttp:(AnalysisClass *)asi DataArray:(NSMutableDictionary *)array
{
    [self remHUD];
    NSArray *arr =[array valueForKey:asi.ControllerName];
    
    
    if (page == 1) {
        [_muArr removeAllObjects];
        
        if (arr.count !=0) {
            [GuiDang ChuCunMenth:arr LJstring:@"zhidao"];
        }
        else
        {
            [self DataMenth:[GuiDang DuquMenth:@"zhidao"]];
            return;
        }
        
    }
    
    [self DataMenth:arr];
    
    [asi release];
    analysis=nil;
}
- (void)DataMenth:(NSArray *)arr
{
    if (arr.count !=0) {
        
        for (NSDictionary *dic in arr) {
            [_muArr addObject:dic];
        }
        
        if (ISIPAD) {
            _uitable.contentOffset = CGPointMake(0, 390*1.4*2);
            
        }else{
            _uitable.contentOffset = CGPointMake(0, 340*2);
            if (page == 1) {
                _uitable.contentOffset = CGPointMake(0, 370*2);
                
            }
            
        }
        
        if (page != 1) {
            
        }
        
    }else{
        
        //    [_uitable tableViewDidFinishedLoadingWithMessage:@"数据全部加载完毕"];
        
    }
    [_uitable tableViewDidFinishedLoading];
    [_uitable reloadData];
}
-(void)loadData{
    NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
    
    NSMutableDictionary * asiDictiong=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[userDic valueForKey:@"uid"],@"uid",[userDic valueForKey:@"token"],@"token",@"0",@"type",@"2",@"limit",[NSString stringWithFormat:@"%d",page],@"page", nil];
    [self analyUrl:asiDictiong];
    [asiDictiong release];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _muArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (ISIPAD) {
        return 390*1.4;
    }else{
        return 370;
        
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = @"tuijianCellID";
    tuijianCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[tuijianCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
    }
    if (_muArr.count) {
        
        
        [cell remImageTextLab];
        NSDictionary *mydic = _muArr[_muArr.count - indexPath.row -1];
        
        cell.timeLab.text = mydic[@"date"];
        
        NSArray *arr = mydic[@"big"];
        NSDictionary *dic = arr[0];
        
        NSString *tiString = dic[@"title"];
        cell.bigLab.hangshu = YES;
        [cell.bigLab  LoadContent:tiString];
        cell.bigBut.tag = [dic[@"id"] intValue];
        
        NSString *urlstr = dic[@"image"];
        urlstr = [urlstr stringByReplacingOccurrencesOfString:@"_small" withString:@""];
        [cell.bigImageView GetImageByStr:urlstr];
        //    [cell.bigImageView setImageWithURL:[NSURL URLWithString:dic[@"image"]]];
        
        
        NSArray *arr1 = mydic[@"list"];
        NSDictionary *dic1 = arr1[0];
        NSString *tiString1 = dic1[@"title"];
        cell.listLab1.hangshu = YES;
        [cell.listLab1 LoadContent:tiString1];
        cell.but1.tag = [dic1[@"id"] intValue];
        [cell.listImageView1 GetImageByStr:dic1[@"image"]];
        //    [cell.listImageView1 setImageWithURL:[NSURL URLWithString:dic1[@"image"]]];
        
        NSDictionary *dic2 = arr1[1];
        NSString *tiString2 = dic2[@"title"];
        cell.listLab2.hangshu = YES;
        [cell.listLab2 LoadContent:tiString2];
        cell.but2.tag = [dic2[@"id"] intValue];
        [cell.listImageView2 GetImageByStr:dic2[@"image"]];
        //    [cell.listImageView2 setImageWithURL:[NSURL URLWithString:dic2[@"image"]]];
        
        NSDictionary *dic3 = arr1[2];
        NSString *tiString3 = dic3[@"title"];
        cell.listLab3.hangshu = YES;
        [cell.listLab3 LoadContent:tiString3];
        cell.but3.tag = [dic3[@"id"] intValue];
        [cell.listImageView3 GetImageByStr:dic3[@"image"]];
        //    [cell.listImageView3 setImageWithURL:[NSURL URLWithString:dic3[@"image"]]];
        
    }
    return cell;
    
    
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_uitable tableViewDidEndDragging:scrollView];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_uitable tableViewDidScroll:scrollView];
    
}

- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    page++;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}



- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    page=1;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
    
}





-(void)clickCellButton:(int)butTag{
    
    NSString *contentID = [NSString stringWithFormat:@"%d",butTag];
    contentViewController *ctrl = [[contentViewController alloc]init];
    ctrl.contentID = contentID;
    [self.nav pushViewController:ctrl animated:YES];
    [ctrl release];
    
}

-(void)makeHUD{
    myHUD= [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:myHUD];
    //  myHUD.dimBackground = YES;
    
    myHUD.labelText = @"加载中..";
    [myHUD show:YES];
    
}
-(void)remHUD{
    
    [myHUD removeFromSuperview];
    [myHUD release];
}


#pragma mark - AppDelegate methods


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end
