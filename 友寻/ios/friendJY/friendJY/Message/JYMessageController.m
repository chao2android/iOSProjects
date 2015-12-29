//
//  JYMessageController.m
//  friendJY
//
//  Created by 高斌 on 15/3/6.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYMessageController.h"
#import "JYChatController.h"
#import "JYHttpServeice.h"
#import "JYMessageModel.h"
#import "JYCreatGroupController.h"
#import "JYMyGroupController.h"
#import "JYSysMsgController.h"
#import "JYChatController.h"
#import "JYChatDataBase.h"
#import "JYMsgUpdate.h"
#import "JYShareData.h"
#import "JYAppDelegate.h"

@interface JYMessageController ()

@end

@implementation JYMessageController{
    UIImageView *countBg;
    UILabel *countLab;
    UILabel *msgLab ;
    UILabel *timeLab;
    NSString *currentSelectUid; //如果是群组则是群组id,普通用户是oid
    NSString * deleteOneMessageUserTag;//删除一个用户标记时间，大于1秒，就是防止连续点击发生
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"消息"];
        _pageIndex = 0;
        _msgList = [[NSMutableArray alloc] init];
        [JYShareData sharedInstance].messageUserList = _msgList;

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketReceiveChatMsg:) name:kSocketReceiveChatMsgNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMessageTableView) name:kRefreshMessageTableViewNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteOneMessageUserNotification:) name:kDeleteOneMessageUserNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PushServiceChatMsg) name:kRefreshTabBarUnreadNumberNotification object:nil];
    
    [JYChatDataBase sharedInstance];
    
    [self layoutSubViews];
}

- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSocketReceiveChatMsgNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRefreshMessageTableViewNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDeleteOneMessageUserNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRefreshTabBarUnreadNumberNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    currentSelectUid = @"";
    [super viewWillAppear:animated];
    //列表获取请求
    [self fromHttpGetUserList];
    [self getSysMsgCount]; //获取系统消息数
    [self getMyGroupCount]; //获取群组数
    if (_table != nil) {
        [_table reloadData];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    _isAppear = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    _isAppear = NO;
}

