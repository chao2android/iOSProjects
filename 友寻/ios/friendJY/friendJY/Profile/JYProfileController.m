//
//  ViewController.m
//  profileTableView
//
//  Created by XU on 15/2/28.
//  Copyright (c) 2015年 XU. All rights reserved.
//

#import "JYProfileController.h"
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
#import "JYPhoto.h"
#import "SDPhotoBrowser.h"
#import "JYGroupModel.h"
#import "JYGroupView.h"
#import "JYDynamicController.h"
#import "JYProfileEditGroupController.h"
#import "JYProfileModel.h"
#import "JYMyGroupModel.h"
#import "JYChatController.h"
#import "JYProfileDownImagePraiseManager.h"
#import "JYImagePraiseModel.h"
#import "JYGroupImagesController.h"

#define kProfileHeadView 500
#define kSectionDistance 10
#define kSectionWidth kScreenWidth-10
#define kAvatarBrowserTag 1234
#define kAlbumBrowserTag 4321

@interface JYProfileController ()<SDPhotoBrowserDelegate,JYProfileIntroDidChangedDelegate>
{
    /**
     *  是否可以上传图片 因为动态处的上传用的是同一个通知。又不能通过写在viewWillAppear的方式添加通知，所以才有这个属性。
     */
//    BOOL canUploadImages;
    UIScrollView *myScrollView;
    
    JYProfileModel *userProfileModel;
    
//    NSDictionary * profileDataDic;
    NSDictionary * profileOptionDic;
    UIImageView *avatarImg; // 头像
    UIImageView *avatarBGImg;
    NSString * nickMark;
    NSMutableDictionary * tagListDic;
    /**
     *  标签
     */
    UIView *sectionSeven;//标签部份，因为标签 是高度不固定
    /**
     *  相册
     */
    UIView *sectionThree;
    /**
     *  动态
     */
    UIView *sectionFour;//动态
    CGPoint tagStartPostion;//标签 的开始位置
    /**
     *  群组
     */
    UIScrollView *sectionEight;//群组的标签
    UIView *sectionNine; //系统设置
    JYProfileTagListView *tagListView;
    BOOL tagExtend; //标签是否展开，高度超过80，默认收起
    BOOL groupExtend;//群组是否展开 超过5个群组收起。
    
    UIImageView *tagMoreClick;
    NSInteger tagListOriginalHeight; //标签的原始高度，便于点击展开和收起时计算高度
    NSInteger tagListDefaultHeight;
    UILabel *nickRemarkLabel;//昵称备注
    
    JYProfileShareView *shareView;//分享层
    NSMutableArray *_tempImagesArrs; //选择上传的图片
    NSMutableArray *_showImagesArrs; //进来时显示已上传的图片
    int _uploadedPhotoCompleteCount; //上传图片的数，最多为4张
    UIActionSheet *uploadPhotosheet;
//    UIActionSheet *reportUserSheet;
//    UIActionSheet *rightTopButtonSheet;
    
//    UIAlertView *addOneTagForUser;//看别人时添加一个标签
    UITextView *signContentTextView;
    UILabel *newDynamicContent;
    NSMutableArray *groupListArr;//群组信息
//    NSMutableArray *sourceGroupArr;
//    NSInteger lastGroupCount;
    BOOL isInviteFriend;//是脱单还是 邀请好友验证
    UIButton *editGroupBtn;
    UILabel *starLab;
    UILabel *cityLab;
    
    NSMutableArray *imagePraseData;
    
    NSMutableArray *imageArray;
}
@property (nonatomic, strong) NSMutableArray *photoesArr;

@end

@implementation JYProfileController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    groupListArr = [NSMutableArray array];
    profileOptionDic = [JYShareData sharedInstance].profile_dict;
    _show_uid = ToString([SharedDefault objectForKey:@"uid"]);
    [self setTitle:@"我"];
    [self reloadData];
    [[JYProfileData sharedInstance] loadMyProfileDataWithSuccessBlcok:^(id responseObject) {
        [self reloadData];
        
    } failureBlock:^(id error) {
        
    }];
    //加载分享的ui层
    shareView = [[JYProfileShareView alloc] init];

    [[JYAppDelegate sharedAppDelegate].window addSubview:shareView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profileDelTagNotification:) name:kProfileDelTagsNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profileDataDidChanged) name:kRefreshProfileInfoNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectImagesToUpload:) name:kConfirmSelectedImagesNotification object:nil];

}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

//    canUploadImages = YES;
    //当自已看自已时，有添加标签，和删除标签
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profileClickTagNotification:) name:kProfileClickTagsNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profileEditTagNotification:) name:kProfileEditTagsNotification object:nil];
    
    if (myScrollView == nil) {
        [[JYProfileData sharedInstance] loadMyProfileDataWithSuccessBlcok:^(id responseObject) {
            [self reloadData];
        } failureBlock:^(id error) {
            
        }];
    }
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localImageGroupToCameraAction:) name:kLocalImageGroupToCameraNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    canUploadImages = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kProfileClickTagsNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kProfileEditTagsNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kConfirmSelectedImagesNotification object:nil];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLocalImageGroupToCameraNotification object:nil];

}
- (void)dealloc{
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRefreshProfileInfoNotification object:nil];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kProfileHasEditGroupNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - subviews

