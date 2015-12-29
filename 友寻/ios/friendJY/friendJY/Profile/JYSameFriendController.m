//
//  JYSameFriendController.m
//  friendJY
//
//  Created by chenxiangjing on 15/4/22.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYSameFriendController.h"
#import "JYSameFriendTableView.h"
#import "JYCreatGroupFriendModel.h"
#import "ChineseString.h"
#import "JYHttpServeice.h"
#import "JYAppDelegate.h"
#import "JYOtherProfileController.h"

#define kSiftLabelHeight 25.0f
#define kSiftYPadding 15.0f

typedef enum : NSUInteger {
    SexFemale = 1,
    SexMale,
    SexNone
}SexType;

@interface JYSameFriendController ()<JYTableViewDidSelectedRowDelegate>
{
    UIScrollView *filterScrollView;//筛选视图
    //共同好友 和 他的好友切换
    UIView *segmentalBgView;
    JYSameFriendTableView *tableView;//好友列表
    UIImageView *filterBtnBgView;
    UIButton *filterBtn;
    SexType sex;
    BOOL isSingle;
    NSMutableArray *_hisFriendList;
    UISegmentedControl *mySegementedControl;
    
    UILabel *noListLab;
    
}

@property (nonatomic, strong) NSMutableArray *nameList;
//@property (nonatomic, strong) NSMutableArray *indexArr;
@property (nonatomic, strong) NSMutableArray *friendList;//存放好友（包括共同好友或者他的好友）

@end

@implementation JYSameFriendController
//@synthesize _friendList;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"共同好友"];
    [self layoutSubviews];
    [self initData];
}
- (void)initData{
    _nameList = [NSMutableArray array];
//    _indexArr = [NSMutableArray array];
    _hisFriendList = [NSMutableArray array];
    sex = SexNone;
    isSingle = 0;
//    if (_dataArr == nil) {
//        NSLog(@"没有创建");
//    }else if (_dataArr.count == 0){
//        NSLog(@"数组为空");
//    }
    _friendList = [NSMutableArray arrayWithArray:self.dataArr];
    if (_friendList.count > 0) {
        [self performSelectorInBackground:@selector(handleFriendsList) withObject:nil];
    }else{
        [mySegementedControl setSelectedSegmentIndex:1];
        [self loadHisFriends];
    }
}
#pragma mark - 视图初始化放这儿
- (void)layoutSubviews{
    //初始化筛选视图
    [self initFilterScrollView];
    //初始化表视图
    [self initTableView];
    //初始化选择视图
    [self initSegematalView];
    
    [self initFilterButton];
    
    noListLab = [[UILabel alloc] initWithFrame:CGRectMake(15, self.view.height/2 - 100, kScreenWidth - 30, 40)];
    [noListLab setTextColor:kTextColorGray];
    [noListLab setFont:[UIFont systemFontOfSize:15]];
    [noListLab setTextAlignment:NSTextAlignmentCenter];
    [noListLab setHidden:YES];
    [self.view addSubview:noListLab];
    
    [self.view bringSubviewToFront:filterScrollView];
}
//初始化筛选视图
- (void)initFilterScrollView{
    filterScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    [filterScrollView setBackgroundColor:[UIColor whiteColor]];
    [filterScrollView setShowsHorizontalScrollIndicator:NO];
    [filterScrollView setShowsVerticalScrollIndicator:NO];
    [filterScrollView setScrollEnabled:NO];
    [filterScrollView setContentSize:CGSizeMake(kScreenWidth, 90)];
    
    CGFloat bottom = 10;
    
    UILabel *sexLab = [self LabelWithText:@"性别" andFrame:CGRectMake(kSiftYPadding, bottom, 60, kSiftLabelHeight)];
    UIButton *buttonOne = [self buttonWithFrame:CGRectMake(sexLab.right + 28 - 5, sexLab.top, 46, sexLab.height) title:@"不限" action:@selector(sexBtnAction:) tag:SexNone];
    [buttonOne setSelected:YES];
    UIButton *buttonMale = [self buttonWithFrame:CGRectMake(buttonOne.right + 10, sexLab.top, 31, sexLab.height) title:@"男" action:@selector(sexBtnAction:) tag:SexMale];
    UIButton *buttonFemale = [self buttonWithFrame:CGRectMake(buttonMale.right + 10, sexLab.top, 31, sexLab.height) title:@"女" action:@selector(sexBtnAction:) tag:SexFemale];
    
    [filterScrollView addSubview:sexLab];
    [filterScrollView addSubview:buttonOne];
    [filterScrollView addSubview:buttonMale];
    [filterScrollView addSubview:buttonFemale];
    bottom += (kSiftLabelHeight + kSiftYPadding);
    
    UILabel *marriageStatusLab = [self LabelWithText:@"情感状态" andFrame:CGRectMake(kSiftYPadding, bottom, 60, kSiftLabelHeight)];
    UIButton *btnFree = [self buttonWithFrame:CGRectMake(marriageStatusLab.right + 28 - 5, marriageStatusLab.top, 46, marriageStatusLab.height) title:@"不限" action:@selector(statusChangedAction:) tag:1000];
    [btnFree setSelected:YES];
    UIButton *btnSingle = [self buttonWithFrame:CGRectMake(btnFree.right + 10, marriageStatusLab.top, 46, marriageStatusLab.height) title:@"单身" action:@selector(statusChangedAction:) tag:1001];
    
    [filterScrollView addSubview:marriageStatusLab];
    [filterScrollView addSubview:btnFree];
    [filterScrollView addSubview:btnSingle];

    [self.view addSubview:filterScrollView];
}
//刷选按钮视图
- (void)initFilterButton{
    filterBtnBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 29)];
    [filterBtnBgView setUserInteractionEnabled:YES];
    [filterBtnBgView setBackgroundColor:[UIColor clearColor]];
    [filterBtnBgView setImage:[UIImage imageNamed:@"find_clearBg"]];
    
    CGFloat width = [JYHelpers getTextWidthAndHeight:@"筛选条件" fontSize:15].width;
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-width)/2, 0, width, 29)];
    [lab setBackgroundColor:[UIColor clearColor]];
    [lab setFont:[UIFont systemFontOfSize:15.0f]];
    [lab setText:@"筛选条件"];
    [lab setTextColor:kTextColorBlue];
    [lab setTextAlignment:NSTextAlignmentCenter];
    [filterBtnBgView addSubview:lab];
    
    filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [filterBtn setFrame:CGRectMake(lab.right, 21/2, 13, 8)];
