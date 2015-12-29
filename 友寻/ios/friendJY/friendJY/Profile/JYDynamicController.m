//
//  JYDynamicController.m
//  friendJY
//
//  Created by chenxiangjing on 15/5/4.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYDynamicController.h"
#import "JYHttpServeice.h"
#import "JYFeedModel.h"
#import "JYAppDelegate.h"
#import "JYFeedDetailController.h"
#import "JYFeedEditController.h"
#import "JYFeedData.h"
#import "JYShareData.h"
#import "JYProfileController.h"
#import "JYOtherProfileController.h"

@interface JYDynamicController ()<JYEmotionBrowserDelegate>
{
    NSString *lastDynamicId;
    NSMutableArray *tableData;
    UIView *sendView ;
    UIView *maskView;
    NSString * _sendfeedid;
    NSString * _sendoid;
    NSString * myself_uid;
    UIView *baseBGView;
    BOOL isLoadMore;
    
    BOOL isReplyComment;//0是直接发送评论，1为回复某人评论
    NSString *_replayDyUid;//回复时动态的uid
    NSString *_replyUid;//回复人的uid
    NSString *_replyDyId;//动态id
    NSString *_replyCommentUid;//评论人的uid
    NSString *_replyCommentId;//评论id
    NSString *_replyNick;//被 回复的昵称
    
    UILabel *noDynamicLabel;
    
    JYEmotionBrowser * emotion;
}
@property (nonatomic, assign) NSInteger currentKeyboardHeight;

@end

@implementation JYDynamicController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellClickAvatarNotification:) name:kFeedCellClickAvatarNotification object:nil];
    // 给用户发私信
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendCommentNotify:) name:kDynamicSendCommentNotify object:nil];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDynamicSendCommentNotify object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFeedCellClickAvatarNotification object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    lastDynamicId = @"0";
    tableData = [NSMutableArray array];
    
    emotion = [[JYEmotionBrowser alloc] init];
    emotion.delegate = self;
    
    BOOL isSelf = [self.uid isEqualToString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]]];
    if (isSelf) {
        //右上角添加动态
        UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        navRightBtn.backgroundColor = [UIColor clearColor];
        [navRightBtn setFrame:CGRectMake(0, 0, 20, 20)];
        [navRightBtn setImage:[UIImage imageNamed:@"feedAddBtn"] forState:UIControlStateNormal];
        [navRightBtn addTarget:self action:@selector(_clickRightTopButton) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:navRightBtn]];
    }
//    _currentKeyboardHeight = 257;
    [self _initTableView];
    [self initNoDynamicLabel];
    [self loadDynamicData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendReplyCommentNotify:) name:kDynamicSendReplyCommentNotify object:nil];
    //刷新table ui
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableListUI:) name:kDynamicListRefreshTableNotify object:nil];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDynamicListRefreshTableNotify object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDynamicSendReplyCommentNotify object:nil];
}
- (void) cellClickAvatarNotification:(NSNotification *)noti {
    
    NSString * uid = noti.object;
    JYOtherProfileController * _proVC = [[JYOtherProfileController alloc] init];
    _proVC.show_uid = uid;
    [self.navigationController pushViewController:_proVC animated:YES];
}

- (void)refreshTableListUI:(NSNotification *)noti{
    
    self.feedTableView.data =tableData= [JYFeedData sharedInstance].myDynamicArr;
    [self.feedTableView reloadData];
    [self.feedTableView doneLoadingTableViewData]; //数据返回，则收起加载
}
- (void)_clickRightTopButton{
    JYFeedEditController * _editVC = [[JYFeedEditController alloc] init];
    _editVC.formId = 1;
    _editVC.refreshFeedListBlock = ^(JYFeedModel *mFeedModel){
        [[JYFeedData sharedInstance].myDynamicArr insertObject:mFeedModel atIndex:0];
        self.feedTableView.data = [JYFeedData sharedInstance].myDynamicArr;
        [self.feedTableView reloadData];
        [[JYAppDelegate sharedAppDelegate] showTip:@"发布成功"];
    };
    [self.navigationController pushViewController:_editVC animated:YES];
}