- (void)reloadData{
//    lastGroupCount = 0;
    tagExtend = false; //默认收起
    groupExtend = false;
    [self loadLastDynamic];
    [self _userTagList];
    [self getUserGroupList];
    //    profileDataDic = [JYShareData sharedInstance].myself_profile_dict;
    userProfileModel = [JYShareData sharedInstance].myself_profile_model;
    [myScrollView removeFromSuperview];
    [self setPhotoesArr:nil];
    [self _initScrollViews];
    
    //去下载图片点赞的信息
    [self DownloadPhotoPraise];
}
- (void)DownloadPhotoPraise{
//    [JYProfileDownImagePraiseManager DownImagePraiseDate:userProfileModel.photoes andSucceedBlock:^(NSMutableDictionary *PraseDict){
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
    [JYProfileDownImagePraiseManager DownImagePraiseDate:userProfileModel.photoes andUid:userProfileModel.uid andSucceedBlock:^(NSMutableDictionary *PraseDict){
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


// 初始化scrollView视图
- (void)_initScrollViews
{
    if (myScrollView) {
        [myScrollView removeFromSuperview];
    }
    // 头视图
    //    UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kProfileHeadView)];
    //    headView.tag = 7000;
    //    headView.userInteractionEnabled = YES;
    //    headView.backgroundColor = [UIColor clearColor];
    //    headView.image = [UIImage imageNamed:@"bg_tadeziliao.png"];
    
    myScrollView = [[UIScrollView alloc] init];
    
    CGFloat height = kScreenHeight - kTabBarViewHeight - kStatusBarHeight - kNavigationBarHeight;
    
    NSLog(@"height --> %lf",height);
    
    myScrollView.frame = CGRectMake(0, 0, kScreenWidth, height); // frame中的size指UIScrollView的可视范围
//    myScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
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
    
//    NSString *sexStr = [profileDataDic objectForKey:@"sex"];
    // 头像
    avatarImg = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 75, 75)];
    avatarImg.userInteractionEnabled = YES;
    avatarImg.layer.cornerRadius = 37.5;
    avatarImg.layer.borderColor =[[UIColor whiteColor] CGColor];
    avatarImg.layer.borderWidth = 3;
    
    avatarImg.layer.masksToBounds = TRUE;
    
    //avatarImg.layer.mask =
    avatarImg.clipsToBounds = YES;
    avatarImg.backgroundColor = [UIColor clearColor];
    
    if ([userProfileModel.sex integerValue] == 1) {
        avatarImg.image = [UIImage imageNamed:@"pic_morentouxiang_man"]; //男的默认图标
    } else {
        avatarImg.image = [UIImage imageNamed:@"pic_morentouxiang_woman"]; //女的默认图标
    }
    [avatarBGImg addSubview:avatarImg];
    __weak typeof(self) _weakSelf = self;
    [avatarImg setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:userProfileModel.avatars[@"200"]]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        __strong typeof(_weakSelf) _strongSelf = _weakSelf;
        [_strongSelf performSelectorInBackground:@selector(writeAvatarToFile:) withObject:image];
//        NSData *imageData = UIImagePNGRepresentation(image);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
//    [avatarImg setImageWithURL:[NSURL URLWithString:[userProfileModel.avatars objectForKey:@"200"]]];
    //只有自已才能点击编辑
    [avatarImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAvatarView:)]];

    
    UITapGestureRecognizer *editTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoEditController:)];
    
    //性别
    UIImageView *sexImageView = [[UIImageView alloc] initWithFrame:CGRectMake(avatarBGImg.right+17, avatarBGImg.top+10, 16, 16)];
    sexImageView.userInteractionEnabled = YES;
    sexImageView.backgroundColor = [UIColor clearColor];
    if ([userProfileModel.sex intValue] == 1) { //1-男, 0-女
        sexImageView.image = [UIImage imageNamed:@"male_16"];
    }else{
        sexImageView.image = [UIImage imageNamed:@"female_16"];
    }
    [sectionOne addSubview:sexImageView];
    
    //如果是自已，显示编辑按钮，如果是别人显示一度或二度标签
    UILabel *editLable = [[UILabel alloc] initWithFrame:CGRectMake(sectionOne.right - 45, sectionOne.top, 40, 15)];
    editLable.backgroundColor = [UIColor clearColor];
    editLable.textAlignment = NSTextAlignmentLeft;
    editLable.font = [UIFont systemFontOfSize:15];
    editLable.textColor = [JYHelpers setFontColorWithString:@"#2695ff"];
    editLable.text = @"编辑";
    [editLable setUserInteractionEnabled:YES];
    [sectionOne addSubview:editLable];
    [editLable addGestureRecognizer:editTap];
    
    //昵称
    UILabel *nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
    //    [nickLabel setNumberOfLines:0];
    nickLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    nickLabel.textAlignment = NSTextAlignmentLeft;
    nickLabel.backgroundColor = [UIColor clearColor];
    nickLabel.textColor = [JYHelpers setFontColorWithString:@"#303030"];
    nickLabel.font = [UIFont systemFontOfSize:14];
    // 测试字串
    NSString *text = userProfileModel.nick;
    //    CGSize labelsize = [JYHelpers getTextWidthAndHeight:text fontSize:14];
    nickLabel.text = text;
    [nickLabel setFrame:CGRectMake(sexImageView.right+6, sexImageView.top, editLable.left - sexImageView.right - 6, 16)];
    [sectionOne addSubview:nickLabel];
    
