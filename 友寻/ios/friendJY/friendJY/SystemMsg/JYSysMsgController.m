//
//  JYSysMsgController.m
//  friendJY
//
//  Created by 高斌 on 15/4/14.
//  Copyright (c) 2015年 高斌. All rights reserved.
//
#import "JYHttpServeice.h"
#import "JYSysMsgController.h"
#import "JYSysMsgModel.h"
#import "JYOtherProfileController.h"
#import "JYProfileController.h"
#import "JYMsgUpdate.h"
#import "JYChatController.h"
#import "JYSysMsgHaveReadViewController.h"
#import "JYProfileDownImagePraiseManager.h"
#import "JYImagePraiseView.h"
#import "SDPhotoBrowser.h"
#import "JYShareData.h"

@interface JYSysMsgController (){
    JYSysMsgTableView *msgTable;
    NSMutableArray *msgList;
    UIButton *navRightBtn;
    int pageIndex;
    
    UILabel * noDataLayer;
    
    UIView *imageViewBox;
    UIImageView * showImage;
    NSString * currentPid;
    NSString * currentShowBigImageUrl;
    
    BOOL picShowStatus;
}

@end

@implementation JYSysMsgController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"系统消息"];
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    msgList = [NSMutableArray array];
    pageIndex = 1;
    
    // Do any additional setup after loading the view.
    msgTable = [[JYSysMsgTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight-kStatusBarHeight)];
    
    msgTable.refreshFooterDelegate = self;
    msgTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    msgTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:msgTable];
    
    noDataLayer = [[UILabel alloc] initWithFrame:CGRectMake(0, (kScreenHeight - kNavigationBarHeight - kStatusBarHeight -kTabBarViewHeight - 20)/2, kScreenWidth, 20)];
    noDataLayer.backgroundColor = [UIColor clearColor];
    noDataLayer.textAlignment = NSTextAlignmentCenter;
    noDataLayer.textColor = kTextColorGray;
    noDataLayer.font = [UIFont systemFontOfSize:14.f];
    noDataLayer.text = @"暂无消息";
    [self.view addSubview:noDataLayer];
    
    [self requestSysMsgList];
    
    imageViewBox = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth - 50)/2, (kScreenHeight - 50)/2, 50, 50)];
    imageViewBox.backgroundColor = [UIColor redColor];
    imageViewBox.hidden = YES;
    [self.view addSubview:imageViewBox];
    
    showImage = [[UIImageView alloc] initWithFrame:imageViewBox.bounds];
    showImage.image = [UIImage imageNamed:@"defalt_pic_show_bg"];
    [imageViewBox addSubview:showImage];
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