- (void)createGroupBtnClick:(UIButton *)btn
{
    NSLog(@"建立群组");
    JYCreatGroupController *creatGroupController = [[JYCreatGroupController alloc] init];
    [self.navigationController pushViewController:creatGroupController animated:YES];
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

//#pragma mark - UITableViewDelegate
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    JYChatController *chatController = [[JYChatController alloc] init];
//    [chatController setFromUid:[NSString stringWithFormat:@"2095350"]];
//    [self.navigationController pushViewController:chatController animated:YES];
//}
//
//
//#pragma mark - UITableViewDataSource
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    
//    return 1;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//        
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        [cell.contentView setBackgroundColor:kTextColorGray];
//        
//        UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectZero];
//        [iconImage setTag:100];
//        [iconImage setBackgroundColor:[UIColor lightGrayColor]];
//        [cell.contentView addSubview:iconImage];
//        
//        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
//        [titleLab setBackgroundColor:[UIColor clearColor]];
//        [titleLab setFont:[UIFont systemFontOfSize:15.0f]];
//        [titleLab setTextColor:[UIColor blackColor]];
//        [titleLab setTextAlignment:NSTextAlignmentLeft];
//        [titleLab setTag:101];
//        [cell.contentView addSubview:titleLab];
//        
//        UILabel *messageLab = [[UILabel alloc] initWithFrame:CGRectZero];
//        [messageLab setBackgroundColor:[UIColor lightGrayColor]];
//        [messageLab setFont:[UIFont systemFontOfSize:15.0f]];
//        [messageLab setTextColor:[UIColor blackColor]];
//        [messageLab setTextAlignment:NSTextAlignmentLeft];
//        [messageLab setTag:102];
//        [cell.contentView addSubview:titleLab];
//    }
//
//    UILabel *titleLab = (UILabel *)[cell.contentView viewWithTag:101];
//    
//    [titleLab setFrame:CGRectMake(100, 5, 100, 30)];
//    [titleLab setText:[NSString stringWithFormat:@"2095350"]];
//    
//    
//    return cell;
//}

- (void)layoutSubViews
{
    UIButton *createGroupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [createGroupBtn setFrame:CGRectMake(0, 0, 65, 44)];
    [createGroupBtn setTitle:@"建立群组" forState:UIControlStateNormal];
    [createGroupBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [createGroupBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
    [createGroupBtn setTitleColor:kTextColorBlue forState:UIControlStateNormal];
    [createGroupBtn addTarget:self action:@selector(createGroupBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *createGroupBarBtn = [[UIBarButtonItem alloc] initWithCustomView:createGroupBtn];
    [self.navigationItem setRightBarButtonItem:createGroupBarBtn];
    
    // 头视图
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 65*2)];
    [headerView setUserInteractionEnabled:YES];
    headerView.backgroundColor = [UIColor clearColor];
    
    //我的群组
    UIButton *myGroup = [UIButton buttonWithType:UIButtonTypeCustom];
    myGroup.frame = CGRectMake(0, 0, kScreenWidth, 65);
    myGroup.backgroundColor = [UIColor clearColor];
    [myGroup addTarget:self action:@selector(myGroupBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:myGroup];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7.5, 50, 50)];
    imgView.backgroundColor = [UIColor clearColor];
    imgView.layer.cornerRadius = 25;
    imgView.layer.masksToBounds = YES;
    imgView.image = [UIImage imageNamed:@"msg_group_message.png"];
    [myGroup addSubview:imgView];
    
    //title
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(imgView.right+13, 15, 100, 18)];
    [titleLab setBackgroundColor:[UIColor clearColor]];
    [titleLab setTextColor:kTextColorBlack];
    [titleLab setFont:[UIFont systemFontOfSize:16.0f]];
    [titleLab setTextAlignment:NSTextAlignmentLeft];
    [titleLab setLineBreakMode:NSLineBreakByWordWrapping];
    [titleLab setText:@"我的群组"];
    [myGroup addSubview:titleLab];
    
    //消息
    msgLab = [[UILabel alloc] initWithFrame:CGRectMake(imgView.right+13, titleLab.bottom+5, kScreenWidth-imgView.right - 50, 18)];
    [msgLab setBackgroundColor:[UIColor clearColor]];
    [msgLab setTextColor:kTextColorGray];
    [msgLab setFont:[UIFont systemFontOfSize:12.0f]];
    [msgLab setTextAlignment:NSTextAlignmentLeft];
    [msgLab setLineBreakMode:NSLineBreakByWordWrapping];
    [msgLab setText:@"共有0个群组"];
    [myGroup addSubview:msgLab];
    
    UIImageView *myGroupMore = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 20, titleLab.bottom-5, 8, 13)];
    myGroupMore.image = [UIImage imageNamed:@"more_gray"];
    [myGroup addSubview:myGroupMore];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(15.0f, 64.0f, kScreenWidth-15.0f, 1.0f)];
    [line setBackgroundColor:kBorderColorGray];
    [myGroup addSubview:line];
        
    //系统消息
    UIButton *sysMessage = [UIButton buttonWithType:UIButtonTypeCustom];
    sysMessage.frame = CGRectMake(0, 65, kScreenWidth, 65);
    sysMessage.backgroundColor = [UIColor clearColor];
    [sysMessage addTarget:self action:@selector(msgSysBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:sysMessage];
    
    UIImageView *sysImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7.5, 50, 50)];
    sysImgView.backgroundColor = [UIColor clearColor];
    sysImgView.layer.cornerRadius = 25;
    sysImgView.layer.masksToBounds = YES;
    sysImgView.image = [UIImage imageNamed:@"msg_system_message.png"];
    [sysMessage addSubview:sysImgView];
    
    //title
    UILabel *sysTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(sysImgView.right+13, 15, 100, 18)];
    [sysTitleLab setBackgroundColor:[UIColor clearColor]];
    [sysTitleLab setTextColor:kTextColorBlack];
    [sysTitleLab setFont:[UIFont systemFontOfSize:16.0f]];
    [sysTitleLab setTextAlignment:NSTextAlignmentLeft];
    [sysTitleLab setLineBreakMode:NSLineBreakByWordWrapping];
    [sysTitleLab setText:@"系统消息"];
    [sysMessage addSubview:sysTitleLab];
    
    //消息
    newMsgLab = [[UILabel alloc] initWithFrame:CGRectMake(sysImgView.right+13, sysTitleLab.bottom+5, kScreenWidth-imgView.right - 50, 18)];
    [newMsgLab setBackgroundColor:[UIColor clearColor]];
    [newMsgLab setTextColor:kTextColorGray];
    [newMsgLab setFont:[UIFont systemFontOfSize:12.0f]];
    [newMsgLab setTextAlignment:NSTextAlignmentLeft];
    [newMsgLab setLineBreakMode:NSLineBreakByWordWrapping];
    [newMsgLab setText:@""];
    [sysMessage addSubview:newMsgLab];
    
    UIImageView *newMsgMore = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 20, sysTitleLab.bottom-5, 8, 13)];
    newMsgMore.image = [UIImage imageNamed:@"more_gray"];
    [sysMessage addSubview:newMsgMore];
    
    UIImageView *sysline = [[UIImageView alloc] initWithFrame:CGRectMake(15.0f, 64.0f, kScreenWidth-15.0f, 1.0f)];
    [sysline setBackgroundColor:kBorderColorGray];
    [sysMessage addSubview:sysline];
    
    //数量
    NSDictionary *msgDic = [[NSUserDefaults standardUserDefaults] objectForKey:kRefreshNewUnreadMessageCount]; //先取缓存数据
    int tempSysCountBg = 18;
    NSString *tempSysCount ;
    if ([msgDic[@"sys_change"] intValue] > 99) {
        tempSysCountBg = 25;
        tempSysCount = [NSString stringWithFormat:@"%@+",msgDic[@"sys_change"]];
    }else{
        tempSysCount = [NSString stringWithFormat:@"%@",msgDic[@"sys_change"]];
    }
    countBg = [[UIImageView alloc] initWithFrame:CGRectMake(sysImgView.right-15,sysImgView.top,tempSysCountBg,18)];
    UIImage *img=[UIImage imageNamed:@"msgCountBg"];
    [countBg setImage:[img stretchableImageWithLeftCapWidth:9 topCapHeight:9]];
    [countBg setBackgroundColor:[UIColor clearColor]];
    [countBg setHidden:YES];
    [sysMessage addSubview:countBg];

    countLab = [[UILabel alloc] initWithFrame:CGRectMake(0,1.5,tempSysCountBg,15)];
    [countLab setBackgroundColor:[UIColor clearColor]];
    [countLab setTextColor:kTextColorWhite];
    [countLab setFont:[UIFont systemFontOfSize:12.0f]];
    [countLab setTextAlignment:NSTextAlignmentCenter];
    [countLab setLineBreakMode:NSLineBreakByWordWrapping];
    [countLab setText:tempSysCount];
    [countBg addSubview:countLab];

    //时间
    timeLab = [[UILabel alloc] initWithFrame:CGRectMake(newMsgMore.left-110, sysTitleLab.top, 100, 20)];
    [timeLab setBackgroundColor:[UIColor clearColor]];
    [timeLab setTextColor:kTextColorGray];
    [timeLab setFont:[UIFont systemFontOfSize:14.0f]];
    [timeLab setTextAlignment:NSTextAlignmentRight];
    [timeLab setLineBreakMode:NSLineBreakByWordWrapping];
    [timeLab setHidden:YES];
    [sysMessage addSubview:timeLab];
    
    
    _table = [[JYMessageTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavigationBarHeight-kTabBarViewHeight) style:UITableViewStylePlain];
    [_table setRowHeight:65];
    [_table setTableHeaderView:headerView];
    [_table setRefreshFooterDelegate:self];
