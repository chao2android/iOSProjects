//
//  TuijianquanziViewController.m
//  好妈妈
//
//  Created by iHope on 13-9-22.
//  Copyright (c) 2013年 1510Cloud. All rights reserved.
//

#import "TuijianquanziViewController.h"
#import "TuijianquanziCell.h"
#import "ZuiXinFaBu_ViewController.h"
#import "TishiView.h"
#import "HuatiCell.h"
#import "contentViewController.h"
#import "QzcyCell.h"
#import "RootViewController.h"
#import "WoViewController.h"
@interface TuijianquanziViewController ()

@end

@implementation TuijianquanziViewController
@synthesize selectImageView;
@synthesize dataArray;
@synthesize oldDictionary;
@synthesize postDictionary;
@synthesize tishiView;
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ReloadQuanziMenht" object:nil];
    [postDictionary release];
    [tishiView release];
    [oldDictionary release];
    [dataArray release];
    [selectImageView release];
    [super dealloc];
}

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
- (void)ReloadQuanziMenht:(NSNotification *)aDictionary
{
    for (int i=0; i<self.dataArray.count; i++) {
        if ([[aDictionary.object valueForKey:@"id"] isEqualToString:[[self.dataArray objectAtIndex:i] valueForKey:@"id"]]) {
            NSLog(@"[self.dataArray objectAtIndex:i] %@  %@",[self.dataArray objectAtIndex:i],[aDictionary.object valueForKey:@"flag"]);
            [[self.dataArray objectAtIndex:i] setValue:[aDictionary.object valueForKey:@"flag"] forKey:@"flag"];
            NSLog(@"[self.dataArray objectAtIndex:i] %@",[self.dataArray objectAtIndex:i]);

            [_uitable reloadData];
            return;
        }
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"%@",self.oldDictionary);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReloadQuanziMenht:) name:@"ReloadQuanziMenht" object:nil];
    UIImageView * backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, KUIOS_7(Screen_Height-20))];
    backImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"底" ofType:@"png"]];
    [self.view addSubview:backImageView];
    [backImageView release];
    UIImageView * navigation=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, KUIOS_7(44))];
    navigation.userInteractionEnabled=YES;
    navigation.backgroundColor=[UIColor blackColor];
    navigation.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nav_background" ofType:@"png"]];
    [self.view addSubview:navigation];
    [navigation release];
    UILabel * navigationLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, KUIOS_7(11), (Screen_Width-160), 22)];
    navigationLabel.backgroundColor=[UIColor clearColor];
    navigationLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:22];
    navigationLabel.textAlignment=NSTextAlignmentCenter;
    navigationLabel.textColor=[UIColor whiteColor];
    navigationLabel.text=[self.oldDictionary valueForKey:@"Title"];
    [navigation addSubview:navigationLabel];
    [navigationLabel release];
    if ([[[self.oldDictionary valueForKey:@"typeArr"] objectAtIndex:0] isEqualToString:@"完成"]) {
        
    }else{
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(5, KUIOS_7(7), 51, 33);
    [back setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backup) forControlEvents:UIControlEventTouchUpInside];
    [navigation addSubview:back];
    }

    page=1;
    NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
    [self.oldDictionary setValue:[userDic valueForKey:@"uid"] forKey:@"uid"];
    [self.oldDictionary setValue:[userDic valueForKey:@"token"] forKey:@"token"];
    [self.oldDictionary setValue:@"15" forKey:@"limit"];
    [self.oldDictionary setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [self.oldDictionary setValue:@"tuijianquanzi" forKey:@"oldViewController"];
    [self.oldDictionary setValue:[self.oldDictionary valueForKey:@"aUrl1"] forKey:@"aUrl"];
    self.dataArray=[[[NSMutableArray alloc]initWithCapacity:1] autorelease];

    _uitable = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, KUIOS_7(44), Screen_Width, Screen_Height-20-44) pullingDelegate:(id<PullingRefreshTableViewDelegate>)self];
    _uitable.backgroundColor = [UIColor clearColor];
    _uitable.delegate = self;
    _uitable.dataSource = self;
    _uitable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_uitable];
    [_uitable release];
    
    if ([[self.oldDictionary valueForKey:@"typeArr"] count]) {
        [self.oldDictionary setValue:@"1" forKey:@"type"];
        
    rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBut.frame = CGRectMake(Screen_Width-52, KUIOS_7(7), 47, 30);
    [rightBut setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"钮" ofType:@"png"]] forState:UIControlStateNormal];
        if ([[[self.oldDictionary valueForKey:@"typeArr"] objectAtIndex:0] isEqualToString:@"完成"]&&[[self.oldDictionary valueForKey:@"typeArr"]count]==1)
        {
            [rightBut addTarget:self action:@selector(RightMenth1) forControlEvents:UIControlEventTouchUpInside];

        }
        else
        {
    [rightBut addTarget:self action:@selector(RightMenth) forControlEvents:UIControlEventTouchUpInside];
        }
    rightBut.titleLabel.font=[UIFont systemFontOfSize:14];
    [rightBut setTitle:[[self.oldDictionary valueForKey:@"typeArr"] objectAtIndex:0] forState:UIControlStateNormal];
    [navigation addSubview:rightBut];
    
    self.selectImageView=[[[UIImageView alloc]initWithFrame:CGRectMake(Screen_Width-78, KUIOS_7(35), 75, [[self.oldDictionary valueForKey:@"typeArr"] count]*27+20)] autorelease];
    self.selectImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"000_20" ofType:@"png"]];
    selectImageView.userInteractionEnabled=YES;
    [self.view addSubview:self.selectImageView];
    selectImageView.hidden=YES;
    for (int i=0; i<[[self.oldDictionary valueForKey:@"typeArr"] count]; i++) {
        UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.tag=i;
        button.titleLabel.font=[UIFont systemFontOfSize:12];
        [button addTarget:self action:@selector(ButtonMenth:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:[[self.oldDictionary valueForKey:@"typeArr"] objectAtIndex:i] forState:UIControlStateNormal];
        button.frame=CGRectMake(0, 27*i+10, 75, 27);
        [selectImageView addSubview:button];
    }
    }

    self.tishiView=[TishiView tishiViewMenth];
    [self.view addSubview:tishiView];
    NSLog(@"oldDictionary  %@",self.oldDictionary);

    [self analyUrl:self.oldDictionary];
