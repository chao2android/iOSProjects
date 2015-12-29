//
//  GongjuViewController.m
//  好妈妈
//
//  Created by iHope on 13-9-22.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "GongjuViewController.h"

#import "HuiYuanZhiFuViewController.h"
#import "paoluanViewController.h"
#import "yuchanViewController.h"
#import "chanjianViewController.h"
#import "xingbieViewController.h"
#import "shengzhangViewController.h"
#import "yumiaoViewController.h"

#import "bianzhunquxiantuViewController.h"
#import "WeirijiViewController.h"

@interface GongjuViewController ()
{
    NSArray *ageArr;
    NSArray *monthArr;
    NSArray *dateArr;
    
    NSArray *zhouArr;
    NSArray *tianArr;
}

@end

@implementation GongjuViewController

- (void)dealloc{
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mArray =[[NSArray alloc]initWithObjects:@"排卵期",@"预产期",@"产检提醒",@"生男生女",@"疫苗提醒",@"微日记", nil];
    self.navigationController.navigationBar.hidden = YES;
    [self makView];
}

- (void)makView {
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
    
    UILabel * navigationLabel=[[UILabel alloc]initWithFrame:CGRectMake(100, KUIOS_7(11), (Screen_Width-200), 22)];
    navigationLabel.backgroundColor=[UIColor clearColor];
    navigationLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:22];
    navigationLabel.textAlignment=NSTextAlignmentCenter;
    navigationLabel.textColor=[UIColor whiteColor];
    navigationLabel.text=@"工具";
    [navigation addSubview:navigationLabel];
    [navigationLabel release];

    int iTop = KUIOS_7(44);
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, iTop, Screen_Width, Screen_Height-iTop-44)];
    mTableView.backgroundColor = [UIColor clearColor];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mTableView];
    [mTableView release];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellident = @"chanjianCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellident];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellident] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 7, 36, 36)];
        imageView.tag = 1200;
        [cell.contentView addSubview:imageView];
        [imageView release];
        
        UILabel *lbName = [[UILabel alloc] initWithFrame:CGRectMake(62, 7, 100, 36)];
        lbName.backgroundColor = [UIColor clearColor];
        lbName.font = [UIFont systemFontOfSize:15];
        lbName.tag = 1300;
        [cell.contentView addSubview:lbName];
        
        UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-1, cell.frame.size.width, 1)];
        lineView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        lineView.image = [UIImage imageNamed:@"f_tablecellline"];
        [cell addSubview:lineView];
    }
    NSString *imagename = [NSString stringWithFormat:@"004_%d.png", indexPath.row+4];
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1200];
    if (imageView) {
        imageView.image = [UIImage imageNamed:imagename];
    }
    UILabel *lbName = (UILabel *)[cell.contentView viewWithTag:1300];
    if (lbName) {
        lbName.text = [mArray objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int tag = indexPath.row;
    if (tag == 0){
        MOBCLICK(kMob_Tools1);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hidesTabBar" object:nil];
        paoluanViewController *ctrl = [[[paoluanViewController alloc]init]autorelease];
        [self.navigationController pushViewController:ctrl animated:YES];
    }else if (tag == 1){
        MOBCLICK(kMob_Tools2);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hidesTabBar" object:nil];
        yuchanViewController *ctrl = [[[yuchanViewController alloc]init]autorelease];
        [self.navigationController pushViewController:ctrl animated:YES];
    }else if (tag == 2){
        MOBCLICK(kMob_Tools3);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hidesTabBar" object:nil];
        chanjianViewController *ctrl = [[[chanjianViewController alloc]init]autorelease];
        [self.navigationController pushViewController:ctrl animated:YES];
    }else if (tag == 3){
        MOBCLICK(kMob_Tools4);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hidesTabBar" object:nil];
        xingbieViewController *ctrl = [[[xingbieViewController alloc]init]autorelease];
        [self.navigationController pushViewController:ctrl animated:YES];
    }else if (tag == 4){
        MOBCLICK(kMob_Tools5);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hidesTabBar" object:nil];
        yumiaoViewController *ctrl = [[[yumiaoViewController alloc]init]autorelease];
        [self.navigationController pushViewController:ctrl animated:YES];
        
    }else if (tag == 5){
        MOBCLICK(kMob_Tools6);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hidesTabBar" object:nil];
        //        yumiaoViewController *ctrl = [[[yumiaoViewController alloc]init]autorelease];
        //        [self.navigationController pushViewController:ctrl animated:YES];
        NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
        WeirijiViewController * weiriji=[[WeirijiViewController alloc]init];
        weiriji.typeString=@"0";
        weiriji.targetidString=[userDic valueForKey:@"uid"];
        [self.navigationController pushViewController:weiriji animated:YES];
        [weiriji release];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    for (UIView *view in self.view.subviews) {
//        [view removeFromSuperview];
//    }
//    [self makView];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayTabBar" object:nil];
}

@end
