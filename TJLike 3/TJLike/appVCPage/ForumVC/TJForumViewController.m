//
//  TJForumViewController.m
//  TJLike
//
//  Created by IPTV_MAC on 15/3/29.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJForumViewController.h"
#import "TJForumViewModel.h"
#import "MJRefresh.h"
#import "TypeSelectView.h"
#import "WTVHomePosterView.h"
#import "TJBBSPosterModel.h"
#import "TJBBSHotsCommendCell.h"
#import "TJTopicViewCell.h"
#import "TJForumTableView.h"


#import "TJSubForumViewController.h"
#import "TJLoginRegisterViewController.h"
#import "TJSubjectPlacardViewController.h"

#define table_headerView_height         140.0 * SCREEN_PHISICAL_SCALE
#define NaviBtnTitles @[@"热点",@"板块"]

@interface TJForumViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,TJBBSHotsCommendCelldelegate>
{
    //海报
     UIView *currentPosterVi;
    //热点标题
    UIView  *hotView;
    int     requestInt;
    UIScrollView  *_ScrollView;
    
}

@property (nonatomic, strong) NSArray    *posterLists;
@property (nonatomic, strong) NSArray    *hotCommendLists;
@property (nonatomic, strong) NSArray    *hotLists;
//海报视图
@property (nonatomic, strong) WTVHomePosterView *posterView;

@property (nonatomic, strong) TJForumViewModel  *viewModel;

@property (nonatomic,strong) NSMutableArray *navBtns;

@property (nonatomic, strong)UIButton       *preBtn;

@property (nonatomic, strong)UIButton       *curBtn;

@property (nonatomic, strong)UITableView    *tableView;

@property (nonatomic, strong)TJForumTableView *fTableVIew;

@end

static NSString *LeftImg = @"luntan_fenlei_";
static NSString *RightImg = @"luntan_xinxi_";

@implementation TJForumViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        _navBtns = [[NSMutableArray alloc] init];
        _viewModel = [[TJForumViewModel alloc] init];
        requestInt = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.view.backgroundColor = [UIColor whiteColor];
   
    [self setupContentView];
    [self bindViewModel];
}

- (void)requestData
{
    [_viewModel requestBBsHotFocusFinish:^(NSArray *results) {
        
    } andFailed:^(NSString *errer) {
        
    }];
    
    
    [_viewModel requestBBsHotCommendFinish:^(NSArray *results) {
        
    } andFailed:^(NSString *errer) {
        
    }];
    
    [self requestHotList];
    
   
   
    
}


- (void)bindViewModel
{
    _posterLists = [[NSArray alloc] init];
    _hotCommendLists = [[NSArray alloc] init];
    _hotLists = [[NSArray alloc] init];
    
    /**
     *  监听海报数组
     */
    @weakify(self)
    [[RACObserve(self.viewModel, posterInfoArr) filter:^BOOL(NSArray *value) {
        
        return value.count != 0;
    }] subscribeNext:^(NSArray *values) {
        @strongify(self)
        self.posterLists = values;
        
        self->currentPosterVi = [self->_posterView posterViewWithInfo:self->_viewModel.posterInfoArr withFrame:CGRectMake(0, 0, SCREEN_WIDTH, table_headerView_height)];
        [self->_tableView reloadData];
        [self.tableView headerEndRefreshing];
    }];
    
    /**
     *  监听推荐数组
     *
     */
    [[RACObserve(self.viewModel, hotInfoArr) filter:^BOOL(NSArray *value) {
        return value.count != 0;
    }] subscribeNext:^(NSArray *results) {
        @strongify(self)
        self.hotCommendLists = results;
        [self->_tableView reloadData];
    }];
    
    [[RACObserve(self.viewModel, hotListArr) filter:^BOOL(NSArray *value) {
        
        return value.count != 0;
    }] subscribeNext:^(NSArray *results) {
        @strongify(self)
        self.hotLists = results;
        [self->_tableView reloadData];
        
    }];
    
    [[RACObserve(self.viewModel, forumArr) filter:^BOOL(NSArray *value) {
     
        return value.count != 0;
    }] subscribeNext:^(NSArray *results) {
       @strongify(self)
        self.fTableVIew.forumTitles = results;
        [self->_fTableVIew reloadData];
        
    }];
    
}

- (void)requestHotList
{
    @weakify(self)
    [_viewModel requestBBsHotListPage:requestInt andFinish:^(NSArray *results) {
        @strongify(self)
        [self.tableView footerEndRefreshing];
        
    } andFailed:^(NSString *errer) {
        @strongify(self)
       [self.tableView footerEndRefreshing];
        
    }];
}

- (void)requestForumList
{
    [self.fTableVIew headerBeginRefreshing];
}

