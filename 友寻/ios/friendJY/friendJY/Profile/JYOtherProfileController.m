//
//  JYOtherProfileController.m
//  friendJY
//
//  Created by chenxiangjing on 15/4/21.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYOtherProfileController.h"
#import "AFNetworking.h"
#import "NSString+URLEncoding.h"
#import "JYHttpServeice.h"
#import "JYAppDelegate.h"
#import "UIImageView+AFNetworking.h"
#import "JYProfileData.h"
#import "JYShareData.h"
#import "JYAlbumController.h"
#import "JYProfileEditController.h"
#import "JYProfileEditIntroController.h"
#import "JYProfileEditTagsController.h"
#import "JYProfileSystemSetController.h"
#import "JYProfileTagListView.h"
#import "JYProfileShareView.h"
#import "JYLocalImageModel.h"
//#import "JYPhoto.h"
#import "SDPhotoBrowser.h"
#import "JYGroupModel.h"
#import "JYGroupView.h"
#import "JYCreatGroupFriendModel.h"
#import "JYSameFriendController.h"
#import "JYManageFriendData.h"
#import "JYDynamicController.h"
#import "JYProfileGroupDetailController.h"
//#import "JYShareContentModel.h"
#import "Toast+UIView.h"
#import "JYCreatGroupFriendModel.h"
#import "JYProfileTagModel.h"
#import "JYChatController.h"
#import "JYMessageModel.h"
#import "JYProfileDownImagePraiseManager.h"
#import "JYProfileAddFriendView.h"
#import "JYProfileModel.h"
#import "JYImagePraiseModel.h"

#define kProfileHeadView 500
#define kSectionDistance 10
#define kSectionWidth kScreenWidth-10
#define kAvatarBrowserTag 1234
#define kAlbumBrowserTag 4321

@interface JYOtherProfileController ()<UIActionSheetDelegate,SDPhotoBrowserDelegate,UITextFieldDelegate>
{
    UIScrollView *myScrollView;
//    NSDictionary * profileDataDic;
    JYProfileModel *userInfoModel;
    NSDictionary * profileOptionDic;
    
    UIImageView *avatarImg; // 头像
    UIImageView *avatarBGImg;
    
    NSString * nickMark;
    NSMutableDictionary * tagListDic;
    BOOL isSelf;
    UIView *sectionSeven;//标签部份，因为标签 是高度不固定
    
    UIView *sectionThree;
    /**
     *  *****标签******
     */
    UIView *sectionSix;
    /**
     *  *****动态******
     */
    UIView *sectionFour;
    CGPoint tagStartPostion;//标签 的开始位置
    UIScrollView *sectionEight;//群组的标签
    JYProfileTagListView *tagListView;
    BOOL tagExtend; //标签是否展开，高度超过80，默认收起
    BOOL groupExtend;
    UIImageView *tagMoreClick;
    
    NSInteger tagListOriginalHeight; //标签的原始高度，便于点击展开和收起时计算高度
    NSInteger tagListDefaultHeight;
    
    UILabel *nickRemarkLabel;//昵称备注
    
    JYProfileShareView *shareView;//分享层
    NSMutableArray *_showImagesArrs; //进来时显示已上传的图片
    
    UIActionSheet *uploadPhotosheet;
    UIActionSheet *reportUserSheet;
    UIActionSheet *rightTopButtonSheet;
    
    UIAlertView *modifyNickMark;//看别人时修改备注的alert
    UIAlertView *addOneTagForUser;//看别人时添加一个标签
    
    NSMutableArray *groupListArr;//群组信息
    UILabel *sameFriendLab;//好友姓名
//    UILabel *friendCount;
    UILabel *newDynamicContent;
    
    UIButton *dynamicMoreBtn;
    UILabel *nickLabel;
    
    UILabel *lonelyCountLab;
    //
    UIImageView *sexImageView;
    //确认单身按钮
//    UIButton *singleBtn;
    
    UILabel *starLab;
    UILabel *cityLab;
    
//    UIButton *singleBtn;
    
    JYProfileAddFriendView *addFriendView;
    NSMutableArray *imagePraseData;
    
    JYContactProfileAddTagView *addTagView;
    
    //用户已添加的标签
    NSMutableArray *sourceTagTitleArr;
    //当前显示推荐标签
    NSMutableArray *showRecommendTagTitleArr;
    //推荐标签
    NSMutableArray *sourceRecommendTagTitleArr;
    
}
//共同好友
@property (nonatomic, strong) NSMutableArray *sameFriendList;

@property (nonatomic, assign) BOOL isLimited;

@end

@implementation JYOtherProfileController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    profileOptionDic = [JYShareData sharedInstance].profile_dict;
    _sameFriendList = [NSMutableArray array];
    
    tagListDic = [NSMutableDictionary dictionary];
    
    tagExtend = false; //默认收起
    groupExtend = false;
    //加载分享的ui层
    shareView = [[JYProfileShareView alloc] init];

    [[JYAppDelegate sharedAppDelegate].window addSubview:shareView];
    
    //自已看自已右上角的求托单，看别人右上角是举报
//    if (!isSelf) {
    UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navRightBtn.backgroundColor = [UIColor clearColor];
    [navRightBtn setFrame:CGRectMake(0, 0, 20, 10)];
    [navRightBtn setImage:[UIImage imageNamed:@"profile_tag_more"] forState:UIControlStateNormal];
    [navRightBtn addTarget:self action:@selector(_initRightTopButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navBarButton = [[UIBarButtonItem alloc] initWithCustomView:navRightBtn];
    [self.navigationItem setRightBarButtonItem:navBarButton];
//    }
    [self _initSubView];
    
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshProfileInfoNotification:) name:kRefreshProfileInfoNotification object:nil];
    //当看别人的时，有点击标签
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profileClickTagNotification:) name:kProfileClickTagsNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profileEditTagNotification:) name:kProfileEditTagsNotification object:nil];
//    addFriendView = [[JYProfileAddFriendView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//    [[JYAppDelegate sharedAppDelegate].window addSubview:addFriendView];
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kProfileClickTagsNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profileEditTagNotification:) name:kProfileEditTagsNotification object:nil];
}

- (void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRefreshProfileInfoNotification object:nil];
}


#pragma mark - subviews

- (void)_initSubView{
    
    //过滤没有传uid的情况
    if ([_show_uid integerValue] <1) {
        _show_uid = ToString([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]);
    }
    
    //获取profile的数据
    [self _getProfileInfo];
    
    if ([_show_uid  isEqualToString:ToString([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"])]) {
        isSelf = YES;
    }else{
        isSelf = NO;
    }
}

- (void)relayoutSubviews{
    NSInteger gid = [JYHelpers integerValueOfAString:userInfoModel.gid];
    if ( gid == 3 || gid == 9) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"该用户已注销" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alertView setTag:3333];
        [alertView show];
        return;
    }
    if (isSelf) {
        [self setTitle:@"我"];
    }else{
        [self setTitle:userInfoModel.nick];
    }
    [self _userTagList];
    [self _initScrollViews];
    [self loadLastDynamic];
    [self getUserGroupList];
    //看他人时底部工具栏
    if (!isSelf) {
        [self _initToolViews];
        [self loadSameFriendData];
    }
//    [self dismissProgressHUDtoView:self.view];
}

// 初始化头视图
- (void)_initScrollViews
{
    if (myScrollView) {
        [myScrollView removeFromSuperview];
    }
    myScrollView = [[UIScrollView alloc] init];
    //
    NSInteger friendType = [JYHelpers integerValueOfAString:userInfoModel.is_friend];
    
    
    CGFloat height = kScreenHeight - kTabBarViewHeight - kNavigationBarHeight - kStatusBarHeight;
    if (isSelf) {
        height = height + kTabBarViewHeight;
    }
    myScrollView.frame = CGRectMake(0, 0, kScreenWidth, height); // frame中的size指UIScrollView的可视范围
    myScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    myScrollView.contentSize = CGSizeMake(kScreenWidth, 3000);
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.showsVerticalScrollIndicator = NO;
    myScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:myScrollView];
    
    /*****************第一部份ui开始******************/
    UIView *sectionOne = [[UIView alloc] initWithFrame:CGRectMake(5, kSectionDistance, kSectionWidth, 100)];
    sectionOne.backgroundColor = [UIColor whiteColor];
    sectionOne.layer.borderColor = [[JYHelpers setFontColorWithString:@"#cccccc"] CGColor];
    sectionOne.layer.borderWidth = 1;
    [myScrollView addSubview:sectionOne];
    
    // 头像背景
    avatarBGImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 79, 79)];
    avatarBGImg.userInteractionEnabled = YES;
    avatarBGImg.backgroundColor = [UIColor clearColor];
    avatarBGImg.image = [UIImage imageNamed:@"avatar_bg_150"];
    [sectionOne addSubview:avatarBGImg];
    
    NSString *sexStr = userInfoModel.sex;
    // 头像
    avatarImg = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 75, 75)];
    avatarImg.userInteractionEnabled = YES;
    avatarImg.layer.cornerRadius = 37.5;
    avatarImg.layer.borderColor =[[UIColor whiteColor] CGColor];
    avatarImg.layer.borderWidth = 3;
    [avatarImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAvatar:)]];
    avatarImg.layer.masksToBounds = TRUE;
    
    //avatarImg.layer.mask =
    avatarImg.clipsToBounds = YES;
    avatarImg.backgroundColor = [UIColor clearColor];
    
    if ([JYHelpers integerValueOfAString:sexStr]) {
        avatarImg.image = [UIImage imageNamed:@"pic_morentouxiang_man.png"]; //男的默认图标
    } else {
        avatarImg.image = [UIImage imageNamed:@"pic_morentouxiang_woman.png"]; //女的默认图标
    }
    [avatarBGImg addSubview:avatarImg];
    
    [avatarImg setImageWithURL:[NSURL URLWithString:[userInfoModel.avatars objectForKey:@"200"]]];
    //    UITapGestureRecognizer *editTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoEditController:)];
    
    //性别
    sexImageView = [[UIImageView alloc] initWithFrame:CGRectMake(avatarBGImg.right+17, avatarBGImg.top+10, 16, 16)];
    sexImageView.userInteractionEnabled = YES;
    sexImageView.backgroundColor = [UIColor clearColor];
    if ([sexStr intValue] == 1) { //1-男, 0-女
        sexImageView.image = [UIImage imageNamed:@"male_16"];
    }else{
        sexImageView.image = [UIImage imageNamed:@"female_16"];
    }
    [sectionOne addSubview:sexImageView];
    
    //昵称
    nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
    //    [nickLabel setNumberOfLines:0];
    nickLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    nickLabel.textAlignment = NSTextAlignmentLeft;
    nickLabel.backgroundColor = [UIColor clearColor];
    nickLabel.textColor = [JYHelpers setFontColorWithString:@"#303030"];
    NSString *text = userInfoModel.nick;
    
    nickLabel.font = [UIFont systemFontOfSize:14];
    //一度好友可以添加备注
    if ([JYHelpers integerValueOfAString:userInfoModel.is_friend] == 1) {
        // 如果备注不为空
        NSString *textMark = @"(添加备注)";
        if (![JYHelpers isEmptyOfString:userInfoModel.mark]) {
            text = userInfoModel.mark;
            [self setTitle:text];
            textMark = @"(修改备注)";
        }
        
        CGFloat markLabWidth = [JYHelpers getTextWidthAndHeight:textMark fontSize:13].width;
        CGFloat nickAddMarkLabWidth = sectionOne.width - sexImageView.right - 20 - 6;
        
        CGSize labelsize = [JYHelpers getTextWidthAndHeight:text fontSize:14];
        [nickLabel setFrame:CGRectMake(sexImageView.right+6, sexImageView.top, nickAddMarkLabWidth - markLabWidth, 16)];
        //    [nickLabel setBackgroundColor:[UIColor orangeColor]];
        [sectionOne addSubview:nickLabel];
        
        if (!isSelf) {
            //昵称备注
            nickRemarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
            //        [nickRemarkLabel setNumberOfLines:0];
            nickRemarkLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            nickRemarkLabel.textAlignment = NSTextAlignmentLeft;
            nickRemarkLabel.backgroundColor = [UIColor clearColor];
            nickRemarkLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
            nickRemarkLabel.font = [UIFont systemFontOfSize:13];
            nickRemarkLabel.userInteractionEnabled = YES;

            [nickRemarkLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_clickUpdateMarkGesture)]];
            //         CGSize markLabelSize = [JYHelpers getTextWidthAndHeight:text fontSize:14];
            
            //        markLabelSize 当前备注尺寸
            //        markLabWidth 默认备注尺寸
            //        labelsize  当前昵称尺寸
            //        nickAddMarkLabWidth  昵称加上备注的最长尺寸
            
            if (labelsize.width < (nickAddMarkLabWidth - markLabWidth)) {
                [nickLabel setFrame:CGRectMake(sexImageView.right+6, sexImageView.top, labelsize.width, 16)];
            }
            [nickRemarkLabel setFrame:CGRectMake(nickLabel.right, sexImageView.top, nickAddMarkLabWidth - nickLabel.width, 16)];
            
            nickLabel.text = text;
            nickRemarkLabel.text = textMark;
            
            [sectionOne addSubview:nickRemarkLabel];
        }
    }else{
        [nickLabel setFrame:CGRectMake(sexImageView.right+6, sexImageView.top, sectionOne.right - sexImageView.right - 6 -15, 16)];
        [nickLabel setText:text];
        [sectionOne addSubview:nickLabel];
    }
    
    //婚姻状况
    UILabel *marryStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(sexImageView.left , sexImageView.bottom+5, 100, 20)];
    //    [marryStatusLabel setBackgroundColor:[UIColor orangeColor]];
    marryStatusLabel.textAlignment = NSTextAlignmentLeft;
    marryStatusLabel.backgroundColor = [UIColor clearColor];
    marryStatusLabel.textColor = [JYHelpers setFontColorWithString:@"#2695ff"];
    marryStatusLabel.font = [UIFont systemFontOfSize:14];
    //1-为单身,2-恋爱中，3-已婚，4-保密
    NSString *marriageStatus = [[[JYShareData sharedInstance].profile_dict objectForKey:@"marriage"] objectForKey:userInfoModel.marriage];
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"情感状态：%@",marriageStatus]];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:kTextColorBlack range:NSMakeRange(0, 5)];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:kTextColorBlue range:NSMakeRange(5, marriageStatus.length)];
    [marryStatusLabel setWidth:[JYHelpers getTextWidthAndHeight:[NSString stringWithFormat:@"情感状态：%@",marriageStatus] fontSize:14].width];
    [marryStatusLabel setAttributedText:attributeStr];

