//
//  TJSubForumViewController.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/11.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJSubForumViewController.h"
#import "TJSendTopicalViewController.h"
#import "TJTopicHeadViewCell.h"
#import "TJTopNoticeViewCell.h"
#import "TJTieBaContentViewCell.h"
#import "TJNoticeViewController.h"

#import "MJRefresh.h"
#import "TJTopicViewModel.h"
@interface TJSubForumViewController ()<UITableViewDataSource,UITableViewDelegate,TopicHeadNoticeDelegate>
{
    int     requestInt;
}

@property (nonatomic, strong) TJBBSCateSubModel *sForumItem;
@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) UIButton          *btnRefresh;
@property (nonatomic, strong) TJTopicViewModel  *viewModel;

@property (nonatomic, strong) NSArray           *topNoticLists;
@property (nonatomic, strong) NSArray           *tieContentLists;
@end

@implementation TJSubForumViewController

- (instancetype)initWithItem:(TJBBSCateSubModel*)item
{
    self = [super init];
    if (self) {
        [self.view setBackgroundColor:COLOR(231, 232, 237, 1)];
        _sForumItem = [[TJBBSCateSubModel alloc] init];
        self.sForumItem = item;
        _viewModel = [[TJTopicViewModel alloc] init];
        [self bindViewModel];
        requestInt = 0;
    }
    return self;
}

- (void)bindViewModel
{
    _topNoticLists = [[NSArray alloc] init];
    _tieContentLists = [[NSArray alloc] init];
    @weakify(self)
    [[RACObserve(_viewModel, topLists) filter:^BOOL(NSArray *value) {
        return value.count != 0;
    }] subscribeNext:^(NSArray *value) {
        @strongify(self)
        self.topNoticLists = value;
        [self.tableView reloadData];
    }];
    
    [[RACObserve(_viewModel, contentLists) filter:^BOOL(NSArray *value) {
        @strongify(self)
        self.tableView.scrollEnabled = NO;
        return value.count != 0;
    }] subscribeNext:^(NSArray *value) {
        @strongify(self)
        self.tableView.scrollEnabled = YES;
        self.tieContentLists = value;
        [self.tableView reloadData];
    }];
}


- (void)initialNaviBar
{
    [self.naviController setNaviBarTitle:self.sForumItem.name];
    [self.naviController setNaviBarTitleStyle:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],NAVTITLE_COLOR_KEY,[UIFont boldSystemFontOfSize:19.0],NAVTITLE_FONT_KEY,nil]];
    UIButton *leftBtn = [TJBaseNaviBarView createNaviBarBtnByTitle:nil imgNormal:@"navi_back" imgHighlight:nil withFrame:CGRectMake(0, 0, 40,40)];
    [[leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [self.naviController popViewControllerAnimated:YES];
        
    }];
    [self.naviController setNaviBarLeftBtn:leftBtn];
    
    UIButton *rightBtn = [TJBaseNaviBarView createNaviBarBtnByTitle:nil imgNormal:@"fatie_" imgHighlight:nil withFrame:CGRectMake(0, 0, 40, 40)];
    [rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [UserAuthorManager authorizationLogin:self EnterPage:EnterPresentMode_push andSuccess:^{
            
            TJSendTopicalViewController *sendVC = [[TJSendTopicalViewController alloc] initWithItem:_sForumItem];
            [self.naviController pushViewController:sendVC animated:YES];
            
        } andFaile:^{
            
        }];
        
       
        
    }];
    [self.naviController setNaviBarRightBtn:rightBtn];
}

