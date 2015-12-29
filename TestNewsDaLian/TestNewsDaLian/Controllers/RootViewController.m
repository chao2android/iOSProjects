//
//  RootViewController.m
//  TestNewsDaLian
//
//  Created by dxy on 14/12/19.
//  Copyright (c) 2014年 zp. All rights reserved.
//

#import "RootViewController.h"
#import "InstallViewController.h"
#import "NSString+Hashing.h"
#import "RootTableViewCell.h"
#import "TimeTableViewCell.h"
#import "ImageArrayTableViewCell.h"
#import "ImageArrayDetailViewController.h"
#import "ReDianModel.h"
#import "VideoDetailViewController.h"
#import "ArticleDetailViewController.h"

#import "ImageModel.h"
@interface RootViewController ()
{
    UITableView * _tableView;
    NSInteger _buttonTag;
    NSMutableArray * _reDianArray;
    NSMutableArray * _ziXunArray;
    
    UIScrollView *_scrollView;
    UITableView * _reDianTableView;
    UITableView * _ziXunTableView;
    UITableView * _shiJianLianTableView;
    
    MJRefreshHeaderView * _reDianHeaderView;
    MJRefreshHeaderView * _ziXunHeaderView;
    MJRefreshHeaderView * _shijianlianHeaderView;
    
    MJRefreshFooterView * _reDianFooterView;
    MJRefreshFooterView * _ziXunFooterView;
    MJRefreshFooterView * _shijianlianFooterView;
    
    
    NSMutableArray* _shiJianLianArray;
    
    
    BOOL _isNext;//判断时间链的时候到底是要不要在请求一下第二组数据
    
    NSMutableDictionary * _mutableDictionary;//键值对  键是年月日   值是model
    NSMutableArray * _dayNumberArray;//所有从字典里取出来的 key值  放在数组里面
    
    
    
    NSMutableArray * _shijianlianREDIANArray;
    NSMutableArray * _shijianlianZIXUNArray;
    
    
    
    BOOL _isShijianlianFoonterView;//用来标记是不是时间链上拉加载更多
    ReDianModel * _timeModel;//记录最后一条数据的时间戳  下次请求用
    
    
    int _countNumber;//记录上拉的次数
    UIImageView * leftImageView;//左边天气的图片
    UILabel * numLabel;//温度
    
    
    NSString * _redianCtime;
    NSString * _zixunCtime;//用来记录最后一条数据的时间戳
    
    

    NSMutableArray * _moreRedianDayArray;
    NSMutableArray  * _moreZixunDayArray;
    
    
//    BOOL _redianDataIsNull;
//    BOOL _zixunDataIsNull;
    
    
    NSMutableArray  *_lastRedianArray;
    NSMutableArray * _lastZixunArray;
    
}
@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //[self AddRightImageBtn:[UIImage imageNamed:@"shezhi.png"] target:self action:@selector(shezhi)];
    
    //右边的设置位置不好  也重新自定义吧
    // leftImageView.backgroundColor = [UIColor blackColor];
    UIView * rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 50)];
    UIImageView * rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(24, 15, 18, 18)];
    rightImageView.image = [UIImage imageNamed:@"shezhi.png"];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shezhi)];
    rightImageView.userInteractionEnabled = YES;
    [rightView addGestureRecognizer:tap];
    [rightView addSubview:rightImageView];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    //右边天气的图片
    //自定义左上角的温度和天气图片
    UIView * leftBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 50)];
    
    leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 20, 15)];
    leftImageView.image = [UIImage imageNamed:@"47"];
       [leftBgView addSubview:leftImageView];
    
    numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 30,10)];
    numLabel.text = @"0℃";
    numLabel.textColor = [UIColor whiteColor];
    numLabel.font = [UIFont systemFontOfSize:10];
    numLabel.backgroundColor = [UIColor clearColor];
    [leftBgView addSubview:numLabel];
    
    UIBarButtonItem *homeButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBgView];
    self.navigationItem.leftBarButtonItem=homeButtonItem;

    
    //self.mTopImage = [UIImage imageNamed:IOS_7?@"navigation7.png":@"navigation6.png"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation7"] forBarMetrics:UIBarMetricsDefault];
    
    [self getWeather];

}

#pragma mark - 获取天气
- (void)getWeather{
    
    if (_iDownManager) {
        return;
    }
    [self StartLoading];
    _iDownManager = [[ImageDownManager alloc] init];
    _iDownManager.delegate = self;
    _iDownManager.OnImageDown = @selector(getWeatherOnLoadFinish:);
    _iDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *urlstr = @"http://www.weather.com.cn/data/cityinfo/101070201.html";

    [_iDownManager GetImageByStr:urlstr];

}
- (void)getWeatherOnLoadFinish:(ImageDownManager *)sender {
    NSString *newstr = sender.mWebStr;
    
    NSDictionary *dict = [newstr JSONValue];
    NSDictionary * weatherinfoDict = [dict objectForKey:@"weatherinfo"];
    numLabel.text = [weatherinfoDict objectForKey:@"temp1"];

    if ([[weatherinfoDict objectForKey:@"weather"] isEqualToString:@"晴"]) {
        [leftImageView setImage:[UIImage imageNamed:@"1.png"]];
        [leftImageView setFrame:CGRectMake(0, 10, 20, 20)];
        
        
    }else if ([[weatherinfoDict objectForKey:@"weather"] isEqualToString:@"晴转多云"]){
        [leftImageView setImage:[UIImage imageNamed:@"2.png"]];
        [leftImageView setFrame:CGRectMake(0, 10, 20, 15)];
    }
    else{
        [leftImageView setImage:[UIImage imageNamed:@"47.png"]];
        [leftImageView setFrame:CGRectMake(0, 10, 20, 15)];
        
    }

   
}