- (void)inistalForumNaviBar:(BOOL)isHide
{
    UIImage *leftImg = [UIImage imageNamed:LeftImg];
    UIButton *leftBtn = [TJBaseNaviBarView createNaviBarBtnByTitle:nil imgNormal:LeftImg imgHighlight:nil withFrame:CGRectMake(0, 0,leftImg.size.width/2,leftImg.size.height/2)];
    [[leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        if (!UserManager.userInfor) {
            TJLoginRegisterViewController *loginVC = [[TJLoginRegisterViewController alloc] init];
            [self.naviController pushViewController:loginVC animated:YES];
        }
        else{
            TLog(@"我已经登录");
        }
        
        
        
    }];
    
    
    
     UIImage *rightImg = [UIImage imageNamed:LeftImg];
    UIButton *rightBtn = [TJBaseNaviBarView createNaviBarBtnByTitle:nil imgNormal:RightImg imgHighlight:nil withFrame:CGRectMake(0, 0,rightImg.size.width/2,rightImg.size.height/2)];
    [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
    
    }];
    
    if (isHide) {
        [self.naviController setNaviBarLeftBtn:nil];
        [self.naviController setNaviBarRightBtn:nil];
    }
    else {
        [self.naviController setNaviBarLeftBtn:leftBtn];
        [self.naviController setNaviBarRightBtn:rightBtn];
    }
}

- (void)initialNaviBar
{

   
    
    for (int i = 0 ; i<NaviBtnTitles.count; i++) {
        UIButton *btncenter = [TJBaseNaviBarView createNaviBarBtnByTitle:    [NaviBtnTitles objectAtIndex:i] imgNormal:nil imgHighlight:nil imgSelected:nil withFrame:CGRectMake(i *10, 25, 50,30)];
        [btncenter.layer setMasksToBounds:YES];
        btncenter.layer.cornerRadius = 10;
        [btncenter setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btncenter setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btncenter setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btncenter.tag = 100 +i;
        
        @weakify(self)
        [[btncenter rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            if (self.preBtn.tag != btncenter.tag) {
                btncenter.selected = YES;
                self.curBtn = btncenter;
                self.preBtn.selected = NO;
                [_preBtn setBackgroundColor:[UIColor clearColor]];
                [btncenter setBackgroundColor:[UIColor grayColor]];
                if (btncenter.tag == 100 ) {
                    
                    [_ScrollView setContentOffset:CGPointMake(0, -NAVIBAR_HEIGHT) animated:YES];
//                    [self inistalForumNaviBar:YES];
                }
                else if (btncenter.tag == 101)
                {
                    [_ScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, -NAVIBAR_HEIGHT) animated:YES];
//                    [self inistalForumNaviBar:NO];
                    [self requestForumList];
                    
                    
                }
                _preBtn = btncenter;
            }
            
        }];
        [_navBtns addObject:btncenter];
    }
    [self.naviController setNaviBarCenterBtnsWithButtonArray:_navBtns];
    
        _preBtn = [_navBtns objectAtIndex:0];
        _preBtn.selected = YES;
        [_preBtn setBackgroundColor:[UIColor grayColor]];
    

//    if (_preBtn.tag == 100) {
//        [self inistalForumNaviBar:YES];
//    }
//    else{
//        [self inistalForumNaviBar:NO];
//    }
    
}

- (void)setupContentView
{
    
    
    _ScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH, SCREEN_HEIGHT - TABBAR_HEIGHT)];
    
    [_ScrollView setContentSize:CGSizeMake(SCREEN_WIDTH *NaviBtnTitles.count, 0)];
    _ScrollView.showsHorizontalScrollIndicator = NO;
    _ScrollView.showsVerticalScrollIndicator = NO;
    _ScrollView.pagingEnabled = YES;
    _ScrollView.delegate = self;
    _ScrollView.bounces = NO;
    [self.view addSubview:_ScrollView];
//    [_ScrollView setBackgroundColor:[UIColor redColor]];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _ScrollView.frame.size.height) style:UITableViewStylePlain];
    NSLog(@"%@",NSStringFromCGRect(_tableView.frame));
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    [_ScrollView addSubview:_tableView];
    @weakify(self)
    [self.tableView addHeaderWithCallback:^{
        @strongify(self)
        
        [self requestData];
        
    }];
    [self.tableView addFooterWithCallback:^{
        @strongify(self)
        self->requestInt = self->requestInt + 3;
        [self requestHotList];
    }];
    
    [self.tableView headerBeginRefreshing];
    
    
    _fTableVIew = [[TJForumTableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH,  0, SCREEN_WIDTH, _ScrollView.frame.size.height - NAVIBAR_HEIGHT - STATUSBAR_HEIGHT) style:UITableViewStylePlain];
    [self.fTableVIew addHeaderWithCallback:^{
        @strongify(self)
        
        [self.viewModel requestBBsCatagoryFinish:^(NSArray *results) {
            
            
            [self.fTableVIew headerEndRefreshing];
        } andFailed:^(NSString *errer) {
            
            [self.fTableVIew headerEndRefreshing];
        }];
        
    }];
    self.fTableVIew.tapFuromCell = ^(TJBBSCateSubModel *item){
        @strongify(self)
       TJSubForumViewController *subForumVC = [[TJSubForumViewController alloc] initWithItem:item];
        [self.naviController pushViewController:subForumVC animated:YES];
        
    };
    
    