//    marryStatusLabel.text = [[[JYShareData sharedInstance].profile_dict objectForKey:@"marriage"] objectForKey:[profileDataDic objectForKey:@"marriage"]];
    
    [sectionOne addSubview:marryStatusLabel];
    //单身 显示确认单身 只有一度好友才能确定单身
    if ([JYHelpers integerValueOfAString:userInfoModel.marriage] == 1 && friendType == 1) {
        
        [sectionOne setHeight:sectionOne.height + 30];
        
        UIButton *singleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [singleBtn setFrame:CGRectMake(0, sectionOne.height - 30, sectionOne.width, 30)];
        [singleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        singleBtn.userInteractionEnabled = YES;
        singleBtn.backgroundColor = [UIColor clearColor];
        singleBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        singleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
       
        [self setSingleBtnStatus:singleBtn];
        
        [singleBtn addTarget:self action:@selector(singleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [sectionOne addSubview:singleBtn];
        
        
    }else if ([JYHelpers integerValueOfAString:userInfoModel.marriage] == 1 && friendType == 0 && !isSelf){
        //非好友 显示帮他脱单
        UIButton *singleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [singleBtn setFrame:CGRectMake(marryStatusLabel.right + 10, marryStatusLabel.top, 60, marryStatusLabel.height)];
        [singleBtn setCenter:CGPointMake(singleBtn.center.x, marryStatusLabel.center.y+1)];
        [singleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [singleBtn setBackgroundImage:[UIImage imageNamed:@"comfirm_bg_90"] forState:UIControlStateNormal];
        [singleBtn setBackgroundImage:[UIImage imageNamed:@"comfirm_bg_90"] forState:UIControlStateDisabled];
        [singleBtn setTitle:@"帮TA脱单" forState:UIControlStateNormal];
        
        singleBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [singleBtn addTarget:self action:@selector(helpFallInLove) forControlEvents:UIControlEventTouchUpInside];
        [sectionOne addSubview:singleBtn];
        
    }
    
    starLab = [[UILabel alloc] initWithFrame:CGRectMake(marryStatusLabel.left, marryStatusLabel.bottom+5, 50, marryStatusLabel.height/2)];
    [starLab setFont:[UIFont systemFontOfSize:10]];
    [starLab setTextColor:kTextColorBlack];
    [sectionOne addSubview:starLab];
    
    if (![userInfoModel.birthday isEqualToString:@"0000-00-00"]) {
        
        NSLog(@"%@,%@",userInfoModel.animal,userInfoModel.star);
//        NSString * animal = [[profileOptionDic objectForKey:@"animal"] objectForKey:userInfoModel.animal];
        NSString *birth = [JYHelpers birthdayTransformToCentery:userInfoModel.birthday];
        NSString * mystar = [[profileOptionDic objectForKey:@"star"] objectForKey:userInfoModel.star];
        NSString *text = [NSString stringWithFormat:@"%@ %@", birth,mystar];
        CGFloat starWidth = [JYHelpers getTextWidthAndHeight:text fontSize:10].width;
        [starLab setFrame:CGRectMake(marryStatusLabel.left, marryStatusLabel.bottom+5, starWidth, marryStatusLabel.height/2)];
        [starLab setText:text];
    }
    
    if (![userInfoModel.live_location isEqualToString:@"0"]) {
        // 地区
        NSString *province = @" ";
        //过滤 不限
        if (![userInfoModel.live_location isEqualToString:@"0"]) {
            province = [[JYShareData sharedInstance].province_code_dict objectForKey:userInfoModel.live_location];
        }
        NSString *city = @" ";
        if (![userInfoModel.live_sublocation isEqualToString:@"0"]) {
            city = [[JYShareData sharedInstance].city_code_dict  objectForKey:userInfoModel.live_sublocation];
        }
        //过滤 空串
        NSString *province_city = @" ";
        if (province && city) {
            province_city = [NSString stringWithFormat:@"%@ %@", province, city];
        }
        
        //        NSString *contentStr = [NSString stringWithFormat:@"%@ %@",province,city];
        
        CGFloat contentW = [JYHelpers getTextWidthAndHeight:province_city fontSize:10].width;
        cityLab = [[UILabel alloc] initWithFrame:CGRectMake(marryStatusLabel.left, starLab.bottom+5, contentW, marryStatusLabel.height/2)];
        [cityLab setFont:[UIFont systemFontOfSize:10]];
        [cityLab setTextColor:kTextColorBlack];
        [cityLab setText:province_city];
        [sectionOne addSubview:cityLab];
        
    }
    //如果生日为空 城市信息顶上去。
    if ([JYHelpers isEmptyOfString:starLab.text]) {
        [cityLab setFrame:starLab.frame];
    }
    // 地区
    //    NSString *province = @" ";
    //    //过滤 不限
    //    if (![[profileDataDic objectForKey:@"live_location"] isEqualToString:@"0"]) {
    //        province = [[JYShareData sharedInstance].province_code_dict objectForKey:[profileDataDic objectForKey:@"live_location"]];
    //    }
    //    NSString *city = @" ";
    //    if (![[profileDataDic objectForKey:@"live_sublocation"] isEqualToString:@"0"]) {
    //        city = [[JYShareData sharedInstance].city_code_dict  objectForKey:[profileDataDic objectForKey:@"live_sublocation"]];
    //    }
    //    //过滤 空串
    //    NSString *province_city = @" ";
    //    if (province && city) {
    //       province_city = [NSString stringWithFormat:@"%@ %@", province, city];
    //    }
    //    UILabel *cityLable = [[UILabel alloc] initWithFrame:CGRectMake(marryStatusLabel.left, marryStatusLabel.bottom+5, 80, 15)];
    //    cityLable.backgroundColor = [UIColor clearColor];
    //    cityLable.textAlignment = NSTextAlignmentLeft;
    //    cityLable.font = [UIFont systemFontOfSize:10];
    //    cityLable.textColor = [JYHelpers setFontColorWithString:@"#303030"];
    //    cityLable.text = province_city;
    //    [sectionOne addSubview:cityLable];
    
    //看自已时，不显示省份和城市。显示邀请好友验证
    //    cityLable.hidden = NO;
    //如果是自已，显示编辑按钮，如果是别人显示一度或二度标签
    
    NSString *imgPath = @"";
    if (friendType == 1) {//一度好友
        imgPath = @"dimensional_1";
    }else if(friendType == 2 && !isSelf){
        imgPath = @"dimensional_2";
    }
    UIImageView *dimensionalImg = [[UIImageView alloc] initWithFrame:CGRectMake(sectionOne.right - 47, sectionOne.top-10, 41, 41)];
    dimensionalImg.userInteractionEnabled = YES;
    dimensionalImg.backgroundColor = [UIColor clearColor];
    dimensionalImg.image = [UIImage imageNamed:imgPath];
    [sectionOne addSubview:dimensionalImg];
    
    /*****************第一部份ui结束******************/
    
    /*****************第二部份(共同好友)ui开始******************/
    UIView *sectionTwo = [[UIView alloc] initWithFrame:CGRectMake(sectionOne.left, sectionOne.bottom, kSectionWidth, 0)];
    if (!isSelf) {
        sectionTwo.frame = CGRectMake(sectionOne.left, sectionOne.bottom+kSectionDistance, kSectionWidth, 40);
        sectionTwo.backgroundColor = [UIColor whiteColor];
        sectionTwo.layer.borderColor = [[JYHelpers setFontColorWithString:@"#cccccc"] CGColor];
        sectionTwo.layer.borderWidth = 1;
        [myScrollView addSubview:sectionTwo];
        
        UITapGestureRecognizer *tapCommomFriend = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoSameFriendController)];
        [sectionTwo addGestureRecognizer:tapCommomFriend];
        
        //共同的好友
        UILabel *commonFriendLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 20)];
        commonFriendLabel.textAlignment = NSTextAlignmentLeft;
        commonFriendLabel.backgroundColor = [UIColor clearColor];
        commonFriendLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
        commonFriendLabel.font = [UIFont systemFontOfSize:15];
        commonFriendLabel.text = @"共同好友";
        [sectionTwo addSubview:commonFriendLabel];
        
        //更多
        UIButton *friendMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [friendMoreBtn setUserInteractionEnabled:YES];
        [friendMoreBtn setFrame:CGRectMake(sectionTwo.right-20, commonFriendLabel.top+3, 8, 13)];
        [friendMoreBtn setBackgroundImage:[UIImage imageNamed:@"more_gray"] forState:UIControlStateNormal];
        [friendMoreBtn setBackgroundImage:[UIImage imageNamed:@"more_blue"] forState:UIControlStateHighlighted];
        //    [friendMoreBtn addTarget:self action:@selector(singleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [sectionTwo addSubview:friendMoreBtn];
        
        //好友名字，暂时完成一行，
        sameFriendLab = [[UILabel alloc] initWithFrame:CGRectMake(commonFriendLabel.right+17, commonFriendLabel.top, friendMoreBtn.left - 10 - commonFriendLabel.right - 17, 20)];
//        friendName = [[UILabel alloc] initWithFrame:CGRectMake(commonFriendLabel.right+17,  commonFriendLabel.top, 140, 20)];
        sameFriendLab.textAlignment = NSTextAlignmentRight;
        sameFriendLab.backgroundColor = [UIColor clearColor];
//        friendName.textColor = [JYHelpers setFontColorWithString:@"#2695ff"];
        sameFriendLab.font = [UIFont systemFontOfSize:15];
//        [sameFriendLab setTextColor:kTextColorBlue];
        //        friendName.text = @"金涛,张晓,张文婷";
        [sectionTwo addSubview:sameFriendLab];
        
    }
    /*****************第二部份(共同好友)ui结束******************/
    
    /*****************第五部份(个性签名)ui开始******************/
    //取当前控件的要显示字符高宽
    NSString *myStr = userInfoModel.intro;
    
    CGSize mSignSize = [JYHelpers getTextWidthAndHeight:myStr fontSize:15 uiWidth:kScreenWidth - 130];
    //    NSLog(@"myStr -> %@  %lf",myStr,mSignSize.height);
    CGFloat textHeight = mSignSize.height+2;
    
    if (textHeight < 20) {//默认高度
        textHeight = 20;
    }
    //    mSignSize.height+10
    UIView *sectionFive = [[UIView alloc] initWithFrame:CGRectMake(sectionTwo.left, sectionTwo.bottom+kSectionDistance, kSectionWidth, textHeight + 20)];
    sectionFive.backgroundColor = [UIColor whiteColor];
    sectionFive.layer.borderColor = [[JYHelpers setFontColorWithString:@"#cccccc"] CGColor];
    sectionFive.layer.borderWidth = 1;
    [myScrollView addSubview:sectionFive];
    
    //个性签名
    UILabel *signLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 20)];
    signLabel.textAlignment = NSTextAlignmentLeft;
    signLabel.backgroundColor = [UIColor clearColor];
    signLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
    signLabel.font = [UIFont systemFontOfSize:15];
    signLabel.text = @"个性签名";
    [sectionFive addSubview:signLabel];
    
    //签名内容
    UITextView *signContentTextView = [[UITextView alloc] initWithFrame:CGRectMake(90-5,  signLabel.top - 6, kScreenWidth - 130, textHeight + 10)]; //初始化大小并自动释放
    [signContentTextView setTextAlignment:NSTextAlignmentNatural];
    signContentTextView.textColor = [JYHelpers setFontColorWithString:@"#303030"];//设置textview里面的字体颜色
    signContentTextView.font = [UIFont fontWithName:@"Arial" size:15.0];//设置字体名字和字体大小
    signContentTextView.backgroundColor = [UIColor clearColor];//设置它的背景颜色
    if (myStr.length>1) {
        signContentTextView.text = myStr;//设置它显示的内容
    }else{
        signContentTextView.text = @"暂无签名";//设置它显示的内容
        [signContentTextView setTextColor:kTextColorLightGray];
    }
  
    signContentTextView.scrollEnabled = NO;//是否可以拖动
    
    signContentTextView.editable = NO;
    
    [sectionFive addSubview: signContentTextView];//加入到整个页面中
    
    
    /*****************第五部份(个性签名)ui结束******************/

    /*****************第三部份(相册)ui开始******************/
    NSInteger dPhotoCount = (kScreenWidth - 10 - 55 - 25)/50;
    NSDictionary  *photoes = userInfoModel.photoes;
    NSUInteger mPhotoCount = photoes.count;
    NSLog(@"dpcount == %ld photoCount == %ld",(long)dPhotoCount,(long)mPhotoCount)
    //图片数量超过当前设备能容纳的图片
    if (mPhotoCount>dPhotoCount) {
        mPhotoCount = dPhotoCount;
    }
    //    //如果没有上传图片
    //    if (mPhotoCount == 0) {
    //        mPhotoCount = 1;
    //    }
    //如果当前图片没有再加一张也没有超过设备能容纳的图片数量
    //    if (mPhotoCount+1<dPhotoCount) {
    //        mPhotoCount++;
    //    }
    NSLog(@"phontocount == %ld",(long)mPhotoCount);
    
    NSInteger sectionThreeBottomPosition = sectionFive.bottom+kSectionDistance;
    if (mPhotoCount != 0) {
        sectionThree = [[UIView alloc] initWithFrame:CGRectMake(sectionOne.left, sectionThreeBottomPosition, kSectionWidth, 80)];
        [sectionThree setUserInteractionEnabled:YES];
        sectionThree.backgroundColor = [UIColor whiteColor];
        sectionThree.layer.borderColor = [[JYHelpers setFontColorWithString:@"#cccccc"] CGColor];
        sectionThree.layer.borderWidth = 1;
        [myScrollView addSubview:sectionThree];
        
        //相册
        UILabel *albumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 45, 15)];
        albumLabel.textAlignment = NSTextAlignmentLeft;
        albumLabel.backgroundColor = [UIColor clearColor];
        albumLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
        albumLabel.font = [UIFont systemFontOfSize:15];
        albumLabel.text = @"相册";
        [sectionThree addSubview:albumLabel];
        
        UIView *albumBgView = [[UIView alloc] initWithFrame:CGRectMake(albumLabel.right, albumLabel.top, kSectionWidth - albumLabel.right, 50)];
        [albumBgView setBackgroundColor:[UIColor clearColor]];
        [albumBgView setTag:123];
        [albumBgView setUserInteractionEnabled:YES];
        [sectionThree addSubview:albumBgView];
        
        if (mPhotoCount>0 && mPhotoCount<=dPhotoCount) {//最多显示4个
            NSArray *photoesValue = [photoes allValues];
            for (int i = 0;i<mPhotoCount;i++) {
                UIImageView *albumImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50*i+5*(i+1), 0, 50, 50)];
                
                [albumImageView setContentMode:UIViewContentModeScaleAspectFill];
                [albumImageView setClipsToBounds:YES];
                albumImageView.userInteractionEnabled = YES;
                albumImageView.backgroundColor = [UIColor clearColor];
                albumImageView.tag = 3000+i;
                //albumImageView.image = [UIImage imageNamed:@"pic_morentouxiang_man"];
                [albumImageView setImageWithURL:[NSURL URLWithString:[[photoesValue objectAtIndex:i] objectForKey:@"100"]]];
                UITapGestureRecognizer *photoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(browserThisPhotoClick:)];
                [albumImageView addGestureRecognizer:photoTap];
                [albumBgView addSubview:albumImageView];
                
            }
            
        }
        UIButton *albumMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [albumMoreBtn setUserInteractionEnabled:YES];
        [albumMoreBtn setFrame:CGRectMake(sectionThree.right-20-5, (sectionThree.height-13)/2-7.5, 8+10, 13+15)];
        [albumMoreBtn setImage:[UIImage imageNamed:@"more_gray"] forState:UIControlStateNormal];
        [albumMoreBtn setImage:[UIImage imageNamed:@"more_blue"] forState:UIControlStateHighlighted];
        [albumMoreBtn addTarget:self action:@selector(albumViewClick) forControlEvents:UIControlEventTouchUpInside];
        [sectionThree addSubview:albumMoreBtn];
        sectionThreeBottomPosition = sectionThree.bottom + kSectionDistance;
    }
    /*****************第三部份(相册)ui结束******************/
    
    /*****************第七部份(标签)ui开始******************/