#pragma mark - 设置上面三个标题的button
- (void)navigationItemTitleButton{
    NSArray * titleNameArray = @[@"热点",@"资讯",@"时间链"];
    for (int i = 0; i < 3; i++) {


        
        UIButton * titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [titleButton setTitle:titleNameArray[i] forState:UIControlStateNormal];
        [titleButton setFrame:CGRectMake(0 + 70 * i , 10, 60, 20)];
        [self.navigationItem.titleView addSubview:titleButton];
        self.navigationItem.titleView.userInteractionEnabled = YES;
        titleButton.tag = 100 + i;
        if (i == _buttonTag ) {
            titleButton.selected = YES;
        }
        
        if (i==2) {
            [titleButton setFrame:CGRectMake(0 + 70 *2 , 10, 70, 20)];
        }
        [titleButton setBackgroundImage:[UIImage imageNamed:@"titleButtonSelect.png"] forState:UIControlStateSelected];
        [titleButton setTitleColor:[UIColor colorWithRed:14/255.0 green:26/255.0 blue:98/255.0 alpha:1] forState:UIControlStateSelected];

        [titleButton addTarget:self action:@selector(selectTitleButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton * moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [moreButton setFrame:CGRectMake(0 + 70 * i , 30, 60, 30)];
        [self.navigationItem.titleView addSubview:moreButton];
        moreButton.tag = 100+ i;
        [moreButton addTarget:self action:@selector(selectTitleButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton * moreButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [moreButton2 setFrame:CGRectMake(0 + 70 * i , 0, 60, 10)];
        [self.navigationItem.titleView addSubview:moreButton2];
        moreButton2.tag = 100+ i;
        [moreButton2 addTarget:self action:@selector(selectTitleButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - 点击三个标题 切换页面
- (void)selectTitleButtonOnClick:(UIButton *)button{
    _buttonTag = button.tag -100;
    for (UIView *subView in self.navigationItem.titleView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *btn1 = (UIButton *)subView;
            if (btn1.tag == button.tag) {
                btn1.selected = YES;
            }else{
                btn1.selected = NO;
            }
        }
    }
    if (button.tag == 100) {//热点
        _scrollView.contentOffset = CGPointMake(0, 0);

        if (_reDianArray.count > 0) {
            
        }else{
        
            [self getReDianAndZiXunWithChannel_id:@"172" ctime:@""];
        }
        
        
        
        
    }else if (button.tag == 101){//获取资讯

        _scrollView.contentOffset = CGPointMake(MainScreenWidth, 0);
        
        if (_ziXunArray.count>0) {
            
        }else{
            [self getReDianAndZiXunWithChannel_id:@"165" ctime:@""];
        }
        
    }else if (button.tag == 102){

        _scrollView.contentOffset = CGPointMake(MainScreenWidth*2, 0);
        
        if (_shiJianLianArray.count>0) {
            
        }else{
            [self getSHIJIANLIANWithChannel_id:@"172" ctime:@""];
        }
        
    }
}


#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView.tag == 1000001) {
        UIButton *reDianBtn = (UIButton *)[self.navigationController.view viewWithTag:100];
        UIButton *ziXunBtn = (UIButton *)[self.navigationController.view viewWithTag:101];
        UIButton * shiJianBtn = (UIButton *)[self.navigationController.view viewWithTag:102];
        
        CGPoint pt = scrollView.contentOffset;
        if (pt.x == 0 && pt.y == 0) {
            _buttonTag =0;
            reDianBtn.selected = YES;
            ziXunBtn.selected = NO;
            shiJianBtn.selected = NO;
            
            if (_reDianArray.count > 0) {
                
            }else{
                
                [self getReDianAndZiXunWithChannel_id:@"172" ctime:@""];
            }

        }else if (pt.y == 0 && pt.x == MainScreenWidth){
            _buttonTag =1;
            reDianBtn.selected = NO;
            ziXunBtn.selected = YES;
            shiJianBtn.selected = NO;

            if (_ziXunArray.count>0) {
                
            }else{
                [self getReDianAndZiXunWithChannel_id:@"165" ctime:@""];
            }

            
        }else if (pt.y == 0 && pt.x == MainScreenWidth*2){
            _buttonTag = 2;
            ziXunBtn.selected = NO;
            shiJianBtn.selected = YES;
            reDianBtn.selected = NO;
            
            if (_shiJianLianArray.count>0) {
                
            }else{
                [self getSHIJIANLIANWithChannel_id:@"172" ctime:@""];
            }
        
            
        }

    }
}


#pragma mark - 右上角的设置按钮
- (void)shezhi{
    InstallViewController * install = [[InstallViewController alloc] init];
    [self.navigationController pushViewController:install animated:YES];
    //开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _reDianArray = [[NSMutableArray alloc] init];
    _ziXunArray = [[NSMutableArray alloc] init];
    _shiJianLianArray = [[NSMutableArray alloc] init];
    _shijianlianREDIANArray = [[NSMutableArray alloc] init];
    _shijianlianZIXUNArray = [[NSMutableArray alloc] init];
    
    _moreRedianDayArray = [[NSMutableArray alloc] init];
    _moreZixunDayArray = [[NSMutableArray alloc] init];
    
    
    _lastRedianArray = [[NSMutableArray alloc] init];
    _lastZixunArray = [[NSMutableArray alloc] init];
    _isNext = YES;
    _isShijianlianFoonterView = NO;
    _countNumber = 0;
    [self uiConfig];
    [self getReDianAndZiXunWithChannel_id:@"172" ctime:@""];
    // Do any additional setup after loading the view.
}

#pragma mark - UI布局
- (void)uiConfig{

    [self navigationItemTitleButton];
    [self creatScrollView];
    [self creatTableView];

}
- (void)creatScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 64)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(3 * MainScreenWidth, MainScreenHeight - 64);
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.delegate = self;
    _scrollView.tag = 1000001;
    [self.view addSubview:_scrollView];
}

#pragma mark - 创建三个tableview
- (void)creatTableView{

    _shiJianLianTableView = [[UITableView alloc]initWithFrame:CGRectMake(MainScreenWidth *2, 0, MainScreenWidth, MainScreenHeight - 64) style:UITableViewStylePlain];
    _shiJianLianTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _shiJianLianTableView.delegate = self;
    _shiJianLianTableView.dataSource  =self;
    [_scrollView addSubview:_shiJianLianTableView];
    
    //下拉刷新
    _shijianlianHeaderView = [[MJRefreshHeaderView alloc] init];
    _shijianlianHeaderView.scrollView = _shiJianLianTableView;
    _shijianlianHeaderView.delegate = self;
    
    //上拉加载更多
    _shijianlianFooterView = [[MJRefreshFooterView alloc] init];
    _shijianlianFooterView.scrollView = _shiJianLianTableView;
    _shijianlianFooterView.delegate = self;
    
    
    //热点
    _reDianTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 64) style:UITableViewStylePlain];
    _reDianTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _reDianTableView.delegate = self;
    _reDianTableView.dataSource  =self;
    [_scrollView addSubview:_reDianTableView];
    
    //下拉刷新
    _reDianHeaderView  = [[MJRefreshHeaderView alloc] init];
    _reDianHeaderView.scrollView = _reDianTableView;
    _reDianHeaderView.delegate = self;
    
    //上拉加载更多
    _reDianFooterView = [MJRefreshFooterView footer];
    _reDianFooterView.scrollView = _reDianTableView;
    [_reDianFooterView setDelegate:self];

    
    //资讯
    _ziXunTableView = [[UITableView alloc]initWithFrame:CGRectMake(MainScreenWidth, 0, MainScreenWidth, MainScreenHeight - 64) style:UITableViewStylePlain];
    _ziXunTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _ziXunTableView.delegate = self;
    _ziXunTableView.dataSource  =self;
    [_scrollView addSubview:_ziXunTableView];
    
    //下拉刷新
    _ziXunHeaderView = [[MJRefreshHeaderView alloc] init];
    _ziXunHeaderView.scrollView = _ziXunTableView;
    _ziXunHeaderView.delegate = self;
    
    //上拉加载更多
    _ziXunFooterView = [MJRefreshFooterView footer];
    _ziXunFooterView.scrollView = _ziXunTableView;
    [_ziXunFooterView setDelegate:self];
    
}


#pragma mark - MJRefresh Delegate 
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH : mm : ss.SSS";
    
    if (refreshView == _reDianHeaderView) {
        _reDianTableView.userInteractionEnabled = NO;
        [_reDianArray removeAllObjects];
        [self getReDianAndZiXunWithChannel_id:@"172" ctime:@""];
        
        [self performSelector:@selector(refreshEnd) withObject:nil afterDelay:1];
    }else if (refreshView == _ziXunHeaderView){
    
        _ziXunTableView.userInteractionEnabled = NO;
        [_ziXunArray removeAllObjects];
        [self getReDianAndZiXunWithChannel_id:@"165" ctime:@""];
        [self performSelector:@selector(refreshEnd) withObject:nil afterDelay:1];
    }else if (refreshView == _shijianlianHeaderView){
        _countNumber = 0;
        _shiJianLianTableView.userInteractionEnabled = NO;
        [_shiJianLianArray removeAllObjects];
        [_shijianlianREDIANArray removeAllObjects];
        [_shijianlianZIXUNArray removeAllObjects];
        _isShijianlianFoonterView = NO;
        [self getSHIJIANLIANWithChannel_id:@"172" ctime:@""];
        [self performSelector:@selector(refreshEnd) withObject:nil afterDelay:1];
    
    }
    
    if (refreshView == _reDianFooterView) {
        
        [_reDianTableView setUserInteractionEnabled:NO];
        ReDianModel * model = [_reDianArray objectAtIndex:_reDianArray.count - 1];
        [self getReDianAndZiXunWithChannel_id:@"172" ctime:model.ctime];
        [self performSelector:@selector(refreshEnd) withObject:nil afterDelay:1];
        
    }else if (refreshView == _ziXunFooterView){
        
        [_ziXunTableView setUserInteractionEnabled: NO];
        ReDianModel * model = [_ziXunArray lastObject];
        [self getReDianAndZiXunWithChannel_id:@"165" ctime:model.ctime];
        [self performSelector:@selector(refreshEnd) withObject:nil afterDelay:1];

    }else if (refreshView == _shijianlianFooterView){
        [_shiJianLianTableView setUserInteractionEnabled:NO];
        
        
        [self getSHIJIANLIANWithChannel_id2:@"172" ctime:_redianCtime];
    
    }
    
}