//    [filterBtn setTag:123];
//    [filterBtn setEnabled:NO];
    [filterBtn setBackgroundImage:[UIImage imageNamed:@"profile_down_arrow"] forState:UIControlStateNormal];
    [filterBtn setBackgroundImage:[UIImage imageNamed:@"profile_up_arrow"] forState:UIControlStateSelected];
    [filterBtn addTarget:self action:@selector(filterBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [filterBtnBgView addSubview:filterBtn];
    
    [self.view addSubview:filterBtnBgView];
    
    [filterBtnBgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(filterBtnAction)]];
}
//初始化选择视图
- (void)initSegematalView{
    
    segmentalBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (29+15)*2)];
    [segmentalBgView setBackgroundColor:[UIColor whiteColor]];
    
     mySegementedControl = [[UISegmentedControl alloc] initWithItems:@[@"共同好友",@"TA的好友"]];
    [mySegementedControl setSegmentedControlStyle:UISegmentedControlStyleBordered];
    [mySegementedControl setFrame:CGRectMake(15, 29+15, kScreenWidth - 30, 29)];
    [mySegementedControl setSelectedSegmentIndex:0];
    [mySegementedControl addTarget:self action:@selector(segementedControlValueChangedAction:) forControlEvents:UIControlEventValueChanged];
    [segmentalBgView addSubview:mySegementedControl];
    [self.view addSubview:segmentalBgView];

}
//初始化表视图
- (void)initTableView{
    tableView = [[JYSameFriendTableView alloc] initWithFrame:CGRectMake(0, 90, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - 90) style:UITableViewStylePlain];
    [tableView setSelectedDelegate:self];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:tableView];
}