//初始化tableview文件
- (void) _initTableView{
    self.feedTableView = [[JYFeedTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.feedTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight -kStatusBarHeight);
    //self.feedTableView.rowHeight = 220;
    self.feedTableView.isMyDynamicCall = YES;
    self.feedTableView.refreshDelegate = self;
    self.feedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.feedTableView.backgroundColor = [JYHelpers setFontColorWithString:@"#edf1f4"];
    if (_isLimited) {
        [self.feedTableView setTableFooterView:nil];
        [self.feedTableView setTableHeaderView:nil];
        [self.feedTableView setRefreshHeader:NO];
        [self.feedTableView setRefreshHeaderView:nil];
    }
    [self.view addSubview:self.feedTableView];
}
//没有动态的时候显示label
- (void)initNoDynamicLabel{
    noDynamicLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (kScreenHeight - kNavigationBarHeight - kStatusBarHeight -kTabBarViewHeight - 20)/2, kScreenWidth, 20)];
    noDynamicLabel.backgroundColor = [UIColor clearColor];
    noDynamicLabel.textAlignment = NSTextAlignmentCenter;
    noDynamicLabel.textColor = kTextColorGray;
    noDynamicLabel.font = [UIFont systemFontOfSize:14.f];
    noDynamicLabel.text = @"暂无动态";
    [noDynamicLabel setHidden:YES];
    [self.view addSubview:noDynamicLabel];
    
}
- (void)loadDynamicData{
    self.feedTableView.tableFooterView.hidden = NO;
    if (!isLoadMore) {
        lastDynamicId = @"0";
    }
    NSDictionary *paraDic = @{@"mod":@"snsfeed",
                              @"func":@"get_one_user_dynamic_list"
                              };
    NSMutableDictionary *postDic =[NSMutableDictionary dictionaryWithDictionary:
                            @{@"uid":_uid,
                              @"dy_id":lastDynamicId,
                              @"num":@"10"
                            }];
    if (_isLimited) {
        [postDic setObject:@"5" forKey:@"num"];
    }
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1 && [[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
            NSMutableArray *resultData = [NSMutableArray array];
            NSMutableArray *rArray = [[responseObject objectForKey:@"data"] objectForKey:@"list"];
            if (isLoadMore) {
                for (NSDictionary * temp in rArray) {
                    JYFeedModel * feedModel = [[JYFeedModel alloc] initWithDataDic:temp];
                    if (![self eliminateDuplicate:feedModel.feedid]) { //不是重复的内容将加到数组中
                        feedModel.contentIsExpand = NO;
                        feedModel.praiseIsExpand = NO;
                        feedModel.rebroadcastIsExpand = NO;
                        [resultData addObject:feedModel];
                        lastDynamicId = feedModel.feedid;
                    }
                }
                if (resultData.count > 0) { //只有结果数据大于0，才进行操作
                    [tableData addObjectsFromArray:resultData];
                    [JYFeedData sharedInstance].myDynamicArr = tableData;
                    self.feedTableView.data =tableData;
                    [self.feedTableView reloadData];
                    [self.feedTableView doneLoadingTableViewData]; //数据返回，则收起加载
                    UIButton *btn = (UIButton *)self.feedTableView.tableFooterView;
                    [btn setTitle:@"上拉加载更多..." forState:UIControlStateNormal];
                }else{
                    //[self.feedTableView setNoMoreData]; //提示没有更多数据
//                    UIButton *btn = (UIButton *)self.feedTableView.tableFooterView;
//                    [btn setTitle:@"没有更多了" forState:UIControlStateNormal];
//                    UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[btn viewWithTag:2013];
//                    [activityView stopAnimating];
                    
                    if (tableData.count==0) {
                        //                        [self.feedTableView performSelector:@selector(setNoMoreDynamic) withObject:nil afterDelay:1.2];
                        [noDynamicLabel setHidden:NO];
                        [self.feedTableView.tableFooterView setHidden:YES];
                    
                    }else{
                        [self.feedTableView performSelector:@selector(setNoMoreData) withObject:nil afterDelay:1.2];
                    }
                }
                
            }else{
                for (NSDictionary * temp in rArray) {
                    JYFeedModel * feedModel = [[JYFeedModel alloc] initWithDataDic:temp];
                    [resultData addObject:feedModel];
                    lastDynamicId = feedModel.feedid;
                }
                
                [tableData removeAllObjects];
                if (resultData.count > 0) { //只有结果数据大于0，才进行操作
                    [tableData addObjectsFromArray:resultData];
                    [JYFeedData sharedInstance].myDynamicArr = tableData;
                    self.feedTableView.data =tableData;
                    [self.feedTableView reloadData];
                }else{
                    
                    if (tableData.count==0) {
                        [noDynamicLabel setHidden:NO];
                        [self.feedTableView.tableFooterView setHidden:YES];
                        //                        [self.feedTableView performSelector:@selector(setNoMoreDynamic) withObject:nil afterDelay:1.2];
                    }else{
                        [self.feedTableView performSelector:@selector(setNoMoreData) withObject:nil afterDelay:1.2];
                    }
                }
            }
            [self.feedTableView performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1];
            
        } else {
            [[JYAppDelegate sharedAppDelegate] showTip:[responseObject objectForKey:@"retmean"]];
        }
        
    } failure:^(id error) {
        
        [self.feedTableView performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1];
    }];
}
- (BOOL) eliminateDuplicate:(NSString *)feedid{
    BOOL isDuplicate = NO;
    for (int i = 0; i<tableData.count; i++) {
        JYFeedModel * temp = [tableData objectAtIndex:i];
        if ( [temp.feedid integerValue] == [feedid integerValue]) {
            isDuplicate = YES;
            break;
        }
    }
    return isDuplicate;
}
- (void)pullUp:(JYBaseTableView *)tableView{
    if (_isLimited) {
        return;
    }
    isLoadMore = YES;
    [self loadDynamicData];
}
- (void) pullDown:(JYBaseTableView *)tableView{
    if (_isLimited) {
        return;
    }
    NSLog(@"fuck pull down");
    isLoadMore = NO;
    [self loadDynamicData];
}
//点击进入动态详情
- (void)didSelectRowAtIndexPath:(JYBaseTableView *)tabelView indexPath:(NSIndexPath *)indexPath{
    JYFeedModel * temp = (JYFeedModel *)[tableData objectAtIndex:indexPath.row];
    
    
    JYFeedDetailController * _profileVC = [[JYFeedDetailController alloc] init];
    _profileVC.feedModel = temp;
    [self.navigationController pushViewController:_profileVC animated:YES];
}