//    ShiyongShuoMingVIew * shiyongShou=[[ShiyongShuoMingVIew alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, KUIOS_7(Screen_Height-20))];
//    shiyongShou.backgroundColor=[UIColor redColor];
//    [self.view addSubview:shiyongShou];
//    [shiyongShou release];

}
- (void)RightMenth1
{
    RootViewController * root=[[RootViewController alloc]init];
    [self.navigationController pushViewController:root animated:YES];
    [root release];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   if (rightBut&&[rightBut.titleLabel.text isEqualToString:@"好妈妈"])
   {
       if (ISIPAD) {
           return 71.5*1.4;
       }
       return 71.5;
   }
    if (ISIPAD) {
        return 55*1.4;
    }
    return 55;
   
}
- (void)analyUrl:(NSMutableDictionary *)urlString
{
    if (analysis) {
    [analysis CancelMenthrequst];
    }
    [tishiView StartMenth];
    NSLog(@"%@",urlString);

    NSURL * aUrl=[[NSURL alloc]initWithString:[urlString valueForKey:@"aUrl"]];
    analysis=[[AnalysisClass alloc]initWithIdentifier:aUrl DataName:Nil ControllerName:[urlString valueForKey:@"oldViewController"] delegate:self];
    [aUrl release];
    [analysis PostMenth:urlString];
}
- (void)Asihttp:(AnalysisClass *)asi DataArray:(NSMutableDictionary *)array
{
    NSLog(@"%@",array);
    [tishiView StopMenth];
    if ([[array valueForKey:asi.ControllerName] count]) {

    if ([asi.ControllerName isEqualToString:@"tuijianquanzi"])
    {
    [self.dataArray addObjectsFromArray:[array valueForKey:asi.ControllerName]];
    }
    else
    {
        if ([[[array valueForKey:asi.ControllerName] valueForKey:@"code"] intValue]==1)
        {
            if ([asi.ControllerName isEqualToString:@"shanquanzi"]) {
                
                [[self.dataArray objectAtIndex:selectcNum] setValue:@"0" forKey:@"flag"];

            }
            else
            {
                [[self.dataArray objectAtIndex:selectcNum] setValue:@"1" forKey:@"flag"];
            }
        }
        else
        {
            NSLog(@"%@",[[array valueForKey:asi.ControllerName] valueForKey:@"msg"]);
        }
    }
    }
    else
    {
        [_uitable tableViewDidFinishedLoading];
        _uitable .reachedTheEnd  = YES;
    }
    [_uitable reloadData];
    [_uitable tableViewDidFinishedLoading];
    [asi release];
    analysis=nil;
}
- (void)ButtonMenth:(UIButton *)sender
{
    [_uitable setContentOffset:CGPointMake(0, 0)];
    selectImageView.hidden=YES;
    [self.dataArray removeAllObjects];
    page=1;
    [self.oldDictionary setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    _uitable .reachedTheEnd  = NO;
    if (![[[self.oldDictionary valueForKey:@"typeArr"] objectAtIndex:sender.tag] isEqualToString:rightBut.titleLabel.text]) {
    [rightBut setTitle:[[self.oldDictionary valueForKey:@"typeArr"] objectAtIndex:sender.tag] forState:UIControlStateNormal];
    [self.oldDictionary setObject:[NSString stringWithFormat:@"%d",sender.tag+1] forKey:@"type"];
    [self.oldDictionary setValue:@"tuijianquanzi" forKey:@"oldViewController"];
    [self.oldDictionary setValue:[self.oldDictionary valueForKey:@"aUrl1"] forKey:@"aUrl"];

    [self analyUrl:self.oldDictionary];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (rightBut&&[rightBut.titleLabel.text isEqualToString:@"话题"]) {
        
    
    static NSString * cellString=@"fier";
    HuatiCell * cell=[tableView dequeueReusableCellWithIdentifier:cellString];
    if (cell==nil) {
        cell=[[[HuatiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString] autorelease];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (self.dataArray.count>indexPath.row) {
            
        

            if (cell.titleLabel) {
                NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
                [cell.titleLabel removeFromSuperview];
                cell.titleLabel = nil;
                [pool release];
            }
            cell.titleLabel=[[[ImageTextLabel alloc]initWithFrame:CGRectMake(5, 5, 200, 20)] autorelease];
            cell.titleLabel.textColor=[UIColor blackColor];
            cell.titleLabel.backgroundColor=[UIColor clearColor];
            [cell.backImageView addSubview:cell.titleLabel];
            cell.titleLabel.hangshu=YES;
            cell.titleLabel.m_Font=[UIFont systemFontOfSize:14];

            if (ISIPAD) {
                cell.titleLabel.m_Font=[UIFont systemFontOfSize:14*1.4];

            }
//            if ([[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"title"] length]>13) {
//                [cell.titleLabel LoadContent:[NSString stringWithFormat:@"%@...",[[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"title"] substringToIndex:13]]];
//                
//            }
//            else
//            {
                [cell.titleLabel LoadContent:[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"title"]];
                
//            }

    cell.timeLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"time"];
//    if ([[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"image"]length]) {
    cell.mainImageView.urlString=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"image"];
//            }
//            else
//            {
//                cell.mainImageView.image=[UIImage imageNamed:@"512.png"];
//            }
    cell.mainImageView.tag=indexPath.row;
    [cell.mainImageView addTarget:self action:@selector(CellSeleMenth:) forControlEvents:UIControlEventTouchUpInside];
    cell.mainImageView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"002_22" ofType:@"png"]]];
    cell.xingLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"approval"];
    cell.pinglunLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"comment"];
        }
        return cell;
    }
    else if (rightBut&&[rightBut.titleLabel.text isEqualToString:@"好妈妈"])
    {
        QzcyCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ID123"];
        if (cell == nil) {
            cell = [[[QzcyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID123"] autorelease];
        }
        if (self.dataArray.count>indexPath.row) {
            NSLog(@"%@  %@",self.oldDictionary,[self.dataArray objectAtIndex:indexPath.row]);
            
            cell.mainImageView.urlString=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"icon"];
           
            cell.titleLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"name"];
            cell.timeLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"status"];
            cell.subLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"sign"];
            cell.qzLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"approvalnum"];
            cell.gzLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"attentions"];
            cell.fsLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"fans"];
            cell.scLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"collection"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.cellButton.tag=indexPath.row;
            [cell.cellButton addTarget:self action:@selector(CellButtonMenth:) forControlEvents:UIControlEventTouchUpInside];
            if ([[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"flag"] intValue]) {
                
                [cell.guanzhuButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"已关注" ofType:@"png"]] forState:UIControlStateNormal];
                cell.guanzhuButton.opaque=NO;
            }
            else
            {
                [cell.guanzhuButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"关注" ofType:@"png"]] forState:UIControlStateNormal];
                cell.guanzhuButton.opaque=YES;
            }
            
            cell.guanzhuButton.tag=indexPath.row;
            [cell.guanzhuButton addTarget:self action:@selector(GuanZhuMenth:) forControlEvents:UIControlEventTouchUpInside];
            if ([[self.oldDictionary valueForKey:@"uid"] intValue]==[[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"id"]intValue]) {
                cell.guanzhuButton.hidden=YES;
            }
            else
            {
                cell.guanzhuButton.hidden=NO;

            }
        }
        return cell;
    }
    static NSString * cellIdentifier=@"cell";
    TuijianquanziCell * cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[[TuijianquanziCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (self.dataArray.count>indexPath.row) {
    
    cell.mainImageView.urlString=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"image"];
    cell.mainImageView.tag=indexPath.row;
    [cell.mainImageView addTarget:self action:@selector(CellSeleMenth:) forControlEvents:UIControlEventTouchUpInside];
        if ([[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"name"] length]>10)
        {
            [cell.titleLabel LoadContent:[NSString stringWithFormat:@"%@...",[[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"name"] substringToIndex:10]]];
        }
        else
        {
            [cell.titleLabel LoadContent:[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"name"]];
            
        }
        

    cell.numLabel.text=[NSString stringWithFormat:@"成员数:  %@",[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"num"]];
        if (cell.synopsisLabel) {
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            [cell.synopsisLabel removeFromSuperview];
            cell.synopsisLabel = nil;
            [pool release];
        }

        cell.synopsisLabel=[[[ImageTextLabel alloc]initWithFrame:CGRectMake(58, 33, Screen_Width-130, 10)] autorelease];
        cell.synopsisLabel.m_RowHeigh=10;
        cell.synopsisLabel.m_EmoWidth=10;
        cell.synopsisLabel.m_EmoHeight=10;
        cell.synopsisLabel.hangshu=YES;
        cell.synopsisLabel.backgroundColor=[UIColor clearColor];
        cell.synopsisLabel.m_Font=[UIFont systemFontOfSize:10];
        [cell.contentView addSubview:cell.synopsisLabel];
        if (ISIPAD) {
            cell.synopsisLabel.frame=CGRectMake(cell.synopsisLabel.frame.origin.x*1.4, cell.synopsisLabel.frame.origin.y*1.4, Screen_Width-130*1.4, cell.synopsisLabel.frame.size.height*1.4);
            cell.synopsisLabel.m_RowHeigh=10*1.4;
            cell.synopsisLabel.m_EmoWidth=10*1.4;
            cell.synopsisLabel.m_EmoHeight=10*1.4;
            cell.synopsisLabel.m_Font=[UIFont systemFontOfSize:10*1.3];

        }
    [cell.synopsisLabel LoadContent:[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"theme"]];
    [cell.symbolButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"002_3%d",[[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"flag"] intValue]+2] ofType:@"png"]] forState:UIControlStateNormal];
    cell.symbolButton.tag=indexPath.row;
    cell.symbolButton.opaque=[[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"flag"] intValue];
    [cell.symbolButton addTarget:self action:@selector(join_jiaru:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    return cell;
}
- (void)GuanZhuMenth:(UIButton *)sender
{
    NSLog(@"%@",[self.dataArray objectAtIndex:sender.tag]);
    [self.oldDictionary setValue:[[self.dataArray objectAtIndex:sender.tag] valueForKey:@"id"] forKey:@"targetid"];
    selectcNum=sender.tag;

    if (sender.opaque == NO) {
        
        UIAlertView * alertview=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"取消关注将扣除5个积分，您确定吗？" delegate:self cancelButtonTitle:@"取 消" otherButtonTitles:@"确定", nil];
        alertview.tag=0;
        [alertview show];
        [alertview release];
        
        }
        else
        {
            [self.oldDictionary setValue:@"http://apptest.mum360.com/web/home/index/addfriend" forKey:@"aUrl"];
            [self.oldDictionary setValue:@"zhengquanzi" forKey:@"oldViewController"];
            [self analyUrl:self.oldDictionary];

            
        }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag) {
        if (buttonIndex) {
            [self.oldDictionary setValue:@"http://apptest.mum360.com/web/home/index/deletemember" forKey:@"aUrl"];
            [self.oldDictionary setValue:@"shanquanzi" forKey:@"oldViewController"];
            [self analyUrl:self.oldDictionary];

        }
    }
    else
    {
        if (buttonIndex) {
            [self.oldDictionary setValue:@"http://apptest.mum360.com/web/home/index/deletefriend" forKey:@"aUrl"];
            [self.oldDictionary setValue:@"shanquanzi" forKey:@"oldViewController"];
            [self analyUrl:self.oldDictionary];

        }
    }
}
- (void)CellSeleMenth:(AsyncImageView *)sender
{
    [self ZuiXinMenth:[self.dataArray objectAtIndex:sender.tag]];
}