//    NSInteger sectionSevenBottomPosition = 0;
//    sectionSevenBottomPosition = sectionSix.bottom+kSectionDistance;
    
    sectionSeven = [[UIView alloc] initWithFrame:CGRectMake(sectionFive.left, sectionThreeBottomPosition, kSectionWidth, 90)];
    
    sectionSeven.backgroundColor = [UIColor whiteColor];
    sectionSeven.layer.borderColor = [[JYHelpers setFontColorWithString:@"#cccccc"] CGColor];
    sectionSeven.layer.borderWidth = 1;
    [myScrollView addSubview:sectionSeven];
    
    //标签
    UILabel *tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 40, 20)];
    tagLabel.textAlignment = NSTextAlignmentLeft;
    tagLabel.backgroundColor = [UIColor clearColor];
    tagLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
    tagLabel.font = [UIFont systemFontOfSize:15];
    tagLabel.text = @"标签";
    [sectionSeven addSubview:tagLabel];
    //只有一度好友可以添加标签
    if (!isSelf && friendType == 1) {
        UILabel *giveHimTagLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-120, tagLabel.top, 100, 20)];
        giveHimTagLabel.textAlignment = NSTextAlignmentRight;
        giveHimTagLabel.backgroundColor = [UIColor clearColor];
        giveHimTagLabel.textColor = [JYHelpers setFontColorWithString:@"#2695ff"];
        giveHimTagLabel.font = [UIFont systemFontOfSize:15];
        giveHimTagLabel.userInteractionEnabled = YES;
        giveHimTagLabel.text = @"给TA贴标签";
        [giveHimTagLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addTagLabelGesture)]];
        
        [sectionSeven addSubview:giveHimTagLabel];
        //初始化addtagview
        addTagView = [[JYContactProfileAddTagView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        __weak typeof(self) weakSelf = self;
//        __weak typeof(addTagView) weakTagView = addTagView;
        
        [addTagView.recommendTagView setClickHandler:^(NSString * __nonnull str) {
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf requestAddTag:str];
//            [weakTagView hide];
            
            
        }];
        addTagView.hidden = YES;
        [[JYAppDelegate sharedAppDelegate].window addSubview:addTagView];
        
//        [self setTagTitles];
        [self requestGetRecommendTags];
    }
    
    tagStartPostion = CGPointMake(tagLabel.left, tagLabel.bottom);
    
    tagListView = [[JYProfileTagListView alloc] initUiView:_show_uid width:kScreenWidth-30 startPosition:tagStartPostion tagList:tagListDic isAllowDelTag:NO isAllowClickTag:YES isContactsTag:NO];
    //    [tagListView setUid:_show_uid];
    [sectionSeven addSubview:tagListView];
    
    tagListOriginalHeight =tagListView.height;
    if (tagListView.height>80) { //当高度大于80，两排时，则收起
        tagListView.height = 80;
        tagListDefaultHeight = 80;
    }else{
        //        [tagMoreClick setHidden:YES];
        tagListDefaultHeight = tagListOriginalHeight;
    }
    sectionSeven.height = tagListView.height+58;
    
    
    tagMoreClick = [[UIImageView alloc] initWithFrame:CGRectMake(sectionSeven.right-35-10, tagListView.bottom+5, 35, 8+10)];
    [tagMoreClick setContentMode:UIViewContentModeCenter];
    tagMoreClick.userInteractionEnabled = YES;
    tagMoreClick.backgroundColor = [UIColor clearColor];
    tagMoreClick.image = [UIImage imageNamed:@"profile_tag_more"];
    
    //    UIView *tagClickBg = [[UIView alloc] initWithFrame:CGRectMake(tagMoreClick.left - 5, tagMoreClick.top - 5, tagMoreClick.width+10, tagMoreClick.height+10)];
    //    [tagMoreClick setBackgroundColor:[UIColor clearColor]];
    //    [tagClickBg setUserInteractionEnabled:YES];
    //    [sectionSeven addSubview:tagClickBg];
    
    [sectionSeven addSubview:tagMoreClick];
    [tagMoreClick addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagMoreClickGesture)]];
    if (tagListOriginalHeight<=80) {
        [tagMoreClick setHidden:YES];
    }
    sectionThreeBottomPosition = sectionSeven.bottom + kSectionDistance;
    /*****************第七部份(标签)ui结束******************/

    /*****************第四部份(动态)ui开始******************/
    sectionFour = [[UIView alloc] initWithFrame:CGRectMake(sectionOne.left,sectionThreeBottomPosition, kSectionWidth, 40)];
    sectionFour.backgroundColor = [UIColor whiteColor];
    sectionFour.layer.borderColor = [[JYHelpers setFontColorWithString:@"#cccccc"] CGColor];
    sectionFour.layer.borderWidth = 1;
    [myScrollView addSubview:sectionFour];
    
    //动态
    UILabel *dynamicLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 40, 20)];
    dynamicLabel.textAlignment = NSTextAlignmentLeft;
    dynamicLabel.backgroundColor = [UIColor clearColor];
    dynamicLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
    dynamicLabel.font = [UIFont systemFontOfSize:15];
    dynamicLabel.text = @"动态";
    [sectionFour addSubview:dynamicLabel];
    
    //动态内容
    float myWidth = kScreenWidth - dynamicLabel.right - 50 - 20;
    newDynamicContent = [[UILabel alloc] initWithFrame:CGRectMake(90-5,  dynamicLabel.top, myWidth, 20)];
    newDynamicContent.textAlignment = NSTextAlignmentLeft;
    newDynamicContent.backgroundColor = [UIColor clearColor];
    newDynamicContent.textColor = [JYHelpers setFontColorWithString:@"#303030"];
    newDynamicContent.font = [UIFont systemFontOfSize:15];
    //    newDynamicContent.text = @"最新发布的一条动态";
    [newDynamicContent setUserInteractionEnabled:YES];
    [newDynamicContent addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newDynamicAction)]];
    [sectionFour addSubview:newDynamicContent];
    
    //更多
    
    dynamicMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dynamicMoreBtn setUserInteractionEnabled:YES];
    [dynamicMoreBtn setFrame:CGRectMake(sectionFour.right-20 -5, newDynamicContent.top+3-5, 8+10, 13+10)];
    [dynamicMoreBtn setImage:[UIImage imageNamed:@"more_gray"] forState:UIControlStateNormal];
    [dynamicMoreBtn setImage:[UIImage imageNamed:@"more_blue"] forState:UIControlStateHighlighted];
    [dynamicMoreBtn addTarget:self action:@selector(newDynamicAction) forControlEvents:UIControlEventTouchUpInside];
    [sectionFour addSubview:dynamicMoreBtn];
    /*****************第四部份(动态)ui结束******************/
    
    
    /*****************第六部份(基本信息的展示)ui开始******************/
    sectionSix = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)];
    
    sectionSix.backgroundColor = [UIColor whiteColor];
    sectionSix.layer.borderColor = [[JYHelpers setFontColorWithString:@"#cccccc"] CGColor];
    sectionSix.layer.borderWidth = 1;
    [myScrollView addSubview:sectionSix];
    
    CGFloat bottomSix = 0;
    if (![userInfoModel.birthday isEqualToString:@"0000-00-00"]){
        //生日
        UILabel *birthdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 40, 20)];
        birthdayLabel.textAlignment = NSTextAlignmentLeft;
        birthdayLabel.backgroundColor = [UIColor clearColor];
        birthdayLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
        birthdayLabel.font = [UIFont systemFontOfSize:15];
        birthdayLabel.text = @"生日";
        [sectionSix addSubview:birthdayLabel];
        
        //生日内容
        UILabel *birthdayContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(newDynamicContent.left ,  birthdayLabel.top, 160, 20)];
        birthdayContentLabel.textAlignment = NSTextAlignmentLeft;
        birthdayContentLabel.backgroundColor = [UIColor clearColor];
        birthdayContentLabel.textColor = [JYHelpers setFontColorWithString:@"#303030"];
        birthdayContentLabel.font = [UIFont systemFontOfSize:15];
        if ([userInfoModel.birthday isEqualToString:@"0000-00-00"]) {
            birthdayContentLabel.text = @"尚未填写";
        }else{
            NSLog(@"%@,%@",userInfoModel.animal,userInfoModel.star);
            NSString *birth = [JYHelpers birthdayTransformToCentery:userInfoModel.birthday];
            
//            NSString * animal = [[profileOptionDic objectForKey:@"animal"] objectForKey:userInfoModel.animal];
            NSString * mystar = [[profileOptionDic objectForKey:@"star"] objectForKey:userInfoModel.star];
            birthdayContentLabel.text = [NSString stringWithFormat:@"%@ %@",birth,mystar];
        }
        [sectionSix addSubview:birthdayContentLabel];
        
        UILabel  *birthdayUnderLine = [[UILabel alloc] initWithFrame:CGRectMake(birthdayContentLabel.left ,  birthdayContentLabel.bottom+15, sectionOne.width-birthdayContentLabel.left, 1)];
        birthdayUnderLine.layer.borderWidth = 1;
        birthdayUnderLine.layer.borderColor = [[JYHelpers setFontColorWithString:@"#edf1f4"] CGColor];
        [sectionSix addSubview:birthdayUnderLine];
        bottomSix = birthdayUnderLine.bottom;
    }
    
    if (![userInfoModel.height isEqualToString:@"0"]) {
        //身高
        UILabel *heightLabel = [[UILabel alloc] initWithFrame:CGRectMake(signLabel.left, bottomSix+15, 40, 20)];
        heightLabel.textAlignment = NSTextAlignmentLeft;
        heightLabel.backgroundColor = [UIColor clearColor];
        heightLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
        heightLabel.font = [UIFont systemFontOfSize:15];
        heightLabel.text = @"身高";
        [sectionSix addSubview:heightLabel];
        
        //身高内容
        UILabel *heightContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(signContentTextView.left ,  heightLabel.top, 160, 20)];
        heightContentLabel.textAlignment = NSTextAlignmentLeft;
        heightContentLabel.backgroundColor = [UIColor clearColor];
        heightContentLabel.textColor = [JYHelpers setFontColorWithString:@"#303030"];
        heightContentLabel.font = [UIFont systemFontOfSize:15];
        heightContentLabel.text = [[profileOptionDic objectForKey:@"height" ] objectForKey:userInfoModel.height];
        [sectionSix addSubview:heightContentLabel];
        
        UILabel  *heightUnderLine = [[UILabel alloc] initWithFrame:CGRectMake(heightContentLabel.left ,  heightContentLabel.bottom+15, sectionOne.width-heightContentLabel.left, 1)];
        heightUnderLine.layer.borderWidth = 1;
        heightUnderLine.layer.borderColor = [[JYHelpers setFontColorWithString:@"#edf1f4"] CGColor];
        [sectionSix addSubview:heightUnderLine];
        bottomSix = heightUnderLine.bottom;
    }
    
    text = [[profileOptionDic objectForKey:@"weight"] objectForKey:userInfoModel.weight];
    
    if (![JYHelpers isEmptyOfString:text]) {
        //体重
        UILabel *weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(signLabel.left, bottomSix+15, 40, 20)];
        weightLabel.textAlignment = NSTextAlignmentLeft;
        weightLabel.backgroundColor = [UIColor clearColor];
        weightLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
        weightLabel.font = [UIFont systemFontOfSize:15];
        weightLabel.text = @"体重";
        [sectionSix addSubview:weightLabel];
        
        //体重内容
        UILabel *weightContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(signContentTextView.left ,  weightLabel.top, 160, 20)];
        weightContentLabel.textAlignment = NSTextAlignmentLeft;
        weightContentLabel.backgroundColor = [UIColor clearColor];
        weightContentLabel.textColor = [JYHelpers setFontColorWithString:@"#303030"];
        weightContentLabel.font = [UIFont systemFontOfSize:15];
        //        text = [[profileOptionDic objectForKey:@"weight"] objectForKey:[profileDataDic objectForKey:@"weight"]];
        //        if ([JYHelpers isEmptyOfString:text]) {
        //            text = @"尚未填写";
        //        }
        weightContentLabel.text = text;
        [sectionSix addSubview:weightContentLabel];
        
        UILabel  *weightUnderLine = [[UILabel alloc] initWithFrame:CGRectMake(weightContentLabel.left ,  weightContentLabel.bottom+15, sectionOne.width-weightContentLabel.left, 1)];
        weightUnderLine.layer.borderWidth = 1;
        weightUnderLine.layer.borderColor = [[JYHelpers setFontColorWithString:@"#edf1f4"] CGColor];
        [sectionSix addSubview:weightUnderLine];
        bottomSix = weightUnderLine.bottom;
    }
    
    //职业
    text = [[profileOptionDic objectForKey:@"career"] objectForKey:userInfoModel.career];
    
    if (![JYHelpers isEmptyOfString:text]) {
        
        UILabel *workLabel = [[UILabel alloc] initWithFrame:CGRectMake(signLabel.left, bottomSix+15, 40, 20)];
        workLabel.textAlignment = NSTextAlignmentLeft;
        workLabel.backgroundColor = [UIColor clearColor];
        workLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
        workLabel.font = [UIFont systemFontOfSize:15];
        workLabel.text = @"职业";
        [sectionSix addSubview:workLabel];
        
        //职业内容
        UILabel *workContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(signContentTextView.left ,  workLabel.top, 160, 20)];
        workContentLabel.textAlignment = NSTextAlignmentLeft;
        workContentLabel.backgroundColor = [UIColor clearColor];
        workContentLabel.textColor = [JYHelpers setFontColorWithString:@"#303030"];
        workContentLabel.font = [UIFont systemFontOfSize:15];
        //        text = [[profileOptionDic objectForKey:@"career"] objectForKey:[profileDataDic objectForKey:@"career"]];
        //    if ([JYHelpers isEmptyOfString:text]) {
        //        text = @"尚未填写";
        //    }
        workContentLabel.text = text;
        [sectionSix addSubview:workContentLabel];
        
        UILabel  *workUnderLine = [[UILabel alloc] initWithFrame:CGRectMake(workContentLabel.left ,  workContentLabel.bottom+15, sectionOne.width-workContentLabel.left, 1)];
        workUnderLine.layer.borderWidth = 1;
        workUnderLine.layer.borderColor = [[JYHelpers setFontColorWithString:@"#edf1f4"] CGColor];
        [sectionSix addSubview:workUnderLine];
        bottomSix = workUnderLine.bottom;
    }
    
    NSString *companyText = @"公司";
    if ([text isEqualToString:@"学生"]) {
        companyText = @"学校";
        text = @"school";
    }else{
        text = @"company_name";
    }
    
    text = [text isEqualToString:@"school"] ? userInfoModel.school : userInfoModel.company_name;
    //    NSLog(@"%@",text)
    if (![JYHelpers isEmptyOfString:text]) {
        //公司
        UILabel *companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(signLabel.left, bottomSix+15, 40, 20)];
        companyLabel.textAlignment = NSTextAlignmentLeft;
        companyLabel.backgroundColor = [UIColor clearColor];
        companyLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
        companyLabel.font = [UIFont systemFontOfSize:15];
        //    NSString *companyText = @"公司";
        //    if ([text isEqualToString:@"学生"]) {
        //        companyText = @"学校";
        //    }
        companyLabel.text = companyText;
        [sectionSix addSubview:companyLabel];
        
        //公司内容
        UILabel *companyContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(signContentTextView.left ,  companyLabel.top, 160, 20)];
        companyContentLabel.textAlignment = NSTextAlignmentLeft;
        companyContentLabel.backgroundColor = [UIColor clearColor];
        companyContentLabel.textColor = [JYHelpers setFontColorWithString:@"#303030"];
        companyContentLabel.font = [UIFont systemFontOfSize:15];
        //        text = @"company_name";
        //        if ([companyText isEqualToString:@"学校"]) {
        //            text = @"school";
        //        }
        //    NSLog(@"%@",text)
        //        text = [profileDataDic objectForKey:text];
        //    NSLog(@"%@",text)
        //        if ([JYHelpers isEmptyOfString:text]) {
        //            text = @"尚未填写";
        //        }
        companyContentLabel.text = text;
        [sectionSix addSubview:companyContentLabel];
        
        UILabel  *companyUnderLine = [[UILabel alloc] initWithFrame:CGRectMake(companyContentLabel.left ,  companyContentLabel.bottom+15, sectionOne.width-companyContentLabel.left, 1)];
        companyUnderLine.layer.borderWidth = 1;
        companyUnderLine.layer.borderColor = [[JYHelpers setFontColorWithString:@"#edf1f4"] CGColor];
        [sectionSix addSubview:companyUnderLine];
        
        bottomSix = companyUnderLine.bottom;
    }
    if (bottomSix == 0) {
        sectionSix.frame = CGRectMake(sectionFive.left, sectionFour.bottom, kSectionWidth, bottomSix);
    }else{
        sectionSix.frame = CGRectMake(sectionFive.left, sectionFour.bottom+kSectionDistance, kSectionWidth, bottomSix);
    }
    
    /*****************第六部份(基本信息的展示)ui结束******************/
    
    
    /*****************第八部份(群组)ui开始******************/
    sectionEight = [[UIScrollView alloc] initWithFrame:CGRectMake(sectionSeven.left, sectionSix.bottom+kSectionDistance, kSectionWidth, 45)];
    sectionEight.backgroundColor = [UIColor whiteColor];
    sectionEight.scrollEnabled = false;
    sectionEight.layer.borderColor = [[JYHelpers setFontColorWithString:@"#cccccc"] CGColor];
    sectionEight.layer.borderWidth = 1;
    [myScrollView addSubview:sectionEight];
    
    //群组
    UILabel *groupLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 20)];
    groupLabel.textAlignment = NSTextAlignmentLeft;
    groupLabel.backgroundColor = [UIColor clearColor];
    groupLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
    groupLabel.font = [UIFont systemFontOfSize:15];
    groupLabel.text = @"群组";
    [sectionEight addSubview:groupLabel];
    
    UILabel  *groupLabelLine = [[UILabel alloc] initWithFrame:CGRectMake(0 ,  groupLabel.bottom+15, sectionEight.width, 1)];
    groupLabelLine.layer.borderWidth = 1;
    groupLabelLine.layer.borderColor = [[JYHelpers setFontColorWithString:@"#edf1f4"] CGColor];
    [sectionEight addSubview:groupLabelLine];
    [self updateGroupList];
    
    /*****************第八部份(群组)ui结束******************/
    
    
    //加载完成后，重新计算scroll的总高度
    myScrollView.contentSize = CGSizeMake( kScreenWidth, sectionEight.bottom+20);

}

