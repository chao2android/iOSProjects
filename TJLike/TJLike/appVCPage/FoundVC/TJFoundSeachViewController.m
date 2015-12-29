//
//  TJFoundSeachViewController.m
//  TJLike
//
//  Created by MC on 15/4/13.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJFoundSeachViewController.h"
#import "TJFountInputCarViewController.h"
#import "CarCell.h"
#import "TJFountAddCarViewController.h"
#import "TJFoundCarSettingViewController.h"

@interface TJFoundSeachViewController ()
{
    UIView *otisView;
    UITableView *mTableView;
    NSMutableArray *dataArray;
}
@end

@implementation TJFoundSeachViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.naviController setNaviBarTitle:@"违章查询"];
    [self.naviController setNavigationBarHidden:NO];
    [self.naviController setNaviBarDefaultLeftBut_Back];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:240/250.f green:240/250.f blue:240/250.f alpha:1];
    
    
    dataArray = [[NSMutableArray alloc]init];
    //fonud_5_
    for (int i = 0; i<2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        btn.frame = CGRectMake(i*SCREEN_WIDTH*0.5, 64, 0.5*SCREEN_WIDTH, 90);
        btn.tag = 1000+i;
        [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 43, 43)];
        image.image = [UIImage imageNamed:i==0?@"fonud_5_":@"fonud_6_"];
        image.center = CGPointMake(SCREEN_WIDTH*0.25, 30);
        [btn addSubview:image];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH*0.5, 20)];
        label.text = i==0?@"违章查询":@"限行限号";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor blackColor];
        [btn addSubview:label];
        if (i==0) {
            UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.5-0.5, 0, 0.5, 90)];
            lineView.backgroundColor = [UIColor grayColor];
            [btn addSubview:lineView];
        }
        
        UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 89.5, SCREEN_WIDTH*0.5, 0.5)];
        lineView.backgroundColor = [UIColor grayColor];
        [btn addSubview:lineView];
    }
    
    mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 155, SCREEN_WIDTH, self.view.bounds.size.height-210)];
    mTableView.backgroundColor = [UIColor clearColor];
    mTableView.dataSource = self;
    mTableView.delegate = self;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mTableView];
    
    
    otisView = [[UIView alloc]initWithFrame:CGRectMake(0, 160, SCREEN_WIDTH, 400)];
    otisView.backgroundColor = [UIColor clearColor];
    otisView.userInteractionEnabled = YES;
    otisView.hidden = YES;
    [self.view addSubview:otisView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = CGRectMake(0, 0, 0.5*SCREEN_WIDTH, 105);
    btn.center = CGPointMake(SCREEN_WIDTH*0.5, 300);
    [btn addTarget:self action:@selector(AddCar) forControlEvents:UIControlEventTouchUpInside];
    [otisView addSubview:btn];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 85, 85)];
    image.image = [UIImage imageNamed:@"fonud_4_"];
    image.center = CGPointMake(SCREEN_WIDTH*0.25, 42.5);
    [btn addSubview:image];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 85, SCREEN_WIDTH*0.5, 20)];
    label.text = @"点击添加车辆";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor blackColor];
    [btn addSubview:label];
    
    [self GetData];
}
- (void)AddCar{
    TJFountAddCarViewController *ctrl = [[TJFountAddCarViewController alloc]init];
    ctrl.mBlock = ^{
        [self GetData];
    };
    [self.naviController pushViewController:ctrl animated:YES];
}
- (void)GetData{
    NSArray *array=[SHARE_DEFAULTS objectForKey:@"Car"];
    dataArray = [array mutableCopy];
    if (dataArray.count == 0) {
        otisView.hidden = NO;
    }else{
        otisView.hidden = YES;
    }
    [mTableView reloadData];
}
- (void)BtnClick:(UIButton *)sender{
    if (sender.tag == 1000) {
        TJFountInputCarViewController *ctrl = [[TJFountInputCarViewController alloc]init];
        [self.naviController pushViewController:ctrl animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    CarCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    [cell LoadContent:dataArray[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TJFoundCarSettingViewController *ctrl = [[TJFoundCarSettingViewController alloc]init];
    ctrl.indexPath = indexPath.row;
    ctrl.mBlock = ^{
        [self GetData];
    };
    [self.naviController pushViewController:ctrl animated:YES];
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
