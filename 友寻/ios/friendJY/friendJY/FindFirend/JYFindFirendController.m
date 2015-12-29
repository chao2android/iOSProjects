//
//  JYFindFirendController.m
//  friendJY
//
//  Created by 高斌 on 15/3/11.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYFindFirendController.h"
#import "JYAppDelegate.h"
#import "JYFriendModel.h"
#import "JYHttpServeice.h"
#import "JYCreatGroupFriendModel.h"
#import "ChineseString.h"
#import "JYFindSecondFriendCell.h"
#import "JYOtherProfileController.h"
#import "JYShareData.h"
#import "JYManageFriendData.h"
#import "JYLocationManage.h"
#import "JYAddFriendController.h"
#import "JYFriendFilterView.h"

static NSString *kKVOFilterViewHeight = @"kKVOFilterViewHeight";
//#define kTableViewHeight
@interface JYFindFirendController ()<UITableViewDataSource,UITableViewDelegate,JYFriendFilterViewDelegate>
{

    NSInteger externStatus;


    UIView *haveNoFriendBg;
    //判断是否第一次加载好友
    BOOL isFirstLoading;

}

//显示二度好友
@property (nonatomic, strong) UITableView *tableView;
//显示筛选选项
@property (nonatomic, strong) JYFriendFilterView *friendFilterView;
//存放好友的数组
@property (nonatomic, strong) NSMutableArray *friendList;
//tableview section 的title
@property (nonatomic, strong) NSMutableArray *indexArr;
//筛选按钮
@property (nonatomic, strong) UIButton *siftBtn;

//姓名
@property (nonatomic, strong) NSMutableArray *nameList;
//当前显示的tag
//@property (nonatomic, strong) NSMutableArray *showTagArr;
//tag是否第一次刷新
//@property (nonatomic, assign) BOOL isFirstLayout;

@end