// 初始化工具栏视图
- (void)_initToolViews
{
    UIView *toolView = [[UIView alloc] init];
    //    if (SYSTEM_IS_IOS7) {
    //        toolView.frame = CGRectMake(0, kScreenHeight-kProfileToolView, kScreenWidth, kProfileToolView);
    //    } else {
    //        toolView.frame = CGRectMake(0, 0, kScreenWidth, kProfileToolView);
    //    }
    NSInteger isFriend = [JYHelpers integerValueOfAString:userInfoModel.is_friend];
    //1 已经是一度好友
    //    if ([[profileDataDic objectForKey:@"is_friend"] integerValue] == 1) {
    //        isFriend = YES;
    //    }
    BOOL isSingle = NO;
    //1 单身
    if ([JYHelpers integerValueOfAString:userInfoModel.marriage] == 1) {
        isSingle = YES;
    }
    CGRect addFriendFrame = CGRectMake(0, 0, 0, 0);
    CGRect chatFrame = CGRectMake(0, 0, 0, 0);
    CGRect castFrame = CGRectMake(0, 0, 0, 0);
    NSString *addFriendImgPath = @"";
    NSString *chatImgPath = @"";
    NSString *castImgPath = @"";
    
    if (isFriend == 1) {
        if (isSingle) {//单身一度好友
            chatFrame = CGRectMake(0, 0, kScreenWidth/2, kTabBarViewHeight);
            castFrame = CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, kTabBarViewHeight);
            chatImgPath = @"profile_bottom_chat_normal160";
            castImgPath = @"profile_bottom_cast_normal160";
        }else{//非单身一度好友
            chatFrame = CGRectMake(0, 0, kScreenWidth, kTabBarViewHeight);
            chatImgPath = @"profile_bottom_chat_normal320";
        }
    }else if(isFriend == 2){
        if ([ToString(userInfoModel.allow_add_with_chat) isEqualToString:@"2"]) {//禁止聊天
            
            
        }else if(isSingle){//二度好友单身
            addFriendFrame = CGRectMake(0, 0, 85*self.autoSizeScaleX, kTabBarViewHeight);
            chatFrame = CGRectMake(85*self.autoSizeScaleX, 0, 85*self.autoSizeScaleX, kTabBarViewHeight);
            castFrame = CGRectMake(170*self.autoSizeScaleX, 0, 150*self.autoSizeScaleX, kTabBarViewHeight);
            addFriendImgPath = @"profile_bottom_add_normal";
            chatImgPath = @"profile_bottom_chat_normal";
            castImgPath = @"profile_bottom_cast_normal";
        }else{
            addFriendFrame = CGRectMake(0, 0, kScreenWidth/2, kTabBarViewHeight);
            chatFrame = CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, kTabBarViewHeight);
            addFriendImgPath = @"profile_bottom_add_normal160";
            chatImgPath = @"profile_bottom_chat_normal160";
        }
    }else{
        if ([ToString(userInfoModel.allow_add_with_chat) isEqualToString:@"0"]) {//允许所有人聊天
            //好 友单身 加好友 聊天
            if (isSingle) {//单身 非好友
                addFriendFrame = CGRectMake(0, 0, 85*self.autoSizeScaleX, kTabBarViewHeight);
                chatFrame = CGRectMake(85*self.autoSizeScaleX, 0, 85*self.autoSizeScaleX, kTabBarViewHeight);
                castFrame = CGRectMake(170*self.autoSizeScaleX, 0, 150*self.autoSizeScaleX, kTabBarViewHeight);
                addFriendImgPath = @"profile_bottom_add_normal";
                chatImgPath = @"profile_bottom_chat_normal";
                castImgPath = @"profile_bottom_cast_normal";
            }else{//非单身  非好友
                addFriendFrame = CGRectMake(0, 0, 160*self.autoSizeScaleX, kTabBarViewHeight);
                chatFrame = CGRectMake(160*self.autoSizeScaleX, 0, 160*self.autoSizeScaleX, kTabBarViewHeight);
                //            castFrame = CGRectMake(170*self.autoSizeScaleX, 0, 150*self.autoSizeScaleX, kTabBarViewHeight*self.);
                addFriendImgPath = @"profile_bottom_add_normal160";
                chatImgPath = @"profile_bottom_chat_normal160";
            }
        }
    }
    
    if (addFriendFrame.size.width != 0 || chatFrame.size.width != 0 || castFrame.size.width != 0) {
        toolView.frame = CGRectMake(0, kScreenHeight-kTabBarViewHeight-kNavigationBarHeight-kStatusBarHeight, kScreenWidth, kTabBarViewHeight);
        toolView.backgroundColor = [JYHelpers setFontColorWithString:@"#fafafa"];//[UIColor whiteColor];
        [self.view addSubview:toolView];
        //    [self.view addSubview:toolView];
        
        //加它为好友
        if (addFriendFrame.size.width != 0) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = addFriendFrame;
            button.tag = 5001;
            [button setBackgroundImage:[UIImage imageNamed:addFriendImgPath] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"tabbat_tadeziliao_yixihuan"] forState:UIControlStateSelected];