//    [_table setRefreshDelegate:self];
    [_table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_table];
    
    [self requestGetAllChatMsgList];
}

//我的群组点击
- (void)myGroupBtnClick:(UIButton *) btn{
    JYMyGroupController *myGroupController = [[JYMyGroupController alloc] init];
    [self.navigationController pushViewController:myGroupController animated:YES];
}

//系统消息点击
- (void)msgSysBtnClick:(UIButton *)btn
{
    //系统消息
    JYSysMsgController *sysMsgController = [[JYSysMsgController alloc] init];
    [self.navigationController pushViewController:sysMsgController animated:YES];
    
 
}


- (void)socketReceiveChatMsg:(NSNotification *)notification
{
    NSString * myuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    
     NSDictionary *msgDic = [[[NSUserDefaults standardUserDefaults] objectForKey:kRefreshNewUnreadMessageCount] mutableCopy];
    JYChatModel *chatModel = [notification.userInfo objectForKey:@"model"];
   
    if (chatModel.isGroup) {
        
        BOOL isNoExist = YES; //如果不存在数据，插入一条新的
        for (int i = 0; i<_msgList.count; i++) {
            JYMessageModel *msgModel = (JYMessageModel *)[_msgList objectAtIndex:i];
            if ([msgModel.group_id isEqualToString:chatModel.groupId]) {
                
                isNoExist = NO;
                if ([msgModel.group_id integerValue] == [currentSelectUid integerValue] || [msgModel.hint intValue] == 1 || [chatModel.fromUid isEqualToString:myuid ]) {
                    msgModel.newcount = @"0";
                }else{
                    [msgDic setValue:[NSString stringWithFormat:@"%d", [msgDic[@"unread_chat"] intValue]+1] forKey:@"unread_chat"];
                    [[NSUserDefaults standardUserDefaults] setObject:msgDic forKey:kRefreshNewUnreadMessageCount];
                    msgModel.newcount = [NSString stringWithFormat:@"%d", [msgModel.newcount intValue]+1];
                }
                msgModel.content  = chatModel.chatMsg;
                msgModel.sendtime = chatModel.time;
                msgModel.msgtype = chatModel.msgType;
                [[JYChatDataBase sharedInstance] updateGroupChatFriendLastTimer:chatModel.time group_id:chatModel.groupId content:chatModel.chatMsg msgType:chatModel.msgType];
                break;
            }
        }
        
        if(isNoExist){
            NSMutableDictionary *msgDic = [[JYChatDataBase sharedInstance] getOneUser:chatModel.groupId type:2];
            JYMessageModel *msgModel = [[JYMessageModel alloc] init];
            msgModel.oid = @"0";
            msgModel.avatar = [JYHelpers stringValueWithObject:[msgDic objectForKey:@"avatar"]];
            msgModel.content = chatModel.chatMsg;
            msgModel.hint = [JYHelpers stringValueWithObject:[msgDic objectForKey:@"hint"]];
            msgModel.logo = chatModel.logo;
            msgModel.iid = @"";
            msgModel.group_id = chatModel.groupId;
            msgModel.msgtype = chatModel.msgType;
            if ([[msgDic objectForKey:@"hint"] intValue] ==1) {
                msgModel.newcount = @"0";
            }else{
                msgModel.newcount = @"1";
            }
            
            msgModel.nick = @"";
            msgModel.sendtime = [JYHelpers currentDateTimeInterval];
            msgModel.sex = @"";
            msgModel.status = @"";
            msgModel.title = chatModel.title;
            [[JYChatDataBase sharedInstance] insertOneUser:msgModel]; //插入本地数据库
            [[JYShareData sharedInstance].messageUserList addObject:msgModel]; //更新共享数据列表
        }
        
    } else {
        BOOL isNoExist = YES;
        for (int i = 0; i<_msgList.count; i++) {
            JYMessageModel *msgModel = (JYMessageModel *)[_msgList objectAtIndex:i];
            if ([msgModel.oid isEqualToString:chatModel.fromUid] && [JYHelpers isEmptyOfString:msgModel.group_id]) {
                isNoExist = NO;
                if ([msgModel.oid integerValue] == [currentSelectUid integerValue]|| [msgModel.hint intValue] == 1 || [chatModel.fromUid isEqualToString:myuid ]) {
                    msgModel.newcount = @"0";
                }else{
                    msgModel.newcount = [NSString stringWithFormat:@"%d", [msgModel.newcount intValue]+1];
                    [msgDic setValue:[NSString stringWithFormat:@"%d", [msgDic[@"unread_chat"] intValue]+1] forKey:@"unread_chat"];
                    [[NSUserDefaults standardUserDefaults] setObject:msgDic forKey:kRefreshNewUnreadMessageCount];
                }
                msgModel.content  = chatModel.chatMsg;
                msgModel.sendtime = chatModel.time;
                msgModel.msgtype = chatModel.msgType;
                [[JYChatDataBase sharedInstance] updateChatFriendLastTimer:chatModel.time oid:chatModel.fromUid content:chatModel.chatMsg msgType:chatModel.msgType];
                break;
            }
        }
        
        if(isNoExist){
            JYMessageModel *msgModel = [[JYMessageModel alloc] init];
            msgModel.oid = chatModel.fromUid;
            msgModel.avatar = chatModel.avatar;
            msgModel.content = chatModel.chatMsg;
            msgModel.hint = @"";
            msgModel.logo = chatModel.avatar;
            msgModel.iid = @"";
            msgModel.group_id = @"";
            msgModel.msgtype = chatModel.msgType;
            msgModel.newcount = @"1";
            msgModel.nick = chatModel.nick;
            msgModel.sendtime = [JYHelpers currentDateTimeInterval];
            msgModel.sex = @"";
            msgModel.status = @"";
            msgModel.title = chatModel.chatMsg;
            [[JYChatDataBase sharedInstance] insertOneUser:msgModel]; //插入本地数据库
            [[JYShareData sharedInstance].messageUserList addObject:msgModel]; //更新共享数据列表
        }
        
    }
    

    //刷新tabbar的数字
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshTabBarUnreadNumberNotification object:nil];
    [self refreshMessageTableView];
}