@implementation JYFindFirendController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"发现二度好友"];
        _friendList = [NSMutableArray array];
        _nameList = [NSMutableArray array];
        _indexArr = [NSMutableArray array];
        isFirstLoading = YES;
    }
    
    return self;
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    NSLog(@"%@",[JYShareData sharedInstance].)
    
    [self layoutSubviews];
    [self initHaveNoFriendView];

    //没有好友时不至于感觉屏幕跳一下
    [_tableView setHidden:YES];
    [_friendFilterView setHidden:YES];
    [self setFriendList:[JYManageFriendData sharedInstance].secondFriendList];
    [self handleFriendsList];
    [self loadSecondFriendDataWithDic:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_friendFilterView addObserverFoyKeyBoard];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_friendFilterView removeObserverFoyKeyBoard];
}
- (void)dealloc{
    [_friendFilterView removeObserver:self forKeyPath:@"height"];
}
#pragma mark - layoutsubviews
- (void)initHaveNoFriendView{
    
    haveNoFriendBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight)];
    [haveNoFriendBg setBackgroundColor:[JYHelpers setFontColorWithString:@"#edf1f4"]];
    [self.view addSubview:haveNoFriendBg];
    [self.view bringSubviewToFront:haveNoFriendBg];
    [haveNoFriendBg setHidden:YES];
    
    UILabel *noListLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 87, kScreenWidth - 30, 20*self.autoSizeScaleY)];
    //    [noListLab setNumberOfLines:2];
    [noListLab setTextColor:kTextColorGray];
    [noListLab setTextAlignment:NSTextAlignmentCenter];
    [noListLab setText:@"你还没有好友，是不是有点寂寞呢？"];
    [noListLab setFont:[UIFont systemFontOfSize:15]];
    //    [noListLab setHidden:YES];
    [haveNoFriendBg addSubview:noListLab];
    
    UIButton *addFriendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addFriendBtn setFrame:CGRectMake(15, noListLab.bottom + 75, kScreenWidth - 30, 40)];
    [addFriendBtn setTitle:@"添加好友" forState:UIControlStateNormal];
    [addFriendBtn setBackgroundImage:[UIImage imageNamed:@"login_confirm_btn_available"] forState:UIControlStateNormal];
    [addFriendBtn setBackgroundImage:[UIImage imageNamed:@"login_confirm_btn_unavailable"] forState:UIControlStateDisabled];
    [addFriendBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [addFriendBtn addTarget:self action:@selector(addFriendAction) forControlEvents:UIControlEventTouchUpInside];
    [haveNoFriendBg addSubview:addFriendBtn];
}
//初始化子视图
- (void)layoutSubviews{
    _friendFilterView = [[JYFriendFilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    [self.view addSubview:_friendFilterView];
    [_friendFilterView setFilterDelegate:self];
    
    [_friendFilterView addObserver:self forKeyPath:@"height" options:NSKeyValueObservingOptionNew context:&kKVOFilterViewHeight];
    
    _siftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_siftBtn setFrame:CGRectMake(0, 0, kScreenWidth, 29)];
    [_siftBtn setBackgroundColor:[UIColor whiteColor]];
    [_siftBtn setTitle:@"更多筛选条件" forState:UIControlStateNormal];
    [_siftBtn setTitle:@"收起" forState:UIControlStateSelected];
    [_siftBtn setTitleColor:[JYHelpers setFontColorWithString:@"2695ff"] forState:UIControlStateNormal];
    [_siftBtn setBackgroundImage:[UIImage imageNamed:@"find_clearBg"] forState:UIControlStateNormal];

//    [_siftBtn addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:&kKVOSiftButtonSelected];
    [_siftBtn setHidden:YES];
    [_siftBtn setAdjustsImageWhenHighlighted:NO];
    [_siftBtn setImage:[UIImage imageNamed:@"profile_down_arrow"] forState:UIControlStateNormal];
    [_siftBtn setImage:[UIImage imageNamed:@"profile_up_arrow"] forState:UIControlStateSelected];
//    13 8
//    [_siftBtn.titleLabel setBackgroundColor:[UIColor orangeColor]];
    CGFloat titleWidth = [JYHelpers getTextWidthAndHeight:@"更多筛选条件" fontSize:15].width;
    [_siftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, (kScreenWidth - titleWidth)/2. - 30, 0, (kScreenWidth - titleWidth)/2. + 20)];
    [_siftBtn setImageEdgeInsets:UIEdgeInsetsMake(21./2., (kScreenWidth+titleWidth)/2 - 20, 21./2, (kScreenWidth - titleWidth)/2.)];
    [_siftBtn setBackgroundColor:[JYHelpers setFontColorWithString:@"#edf1f4"]];
    [_siftBtn addTarget:self action:@selector(siftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_siftBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self.view addSubview:_siftBtn];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _siftBtn.bottom, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - _siftBtn.bottom) style:UITableViewStylePlain];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self.view addSubview:_tableView];
    [_tableView setRowHeight:54];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 29)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth - 30, 29)];
    [label setText:@"二度好友推荐(0)"];
    [label setFont:[UIFont systemFontOfSize:15.0f]];
    [label setTag:12306];
    [label setTextColor:[JYHelpers setFontColorWithString:@"#848484"]];
    [headerView addSubview:label];
    
    [_tableView setTableHeaderView:headerView];
    [_tableView setTableFooterView:[[UIView alloc] init]];
    
}