//            [button setBackgroundColor:kTextColorGray];
//            button setBackgroundImage:nil forState:<#(UIControlState)#>
            [button addTarget:self action:@selector(toolButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [toolView addSubview:button];
        }
        //聊天
        if (chatFrame.size.width != 0) {
            UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
            button1.frame = chatFrame;
            button1.tag = 5002;
            [button1 setBackgroundImage:[UIImage imageNamed:chatImgPath] forState:UIControlStateNormal];
            [button1 setBackgroundImage:[UIImage imageNamed:@"tabbat_tadeziliao_yidazhaohu.png"] forState:UIControlStateSelected];
            [button1 addTarget:self action:@selector(toolButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [toolView addSubview:button1];
        }
        
        //帮它脱单
        if (castFrame.size.width != 0) {
            UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
            button2.frame = castFrame;
            button2.tag = 5003;
            [button2 setBackgroundImage:[UIImage imageNamed:castImgPath] forState:UIControlStateNormal];
            [button2 setBackgroundImage:[UIImage imageNamed:@"tabbat_tadeziliao_sixin"] forState:UIControlStateSelected];
            [button2 addTarget:self action:@selector(helpFallInLove) forControlEvents:UIControlEventTouchUpInside];
            [toolView addSubview:button2];
            
        }
        
        UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
        sepView.backgroundColor = [JYHelpers setFontColorWithString:@"#303030"];//[UIColor grayColor];
        [toolView addSubview:sepView];
    }else{
        [myScrollView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    
    if (![SharedDefault boolForKey:[NSString stringWithFormat:@"%@_add_view_show",userInfoModel.uid]] && addFriendFrame.size.width != 0) {
        addFriendView = [[JYProfileAddFriendView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        __weak typeof(self) weakSelf = self;
        [addFriendView setAddFriendBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf addFriend];
        }];
        __weak typeof(addFriendView) weakAddFriendView = addFriendView;
        addFriendView.RemoveBlock = ^{
            //如果没有导入通讯录， 点x时提示导入
            weakAddFriendView.hidden = YES;
            
            if ([JYGuideToAddressBookManager HaveIntoAddressBook]) {
                JYGuideIntoAddressBookView *noFriendInviteBox =[[JYGuideIntoAddressBookView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
                //大层的，容器
                [[JYAppDelegate sharedAppDelegate].window addSubview:noFriendInviteBox];
            }
        };
        
        [addFriendView show];
        [SharedDefault setBool:YES forKey:[NSString stringWithFormat:@"%@_add_view_show",userInfoModel.uid]];
        [SharedDefault synchronize];
    }
}

//上传照片选择初始化
- (void)_initActionSheetView
{
    uploadPhotosheet = [[UIActionSheet alloc] initWithTitle:@"上传照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    [uploadPhotosheet showInView:self.view];
}

//获取群组信息以后刷新UI
- (void)updateGroupList{
    
    id target = self;
    SEL sel = @selector(joinGroup:);
    //获取导数据刷新去掉之前的假数据view
    if (groupListArr.count == 0) {
        if ([sectionEight viewWithTag:123]) {
            [[sectionEight viewWithTag:123] removeFromSuperview];
        }
    }else{
    //当加入成功回调刷新UI
        for (int i = 0; i < groupListArr.count; i++) {
            UIView *view = [sectionEight viewWithTag:123+i];
            if (view) {
                [view removeFromSuperview];
            }
        }
    }
    
    
    CGFloat lastBottom = 50;
    for (int i = 0; i < groupListArr.count; i++) {
        JYGroupModel *group = (JYGroupModel*)[groupListArr objectAtIndex:i];
//        if ([group.show isEqualToString:@"0"]) {//过滤不能显示的
//            showGroupCount++;
        
        JYGroupView *view = [JYGroupView groupViewWithModel:group andFrame:CGRectMake(0, lastBottom, kScreenWidth, 44) target:target action:sel realData:YES];
        [view setTag:123+i];
        lastBottom += 44;
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookForGroupDetail:)]];
        [sectionEight addSubview:view];
//        }
    }
    
    if (lastBottom == 50) {//没有群组
        JYGroupModel *group = [[JYGroupModel alloc] init];
        group.title = [JYHelpers integerValueOfAString:userInfoModel.sex] == 0 ? @"她还没有加入任何群组" : @"他还没有加入任何群组";
        group.total = 0;
        group.join = @"1";//虚拟加入
        group.show = @"0";//显示
        JYGroupView *view = [JYGroupView groupViewWithModel:group andFrame:CGRectMake(0, lastBottom, kScreenWidth, 44) target:nil action:nil realData:NO];
        [view setTag:123];
        lastBottom += 44;
        [sectionEight addSubview:view];
    }
    //群组超过5个
    if (lastBottom > 50+44*5) {
        [sectionEight setFrame:CGRectMake(sectionSeven.left, sectionSix.bottom + kSectionDistance, kSectionWidth, 50+44*5+20)];
        
        UIView *groupMoreBg = [[UIView alloc] initWithFrame:CGRectMake(0, 50+44*5-1, sectionEight.width, 21)];
        [groupMoreBg setBackgroundColor:[UIColor whiteColor]];
        [sectionEight addSubview:groupMoreBg];
        
        UIImageView *groupMore = [[UIImageView alloc] initWithFrame:CGRectMake(sectionEight.right-35, 1, 35, 20)];
        groupMore.userInteractionEnabled = YES;
        groupMore.backgroundColor = [UIColor clearColor];
        [groupMore setContentMode:UIViewContentModeLeft];
        groupMore.image = [UIImage imageNamed:@"profile_tag_more"];
        [groupMoreBg addSubview:groupMore];
        [groupMore addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(groupMoreClickGesture:)]];
        [sectionEight setContentSize:CGSizeMake(sectionEight.width, lastBottom-50+20)];
        
    }else{
        [sectionEight setFrame:CGRectMake(sectionSeven.left, sectionSix.bottom + kSectionDistance, kSectionWidth, lastBottom)];
        [sectionEight setContentSize:CGSizeMake(sectionEight.width, lastBottom-50)];
    }
    
//    [sectionEight setFrame:CGRectMake(sectionSeven.left, sectionSix.bottom + kSectionDistance, kSectionWidth, lastBottom)];
    myScrollView.contentSize = CGSizeMake( kScreenWidth, sectionEight.bottom+20);
    
}
- (void)tagListViewDidChangeFrame{
    
    tagListOriginalHeight = tagListView.height;
    if (tagListView.height>80) { //当高度大于80，两排时，则收起
        tagListView.height = 80;
        tagListDefaultHeight = 80;
        if (tagMoreClick.hidden) {
            [tagMoreClick setHidden:NO];
        }
    }else{
        //        [tagMoreClick setHidden:YES];
        tagListDefaultHeight = tagListOriginalHeight;
    }
}
//重新调整ui的高度，由于标签的移动，导致7，8，9段的位置变化
-(void)_adjustTagListUiHeight{
    
    if (tagExtend) {
        tagListView.height = tagListOriginalHeight;
        
    }else{
        tagListView.height = tagListDefaultHeight;
    }
    sectionSeven.height = tagListView.height+58;
    
    tagMoreClick.origin = CGPointMake(tagMoreClick.left, tagListView.bottom+5);
    sectionFour.origin = CGPointMake(sectionSeven.left, sectionSeven.bottom+kSectionDistance);
    if (sectionSix.height == 0) {
        [sectionSix setOrigin:CGPointMake(sectionSix.left, sectionFour.bottom)];
    }else{
        [sectionSix setOrigin:CGPointMake(sectionSix.left, sectionFour.bottom + kSectionDistance)];
    }
    sectionEight.origin = CGPointMake(sectionSeven.left, sectionSix.bottom+kSectionDistance);
    //加载完成后，重新计算scroll的总高度
    myScrollView.contentSize = CGSizeMake( kScreenWidth, sectionEight.bottom+20);
}
- (void)relayoutTaglistView{
    
    [tagListView setTagDic:tagListDic];
    [tagListView resetAllTagList];
    
    if (tagListView.height > 80) {
        
    }
    [self tagListViewDidChangeFrame];
    [self _adjustTagListUiHeight];

}

- (void)layoutNickLabAndMarkLabWithNick:(NSString*)nickStr mark:(NSString*)markStr{
    // 如果备注不为空
    //    NSString *textMark = @"(添加备注)";
    //    if (![JYHelpers isEmptyOfString:[profileDataDic objectForKey:@"mark"]]) {
    //        text = [profileDataDic objectForKey:@"mark"];
    //        textMark = @"(修改备注)";
    //    }
    if (self.friendModel) {
        [self.friendModel setNick:nickStr];
    }
    NSLog(@"nick %@ --> mark %@",nickStr,markStr);
    [self setTitle:nickStr];
    CGFloat markLabWidth = [JYHelpers getTextWidthAndHeight:markStr fontSize:13].width;
    CGFloat nickAddMarkLabWidth = kSectionWidth - sexImageView.right - 6 - 20;
    
    CGSize labelsize = [JYHelpers getTextWidthAndHeight:nickStr fontSize:14];
    [nickLabel setFrame:CGRectMake(sexImageView.right + 6, sexImageView.top, nickAddMarkLabWidth - markLabWidth, 16)];
    
    //        markLabelSize 当前备注尺寸
    //        markLabWidth 默认备注尺寸
    //        labelsize  当前昵称尺寸
    //        nickAddMarkLabWidth  昵称加上备注的最长尺寸
    
    if (labelsize.width < (nickAddMarkLabWidth - markLabWidth)) {
        [nickLabel setFrame:CGRectMake(sexImageView.right + 6, sexImageView.top, labelsize.width, 16)];
    }
    [nickRemarkLabel setFrame:CGRectMake(nickLabel.right, sexImageView.top, nickAddMarkLabWidth - nickLabel.width, 16)];
    
    nickLabel.text = nickStr;
    nickRemarkLabel.text = markStr;
}
//重新配置显示的推荐标签
- (void)relayoutRecommendTagView{
    
    [self setTagTitles];
    //清空当前显示标签
    [showRecommendTagTitleArr removeAllObjects];
    if (showRecommendTagTitleArr == nil) {
        showRecommendTagTitleArr = [NSMutableArray array];
    }
    
    //清除推荐标签中和用户已添加标签重复的标签
    [sourceRecommendTagTitleArr removeObjectsInArray:sourceTagTitleArr];
    
    //如果本身给的推荐标签数目小于6 直接全显示了。
    if (sourceRecommendTagTitleArr.count <= 6) {
        [showRecommendTagTitleArr addObjectsFromArray:sourceRecommendTagTitleArr];
        //清除换一批按钮
//        UIView *btnView = [anotherSection viewWithTag:54321];
//        if (btnView) {
//            [btnView removeFromSuperview];
//        }
    }else{
        //推荐标签大于6个  随机抽取6个
        while (showRecommendTagTitleArr.count < 6) {
            
            NSInteger i = arc4random()%sourceRecommendTagTitleArr.count;
            NSString *tagTitle = sourceRecommendTagTitleArr[i];
            
            if (![showRecommendTagTitleArr containsObject:tagTitle]) {
                [showRecommendTagTitleArr addObject:tagTitle];
            }
        }
        
    }
    //刷新
    [addTagView reloadRecommendTagView:showRecommendTagTitleArr];
}
#pragma mark - request

- (void)_getProfileInfo{
    [self showProgressHUD:@"加载中..." toView:self.view];
//    profileDataDic =  [[JYProfileData sharedInstance] getProfileData:_show_uid];
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"profile" forKey:@"mod"];
    [parametersDict setObject:@"get_user_info" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:_show_uid forKey:@"uid"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        [self dismissProgressHUDtoView:self.view];

        if (iRetcode == 1) {

            [self setProfileDataDic:[responseObject objectForKey:@"data"]];
            [self relayoutSubviews];
            
        } else {
//            [self dismissProgressHUDtoView:self.view];
            [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        }
        
    } failure:^(id error) {
        [self dismissProgressHUDtoView:self.view];
        NSLog(@"%@", error);
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];

}

//获取用户标签列表
- (void)_userTagList
{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"tags" forKey:@"mod"];
    [parametersDict setObject:@"tag_list" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:_show_uid forKey:@"uid"];
    //    [postDict setObject:_passwordTextField.text forKey:@"password"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        
        if (iRetcode == 1) {
            if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in [responseObject objectForKey:@"data"]) {
                    if ([dic isKindOfClass:[NSDictionary class]]) {
                        JYProfileTagModel *model = [[JYProfileTagModel alloc] initWithDataDic:dic];
                        [tagListDic setObject:model.modelToDictionary forKey:model.tid];
                    }
                }
            }
            [tagListView setTagDic:tagListDic];
            [tagListView resetAllTagList];
            [self relayoutTaglistView];
            
        } else {
            [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        }
        
    } failure:^(id error) {
        
        NSLog(@"%@", error);
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];

//    tagListDic = [[JYProfileData sharedInstance] getProfileTagList:_show_uid];
}


//获取共同好友
- (void)loadSameFriendData{

    NSDictionary *paraDic = @{@"mod":@"friends",
                              @"func":@"friends_get_mutualfriends"
                              };
    NSDictionary *postDic = @{@"uid":ToString([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]),
                              @"fuid":self.show_uid,
                              @"start":@"1",
                              @"nums":@"300"
                              };
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            //do any addtion here...
            if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *dataDic = [[responseObject objectForKey:@"data"] objectForKey:@"mutualuser"];
                for (NSString *key in dataDic.allKeys) {
                    NSDictionary *dic = [dataDic objectForKey:key];
                    JYCreatGroupFriendModel *model = [[JYCreatGroupFriendModel alloc] initWithDataDic:dic];
                    [model setAvatar:[[dic objectForKey:@"avatars"] objectForKey:@"200"]];
                    [_sameFriendList addObject:model];
                }
//                NSMutableString *mutStr = [NSMutableString string];
                if (_sameFriendList.count > 0) {
                    
//                    NSInteger count = (_sameFriendList.count < 4 ? _sameFriendList.count : 3);
//                    for (int i = 0; i < count ; i++) {
//                        JYCreatGroupFriendModel *model = (JYCreatGroupFriendModel*)_sameFriendList[i];
//                        //                NSDictionary *dic = _sameFriendList[i];
//                        [mutStr appendString:[NSString stringWithFormat:@"%@,",model.nick]];
//                    }
                    [self sameFriendLabText];
                    
                }else{
                    CGFloat width = [JYHelpers getTextWidthAndHeight:@"你们还没有共同好友哦 查看TA的好友" fontSize:15].width;
                    [sameFriendLab setTextColor:kTextColorBlue];
                    [sameFriendLab setText:@"你们还没有共同好友哦 查看TA的好友"];
                    if (width > sameFriendLab.width) {
                        [sameFriendLab setFont:[UIFont systemFontOfSize:12]];
                    }
                }
//                if (_sameFriendList.count > 3) {
//                    [friendCount setText:[NSString stringWithFormat:@"等%ld人",(long)_sameFriendList.count]];
//                }
            }else{
                CGFloat width = [JYHelpers getTextWidthAndHeight:@"你们还没有共同好友哦 查看TA的好友" fontSize:15].width;
                [sameFriendLab setTextColor:kTextColorBlue];

                [sameFriendLab setText:@"你们还没有共同好友哦 查看TA的好友"];
                if (width > sameFriendLab.width) {
                    [sameFriendLab setFont:[UIFont systemFontOfSize:12]];
                }
//                [friendName setFrame:CGRectMake(kSectionWidth - 20 - 5 - width,  10, width, 20)];
////                [friendName adjustsFontSizeToFitWidth];
//                [friendName setTextAlignment:NSTextAlignmentRight];
            }
        }
    } failure:^(id error) {
        [self dismissProgressHUDtoView:self.view];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];
}
- (void)loadLastDynamic{
//>http://c.friendly.dev/cmiajax/?mod=snsfeed&func=get_one_user_dynamic_list&uid=2134750&dy_id=0&num=1
    NSDictionary *paraDic = @{@"mod":@"snsfeed",
                              @"func":@"get_one_user_dynamic_list"
                              };
    NSDictionary *postDic = @{@"uid":_show_uid,
                              @"dy_id":@"0",
                              @"num":@"1"
                              };
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            //do any addtion here...
            if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                NSArray *dataArr = [[responseObject objectForKey:@"data"] objectForKey:@"list"];
                
                if (dataArr.count != 0) {
                    
                    NSString *text = [[[dataArr objectAtIndex:0] objectForKey:@"data"] objectForKey:@"content"];
                    NSInteger type = [[[dataArr objectAtIndex:0] objectForKey:@"type"] integerValue];
                    if (type == 500) {
                        text = [NSString stringWithFormat:@"转播文字 %@",text];
                    }else if (type == 501){
                        text = [NSString stringWithFormat:@"转播图片 %@",text];
                    }
                    [newDynamicContent setTextColor:kTextColorBlack];
                    [newDynamicContent setText:text];
                }else{
                    [newDynamicContent setText:@"暂无动态"];
                    [newDynamicContent setTextColor:kTextColorLightGray];
                    [dynamicMoreBtn setHidden:YES];
                }
            }
        }
    } failure:^(id error) {
        [self dismissProgressHUDtoView:self.view];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];
}
//获取用户的群组列表
- (void)getUserGroupList
{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"chat" forKey:@"mod"];
    [parametersDict setObject:@"group_list" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:_show_uid forKey:@"uid"];
    //    [postDict setObject:_passwordTextField.text forKey:@"password"];
    groupListArr = [NSMutableArray array];
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        
        if (iRetcode == 1) {
            NSLog(@"成功获取群组信息");
            NSArray *dataArr = [responseObject objectForKey:@"data"];
            if ([dataArr isKindOfClass:[NSArray class]]) {
                if (dataArr.count != 0) {

                    for (int i = 0; i < dataArr.count; i ++) {
                        NSDictionary *dic = [dataArr objectAtIndex:i];
                        JYGroupModel *group = [[JYGroupModel alloc] initWithDataDic:dic];
                        if ([group.show isEqualToString:@"0"]) {
                            [groupListArr addObject:group];
                        }
                    }
                    
                }
                [self updateGroupList];
            }
            
        } else {
            NSLog(@"获取群组信息失败");
        }
        
    } failure:^(id error) {
        
        [self dismissProgressHUDtoView:self.view];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        NSLog(@"%@", error);
        
    }];
    
   
}
- (void)addFriendToBlackList{
    
    if (isSelf) {
        return;
    }
    NSDictionary *paraDic = @{@"mod":@"relation",
                              @"func":@"add_black"
                              };
    
    NSDictionary *postDic = @{@"uid":ToString([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]),
                              @"fuid_arr":userInfoModel.uid
                              };
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            //do any addtion here...
            
            [[JYAppDelegate sharedAppDelegate] showTip:@"加黑成功！"];
        }else{
            [[JYAppDelegate sharedAppDelegate] showTip:@"加黑失败！"];
        }
    } failure:^(id error) {
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];
    
}

