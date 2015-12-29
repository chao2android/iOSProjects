//
//  contentViewController.m
//  好妈妈
//
//  Created by liuguozhu on 13-10-11.
//  Copyright (c) 2013年 iHope. All rights reserved.
//
#import <ShareSDK/ShareSDK.h>
#import "AGViewDelegate.h"
#import "IBActionSheet.h"

#import "contentViewController.h"
#import "WoViewController.h"
#import "contentCell.h"

#import "NSString+SBJSON.h"
#import "UIImageView+WebCache.h"

#import "pinglunViewController.h"

#import "BigImageView.h"

#import "EmoTextLable.h"
#import "MBProgressHUD.h"

#import "LargeImageView.h"
#import "AudioButton.h"

@interface contentViewController ()


@property (nonatomic,retain)UIImage *bigImage;
@end
@interface UIView (ss)
-(void)removeAllSubviewss;

@end

@implementation UIView (ss)

-(void)removeAllSubviewss{
    for (id cc in [self subviews]) {
        [cc removeFromSuperview];
    }
}
@end



@implementation contentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hidesTabBar" object:nil];
}
-(void)dealloc{
    [super dealloc];
    [_muArr release];
    [_muUserArr release];
    [_audioPlayer release];
    
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    _muArr = [[NSMutableArray alloc]init];
    _muUserArr = [[NSMutableArray alloc]init];
    page = 1;
    
    UIImageView * backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, KUIOS_7(Screen_Height-20))];
    backImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"底" ofType:@"png"]];
    [self.view addSubview:backImageView];
    [backImageView release];
    
    UIImageView * navigation=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, KUIOS_7(44))];
    navigation.backgroundColor=[UIColor blackColor];
    navigation.userInteractionEnabled=YES;
    navigation.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nav_background" ofType:@"png"]];
    [self.view addSubview:navigation];
    [navigation release];
    
    UILabel * navigationLabel=[[UILabel alloc]initWithFrame:CGRectMake(100, KUIOS_7(11), (Screen_Width-200), 22)];
    navigationLabel.backgroundColor=[UIColor clearColor];
    //    navigationLabel.font=[UIFont systemFontOfSize:22];
    navigationLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:22];
    navigationLabel.textAlignment=NSTextAlignmentCenter;
    navigationLabel.textColor=[UIColor whiteColor];
    navigationLabel.text=@"帖子详情";
    [navigation addSubview:navigationLabel];
    [navigationLabel release];
    
    
    UIButton * leftBut=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBut.frame=CGRectMake(5, KUIOS_7(6), 45, 30.5);
    [leftBut addTarget:self action:@selector(clicked_leftBut) forControlEvents:UIControlEventTouchUpInside];
    [leftBut setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"001_4" ofType:@"png"]] forState:UIControlStateNormal];
    [navigation addSubview:leftBut];
    
    UIButton *shareBut=[UIButton buttonWithType:UIButtonTypeCustom];
    shareBut.frame=CGRectMake(Screen_Width - 90, KUIOS_7(5), 42,34);
    [shareBut addTarget:self action:@selector(clicked_shareBut) forControlEvents:UIControlEventTouchUpInside];
    [shareBut setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"001_3" ofType:@"png"]] forState:UIControlStateNormal];
    [shareBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navigation addSubview:shareBut];
    
    UIButton *commenttBut=[UIButton buttonWithType:UIButtonTypeCustom];
    commenttBut.frame=CGRectMake(Screen_Width - 50, KUIOS_7(5), 42,34);
    [commenttBut addTarget:self action:@selector(clicked_commentBut) forControlEvents:UIControlEventTouchUpInside];
    [commenttBut setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"001_2" ofType:@"png"]] forState:UIControlStateNormal];
    [commenttBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navigation addSubview:commenttBut];
    
    
    
    
    _uitable = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, KUIOS_7(44), Screen_Width, Screen_Height - 44-20) pullingDelegate:(id<PullingRefreshTableViewDelegate>)self];
    _uitable.delegate = self;
    _uitable.dataSource = self;
    _uitable.backgroundColor = [UIColor clearColor];
    
    //  _uitable.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 40.0f, 0.0f);
    
    _uitable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_uitable];
    [_uitable release];
    
    
    
    UIButton * topBut = [UIButton buttonWithType:UIButtonTypeCustom];
    topBut.frame = CGRectMake(10, Screen_Height - 80, 40, 40);
    [topBut setImage:[UIImage imageNamed:@"up.png"] forState:UIControlStateNormal];
    [topBut addTarget:self action:@selector(topBut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topBut];
    
    
    [self loadData];
    
}
-(void)topBut{
    _uitable.contentOffset = CGPointMake(0, 0);
}
-(void)clicked_starBut:(UIButton *)but{
    
    NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
    
    NSMutableDictionary * asiDictiong=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[userDic valueForKey:@"uid"],@"uid",[userDic valueForKey:@"token"],@"token",self.contentID,@"id",nil];
    
    if (isStar == NO) {
        [asiDictiong setValue:@"http://apptest.mum360.com/web/home/index/createCollection" forKey:@"aUrl"];
        [asiDictiong setValue:@"shoucang" forKey:@"Controller"];
        
    }else{
        [asiDictiong setValue:@"http://apptest.mum360.com/web/home/index/deleteCollection" forKey:@"aUrl"];
        [asiDictiong setValue:@"quxiaoshoucang" forKey:@"Controller"];
        
    }
    [self analyUrl:asiDictiong];
    [asiDictiong release];
    
}
-(void)clicked_zanTBut:(UIButton *)but{
    
    if (but.opaque == NO) {
        NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
        
        NSMutableDictionary * asiDictiong=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[userDic valueForKey:@"uid"],@"uid",[userDic valueForKey:@"token"],@"token",@"4",@"type",nil];
        int row = but.tag/10000000;
        int zid = but.tag%10000000;
        NSDictionary * d = _muArr[row];
        int num = [but.titleLabel.text intValue];
        [d setValue:@"1" forKey:@"isapproval"];
        but.opaque=YES;
        
        
        [d setValue:[NSString stringWithFormat:@"%d",num+1] forKey:@"approvalnum"];
        [but setTitle:[NSString stringWithFormat:@"    %d",num+1] forState:UIControlStateNormal];
        
        NSLog(@"num === %d",num);
        [asiDictiong setValue:@"http://apptest.mum360.com/web/home/index/createapproval" forKey:@"aUrl"];
        [asiDictiong setValue:@"zan" forKey:@"Controller"];
        [asiDictiong setValue:[NSString stringWithFormat:@"%d",zid] forKey:@"tid"];
        [self analyUrl:asiDictiong];
        [asiDictiong release];
        
    }else{
        
        NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
        
        NSMutableDictionary * asiDictiong=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[userDic valueForKey:@"uid"],@"uid",[userDic valueForKey:@"token"],@"token",@"4",@"type",nil];
        int row = but.tag/10000000;
        int zid = but.tag%10000000;
        NSDictionary * d = _muArr[row];
        but.opaque=NO;
        
        int num = [but.titleLabel.text intValue];
        [d setValue:@"0" forKey:@"isapproval"];
        [d setValue:[NSString stringWithFormat:@"%d",num-1] forKey:@"approvalnum"];
        [but setTitle:[NSString stringWithFormat:@"    %d",num-1] forState:UIControlStateNormal];
        
        NSLog(@"num === %d",num);
        
        
        [asiDictiong setValue:@"http://apptest.mum360.com/web/home/index/deleteapproval" forKey:@"aUrl"];
        [asiDictiong setValue:@"quxiaozan" forKey:@"Controller"];
        [asiDictiong setValue:[NSString stringWithFormat:@"%d",zid] forKey:@"tid"];
        [self analyUrl:asiDictiong];
        [asiDictiong release];
        
        
    }
    
    
}
-(void)clicked_zanXTBut:(UIButton *)but{
    
}
-(void)clicked_zanBut:(UIButton *)but{
    //http://apptest.mum360.com/web/home/index/createapproval?uid=61&token=e4032723bbdbd7e3055a17eb596c7335&tid=17
    
    NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
    
    NSMutableDictionary * asiDictiong=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[userDic valueForKey:@"uid"],@"uid",[userDic valueForKey:@"token"],@"token",@"3",@"type",nil];
    
    NSDictionary *uDic = _muUserArr[0];
    
    if (isZan == NO) {
        
        int num = [but.titleLabel.text intValue];
        [but setTitle:[NSString stringWithFormat:@"    %d",num+1] forState:UIControlStateNormal];
        [uDic setValue:[NSString stringWithFormat:@"%d",num+1] forKey:@"approvalnum"];
        
        NSLog(@"num === %d",num);
        [asiDictiong setValue:@"http://apptest.mum360.com/web/home/index/createapproval" forKey:@"aUrl"];
        [asiDictiong setValue:@"zan" forKey:@"Controller"];
        [asiDictiong setValue:self.contentID forKey:@"tid"];
        
    }else{
        
        int num = [but.titleLabel.text intValue];
        [but setTitle:[NSString stringWithFormat:@"    %d",num-1] forState:UIControlStateNormal];
        [uDic setValue:[NSString stringWithFormat:@"%d",num-1] forKey:@"approvalnum"];
        
        NSLog(@"num === %d",num);
        
        [asiDictiong setValue:@"http://apptest.mum360.com/web/home/index/deleteapproval" forKey:@"aUrl"];
        [asiDictiong setValue:@"quxiaozan" forKey:@"Controller"];
        [asiDictiong setValue:self.contentID forKey:@"tid"];
        
        
    }
    [self analyUrl:asiDictiong];
    [asiDictiong release];
    
}
- (void)analyUrl:(NSMutableDictionary *)urlString
{
    [self makeHUD];
    
    if (analysis) {
        [analysis CancelMenthrequst];
    }
    NSLog(@"%@",urlString);
    NSURL * aUrl=[[NSURL alloc]initWithString:[urlString valueForKey:@"aUrl"]];
    analysis=[[AnalysisClass alloc]initWithIdentifier:aUrl DataName:nil ControllerName:[urlString valueForKey:@"Controller"] delegate:self];
    [aUrl release];
    [analysis PostMenth:urlString];
    
}
- (void)Asihttp:(AnalysisClass *)asi DataArray:(NSMutableDictionary *)array
{
    NSDictionary * userDic = [array valueForKey:asi.ControllerName];
    
    
    NSLog(@"%@",array);
    [self remHUD];
    
    if ([asi.ControllerName isEqualToString:@"zhidao"]) {
        if (!userDic) {
            return;
        }
        if (page == 1) {
            [_muArr removeAllObjects];
            [_muUserArr removeAllObjects];
            NSDictionary *uDic =userDic[@"themeinfo"];
            [_muUserArr addObject:uDic];
            
            UIImageView *titBgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"001_6.png"]];
            titBgView.frame = CGRectMake(0, 0, Screen_Width, 40);
            titBgView.userInteractionEnabled=YES;
            [_uitable addSubview:titBgView];
            [titBgView release];
            starBut = [UIButton buttonWithType:UIButtonTypeCustom];
            //  [starBut setImage:[UIImage imageNamed:@"001_5.png"] forState:UIControlStateNormal];
            [starBut addTarget:self action:@selector(clicked_starBut:) forControlEvents:UIControlEventTouchUpInside];
            starBut.frame = CGRectMake(Screen_Width - 30, 10, 20, 20);
            [titBgView addSubview:starBut];
            
            titLab = [[ImageTextLabel alloc]initWithFrame:CGRectMake(5, 10, Screen_Width -60, 40)];
            titLab.backgroundColor = [UIColor clearColor] ;
            titLab.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_background.png"]];
            titLab.m_EmoWidth = 20;
            titLab.m_EmoHeight = 20;
            [titBgView addSubview:titLab];
            [titLab release];
            
            [titLab LoadContent: uDic[@"title"]];
            
            int hei = [ImageTextLabel HeightOfContent:uDic[@"title"]:CGSizeMake(270, 1000)];
            titBgView.frame = CGRectMake(0, 0, Screen_Width, hei+20);
            
            
            NSString *starStr = [NSString stringWithFormat:@"%@",uDic[@"flag"]];
            if ([starStr isEqualToString:@"0"]) {
                isStar = NO;
                [starBut setImage:[UIImage imageNamed:@"001_5.png"] forState:UIControlStateNormal];
            }else{
                isStar = YES;
                [starBut setImage:[UIImage imageNamed:@"已收藏.png"] forState:UIControlStateNormal];
            }
            NSString *zanStr = [NSString stringWithFormat:@"%@",uDic[@"isapproval"]];
            
            if ([zanStr isEqualToString:@"0"]) {
                
                isZan = NO;
            }else {
                
                isZan = YES;
            }
            
        }
        
        
        
        
        
        NSArray *arr = userDic[@"comment"];
        
        for (NSDictionary *dic in arr) {
            [_muArr addObject:dic];
        }
        if ([arr count] < 20) {
            
            //        [_uitable tableViewDidFinishedLoadingWithMessage:@"数据全部加载完毕"];
            _uitable .reachedTheEnd  = YES;
        }else{
            
            _uitable .reachedTheEnd  = NO;
            
        }
        NSLog(@"arr count %d",arr.count);
        
        
        [_uitable reloadData];
        [_uitable tableViewDidFinishedLoading];
        
        
    }else if ([asi.ControllerName isEqualToString:@"shoucang"]){
        
        NSString *msg=[NSString stringWithFormat:@"%@",userDic[@"code"]];
        if ([msg isEqualToString:@"1"]) {
            isStar = YES;
            [starBut setImage:[UIImage imageNamed:@"已收藏.png"] forState:UIControlStateNormal];
            
            //        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"收藏成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            //        [alert show];
            
            MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.labelText = @"收藏成功";
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [HUD removeFromSuperview];
                [HUD release];
            }];
            
            
        }else {
            MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.labelText = @"收藏失败";
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [HUD removeFromSuperview];
                [HUD release];
            }];
        }
        
        
    }else if([asi.ControllerName isEqualToString:@"quxiaoshoucang"]){
        NSString *msg=[NSString stringWithFormat:@"%@",userDic[@"code"]];
        if ([msg isEqualToString:@"1"]) {
            isStar = NO;
            [starBut setImage:[UIImage imageNamed:@"001_5.png"] forState:UIControlStateNormal];
            
            MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.labelText = @"取消收藏成功";
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [HUD removeFromSuperview];
                [HUD release];
            }];
            
            
        }else {
            MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.labelText = @"取消收藏失败";
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [HUD removeFromSuperview];
                [HUD release];
            }];
        }
        
    }else if([asi.ControllerName isEqualToString:@"zan"]){
        NSString *msg=[NSString stringWithFormat:@"%@",userDic[@"code"]];
        if ([msg isEqualToString:@"1"]) {
            //        int num = [zanLab.text intValue];
            
            
            isZan = YES;
            MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.labelText = @"赞成功";
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [HUD removeFromSuperview];
                [HUD release];
            }];
            
        }else{
            MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.labelText = @"赞失败";
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [HUD removeFromSuperview];
                [HUD release];
            }];
            
        }
    }else if([asi.ControllerName isEqualToString:@"quxiaozan"]){
        NSString *msg=[NSString stringWithFormat:@"%@",userDic[@"code"]];
        if ([msg isEqualToString:@"1"]) {
            
            //        int num = [zanLab.text intValue];
            
            isZan = NO;
            MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.labelText = @"取消赞成功";
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [HUD removeFromSuperview];
                [HUD release];
            }];
            
        }else{
            MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.labelText = @"取消赞失败";
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [HUD removeFromSuperview];
                [HUD release];
            }];
            
        }
        
    }else if([asi.ControllerName isEqualToString:@"jubao"]){
        NSString *msg=[NSString stringWithFormat:@"%@",userDic[@"code"]];
        if ([msg isEqualToString:@"1"]) {
            
            MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.labelText = @"举报成功";
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [HUD removeFromSuperview];
                [HUD release];
            }];
            
        }else{
            MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.labelText = @"举报失败";
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [HUD removeFromSuperview];
                [HUD release];
            }];
            
        }
        
        
    }
    [asi release];
    analysis=nil;
}

