//
//  JYSysMsgHaveReadViewController.m
//  friendJY
//
//  Created by aaa on 15/6/11.
//  Copyright (c) 2015年 友寻. All rights reserved.
//

#import "JYSysMsgHaveReadViewController.h"
#import "JYSysMsgModel.h"
#import "JYChatController.h"
#import "JYOtherProfileController.h"
#import "JYProfileController.h"
#import "JYProfileDownImagePraiseManager.h"
#import "JYImagePraiseView.h"
#import "SDPhotoBrowser.h"
#import "JYShareData.h"

@interface JYSysMsgHaveReadViewController ()
{
    JYSysMsgTableView *msgTable;
    NSMutableArray *msgList;
    UIButton *navRightBtn;
    int pageIndex;
    UIView *imageViewBox;
    UIImageView * showImage;
    UILabel * noDataLayer;
    NSString * currentPid;
    NSString * currentShowBigImageUrl;
    BOOL picShowStatus;
}
@end

@implementation JYSysMsgHaveReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"已读消息"];
    
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
    
    
    imageViewBox = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth - 50)/2, (kScreenHeight - 50)/2, 50, 50)];
    imageViewBox.backgroundColor = [UIColor redColor];
    imageViewBox.hidden = YES;
    [self.view addSubview:imageViewBox];
    
    showImage = [[UIImageView alloc] initWithFrame:imageViewBox.bounds];
    showImage.image = [UIImage imageNamed:@"defalt_pic_show_bg"];
    [imageViewBox addSubview:showImage];
    
    [self requestSysMsgList];
}

- (void)requestSysMsgList
{
    [self showProgressHUD:@"加载中..." toView:self.view];
    //http://c.friendly.dev/cmiajax/?mod=msg&func=listsys&pageSize=20&autostatus=0&type=sys&avatarSize=100&status=0&page=1
    //http://c.friendly.dev/cmiajax/?mod=msg&func=listsys&autostatus=0&reg_meid=353771057483744&reg_version=1.0.4&avatarSize=100&status=1&page=1&reg_mtype=android&pageSize=20&reg_channel_id=100&type=sys
    //http://c.friendly.dev/cmiajax/?mod=msg&func=set_handled&reg_channel_id=100&reg_meid=353771057483744&reg_version=1.0.4&iid=3997250&reg_mtype=android&operate=3
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"msg" forKey:@"mod"];
    [parametersDict setObject:@"listsys" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:@"20" forKey:@"pageSize"];
    [postDict setObject:@"0" forKey:@"autostatus"];
    [postDict setObject:@"sys" forKey:@"type"];
    [postDict setObject:@"100" forKey:@"avatarSize"];
    [postDict setObject:@"1" forKey:@"status"];
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
             for (NSDictionary *dict in dataList) {
                 JYSysMsgModel *groupModel = [[JYSysMsgModel alloc] initWithDataDic:dict];
                 groupModel.acceptType = @"-1";
                 [msgList addObject:groupModel];
             }
             
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

// 上拉事件
- (void)pullUp:(JYBaseFooterTableView *)tableView{
    //    if (msgList.count<10) {
    pageIndex ++;
    [self requestSysMsgList];
    //    }
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
                picShowStatus = YES;
            }
            
        }
            break;
        default:
            return;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