#pragma mark - 网络请求放这儿
- (void)loadHisFriends{
    [self showProgressHUD:@"获取中..." toView:self.view];
    NSDictionary *paraDic = @{@"mod":@"friends",
                              @"func":@"friends_get_myfriends_all"
                              };
    
    NSDictionary *postDic = @{@"uid":self.show_uid,
                              @"start":@"0",
                              @"nums":@"300"
                              };
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            NSLog(@"成功获取一度好友信息")
            NSDictionary *dataDic = [responseObject objectForKey:@"data"];
            if ([dataDic isKindOfClass:[NSDictionary class]]) {
                for (NSString *key in dataDic.allKeys) {
                    NSDictionary *dic = dataDic[key];
                    if (dic.count < 3) {
                        continue;
                    }
                    JYCreatGroupFriendModel *model = [[JYCreatGroupFriendModel alloc] initWithDataDic:dic];
                    [model setAvatar:dataDic[key][@"avatars"][@"100"]];
                    if (![JYHelpers isEmptyOfString:model.friendUid]) {
                        [_hisFriendList addObject:model];
                    }
                }
                [_friendList removeAllObjects];
                [_friendList addObjectsFromArray:_hisFriendList];
                if (_friendList.count == 0) {
                    [noListLab setHidden:NO];
                    [noListLab setText:@"他还没有好友哦"];
                }else{
                    [noListLab setHidden:YES];
                    [self getMutualNums];
                }
            }else{
                [noListLab setHidden:NO];
                [noListLab setText:@"他还没有好友哦"];
            }
            //            [self getMutualNums];
            [self dismissProgressHUDtoView:self.view];
        }
    } failure:^(id error) {
        [self dismissProgressHUDtoView:self.view];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];

}
//获取共同好友数量
- (void)getMutualNums{
    //用于检测所有所有二度好友的 共同好友数量是否下载成功
    __block NSInteger finishedCount = 0;
    for (int i= 0; i < _friendList.count; i++) {
        
        JYCreatGroupFriendModel *model = [_friendList objectAtIndex:i];
        //                        friends_get_mutualnums(int this->uid, int this->fuid
        NSDictionary *paraDict = @{
                                   @"mod":@"friends",
                                   @"func":@"friends_get_mutualnums"
                                   };
        NSDictionary *postDict = @{
                                   @"uid":ToString([SharedDefault objectForKey:@"uid"]),
                                   @"fuid":model.friendUid
                                   };
        [JYHttpServeice requestWithParameters:paraDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
            NSInteger iRetcodet = [[responseObject objectForKey:@"retcode"] integerValue];
            if (iRetcodet == 1) {
                finishedCount ++;
                [model setMutualNums:[responseObject objectForKey:@"data"]];
                if (finishedCount == _friendList.count) {
                    [self handleFriendsList];
                    [self dismissProgressHUDtoView:self.view];
                }
            }
            
        } failure:^(id error) {
            [self dismissProgressHUDtoView:self.view];
            [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        }];
    }
}

#pragma mark - 触发事件放这儿
//筛选选项值变化