- (void)JYEmotionTextFieldShouldReturn:(JYEmotionBrowser *)jyEmotion contentText:(NSString *)contentText{
    // 发送私信
    if (contentText.length == 0) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"您没有输入任何内容哦"];
        
    } else {
        [self _requestSendCommendData:contentText];
    }
}

// 发私信
- (void)sendCommentNotify:(NSNotification *)notify
{
    isReplyComment = NO;
    NSDictionary *dic = notify.userInfo;
    _sendoid = dic[@"userId"];
    _sendfeedid = dic[@"feedId"];
    NSString *nick = [NSString stringWithFormat:@"“%@”", dic[@"nickName"]];
    NSLog(@"dict--->%@",dic[@"userId"]);
    
    emotion.showNick = nick;
    [emotion show];
}
// 回复评论
- (void)sendReplyCommentNotify:(NSNotification *)notify
{
    isReplyComment = YES;
    NSDictionary *dic = notify.userInfo;
    _replayDyUid = dic[@"dyUid"];
    _replyUid = dic[@"replyUid"];
    _replyDyId =dic[@"dyId"];
    _replyCommentUid = dic[@"commentUid"];
    _replyCommentId = dic[@"commentId"];
    _replyNick = dic[@"nickName"];
    NSString *nick = [NSString stringWithFormat:@"“%@”", _replyNick];
    
    emotion.showNick = nick;
    [emotion show];
}

//提交评论内容到web
- (void)_requestSendCommendData:(NSString *) content{
    // send_comment(对方uid oid, 动态id dy_id, 评论内容 content)
    if (content.length < 1) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"输入的内容太短！请重新输入"];
        return;
    }
    if (isReplyComment) { //直接评论还是回复评论
        [[JYFeedData sharedInstance] sendReplyCommendDataToHttp:_replayDyUid reply_nick:_replyNick reply_uid:_replyUid dy_id:_replyDyId comment_id:_replyCommentId comment_uid:_replyCommentUid content:content];
    }else{
        [[JYFeedData sharedInstance] sendCommendDataToHttp:_sendoid sendFeedId:_sendfeedid content:content];
    }
}