- (void)refreshEnd{//刷新结束

    if (_buttonTag == 0) {
        [_reDianTableView setUserInteractionEnabled:YES];
        [_ziXunTableView setUserInteractionEnabled:YES];
        _shiJianLianTableView.userInteractionEnabled = YES;

        [_reDianTableView reloadData];
    }else if (_buttonTag == 1){
        [_reDianTableView setUserInteractionEnabled:YES];
        [_ziXunTableView setUserInteractionEnabled:YES];
        _shiJianLianTableView.userInteractionEnabled = YES;
        [_ziXunTableView reloadData];
    }else if (_buttonTag == 2){
        [_reDianTableView setUserInteractionEnabled:YES];
        [_ziXunTableView setUserInteractionEnabled:YES];
        _shiJianLianTableView.userInteractionEnabled = YES;
        [_shiJianLianTableView reloadData];
    }
    
    [_ziXunHeaderView endRefreshing];
    [_reDianHeaderView endRefreshing];
    [_shijianlianHeaderView endRefreshing];
    
    [_ziXunFooterView endRefreshing];
    [_reDianFooterView endRefreshing];
    [_shijianlianFooterView endRefreshing];
}

#pragma mark - UITableView Delegate & UITableView DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView==_shiJianLianTableView) {//如果是时间链的话
        return 78;
    }else if(tableView == _reDianTableView) {
        if (_reDianArray.count>0) {
            ReDianModel * model = [_reDianArray objectAtIndex:indexPath.row];
            if ([model.source_type isEqualToString:@"picture"]) {//假数据  第三行的话  是图集
                return 133;
            }else{
                return 78;
            }
        }
    }else if(tableView == _ziXunTableView){
        if (_ziXunArray.count>0) {
            ReDianModel * model = [_ziXunArray objectAtIndex:indexPath.row];
            if ([model.source_type isEqualToString:@"picture"]) {//假数据  第三行的话  是图集
                return 133;
            }else{
                return 78;
            }
        }
    }
    
    return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
 
    if (tableView == _reDianTableView) {
        return _reDianArray.count;
    }else if(tableView == _ziXunTableView) {
        
        return _ziXunArray.count;
    }else if(tableView == _shiJianLianTableView){

        NSString *year=_dayNumberArray[section];
        NSMutableArray *arr= [_mutableDictionary objectForKey:year];
        return arr.count;
        
    }else{
        return 0;
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _shiJianLianTableView) {//这个时间链的返回的组   是分时间的
        return _dayNumberArray.count;
    }else{
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView==_shiJianLianTableView) {//时间链分组  返回的标题
        for (int  i = 0; i<_dayNumberArray.count; i++) {
            if (section == i) {
                return [_dayNumberArray objectAtIndex:i];
            }
        }
        return nil;
    }else{
        return nil;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _shiJianLianTableView) {
        return 23;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _shiJianLianTableView) {
        UIView *v_headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 23)];//创建一个视图（v_headerView）
        UIImageView *v_headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 23)];//创建一个UIimageView（v_headerImageView）
        [v_headerView addSubview:v_headerImageView];//将v_headerImageView添加到创建的视图（v_headerView）中
        v_headerImageView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        UILabel *v_headerLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, MainScreenWidth, 19)];//创建一个UILable（v_headerLab）用来显示标题
        v_headerLab.backgroundColor = [UIColor clearColor];//设置v_headerLab的背景颜色
        v_headerLab.textAlignment = NSTextAlignmentCenter;
        v_headerLab.textColor = [UIColor colorWithRed:28/255.0 green:92/255.0 blue:183/255.0 alpha:1];//设置v_headerLab的字体颜色
        v_headerLab.font = [UIFont fontWithName:@"Arial" size:13];//设置v_headerLab的字体样式和大小
        v_headerLab.shadowColor = [UIColor whiteColor];//设置v_headerLab的字体的投影
        [v_headerLab setShadowOffset:CGSizeMake(0, 1)];//设置v_headerLab的字体投影的位置
        //设置每组的的标题

        for (int  i = 0; i<_dayNumberArray.count; i++) {
            if (section == i) {
                v_headerLab.text = [_dayNumberArray objectAtIndex:i];
                if ([[[NSString stringWithFormat:@"%@",[NSDate date]] substringToIndex:10] isEqualToString:[[_dayNumberArray objectAtIndex:i] substringToIndex:10]]) {
                    v_headerLab.text = @"今天";
                }
            }
        }
        
        [v_headerView addSubview:v_headerLab];//将标题v_headerLab添加到创建的视图（v_headerView）中
        return v_headerView;//将视图（v_headerView）返回
    }else{
        UIView *v_headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 0)];//创建
        v_headerView.backgroundColor = [UIColor redColor];
        return v_headerView;
    }
}



- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _reDianTableView) {
        if (_reDianArray.count>0) {
            ReDianModel * model = [_reDianArray objectAtIndex:indexPath.row];
            
            if ([model.source_type isEqualToString:@"picture"]) {//假数据  第三行的话  是图集
                static NSString * cellIde = @"imageArray";
                ImageArrayTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
                if (cell==nil) {
                    cell = [[ImageArrayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
                }
                if (indexPath.row%2==0) {//偶数
                    
                    cell.backgroundColor = [UIColor whiteColor];
                }else{
                    cell.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
                }
                
                [cell setUIConfigWithModel:model];
                
                return cell;
            }else{
                static NSString * cellIde = @"cellIde";
                RootTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
                if (cell == nil) {
                    cell = [[RootTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
                }

                if (indexPath.row%2==0) {//偶数
                    cell.backgroundColor = [UIColor whiteColor];
                }else{
                    cell.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
                }
                [cell setUIConfigWithModel:model];
                return cell;
                
            }

        }else{
        
            static NSString * cellIde = @"oushu";
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
            if (cell==nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
            }
            return cell;
        }
        
        
    }else if (tableView == _ziXunTableView){
        if (_ziXunArray.count>0) {
            ReDianModel * model = [_ziXunArray objectAtIndex:indexPath.row];

            
            if ([model.source_type isEqualToString:@"picture"]) {//假数据  第三行的话  是图集
                static NSString * cellIde = @"imageArray";
                ImageArrayTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
                if (cell==nil) {
                    cell = [[ImageArrayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
                }
                if (indexPath.row%2==0) {//偶数
                    
                    cell.backgroundColor = [UIColor whiteColor];
                }else{
                    cell.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
                }
                
                [cell setUIConfigWithModel:model];
                
                return cell;
            }else{
                static NSString * cellIde = @"celltwo";
                RootTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
                if (cell == nil) {
                    cell = [[RootTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
                }
                
                
                
                if (indexPath.row%2==0) {//偶数
                    
                    cell.backgroundColor = [UIColor whiteColor];
                }else{
                    cell.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
                }
                [cell setUIConfigWithModel:model];
                return cell;
                
            }

        }
        else{
            
            static NSString * cellIde = @"oushu2";
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
            if (cell==nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
            }
            return cell;
        }

        
    }else if(tableView == _shiJianLianTableView){
        
        if (_shiJianLianArray.count>0) {
            static NSString * cellIde = @"cellThree";
            TimeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
            if (cell == nil) {
                cell = [[TimeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
            }
            
            if (indexPath.row%2==0) {//偶数
                
                cell.backgroundColor = [UIColor whiteColor];
            }else{
                cell.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
            }
            
            NSString *year=[_dayNumberArray objectAtIndex:indexPath.section];
            NSMutableArray *arr= [_mutableDictionary objectForKey:year];
            
            ReDianModel * model = [arr objectAtIndex:indexPath.row];
            
            [cell setUIConfigWithModel:model];
            
            return cell;
    
        }else{
        
            static NSString * cellIde= @"cellIdesds";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
            }
            return cell;
            
        }
        
    
        }else{
            static NSString * cellIde= @"cellIdeassd";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
            }
            return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_buttonTag == 0) {
        ReDianModel * model = [_reDianArray objectAtIndex:indexPath.row];
        if ([model.source_type isEqualToString:@"picture"]) {//图集
            
            ImageArrayDetailViewController * detail = [[ImageArrayDetailViewController alloc] init];
            detail.model = model;
            detail.source_id = model.source_id;
            detail.titleName = @"热点";
            detail.modalPresentationStyle = UIModalPresentationFullScreen;
            detail.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self.navigationController pushViewController:detail animated:YES];
            //开启iOS7的滑动返回效果
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.delegate = nil;
            }
            
        }else if([model.source_type isEqualToString:@"video"]) {//视频类新闻
            VideoDetailViewController * video = [[VideoDetailViewController alloc] init];
            video.source_id = model.source_id;
            video.titleNameString = @"热点";
            [self.navigationController pushViewController:video animated:YES];
            //开启iOS7的滑动返回效果
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.delegate = nil;
            }

        }else if ([model.source_type isEqualToString:@"article"]){//文章类新闻
            ArticleDetailViewController * atricle = [[ArticleDetailViewController alloc] init];
            atricle.source_id = model.source_id;
            atricle.titleNameString = @"热点";
            [self.navigationController pushViewController:atricle animated:YES];
            //开启iOS7的滑动返回效果
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.delegate = nil;
            }

            
        }
    }else if (_buttonTag == 1){
        ReDianModel * model = [_ziXunArray objectAtIndex:indexPath.row];
        if ([model.source_type isEqualToString:@"picture"]) {
            ImageArrayDetailViewController * detail = [[ImageArrayDetailViewController alloc] init];
            detail.model = model;
            detail.source_id = model.source_id;
            detail.titleName = @"资讯";
            detail.modalPresentationStyle = UIModalPresentationFullScreen;
            detail.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self.navigationController pushViewController:detail animated:YES];
            //开启iOS7的滑动返回效果
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.delegate = nil;
            }

        }else if ([model.source_type isEqualToString:@"video"]){//视频类新闻
            VideoDetailViewController * video = [[VideoDetailViewController alloc] init];
            video.source_id = model.source_id;
            video.titleNameString = @"资讯";
            [self.navigationController pushViewController:video animated:YES];
            //开启iOS7的滑动返回效果
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.delegate = nil;
            }

        }else if ([model.source_type isEqualToString:@"article"]){//文章类新闻
            ArticleDetailViewController * atricle = [[ArticleDetailViewController alloc] init];
            atricle.source_id = model.source_id;
            atricle.titleNameString = @"资讯";
            [self.navigationController pushViewController:atricle animated:YES];
            //开启iOS7的滑动返回效果
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.delegate = nil;
            }

            
        }
    }else if (_buttonTag == 2){
        
        NSString *year=_dayNumberArray[indexPath.section];
        NSMutableArray *arr= [_mutableDictionary objectForKey:year];
        
        ReDianModel * model = [arr objectAtIndex:indexPath.row];
        
        
        
        if ([model.source_type isEqualToString:@"picture"]) {
            ImageArrayDetailViewController * detail = [[ImageArrayDetailViewController alloc] init];
            detail.model = model;
            detail.source_id = model.source_id;
            detail.titleName = @"时间戳";
            detail.modalPresentationStyle = UIModalPresentationFullScreen;
            detail.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self.navigationController pushViewController:detail animated:YES];
            //开启iOS7的滑动返回效果
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.delegate = nil;
            }
            

            
        }else if ([model.source_type isEqualToString:@"video"]){//视频类新闻
            VideoDetailViewController * video = [[VideoDetailViewController alloc] init];
            video.source_id = model.source_id;
            video.titleNameString = @"时间链";
            [self.navigationController pushViewController:video animated:YES];
            //开启iOS7的滑动返回效果
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.delegate = nil;
            }
            
        }else if ([model.source_type isEqualToString:@"article"]){//文章类新闻
            ArticleDetailViewController * atricle = [[ArticleDetailViewController alloc] init];
            atricle.source_id = model.source_id;
            atricle.titleNameString = @"时间链";
            [self.navigationController pushViewController:atricle animated:YES];
            //开启iOS7的滑动返回效果
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.delegate = nil;
            }
            
            
        }

        
    }

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - 获取频道的ID
- (void)getReDianAndZiXunWithChannel_id:(NSString *)channel_id ctime: (NSString *)ctime{
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    self.mDownManager = [[ASIDownManager alloc] init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString * str = @"http://vnews.cdv.com/app/?app=newsapp&controller=iosapi&action=sourceList";
    
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:

                          @"12345",@"SeqNo",
                          kSource,@"Source",
                          kUUID,@"TerminalSN",
                          kTimeSp,@"TimeStamp",
                          channel_id,@"channel_id",
                          @"UP",@"page",
                          @"8",@"limit",
                          ctime,@"ctime",
                          nil];
    
    [_mDownManager PostHttpRequest:str :dic :nil :nil];

}
- (void)OnLoadFinish:(ImageDownManager *)sender {
    
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (_buttonTag == 0) {//热点
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            NSArray * array = [dict objectForKey:@"data"];
            for (NSDictionary * listDict in array) {
                
                ReDianModel * model = [[ReDianModel alloc] init];
                [model setValuesForKeysWithDictionary:listDict];
                [_reDianArray addObject:model];
                
                
            }
            
            
            
        }
        [_reDianTableView reloadData];

    }else if (_buttonTag == 1){//资讯
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            NSArray * array = [dict objectForKey:@"data"];
            for (NSDictionary * listDict in array) {
                
                ReDianModel * model = [[ReDianModel alloc] init];
                [model setValuesForKeysWithDictionary:listDict];
                [_ziXunArray addObject:model];
            }
        }
        [_ziXunTableView reloadData];
    }else if (_buttonTag == 2){//时间链

    }

}

- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}

- (void)dealloc {
    [_reDianHeaderView free];
    [_ziXunHeaderView free];
    [self Cancel];
}

- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}