#pragma mark - request

- (void)requestGetAllChatMsgList
{
    _pageIndex++;
    
    NSMutableArray * resultArr = [[JYChatDataBase sharedInstance] getListUser:_pageIndex];
    if (resultArr.count > 0) {
        [_msgList removeAllObjects];
        for (int i=0; i<resultArr.count; i++) {
            NSDictionary *infoDict = [resultArr objectAtIndex:i];
            JYMessageModel *msgModel = [[JYMessageModel alloc] initWithDataDic:infoDict];
            [_msgList addObject:msgModel];
        }

        [_table setIsMore:NO];
        if (resultArr.count == _pageIndex * 10) { //_pageIndex *10是表示 页数乘以每页的个数
            [_table setIsMore:YES];
        }else{
            _pageIndex --;
        }
        if(_msgList.count < 10) {
            [_table showOrHiddenTextView:@"" showOrHidden:YES];
            //[_table setIsMore:NO];
        }

        [_table setData:_msgList];
        [_table reloadData];
    }
    
}

- (void) fromHttpGetUserList{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"msg" forKey:@"mod"];
    [parametersDict setObject:@"get_all_chat_msg_list" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:[NSString stringWithFormat:@"%ld", (long)_pageIndex] forKey:@"page"];
    [postDict setObject:@"200" forKey:@"avatarSize"];
    [postDict setObject:@"0" forKey:@"type"];
    [postDict setObject:@"10" forKey:@"pageSize"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1 && [[responseObject objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
            
            NSArray *dataList = [responseObject objectForKey:@"data"];
            if (dataList.count > 0) {
                for (int i=0; i<dataList.count; i++) {
                    NSDictionary *infoDict = [dataList objectAtIndex:i];
                    JYMessageModel *msgModel = [[JYMessageModel alloc] initWithDataDic:infoDict];
                    if ([msgModel.group_id integerValue] >0 && [msgModel.hint intValue] == 1) {
                        msgModel.newcount = @"0";
                    }
                    [[JYChatDataBase sharedInstance] insertOneUser:msgModel];
                    
                    JYChatModel *chatModel = [[JYChatModel alloc] init];
                    chatModel.iid = msgModel.iid;
                    chatModel.msgType = msgModel.msgtype;
                    chatModel.avatar = msgModel.avatar;
                    chatModel.logo = msgModel.logo;
                    chatModel.chatMsg = msgModel.content;
                    chatModel.fromUid = msgModel.oid;
                    chatModel.nick = msgModel.nick;
                    chatModel.title = msgModel.title;
                    chatModel.sex = msgModel.sex;
                    chatModel.time = msgModel.sendtime;
                    chatModel.sendStatus = @"2";
                    chatModel.readStatus = @"0";
                    chatModel.sendType = msgModel.type;
                    chatModel.ext = msgModel.ext;
                    if ([msgModel.msgtype intValue] == 2 || [msgModel.msgtype intValue] == 4) {
                        chatModel.fileUrl = infoDict[@"ext"][@"voice"];
                        chatModel.voiceLength = infoDict[@"ext"][@"dur"];
                    }else if([msgModel.msgtype intValue] == 3 || [msgModel.msgtype intValue] == 5) {
                        chatModel.fileUrl = infoDict[@"ext"][@"voice"];
//                        chatModel.voiceLength = @"0";
                        chatModel.fileUrl = infoDict[@"ext"][@"pic200"];
                        
                    }
                    if (msgModel.group_id) {
                        
                        chatModel.groupId = msgModel.group_id;
                        chatModel.isGroup = YES;
                        
                        [[JYChatDataBase sharedInstance] insertOneChatMsgIntoGroupChatLogWithModel:chatModel];
                    }else{
                        chatModel.groupId = @"";
                        chatModel.isGroup = NO;
                        [[JYChatDataBase sharedInstance] insertOneChatMsgIntoChatLogWithModel:chatModel];
                    }
                    
                }
                [self requestGetAllChatMsgList];
            }
        } else {
            
        }
        
    } failure:^(id error) {
        
        //        [_table doneLoadingTableViewData];
        
    }];
}
#pragma mark - FooterTableViewDelegate