- (void)statusChangedAction:(UIButton*)button{
    if (button.tag == 1000 && isSingle) {
        UIButton *btn = (UIButton*)[filterScrollView viewWithTag:1001];
        [btn setSelected:NO];
        [button setSelected:YES];
        isSingle = NO;
        [self FilterData];
    }else if(button.tag == 1001 && !isSingle){
        UIButton *btn = (UIButton*)[filterScrollView viewWithTag:1000];
        [btn setSelected:NO];
        [button setSelected:YES];
        isSingle = YES;
        [self FilterData];
    }
}
- (void)sexBtnAction:(UIButton*)button{
    if (button.tag != sex) {
        UIButton *btn = (UIButton*)[filterScrollView viewWithTag:sex];
        btn.selected = NO;
        button.selected = YES;
        sex = button.tag;
        [self FilterData];
    }
}
//选择器值变化
- (void)segementedControlValueChangedAction:(UISegmentedControl*)segmentedControl{
    NSLog(@"value --> %ld",(long)segmentedControl.selectedSegmentIndex);
    NSInteger index = segmentedControl.selectedSegmentIndex;
    if (index == 0) {
        [_friendList removeAllObjects];
        [_friendList addObjectsFromArray:self.dataArr];
        [self handleFriendsList];
        if (_friendList.count == 0) {
            [noListLab setHidden:NO];
            [noListLab setText:@"你们还没有共同好友哦"];
        }else{
            [noListLab setHidden:YES];
        }
    }else if (_hisFriendList.count > 0){
        [_friendList removeAllObjects];
        [_friendList addObjectsFromArray:_hisFriendList];
        [self handleFriendsList];
        if (_friendList.count == 0) {
            [noListLab setHidden:NO];
            [noListLab setText:@"他还没有好友哦"];
        }else{
            [noListLab setHidden:YES];
        }

    }else if (_hisFriendList.count == 0){
        [self loadHisFriends];
    }
//    [self FilterData];
    [self resetFilterOption];
}
//筛选按钮
- (void)filterBtnAction{

    if (filterBtn.selected) {
        [UIView animateWithDuration:.2 animations:^{
            [filterScrollView setFrame:CGRectMake(0, 0, kScreenWidth, 0)];
            [filterBtnBgView setFrame:CGRectMake(0, filterScrollView.bottom, kScreenWidth, 29)];
        }];
    }else{
        [UIView animateWithDuration:.2 animations:^{
            [filterScrollView setFrame:CGRectMake(0, 0, kScreenWidth, 90)];
            [filterBtnBgView setFrame:CGRectMake(0, filterScrollView.bottom, kScreenWidth, 29)];
        }];
    }
    
    filterBtn.selected = !filterBtn.selected;
    
}
#pragma mark - 代理方法放这里
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JYCreatGroupFriendModel *model = [[_friendList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSArray *viewControllers = self.navigationController.viewControllers;
    NSInteger index;
    for (index = 0; index < viewControllers.count; index++) {
        if ([viewControllers[index] isKindOfClass:[JYOtherProfileController class]]) {
            JYOtherProfileController *VC = [viewControllers objectAtIndex:index];
            if ([VC.show_uid isEqualToString:model.friendUid]) {
                NSLog(@"当前用户详情已存在导航控制器中。 姓名 ====》%@",model.nick)
                break;
            }
        }
    }
    if (index == viewControllers.count) {
        JYOtherProfileController *profileController = [[JYOtherProfileController alloc] init];
        [profileController setShow_uid:model.friendUid];
        [self.navigationController pushViewController:profileController animated:YES];
    }else{
    
        [self.navigationController popToViewController:viewControllers[index] animated:YES];
    }
}

#pragma mark - 帮助类方法放这里
//创建label
- (UILabel *)LabelWithText:(NSString*)text andFrame:(CGRect)frame{
    
    UILabel *sexLab = [[UILabel alloc] initWithFrame:frame];
    [sexLab setFont:[UIFont systemFontOfSize:15.0f]];
    [sexLab setTextColor:[JYHelpers setFontColorWithString:@"#303030"]];
    [sexLab setTextAlignment:NSTextAlignmentRight];
    [sexLab setText:text];
    
    return sexLab;
}
//创建btn选项
- (UIButton*)buttonWithFrame:(CGRect)frame title:(NSString*)title action:(SEL)action tag:(NSInteger)tag{
    
    UIButton *btnOne = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnOne setFrame:frame];
    [btnOne setTag:tag];
    [btnOne setTitle:title forState:UIControlStateNormal];
    [btnOne setTitleColor:[JYHelpers setFontColorWithString:@"#848484"] forState:UIControlStateNormal];
    [btnOne setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btnOne.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [btnOne addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [btnOne setBackgroundImage:[UIImage imageNamed:@"find_contact_btnBg"] forState:UIControlStateSelected];
    return btnOne;
}
//本地筛选
- (void)FilterData{
    
    NSArray *srcArr = mySegementedControl.selectedSegmentIndex == 0 ? _dataArr : _hisFriendList;
    [_friendList removeAllObjects];
    switch (sex) {
        case SexNone:{
            [_friendList addObjectsFromArray:srcArr];
        }
            break;
        case SexMale:{
            [self siftFriendsWithSex:@"1" andSrcArr:srcArr];
        }
            break;
        case SexFemale:{
            [self siftFriendsWithSex:@"0" andSrcArr:srcArr];
        }
            break;
        default:
            break;
    }
    NSMutableArray *tmpArr = [NSMutableArray array];
    if (isSingle) {
        for (JYCreatGroupFriendModel *model in _friendList) {
            if (![model.marriage isEqualToString:@"1"]) {
                [tmpArr addObject:model];
            }
        }
    }
    [_friendList removeObjectsInArray:tmpArr];
    [[JYAppDelegate sharedAppDelegate] showTip:@"筛选完成"];
    [self handleFriendsList];
}
//点击男女筛选
- (void)siftFriendsWithSex:(NSString*)sexStr andSrcArr:(NSArray*)srcArr{
    
    for (JYCreatGroupFriendModel *model in srcArr) {
        if ([model.sex isEqualToString:sexStr]) {
            [_friendList addObject:model];
        }
    }
}
- (void)resetFilterOption{
    //重置筛选
    UIButton *btn = (UIButton*)[filterScrollView viewWithTag:sex];
    btn.selected = NO;
    UIButton *button = (UIButton*)[filterScrollView viewWithTag:SexNone];
    button.selected = YES;
    sex = button.tag;
    
    UIButton *singleBtn = (UIButton*)[filterScrollView viewWithTag:1001];
    [singleBtn setSelected:NO];
    UIButton *btnFree = (UIButton*)[filterScrollView viewWithTag:1000];
    [btnFree setSelected:YES];
    isSingle = NO;

}
- (void)handleFriendsList
{
    NSMutableArray *nameArr = [NSMutableArray array];
    for (JYCreatGroupFriendModel *friendModel in _friendList)
    {
        [nameArr addObject:friendModel.nick];
    }
    //    [_nameList removeAllObjects];
    [self setNameList:nameArr];
    
    [tableView setIndexArr:[ChineseString indexArray:_nameList]];
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
                    [_friendList removeObject:friendModel];
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
    //与同步tableview 数据模型数组同步 方便跳转的时候取model
    [self setFriendList:resultList];
    
    [tableView setFriendList:resultList];
    dispatch_async(dispatch_get_main_queue(), ^{
        [tableView reloadData];
        [tableView setContentOffset:CGPointMake(0, 0) animated:NO];
    });
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