- (void)requestGetRecommendTags{
    
    BOOL isMale = [JYHelpers integerValueOfAString:userInfoModel.sex]==1 ? YES : NO;
    [[JYShareData sharedInstance] loadRecommendTagsWithMaleOrNot:isMale successBlock:^{
        if (isMale) {
            sourceRecommendTagTitleArr = [[JYShareData sharedInstance].maleRecommendTagArr mutableCopy];;
        }else{
            sourceRecommendTagTitleArr = [[JYShareData sharedInstance].feMaleRecommendTagArr mutableCopy];
        }
        [self relayoutRecommendTagView];
    }];
    
}
- (void)requestAddTag:(NSString*)tagTitle{
    
    NSMutableString *mutStr = [NSMutableString stringWithString:tagTitle];
    NSRange range = [mutStr rangeOfString:@" "];
    while (range.location != NSNotFound) {
        [mutStr deleteCharactersInRange:range];
        range = [mutStr rangeOfString:@" "];
    }
    if (mutStr.length == 0) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"请输入标签内容"];
        return;
    }
    
    tagTitle = [JYHelpers filterEmojiString:tagTitle];
     
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"tags" forKey:@"mod"];
    [parametersDict setObject:@"add_tag" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:_show_uid forKey:@"uid"];
    [postDict setObject:tagTitle forKey:@"add_tag"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            //[[JYAppDelegate sharedAppDelegate] showTip:@"添加成功"];
            if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                NSMutableDictionary *aTagDic = [NSMutableDictionary dictionaryWithDictionary:[responseObject objectForKey:@"data"]];
                [aTagDic setObject:@"0" forKey:@"bind"];
                [aTagDic setObject:@"0" forKey:@"oper"];
                NSTimeInterval ctime = [[NSDate date] timeIntervalSince1970];
                [aTagDic setObject:[NSString stringWithFormat:@"%ld",(long)ctime] forKey:@"ctime"];
                JYProfileTagModel *tagModel = [[JYProfileTagModel alloc] initWithDataDic:aTagDic];
                
                [tagListDic setObject:tagModel.modelToDictionary forKey:tagModel.tid];
                
                [tagListView addOneTagResetList:tagListDic];
                [self _adjustTagListUiHeight];
                if (addTagView) {
                    
                    [self replaceTagTitle:tagTitle];
                    [addTagView hide];

                }
                
            }else {
                [[JYAppDelegate sharedAppDelegate] showTip:@"添加错误"];
                NSLog(@"返回数据不是个字典");
            }
        } else {
            [[JYAppDelegate sharedAppDelegate] showTip:@"添加失败"];
        }
    } failure:^(id error) {
        
        NSLog(@"%@", error);
        [self dismissProgressHUDtoView:self.view];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];


}

#pragma mark - gesture Action
- (void)groupMoreClickGesture:(UITapGestureRecognizer*)aGesture{
    UIImageView *imageView = (UIImageView*)aGesture.view;
    
    if (groupExtend) { //已经展示，实现收起
        groupExtend = false;
        //        tagListView.height = tagListDefaultHeight;
        [sectionEight setHeight:50+44*5+20];
        [imageView.superview setOrigin:CGPointMake(0, 50+44*5-1)];
        imageView.image = [UIImage imageNamed:@"profile_tag_more"];
        
    }else{ //已经收起，实现展开
        groupExtend = true;
        [sectionEight setHeight:sectionEight.contentSize.height];
        
        //        tagListView.height = tagListOriginalHeight;
        [imageView.superview setOrigin:CGPointMake(0, sectionEight.contentSize.height - 21)];
        imageView.image = [UIImage imageNamed:@"profile_up_arrow"];
    }
    
    //加载完成后，重新计算scroll的总高度
    myScrollView.contentSize = CGSizeMake( kScreenWidth, sectionEight.bottom+20);
    
}

- (void)tapAvatar:(UITapGestureRecognizer*)aGesture{
    if (![userInfoModel.hasavatar boolValue]) {
        return;
    }
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = avatarBGImg;// [self viewWithTag:gesture.view.tag]; // 原图的父控件
    browser.imageCount = 1; // 图片总数
    browser.currentImageIndex = 0;
    [browser setFromSelf:NO];
    [browser setIsMyAvatar:NO];
    [browser setTag:kAvatarBrowserTag];
    
    [browser setShareContent:[NSString stringWithFormat:@"来自%@的友寻相册",userInfoModel.nick]];
    browser.delegate = self;
    [browser show];
    
}
- (void)gotoSameFriendController{
    JYSameFriendController *sameVC = [[JYSameFriendController alloc] init];
    NSLog(@"===================")
    NSLog(@"进入共同好友！")
    NSLog(@"===================")
    [sameVC setDataArr:_sameFriendList];
    [sameVC setShow_uid:self.show_uid];
    [self.navigationController pushViewController:sameVC animated:YES];
}

- (void)newDynamicAction{
    NSLog(@"进入动态")
    if (![self hasAccessToLook]) {
        return;
    }
    JYDynamicController *dynamicVC = [[JYDynamicController alloc] init];
    [dynamicVC setUid:_show_uid];
    [dynamicVC setIsLimited:_isLimited];
    [dynamicVC setTitle:[NSString stringWithFormat:@"%@的动态",self.title]];
    [self.navigationController pushViewController:dynamicVC animated:YES];
}

//- (void)gotoEditController:(UIGestureRecognizer *)gesture{
//    JYProfileEditController * _editVC = [[JYProfileEditController alloc] init];
//    [self.navigationController pushViewController:_editVC animated:YES];
//}

//查看群组详情
- (void)lookForGroupDetail:(UITapGestureRecognizer *)tap{
    NSInteger index = tap.view.tag - 123;
    JYGroupModel *model = [groupListArr objectAtIndex:index];
    JYProfileGroupDetailController *groupDetailController = [[JYProfileGroupDetailController alloc] init];
    [groupDetailController setGroup:model];
    [groupDetailController setHadJoinedGroup:^(NSString *group_id) {
        for (JYGroupModel *obj in groupListArr) {
            if ([obj.group_id isEqualToString:group_id]) {
                [obj setJoin:@"1"];
                [obj setTotal:[NSString stringWithFormat:@"%ld",(long)[JYHelpers integerValueOfAString:obj.total] + 1]];
                [self updateGroupList];
                break;
            }
        }
        
    }];
    [self.navigationController pushViewController:groupDetailController animated:YES];
}

- (void)signMoreBtnClick{
    JYProfileEditIntroController * _editVC = [[JYProfileEditIntroController alloc] init];
    [self.navigationController pushViewController:_editVC animated:YES];
}

- (void)singleBtnClick:(UIButton *)btn
{
    int isConfirm = [userInfoModel.is_lonely_confirm intValue];
    [btn setEnabled:NO];
    
    if (isConfirm == 0) {

        if (![_show_uid isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]]) {
            

            NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
            [parametersDict setObject:@"profile" forKey:@"mod"];
            [parametersDict setObject:@"user_lonely_confirm" forKey:@"func"];
            
            NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
            [postDict setObject:_show_uid forKey:@"friend_uid"];
            
            [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
                
                NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
                [btn setEnabled:YES];
                if (iRetcode == 1) {
                    
                    NSString *text = [NSString stringWithFormat:@"%ld",(long)[JYHelpers integerValueOfAString:userInfoModel.lonely_confirm] + 1];
                    
                    [userInfoModel setIs_lonely_confirm:@"1"];
                    [userInfoModel setLonely_confirm:text];
                    [self setSingleBtnStatus:btn];

                    
                    [[JYAppDelegate sharedAppDelegate] showTip:@"确认成功"];
                    
                } else {
                    [[JYAppDelegate sharedAppDelegate] showTip:@"确认失败"];
                }
                
            } failure:^(id error) {
                
                NSLog(@"%@", error);
                [self dismissProgressHUDtoView:self.view];
                [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
            }];
        }else{
            [[JYAppDelegate sharedAppDelegate] showTip:@"不能给自己单身确定"];
        }
        
    }else{

        NSDictionary *paraDic = @{@"mod":@"profile",
                                  @"func":@"cancel_lonely_confirm"
                                  };
        NSDictionary *postDic = @{
                                  @"friend_uid":userInfoModel.uid
                                  };
        [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
            NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
            [btn setEnabled:YES];
            if (iRetcode == 1) {
                //do any addtion here...
                NSString *text = [NSString stringWithFormat:@"%ld",(long)[JYHelpers integerValueOfAString:userInfoModel.lonely_confirm] - 1];
                
                [userInfoModel setIs_lonely_confirm:@"0"];
                [userInfoModel setLonely_confirm:text];
                [self setSingleBtnStatus:btn];
                [[JYAppDelegate sharedAppDelegate] showTip:@"取消成功"];
            }else{
                [[JYAppDelegate sharedAppDelegate] showTip:@"取消失败"];
            }
        } failure:^(id error) {
            
            [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        }];
    }
    
}



//点击照片更多
- (void)albumViewClick
{
    if (![self hasAccessToLook]) {
        return;
    }
    JYAlbumController * _albumVC = [[JYAlbumController alloc] init];
    _albumVC.show_uid = _show_uid;
    [_albumVC setIsLimited:_isLimited];
    //            [_seenVC setHidesBottomBarWhenPushed: YES];
    [self.navigationController pushViewController:_albumVC animated:YES];
}

// 喜欢、打招呼、私信...
- (void)toolButtonClick:(UIButton *)button
{
    //    button.selected = !button.selected;
    //加好友
    if (button.tag == 5001) {
        [self addFriend];
    }
    //聊天
    if (button.tag == 5002) {
        if (_isFromChat) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            JYMessageModel *messageModel = [[JYMessageModel alloc] init];
            [messageModel setNick:userInfoModel.nick];
            [messageModel setOid:userInfoModel.uid];
            [messageModel setAvatar:[userInfoModel.avatars objectForKey:@"100"]];
            [messageModel setSex:userInfoModel.sex];
            JYChatController *chatController = [[JYChatController alloc] init];
            [chatController setFromUid:messageModel.oid];
            [chatController setIsGroupChat:NO];
            [chatController setFromMsgModel:messageModel];
            [chatController setFrom:@"3"];
            [self.navigationController pushViewController:chatController animated:YES];
        }
    }
  
}
- (void)addFriend{
    NSDictionary *paraDic = @{@"mod":@"friends",
                              @"func":@"friends_sent_req"
                              };
    NSDictionary *postDic = @{@"uid":ToString([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]),
                              @"fuid":self.show_uid
                              };
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            //                [button setEnabled:NO];
            [(JYAppDelegate*)[[UIApplication sharedApplication] delegate] showTip:@"发送成功"];
        }else if(iRetcode == -2802){
            [(JYAppDelegate*)[[UIApplication sharedApplication] delegate] showTip:@"添加失败：已发出过申请"];
        }else{
            [(JYAppDelegate*)[[UIApplication sharedApplication] delegate] showTip:@"发送失败"];
        }
        
        //加好友后 每到如果通讯录的 每加两次 提示一次导入通讯录
        [JYGuideToAddressBookManager CountNumToAddressBook];
    } failure:^(id error) {
        [self dismissProgressHUDtoView:self.view];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];
}
//加入群组
- (void)joinGroup:(UIButton*)button{

    NSInteger index = button.superview.tag - 123;
    JYGroupModel *group = groupListArr[index];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"你确定加入%@(%@)",group.title,group.total] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView setTintColor:kTextColorBlue];
    [alertView setTag:123+index];
    [alertView show];
    
}
//标签超过两行默认收起，点击more更多
- (void)tagMoreClickGesture{
    if (tagExtend) { //已经展示，实现收起
        tagExtend = false;
        tagListView.height = tagListDefaultHeight;
        tagMoreClick.image = [UIImage imageNamed:@"profile_tag_more"];
        
    }else{ //已经收起，实现展开
        tagExtend = true;
        tagListView.height = tagListOriginalHeight;
        tagMoreClick.image = [UIImage imageNamed:@"profile_up_arrow"];
    }
    [self _adjustTagListUiHeight];
}