//    UILabel *marriageLabel = [[UILabel alloc] initWithFrame:CGRectMake(sexImageView.left, sexImageView.bottom+5, 50, 20)];
//    [marriageLabel setText:@"情感状态:"]
    //婚姻状况
    UILabel *marryStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(sexImageView.left , sexImageView.bottom+5, 120, 20)];
    marryStatusLabel.textAlignment = NSTextAlignmentLeft;
    marryStatusLabel.backgroundColor = [UIColor clearColor];
    marryStatusLabel.textColor = [JYHelpers setFontColorWithString:@"#2695ff"];
    marryStatusLabel.font = [UIFont systemFontOfSize:14];
    //1-为单身,2-恋爱中，3-已婚，4-保密
    NSString *marriageStatus = [[[JYShareData sharedInstance].profile_dict objectForKey:@"marriage"] objectForKey:userProfileModel.marriage];
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"情感状态：%@",marriageStatus]];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:kTextColorBlack range:NSMakeRange(0, 5)];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:kTextColorBlue range:NSMakeRange(5, marriageStatus.length)];
    
    [marryStatusLabel setAttributedText:attributeStr];
    [marryStatusLabel setWidth:[JYHelpers getTextWidthAndHeight:[NSString stringWithFormat:@"情感状态：%@",marriageStatus] fontSize:14].width];
    [sectionOne addSubview:marryStatusLabel];
    
    starLab = [[UILabel alloc] initWithFrame:CGRectMake(marryStatusLabel.left, marryStatusLabel.bottom+5, 50, marryStatusLabel.height/2)];
    [starLab setFont:[UIFont systemFontOfSize:10]];
    [starLab setTextColor:kTextColorBlack];
    [sectionOne addSubview:starLab];
    
    if (![userProfileModel.birthday isEqualToString:@"0000-00-00"]) {
        
        NSLog(@"%@,%@",userProfileModel.animal,userProfileModel.star);
//        NSString * animal = [[profileOptionDic objectForKey:@"animal"] objectForKey:userProfileModel.animal];
        NSString *birth = [JYHelpers birthdayTransformToCentery:userProfileModel.birthday];
        NSString * mystar = [[profileOptionDic objectForKey:@"star"] objectForKey:userProfileModel.star];
        NSString *text = [NSString stringWithFormat:@"%@ %@",birth,mystar];
        CGFloat starWidth = [JYHelpers getTextWidthAndHeight:text fontSize:10].width;
        [starLab setFrame:CGRectMake(marryStatusLabel.left, marryStatusLabel.bottom+5, starWidth, marryStatusLabel.height/2)];
        [starLab setText:text];
    }
    
    if (![userProfileModel.live_location isEqualToString:@"0"]) {
        
        NSString *province = @" ";
        //过滤 不限
        if (![userProfileModel.live_location isEqualToString:@"0"]) {
            province = [[JYShareData sharedInstance].province_code_dict objectForKey:userProfileModel.live_location];
        }
        NSString *city = @" ";
        if (![userProfileModel.live_sublocation isEqualToString:@"0"]) {
            city = [[JYShareData sharedInstance].city_code_dict  objectForKey:userProfileModel.live_sublocation];
        }
        //过滤 空串
        NSString *province_city = @" ";
        if (province && city) {
            province_city = [NSString stringWithFormat:@"%@ %@", province, city];
        }
        
        //        NSString *province = [[JYShareData sharedInstance].province_code_dict objectForKey:[profileDataDic objectForKey:@"live_location"]];
        //        NSString *city = [[JYShareData sharedInstance].city_code_dict  objectForKey:[profileDataDic objectForKey:@"live_sublocation"]];
        //        NSString *contentStr = [NSString stringWithFormat:@"%@ %@",province,city];
        
        CGFloat contentW = [JYHelpers getTextWidthAndHeight:province_city fontSize:10].width;
        cityLab = [[UILabel alloc] initWithFrame:CGRectMake(marryStatusLabel.left, starLab.bottom+5, contentW, marryStatusLabel.height/2)];
        [cityLab setFont:[UIFont systemFontOfSize:10]];
        [cityLab setTextColor:kTextColorBlack];
        [cityLab setText:province_city];
        [sectionOne addSubview:cityLab];
        
    }
    
    if ([marriageStatus isEqualToString:@"单身"]) {
        
        //自已看自已右上角的求托单
        UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [navRightBtn setFrame:CGRectMake(0, 0, 65, 44)];
        [navRightBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [navRightBtn setTitleColor:[JYHelpers setFontColorWithString:@"#2695ff"] forState:UIControlStateNormal];
        [navRightBtn setTitle:@"求脱单" forState:UIControlStateNormal];
        [navRightBtn addTarget:self action:@selector(helpFallInLove) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *navBarButton = [[UIBarButtonItem alloc] initWithCustomView:navRightBtn];
        [self.navigationItem setRightBarButtonItem:navBarButton];
        
        [sectionOne setHeight:sectionOne.height+30];
        
        //当是自已看自已时，显示邀请好友验证，按钮
        UIButton *inviteFriendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [inviteFriendBtn setFrame:CGRectMake(0, sectionOne.height - 30, sectionOne.width, 30)];
        [inviteFriendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        inviteFriendBtn.userInteractionEnabled = YES;
        inviteFriendBtn.backgroundColor = [UIColor clearColor];
        inviteFriendBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        
//        [inviteFriendBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
        [inviteFriendBtn setTitle:[NSString stringWithFormat:@"已有%@人确认我是单身 邀请好友帮我认证",userProfileModel.lonely_confirm] forState:UIControlStateNormal];
//        [inviteFriendBtn setBackgroundImage:[UIImage imageNamed:@"profile_invite_bg"]  forState:UIControlStateNormal];
        [inviteFriendBtn setBackgroundColor:kTextColorBlue];
        inviteFriendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [inviteFriendBtn addTarget:self action:@selector(_inviteFriendClick) forControlEvents:UIControlEventTouchUpInside];
        [sectionOne addSubview:inviteFriendBtn];
    }
    //如果生日为空 城市信息顶上去。
    if ([JYHelpers isEmptyOfString:starLab.text]) {
        [cityLab setFrame:starLab.frame];
    }
    /*****************第一部份ui结束******************/
    
    /*****************第五部份(个性签名)ui开始******************/
    //取当前控件的要显示字符高宽
    NSString *myStr = userProfileModel.intro;
    
    CGSize mSignSize = [JYHelpers getTextWidthAndHeight:myStr fontSize:15 uiWidth:kScreenWidth - 130];
    //    NSLog(@"myStr -> %@  %lf",myStr,mSignSize.height);
    CGFloat textHeight = mSignSize.height+2;
    
    if (textHeight < 20) {//默认高度
        textHeight = 20;
    }
    //    mSignSize.height+10
    UIView *sectionFive = [[UIView alloc] initWithFrame:CGRectMake(sectionOne.left, sectionOne.bottom+kSectionDistance, kSectionWidth, textHeight + 20)];
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
    signContentTextView = [[UITextView alloc] initWithFrame:CGRectMake(90-5,  signLabel.top - 7, kScreenWidth - 130, textHeight + 10)]; //初始化大小并自动释放
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
    
    
    //只有自已才能出现更多，可编辑
    [signContentTextView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signMoreBtnClick)]];
    UIButton *signMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [signMoreBtn setUserInteractionEnabled:YES];
    //    [signMoreBtn setBackgroundColor:[UIColor orangeColor]];
    [signMoreBtn setFrame:CGRectMake(sectionOne.right-20-10, signLabel.top+3-10, 8+20, 13+20)];
    [signMoreBtn setImage:[UIImage imageNamed:@"more_gray"] forState:UIControlStateNormal];
    [signMoreBtn setImage:[UIImage imageNamed:@"more_blue"] forState:UIControlStateHighlighted];
    [signMoreBtn addTarget:self action:@selector(signMoreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [sectionFive addSubview:signMoreBtn];
    
    /*****************第五部份(个性签名)ui结束******************/
    
    /*****************第三部份(相册)ui开始******************/
    NSInteger sectionThreeBottomPosition = 0;
    sectionThreeBottomPosition = sectionFive.bottom+kSectionDistance;
    sectionThree = [[UIView alloc] initWithFrame:CGRectMake(sectionOne.left, sectionThreeBottomPosition, kSectionWidth, 80)];
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
    
    NSInteger dPhotoCount = (kScreenWidth - 10 - 55 - 25)/50;
//    NSDictionary  *photoes = userProfileModel.photoes;
    NSUInteger mPhotoCount = _photoesArr.count;
    NSLog(@"dpcount == %ld photoCount == %ld",(long)dPhotoCount,(long)mPhotoCount)
    //图片数量超过当前设备能容纳的图片
    if (mPhotoCount>dPhotoCount) {
        mPhotoCount = dPhotoCount;
    }
    //如果没有上传图片
    if (mPhotoCount == 0) {
        mPhotoCount = 1;
    }else if(mPhotoCount+1<=dPhotoCount) {//如果当前图片没有再加一张也没有超过设备能容纳的图片数量
        mPhotoCount++;
    }
    UIView *albumBgView = [[UIView alloc] initWithFrame:CGRectMake(albumLabel.right, albumLabel.top,kSectionWidth - albumLabel.right, 50)];
    [albumBgView setTag:123];
    [albumBgView setBackgroundColor:[UIColor clearColor]];
    [sectionThree addSubview:albumBgView];
    
    NSLog(@"phontocount == %ld",(long)mPhotoCount);
    if (mPhotoCount>0 && mPhotoCount<=dPhotoCount) {//最多显示4个
//        NSArray *photoesValue;
//        if ([photoes isKindOfClass:[NSDictionary class]]) {
//            photoesValue = [photoes allValues];
//        }
        for (int i = 0;i<mPhotoCount;i++) {
            if (i == mPhotoCount - 1 ) { //第四个时，显示+号，为上传图片
                UIImageView *albumImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50*i+5*(i+1), 0, 50, 50)];
                albumImageView.tag = 6000+i;
                albumImageView.userInteractionEnabled = YES;
                albumImageView.backgroundColor = [UIColor clearColor];
                albumImageView.image = [UIImage imageNamed:@"profile_upload_img"];
                [albumBgView addSubview:albumImageView];
                UITapGestureRecognizer *photoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadPhotoClick)];
                [albumImageView addGestureRecognizer:photoTap];
                
            }else{
                
                UIImageView *albumImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50*i+5*(i+1), 0, 50, 50)];
                
                [albumImageView setContentMode:UIViewContentModeScaleAspectFill];
                [albumImageView setClipsToBounds:YES];
                
                albumImageView.tag = 6000+i;
                albumImageView.userInteractionEnabled = YES;
                albumImageView.backgroundColor = [UIColor clearColor];
                albumImageView.tag = 3000+i;
                //albumImageView.image = [UIImage imageNamed:@"pic_morentouxiang_man"];
                [albumBgView addSubview:albumImageView];
                [albumImageView setImageWithURL:[NSURL URLWithString:[[_photoesArr objectAtIndex:i] objectForKey:@"100"]]];
                UITapGestureRecognizer *photoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(browserThisPhotoClick:)];
                [albumImageView addGestureRecognizer:photoTap];
            }
        }
        
    }
    
    
    //更多
    UIButton *albumMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [albumMoreBtn setUserInteractionEnabled:YES];