//上拉加载更多
- (void)pullUp:(JYBaseFooterTableView *)tableView
{
    [self requestGetAllChatMsgList];
    [self fromHttpGetUserList];
}

// 选中事件
- (void)didSelectRowAtIndexPath:(JYBaseFooterTableView *)tabelView indexPath:(NSIndexPath *)indexPath
{
    JYChatController *chatController = [[JYChatController alloc] init];
    JYMessageModel *msgModel = [_msgList objectAtIndex:indexPath.row];
    msgModel.newcount = @"0"; //数字清0
//    [msgModel setCount:@"0"];
    if ([msgModel.group_id integerValue] >0) {
        currentSelectUid = msgModel.group_id ;
        
        JYMyGroupModel *groupModel = [[JYMyGroupModel alloc] init];
        groupModel.friend_num = @"0";
        groupModel.group_id = msgModel.group_id;
        groupModel.hint = @"0";
        groupModel.intro = @"";
        groupModel.logo = msgModel.avatar;
        groupModel.show = @"0";
        groupModel.title = msgModel.title;
        groupModel.total = @"0";
        [chatController setIsGroupChat:YES];
        [chatController setFromGroupModel:groupModel];
        
        //数据库中的数字也清0
        [[JYChatDataBase sharedInstance] clearGroupUserUnreadCount:msgModel.group_id];
    } else {
        currentSelectUid = msgModel.oid ;
        [chatController setFromUid:msgModel.oid];
        [chatController setIsGroupChat:NO];
        [chatController setFromMsgModel:msgModel];
        
        //数据库中的数字也清0
        [[JYChatDataBase sharedInstance] clearNormalUserUnreadCount:msgModel.oid];
    }
    
    [self.navigationController pushViewController:chatController animated:YES];
}