//获取时间链的热点
- (void)getSHIJIANLIANWithChannel_id:(NSString *)channel_id ctime: (NSString *)ctime{
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    self.mDownManager = [[ASIDownManager alloc] init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(getShijianlianOnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString * str = @"http://vnews.cdv.com/app/?app=newsapp&controller=iosapi&action=sourceList";
    
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                          
                          @"12345",@"SeqNo",
                          kSource,@"Source",
                          kUUID,@"TerminalSN",
                          kTimeSp,@"TimeStamp",
                          channel_id,@"channel_id",
                          @"UP",@"page",
                          @"8",@"limit",
                          ctime,@"ctime",
                          nil];
    
    [_mDownManager PostHttpRequest:str :dic :nil :nil];
    
}

- (void)getShijianlianOnLoadFinish:(ImageDownManager *)sender {
    
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSArray * array = [dict objectForKey:@"data"];
        

        for (NSDictionary * listDict in array) {
            ReDianModel * model = [[ReDianModel alloc] init];
            [model setValuesForKeysWithDictionary:listDict];
            if(![_shijianlianREDIANArray containsObject:model])
            {
                [_shijianlianREDIANArray addObject:model];
            }
            
        }
    }
    

    
    ReDianModel * lastModel  = [_shijianlianREDIANArray objectAtIndex:_shijianlianREDIANArray.count - 1];
    if (_shijianlianREDIANArray.count > 8) {//如果大于8   就不是第一调用  比较
        
        ReDianModel * lastTwoMdoel = [_shijianlianREDIANArray objectAtIndex:_shijianlianREDIANArray.count - 9];//倒数第二组的最后一个model
        
        if ([[DxyCustom getYearMonthDay:lastModel.ctime] isEqualToString:[DxyCustom getYearMonthDay:lastTwoMdoel.ctime]]) {//所有的热点的最后一个数据和倒数第二组的最后一个数   是否取得了某一天的全部热点数据
        
            //相等的话   接着调用热点的数据  获取同一天的
            [self getSHIJIANLIANWithChannel_id:@"172" ctime:lastModel.ctime];
            
        }else{
            int index = 0;//标记的是不一样的那个数据的数组小标
            //不相等的话  就把本次请求的数据  不跟上一次请求最后一条数据一样的删除
            for (int i = (int) _shijianlianREDIANArray.count -8; i < _shijianlianREDIANArray.count ; i++) {
                ReDianModel * comMdoel = [_shijianlianREDIANArray objectAtIndex:i];//用来比较跟倒数第二个model的时间长是不是一样的
                if (![[DxyCustom getYearMonthDay:lastTwoMdoel.ctime] isEqualToString:[DxyCustom getYearMonthDay:comMdoel.ctime]]) {
                    //[_shijianlianREDIANArray removeObject:comMdoel];//如果不一样的话 就把他删除
                    
                    index = i;
                    break;
                }
                
            }
            
            
            NSMutableArray * tempArray = [[NSMutableArray alloc]init];
            for (int i = 0; i<_shijianlianREDIANArray.count; i++) {
                
                if (i < index) {
                    [tempArray addObject:_shijianlianREDIANArray[i]];
                }
            }
            
            
            [_shijianlianREDIANArray removeAllObjects];
            _shijianlianREDIANArray = [[NSMutableArray alloc] initWithArray:tempArray];
            

            //不相等的话  就去调资讯
            [self getSHIJIANLIANWithZIXUNChannel_id:@"165" ctime:@""];
            
        }
        
    }else{//不大于8
        [self getSHIJIANLIANWithChannel_id:@"172" ctime:lastModel.ctime];
        
        //[_shijianlianREDIANArray removeObjectAtIndex:0];
    }
}

- (void)getSHIJIANLIANWithZIXUNChannel_id:(NSString *)channel_id ctime: (NSString *)ctime{
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    self.mDownManager = [[ASIDownManager alloc] init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(getShijianlianZixunOnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString * str = @"http://vnews.cdv.com/app/?app=newsapp&controller=iosapi&action=sourceList";
    
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                          
                          @"12345",@"SeqNo",
                          kSource,@"Source",
                          kUUID,@"TerminalSN",
                          kTimeSp,@"TimeStamp",
                          channel_id,@"channel_id",
                          @"UP",@"page",
                          @"8",@"limit",
                          ctime,@"ctime",
                          nil];
    
    [_mDownManager PostHttpRequest:str :dic :nil :nil];
    
}

- (void)getShijianlianZixunOnLoadFinish:(ImageDownManager *)sender {
    
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSArray * array = [dict objectForKey:@"data"];
        
        for (NSDictionary * listDict in array) {
            ReDianModel * model = [[ReDianModel alloc] init];
            [model setValuesForKeysWithDictionary:listDict];
            
            if(![_shijianlianZIXUNArray containsObject:model])
            {
                [_shijianlianZIXUNArray addObject:model];
            }

        }
    }
    
    
    
    
    ReDianModel * lastModel  = [_shijianlianZIXUNArray objectAtIndex:_shijianlianZIXUNArray.count - 1];
    if (_shijianlianZIXUNArray.count > 8) {//如果大于8   就不是第一调用  比较
        
        ReDianModel * lastTwoMdoel = [_shijianlianZIXUNArray objectAtIndex:_shijianlianZIXUNArray.count - 9];//倒数第二组的最后一个model
        
        
        if ([[DxyCustom getYearMonthDay:lastModel.ctime] isEqualToString:[DxyCustom getYearMonthDay:lastTwoMdoel.ctime]]) {//所有的热点的最后一个数据和倒数第二组的最后一个数   是否取得了某一天的全部热点数据
            
            //相等的话   接着调用资讯的数据  获取同一天的
            //[self getSHIJIANLIANWithChannel_id:@"165" ctime:lastModel.ctime];
            [self getSHIJIANLIANWithZIXUNChannel_id:@"165" ctime:lastModel.ctime];
            
        }else{
            int index = 0;//标记的是不一样的那个数据的数组小标
            //不相等的话  就把本次请求的数据  不跟上一次请求最后一条数据一样的删除
            for (int i = (int) _shijianlianZIXUNArray.count -8; i < _shijianlianZIXUNArray.count ; i++) {
                ReDianModel * comMdoel = [_shijianlianZIXUNArray objectAtIndex:i];//用来比较跟倒数第二个model的时间长是不是一样的
                if (![[DxyCustom getYearMonthDay:lastTwoMdoel.ctime] isEqualToString:[DxyCustom getYearMonthDay:comMdoel.ctime]]) {
                    //[_shijianlianREDIANArray removeObject:comMdoel];//如果不一样的话 就把他删除
                    
                    index = i;
                    break;
                }
                
            }
            
            
            NSMutableArray * tempArray = [[NSMutableArray alloc]init];
            for (int i = 0; i<_shijianlianZIXUNArray.count; i++) {
                
                if (i < index) {
                    [tempArray addObject:_shijianlianZIXUNArray[i]];
                }
            }
            
            
            [_shijianlianZIXUNArray removeAllObjects];
            _shijianlianZIXUNArray = [[NSMutableArray alloc] initWithArray:tempArray];
            [self saveDataToShijianLian];

        }
        
    }else{//不大于8
        [self getSHIJIANLIANWithZIXUNChannel_id:@"165" ctime:lastModel.ctime];

    }

    
    //[self savaDataToShijianLianArray];
}

- (void)saveDataToShijianLian{

    for ( int i = 0; i <_shijianlianREDIANArray.count ; i++) {
        [_shiJianLianArray addObject: [_shijianlianREDIANArray objectAtIndex:i]];
    }
    
    for (int i =0; i<_shijianlianZIXUNArray.count; i++) {
        [_shiJianLianArray addObject:[_shijianlianZIXUNArray objectAtIndex:i]];
    }

    
    //排序
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:_shiJianLianArray];
    if (array.count != 0) {
        for (int i = 0; i < array.count - 1; i++) {
            for (int j = 0; j < array.count - i - 1; j++) {
                ReDianModel *m1 = [array objectAtIndex:j];
                ReDianModel *m2 = [array objectAtIndex:j + 1];
               
                NSInteger ts1 = [m1.ctime integerValue];
                NSInteger ts2 = [m2.ctime integerValue];
                if (ts1 < ts2) {
                    [array exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                }
            }
        }
        
    }
    
    _shiJianLianArray = nil;
    _shiJianLianArray = array;

    
    for (int i =0 ; i <_shiJianLianArray.count; i++) {
        ReDianModel * model = [_shiJianLianArray objectAtIndex:i];
    }

    
    [self getYearArray];

}