- (void)requestSysMsgList
{
    [self showProgressHUD:@"加载中..." toView:self.view];
    //http://c.friendly.dev/cmiajax/?mod=msg&func=listsys&pageSize=20&autostatus=0&type=sys&avatarSize=100&status=0&page=1
    //http://c.friendly.dev/cmiajax/?mod=msg&func=listsys&autostatus=0&reg_meid=353771057483744&reg_version=1.0.4&avatarSize=100&status=1&page=1&reg_mtype=android&pageSize=20&reg_channel_id=100&type=sys
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"msg" forKey:@"mod"];
    [parametersDict setObject:@"listsys" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:@"20" forKey:@"pageSize"];
    [postDict setObject:@"0" forKey:@"autostatus"];
    [postDict setObject:@"sys" forKey:@"type"];
    [postDict setObject:@"100" forKey:@"avatarSize"];
    [postDict setObject:@"0" forKey:@"status"];
    [postDict setObject:UUID forKey:@"reg_meid"];
    [postDict setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey] forKey:@"reg_version"];
    [postDict setObject:@"100" forKey:@"reg_channel_id"];
    [postDict setObject:@"ios" forKey:@"reg_mtype"];
    [postDict setObject:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"page"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject)
    {
        [self dismissProgressHUDtoView:self.view];
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1 && [[responseObject objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
            
            NSArray *dataList = [responseObject objectForKey:@"data"];
            
//            if (dataList.count == 0) {
//                
//                return ;
//            }
            
            //右上角添加动态
            navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            navRightBtn.backgroundColor = [UIColor clearColor];
            [navRightBtn setFrame:CGRectMake(0, 0, 55, 20)];
            [navRightBtn setTitle:@"全部忽略" forState:UIControlStateNormal];
            [navRightBtn setTitleColor:[JYHelpers setFontColorWithString:@"#2695ff"] forState:UIControlStateNormal];
            
            navRightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            navRightBtn.titleLabel.font = [UIFont systemFontOfSize: 13.0];
            [navRightBtn addTarget:self action:@selector(_clickRightTopButton) forControlEvents:UIControlEventTouchUpInside];
            //已读
            UIButton *navRightBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
            navRightBtn2.backgroundColor = [UIColor clearColor];
            [navRightBtn2 setFrame:CGRectMake(0, 0, 30, 20)];
            [navRightBtn2 setTitle:@"已读" forState:UIControlStateNormal];
            [navRightBtn2 setTitleColor:[JYHelpers setFontColorWithString:@"#2695ff"] forState:UIControlStateNormal];
            navRightBtn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            navRightBtn2.titleLabel.font = [UIFont systemFontOfSize: 13.0];
            [navRightBtn2 addTarget:self action:@selector(HaveReadClick) forControlEvents:UIControlEventTouchUpInside];
            
            //[self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:navRightBtn]];
            [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithCustomView:navRightBtn2],[[UIBarButtonItem alloc] initWithCustomView:navRightBtn], nil]];
            
            int clearNumber = 0;
            for (NSDictionary *dict in dataList) {
                
                JYSysMsgModel *groupModel = [[JYSysMsgModel alloc] initWithDataDic:dict];
                groupModel.acceptType = @"-1";
                [msgList addObject:groupModel];
                if ([groupModel.type intValue] != 11 && [groupModel.type intValue] != 23) {
                    [self _msgReadOnMessage:groupModel.iid type:[groupModel.type intValue]];
                    clearNumber ++;
                }
            }
            
            
            NSDictionary *msgDic = [[[NSUserDefaults standardUserDefaults] objectForKey:kRefreshNewUnreadMessageCount] mutableCopy];
            [msgDic setValue:[NSString stringWithFormat:@"%d",[msgDic[@"sys_change"] intValue]-clearNumber ] forKey:@"sys_change"];
            [[NSUserDefaults standardUserDefaults] setObject:msgDic forKey:kRefreshNewUnreadMessageCount];
            //刷新tabbar的数字
            [[JYMsgUpdate sharedInstance] getSysMsgCount];
            
            if (msgList.count > 0 ) {
                noDataLayer.hidden = YES; //隐藏无数据提示层
            }
            
            if(dataList.count==0){//
                
                navRightBtn.enabled = NO;
                navRightBtn.hidden = YES;
            }else{
                navRightBtn.enabled = YES;
                navRightBtn.hidden = NO;
            }
            [msgTable setIsMore :YES];
            if (dataList.count <20) {
                [msgTable setIsMore :NO];
            }
            if(msgList.count < 20) {
                [msgTable showOrHiddenTextView:@"" showOrHidden:YES];
                //[_table setIsMore:NO];
            }

            msgTable.data = msgList;
            [msgTable reloadData];
            
        } else {
            
        }
        
    } failure:^(id error) {
        
        
    }];
}
- (void)HaveReadClick{
    JYSysMsgHaveReadViewController *ctrl = [[JYSysMsgHaveReadViewController alloc]init];
    [self.navigationController pushViewController:ctrl animated:YES];
}

// 上拉事件
- (void)pullUp:(JYBaseFooterTableView *)tableView{
//    if (msgList.count<10) {
        pageIndex ++;
        [self requestSysMsgList];
//    }
    
}

- (void)_clickRightTopButton{
    [self showProgressHUD:@"发送中..." toView:self.view];
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"msg" forKey:@"mod"];
    [parametersDict setObject:@"set_onread_allsysmsg" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:@"sys" forKey:@"type"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1 ) {
            //系统未读清0
            NSDictionary *msgDic = [[[NSUserDefaults standardUserDefaults] objectForKey:kRefreshNewUnreadMessageCount] mutableCopy];
            [msgDic setValue:@"0" forKey:@"sys_change"];
            [[NSUserDefaults standardUserDefaults] setObject:msgDic forKey:kRefreshNewUnreadMessageCount];
            [self dismissProgressHUDtoView:self.view];
            [self.navigationController popViewControllerAnimated:YES];
            
            [[JYMsgUpdate sharedInstance] getSysMsgCount];
            
        } else {
            
        }
        
    } failure:^(id error) {
        
        
    }];
}