//点击添加备注
- (void) _clickUpdateMarkGesture{
    modifyNickMark = [[UIAlertView alloc] initWithTitle:@"添加备注"
                                                message:nil
                                               delegate:self
                                      cancelButtonTitle:@"取消"
                                      otherButtonTitles:@"确定",nil];
    [modifyNickMark setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[modifyNickMark textFieldAtIndex:0] addTarget:self action:@selector(TextFieldDidChangeText:) forControlEvents:UIControlEventEditingChanged];
    //    [[modifyNickMark textFieldAtIndex:0] setDelegate:self];
    [modifyNickMark show];
    
    
}
- (void)tapHeadViewGesture:(UIGestureRecognizer *)gesture
{
    NSLog(@" gesture");
    // 上传头像
    // 初始化actionsheet
    [self _initActionSheetView];
    
}

- (void)shareFriend{
    //    isInviteFriend = YES;

    if (isSelf) {
        NSString *genderStr = @"她们";
        if ([userInfoModel.sex isEqualToString:@"0"]) {
            genderStr = @"他们";
        }
        [shareView setShareContent:[NSString stringWithFormat:@"给我介绍几个合适的对象吧,帮我把资料分享给%@哦！我的资料：http://m.iyouxun.com/wechat/share_profile/?uid=%@",genderStr,_show_uid]];
        [shareView setShareImageUrl:[userInfoModel.avatars objectForKey:@"200"]];
        //没有头像的时候不上传默认头像
        if ([userInfoModel.hasavatar intValue]==1) {
            [shareView setShareImage:avatarImg.image];
        }
        [shareView setShareSingleContent:nil];
//        [shareView setShareImage:avatarImg.image];
        
        [shareView setShareTitle:[NSString stringWithFormat:@"求脱单-%@的资料-友寻",userInfoModel.nick]];
        [shareView setShareUrl:[NSString stringWithFormat:@"http://m.iyouxun.com/wechat/share_profile/?uid=%@",_show_uid]];
        [shareView setProfileDataDic:[JYShareData sharedInstance].myself_profile_dict];
        [shareView positionAnimationIn];
        
    }else{
 

        //没有头像的时候不上传默认头像
        if ([userInfoModel.hasavatar intValue]==1) {
//            [shareView setPid:[userInfoModel.avatars objectForKey:@"pid"]];
            [shareView setShareImage:avatarImg.image];
        }
        [shareView setShareSingleContent:nil];
        [shareView setProfileDataDic:userInfoModel.modelToDictionary];
//        [shareView setPid:[userInfoModel.avatars objectForKey:@"pid"]];
        [shareView setShareImageUrl:[userInfoModel.avatars objectForKey:@"200"]];
        [shareView setShareUrl:[NSString stringWithFormat:@"http://m.iyouxun.com/wechat/share_profile/?uid=%@",self.show_uid]];
        [shareView setShareTitle:[NSString stringWithFormat:@"友寻-%@的资料",userInfoModel.nick]];
        //非单身
        if ([userInfoModel.marriage intValue] != 1) {
            NSString *genderStr = @"他";
            if ([userInfoModel.sex integerValue] == 0) {
                genderStr = @"她";
            }
            [shareView setShareContent:[NSString stringWithFormat:@"%@正在友寻里交友，来认识%@一下吧。%@",genderStr,genderStr,[NSString stringWithFormat:@"http://m.iyouxun.com/wechat/share_profile/?uid=%@",self.show_uid]]];
            [shareView setProfileDataDic:nil];
        }
        
        [shareView positionAnimationIn];
    }
   
}
//求脱单时，弹出来的分享层
- (void)helpFallInLove{

    
    [shareView setShareContent:[self shareContentMake]];

    [shareView setShareImageUrl:[userInfoModel.avatars objectForKey:@"200"]];
    
    //没有头像的时候不上传默认头像
    if ([userInfoModel.hasavatar intValue]==1) {
//        [shareView setPid:[[profileDataDic objectForKey:@"avatars"] objectForKey:@"pid"]];
        [shareView setShareImage:avatarImg.image];
    }
    [shareView setShareSingleContent:[self shareSingleContentMake]];
    [shareView setShareTitle:[NSString stringWithFormat:@"友寻-%@的资料",userInfoModel.nick]];
    [shareView setProfileDataDic:nil];
    [shareView setShareUrl:[NSString stringWithFormat:@"http://m.iyouxun.com/wechat/share_profile/?uid=%@",self.show_uid]];
    [shareView positionAnimationIn];
    
}

//看别人时点击右上角
- (void)_initRightTopButton
{
    if (isSelf) {
        rightTopButtonSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享给好友", nil];
    }else if([JYHelpers integerValueOfAString:userInfoModel.is_friend] != 0){
        
        rightTopButtonSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享给好友", @"举报",@"加入黑名单", nil];
    }else{
        rightTopButtonSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享给好友", @"举报", nil];
    
    }
    [rightTopButtonSheet showInView:self.view];
}

