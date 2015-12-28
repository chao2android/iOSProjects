//
//  VideoDetialViewController.m
//  TestVideoJoiner
//
//  Created by MC on 14-12-3.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "VideoDetialViewController.h"
#import "IfGownBtn.h"
#import "VideoPlayView.h"
#import "NetImageView.h"
#import "MapLineViewController.h"
#import "PopCommentView.h"
#import "ThirdLoginViewController.h"
#import "ImageDownManager.h"
#import "RefreshTableView.h"
#import "JSON.h"
#import "CommentListModel.h"
#import "CommentListCell.h"
#import "NetVideoPlayView.h"
#import "ShareMethod.h"

@interface VideoDetialViewController ()<UITableViewDataSource, UITableViewDelegate, RefreshTableViewDelegate, UIActionSheetDelegate> {
    RefreshTableView *mTableView;
    NetVideoPlayView *mPlayView;
    NetImageView *mHeadView;
    UILabel *mlbNickName;
    UILabel *mlbTime;
    UILabel *mlbDesc;
    UILabel *mlbCount;
    UILabel *mlbName;
    UILabel *mlbAddress;
    int miPage;
}

@property (nonatomic, strong) ImageDownManager *mDownManager;
@property (nonatomic, strong) UIView *mDetailView;
@property (nonatomic, strong) NSMutableArray *mComments;

@end

@implementation VideoDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.mVideoModel.title;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReloadList:) name:kMsg_RefreshComment object:nil];
    
    [self AddLeftImageBtn:[UIImage imageNamed:@"3_03.png"] target:self action:@selector(GoBack)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.mComments = [[NSMutableArray alloc] initWithCapacity:10];
    
    [self AddDetailView];
    
    mTableView = [[RefreshTableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeigh-130)];
    mTableView.delegate = self;
    mTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mTableView];

    UIImageView *botView = [[UIImageView alloc]initWithFrame:CGRectMake(2, KscreenHeigh - 130, KscreenWidth-4, 179)];
    botView.backgroundColor = [UIColor clearColor];
    botView.image = [UIImage imageNamed:@"p_havegoback"];
    botView.userInteractionEnabled = YES;
    [self.view addSubview:botView];
    
    int iWidth = 110;

    IfGownBtn *iBtn = [[IfGownBtn alloc]initWithFrame:CGRectMake(0, 0, iWidth, 66)];
    iBtn.delegate = self;
    iBtn.OnViewClick = @selector(WantGo);
    [iBtn loadView:@"f_wantgolarge" :@"要去" :YES];
    [botView addSubview:iBtn];
    
    iBtn = [[IfGownBtn alloc]initWithFrame:CGRectMake(botView.frame.size.width-iWidth, 0, iWidth, 66)];
    iBtn.delegate = self;
    iBtn.OnViewClick = @selector(HaveGown);
    [iBtn loadView:@"f_havegolarge" :@"去过" :NO];
    [botView addSubview:iBtn];
    
    [self ReloadList:mTableView];
}