//// 发送消息
//- (void)sendMsgToUser
//{
//    [maskView removeFromSuperview];
//    
//    UITextField *textFiled = (UITextField *)[baseBGView viewWithTag:1100];
//    [textFiled resignFirstResponder];
//    [UIView animateWithDuration:0.25 animations:^{
//        baseBGView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 265);
//    }];
//    
//    // 发送私信
//    if (textFiled.text.length == 0) {
//        [[JYAppDelegate sharedAppDelegate] showTip:@"您没有输入任何内容哦"];
//        return;
//    } else {
//        [self _requestSendCommendData:textFiled.text];
//        textFiled.text = @"";
//    }
//}
//
//- (void)sendCommentNotify:(NSNotification *)notify
//{
//    maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//    maskView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:maskView];
//    
//    NSDictionary *dic = notify.userInfo;
//    _sendoid = dic[@"userId"];
//    _sendfeedid = dic[@"feedId"];
//    NSString *nick = [NSString stringWithFormat:@"“%@”", dic[@"nickName"]];
//    
//    
//    UITextField *textFiled = (UITextField *)[baseBGView viewWithTag:1100];
//    textFiled.placeholder = [NSString stringWithFormat:@"我想对%@说...", nick];
//    [UIView animateWithDuration:0.25 animations:^{
//        baseBGView.frame = CGRectMake(0, kScreenHeight-_currentKeyboardHeight - 49, kScreenWidth, _currentKeyboardHeight + 49);
//    }];
//    [textFiled becomeFirstResponder];
//}

////提交评论内容到web
//- (void)_requestSendCommendData:(NSString *) content{
//    // send_comment(对方uid oid, 动态id dy_id, 评论内容 content)
//    if (content.length < 1) {
//        [[JYAppDelegate sharedAppDelegate] showTip:@"输入的内容太短！请重新输入"];
//        return;
//    }
//    
//    //拼接数据，存入数据
//    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
//    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
//    
//    NSDictionary * myProfile = [JYShareData sharedInstance].myself_profile_dict;
//    NSDictionary * temp = [[NSDictionary alloc] initWithObjectsAndKeys:[myProfile objectForKey:@"avatars"],@"avatar", [myProfile objectForKey:@"nick"],@"nick",[myProfile objectForKey:@"sex"],@"sex",[myProfile objectForKey:@"uid"],@"uid",content,@"content",@"",@"reply",timeSp,@"time",nil];
//    NSMutableArray *commentTemp = [NSMutableArray array];
//    
//    
//    for (int i = 0; i<tableData.count; i++) {
//        JYFeedModel *tempModel = [tableData objectAtIndex:i];
//        if ([tempModel.feedid isEqualToString:_sendfeedid]) {
//            [commentTemp addObjectsFromArray:tempModel.comment_list];
//            [commentTemp addObject:temp];
//            tempModel.comment_list = commentTemp;
//            break;
//        }
//    }
//    [self.feedTableView reloadData];
//    
//    
//    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
//    [parametersDict setObject:@"comment" forKey:@"mod"];
//    [parametersDict setObject:@"send_comment" forKey:@"func"];
//    
//    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
//    [postDict setObject:_sendoid forKey:@"oid"];
//    [postDict setObject:_sendfeedid forKey:@"dy_id"];
//    [postDict setObject:content forKey:@"content"];
//    
//    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
//        [self.feedTableView doneLoadingTableViewData]; //数据返回，则收起加载
//        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
//        if (iRetcode == 1) {
//            //处理数据，刷新ui
//            
//        } else {
//            [[JYAppDelegate sharedAppDelegate] showTip:[responseObject objectForKey:@"retmean"]];
//        }
//        
//    } failure:^(id error) {
//        
//        NSLog(@"%@", error);
//        
//    }];
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [maskView removeFromSuperview];
    
    UITextField *textFiled = (UITextField *)[baseBGView viewWithTag:1100];
    [textFiled resignFirstResponder];
    
    [UIView animateWithDuration:0.25 animations:^{
        baseBGView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 265);
    }];
    
    
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