//    [albumMoreBtn setBackgroundColor:[UIColor orangeColor]];
    [albumMoreBtn setFrame:CGRectMake(sectionThree.right-20-10, (sectionThree.height-13)/2 - 10, 8+20, 13+20)];
    //    [albumMoreBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    //    [albumMoreBtn setBackgroundColor:[UIColor orangeColor]];
    [albumMoreBtn setImage:[UIImage imageNamed:@"more_gray"] forState:UIControlStateNormal];
    [albumMoreBtn setImage:[UIImage imageNamed:@"more_blue"] forState:UIControlStateHighlighted];
    [albumMoreBtn addTarget:self action:@selector(albumViewClick) forControlEvents:UIControlEventTouchUpInside];
    [sectionThree addSubview:albumMoreBtn];
    /*****************第三部份(相册)ui结束******************/
    
    
    /*****************第七部份(标签)ui开始******************/
    NSInteger sectionSevenBottomPosition = 0;
    sectionSevenBottomPosition = sectionThree.bottom+kSectionDistance;
    
    sectionSeven = [[UIView alloc] initWithFrame:CGRectMake(sectionFive.left, sectionSevenBottomPosition, kSectionWidth, 90)];
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
    
    UILabel *giveHimTagLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-120, tagLabel.top, 100, 20)];
    giveHimTagLabel.textAlignment = NSTextAlignmentRight;
    giveHimTagLabel.backgroundColor = [UIColor clearColor];
    giveHimTagLabel.textColor = [JYHelpers setFontColorWithString:@"#2695ff"];
    giveHimTagLabel.font = [UIFont systemFontOfSize:15];
    giveHimTagLabel.userInteractionEnabled = YES;
    giveHimTagLabel.text = @"编辑标签";
    [giveHimTagLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(giveHimTagLabelGesture)]];
    [sectionSeven addSubview:giveHimTagLabel];
    
    tagStartPostion = CGPointMake(tagLabel.left, tagLabel.bottom);
    
    tagListView = [[JYProfileTagListView alloc] initUiView:_show_uid width:kScreenWidth-30 startPosition:tagStartPostion tagList:tagListDic isAllowDelTag:NO isAllowClickTag:YES isContactsTag:NO];
    [sectionSeven addSubview:tagListView];
    
    tagListOriginalHeight =tagListView.height;
    if (tagListView.height>80) { //当高度大于80，两排时，则收起
        tagListView.height = 80;
        tagListDefaultHeight = 80;
    }else{
        tagListDefaultHeight = tagListOriginalHeight;
        [tagMoreClick setHidden:YES];
    }
    sectionSeven.height = tagListView.height+48;
    
    tagMoreClick = [[UIImageView alloc] initWithFrame:CGRectMake(sectionSeven.right-35, tagListView.bottom+5, 18, 8)];
    tagMoreClick.userInteractionEnabled = YES;
    tagMoreClick.backgroundColor = [UIColor clearColor];
    tagMoreClick.image = [UIImage imageNamed:@"profile_tag_more"];
    [sectionSeven addSubview:tagMoreClick];
    [tagMoreClick addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagMoreClickGesture)]];
    
    if (tagListOriginalHeight <= 80) {
        [tagMoreClick setHidden:YES];
    }
    /*****************第七部份(标签)ui结束******************/
    
    /*****************第四部份(动态)ui开始******************/
    sectionFour = [[UIView alloc] initWithFrame:CGRectMake(sectionSeven.left, sectionSeven.bottom+kSectionDistance, kSectionWidth, 40)];
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
    newDynamicContent = [[UILabel alloc] initWithFrame:CGRectMake(90,  dynamicLabel.top, myWidth, 20)];
    newDynamicContent.textAlignment = NSTextAlignmentLeft;
    newDynamicContent.backgroundColor = [UIColor clearColor];
    newDynamicContent.textColor = [JYHelpers setFontColorWithString:@"#303030"];
    newDynamicContent.font = [UIFont systemFontOfSize:15];
    //    newDynamicContent.text = @"最新发布的一条动态";
    [newDynamicContent setUserInteractionEnabled:YES];
    [newDynamicContent addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newDynamicAction)]];
    [sectionFour addSubview:newDynamicContent];
    
    //更多
    
    UIButton *dynamicMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dynamicMoreBtn setUserInteractionEnabled:YES];
    [dynamicMoreBtn setFrame:CGRectMake(sectionFour.right-20-5, newDynamicContent.top+3-5, 8+10, 13+10)];
    [dynamicMoreBtn setImage:[UIImage imageNamed:@"more_gray"] forState:UIControlStateNormal];
    [dynamicMoreBtn setImage:[UIImage imageNamed:@"more_blue"] forState:UIControlStateHighlighted];
    [dynamicMoreBtn addTarget:self action:@selector(newDynamicAction) forControlEvents:UIControlEventTouchUpInside];
    [sectionFour addSubview:dynamicMoreBtn];
    /*****************第四部份(动态)ui结束******************/

    /*****************第八部份(群组)ui开始******************/
    sectionEight = [[UIScrollView alloc] initWithFrame:CGRectMake(sectionSeven.left, sectionFour.bottom+kSectionDistance, kSectionWidth, 45)];
    [sectionEight setScrollEnabled:NO];
    sectionEight.backgroundColor = [UIColor whiteColor];
    sectionEight.layer.borderColor = [[JYHelpers setFontColorWithString:@"#cccccc"] CGColor];
    sectionEight.layer.borderWidth = 1;
    [myScrollView addSubview:sectionEight];
    [self updateGroupList];
    
    /*****************第八部份(群组)ui结束******************/
    
    sectionNine = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)];
    sectionNine.frame = CGRectMake(sectionEight.left, sectionEight.bottom+kSectionDistance, kSectionWidth, 50);
    sectionNine.backgroundColor = [UIColor whiteColor];
    sectionNine.layer.borderColor = [[JYHelpers setFontColorWithString:@"#cccccc"] CGColor];
    sectionNine.layer.borderWidth = 1;
    [myScrollView addSubview:sectionNine];
    
    UILabel *systemSetLabel = [[UILabel alloc] initWithFrame:CGRectMake((sectionNine.width-80)/2, 15, 80, 20)];
    systemSetLabel.textAlignment = NSTextAlignmentCenter;
    systemSetLabel.backgroundColor = [UIColor clearColor];
    systemSetLabel.textColor = [JYHelpers setFontColorWithString:@"#2695ff"];
    systemSetLabel.font = [UIFont systemFontOfSize:15];
    systemSetLabel.text = @"系统设置";
    systemSetLabel.userInteractionEnabled = YES;
    [sectionNine addSubview:systemSetLabel];
    [sectionNine addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(systemSetGesture)]];
    
    
    //加载完成后，重新计算scroll的总高度
    myScrollView.contentSize = CGSizeMake( kScreenWidth, sectionNine.bottom+20);
    // frame中的size指UIScrollView的可视范围
}