- (void)buildUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setBackgroundColor:COLOR(231, 232, 237, 1)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    @weakify(self)
    [_tableView addHeaderWithCallback:^{
        @strongify(self)
        [self requestData];
    }];
    [self.tableView addFooterWithCallback:^{
        @strongify(self)
        self->requestInt = self->requestInt + 3;
        [self requestTieZiContent];
    }];
    
    
    UIImage *image = [UIImage imageNamed:@"tiezi_refresh_icon"];
    _btnRefresh = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnRefresh setImage:[UIImage imageNamed:@"tiezi_refresh_icon"] forState:UIControlStateNormal];
    [[_btnRefresh rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self requestTieZiContent];
    }];
    [_btnRefresh setFrame:CGRectMake(SCREEN_WIDTH - image.size.width/2 - 20, SCREEN_HEIGHT - TABBAR_HEIGHT - 20 - image.size.height/2,image.size.width/2, image.size.height/2)];
    [self.view addSubview:_btnRefresh];
    
    
}

- (void)requestTieZiContent
{
    @weakify(self)
    [_viewModel postTopicBBSTieBaContent:_sForumItem.subID withPageIndex:requestInt andFinishBlock:^(NSArray *results) {
        @strongify(self)
         [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    } andFaileBlock:^(NSString *error) {
        @strongify(self)
         [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    }];
}

- (void)requestData
{
     @weakify(self)
    [_viewModel postTopicBBSTopTieBa:_sForumItem.subID andFinishBlock:^(NSArray *results) {
        @strongify(self)
        [self.tableView headerEndRefreshing];
    } andFaileBlock:^(NSString *error) {
        @strongify(self)
        [self.tableView headerEndRefreshing];
    }];
    
    [self requestTieZiContent];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initialNaviBar];
    [_tableView headerBeginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return self.topNoticLists.count;
            break;
        case 2:
            return self.tieContentLists.count;
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
            return 120;
            break;
        case 1:
            return 25;
            break;
        case 2:
        {
            TJTieBaContentModel *model = (TJTieBaContentModel *)[self.tieContentLists objectAtIndex:indexPath.row];
            CGSize sizeT = [UIUtil textToSize:model.title fontSize:20];
            CGSize sizeF = [UIUtil textToSize:model.font fontSize:14];
            CGFloat fHeight;
            if (StringEqual(model.imgs, @"")) {
                fHeight = 10;
            }
            else{
                fHeight =  100;
            }
            
            
            return sizeT.height + sizeF.height + 80 + fHeight;
        }
            
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strCell = @"TJTopicHeadViewCell";
    static NSString *strTopCell = @"TJTopNoticeViewCell";
    static NSString *strConCell = @"TJTieBaContentViewCell";
    switch (indexPath.section) {
        case 0:
        {
            TJTopicHeadViewCell *cell = (TJTopicHeadViewCell *)[tableView dequeueReusableCellWithIdentifier:strCell];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:strCell owner:self options:nil] lastObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
            }
            
            [cell bindModel:_sForumItem];
            
            return cell;
        }
            break;
        case 1:
        {
            TJTopNoticeViewCell *cell = (TJTopNoticeViewCell *)[tableView dequeueReusableCellWithIdentifier:strCell];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:strTopCell owner:self options:nil] lastObject];
            }
            
            TJBBSTopTieBaModel *modle = (TJBBSTopTieBaModel *)[_topNoticLists objectAtIndex:indexPath.row];
            [cell bindModel:modle];

            return cell;
        }
            break;
        case 2:
        {
            TJTieBaContentViewCell *cell = (TJTieBaContentViewCell *)[tableView dequeueReusableCellWithIdentifier:strConCell];
            if (!cell) {
                cell = [[TJTieBaContentViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strConCell];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                TJTieBaContentModel *model = (TJTieBaContentModel *)[_tieContentLists objectAtIndex:indexPath.row];
                
                [cell bindModel:model];
            }
            
            
            return cell;

        }
            break;
        default:
            return nil;
            break;
    }
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        
    }
    else if (indexPath.section == 2)
    {
        
    }
}



- (void)tapBoticeEvent:(NSString *)strid
{
    TJNoticeViewController *noticeVC = [[TJNoticeViewController alloc] initWIthID:strid];
    [self.naviController pushViewController:noticeVC animated:YES];
}



@end