//获取二度好友信息
- (void)loadSecondFriendDataWithDic:(NSDictionary*)statusDic{

    if (statusDic != nil || _friendList.count == 0) {
        [self showProgressHUD:@"加载中，请稍后..." toView:self.view];
    }
    [[JYManageFriendData sharedInstance] loadSecondFriendsWithNums:300 statusDic:statusDic SuccessBlock:^(NSMutableArray *dataArr) {
        [self dismissProgressHUDtoView:self.view];
        [self setFriendList:dataArr];
        [self handleFriendsList];
    } failureBlock:^(NSError *error) {
        [self dismissProgressHUDtoView:self.view];
    }];
    
}
//获取共同好友数量
//- (void)getMutualNums{
//    //用于检测所有所有二度好友的 共同好友数量是否下载成功
//    __block NSInteger finishedCount = 0;
//    for (int i= 0; i < _friendList.count; i++) {
//
//        JYCreatGroupFriendModel *model = [_friendList objectAtIndex:i];
//        //                        friends_get_mutualnums(int this->uid, int this->fuid
//        NSDictionary *paraDict = @{@"mod":@"friends",
//                                   @"func":@"friends_get_mutualnums"};
//        NSDictionary *postDict = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],
//                                   @"fuid":model.friendUid};
//        [JYHttpServeice requestWithParameters:paraDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
//            NSInteger iRetcodet = [[responseObject objectForKey:@"retcode"] integerValue];
//            if (iRetcodet == 1) {
//                finishedCount ++;
//                [model setMutualNums:[responseObject objectForKey:@"data"]];
//                if (finishedCount == _friendList.count) {
//                    [self handleFriendsList];
//                }
////                [_tableView reloadData];
//            }
//
//        } failure:^(id error) {
//            
//        }];
//    }
//}
- (void)handleFriendsList
{
    if (isFirstLoading && _friendList.count == 0) {
        [haveNoFriendBg setHidden:NO];
        [_tableView setHidden:YES];
        [_friendFilterView setHidden:YES];
        return;
    }
    [_siftBtn setHidden:NO];
    [_tableView setHidden:NO];
    [_friendFilterView setHidden:NO];
    [haveNoFriendBg setHidden:YES];
    isFirstLoading = NO;
    //筛选完成之后刷新 好友数量
    UILabel *countLab = (UILabel*)[_tableView.tableHeaderView viewWithTag:12306];
    [countLab setText:[NSString stringWithFormat:@"二度好友推荐（%ld）", (long)_friendList.count]];
//    NSMutableArray *nameList = [NSMutableArray array];
    NSMutableArray *nameArr = [NSMutableArray array];
//    NSLog(@"%@",_friendList)
//    NSLog(@"%@",_friendList)//数据模型NSLog两次就蹦

    for (JYCreatGroupFriendModel *friendModel in _friendList)
    {
        [nameArr addObject:friendModel.nick];
    }
    [self setNameList:nameArr];
    
    [self setIndexArr:[ChineseString indexArray:_nameList]];
    [self setNameList:[ChineseString returnSortChineseArrar:_nameList]];
    [self sortFriendsList];
}