//弹出举报层
- (void) _reportUserClick{
    reportUserSheet = [[UIActionSheet alloc] initWithTitle:@"选择举报类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"骚扰信息", @"虚假资料",@"不良照片",@"反动政治",@"欺诈钱财", nil];
    [reportUserSheet showInView:self.view];
}

//当看别人时，点击给别人贴标签
- (void)addTagLabelGesture{
    //JYProfileAddTagController * _albumVC = [[JYProfileAddTagController alloc] init];
    //[self.navigationController pushViewController:_albumVC animated:YES];
    if (tagListDic.count <= 3) {
        if (addTagView == nil) {
            addTagView = [[JYContactProfileAddTagView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            
            __weak typeof(self) weakSelf = self;
            [addTagView.recommendTagView setClickHandler:^(NSString * __nonnull str) {
                
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf requestAddTag:str];
                
            }];
            [[JYAppDelegate sharedAppDelegate].window addSubview:addTagView];
        }
        [addTagView show];
    }else{
        addOneTagForUser = [[UIAlertView alloc] initWithTitle:@"添加标签"
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                            otherButtonTitles:@"确定",nil];
        [addOneTagForUser setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [[addOneTagForUser textFieldAtIndex:0] addTarget:self action:@selector(TextFieldDidChangeText:) forControlEvents:UIControlEventEditingChanged];
        [[addOneTagForUser textFieldAtIndex:0] setTag:111];
        [addOneTagForUser show];

    }
    
}

- (void) browserThisPhotoClick:(UITapGestureRecognizer *)gesture{
    
    NSDictionary  *photoes = userInfoModel.photoes;
    NSInteger photoCount = photoes.count;
    if (photoes.count>=4) { //不是自已看自已显示4张
        photoCount = 4;
    }
    
    NSInteger imgIndex = gesture.view.tag -3000;

    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    //下边两属性是 点赞的
    if (imagePraseData.count>0) {
        browser.imagePraiseData = imagePraseData;
        browser.fuid = _show_uid;
        browser.mRootCtrl = self;
    }
    
    browser.sourceImagesContainerView = [sectionThree viewWithTag:123];// [self viewWithTag:gesture.view.tag]; // 原图的父控件
    browser.imageCount = photoCount; // 图片总数
    NSString *shareContent = [NSString stringWithFormat:@"来自%@的友寻相册",userInfoModel.nick];
    [browser setShareContent:shareContent];
    [browser setTag:kAlbumBrowserTag];
    browser.currentImageIndex = (int)imgIndex;
    browser.delegate = self;
    [browser show];
    
}

#pragma mark - Notification
//通知，重新刷新ui，弃用
- (void)refreshProfileInfoNotification:(NSNotification*)note
{
    [self _getProfileInfo];
}

//通知-编辑标签
- (void)profileEditTagNotification:(NSNotification*)note
{
    tagListDic = (NSMutableDictionary *)note.userInfo;
    [self tagListViewDidChangeFrame];
    [self _adjustTagListUiHeight];
    //[self _getProfileInfo];
}

//通知删除标签
- (void)profileDelTagNotification:(NSNotification*)note
{
    tagListDic = (NSMutableDictionary *)note.userInfo;
    tagListView.tagDic = (NSMutableDictionary *)tagListDic;
    [tagListView resetAllTagList];
    [self tagListViewDidChangeFrame];
    [self _adjustTagListUiHeight];
    
}

//通知-点击标签
- (void)profileClickTagNotification:(NSNotification*)note
{
    [self tagListViewDidChangeFrame];
    
    [self _adjustTagListUiHeight];
    //[self _getProfileInfo];
    if ([_show_uid isEqualToString:ToString([SharedDefault objectForKey:@"uid"])]) {
        NSLog(@"刷新profile");
        [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshProfileInfoNotification object:nil];
    }
}

#pragma mark - photobrowser代理方法

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    if (browser.tag == kAlbumBrowserTag) {
        return ((UIImageView *)[sectionThree viewWithTag:3000+index]).image;
    }else{
        return avatarImg.image;
    }
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    if (browser.tag == kAlbumBrowserTag) {
        NSDictionary  *photoes = userInfoModel.photoes;
        NSArray *photoesValue = [photoes allValues];
        return [NSURL URLWithString:[[photoesValue objectAtIndex:index] objectForKey:@"800"]]; // 图片路径
    }else{
        return [NSURL URLWithString:[userInfoModel.avatars objectForKey:@"600"]];
    }
    
}

//返回当前图片的pid
- (NSString *)photoBrowserId:(SDPhotoBrowser *)browser pidForIndex:(NSInteger)index{
    if (browser.tag == kAlbumBrowserTag) {
        NSDictionary  *photoes = userInfoModel.photoes;
        NSArray *photoesKey = [photoes allKeys];
        return [photoesKey objectAtIndex:index];
    }else{
        return [userInfoModel.avatars objectForKey:@"pid"];
    }

}

#pragma mark - UIAlertViewDelegate

//点击确定时，弹出可输入的alert
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //点击确定才有的操作
    if(alertView == modifyNickMark){
        if (buttonIndex == 1) {
           
            UITextField *myField =  [alertView textFieldAtIndex:0];
            
            NSMutableString *mutStr = [NSMutableString stringWithString:myField.text];
            NSString *text = myField.text;
            NSRange range = [mutStr rangeOfString:@" "];
            while (range.location != NSNotFound) {
                [mutStr deleteCharactersInRange:range];
                range = [mutStr rangeOfString:@" "];
            }
            
            if (mutStr.length == 0) {
                //                [[JYAppDelegate sharedAppDelegate] showTip:@"请输入备注内容"];
                //                return;
                text = @"";
            }
            
            NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
            [parametersDict setObject:@"profile" forKey:@"mod"];
            [parametersDict setObject:@"update_user_mark" forKey:@"func"];
            
            NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
            [postDict setObject:_show_uid forKey:@"uid"];
            [postDict setObject:text forKey:@"mark"];
            
            [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
                
                NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
                
                if (iRetcode == 1) {
                    
//                    [profileDataDic setValue:text forKey:@"mark"];
                    
                    if (text.length == 0) {
                        [self layoutNickLabAndMarkLabWithNick:userInfoModel.nick mark:@"(添加备注)"];

                    }else{
                        
                        [[JYAppDelegate sharedAppDelegate] showTip:@"备注修改成功"];
                        [self layoutNickLabAndMarkLabWithNick:text mark:@"(修改备注)"];
                    }
                    
                } else {
                    [[JYAppDelegate sharedAppDelegate] showTip:@"备注修改失败"];
                }
                
            } failure:^(id error) {
                
                NSLog(@"%@", error);
                [self dismissProgressHUDtoView:self.view];
                [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
                
            }];
        }
        
    }else if(alertView == addOneTagForUser){
        //点击确定才有的操作
        if (buttonIndex == 1) {
            
            UITextField *myField =  [alertView textFieldAtIndex:0];
            
            [self requestAddTag:myField.text];
            
        }
    }else if(alertView.tag == 3333){//被系统拉黑账户不让查看
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{//加入群组
        if (buttonIndex == 1) {
            NSInteger index = alertView.tag - 123;
            JYGroupModel *group = (JYGroupModel*)[groupListArr objectAtIndex:index];
            NSDictionary *paraDic = @{@"mod":@"chat",
                                      @"func":@"add_group"
                                      };
            NSDictionary *postDic = @{@"touid":ToString([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]),
                                      @"group_id":group.group_id
                                      };
            [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
                NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
                if (iRetcode == 1) {
                    //do any addtion here...
//                    'result' -1 禁止加入 1-加入成功 2-等待群主审核 3 申请过

                    if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                        NSInteger result = [JYHelpers integerValueOfAString:[[responseObject objectForKey:@"data"] objectForKey:@"result"]];
                        if (result == 1) {
                            [[JYAppDelegate sharedAppDelegate] showTip:@"恭喜,加入成功"];
                            [group setJoin:@"1"];
                            [group setTotal:[NSString stringWithFormat:@"%ld",(long)[group.total integerValue]+1]];
                            [self updateGroupList];
                        }else if (result == 2){
                            [[JYAppDelegate sharedAppDelegate] showTip:@"申请成功,等待群主审核"];
                        }else if (result == -1){
                            [[JYAppDelegate sharedAppDelegate] showTip:@"该群组禁止加入"];
                        }else if (result == 3){
                            [[JYAppDelegate sharedAppDelegate] showTip:@"申请已经提交，请耐心等待"];
                        }
                    }
                }else{
                    [[JYAppDelegate sharedAppDelegate] showTip:@"申请失败"];
                }
            } failure:^(id error) {
                [self dismissProgressHUDtoView:self.view];
                [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
            }];
  
        }
        
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(actionSheet == reportUserSheet){
        if(buttonIndex  <5){ // 0- 骚扰信息 1- 虚假资料 2- 不良照片 3-反动政治 4 - 欺诈钱财
            NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
            [parametersDict setObject:@"police" forKey:@"mod"];
            [parametersDict setObject:@"report_profile" forKey:@"func"];
            
            NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
            [postDict setObject:_show_uid forKey:@"uid"];
            [postDict setObject:[NSString stringWithFormat:@"%ld",(long)buttonIndex] forKey:@"type"];
            
            
            [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id  responseObject) {
                
                NSInteger iRetcode = [JYHelpers integerValueOfAString:[responseObject objectForKey:@"retcode"]];
                
                if (iRetcode == 1) {
                    
                    [[JYAppDelegate sharedAppDelegate] showTip:@"举报成功"];
                    
                } else {
                    [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
                }
                
            } failure:^(id error) {
                
                NSLog(@"%@", error);
                [self dismissProgressHUDtoView:self.view];
                [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
            }];
        }
        
    }else if (actionSheet == rightTopButtonSheet){
        switch (buttonIndex) {
            case 0:
            {
                [self shareFriend];
            }
                break;
            case 1:
            {
                if (!isSelf) {
                    [self _reportUserClick];
                }
                
            }
                break;
            case 2:{
                if (![[actionSheet buttonTitleAtIndex:2] isEqualToString:@"取消"]) {
                    [self addFriendToBlackList];
                }
            }
                break;
            default:
                break;
        }
        
    }

}
//#pragma mark - UITextFieldDelegate
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if ([textField isEqual:[modifyNickMark textFieldAtIndex:0]] && (textField.text.length+string.length) > 8 && ![string isEqualToString:@""]) {
//        return NO;
//    }else
//        return YES;
//}
#pragma mark - EditingChanged Action
- (void)TextFieldDidChangeText:(UITextField*)textField{
    [textField setClipsToBounds:NO];
//    NSString *text = textField.text;
    NSInteger limitedLength = 8;
    if (textField.tag == 111) {
        limitedLength = 10;
    }
    bool isChinese;//判断当前输入法是否是中文
    if ([[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString: @"en-US"]) {
        isChinese = false;
    }
    else
    {
        isChinese = true;
    }
                // 8位
        NSString *str = [[textField text] stringByReplacingOccurrencesOfString:@"?" withString:@""];
        if (isChinese) { //中文输入法下
            UITextRange *selectedRange = [textField markedTextRange];
            //获取高亮部分
            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                NSLog(@"汉字");
                if ( str.length>=(limitedLength+1)) {
                    [textField makeToast:[NSString stringWithFormat:@"最多输入%ld个汉字",(long)limitedLength] duration:1 position:[NSValue valueWithCGPoint:CGPointMake(textField.width/2, 14)]];
                    NSString *strNew = [NSString stringWithString:str];
                    [textField setText:[strNew substringToIndex:limitedLength]];
                }
            }
            else
            {
                NSLog(@"输入的英文还没有转化为汉字的状态");
                
            }
        }else{
            NSLog(@"str=%@; 本次长度=%ld",str,(long)[str length]);
            if ([str length]>=(limitedLength+1)) {
//                [[JYAppDelegate sharedAppDelegate].window makeToast:[NSString stringWithFormat:@"最多输入%ld个汉字",(long)limitedLength] duration:1 position:[NSValue valueWithCGPoint:CGPointMake(kScreenWidth/2, 40)]];
                [textField makeToast:[NSString stringWithFormat:@"最多输入%ld个汉字",(long)limitedLength] duration:1 position:[NSValue valueWithCGPoint:CGPointMake(textField.width/2, 14)]];
                NSString *strNew = [NSString stringWithString:str];
                [textField setText:[strNew substringToIndex:limitedLength]];
            }
        }
}
- (void)sameFriendLabText{

   
    NSMutableString *nick = [NSMutableString stringWithString:((JYCreatGroupFriendModel*)[_sameFriendList firstObject]).nick];
    //找昵称最短的好友
    for (JYCreatGroupFriendModel *friend in _sameFriendList) {
        if (friend.nick.length < nick.length) {
            nick = nil;
            nick = [NSMutableString stringWithString:friend.nick];
        }
    }
    //只有一个好友直接显示
    if (_sameFriendList.count == 1) {
        [sameFriendLab setTextColor:kTextColorBlue];
        [sameFriendLab setText:nick];
        return;
    }
    NSString *countStr = [NSString stringWithFormat:@"%ld",(long)_sameFriendList.count];
    NSString *resultStr = [NSString stringWithFormat:@"%@等%@人",nick,countStr];
    
    CGFloat width = [JYHelpers getTextWidthAndHeight:resultStr fontSize:15].width;
    //防止最短的昵称太长的裁剪
    while (width > sameFriendLab.width) {
        NSRange range = [nick rangeOfString:@"..."];
        if (range.location != NSNotFound) {
            [nick deleteCharactersInRange:range];
        }
        NSInteger location = nick.length - 2;
        [nick deleteCharactersInRange:NSMakeRange(location, 2)];
        [nick appendString:@"..."];
        resultStr = nil;
        resultStr = [NSString stringWithFormat:@"%@等%@人",nick,countStr];
        width = [JYHelpers getTextWidthAndHeight:resultStr fontSize:15].width;
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:resultStr];
    [str addAttribute:NSForegroundColorAttributeName value:kTextColorBlue range:NSMakeRange(0, nick.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[JYHelpers setFontColorWithString:@"#2695ff"] range:NSMakeRange(nick.length+1, countStr.length)];
    [sameFriendLab setAttributedText:str];
}
- (NSString*)shareContentMake{
    
//    NSString * animal = [[[JYShareData sharedInstance].profile_dict objectForKey:@"animal"] objectForKey:[profileDataDic objectForKey:@"animal"]];
//    NSString * mystar = [[[JYShareData sharedInstance].profile_dict objectForKey:@"star"] objectForKey:[profileDataDic objectForKey:@"star"]];
//
//    NSString *star = @"";
//    if (animal.length != 0 && mystar.length != 0) {
//        star = [NSString stringWithFormat:@"%@，属相%@",mystar,animal];
//    }

    NSString *province = [[JYShareData sharedInstance].city_code_dict objectForKey:userInfoModel.live_location];

    NSString *friend = @"";
    if ([JYHelpers integerValueOfAString:userInfoModel.is_friend] == 1) {
        friend = [[JYShareData sharedInstance].myself_profile_dict objectForKey:@"nick"];
    }
    NSMutableString *contenStr = [NSMutableString stringWithFormat:@"我是%@，",userInfoModel.nick];
    if (province.length > 0 && ![province isEqualToString:@"不限"]) {
        [contenStr appendFormat:@"来自%@，",province];
    }
    if (friend.length > 0) {
        [contenStr appendFormat:@"是%@的好友，",friend];
    }

    [contenStr appendFormat:@"我的资料：http://m.iyouxun.com/wechat/share_profile/?uid=%@",userInfoModel.uid];
    
    return contenStr;
}

- (NSString*)shareSingleContentMake{
//我是XX的朋友，他/她已经单身好久啦，你觉得他/她是否会是你的真命天子/真命天女呢？+资料卡
    NSMutableString *resultStr = [NSMutableString string];
    NSString *genderStr = @"他";
    NSString *str = @"天子";
    
    if ([userInfoModel.sex isEqualToString:@"0"]) {
        genderStr = @"她";
        str = @"天女";
    }
    [resultStr appendFormat:@"我是%@的朋友，%@已经单身好久啦，你觉得%@是否会是你的真命%@呢？%@的资料：\n",userInfoModel.nick,genderStr,genderStr,str,genderStr];
    
//    NSString * animal = [[[JYShareData sharedInstance].profile_dict objectForKey:@"animal"] objectForKey:userInfoModel.animal];
    NSString *birth = [JYHelpers birthdayTransformToCentery:userInfoModel.birthday];
    NSString * mystar = [[[JYShareData sharedInstance].profile_dict objectForKey:@"star"] objectForKey:userInfoModel.star];

    NSString *star = @"";
    if (birth.length != 0 && mystar.length != 0) {
        star = [NSString stringWithFormat:@"%@，%@",birth,mystar];
    }
    NSString *province = [[JYShareData sharedInstance].province_code_dict objectForKey:userInfoModel.live_location];
    
    NSString *confirm = [NSString stringWithFormat:@"%@位好友认证%@是单身",userInfoModel.lonely_confirm,genderStr];
    
    NSString *city = [[JYShareData sharedInstance].province_code_dict objectForKey:userInfoModel.live_sublocation];

    NSMutableString *contenStr = [NSMutableString stringWithFormat:@"%@",userInfoModel.nick];
    if (star.length > 0) {
        [contenStr appendFormat:@"，%@",star];
    }
    if (province.length > 0 && ![province isEqualToString:@"不限"]) {
        [contenStr appendFormat:@"，%@",province];
    }
    if (city.length > 0 && ![city isEqualToString:@"不限"]) {
        [contenStr appendFormat:@"，%@",city];
    }
    [contenStr appendFormat:@"，%@",confirm];
    [contenStr appendFormat:@"，详细资料：http://m.iyouxun.com/wechat/share_profile/?uid=%@",userInfoModel.uid];

    [resultStr appendString:contenStr];
    NSLog(@"resultStr -->%@",resultStr);
    return resultStr;
}
#pragma mark - Setter && Getter
- (void)setShow_uid:(NSString *)show_uid{
    
    if ([show_uid isKindOfClass:[NSString class]]) {
        _show_uid = show_uid;
    }else if ([show_uid isKindOfClass:[NSNumber class]]){
        _show_uid = [NSString stringWithFormat:@"%@",show_uid];
    }else{
        _show_uid = ToString([SharedDefault objectForKey:@"uid"]);
    }
    
}
- (void)setProfileDataDic:(NSDictionary*)dic{
    if ([dic isKindOfClass:[NSDictionary class]]) {
        userInfoModel = [[JYProfileModel alloc] initWithDataDic:dic];
        //去下载图片点赞的信息
        [self DownloadPhotoPraise];
    }
}
- (void)DownloadPhotoPraise{
//    [JYProfileDownImagePraiseManager DownImagePraiseDate:userInfoModel.photoes andSucceedBlock:^(NSMutableDictionary *PraseDict){
//        imagePraseData = [[NSMutableArray alloc]init];
//        for (NSString *key in PraseDict) {
//            NSDictionary *dict = PraseDict[key][@"data"];
//            JYImagePraiseModel *model = [[JYImagePraiseModel alloc]init];
//            model.count = [NSString stringWithFormat:@"%@",dict[@"count"]];
//            if (dict[@"list"] && [dict[@"list"]isKindOfClass:[NSDictionary class]]) {
//                model.list = [dict[@"list"] mutableCopy];
//            }else{
//                NSMutableDictionary *mDict = [[NSMutableDictionary alloc]init];
//                model.list = mDict;
//            }
//            model.pid = [NSString stringWithFormat:@"%@",dict[@"pid"]];
//            [imagePraseData addObject:model];
//        }
//    }];
    [JYProfileDownImagePraiseManager DownImagePraiseDate:userInfoModel.photoes andUid:userInfoModel.uid andSucceedBlock:^(NSMutableDictionary *PraseDict){
        imagePraseData = [[NSMutableArray alloc]init];
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
    }];
}
//设置确认单身按钮状态
- (void)setSingleBtnStatus:(UIButton*)singleBtn{
    
    if ([userInfoModel.is_lonely_confirm intValue] == 0) { //没有确认过是单身
        
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已有%@人确认TA是单身 我也来帮TA认证",[NSString stringWithFormat:@"%@",userInfoModel.lonely_confirm]]];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:kTextColorWhite range:NSMakeRange(0, attributeStr.length)];
        [singleBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
        [singleBtn setBackgroundColor:kTextColorBlue];
        
    }else{
        
        NSString *str = [NSString stringWithFormat:@"已有%@人确认TA是单身 我已帮TA认证",[NSString stringWithFormat:@"%@",userInfoModel.lonely_confirm]];
        
        NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 取消认证",str]];
        [mutStr addAttribute:NSForegroundColorAttributeName value:kTextColorWhite range:NSMakeRange(0, str.length)];
        [mutStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(str.length, 5)];
        
        [singleBtn setAttributedTitle:mutStr forState:UIControlStateNormal];
        
        [singleBtn setBackgroundColor:kTextColorLightGray];
        
    }

}
- (BOOL)hasAccessToLook{
    
    NSInteger show = [JYHelpers integerValueOfAString:userInfoModel.allow_my_profile_show];
    NSInteger friend = [JYHelpers integerValueOfAString:userInfoModel.is_friend];
    if ( show == 1 &&  friend != 1) {//只允许一度好友查看 且不是一度好友
        [[JYAppDelegate sharedAppDelegate] showTip:@"你没有权限查看更多内容了。"];
        return NO;
    }else if(show == 2 && friend == 0){//只有一度二度可以查看且不是一二度好友
        return NO;
    }else if (show == 3 && friend == 0) {//限制只能查看5条内容
        _isLimited = YES;
    }
    return YES;
}

//设置已添加标签的标签title数组，用于判断推荐标签和添加的标签是否已经添加
- (void)setTagTitles{
    
    [sourceTagTitleArr removeAllObjects];
    if (sourceTagTitleArr == nil) {
        sourceTagTitleArr = [NSMutableArray array];
    }
    
    for (NSDictionary *dic in tagListDic.allValues) {
        [sourceTagTitleArr addObject:[dic objectForKey:@"title"]];
    }
}

//成功添加标签后调用，用于清除当前显示推荐标签中的和添加标签相同的标签并替换。
- (void)replaceTagTitle:(NSString*)tagTitle{
    //不在显示的推荐标签中不做任何操作
    if (![showRecommendTagTitleArr containsObject:tagTitle]) {
        return;
    }
    
    //如果源推荐标签小于6个，找不到新的来替换，直接删除
    if (sourceRecommendTagTitleArr.count <= 6) {
        
        [showRecommendTagTitleArr removeObject:tagTitle];
        [addTagView reloadRecommendTagView:showRecommendTagTitleArr];
//        [self adjustFrameOfSubviews];
        
    }else{
        //源推荐标签大于6个 则找一个新的来替换已经添加的标签
        if ([showRecommendTagTitleArr containsObject:tagTitle]) {
            while (1) {//找到新标签后break
                NSString *aTagTitle = [sourceRecommendTagTitleArr objectAtIndex:arc4random()%showRecommendTagTitleArr.count];
                if (![showRecommendTagTitleArr containsObject:aTagTitle]) {
                    NSInteger index = [showRecommendTagTitleArr indexOfObject:tagTitle];
                    [showRecommendTagTitleArr replaceObjectAtIndex:index withObject:aTagTitle];
                    break;
                }
            }
            //刷新recommendTagView
            [addTagView reloadRecommendTagView:showRecommendTagTitleArr];
            //调整控制器中的视图
//            [self adjustFrameOfSubviews];
        }
    }
    
}

@end