//    [self.fTableVIew addFooterWithCallback:^{
////        @strongify(self)
//
//    }];
    [_ScrollView addSubview:_fTableVIew];
    
    
    
    _posterView = [[WTVHomePosterView alloc] init];
    currentPosterVi = [[UIView alloc] init];

    hotView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 24)];
    UILabel *lblHot = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 24)];
    [lblHot setText:@"  热门"];
    [lblHot setTextAlignment:NSTextAlignmentLeft];
    [lblHot setFont:[UIFont systemFontOfSize:12.0f]];
    [hotView addSubview:lblHot];
    [lblHot setBackgroundColor:COLOR(242, 244, 248, 1)];
    
    
    _posterView.showPosterDetailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(TJBBSPosterModel *posterDetailInfo) {
//        @strongify(self)
        TLog(@"posterDetailInfo : %@", posterDetailInfo.bbsID);
        
       
        
       
        return [RACSignal empty];
    }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     self.tabBarController.tabBar.hidden = NO;

    self.naviController.navigationBarHidden = NO;
    if (_navBtns.count) {
        [_navBtns removeAllObjects];
    }
    
    
    [self initialNaviBar];
    if (_curBtn) {
        [_ScrollView setContentOffset:CGPointMake(0, -NAVIBAR_HEIGHT) animated:NO];
    }
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
     [self.posterView timerStop];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
            return 0;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return _hotLists.count;
            break;
        case 4:
            return 0;
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
            return 0;
            break;
        case 1:
            return 90;
            break;
        case 2:
            return 34;
            break;
        case 3:
            return 70;
            break;
        default:
            return 0;
            break;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0://header区域
            return table_headerView_height;
            break;
        default:
            return 0;
            break;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0://header区域
            return currentPosterVi;
            break;
        default:
            return nil;
            break;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 4:
            return 100;
            break;
            
        default:
            return 0;
            break;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 4:
        {
            UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
            footerView.backgroundColor = [UIColor whiteColor];
            
            UIButton *editBut = [UIButton buttonWithType:UIButtonTypeCustom];
            editBut.frame =  CGRectMake(0, 0, 290, 45);
            editBut.center = CGPointMake(SCREEN_WIDTH/2.0, 100/2);
            [editBut setTitle:@"加载更多" forState:UIControlStateNormal];
            [editBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            @weakify(self)
            [[editBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
//                @strongify(self)
                
                requestInt = requestInt +5;
                [self requestHotList];
               
                
            }];
            
            [footerView addSubview:editBut];
            return footerView;
        }
            break;
            
        default:
            return nil;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CustomCellIdentifier = @"TJTopicViewCell";
    static NSString *hotIdentifier = @"TJBBSHotsCommendCell";
    static NSString *hotTitleCell  = @"hotCell";
    if (indexPath.section == 1) {
        TJBBSHotsCommendCell *cell = (TJBBSHotsCommendCell *)[tableView dequeueReusableCellWithIdentifier:hotIdentifier];
        if (!cell) {
            cell = [[TJBBSHotsCommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotIdentifier];
            cell.delegate = self;
        }
        if (_hotCommendLists.count != 0) {
            [cell bindModel:_hotCommendLists];
        }
        
        
        return cell;
    }
    else if(indexPath.section == 3){
         TJTopicViewCell *cell = (TJTopicViewCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:CustomCellIdentifier owner:self options:nil] lastObject];
        }
        [cell bindModel:[_hotLists objectAtIndex:indexPath.row]];
        
        
        return cell;
    }
    else if (indexPath.section == 2)
    {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:hotTitleCell];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotTitleCell];
        }
        [cell addSubview:hotView];
        return cell;
    }

    return nil;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger curCount = scrollView.contentOffset.x/SCREEN_WIDTH;
 
    if (curCount == _preBtn.tag - 100) {
        return;
    }
    
    
    UIButton *button = [_navBtns objectAtIndex:curCount];
   
    button.selected = YES;
    _preBtn.selected = NO;
    [_preBtn setBackgroundColor:[UIColor clearColor]];
    [button setBackgroundColor:[UIColor grayColor]];
    _preBtn = button;
    if (_preBtn.tag == 100) {
//        [self inistalForumNaviBar:YES];
    }
    else{
//        [self inistalForumNaviBar:NO];
        [self requestForumList];
    }
}

- (void)pressHotRecommend:(int)index
{
    TJSubjectPlacardViewController *spVC = [[TJSubjectPlacardViewController alloc] init];
    [self.naviController pushViewController:spVC animated:YES];
}

@end