-(void)loadData{
    
    NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
    
    NSMutableDictionary * asiDictiong=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[userDic valueForKey:@"uid"],@"uid",[userDic valueForKey:@"token"],@"token",self.contentID,@"id",@"20",@"limit",[NSString stringWithFormat:@"%d",page],@"page",@"http://apptest.mum360.com/web/home/index/themeinfo",@"aUrl",@"zhidao",@"Controller", nil];
    [self analyUrl:asiDictiong];
    [asiDictiong release];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _muUserArr.count;
    }else{
        return _muArr.count + _muUserArr.count;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        NSDictionary *dic = _muUserArr[0];
        int hei = [ImageTextLabel HeightOfContent:dic[@"title"]:CGSizeMake(270, 1000)];
        
        return hei+20;
    }else{
        if (indexPath.row == 0) {
            NSDictionary *uDic = _muUserArr[0];
            
            NSString *vieo = uDic[@"vieo"];
            if (vieo) {
                return [contentCell HeightOfContent:uDic] +50;
                
            }else{
                return [contentCell HeightOfContent:uDic];
                
            }
            
        }else{
            NSDictionary *dic = _muArr[indexPath.row -1];
            
            return [contentCell HeightOfContent:dic];
        }
        
        
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (indexPath.section == 0) {
        UITableViewCell *ce = [tableView dequeueReusableCellWithIdentifier:@"ceID"];
        if (ce == nil) {
            ce = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ceID"];
            
        }
        return ce;
        
    }else{
        
        NSString *CellIdentifier = @"contentCellID";
        contentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil){
            
            cell = [[contentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
            
            
        }
        
        if (indexPath.row == 0) {
            
            cell.numLab.hidden = YES;
            //      cell.numView.hidden = YES;
            cell.numView.image = [UIImage imageNamed:@"001_7.png"];
            NSDictionary *uDic = _muUserArr[0];
            [cell ShowContent:uDic];
            
            
            
            NSString *vieo = uDic[@"vieo"];
            if (vieo) {
                cell.audioButton.hidden = NO;
                [cell.audioButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
                
                CGRect rect = cell.contentLab.frame;
                
                cell.contentLab.frame = CGRectMake(rect.origin.x, rect.origin.y + 50, rect.size.width, rect.size.height);

                rect = cell.contentBgView.frame;
                cell.contentBgView.frame = CGRectMake(rect.origin.x, rect.origin.y + 50, rect.size.width, rect.size.height);
                rect = cell.lineImage.frame;
                cell.lineImage.frame = CGRectMake(rect.origin.x, rect.origin.y , rect.size.width, rect.size.height+50);
                rect = cell.lineImage2.frame;
                cell.lineImage2.frame = CGRectMake(rect.origin.x, rect.origin.y+50 , rect.size.width, rect.size.height);
                rect = cell.nameLab.frame;
                cell.nameLab.frame = CGRectMake(rect.origin.x, rect.origin.y+50 , rect.size.width, rect.size.height);
                rect = cell.statusLab.frame;
                cell.statusLab.frame = CGRectMake(rect.origin.x, rect.origin.y+50 , rect.size.width, rect.size.height);
                rect = cell.timeLab.frame;
                cell.timeLab.frame = CGRectMake(rect.origin.x, rect.origin.y+50 , rect.size.width, rect.size.height);
                rect = cell.plBut.frame;
                cell.plBut.frame = CGRectMake(rect.origin.x, rect.origin.y+50 , rect.size.width, rect.size.height);
                rect = cell.contentImage.frame;
                cell.contentImage.frame = CGRectMake(rect.origin.x, rect.origin.y+50 , rect.size.width, rect.size.height);
                rect = cell.zanBut.frame;
                cell.zanBut.frame = CGRectMake(rect.origin.x, rect.origin.y+50 , rect.size.width, rect.size.height);
                
            }
            
            
            [cell.zanBut addTarget:self action:@selector(clicked_zanBut:) forControlEvents:UIControlEventTouchUpInside];
            [cell.zanBut setTitle:[NSString stringWithFormat:@"    %@",uDic[@"approvalnum"]]  forState:UIControlStateNormal];
            
            [cell.iconImage setImageWithURL:[NSURL URLWithString:uDic[@"icon"]]];
            
            cell.contentImage.urlString = uDic[@"image"];
            [cell.contentImage addTarget:self action:@selector(FdImageView:) forControlEvents:UIControlEventTouchUpInside];
            
            //      cell.contentLab.text = uDic[@"content"];
            NSLog(@"%@",uDic[@"content"]);
            [cell.contentLab LoadContent:uDic[@"content"]];

            cell.nameLab.text = uDic[@"name"];
            cell.statusLab.text = uDic[@"status"];
            cell.timeLab.text = uDic[@"time"];
            cell.levelLab.text = [NSString stringWithFormat:@"LV.%@",uDic[@"level"]];
            cell.iconBut.tag = [uDic[@"uid"] intValue]+50;
            [cell.iconBut addTarget:self action:@selector(clicked_iconBut:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.plBut addTarget:self action:@selector(plBut_jubaoBut) forControlEvents:UIControlEventTouchUpInside];
            
            
            
            
            
        }else{
            cell.numLab.hidden = NO;
            cell.audioButton.hidden = YES;
            
            cell.numView.image = [UIImage imageNamed:@"001_8.png"];
            
            NSDictionary *dic = _muArr[indexPath.row -1];
            
            [cell ShowContent:dic];
            
            cell.zanBut.tag =[dic[@"id"] intValue]+10000000*(indexPath.row-1);
            [cell.zanBut setTitle:[NSString stringWithFormat:@"    %@",dic[@"approvalnum"]]  forState:UIControlStateNormal];
            
            NSString *isapproval = [NSString stringWithFormat:@"%@",dic[@"isapproval"]];
            if ([isapproval isEqualToString:@"0"]) {
                cell.zanBut.opaque=NO;
                
                [cell.zanBut addTarget:self action:@selector(clicked_zanTBut:)forControlEvents:UIControlEventTouchUpInside];
            }else{
                cell.zanBut.opaque=YES;
                
                [cell.zanBut addTarget:self action:@selector(clicked_zanTBut:)forControlEvents:UIControlEventTouchUpInside];
            }
            
            
            
            [cell.iconImage setImageWithURL:[NSURL URLWithString:dic[@"icon"]]];
            
            cell.contentImage.urlString = dic[@"image"];
            
            [cell.contentImage addTarget:self action:@selector(FdImageView:) forControlEvents:UIControlEventTouchUpInside];
            
            
            
            //      cell.contentLab.text = dic[@"content"];
            [cell.contentLab LoadContent:dic[@"content"]];
            cell.nameLab.text = dic[@"name"];
            cell.statusLab.text = dic[@"status"];
            cell.numLab.text = dic[@"num"];
            cell.levelLab.text = [NSString stringWithFormat:@"LV.%@",dic[@"level"]];

            cell.timeLab .text = dic[@"time"];
            cell.iconBut.tag = [dic[@"uid"] intValue]+50;
            [cell.iconBut addTarget:self action:@selector(clicked_iconBut:) forControlEvents:UIControlEventTouchUpInside];
            cell.plBut.tag = [dic[@"id"] intValue]*100000 +indexPath.row - 1;
            
            
            [cell.plBut addTarget:self action:@selector(plBut_jubaoBut2:) forControlEvents:UIControlEventTouchUpInside];
            
            NSString *type = [NSString stringWithFormat:@"%@",dic[@"type"]];
            
            if ([type isEqualToString:@"2"]){
                
                NSDictionary*relpDic = dic[@"recontent"];
                NSString *relpContent = relpDic[@"content"];
                
                [cell.replyContentLab LoadContent:relpContent];
                cell.replyNameLab.text = relpDic[@"name"];
                cell.replyTimeLab.text = relpDic[@"time"];
                cell.repNumLab.text = relpDic[@"num"];
                [cell.replyIconView setImageWithURL:[NSURL URLWithString:relpDic[@"icon"]]];
                
            }
            
            
            
            
        }
        return cell;
        
    }
    
    
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_uitable tableViewDidEndDragging:scrollView];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_uitable tableViewDidScroll:scrollView];
    
}

- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    page = 1;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}



- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    page++;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
    
}



- (void)FdImageView:(AsyncImageView *)sender
{
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    NSLog(@"%@", sender.urlString);
    
    float iWidth = sender.image.size.width;
    float iHeight = sender.image.size.height;
    float fScale1 = iWidth/keywindow.bounds.size.width;
    float fScale2 = iHeight/keywindow.bounds.size.height;
    NSLog(@"%f, %f", fScale1, fScale2);
    float fMaxScale = 2.37;
    if (fScale1>0 && fScale2>0) {
        fMaxScale = MAX(fScale1/fScale2, fScale2/fScale1);
    }
    if (fMaxScale<2.37) {
        fMaxScale = 2.37;
    }
    if (fMaxScale>10) {
        fMaxScale = 10;
    }
    
    NSString *urlstr = [sender.urlString stringByReplacingOccurrencesOfString:@"_small" withString:@""];
    LargeImageView *largeView = [[LargeImageView alloc] initWithFrame:keywindow.bounds];
    largeView.backgroundColor = [UIColor blackColor];
    largeView.mMaxZoomScale = fMaxScale;
    [keywindow addSubview:largeView];
    [largeView release];
    [largeView ShowImage:urlstr];
//    
//    BigImageView * _zoomScrollView = [[BigImageView alloc]initWithFrame:sender.frame image:sender.image];
//    _zoomScrollView.backgroundColor=[UIColor blackColor];
//    
//    [self.view addSubview:_zoomScrollView];
//    [_zoomScrollView release];
//    
//    
//    
}