//上传照片选择初始化
- (void)_initActionSheetView
{
    uploadPhotosheet = [[UIActionSheet alloc] initWithTitle:@"上传照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    [uploadPhotosheet showInView:self.view];
}

//获取群组信息以后刷新UI
- (void)updateGroupList{
    
    [sectionEight.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //群组
    UILabel *groupLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 20)];
    groupLabel.textAlignment = NSTextAlignmentLeft;
    groupLabel.backgroundColor = [UIColor clearColor];
    groupLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
    groupLabel.font = [UIFont systemFontOfSize:15];
    groupLabel.text = @"群组";
    [sectionEight addSubview:groupLabel];
    
    CGFloat editGroupBtnWidth = [JYHelpers getTextWidthAndHeight:@"编辑群组" fontSize:15].width;
    
    editGroupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editGroupBtn setTitle:@"编辑群组" forState:UIControlStateNormal];
    [editGroupBtn setTitleColor:kTextColorBlue forState:UIControlStateNormal];
    [editGroupBtn setFrame:CGRectMake(kScreenWidth-10-8-editGroupBtnWidth, groupLabel.top, editGroupBtnWidth, 20)];
    [editGroupBtn addTarget:self action:@selector(editGroupAction) forControlEvents:UIControlEventTouchUpInside];
    [editGroupBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [editGroupBtn setHidden:YES];
    [sectionEight addSubview:editGroupBtn];
    
    UILabel  *groupLabelLine = [[UILabel alloc] initWithFrame:CGRectMake(0 ,  groupLabel.bottom+15, sectionEight.width, 1)];
    groupLabelLine.layer.borderWidth = 1;
    groupLabelLine.layer.borderColor = [[JYHelpers setFontColorWithString:@"#edf1f4"] CGColor];
    [sectionEight addSubview:groupLabelLine];
    
    JYGroupView *view = (JYGroupView*)[sectionEight viewWithTag:123];
    [view removeFromSuperview];
    
    if (groupListArr.count == 0) {
        
        [editGroupBtn setHidden:YES];
        
    }else{
        [editGroupBtn setHidden:NO];
    }

//    id target = nil;
//    SEL sel = nil;
//    NSMutableArray *resultArr =
    CGFloat lastBottom = 50;
    for (int i = 0; i < groupListArr.count; i++) {
        JYGroupModel *group = (JYGroupModel*)[groupListArr objectAtIndex:i];
        //是否显示
        if ([group.show isEqualToString:@"0"]) {
        
            JYGroupView *view = [JYGroupView groupViewWithModel:group andFrame:CGRectMake(0, lastBottom, kScreenWidth, 44) target:nil action:nil realData:YES];
            [view setTag:123+i];
            lastBottom += 44;
            [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGroupViewAction:)]];
            [sectionEight addSubview:view];
        }
    }
    
    if (lastBottom == 50) {//没有群组
        JYGroupModel *group = [[JYGroupModel alloc] init];
        group.title = @"暂无群组信息";
        group.total = 0;
        group.join = @"1";//虚拟加入
        group.show = @"0";//显示
        JYGroupView *view = [JYGroupView groupViewWithModel:group andFrame:CGRectMake(0, lastBottom, sectionEight.width, 44) target:nil action:nil realData:NO];
        [view setTag:123];
        lastBottom += 44;
        [sectionEight addSubview:view];
    }
    //群组超过5个
    if (lastBottom > 50+44*5) {
        [sectionEight setFrame:CGRectMake(sectionSeven.left, sectionFour.bottom + kSectionDistance, kSectionWidth, 50+44*5+20)];
        
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
        [sectionEight setFrame:CGRectMake(sectionSeven.left, sectionFour.bottom + kSectionDistance, kSectionWidth, lastBottom)];
        [sectionEight setContentSize:CGSizeMake(sectionEight.width, lastBottom-50)];
    }

    [sectionNine setFrame:CGRectMake(sectionEight.left, sectionEight.bottom + kSectionDistance, kSectionWidth, 50)];

    myScrollView.contentSize = CGSizeMake( kScreenWidth, sectionNine.bottom+20);
    
}

//重新调整ui的高度，由于标签的移动，导致7，8，9段的位置变化
-(void)_adjustTagListUiHeight{
    if (tagExtend) {
        tagListView.height = tagListOriginalHeight;
        
    }else{
        tagListView.height = tagListDefaultHeight;
    }
    sectionSeven.height = tagListView.height+48;
    
    sectionFour.origin = CGPointMake(sectionSeven.left, sectionSeven.bottom+kSectionDistance);
    tagMoreClick.origin = CGPointMake(tagMoreClick.left, tagListView.bottom+5);
    sectionEight.origin = CGPointMake(sectionSeven.left, sectionFour.bottom+kSectionDistance);
    sectionNine.origin  = CGPointMake(sectionEight.left, sectionEight.bottom+kSectionDistance);
    //加载完成后，重新计算scroll的总高度
    myScrollView.contentSize = CGSizeMake( kScreenWidth, sectionNine.bottom+20);
    
}
#pragma mark - Request

//- (void)_getProfileInfo{
//    
////    profileDataDic = [JYShareData sharedInstance].myself_profile_dict;
//    userProfileModel = [JYShareData sharedInstance].myself_profile_model;
//    
//}

//获取用户标签列表
- (void)_userTagList
{
    tagListDic = [[JYProfileData sharedInstance] getProfileTagList:_show_uid];
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
//    lastGroupCount = groupListArr.count;
    [groupListArr removeAllObjects];
//    [sourceGroupArr removeAllObjects];
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
//                        [sourceGroupArr addObject:group];
//                        if ([group.show isEqualToString:@"0"]) {
                        [groupListArr addObject:group];
//                        }
                    }
                }
                [self updateGroupList];
            }
            
        } else {
            NSLog(@"获取群组信息失败");
        }
        
    } failure:^(id error) {
        
        NSLog(@"%@", error);
        [self dismissProgressHUDtoView:self.view];
//        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];
    
}

//获取最新动态
- (void)loadLastDynamic{

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
//                    500-转播文字,501-转播图片
//                    if (<#condition#>) {
//                        <#statements#>
//                    }
                    NSString *text = [[[dataArr objectAtIndex:0] objectForKey:@"data"] objectForKey:@"content"];
                    NSInteger type = [[[dataArr objectAtIndex:0] objectForKey:@"type"] integerValue];
                    if (type == 500 || type == 501) {
                        text = [NSString stringWithFormat:@"转播动态:%@",text];
                    }
//                    if (text.length > 8) {
//                        text = [text substringToIndex:8];
//                    }
                    [newDynamicContent setText:text];
                }else{
                    [newDynamicContent setText:@"暂无动态"];
                    [newDynamicContent setTextColor:kTextColorLightGray];
                }
            }
        }
    } failure:^(id error) {
        [self dismissProgressHUDtoView:self.view];
//        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];
}