- (NSArray *)getYearArray{
    
    
    
    
    _mutableDictionary = [[NSMutableDictionary alloc] init];
    _dayNumberArray = [[NSMutableArray alloc] init];
    ReDianModel * model = nil;
    NSString * yearString=nil;
    if(_shiJianLianArray.count>0)
    {
        model=_shiJianLianArray[0];
        yearString = [[DxyCustom getTimeWithTimeSp:model.ctime ]substringToIndex:10];
    }
    
    if (yearString.length>0) {
        [_dayNumberArray addObject:yearString];
    }
    
    for (int i = 0; i < _shiJianLianArray.count; i++) {
        model = [_shiJianLianArray objectAtIndex:i];
        //NSString *tempyear=[model.ctime substringToIndex:10];
        NSString * tempyear = [[DxyCustom getTimeWithTimeSp:model.ctime ]substringToIndex:10];
        if(![_dayNumberArray containsObject:tempyear])
        {
            [_dayNumberArray addObject:tempyear];//填充不重复日期
        }
    }
    //拼凑字典
    for(int j=0;j<_dayNumberArray.count;j++)
    {
        for (int i = 0; i < _shiJianLianArray.count; i++) {
            NSString *year=_dayNumberArray[j];
            model = [_shiJianLianArray objectAtIndex:i];
            NSString * tempyear = [[DxyCustom getTimeWithTimeSp:model.ctime ]substringToIndex:10];
            if([tempyear isEqualToString:year]){
                NSMutableArray * arr= [_mutableDictionary objectForKey:year];
                if(arr==nil){
                    arr=[NSMutableArray new];
                    [arr addObject:model];
                }
                else
                {
                    arr=[NSMutableArray arrayWithArray:arr];
                    [arr addObject:model];
                }
                [_mutableDictionary setObject:arr forKey:tempyear];
            }
        }
    }
    
    
    
    

    
    NSMutableArray * tempArray = [[NSMutableArray alloc] init];
    int tempI = 0 ;
    for ( int i  = 0; i<_dayNumberArray.count; i++) {//计算取多少个数据
        [_dayNumberArray objectAtIndex:i];

        NSArray * everyDayArray = [_mutableDictionary objectForKey:[_dayNumberArray objectAtIndex:i]];
        for (int j = 0; j <everyDayArray.count; j++) {
            [tempArray addObject:[everyDayArray objectAtIndex:j]];
            
        }
        if (tempArray.count >= 8) {
            tempI = i ;

            break;
        }
        
    }
    
    NSMutableArray * dayArray = [[NSMutableArray alloc] init];
    NSMutableDictionary * mutableDict = [[NSMutableDictionary alloc] init];
    for (int i = 0; i <= tempI; i++) {
        [dayArray addObject:[_dayNumberArray objectAtIndex:i]];
        
        [mutableDict setObject:[_mutableDictionary objectForKey:[_dayNumberArray objectAtIndex:i]] forKey:[_dayNumberArray objectAtIndex:i]];
        
        
    }
    
    [_dayNumberArray removeAllObjects];
    [_mutableDictionary removeAllObjects];
    
    
    _dayNumberArray = [[NSMutableArray alloc] initWithArray:dayArray];
    _mutableDictionary = [[NSMutableDictionary alloc] initWithDictionary:mutableDict];
    
    ReDianModel * tempModel = [[_mutableDictionary objectForKey:[_dayNumberArray lastObject]] lastObject];
    NSString * tempCtime = tempModel.ctime;//标记的时间戳  显示在tableView上的最后一条
    
    
    for ( int  i = 0; i <_shijianlianREDIANArray.count; i++) {
        ReDianModel * everyMdoel = [_shijianlianREDIANArray objectAtIndex:i];

        if ([everyMdoel.ctime doubleValue] <= [tempCtime doubleValue]) {
            if ([tempCtime doubleValue] == [everyMdoel.ctime doubleValue]) {
                _redianCtime = tempCtime;
                break;
            }else {
            
                if (i == 0) {
                    _redianCtime = everyMdoel.ctime;
                    break;
                }else{
                    ReDianModel * everyMdoel2 = [_shijianlianREDIANArray objectAtIndex:i - 1];
                    _redianCtime = everyMdoel2.ctime;
                    break;
                }
            
            }
        }

    }
    
    
    
    for ( int  i = 0; i <_shijianlianZIXUNArray.count; i++) {
        ReDianModel * everyMdoel = [_shijianlianZIXUNArray objectAtIndex:i];
        
        if ([everyMdoel.ctime doubleValue] <= [tempCtime doubleValue]) {//最后一个数据的时间戳小于时间链里面的数据
            if ([tempCtime doubleValue] == [everyMdoel.ctime doubleValue]) {
                _zixunCtime = tempCtime;
                break;
            }else {
                
                if (i == 0) {
                    _zixunCtime = everyMdoel.ctime;
                    break;
                }else{
                    ReDianModel * everyMdoel2 = [_shijianlianZIXUNArray objectAtIndex:i - 1];
                    _zixunCtime = everyMdoel2.ctime;
                    break;
                }
                
            }
        }
        
    }

    [self refreshEnd];
    [_shiJianLianTableView reloadData];
    return nil;
}