// 选中事件
- (void)didSelectRowAtIndexPath:(JYBaseFooterTableView *)tabelView indexPath:(NSIndexPath *)indexPath{
    JYSysMsgModel * model = msgList[indexPath.row];
    switch (([model.type intValue]) ) {
        case 11:// 申请加入群消息
        case 12:// 退群消息
        case 23:// 好友申请
        case 24:// 新好友加入
        {
            JYOtherProfileController * _profileVC = [[JYOtherProfileController alloc] init];
            _profileVC.show_uid = [NSString stringWithFormat:@"%@",model.uid];
            [self.navigationController pushViewController:_profileVC animated:YES];
        }
            break;
        case 13:// 同意加入群,点击进群聊，还没有做
        {
            JYChatController *chatController = [[JYChatController alloc] init];
                JYMyGroupModel *groupModel = [[JYMyGroupModel alloc] init];
                groupModel.friend_num = @"0";
                groupModel.group_id = model.group_id;
                groupModel.hint = @"0";
                groupModel.intro = @"";
                groupModel.logo = model.avatars;
                groupModel.show = @"0";
                groupModel.title = model.title;
                groupModel.total = @"0";
                [chatController setIsGroupChat:YES];
                [chatController setFromGroupModel:groupModel];
            
            [self.navigationController pushViewController:chatController animated:YES];
        }
            break;
        case 22:// 别人给我打标签
        {
            JYProfileController * _profileVC = [[JYProfileController alloc] init];
            [self.navigationController pushViewController:_profileVC animated:YES];
        }
            break;
        case 25:// 照片点赞
        {
            if (!picShowStatus) {
                JYSysMsgModel *myModel = [msgList objectAtIndex:indexPath.row];
                [self _gotoLikePhoto:myModel.pid];
                currentPid = myModel.pid;
                currentShowBigImageUrl = myModel.photolists[myModel.pid][@"800"];
                picShowStatus = NO;
            }
        }
            break;
        default:
            return;
    }
    
}

//不带操作的消息条，直接设为已读
- (void) _msgReadOnMessage:(NSString *)iid type:(int)type{
    NSString * typeString ;
    switch (type) {
        case 11:
            typeString = @"addgroup";
            break;
        case 12:
            typeString = @"qtgroup";
            break;
        case 13:
            typeString = @"accept";
            break;
        case 14:
            typeString = @"reject";
            break;
        case 15:
            typeString = @"del";
            break;
        case 21:
            typeString = @"friendaddtags";
            break;
        case 22:
            typeString = @"ownaddtags";
            break;
        case 23:
            typeString = @"addfriend";
            break;
        case 24:
            typeString = @"newfriend";
            break;
        case 25:
            typeString = @"likepic";
            break;
    }
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"msg" forKey:@"mod"];
    [parametersDict setObject:@"set_onread" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:typeString forKey:@"type"];
    [postDict setObject:iid forKey:@"iid"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1 ) {
        } else {
            
        }
        
    } failure:^(id error) {
        
        
    }];
}

- (void) _gotoLikePhoto:(NSString *)pid {
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"photo" forKey:@"mod"];
    [parametersDict setObject:@"is_exist_photo" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:pid forKey:@"pid"];
    
        [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
    
            NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
            if (iRetcode == 1 ) {
                [self DownloadPhotoCommendData:pid];
            } else {
    
            }
    
        } failure:^(id error) {
            
            
        }];
}


//获取图片评论的数据
- (void)DownloadPhotoCommendData:(NSString *)pid{
    [JYProfileDownImagePraiseManager DownImagePraiseDate:@{pid:pid} andSucceedBlock:^(NSMutableDictionary *PraseDict){
        NSMutableArray *imagePraseData = [[NSMutableArray alloc]init];
        for (NSString *key in PraseDict) {
            NSDictionary *dict = PraseDict[key][@"data"];
            JYImagePraiseModel *model = [[JYImagePraiseModel alloc]init];
            model.count = [NSString stringWithFormat:@"%@",dict[@"count"]];
            if (dict[@"list"] && [dict[@"list"]isKindOfClass:[NSDictionary class]]) {
                model.list = [dict[@"list"] mutableCopy];
            }else{
                NSMutableDictionary *mDict = [[NSMutableDictionary alloc]init];
                model.list = mDict;
            }
            model.pid = [NSString stringWithFormat:@"%@",dict[@"pid"]];
            [imagePraseData addObject:model];
        }
        
        SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
        browser.imagePraiseData = imagePraseData;
        browser.sourceImagesContainerView = imageViewBox;// [self viewWithTag:gesture.view.tag]; // 原图的父控件
        browser.imageCount = 1; // 图片总数
        browser.currentImageIndex = 0;
        browser.fuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
//        [browser setFromSelf:YES];
        [browser setTag:4321];
        
        [browser setShareContent:[NSString stringWithFormat:@"来自%@的友寻相册",[JYShareData sharedInstance].myself_profile_model.nick]];
        
        browser.delegate = self;
        [browser show];
    }];
}

#pragma mark - photobrowser代理方法

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return showImage.image;
    
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    //    NSDictionary  *photoes = userProfileModel.photoes;
    //    NSArray *photoesValue = [photoes allValues];
    return [NSURL URLWithString:currentShowBigImageUrl] ;
   
}

//返回当前图片的pid
- (NSString *)photoBrowserId:(SDPhotoBrowser *)browser pidForIndex:(NSInteger)index{
    

    return currentPid;
  
}

- (void)closedWindow:(SDPhotoBrowser *)browser closed:(BOOL)closed{
    picShowStatus = NO;
}

@end