// 上传生活照片
- (void)_requestUploadImages
{
    
    
    [self showProgressHUD:@"图片上传中..." toView:self.view];
    
    
    UIImage *image = nil;
    if (_uploadedPhotoCompleteCount<_tempImagesArrs.count) {
        image = ((JYLocalImageModel *)[_tempImagesArrs objectAtIndex:(_uploadedPhotoCompleteCount)]).fullScreenImage;
        
    } else {
//        _uploadedPhotoCompleteCount = 0;
//        [_tempImagesArrs removeAllObjects];
        [self _initScrollViews];
        [self dismissProgressHUDtoView:self.view];
        return;
    }
    

    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"photo" forKey:@"mod"];
    [parametersDict setObject:@"upload_photo" forKey:@"func"];

    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:_show_uid forKey:@"uid"];

    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    if (imageData.length>2249) {
        //imageData = UIImageJPEGRepresentation(image, 0.9);
    }
    
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:imageData forKey:@"upload"];
    __weak typeof(self) vc = self;
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict dataDict:dataDict formDict:nil success:^(id responseObject) {
        __strong typeof(vc) controller = vc;
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        [self dismissProgressHUDtoView:self.view];
        if (iRetcode == 1 && [[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
            _uploadedPhotoCompleteCount++;
            NSLog(@"上传成功");
            NSDictionary *dataDic = [responseObject objectForKey:@"data"];
            if ([dataDic isKindOfClass:[NSDictionary class]]) {
//                NSDictionary *photoes = userProfileModel.photoes;
                NSMutableDictionary *uploadImageInfo = [NSMutableDictionary dictionary];
                [uploadImageInfo setObject:[dataDic objectForKey:@"pic100"] forKey:@"100"];
                [uploadImageInfo setObject:[dataDic objectForKey:@"pic300"] forKey:@"300"];
                [uploadImageInfo setObject:[dataDic objectForKey:@"pic800"] forKey:@"800"];
                [uploadImageInfo setObject:[dataDic objectForKey:@"pic1600"] forKey:@"1600"];

                NSMutableDictionary *newPhotoes = [NSMutableDictionary dictionaryWithObject:uploadImageInfo forKey:ToString([dataDic objectForKey:@"pid"])];
                for (NSDictionary *dict in _photoesArr) {
                    NSMutableDictionary *fourValueDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                    [fourValueDict removeObjectForKey:@"pid"];
                    [newPhotoes setObject:fourValueDict forKey:[dict objectForKey:@"pid"]];
                    if (newPhotoes.count == 3) {
                        break;
                    }
                }
                [userProfileModel setPhotoes:newPhotoes];
                [self setPhotoesArr:nil];
            }
            [controller _requestUploadImages];

        } else if (iRetcode == -3){
            [[JYAppDelegate sharedAppDelegate] showTip:@"图片大小不正确（大小应为2KB-5MB）"];
            
        }
        else if (iRetcode == -4){
            [[JYAppDelegate sharedAppDelegate] showTip:@"图片格式不正确（支持jpg/jpeg/png/gif）"];
            
        }
        else if (iRetcode == -5){
            [[JYAppDelegate sharedAppDelegate] showTip:@"图片尺寸不正确（尺寸应为100-5000px）"];
            
        }
        else if (iRetcode == -6){
            [[JYAppDelegate sharedAppDelegate] showTip:@"图片尺寸不正确（尺寸应为100-5000px）"];
            
        }
        else {
            [[JYAppDelegate sharedAppDelegate] showTip:@"上传失败"];
            
        }
        
        
        
    } failure:^(id error) {
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        
        NSLog(@"%@", error);
        [self dismissProgressHUDtoView:self.view];
    }];

//    UIImage *image = nil;
//
//    image = ((JYLocalImageModel *)[_tempImagesArrs objectAtIndex:(_uploadedPhotoCompleteCount)]).fullScreenImage;
//    
//    //    NSLog(@"fuck you!!!");
//    [self showProgressHUD:@"图片上传中..." toView:self.view];
//    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
//    [parametersDict setObject:@"photo" forKey:@"mod"];
//    [parametersDict setObject:@"upload_photo" forKey:@"func"];
//    
//    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
//    [postDict setObject:_show_uid forKey:@"uid"];
//    
//    NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
//    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
//    [dataDict setObject:imageData forKey:@"upload"];
//    
//    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict dataDict:dataDict formDict:nil success:^(id responseObject) {
//        
//        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
//        [self dismissProgressHUDtoView:self.view];
//        if (iRetcode == 1) {
//            NSLog(@"上传成功");
//            [[JYAppDelegate sharedAppDelegate] showTip:@"上传成功"];
//            //刷新UI
//            NSDictionary *dataDic = [responseObject objectForKey:@"data"];
//            if ([dataDic isKindOfClass:[NSDictionary class]]) {
////                NSDictionary *photoes = userProfileModel.photoes;
//                NSMutableDictionary *uploadImageInfo = [NSMutableDictionary dictionary];
//                [uploadImageInfo setObject:[dataDic objectForKey:@"pic100"] forKey:@"100"];
//                [uploadImageInfo setObject:[dataDic objectForKey:@"pic300"] forKey:@"300"];
//                [uploadImageInfo setObject:[dataDic objectForKey:@"pic800"] forKey:@"800"];
//                [uploadImageInfo setObject:[dataDic objectForKey:@"pic1600"] forKey:@"1600"];
//                
//                NSMutableDictionary *newPhotoes = [NSMutableDictionary dictionaryWithObject:uploadImageInfo forKey:ToString([dataDic objectForKey:@"pid"])];
//                for (NSDictionary *dict in _photoesArr) {
//                    NSMutableDictionary *fourValueDict = [NSMutableDictionary dictionaryWithDictionary:dict];
//                    [fourValueDict removeObjectForKey:@"pid"];
//                    [newPhotoes setObject:fourValueDict forKey:[dict objectForKey:@"pid"]];
//                    if (newPhotoes.count == 3) {
//                        break;
//                    }
//                }
//                [userProfileModel setPhotoes:newPhotoes];
//                [self setPhotoesArr:nil];
//                [self _initScrollViews];
//            }
//           
//        } else {
//
//        }
//        
//    } failure:^(id error) {
//        [self dismissProgressHUDtoView:self.view];
//        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
//        NSLog(@"%@", error);
//        
//    }];
}


- (void)gotoEditController:(UIGestureRecognizer *)gesture{
    JYProfileEditController * _editVC = [[JYProfileEditController alloc] init];
    [self.navigationController pushViewController:_editVC animated:YES];
}

#pragma mark - gesture Action
//- (void)tapHeadViewGesture:(UIGestureRecognizer *)gesture
//{
//    NSLog(@" gesture");
//    // 上传头像
//    // 初始化actionsheet
//    [self _initActionSheetView];
//    
//}
//用户动态
- (void)newDynamicAction{
    NSLog(@"进入动态")
    JYDynamicController *dynamicVC = [[JYDynamicController alloc] init];
    [dynamicVC setUid:_show_uid];
    [dynamicVC setTitle:[NSString stringWithFormat:@"%@的动态",self.title]];
    //    dynamicVC setTotalNum:<#(NSInteger)#>
    [self.navigationController pushViewController:dynamicVC animated:YES];
}

- (void)signMoreBtnClick{
    JYProfileEditIntroController * _editVC = [[JYProfileEditIntroController alloc] init];
    [_editVC setDelegate:self];
    [self.navigationController pushViewController:_editVC animated:YES];
}


//编辑群组
- (void)editGroupAction{
    JYProfileEditGroupController *editGroupController = [[JYProfileEditGroupController alloc] init];
    [editGroupController setGroupList:groupListArr];
    [self.navigationController pushViewController:editGroupController animated:YES];
}


//点击照片更多
- (void)albumViewClick
{
    JYAlbumController * _albumVC = [[JYAlbumController alloc] init];
    _albumVC.show_uid = _show_uid;
    //            [_seenVC setHidesBottomBarWhenPushed: YES];
    [self.navigationController pushViewController:_albumVC animated:YES];
}

- (void)uploadPhotoClick{
    [self _initActionSheetView ];
    _uploadedPhotoCompleteCount = 0;
    _tempImagesArrs = nil;
    _tempImagesArrs = [NSMutableArray array];
}

//跳到编辑标签
- (void)giveHimTagLabelGesture{
    JYProfileEditTagsController * _albumVC = [[JYProfileEditTagsController alloc] init];
    _albumVC.show_uid = _show_uid;
    _albumVC.tagDic = tagListDic;
    [self.navigationController pushViewController:_albumVC animated:YES];
}

