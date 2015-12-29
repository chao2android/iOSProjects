//
//  JYProfileSetRootController.m
//  friendJY
//
//  Created by coder_zhang on 15/4/1.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYProfileSetRootController.h"

@interface JYProfileSetRootController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSIndexPath *lastSelectIndexPath;
}

@end

@implementation JYProfileSetRootController
- (NSString *)phoneNum{
//    if (_phoneNum == nil) {
        _phoneNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
//    }
    return _phoneNum;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    [self initFooterView];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (lastSelectIndexPath) {
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:lastSelectIndexPath];
        [cell setSelected:NO];
    }
}

- (void)initTableView{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight - kStatusBarHeight) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = kSettingDefaultBgColor;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    
}
- (void)initFooterView{
    UIView *view = [[UIView alloc] init];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, -1, kScreenWidth, 1)];
    line.layer.borderColor = [[JYHelpers setFontColorWithString:@"#cccccc"] CGColor];
    line.layer.borderWidth = 1;
    [view addSubview:line];
    _tableView.tableFooterView = view;
}
#pragma mark -UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.cellTitleArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ((NSArray*)self.cellTitleArr[section]).count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSettingCellID];
    }
    cell.textLabel.text = self.cellTitleArr[indexPath.section][indexPath.row];
    //    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kSettingCellHeight;
}
//headerView的配置
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return section == 0 ? kSettingFirstHeaderViewHeight : kSettingHeaderViewHeight;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSettingFirstHeaderViewHeight)];
        [view setBackgroundColor:kSettingDefaultBgColor];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kSettingFirstHeaderViewHeight-1, kScreenWidth, 1)];
        [lineView.layer setBorderColor:[[JYHelpers setFontColorWithString:@"#cccccc"] CGColor]];
        [lineView.layer setBorderWidth:1];
        [view addSubview:lineView];
        return view;
    }else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(-1, 0, kScreenWidth+2, kSettingHeaderViewHeight)];
        view.layer.borderWidth = 1;
        view.layer.borderColor = [[JYHelpers setFontColorWithString:@"#cccccc"] CGColor];
        view.backgroundColor = kSettingDefaultBgColor;
        return view;
    }
}
//去headerView黏性
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableView)
    {
        CGFloat sectionHeaderHeight = kSettingFirstHeaderViewHeight; //sectionHeaderHeight
        if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    lastSelectIndexPath = indexPath;
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
