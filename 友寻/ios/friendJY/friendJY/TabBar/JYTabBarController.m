//
//  JYTabBarController.m
//  friendJY
//
//  Created by 高斌 on 15/2/27.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYTabBarController.h"
#import "JYTabBarItem.h"
#import "JYNavigationController.h"
#import "JYFeedController.h"
#import "JYMessageController.h"
#import "JYFindController.h"
#import "JYProfileController.h"
#import "JYShareData.h"
#import "JYProfileData.h"
#import "JYMessageModel.h"
#import "NSDictionary+Additions.h"


@interface JYTabBarController ()
{
    JYFeedController *feedController;
}
@end

@implementation JYTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initViewContollers];
    
    [self initTabBar];
    
    [JYShareData sharedInstance].myself_profile_dict =  [[JYProfileData sharedInstance] getProfileData:ToString([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"])];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTabBarUnreadNumber:) name:kRefreshTabBarUnreadNumberNotification object:nil];
    
    //注册消息推送通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushServiceNotification:) name:kTabBarRedTipShowOrHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRefreshTabBarUnreadNumberNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRefreshTabBarUnreadNumberNotification object:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)initViewContollers
{
    feedController = [[JYFeedController alloc] init];
    JYMessageController *messageController = [[JYMessageController alloc] init];
    JYFindController *findController = [[JYFindController alloc] init];
    JYProfileController *profileController = [[JYProfileController alloc] init];
    
    NSArray *controllers = @[feedController, messageController, findController, profileController];
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:controllers.count];
    
    for (int i=0; i<controllers.count; i++) {
        UIViewController *controller = controllers[i];
        JYNavigationController *navigationController = [[JYNavigationController alloc] initWithRootViewController:controller];
        navigationController.delegate = self;
        [viewControllers addObject:navigationController];
        [controller setHidesBottomBarWhenPushed:YES];
    }
    
    [self setViewControllers:viewControllers];
}

- (void)initTabBar
{
    [self.tabBar setHidden:YES];
    
    _tabBarBgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenHeight-kTabBarViewHeight, kScreenWidth, kTabBarViewHeight)];
    _tabBarBgImage.clipsToBounds = YES;
    [_tabBarBgImage setBackgroundColor:[JYHelpers setFontColorWithString:@"#edf1f4"]];
    [_tabBarBgImage setUserInteractionEnabled:YES];
    UIImage *img=[UIImage imageNamed:@"bg_tabbar.png"];
    [_tabBarBgImage setImage:[img stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
    [self.view addSubview:_tabBarBgImage];
    
    NSArray *normalImages = @[@"tab_bar_feed_normal.png", @"tab_bar_message_normal.png",@"tab_bar_find_normal.png", @"tab_bar_profile_normal.png"];
    NSArray *highlightedImages = @[@"tab_bar_feed_selected.png", @"tab_bar_message_selected.png",@"tab_bar_find_selected.png", @"tab_bar_profile_selected.png"];
    
    CGFloat tabBarWidth = kScreenWidth/normalImages.count;
    
    for (int i=0; i<normalImages.count; i++) {
        NSString *normalImage = normalImages[i];
        NSString *highlightedImage = highlightedImages[i];
        
        JYTabBarItem *tabBarItem = [[JYTabBarItem alloc] initWithFrame:CGRectMake(tabBarWidth*i+(tabBarWidth-80)/2, 0, 80, kTabBarViewHeight) normalImage:normalImage highlightedImage:highlightedImage title:nil];
        tabBarItem.tag = i+100;
        [tabBarItem addTarget:self action:@selector(tabBarItemSelected:) forControlEvents:UIControlEventTouchUpInside];
        [_tabBarBgImage addSubview:tabBarItem];

        if (i == 0) {
//            tabBarItem.selected = YES;
            [self tabBarItemSelected:tabBarItem];
            _lastSelectedIndex = i+100;
        }
        
    }
    
    //新动态消息，右上角红点
    _feedNewMsgBgImage = [[UIImageView alloc] initWithFrame:CGRectMake(tabBarWidth/2+15, 5, 5,5)];
    _feedNewMsgBgImage.hidden = YES;
    _feedNewMsgBgImage.clipsToBounds = YES;
    [_feedNewMsgBgImage setImage:[[UIImage imageNamed:@"msgVoiceUnread"] stretchableImageWithLeftCapWidth:9 topCapHeight:9]];
    [_tabBarBgImage addSubview:_feedNewMsgBgImage];
    
    
    //消息右上角未读消息
    _messageCountBgImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    _messageCountBgImage.clipsToBounds = YES;
    [_messageCountBgImage setImage:[[UIImage imageNamed:@"msgCountBg"] stretchableImageWithLeftCapWidth:9 topCapHeight:9]];
    [_tabBarBgImage addSubview:_messageCountBgImage];
    
    _messageCountLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [_messageCountLab setBackgroundColor:[UIColor clearColor]];
    [_messageCountLab setTextColor:[UIColor whiteColor]];
    [_messageCountLab setFont:[UIFont boldSystemFontOfSize:12.0f]];
    [_messageCountLab setTextAlignment:NSTextAlignmentCenter];
    [_messageCountBgImage addSubview:_messageCountLab];
}

- (void)tabBarItemSelected:(UIControl *)tabBarItem
{
    self.selectedIndex = tabBarItem.tag-100;
    if (_lastSelectedIndex !=0 ) {
        JYTabBarItem *lastItem = (JYTabBarItem *)[_tabBarBgImage viewWithTag:_lastSelectedIndex];
        lastItem.selected = NO;
    }
    
    if (_lastSelectedIndex==100 && tabBarItem.tag==100) {
        //- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
        [feedController.feedTableView setContentOffset:CGPointMake(0, -65) animated:YES];
        [feedController.feedTableView egoRefreshTableHeaderDidTriggerRefresh:feedController.feedTableView.refreshHeaderView];
        [feedController.feedTableView.refreshHeaderView setState:EGOOPullRefreshLoading];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        feedController.feedTableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        [UIView commitAnimations];
    }
    
    tabBarItem.selected = YES;
    _lastSelectedIndex = tabBarItem.tag;
}

- (void)hiddenTabBar:(BOOL)hidden
{
    if (hidden) {
        _tabBarBgImage.left = -kScreenWidth;
    } else {
        _tabBarBgImage.left = 0;
    }
    [self.tabBar setHidden:YES];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    // 子控制器的个数
    NSInteger count = navigationController.viewControllers.count;
    
    if (count == 1) {
        
        // 显示工具栏
        [self hiddenTabBar:NO];
    } else {
        // 隐藏工具栏
        [self hiddenTabBar:YES];
    }
}

- (void) refreshTabBarUnreadNumber:(NSNotification *)noti{
    CGFloat tabBarWidth = kScreenWidth/4;
    NSDictionary *msgDic = [[NSUserDefaults standardUserDefaults] objectForKey:kRefreshNewUnreadMessageCount];
    //刷新启动icon的右上角数字
    int totalNum = [msgDic[@"sys_change"] intValue] ;
    NSMutableArray *tempArr = [JYShareData sharedInstance].messageUserList ;
    if (tempArr.count > 0) { //如果messagelist不为空，则未读数，以messageUserlist的newcount的和
        for (JYMessageModel * t in tempArr) {
            totalNum += [t.newcount intValue];
        }
    }else{
        totalNum += [msgDic[@"unread_chat"] intValue];
    }
    
    if (totalNum > 0) {
        
        if(totalNum > 99){
            _messageCountLab.text = @"99+";
            _messageCountLab.width = 25;
            _messageCountBgImage.frame = CGRectMake(tabBarWidth+tabBarWidth/2+10, 2, 25,18);
        }else{
            _messageCountLab.text = [NSString stringWithFormat:@"%d",totalNum];
            _messageCountLab.width = 18;
            _messageCountBgImage.frame = CGRectMake(tabBarWidth+tabBarWidth/2+10, 2, 18,18);
        }
    }else{
        _messageCountBgImage.frame = CGRectZero;
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber= totalNum;
}

//有新动态消息
- (void)pushServiceNotification:(NSNotification *)noti{
    NSString * num = [noti.userInfo objectForKey:@"unreadFeedNumber"];
    if ([num intValue] >0) {
        _feedNewMsgBgImage.hidden = NO;
    }else{
        _feedNewMsgBgImage.hidden = YES;
    }
}

@end
