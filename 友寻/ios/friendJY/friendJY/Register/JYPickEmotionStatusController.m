//
//  JYPickEmotionStatusController.m
//  friendJY
//
//  Created by 高斌 on 15/3/5.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYPickEmotionStatusController.h"
#import "JYShareData.h"

@interface JYPickEmotionStatusController ()

@end

@implementation JYPickEmotionStatusController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [self setTitle:@"选择情感状态"];
        
        //_emotionStatusDict = [[JYShareData sharedInstance].profile_dict objectForKey:@"marriage"];
        
        // 单身 恋爱中 已婚 保密
        _emotionStatusDict = [[NSDictionary alloc]initWithObjects:@[@"单身",@"恋爱中",@"已婚",@"保密"] forKeys:@[@"1",@"2",@"3",@"4"]];
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 200) style:UITableViewStylePlain];
    [_table setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_table setRowHeight:50.0f];
    [_table setDelegate:self];
    [_table setDataSource:self];
    [self.view addSubview:_table];
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

- (void)backAction
{
    if ([self.jyDelegate respondsToSelector:@selector(pickEmotionStatusCompleteWithIndex:)])
    {
        [self.jyDelegate performSelector:@selector(pickEmotionStatusCompleteWithIndex:) withObject:[NSNumber numberWithInteger:_seleStatues]];
    }
    
    [super backAction];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (int i = 0; i<4; i++) {
         UITableViewCell *lastSelectedCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        UIImageView *lastIndicatorImage = (UIImageView *)[lastSelectedCell viewWithTag:101];
        [lastIndicatorImage setHidden:YES];
    }
    
    UITableViewCell *currentSelectedCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
    UIImageView *currentIndicatorImage = (UIImageView *)[currentSelectedCell viewWithTag:101];
    [currentIndicatorImage setHidden:NO];
    
    _seleStatues = indexPath.row;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        UILabel *statusLab = [[UILabel alloc] initWithFrame:CGRectZero];
        [statusLab setBackgroundColor:[UIColor clearColor]];
        [statusLab setFont:[UIFont systemFontOfSize:14.0f]];
        [statusLab setTextColor:kTextColorGray];
        [statusLab setTextAlignment:NSTextAlignmentLeft];
        [statusLab setTag:100];
        [cell.contentView addSubview:statusLab];
        
        UIImageView *indicatorImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [indicatorImage setImage:[UIImage imageNamed:@"register_checkmark.png"]];
        [indicatorImage setTag:101];
        [indicatorImage setHidden:YES];
        [cell.contentView addSubview:indicatorImage];
    }
    
    UILabel *statusLab = (UILabel *)[cell.contentView viewWithTag:100];
    UIImageView *indicatorImage = (UIImageView *)[cell.contentView viewWithTag:101];
    
    [statusLab setFrame:CGRectMake(15, 0, 100, 44)];
    NSString *key = [NSString stringWithFormat:@"%ld", (long)indexPath.row+1];
    [statusLab setText:[_emotionStatusDict objectForKey:key]];
    
    [indicatorImage setFrame:CGRectMake(kScreenWidth-21-15, 14, 21, 15)];
    if (indexPath.row == self.seleStatues) {
        [indicatorImage setHidden:NO];
    } else {
        [indicatorImage setHidden:YES];
    }
    
    return cell;
}



@end