//跳到系统设置
- (void)systemSetGesture{
    JYProfileSystemSetController *sysVC = [[JYProfileSystemSetController alloc] init];
    [self.navigationController pushViewController:sysVC animated:YES];
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
    
    sectionNine.origin  = CGPointMake(sectionEight.left, sectionEight.bottom+kSectionDistance);
    //加载完成后，重新计算scroll的总高度
    myScrollView.contentSize = CGSizeMake( kScreenWidth, sectionNine.bottom+20);
    
}
//邀请好友验证单身
- (void) _inviteFriendClick{
//    isInviteFriend = YES;
    [shareView setShareContent:[NSString stringWithFormat:@"帮助确认我的单身状态，助我早日脱单 我的资料:http://m.iyouxun.com/wechat/share_profile/?uid=%@",self.show_uid]];
    if ([[userProfileModel.avatars objectForKey:@"pid"] intValue]!=0) {//有头像
        [shareView setShareImage:avatarImg.image];
        [shareView setShareImageUrl:[userProfileModel.avatars objectForKey:@"200"]];
    }else{
        [shareView setShareImageUrl:nil];
        [shareView setShareImage:nil];
    }
    [shareView setPid:[userProfileModel.avatars objectForKey:@"pid"]];
    [shareView setShareUrl:[NSString stringWithFormat:@"http://m.iyouxun.com/wechat/share_profile/?uid=%@",self.show_uid]];
//    [shareView setProfileDataDic:nil];
    [shareView setShareTitle:@"帮我认证一下单身吧-友寻"];
    [shareView positionAnimationIn];
}
//求脱单时，弹出来的分享层
- (void)helpFallInLove{
    NSString *genderStr = @"她们";
    if ([userProfileModel.sex isEqualToString:@"0"]) {
        genderStr = @"他们";
    }
    
    [shareView setShareContent:[NSString stringWithFormat:@"给我介绍几个合适的对象吧,帮我把资料分享给%@哦！我的资料：http://m.iyouxun.com/wechat/share_profile/?uid=%@",genderStr,_show_uid]];
    
    if ([[userProfileModel.avatars objectForKey:@"pid"] intValue]!=0) {//有头像
        [shareView setShareImageUrl:[userProfileModel.avatars objectForKey:@"200"]];
        [shareView setPid:[userProfileModel.avatars objectForKey:@"pid"]];
        [shareView setShareImage:avatarImg.image];
    }else{
        [shareView setShareImage:nil];
        [shareView setShareImageUrl:nil];
    }
    
    [shareView setShareTitle:[NSString stringWithFormat:@"求脱单-%@的资料-友寻",userProfileModel.nick]];
    [shareView setShareUrl:[NSString stringWithFormat:@"http://m.iyouxun.com/wechat/share_profile/?uid=%@",_show_uid]];
//    [shareView setProfileDataDic:nil];
    [shareView positionAnimationIn];
}
// 获取上传的照片
- (void)_getLocalImages
{
    JYGroupImagesController *controller = [[JYGroupImagesController alloc]init];
    controller.canUploadCount = 9;
//    controller.imagesUrlArr = imageArray;

    JYNavigationController *naviController = [[JYNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:naviController animated:YES completion:NULL];


}

// 旋转图片在上传
- (UIImage *)fixOrientation:(UIImage * )imag
{
    // No-op if the orientation is already correct
    if (imag.imageOrientation == UIImageOrientationUp) return imag;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (imag.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, imag.size.width, imag.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, imag.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, imag.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:break;
    }
    
    switch (imag.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, imag.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, imag.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, imag.size.width, imag.size.height,
                                             CGImageGetBitsPerComponent(imag.CGImage), 0,
                                             CGImageGetColorSpace(imag.CGImage),
                                             CGImageGetBitmapInfo(imag.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (imag.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,imag.size.height,imag.size.width), imag.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,imag.size.width,imag.size.height), imag.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
    
}

- (void)tapAvatarView:(UITapGestureRecognizer*)tap{
    if (![userProfileModel.hasavatar boolValue]) {
        return;
    }
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = avatarBGImg;// [self viewWithTag:gesture.view.tag]; // 原图的父控件
    browser.imageCount = 1; // 图片总数
    browser.currentImageIndex = 0;
    [browser setFromSelf:YES];
    [browser setIsMyAvatar:YES];
    [browser setTag:kAvatarBrowserTag];
    [browser setShareContent:[NSString stringWithFormat:@"来自%@的友寻相册",userProfileModel.nick]];
    browser.delegate = self;
    [browser show];
}
//点击群组
- (void)tapGroupViewAction:(UITapGestureRecognizer*)aGesture{
    JYGroupModel *model = (JYGroupModel*)[groupListArr objectAtIndex:aGesture.view.tag - 123];
    
    JYChatController *chatController = [[JYChatController alloc] init];
    JYMyGroupModel *groupModel = [[JYMyGroupModel alloc] init];
    
    groupModel.friend_num = @"0";
    groupModel.group_id = model.group_id;
    groupModel.hint = @"0";
    groupModel.intro = @"";
    groupModel.logo = model.logo;
    groupModel.show = @"0";
    groupModel.title = model.title;
    groupModel.total = @"0";
    [chatController setIsGroupChat:YES];
    [chatController setFromGroupModel:groupModel];
    
    [self.navigationController pushViewController:chatController animated:YES];
}

- (void) browserThisPhotoClick:(UITapGestureRecognizer *)gesture{
    
    NSInteger dPhotoCount = (kScreenWidth - 10 - 55 - 25)/50;
    NSDictionary  *photoes = userProfileModel.photoes;
    NSUInteger mPhotoCount = photoes.count;
    //    NSLog(@"dpcount == %ld photoCount == %ld",(long)dPhotoCount,(long)mPhotoCount)
    //图片数量超过当前设备能容纳的图片
    if (mPhotoCount>=dPhotoCount) {
        mPhotoCount = dPhotoCount-1;
    }
    //如果没有上传图片
    //    if (mPhotoCount == 0) {
    //        mPhotoCount = 1;
    //    }else if(mPhotoCount+1<dPhotoCount) {//如果当前图片没有再加一张也没有超过设备能容纳的图片数量
    //        mPhotoCount++;
    //    }
    //    NSInteger photoCount = photoes.count;
    //    if (photoes.count>=4) { //不是自已看自已显示4张
    //        photoCount = 4;
    //    }
    
    NSInteger imgIndex = gesture.view.tag -3000;
    
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    //下边两属性是 点赞的
    if (imagePraseData.count>0) {
        browser.imagePraiseData = imagePraseData;
        browser.fuid = _show_uid;
        browser.mRootCtrl = self;
    }
    
    browser.sourceImagesContainerView = [sectionThree viewWithTag:123];// [self viewWithTag:gesture.view.tag]; // 原图的父控件
    browser.imageCount = mPhotoCount; // 图片总数
    browser.currentImageIndex = (int)imgIndex;
    [browser setFromSelf:YES];
    [browser setTag:kAlbumBrowserTag];
    [browser setShareContent:[NSString stringWithFormat:@"来自%@的友寻相册",userProfileModel.nick]];
    
    browser.delegate = self;
    [browser show];
    
}
#pragma mark - Notification

////通知，重新刷新ui，弃用
//- (void)refreshProfileInfoNotification:(NSNotification*)note
//{
//    [self _getProfileInfo];
//}
//
//通知-编辑标签
- (void)profileEditTagNotification:(NSNotification*)note
{
    tagListDic = (NSMutableDictionary *)note.userInfo;
    //    tagListView.tagDic = (NSMutableDictionary *)tagListDic;
    //    [tagListView resetAllTagList];
    //    tagExtend = YES;
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
    //    tagListOriginalHeight = tagListView.height;
    [self _adjustTagListUiHeight];
}

//通知删除标签
- (void)profileDelTagNotification:(NSNotification*)note
{
    tagListDic = (NSMutableDictionary *)note.userInfo;
    tagListView.tagDic = (NSMutableDictionary *)tagListDic;
    [tagListView resetAllTagList];
    tagListOriginalHeight =tagListView.height;
    if (tagListView.height>80) { //当高度大于80，两排时，则收起
        tagListView.height = 80;
        tagListDefaultHeight = 80;
    }else{
        tagListDefaultHeight = tagListOriginalHeight;
        [tagMoreClick setHidden:YES];
    }
    sectionSeven.height = tagListView.height+48;
    [self _adjustTagListUiHeight];
    
}

//通知-点击标签
- (void)profileClickTagNotification:(NSNotification*)note
{
    tagListDic = (NSMutableDictionary *)note.userInfo;
    
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

    [self _adjustTagListUiHeight];
    //[self _getProfileInfo];
}

////下级界面编辑分组
//- (void)groupChangedNotification:(NSNotification*)noti{
//    NSLog(@"编辑分组");
//    JYGroupModel *model = noti.object;
//    [self requestChangeGroupInfoWithDataModel:model];
//}
- (void)profileDataDidChanged{
    
    [[JYProfileData sharedInstance] loadMyProfileDataWithSuccessBlcok:^(id responseObject) {
        [self reloadData];
    } failureBlock:^(id error) {
        
    }];
    
}

- (void)didSelectImagesToUpload:(NSNotification*)aNotification{
    
    if (self.tabBarController.selectedIndex != 3) {
        NSLog(@"不是资料页的上传操作");
        return;
    }
    for (JYLocalImageModel *localImageModel in [aNotification.userInfo objectForKey:@"images"])
    {
        BOOL isExist = NO; //照片是否存在于将要上传的照片中
        for (JYLocalImageModel *model in _tempImagesArrs) {
            if ([localImageModel.imageUrl isEqualToString:model.imageUrl]) {
                isExist = YES;
                break;
            }
        }
        
        if (isExist) {
            //不能上传相同的照片;
            [[JYAppDelegate sharedAppDelegate] showTip:@"不能上传重复的照片"];
        } else {
            if (_tempImagesArrs.count<=9) {
                [_tempImagesArrs addObject:localImageModel];
            } else {
                [[JYAppDelegate sharedAppDelegate] showTip:@"最多上传9张照片"];
            }
        }
    }
    
    [self _requestUploadImages];

}
#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{

    
    if(actionSheet == uploadPhotosheet){ //上传照片
        switch (buttonIndex) {
            case 0:
            {
                if (![JYHelpers canUseCamera]) {
                    [JYHelpers showCameraAuthDeniedAlertView];
                    return;
                }
                NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] &&[mediatypes count]>0){
                      UIImagePickerController *picker=[[UIImagePickerController alloc] init];
                      picker.mediaTypes=mediatypes;
                      picker.delegate=self;
                      picker.sourceType=UIImagePickerControllerSourceTypeCamera;
                      NSString *requiredmediatype=(NSString *)kUTTypeImage;
                      NSArray *arrmediatypes=[NSArray arrayWithObject:requiredmediatype];
                      [picker setMediaTypes:arrmediatypes];
                      [self presentViewController:picker animated:YES completion:nil];
              }
            }
                break;
            case 1:
            {
                // 从手机相册选择
                imageArray = [NSMutableArray array];

                [self _getLocalImages];
                
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - JYProfileIntroDidChangedDelegate
- (void)profileIntroDidChanged:(NSString *)newIntro{
//    [signContentTextView setText:newIntro];
    [[JYProfileData sharedInstance] loadMyProfileDataWithSuccessBlcok:^(id responseObject) {
        [self reloadData];
    } failureBlock:^(id error) {
        
    }];
//    [self reloadData];
}
#pragma mark - UIImagePickerController delegate
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 3.1
    UIImage *image= [info objectForKey:UIImagePickerControllerOriginalImage];
//    UIImage *originalImage= [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //[_tempImagesArrs removeAllObjects];
    
    UIImage *newImg = [self fixOrientation:image];
//    JYLocalImageModel *imageModel = [[JYLocalImageModel alloc] init];
    
    JYLocalImageModel *imodel = [[JYLocalImageModel alloc] init];
    imodel.thumbnailImage = image;
    imodel.fullScreenImage = newImg;
    imodel.imageUrl = @"1";

    [_tempImagesArrs addObject:imodel];
    
    // 上传生活照片请求
    [self _requestUploadImages];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - photobrowser代理方法

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    if (browser.tag == kAvatarBrowserTag) {
        return avatarImg.image;
    }else{
        return ((UIImageView *)[sectionThree viewWithTag:3000+index]).image;
    }
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
//    NSDictionary  *photoes = userProfileModel.photoes;
//    NSArray *photoesValue = [photoes allValues];
    if (browser.tag == kAvatarBrowserTag) {
        return [NSURL URLWithString:[userProfileModel.avatars objectForKey:@"600"]] ;
    }else{
        return [NSURL URLWithString:[[_photoesArr objectAtIndex:index] objectForKey:@"800"]]; // 图片路径
    }
}

//返回当前图片的pid
- (NSString *)photoBrowserId:(SDPhotoBrowser *)browser pidForIndex:(NSInteger)index{
    
//    NSDictionary  *photoes = userProfileModel.photoes;
//    NSArray *photoesKey = [photoes allKeys];
    if (browser.tag == kAvatarBrowserTag) {
        return [userProfileModel.avatars objectForKey:@"pid"];
    }else{
        return [[_photoesArr objectAtIndex:index] objectForKey:@"pid"];
    }
}
//删除了照片
- (void) photoBrowser:(SDPhotoBrowser *)browser didDeleteImage:(NSInteger)index{
    [browser setHidden:YES];
    [[JYProfileData sharedInstance] loadMyProfileDataWithSuccessBlcok:^(id responseObject) {
        [self reloadData];
    } failureBlock:^(id error) {
        
    }];
}

#pragma mark - Setter && Getter
- (void)setPhotoesArr:(NSMutableArray *)photoesArr{
    NSDictionary *dataDic = userProfileModel.photoes;
    if ([dataDic isKindOfClass:[NSDictionary class]]) {
        NSMutableArray *sortKeys = [NSMutableArray arrayWithArray:dataDic.allKeys];
        [sortKeys sortUsingComparator:^NSComparisonResult(NSString* obj1, NSString *obj2) {
            return [obj1 integerValue] < [obj2 integerValue];
        }];
        [_photoesArr removeAllObjects];
        _photoesArr = [NSMutableArray array];
        for (NSString *key in sortKeys) {
            NSLog(@"key == %@",key);
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[dataDic objectForKey:key]];
            [dic setObject:key forKey:@"pid"];
            if (_photoesArr.count <= 3) {
                [_photoesArr addObject:dic];
            }
        }
    }else{
        _photoesArr = [NSMutableArray array];
    }
   
}
- (void)writeAvatarToFile:(UIImage*)image{
    [avatarImg setImage:image];
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_avatar",ToString([SharedDefault objectForKey:@"uid"])]];
    NSLog(@"avatarPath = %@",path);
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:path atomically:YES];

}

@end