////////////////////以上都是刷新重新获取数据的    下面的都是上拉加载更多的///////////////////////////////
//获取时间链的热点
- (void)getSHIJIANLIANWithChannel_id2:(NSString *)channel_id ctime: (NSString *)ctime{
    
    [_moreRedianDayArray removeAllObjects];
    [_moreZixunDayArray removeAllObjects];
    
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    self.mDownManager = [[ASIDownManager alloc] init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(getShijianlianOnLoadFinish2:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString * str = @"http://vnews.cdv.com/app/?app=newsapp&controller=iosapi&action=sourceList";
    
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                          
                          @"12345",@"SeqNo",
                          kSource,@"Source",
                          kUUID,@"TerminalSN",
                          kTimeSp,@"TimeStamp",
                          channel_id,@"channel_id",
                          @"UP",@"page",
                          @"8",@"limit",
                          ctime,@"ctime",
                          nil];
    
    [_mDownManager PostHttpRequest:str :dic :nil :nil];
    
}

- (void)getShijianlianOnLoadFinish2:(ImageDownManager *)sender {
    
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    NSArray * array = nil;
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        array = [dict objectForKey:@"data"];
        NSLog(@"上拉热点返回数据%@",array);

        for (NSDictionary * listDict in array) {
            ReDianModel * model = [[ReDianModel alloc] init];
            [model setValuesForKeysWithDictionary:listDict];

            [_moreRedianDayArray addObject:model];
            
            
        }
    }
    
    if (array.count ==0) {
        [self getSHIJIANLIANWithZIXUNChannel_id2:@"165" ctime:_zixunCtime];
    }else{
        ReDianModel * lastModel  = [_moreRedianDayArray lastObject];
        
        
        if (_moreRedianDayArray.count>0) {
            ReDianModel * oneMdoel = [_moreRedianDayArray firstObject];//第一个
            if ([[DxyCustom getYearMonthDay:lastModel.ctime] isEqualToString:[DxyCustom getYearMonthDay:oneMdoel.ctime]]) {//所有的热点的最后一个数据和倒数第二组的最后一个数   是否取得了某一天的全部热点数据
                
                //相等的话   接着调用热点的数据  获取同一天的
                
                if (array.count == 8) {
                    ReDianModel * lastmodelTemp =[_moreRedianDayArray lastObject];
                    _redianCtime  = lastmodelTemp.ctime;
                    
                    
                    [self getSHIJIANLIANWithChannel_id2:@"172" ctime:_redianCtime];
                    
                }else{
                    //_redianDataIsNull = YES;
                    int index = 0;//标记的是不一样的那个数据的数组小标
                    //不相等的话  就把本次请求的数据  不跟上一次请求最后一条数据一样的删除
                    for (int i =0 ; i < _moreRedianDayArray.count ; i++) {
                        ReDianModel * comMdoel = [_moreRedianDayArray objectAtIndex:i];//用来比较跟倒数第二个model的时间长是不是一样的
                        if (![[DxyCustom getYearMonthDay:oneMdoel.ctime] isEqualToString:[DxyCustom getYearMonthDay:comMdoel.ctime]]) {
                            
                            index = i;
                            break;
                        }
                        
                        
                        if (i==_moreRedianDayArray.count-1) {
                            index = i;
                        }
                        
                    }
                    
                    
                    NSMutableArray * tempArray = [[NSMutableArray alloc]init];
                    for (int i = 0; i<_moreRedianDayArray.count; i++) {
                        
                        if (i <= index) {
                            if (![tempArray containsObject:_moreRedianDayArray]) {
                                [tempArray addObject:_moreRedianDayArray[i]];
                            }
                            
                        }
                    }
                    
                    
                    [_moreRedianDayArray removeAllObjects];
                    _moreRedianDayArray = [[NSMutableArray alloc] initWithArray:tempArray];
                    _lastRedianArray = [[NSMutableArray alloc] initWithArray:tempArray];
                    
                    //不相等的话  就去调资讯
                        [self getSHIJIANLIANWithZIXUNChannel_id2:@"165" ctime:_zixunCtime];
                   
                   
                    
                    
                    
                    
                }
                
                
                
            }else{
                int index = 0;//标记的是不一样的那个数据的数组小标
                //不相等的话  就把本次请求的数据  不跟上一次请求最后一条数据一样的删除
                for (int i =0 ; i < _moreRedianDayArray.count ; i++) {
                    ReDianModel * comMdoel = [_moreRedianDayArray objectAtIndex:i];//用来比较跟倒数第二个model的时间长是不是一样的
                    if (![[DxyCustom getYearMonthDay:oneMdoel.ctime] isEqualToString:[DxyCustom getYearMonthDay:comMdoel.ctime]]) {
                        
                        index = i;
                        break;
                    }
                    
                }
                
                
                NSMutableArray * tempArray = [[NSMutableArray alloc]init];
                for (int i = 0; i<_moreRedianDayArray.count; i++) {
                    
                    if (i < index) {
                        if (![tempArray containsObject:_moreRedianDayArray]) {
                            [tempArray addObject:_moreRedianDayArray[i]];
                        }
                        
                    }
                }
                
                
                [_moreRedianDayArray removeAllObjects];
                _moreRedianDayArray = [[NSMutableArray alloc] initWithArray:tempArray];
                
                
                //不相等的话  就去调资讯
                    [self getSHIJIANLIANWithZIXUNChannel_id2:@"165" ctime:_zixunCtime];
                    NSLog(@"死循环了吗？？？？？？？");
                
                
            }
            
        }else{
            //不相等的话  就去调资讯
           
                [self getSHIJIANLIANWithZIXUNChannel_id2:@"165" ctime:_zixunCtime];
           
            
        }

    }
    
   
    
}

- (void)getSHIJIANLIANWithZIXUNChannel_id2:(NSString *)channel_id ctime: (NSString *)ctime{
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    self.mDownManager = [[ASIDownManager alloc] init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(getShijianlianZixunOnLoadFinish2:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString * str = @"http://vnews.cdv.com/app/?app=newsapp&controller=iosapi&action=sourceList";
    
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                          
                          @"12345",@"SeqNo",
                          kSource,@"Source",
                          kUUID,@"TerminalSN",
                          kTimeSp,@"TimeStamp",
                          channel_id,@"channel_id",
                          @"UP",@"page",
                          @"8",@"limit",
                          ctime,@"ctime",
                          nil];
    
    [_mDownManager PostHttpRequest:str :dic :nil :nil];
    
}

- (void)getShijianlianZixunOnLoadFinish2:(ImageDownManager *)sender {
    
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    NSArray * array ;
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
       array = [dict objectForKey:@"data"];
        NSLog(@"上拉资讯返回的数据%@",array);
        
        for (NSDictionary * listDict in array) {
            ReDianModel * model = [[ReDianModel alloc] init];
            [model setValuesForKeysWithDictionary:listDict];
            
            [_moreZixunDayArray addObject:model];
            
        }
    }
    
    if (array.count == 0) {
        [self saveDataToShijianLian2];
    }else{
    
        
        if (_moreZixunDayArray.count > 0) {
            ReDianModel * lastModel  = [_moreZixunDayArray lastObject];
            ReDianModel * oneModel = [_moreZixunDayArray objectAtIndex:0];//倒数第二组的最后一个model
            
            
            
            if ([[DxyCustom getYearMonthDay:lastModel.ctime] isEqualToString:[DxyCustom getYearMonthDay:oneModel.ctime]]) {//所有的热点的最后一个数据和倒数第二组的最后一个数   是否取得了某一天的全部热点数据
                
                //相等的话   接着调用资讯的数据  获取同一天的
                
                if (array.count == 8) {
                    
                    ReDianModel * lastModelTemp = [_moreZixunDayArray lastObject];
                    _zixunCtime = lastModelTemp.ctime;
                    
                    /// [self getSHIJIANLIANWithChannel_id2:@"165" ctime:_zixunCtime];
                    [self getSHIJIANLIANWithZIXUNChannel_id2:@"165" ctime:_zixunCtime];
                    NSLog(@"11111111111111111111111111111");
                }else{
                    int index = 0;//标记的是不一样的那个数据的数组小标
                    //不相等的话  就把本次请求的数据  不跟上一次请求最后一条数据一样的删除
                    for (int i =0 ; i < _moreZixunDayArray.count ; i++) {
                        ReDianModel * comMdoel = [_moreZixunDayArray objectAtIndex:i];//用来比较跟倒数第二个model的时间长是不是一样的
                        if (![[DxyCustom getYearMonthDay:oneModel.ctime] isEqualToString:[DxyCustom getYearMonthDay:comMdoel.ctime]]) {
                            
                            index = i;
                            break;
                        }
                        
                        
                        if (i==_moreZixunDayArray.count-1) {
                            index = i;
                        }
                        
                    }
                    
                    
                    NSMutableArray * tempArray = [[NSMutableArray alloc]init];
                    for (int i = 0; i<_moreZixunDayArray.count; i++) {
                        
                        if (i <= index) {
                            if (![tempArray containsObject:_moreZixunDayArray]) {
                                [tempArray addObject:_moreZixunDayArray[i]];
                            }
                            
                        }
                    }
                    
                    
                    [_moreZixunDayArray removeAllObjects];
                    _moreZixunDayArray = [[NSMutableArray alloc] initWithArray:tempArray];
                    _lastZixunArray = [[NSMutableArray alloc] initWithArray:tempArray];
                    [self saveDataToShijianLian2];
                    
                }
                
                
                
            }else{
                int index = 0;//标记的是不一样的那个数据的数组小标
                //不相等的话  就把本次请求的数据  不跟上一次请求最后一条数据一样的删除
                for (int i = 0 ; i < _moreZixunDayArray.count ; i++) {
                    ReDianModel * comMdoel = [_moreZixunDayArray objectAtIndex:i];//用来比较跟倒数第二个model的时间长是不是一样的
                    if (![[DxyCustom getYearMonthDay:oneModel.ctime] isEqualToString:[DxyCustom getYearMonthDay:comMdoel.ctime]]) {
                        
                        index = i;
                        break;
                    }
                    
                }
                
                
                NSMutableArray * tempArray = [[NSMutableArray alloc]init];
                for (int i = 0; i<_moreZixunDayArray.count; i++) {
                    
                    if (i < index) {
                        if (![tempArray containsObject:_moreZixunDayArray]) {
                            [tempArray addObject:_moreZixunDayArray[i]];
                        }
                        
                    }
                }
                
                
                [_moreZixunDayArray removeAllObjects];
                _moreZixunDayArray = [[NSMutableArray alloc] initWithArray:tempArray];
                NSLog(@"调整合数据的");
                [self saveDataToShijianLian2];
                
            }
            
        }else{
            [self saveDataToShijianLian2];
        }
        
        

    }
    
}