- (void)join_jiaru:(UIButton *)sender
{
    selectcNum = sender.tag;

    NSLog(@"%@",[[self.dataArray objectAtIndex:sender.tag] valueForKey:@"cid"]);
    
    if ([[[self.dataArray objectAtIndex:sender.tag] valueForKey:@"cid"] length])
    {
        [self.oldDictionary setValue:[[self.dataArray objectAtIndex:sender.tag] valueForKey:@"cid"] forKey:@"cid"];
    }
    else
    {
        [self.oldDictionary setValue:[[self.dataArray objectAtIndex:sender.tag] valueForKey:@"id"] forKey:@"cid"];
    }
    if (sender.opaque == NO)
    {
        [self.oldDictionary setValue:@"http://apptest.mum360.com/web/home/index/createmember" forKey:@"aUrl"];
        [self.oldDictionary setValue:@"zhengquanzi" forKey:@"oldViewController"];
        [self analyUrl:self.oldDictionary];

        
    }
    else {
        [self.oldDictionary setValue:@"http://apptest.mum360.com/web/home/index/deletemember" forKey:@"aUrl"];
        [self.oldDictionary setValue:@"shanquanzi" forKey:@"oldViewController"];
        [self analyUrl:self.oldDictionary];
//        UIAlertView * alertview=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"退出圈子要还回加入时送您的5个积分呢" delegate:self cancelButtonTitle:@"取 消" otherButtonTitles:@"确定", nil];
//        alertview.tag=1;
//        [alertview show];
//        [alertview release];
//       
    }
    NSLog(@"%d  %d",sender.opaque,sender.tag);
}
- (void)ZuiXinMenth:(NSMutableDictionary *)sender
{
    for (int i=0; i<[[sender allKeys] count]; i++) {
        if ([[[sender allKeys] objectAtIndex:i] isEqualToString:@"cid"]) {
            [sender setObject:[sender valueForKey:@"cid"] forKey:@"id"];
            break;
        }
    }
    ZuiXinFaBu_ViewController* faBuVC = [[ZuiXinFaBu_ViewController alloc]init];
    faBuVC.oldDictionary=sender;
    [self.navigationController pushViewController:faBuVC animated:YES];
    [faBuVC release];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"dataArray %@",[self.dataArray objectAtIndex:indexPath.row]);
    if (rightBut&&[rightBut.titleLabel.text isEqualToString:@"话题"]) {
        contentViewController *ctrl = [[contentViewController alloc]init];
        ctrl.contentID = self.dataArray[indexPath.row][@"id"];
        [self.navigationController pushViewController:ctrl animated:YES];
        [ctrl release];
    }
    else
    {
    [self ZuiXinMenth:[self.dataArray objectAtIndex:indexPath.row]];
    }
    
}
- (void)CellButtonMenth:(UIButton *)sender
{
    NSMutableDictionary * diction=[[NSMutableDictionary alloc]initWithCapacity:1];
    [diction addEntriesFromDictionary:[self.dataArray objectAtIndex:sender.tag]];
    [diction setObject:@"YES" forKey:@"bool"];
    [diction setValue:@"0" forKey:@"type"];
    WoViewController * woview=[[WoViewController alloc]init];
    woview.oldDictionary=diction;
    [diction release];
    [self.navigationController pushViewController:woview animated:YES];
    [woview release];
    
}

- (void)RightMenth
{
   
    if (selectImageView.hidden) {
        selectImageView.hidden=NO;
    }
    else
    {
        selectImageView.hidden=YES;
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    if ([oldDictionary valueForKey:@"bool"]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayTabBar" object:nil];
    }
    NSLog(@"%@", [self.oldDictionary valueForKey:@"Title"]);
   
    if (analysis&&![[[self.oldDictionary valueForKey:@"typeArr"] objectAtIndex:0] isEqualToString:@"完成"]) {
        
    
    [analysis CancelMenthrequst];
    }
    selectImageView.hidden=YES;
}
-(void)backup
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_uitable tableViewDidEndDragging:scrollView];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_uitable tableViewDidScroll:scrollView];
    
}

- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    [self.dataArray removeAllObjects];
    page=1;
    [self.oldDictionary setValue:@"tuijianquanzi" forKey:@"oldViewController"];
    [self.oldDictionary setValue:[self.oldDictionary valueForKey:@"aUrl1"] forKey:@"aUrl"];
    [self.oldDictionary setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    _uitable .reachedTheEnd  = NO;
    [self analyUrl:self.oldDictionary];
}



- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    page++;
    [self.oldDictionary setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [self analyUrl:self.oldDictionary];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