-(void)plBut_jubaoBut{
    IBActionSheet * customIBAS = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"评论",@"举报",nil];
    customIBAS.tag = 1;
    [customIBAS showInView:self.view];
    [customIBAS release];
    
}
-(void)plBut_jubaoBut2:(UIButton *)but{
    
    IBActionSheet * customIBAS = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"回复",@"举报",nil];
    customIBAS.tag = but.tag;
    [customIBAS showInView:self.view];
    [customIBAS release];
    
}


-(void)clicked_huifuBut:(int )but{
    pinglunViewController *ctrl = [[pinglunViewController alloc]init];
    ctrl.commentID = self.contentID;
    ctrl.cID = [NSString stringWithFormat:@"%d",but/100000];
    ctrl.delegate = self;
    [self.navigationController pushViewController:ctrl animated:YES];
    
}

-(void)clicked_commentBut{
    pinglunViewController *ctrl = [[pinglunViewController alloc]init];
    ctrl.commentID = self.contentID;
    ctrl.delegate = self;
    [self.navigationController pushViewController:ctrl animated:YES];
}

-(void)clicked_iconBut:(UIButton *)but{
    NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
    
    NSMutableDictionary * asiDictiong=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[userDic valueForKey:@"uid"],@"uid",[userDic valueForKey:@"token"],@"token",[NSString stringWithFormat:@"%d",but.tag-50],@"id",@"1",@"bool", nil];
    NSLog(@"%@",asiDictiong);
    //  [asiDictiong setObject:@"1" forKey:@"bool"];
    WoViewController * woview=[[WoViewController alloc]init];
    woview.oldDictionary=asiDictiong;
    [asiDictiong release];
    [self.navigationController pushViewController:woview animated:YES];
    [woview release];
    //  [self analyUrl:asiDictiong];
    //  [asiDictiong release];
    
    //  NSLog(@"but tag is %d  %@",but.tag-50,,);
    
    
    
}
-(void)clicked_shareBut{
    IBActionSheet * customIBAS = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"短信分享",@"微信分享",@"朋友圈分享",@"新浪微博分享",@"腾讯微博分享",nil];
    customIBAS.tag = 100;
    [customIBAS showInView:self.view];
    [customIBAS release];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 100) {
        NSDictionary *dic = _muUserArr[0];
        
        if (buttonIndex!=5) {
            NSString *shareurl = [NSString stringWithFormat:@"%@themeshow?id=%@", SERVER_URL, self.contentID];
            NSString *content = dic[@"content"];
            if (content.length>140) {
                content = [NSString stringWithFormat:@"%@...",[content substringToIndex:100]];
            }
            else if (content.length == 0) {
                content = @"";
            }
            content = [content stringByAppendingFormat:@" %@", shareurl];
            //      NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"" ofType:@""];
            NSString * realPath= [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, //NSDocumentDirectory or NSCachesDirectory
                                                                      NSUserDomainMask, //NSUserDomainMask
                                                                      YES)	// YES
                                  objectAtIndex: 0];
            NSString *imageCachePath = [dic[@"image"] stringByReplacingOccurrencesOfString: @"/" withString: @"_"];
            NSString * filePath=[realPath stringByAppendingPathComponent:imageCachePath];
            NSLog(@"%@",content);
            AGViewDelegate * _viewDelegate = [[AGViewDelegate alloc] init];
            id<ISSContent> publishContent = [ShareSDK content:content
                                               defaultContent:dic[@"name"]
                                                        image:[ShareSDK imageWithPath:filePath]
                                                        title:dic[@"title"]
                                                          url:shareurl
                                                  description:@"222"
                                                    mediaType:SSPublishContentMediaTypeNews];
            id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                                 allowCallback:YES
                                                                 authViewStyle:SSAuthViewStyleFullScreenPopup
                                                                  viewDelegate:nil
                                                       authManagerViewDelegate:_viewDelegate];
            [authOptions setPowerByHidden:YES];

            int fenxiangType=0;
            if (buttonIndex==0) {
                fenxiangType=19;
            }
            else if (buttonIndex==1)
            {
                fenxiangType=22;
            }else if (buttonIndex==2)
            {
                fenxiangType=23;
            }else if (buttonIndex==3)
            {
                fenxiangType=1;
            }
            else
            {
                fenxiangType=2;
            }
            
            [ShareSDK shareContent:publishContent type:fenxiangType  authOptions:authOptions shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                                                                                                 oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                                                                                                  qqButtonHidden:NO
                                                                                                                           wxSessionButtonHidden:NO
                                                                                                                          wxTimelineButtonHidden:NO
                                                                                                                            showKeyboardOnAppear:NO
                                                                                                                               shareViewDelegate:_viewDelegate
                                                                                                                             friendsViewDelegate:_viewDelegate
                                                                                                                           picViewerViewDelegate:nil] statusBarTips:YES result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                if (state == SSPublishContentStateSuccess)
                {
                    NSLog(@"发表成功");
                }
                else if (state == SSPublishContentStateFail)
                {
                    NSLog(@"发布失败!error code == %d, error code == %@", [error errorCode], [error errorDescription]);
                }
            }];
            [_viewDelegate release];
        }
        
        
    }else if(actionSheet.tag == 1){
        if (buttonIndex == 0) {
            
            NSLog(@"pinglun");
            [self clicked_commentBut];
            
        }else if(buttonIndex == 1){
            [self jubaoButTie:nil];
            NSLog(@"jubao");
            
            
        }
        
        
    }else{
        if (buttonIndex == 0) {
            [self clicked_huifuBut:actionSheet.tag];
        }else if(buttonIndex == 1){
            
            [self jubaoButHui:actionSheet.tag];
        }
        
    }
    
}