//获取最新的聊天数
- (void)getSysMsgCount{
    
    NSDictionary *msgDic = [[NSUserDefaults standardUserDefaults] objectForKey:kRefreshNewUnreadMessageCount]; //先取缓存数据
    
    if ([msgDic[@"sys_change"] intValue] > 0) {
        countBg.hidden = NO;
        countLab.hidden = NO;
    }else{
        countBg.hidden = YES;
        countLab.hidden = YES;
    }
    
    int tempSysCountBg = 18;
    if ([msgDic[@"sys_change"] intValue] > 99) {
        tempSysCountBg = 25;
        countLab.text = [NSString stringWithFormat:@"%@+",msgDic[@"sys_change"]];
    }else{
        countLab.text = [NSString stringWithFormat:@"%@",msgDic[@"sys_change"]];
    }
    
    if ([msgDic[@"sys_change"] intValue] >0) {
        [newMsgLab setText:@"新的系统消息"];
        [timeLab setHidden: NO];
    }else{
        [newMsgLab setText:@""];
        [timeLab setHidden: YES];
    }
    countBg.width = tempSysCountBg;
    countLab.width = tempSysCountBg;
    if ([msgDic[@"sys_time"] integerValue] > 0) {
        timeLab.text = [JYHelpers unixToDate:[msgDic[@"sys_time"] integerValue]];
    }
    
//    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
//    [parametersDict setObject:@"msg" forKey:@"mod"];
//    [parametersDict setObject:@"countnew" forKey:@"func"];
//    
//    [JYHttpServeice requestWithParameters:parametersDict postDict:nil httpMethod:@"POST" success:^(id responseObject) {
//        
//        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
//        
//        if (iRetcode == 1 && [[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
//            
//            NSDictionary *dic = [responseObject objectForKey:@"data"];
//            if ([dic[@"sys_change"] intValue] > 0) {
//                [countBg setHidden:NO];
//                if ([dic[@"sys_change"] intValue] > 99) {
//                    countBg.width = 25;
//                    countLab.width = 25;
//                    countLab.text = [NSString stringWithFormat:@"%@+",dic[@"sys_change"]];
//                    
//                }else{
//                    countLab.text = [NSString stringWithFormat:@"%@",dic[@"sys_change"]];;
//                }
//            }
//            
//            if ([dic[@"sys_time"] integerValue] > 0) {
//                NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[dic[@"sys_time"] integerValue]];
//                timeLab.text = [JYHelpers compareCurrentTime:confromTimesp];
//            }
//
//        }
//        
//    } failure:^(id error) {
//        
//        //        [_table doneLoadingTableViewData];
//        
//    }];
    
}