- (void)saveDataToShijianLian2{
    [self refreshEnd];

    if (!(_moreRedianDayArray.count >0 && _moreZixunDayArray.count>0)) {
        
        
        
        if (_moreRedianDayArray.count>0) {
            ReDianModel * redianModel = [_moreRedianDayArray firstObject];
            
            
            NSMutableArray * tempArray = [[NSMutableArray alloc] initWithArray:_moreRedianDayArray];
            
            [_dayNumberArray addObject:[DxyCustom getYearMonthDay:redianModel.ctime]];
            [_mutableDictionary setObject:tempArray forKey:[DxyCustom getYearMonthDay:redianModel.ctime]];
            ReDianModel * modelll = [_moreRedianDayArray lastObject];
            _redianCtime = modelll.ctime;
            [_shiJianLianTableView reloadData];
            return;
          
        }
        
        
        if (_moreZixunDayArray.count>0) {
            ReDianModel * zixunModel = [_moreZixunDayArray firstObject];
            
            
            NSMutableArray * tempArray = [[NSMutableArray alloc] initWithArray:_moreZixunDayArray];
            
            [_dayNumberArray addObject:[DxyCustom getYearMonthDay:zixunModel.ctime]];
            [_mutableDictionary setObject:tempArray forKey:[DxyCustom getYearMonthDay:zixunModel.ctime]];
            ReDianModel * modelll = [_moreZixunDayArray lastObject];
            _zixunCtime = modelll.ctime;
            
            
            [_shiJianLianTableView reloadData];
            return;
            
        }

        NSLog(@"没有整合数据");
        
    }else{
    
    
    ReDianModel * redianModel = [_moreRedianDayArray firstObject];
    ReDianModel * zixunModel = [_moreZixunDayArray firstObject];
    
    
    if ([[DxyCustom getYearMonthDay:redianModel.ctime] compare:[DxyCustom getYearMonthDay:zixunModel.ctime] options:NSNumericSearch] == NSOrderedDescending) {//降序的话
        
        //热点大   取热点
        
        NSMutableArray * tempArray = [[NSMutableArray alloc] initWithArray:_moreRedianDayArray];
        
        [_dayNumberArray addObject:[DxyCustom getYearMonthDay:redianModel.ctime]];
        [_mutableDictionary setObject:tempArray forKey:[DxyCustom getYearMonthDay:redianModel.ctime]];
        ReDianModel * modelll = [_moreRedianDayArray lastObject];
        _redianCtime = modelll.ctime;
        
        NSLog(@"降序");
        [_shiJianLianTableView reloadData];
        
        
    }else if ([[DxyCustom getYearMonthDay:redianModel.ctime] compare:[DxyCustom getYearMonthDay:zixunModel.ctime] options:NSNumericSearch] == NSOrderedAscending){
        //升序 就是资讯大
        
        NSMutableArray * tempArray = [[NSMutableArray alloc] initWithArray:_moreZixunDayArray];
        
        [_dayNumberArray addObject:[DxyCustom getYearMonthDay:zixunModel.ctime]];
        [_mutableDictionary setObject:tempArray forKey:[DxyCustom getYearMonthDay:zixunModel.ctime]];
        ReDianModel * modell = [_moreZixunDayArray lastObject];
        _zixunCtime = modell.ctime;
        NSLog(@"升序");
        [_shiJianLianTableView reloadData];
        
    }else{
        [_shiJianLianArray removeAllObjects];
        
        
        ReDianModel * modell = [_moreZixunDayArray lastObject];
        _zixunCtime = modell.ctime;
        
        
        ReDianModel * modelll = [_moreRedianDayArray lastObject];
        _redianCtime = modelll.ctime;
        NSLog(@"相等");
        
        //相等
        for ( int i = 0; i <_moreRedianDayArray.count ; i++) {
            [_shiJianLianArray addObject: [_moreRedianDayArray objectAtIndex:i]];
        }
        
        for (int i =0; i<_moreZixunDayArray.count; i++) {
            [_shiJianLianArray addObject:[_moreZixunDayArray objectAtIndex:i]];
        }
        
        
        //排序
        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:_shiJianLianArray];
        if (array.count != 0) {
            for (int i = 0; i < array.count - 1; i++) {
                for (int j = 0; j < array.count - i - 1; j++) {
                    ReDianModel *m1 = [array objectAtIndex:j];
                    ReDianModel *m2 = [array objectAtIndex:j + 1];
                    

                    NSInteger ts1 = [m1.ctime integerValue];
                    NSInteger ts2 = [m2.ctime integerValue];
                    if (ts1 < ts2) {
                        [array exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                    }
                }
            }
            
        }
        


        
        
        ReDianModel * abcModel = [array firstObject];
        
        [_dayNumberArray addObject:[DxyCustom getYearMonthDay:abcModel.ctime]];
        [_mutableDictionary setObject:array forKey:[DxyCustom getYearMonthDay:abcModel.ctime]];
        ReDianModel * model2 = [_moreRedianDayArray lastObject];
        _redianCtime = model2.ctime;
        
        
        ReDianModel * modelZi = [_moreZixunDayArray lastObject];
        _zixunCtime = modelZi.ctime;
        
        
        
        
        
        [_shiJianLianTableView reloadData];
        
        
        

    
    }
    
    }
    
    
}

- (NSArray *)getYearArray2{
    
    
    
    
    ReDianModel * model = nil;
    NSString * yearString=nil;
    if(_shiJianLianArray.count>0)
    {
        model=_shiJianLianArray[0];
        yearString = [[DxyCustom getTimeWithTimeSp:model.ctime ]substringToIndex:10];
    }
    
    if (yearString.length>0) {
        [_dayNumberArray addObject:yearString];
    }
    
    for (int i = 0; i < _shiJianLianArray.count; i++) {
        model = [_shiJianLianArray objectAtIndex:i];
        //NSString *tempyear=[model.ctime substringToIndex:10];
        NSString * tempyear = [[DxyCustom getTimeWithTimeSp:model.ctime ]substringToIndex:10];
        if(![_dayNumberArray containsObject:tempyear])
        {
            [_dayNumberArray addObject:tempyear];//填充不重复日期
        }
    }
    //拼凑字典
    for(int j=0;j<_dayNumberArray.count;j++)
    {
        for (int i = 0; i < _shiJianLianArray.count; i++) {
            NSString *year=_dayNumberArray[j];
            model = [_shiJianLianArray objectAtIndex:i];
            NSString * tempyear = [[DxyCustom getTimeWithTimeSp:model.ctime ]substringToIndex:10];
            if([tempyear isEqualToString:year]){
                NSMutableArray * arr= [_mutableDictionary objectForKey:year];
                if(arr==nil){
                    arr=[NSMutableArray new];
                    [arr addObject:model];
                }
                else
                {
                    arr=[NSMutableArray arrayWithArray:arr];
                    [arr addObject:model];
                }
                [_mutableDictionary setObject:arr forKey:tempyear];
            }
        }
    }
    
    
    
    
    
    
    
    [_shiJianLianTableView reloadData];
    return nil;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