-(void)sendComment:(NSString *)comment{
    
    MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = @"发送成功";
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [HUD removeFromSuperview];
        [HUD release];
    }];
    
    page = 1;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
    
    
    //  [self loadData];
}
- (void)playAudio:(Mp3PlayerButton *)button
{
    
    NSDictionary *uDic = _muUserArr[0];
    NSString *vieo =[NSString stringWithFormat:@"%@", [uDic[@"vieo"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"vieo %@",vieo);
    
//    vieo = [@"http://qq.djwma.com/mp3/中国好声音第二季领军人物精选音乐连版.mp3" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:vieo];

    button.mp3URL = url;

    if (_player == nil) {
        _player = [[NCMusicEngine alloc] init];
        //_player.button = button;
        _player.delegate = self;
    }
    
    if ([_player.button isEqual:button]) {
        if (_player.playState == NCMusicEnginePlayStatePlaying) {
            [_player pause];
        }
        else if(_player.playState==NCMusicEnginePlayStatePaused){
            [_player resume];
        }
        else{
            [_player playUrl:button.mp3URL];
        }
    } else {
        [_player stop];
        _player.button = button;
        [_player playUrl:button.mp3URL];
    }
}
- (void)engine:(NCMusicEngine *)engine didChangePlayState:(NCMusicEnginePlayState)playState{

}
- (void)engine:(NCMusicEngine *)engine didChangeDownloadState:(NCMusicEngineDownloadState)downloadState{

}
- (void)engine:(NCMusicEngine *)engine downloadProgress:(CGFloat)progress{
    NSLog(@"prog1111 %f",progress);

}
- (void)engine:(NCMusicEngine *)engine playProgress:(CGFloat)progress{
    NSLog(@"prog %f",progress);
}
//- (void)playAudio:(AudioButton *)button
//{
//    NSDictionary *uDic = _muUserArr[0];
//    NSString *vieo =[NSString stringWithFormat:@"%@", [uDic[@"vieo"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    NSLog(@"vieo %@",vieo);
//    
////    vieo = [@"http://qq.djwma.com/mp3/中国好声音第二季领军人物精选音乐连版.mp3" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *url = [NSURL URLWithString:vieo];
//    
//    if (_audioPlayer == nil) {
//        _audioPlayer = [[AudioPlayer alloc] init];
//    }
//    
//    if ([_audioPlayer.button isEqual:button]) {
//        [_audioPlayer play];
//    } else {
//        [_audioPlayer stop];
//        
//        _audioPlayer.button = button;
//        _audioPlayer.url = url;
//        
//        [_audioPlayer play];
//    }
//}

-(void)jubaoButTie:(UIButton *)but{
    
    NSDictionary *dic =_muUserArr[0];
    
    NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
    
    NSMutableDictionary * asiDictiong=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[userDic valueForKey:@"uid"],@"uid",[userDic valueForKey:@"token"],@"token",self.contentID,@"id",@"4",@"type",dic[@"uid"],@"targetid",dic[@"content"],@"content",@"http://apptest.mum360.com/web/home/index/reportcontent",@"aUrl",@"jubao",@"Controller", nil];
    [self analyUrl:asiDictiong];
    [asiDictiong release];
    
    
}

-(void)jubaoButHui:(int )but{
    NSDictionary * dic = _muArr[but%10000];
    
    NSMutableDictionary * userDic = [[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
    
    NSMutableDictionary * asiDictiong = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[userDic valueForKey:@"uid"],@"uid",[userDic valueForKey:@"token"],@"token",dic[@"id"],@"id",@"5",@"type",dic[@"uid"],@"targetid",dic[@"content"],@"content",@"http://apptest.mum360.com/web/home/index/reportcontent",@"aUrl",@"jubao",@"Controller", nil];
    [self analyUrl:asiDictiong];
    [asiDictiong release];
    
}

-(void)clicked_leftBut{
    if (analysis) {
        [analysis CancelMenthrequst];
    }
    if (_audioPlayer){
        [_audioPlayer stop];
        [_audioPlayer release];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayTabBar" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)makeHUD{
    myHUD= [[MBProgressHUD alloc] initWithView:self.view];
    [_uitable addSubview:myHUD];
    //  myHUD.dimBackground = YES;
    
    myHUD.labelText = @"加载中..";
    [myHUD show:YES];
    
}
-(void)remHUD{
    [myHUD removeFromSuperview];
    [myHUD release];
}


@end