- (void)AddDetailView {
    self.mDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeigh)];
    
    int iTop = 0;
    int iHeight = 0;
    mPlayView = [[NetVideoPlayView alloc] initWithFrame:CGRectMake(0, iTop, KscreenWidth, KscreenWidth*3/4)];
    mPlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_mDetailView addSubview:mPlayView];

    [mPlayView PlayVideo:self.mVideoModel.src];
    
    iHeight += mPlayView.frame.size.height;
    
    iTop = iHeight+12+30;
    mHeadView = [[NetImageView alloc]initWithFrame:CGRectMake(15, iTop, 40, 40)];
    mHeadView.mDefaultImage = [UIImage imageNamed:@"default_avatar"];
    mHeadView.layer.masksToBounds = YES;
    mHeadView.layer.cornerRadius = 20;
    [_mDetailView addSubview:mHeadView];
    [mHeadView GetImageByStr:self.mVideoModel.avater];
    
    iTop += 6;
    
    mlbNickName = [[UILabel alloc] initWithFrame:CGRectMake(61, iTop, 200, 14)];
    mlbNickName.backgroundColor = [UIColor clearColor];
    mlbNickName.textAlignment = NSTextAlignmentLeft;
    mlbNickName.textColor = [UIColor grayColor];
    mlbNickName.text = self.mVideoModel.nickname;
    mlbNickName.font = [UIFont systemFontOfSize:13];
    [_mDetailView addSubview:mlbNickName];
    
    iTop += 18;
    
    mlbTime = [[UILabel alloc] initWithFrame:CGRectMake(61, iTop, 100, 14)];
    mlbTime.backgroundColor = [UIColor clearColor];
    mlbTime.textAlignment = NSTextAlignmentLeft;
    mlbTime.textColor = [UIColor grayColor];
    mlbTime.text = [UserInfoManager GetFormatDateByInterval:[self.mVideoModel.create_time floatValue]];
    mlbTime.font = [UIFont systemFontOfSize:10];
    [_mDetailView addSubview:mlbTime];
    
    iTop += 30;
    
    NSDictionary *attribute = @{ NSFontAttributeName:[UIFont systemFontOfSize:14] };
    CGSize size = [self.mVideoModel.content boundingRectWithSize:CGSizeMake(_mDetailView.frame.size.width-140, 100) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    mlbDesc = [[UILabel alloc] initWithFrame:CGRectMake(15, iTop, size.width, size.height)];
    mlbDesc.backgroundColor = [UIColor clearColor];
    mlbDesc.textAlignment = NSTextAlignmentLeft;
    mlbDesc.textColor = [UIColor grayColor];
    mlbDesc.numberOfLines = 2;
    mlbDesc.lineBreakMode = NSLineBreakByWordWrapping;
    mlbDesc.text = self.mVideoModel.content;
    mlbDesc.font = [UIFont systemFontOfSize:14];
    [_mDetailView addSubview:mlbDesc];
    
    iTop += ((size.height<20?20:size.height)+5);
    
    mlbCount = [[UILabel alloc] initWithFrame:CGRectMake(15, iTop, 150, 20)];
    mlbCount.backgroundColor = [UIColor clearColor];
    mlbCount.textAlignment = NSTextAlignmentLeft;
    mlbCount.textColor = [UIColor lightGrayColor];
    mlbCount.text = [NSString stringWithFormat:@"%@浏览 · %@喜欢 · %@评论", self.mVideoModel.look, self.mVideoModel.approval, self.mVideoModel.common];
    mlbCount.font = [UIFont systemFontOfSize:11];
    [_mDetailView addSubview:mlbCount];
    
    iTop += 30;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, iHeight+32, KscreenWidth, iTop-iHeight-32)];
    imageView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    [_mDetailView addSubview:imageView];
    [_mDetailView sendSubviewToBack:imageView];
    
    UIImageView *roundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 106, 106)];
    roundView.center = CGPointMake(KscreenWidth - 58, iTop);
    roundView.backgroundColor = [UIColor whiteColor];
    roundView.userInteractionEnabled = YES;
    roundView.layer.masksToBounds = YES;
    roundView.layer.cornerRadius = 53;
    [_mDetailView addSubview:roundView];
    
    UIButton *mapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mapBtn.frame = roundView.bounds;
    [mapBtn addTarget:self action:@selector(OnMapClick) forControlEvents:UIControlEventTouchUpInside];
    [roundView addSubview:mapBtn];
    
    mMapView = [[MapDisplayView alloc] initWithFrame:CGRectMake((roundView.frame.size.width-95)/2, (roundView.frame.size.height-95)/2, 95, 95)];
    mMapView.userInteractionEnabled = NO;
    mMapView.layer.masksToBounds = YES;
    mMapView.layer.cornerRadius = 50;
    [roundView addSubview:mMapView];
    [mMapView AddPointAnnotation:[self.mVideoModel.x floatValue] :[self.mVideoModel.y floatValue] :self.mVideoModel.xy_name];
    
    iTop += 5;
    
    mlbName = [[UILabel alloc]initWithFrame:CGRectMake(15, iTop, 150, 40)];
    mlbName.backgroundColor = [UIColor clearColor];
    mlbName.textAlignment = NSTextAlignmentLeft;
    mlbName.textColor = [UIColor darkGrayColor];
    mlbName.text = self.mVideoModel.title;
    mlbName.font = [UIFont systemFontOfSize:30];
    [_mDetailView addSubview:mlbName];
    
    iTop += 45;
    mlbAddress = [[UILabel alloc]initWithFrame:CGRectMake(15, iTop, 150, 15)];
    mlbAddress.backgroundColor = [UIColor clearColor];
    mlbAddress.textAlignment = NSTextAlignmentLeft;
    mlbAddress.textColor = [UIColor grayColor];
    mlbAddress.text = self.mVideoModel.xy_name;
    mlbAddress.font = [UIFont systemFontOfSize:11];
    [_mDetailView addSubview:mlbAddress];
    
    iTop += 35;
    
    float fWidth = KscreenWidth-28;
    float fHeight = fWidth/11.67;
    
    UIButton *commentBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    commentBtn.frame = CGRectMake(15, iTop, fWidth, fHeight);
    [commentBtn setBackgroundImage:[UIImage imageNamed:@"p_commentback"] forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(OnCommentClick) forControlEvents:UIControlEventTouchUpInside];
    [_mDetailView addSubview:commentBtn];
    
    UIImageView *flagView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, fHeight*0.57, fHeight*0.57)];
    flagView.center = CGPointMake(fHeight*1.1/2, fHeight/2);
    flagView.image = [UIImage imageNamed:@"p_inputflag"];
    [commentBtn addSubview:flagView];
    
    UILabel *lbText = [[UILabel alloc] initWithFrame:CGRectMake(fHeight, 0, commentBtn.frame.size.width-fHeight, fHeight)];
    lbText.backgroundColor = [UIColor clearColor];
    lbText.font = [UIFont systemFontOfSize:16];
    lbText.textColor = [UIColor grayColor];
    lbText.text = @"说点什么";
    [commentBtn addSubview:lbText];
    
    iTop += (commentBtn.frame.size.height+10);
    
    UIButton *moreBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(KscreenWidth-60, iHeight+4, 60, 25);
    [moreBtn setImage:[UIImage imageNamed:@"video_gengduo"] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(OnMoreClick) forControlEvents:UIControlEventTouchUpInside];
    [_mDetailView addSubview:moreBtn];
    
    _mDetailView.frame = CGRectMake(0, 0, KscreenWidth, iTop);

}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.mComments.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return self.mDetailView.frame.size.height;
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = [NSString stringWithFormat:@"CellID%02ld", indexPath.section];
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:self.mDetailView];
        }
        return cell;
    }
    else {
        CommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[CommentListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        CommentListModel *model = [self.mComments objectAtIndex:indexPath.row];
        [cell LoadContent:model];
        return cell;
    }
}