//获取最新的群组数
- (void)getMyGroupCount{
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"chat" forKey:@"mod"];
    [parametersDict setObject:@"count_group" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] forKey:@"uid"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:nil httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        
        if (iRetcode == 1 ) {
            
            NSString *num = [responseObject objectForKey:@"data"];
            [msgLab setText:[NSString stringWithFormat:@"共有%d个群组",[num intValue]] ];
        }
        
    } failure:^(id error) {
        
        
    }];
    
}
- (void) PushServiceChatMsg{
    [self getSysMsgCount]; //获取系统消息数
    [self getMyGroupCount]; //获取群组数
    [_table reloadData];
}

- (void) refreshMessageTableView{
//    _msgList = [JYShareData sharedInstance].messageUserList ;
    //排序
    for (int i= 0; i<_msgList.count-1; i++) {
        JYMessageModel *iModel = (JYMessageModel *)_msgList[i] ;
        for (int j = i+1; j<_msgList.count; j++) {
            JYMessageModel *jModel = (JYMessageModel *)_msgList[j] ;
            if ([iModel.sendtime integerValue] < [jModel.sendtime integerValue]) {
                JYMessageModel *tempModel = iModel;
                [_msgList replaceObjectAtIndex:i withObject:jModel];
                [_msgList replaceObjectAtIndex:j withObject:tempModel];
            }
        }
    }
    _table.data = _msgList;
    [_table reloadData];
}

- (void) deleteOneMessageUserNotification:(NSNotification *)noti{
    NSString * oid = [noti.userInfo objectForKey:@"oid"];
    NSString * group_id = [noti.userInfo objectForKey:@"group_id"];
    if ([group_id integerValue] > 0) {
        if ([deleteOneMessageUserTag isEqualToString:[JYHelpers currentDateTimeInterval]]) {
            return;
        }
        DeleteSuccessCallBackBlock block = [noti.userInfo objectForKey:@"callBackBlock"];
        block(oid,group_id);
        [self deleteUserClearWebCache:group_id];
        deleteOneMessageUserTag = [JYHelpers currentDateTimeInterval];
    }else{
        if ([deleteOneMessageUserTag isEqualToString:[JYHelpers currentDateTimeInterval]]) {
            return;
        }
        deleteOneMessageUserTag = [JYHelpers currentDateTimeInterval];
        NSLog(@"delete-oid:%@",oid);
        NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
        [parametersDict setObject:@"msg" forKey:@"mod"];
        [parametersDict setObject:@"del_contact" forKey:@"func"];
        NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
        [postDict setObject:oid forKey:@"oid"];
        
        [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
            
            NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
            if (iRetcode == 1 ) {
                
                DeleteSuccessCallBackBlock block = [noti.userInfo objectForKey:@"callBackBlock"];
                block(oid,group_id);
            }
            
        } failure:^(id error) {
            [[JYAppDelegate sharedAppDelegate] showTip:@"删除失败"];
            //        [_table doneLoadingTableViewData];
            
        }];
    }
    
}

- (void) deleteUserClearWebCache:(NSString * )group_id {
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"msg" forKey:@"mod"];
    [parametersDict setObject:@"clear_cache_gid" forKey:@"func"];
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:group_id forKey:@"group_id"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1 ) {
            
           
            
        }
        
    } failure:^(id error) {
        //        [_table doneLoadingTableViewData];
        
    }];
}

@end
