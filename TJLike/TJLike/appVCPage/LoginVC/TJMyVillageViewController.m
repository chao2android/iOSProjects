//
//  TJMyVillageViewController.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/5.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJMyVillageViewController.h"
#import "TJVillageViewModel.h"

#define LABELCELL_Height (30)
#define LABELCELL_Y      (35)
#define LABELCELL_WidthH (80)
#define ThirdPartHeight 167.5
#define ThirdIconWH 66.5
#define TextFieldH 50
#define LineH 0.5


@interface TJMyVillageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) TJVillageViewModel *viewModel;
@property (nonatomic, strong) NSArray        *cityLists;
@property (nonatomic, strong) NSArray        *streetLists;
@property (nonatomic, strong) NSArray        *communityLists;


@end

@implementation TJMyVillageViewController

- (instancetype)init
{
    self =[super init];
    if (self) {
        
        _viewModel = [[TJVillageViewModel alloc] init];
    }
    return self;
}


- (void)bindViewModel
{
    _cityLists = [[NSArray alloc] init];
    _streetLists = [[NSArray alloc] init];
    _communityLists = [[NSArray alloc] init];
    
    @weakify(self)
    [[RACObserve(_viewModel, cityArr) filter:^BOOL(NSArray *value) {
        return value.count != 0;
    }] subscribeNext:^(NSArray *value) {
        @strongify(self)
        self.cityLists = value;
    }];
    
    [[RACObserve(_viewModel, cityArr) filter:^BOOL(NSArray *value) {
        return value.count != 0;
    }] subscribeNext:^(NSArray *value) {
        @strongify(self)
        self.streetLists = value;
    }];
    [[RACObserve(_viewModel, cityArr) filter:^BOOL(NSArray *value) {
        return value.count != 0;
    }] subscribeNext:^(NSArray *value) {
        @strongify(self)
        self.communityLists = value;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
    [self bindViewModel];
}

- (void)inistalNavBar
{
    [self.naviController setNaviBarTitle:@"我的小区"];
    [self.naviController setNaviBarTitleStyle:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NAVTITLE_COLOR_KEY,[UIFont boldSystemFontOfSize:19.0],NAVTITLE_FONT_KEY,nil]];
    UIImage *leftImg = [UIImage imageNamed:@"appui_fanhui_"];
    UIButton *leftBtn = [TJBaseNaviBarView createNaviBarBtnByTitle:nil imgNormal:@"appui_fanhui_" imgHighlight:nil withFrame:CGRectMake(0, 0, leftImg.size.width/2,leftImg.size.height/2)];
    [[leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [self.naviController popViewControllerAnimated:YES];
        
    }];
    [self.naviController setNaviBarLeftBtn:leftBtn];
    
    
    UIButton *rightBtn = [TJBaseNaviBarView createNaviBarBtnByTitle:@"完成" imgNormal:nil imgHighlight:nil withFrame:CGRectMake(0, 0, 40, 40)];
    [rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
       
        
    }];
    [self.naviController setNaviBarRightBtn:rightBtn];
    
}

- (void)buildUI
{
    _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsHorizontalScrollIndicator = YES;
    _tableView.scrollEnabled = NO;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 10);
    [self.view addSubview:_tableView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self inistalNavBar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
            break;
            
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 70;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 1:
            return SCREEN_HEIGHT - 70 *3;
            break;
        default:
            return 0;
            break;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 70 *3 - NAVIBAR_HEIGHT - STATUSBAR_HEIGHT)];
    view.backgroundColor = [UIColor clearColor];
    
    
    UIImage *image =[UIImage imageNamed:@"sign_10_"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setFrame:CGRectMake(20, view.frame.size.height *3/4, SCREEN_WIDTH - 40, 50)];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    
    
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        
    }];
    
    [view addSubview:button];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strCell = @"strCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:strCell];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                UIView *viewA  = [self setupTableViewCellSubView:CGRectMake(15, LABELCELL_Y, LABELCELL_WidthH, LABELCELL_Height) andTitle:@"区县"];
                
                [cell addSubview:viewA];
            }
                break;
            case 1:
            {
                
                UIView *viewC  = [self setupTableViewCellSubView:CGRectMake(15, LABELCELL_Y, LABELCELL_WidthH, LABELCELL_Height) andTitle:@"街道/乡镇"];
                [cell addSubview:viewC];
                
            }
                
                break;
            case 2:
            {

                UIView *viewD  = [self setupTableViewCellSubView:CGRectMake(15, LABELCELL_Y, LABELCELL_WidthH, LABELCELL_Height) andTitle:@"小区/村庄"];
                [cell addSubview:viewD];
                
            }
                
                break;
            default:
                break;
        }
    }


    return cell;
    
}


- (UIView *)setupTableViewCellSubView:(CGRect)frame andTitle:(NSString *)title
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] init];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setText:title];
    
    [label  setFont:[UIFont systemFontOfSize:20]];
    [label setTextColor:[UIColor redColor]];
    CGSize size =  [UIUtil textToSize:title fontSize:20];
    [label setFrame:CGRectMake(0, 0, size.width, frame.size.height)];
    [view addSubview:label];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(label.frame.size.width + 20,0,1, label.frame.size.height)];
    [line setBackgroundColor:[UIColor redColor]];
    [view addSubview:line];
    
    view.frame = CGRectMake(frame.origin.x, frame.origin.y, label.frame.size.width + 21, frame.size.height);
    
    return view;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                
                
                TLog(@"%@",NSStringFromCGRect([tableView rectForRowAtIndexPath:indexPath]));
            }
                break;
            case 1:
            {
                TLog(@"%@",NSStringFromCGRect([tableView rectForRowAtIndexPath:indexPath]));
               
                
            }
                
                break;
            case 2:
            {
                TLog(@"%@",NSStringFromCGRect([tableView rectForRowAtIndexPath:indexPath]));
                
            }
                
                break;
            default:
                break;
        }
    }
    

}

@end