- (void)dealloc {
    [self.mDetailView removeFromSuperview];
    self.mDetailView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)OnMapClick {
    MapLineViewController *ctrl = [[MapLineViewController alloc] init];
    ctrl.mLatitude = [self.mVideoModel.x floatValue];
    ctrl.mLongitude = [self.mVideoModel.y floatValue];
    ctrl.mName = self.mVideoModel.xy_name;
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void)OnCommentClick {
    if (!kkIsLogin) {
        ThirdLoginViewController *ctrl = [[ThirdLoginViewController alloc] init];
        [self presentViewController:ctrl animated:YES completion:nil];
    }
    else {
        PopCommentView *view = [[PopCommentView alloc] initWithFrame:self.view.bounds];
        view.mVideoID = self.mVideoModel.m_id;
        [self.view addSubview:view];
    }
}

#pragma mark - ImageDownManager

- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (void)OnRefreshComment {
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    
    self.mDownManager = [[ImageDownManager alloc] init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnAddLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    NSString *urlstr = [NSString stringWithFormat:@"%@/mobileapi/video/comment_list", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.mVideoModel.m_id forKey:@"v_id"];
    [dict setObject:[NSString stringWithFormat:@"%d", miPage+1] forKey:@"page"];
    [dict setObject:@"20" forKey:@"page_size"];
    [_mDownManager PostHttpRequest:urlstr :dict];
}

- (void)OnAddLoadFinish:(ImageDownManager *)sender {
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSLog(@"%@", dict);
        int iStatus = [[dict objectForKey:@"status"] intValue];
        if (iStatus == 1001) {
            if (miPage == 0) {
                [self.mComments removeAllObjects];
            }
            NSArray *array = [dict objectForKey:@"lst"];
            for (int i = 0; i<array.count; i++) {
                NSDictionary *dDict = array[i];
                CommentListModel *model = [CommentListModel CreateWithDict:dDict];
                [self.mComments addObject:model];
            }
            miPage ++;
            mTableView.mbMoreHidden = (array.count < 20);
        }
        [mTableView FinishLoading];
        [mTableView reloadData];
    }
}

- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}

#pragma mark - RefreshTableView

- (void)ReloadList:(RefreshTableView *)sender {
    miPage = 0;
    [self OnRefreshComment];
}

- (void)LoadMoreList:(RefreshTableView *)sender {
    [self OnRefreshComment];
}

- (BOOL)CanRefreshTableView:(RefreshTableView *)sender {
    return !_mDownManager;
}

- (void)OnMoreClick {
    UIActionSheet *actView = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"算了" destructiveButtonTitle:nil otherButtonTitles:@"黄赌毒！我要举报", nil];
    [actView showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if (!kkIsLogin) {
            ThirdLoginViewController *ctrl = [[ThirdLoginViewController alloc] init];
            [self presentViewController:ctrl animated:YES completion:nil];
        }
        else {
            [[ShareMethod Share] Report:self.mVideoModel.m_id];
        }
    }
}

#pragma mark - 加去过
- (void)HaveGown {
    if (!kkIsLogin) {
        ThirdLoginViewController *ctrl = [[ThirdLoginViewController alloc] init];
        [self presentViewController:ctrl animated:YES completion:nil];
    }
    else {
        [[ShareMethod Share] HaveGo:self.mVideoModel];
    }
}

#pragma mark - 加想去
- (void)WantGo {
    if (!kkIsLogin) {
        ThirdLoginViewController *ctrl = [[ThirdLoginViewController alloc] init];
        [self presentViewController:ctrl animated:YES completion:nil];
    }
    else {
        [[ShareMethod Share] WantGo:self.mVideoModel];
    }
}

#pragma mark - ShareMethodDelegate

- (void)OnWantGoStart:(ShareMethod *)sender {
    [self StartLoading];
}

- (void)OnHaveGoStart:(ShareMethod *)sender {
    [self StartLoading];
}

- (void)OnShareMethodFinish:(ShareMethod *)sender {
    [self StopLoading];
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