- (void)sortFriendsList
{
    
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    
    NSString *tempStr = @"";
    NSMutableArray *tempList = [[NSMutableArray alloc] init];
    
    for (int i=0; i<_nameList.count; i++) {
        NSString *py = [((ChineseString*)_nameList[i]).pinYin substringToIndex:1];
        NSString *nick = ((ChineseString*)_nameList[i]).string;
        
        if(![tempStr isEqualToString:py]) {
            //不同
            [resultList addObject:tempList];
            
            tempList = [[NSMutableArray alloc] init];
            for (int i=0; i<_friendList.count; i++) {
                
                JYCreatGroupFriendModel *friendModel = _friendList[i];
                if ([[ChineseString RemoveSpecialCharacter:friendModel.nick] isEqualToString:nick])
                {
                    [tempList addObject:friendModel];
                    [_friendList removeObjectAtIndex:i];
                    break;
                }
            }
            
            tempStr = py;
            
        } else {
            
            //相同
            for (int i=0; i<_friendList.count; i++) {
                
                JYCreatGroupFriendModel *friendModel = _friendList[i];
                
                if ([[ChineseString RemoveSpecialCharacter:friendModel.nick] isEqualToString:nick])
                {
                    [tempList addObject:friendModel];
                    [_friendList removeObject:friendModel];
                    break;
                }
            }
            
            
        }
        
    }
    [resultList addObject:tempList];
    
    [resultList removeObjectAtIndex:0];
    
    [self setFriendList:resultList];
    [_tableView reloadData];
    if (_friendList.count > 0) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

//筛选按钮点击事件
- (void)siftBtnAction:(UIButton*)sender{
    
    if (_friendFilterView.status == JYFriendFilterStatusClose) {
        [_friendFilterView setStatus:JYFriendFilterStatusHalf];
    }else if (_friendFilterView.status == JYFriendFilterStatusHalf){
        [_friendFilterView setStatus:JYFriendFilterStatusFullScreen];
    }else{
        [_friendFilterView setStatus:JYFriendFilterStatusClose];
    }
    
    
}

//没有好友时添加好友
- (void)addFriendAction{
    JYAddFriendController *addController = [[JYAddFriendController alloc] init];
    [self.navigationController pushViewController:addController animated:YES];
}
#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    CGFloat height = [[change objectForKey:@"new"] floatValue];
    CGFloat titleWidth;

    if (((JYFriendFilterView*)object).status == JYFriendFilterStatusFullScreen) {
         titleWidth = [JYHelpers getTextWidthAndHeight:@"收起" fontSize:15].width;
        [_siftBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [_siftBtn setSelected:YES];
        
    }else{
        [_siftBtn setSelected:NO];
        titleWidth = [JYHelpers getTextWidthAndHeight:@"更多筛选条件" fontSize:15].width;
        if (((JYFriendFilterView*)object).status == JYFriendFilterStatusClose) {
            [_siftBtn setBackgroundImage:[UIImage imageNamed:@"find_clearBg"] forState:UIControlStateNormal];
        }else{
            [_siftBtn setBackgroundImage:nil forState:UIControlStateNormal];
        }

    }
    
    [_siftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, (kScreenWidth - titleWidth)/2. - 30, 0, (kScreenWidth - titleWidth)/2. + 20)];
    [_siftBtn setImageEdgeInsets:UIEdgeInsetsMake(21./2., (kScreenWidth+titleWidth)/2 - 20, 21./2, (kScreenWidth - titleWidth)/2.)];
    [UIView animateWithDuration:.2 animations:^{
        [_siftBtn setOrigin:CGPointMake(0, height)];
        [_tableView setFrame:CGRectMake(0, _siftBtn.bottom, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - _siftBtn.bottom)];

    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_friendList[section] count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_friendList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    JYFindSecondFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[JYFindSecondFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [cell layoutSubviewsWithModel:[_friendList objectAtIndex:indexPath.section][indexPath.row]];
    return cell;
}
- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return _indexArr;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 29)];
    [header setBackgroundColor:[JYHelpers setFontColorWithString:@"#edf1f4"]];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 40, 29)];
    [lab setBackgroundColor:[UIColor clearColor]];
    [lab setFont:[UIFont systemFontOfSize:17.0f]];
    [lab setTextColor:[JYHelpers setFontColorWithString:@"#303030"]];
    [lab setText:_indexArr[section]];
    [header addSubview:lab];

    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 29;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JYCreatGroupFriendModel *model = [[_friendList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    JYOtherProfileController *profileVC = [[JYOtherProfileController alloc] init];
    profileVC.show_uid = model.friendUid;
    [self.navigationController pushViewController:profileVC animated:YES];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
//    if ([scrollView isEqual:_friendFilterView]) {
//        NSLog(@"滚动scrollView")
//        return;
//    }
    if (_tableView.contentOffset.y > 10) {
        if (_tableView.top != 29) {
            [_friendFilterView setStatus:JYFriendFilterStatusClose];
        }
    }else if(_tableView.contentOffset.y < -10){
        if (_tableView.top == 29) {
            [_friendFilterView setStatus:JYFriendFilterStatusHalf];
        }

    }
}
#pragma mark - JYFriendFilterViewDelegate
- (void)friendFilterView:(JYFriendFilterView *)filterView didFinishedFilterViewFilterResultDict:(NSDictionary *)resultDict{
    [self loadSecondFriendDataWithDic:resultDict];
}

#pragma mark - setter && getter

- (void)setFriendList:(NSMutableArray *)friendList{
    
    [_friendList removeAllObjects];
    _friendList = nil;
    _friendList = [NSMutableArray array];
    [_friendList addObjectsFromArray:friendList];

}
@end







