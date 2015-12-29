//
//  JYProfileEditController.m
//  friendJY
//
//  Created by ouyang on 3/17/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//

#import "JYProfileEditController.h"
#import "JYShareData.h"
#import "UIImageView+WebCache.h"
#import "JYAppDelegate.h"
#import "AFNetworking.h"
#import "NSString+URLEncoding.h"
#import "JYHttpServeice.h"
#import "JYProfileEditDetailController.h"
#import "JYProfileData.h"

@interface JYProfileEditController ()<JYProfileDelegate,JYBaseTextFieldDelegate,UIScrollViewDelegate>
{
    UIImageView *avatarImg; // 头像
    
    NSMutableDictionary * profileDataDic;//个人信息
    NSDictionary *profileOptionDic;//选项信息

    JYBaseTextField *nickEditTextField;//昵称修改文本框
    JYBaseTextField *companyEditTextField;//公司修改文本框
    JYBaseTextField *frequentlyEditContent;//常住地修改文本框
   
    UIView *marrageStatuSection;
    UIView *sectionSix;
    
    UIImageView *marrageStatusMore;
    UILabel *marrageStatusContent;//情感状态
    UILabel *cityContentLabel; //省份城市标签
    
    UILabel *birthdayContentLabel;//生日
    UILabel *heightContentLabel;//体重
    UILabel *weightContentLabel;//身高
    UILabel *workContentLabel;//职业
    UILabel *companyLabel;//公司 或 学校
    
    UIScrollView * myScrollView;//背景视图
    NSString *schoollOrCompany;//存储学校或者公司状态 同时作为网络请求func的value
    
    CGFloat currentTxtFieldBottm;//存储当前响应文本框的底部
    
//    UITextField *currentTxtF;//存储当前编辑状态的textField
    CGFloat offSet;//键盘弹出之前 scrollView的Y偏移量
    UIImage *avtar;
    
    BOOL shouldHideKeyboard;
}

@end

@implementation JYProfileEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"个人资料"];
    shouldHideKeyboard = NO;
    profileDataDic = [NSMutableDictionary dictionaryWithDictionary:[JYShareData sharedInstance].myself_profile_dict];
    profileOptionDic = [JYShareData sharedInstance].profile_dict;
    NSLog(@"%@",profileDataDic);

    [self _initUiView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    键盘frame变化的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) _initUiView{
    
    UIButton *createGroupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [createGroupBtn setFrame:CGRectMake(0, 0, 65, 44)];
    [createGroupBtn setTitle:@"保存" forState:UIControlStateNormal];
    [createGroupBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [createGroupBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
    [createGroupBtn setTitleColor:kTextColorBlue forState:UIControlStateNormal];
    [createGroupBtn addTarget:self action:@selector(saveChanges) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:createGroupBtn]];
//    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveChanges)]];
    
    myScrollView = [[UIScrollView alloc] init];
    myScrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight); // frame中的size指UIScrollView的可视范围
    myScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    myScrollView.contentSize = CGSizeMake(kScreenWidth, 3000);
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.showsVerticalScrollIndicator = NO;
    myScrollView.backgroundColor = [UIColor clearColor];
    [myScrollView setDelegate:self];
    [self.view addSubview:myScrollView];
    
    [myScrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgClicked)]];
    
    /*************************头像UI Section 部分**************************/
    UIImageView *avatarBGImg = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-100)/2, 20, 100, 100)];
    avatarBGImg.layer.masksToBounds = YES;
    avatarBGImg.layer.cornerRadius = 50;
    avatarBGImg.userInteractionEnabled = YES;
    avatarBGImg.backgroundColor = [UIColor clearColor];
    NSString *sexStr = [[JYShareData sharedInstance].myself_profile_dict objectForKey:@"sex"];
    if ([sexStr integerValue]) {
        avatarBGImg.image = [UIImage imageNamed:@"pic_morentouxiang_man.png"]; //男的默认图标
    } else {
        avatarBGImg.image = [UIImage imageNamed:@"pic_morentouxiang_woman.png"]; //女的默认图标
    }
    [myScrollView addSubview:avatarBGImg];
    
    avatarImg = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 100, 100)];
    avatarImg.userInteractionEnabled = YES;

    avatarImg.backgroundColor = [UIColor clearColor];
    
    [avatarBGImg addSubview:avatarImg];
    
//    NSLog(@"%@",[profileDataDic objectForKey:@"avatars"]);
    [avatarImg sd_setImageWithURL:[NSURL URLWithString:[[profileDataDic objectForKey:@"avatars"] objectForKey:@"200"]]];
    [avatarImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeadViewGesture:)]];
    /*************************头像UI Section 部分  结束**************************/
    
    /*************************昵称UI Section 部分**************************/
    UILabel *nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,avatarBGImg.bottom+33,80,20)];
    nickLabel.lineBreakMode = NSLineBreakByWordWrapping;
    nickLabel.textAlignment = NSTextAlignmentLeft;
    nickLabel.backgroundColor = [UIColor clearColor];
    nickLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
    nickLabel.font = [UIFont systemFontOfSize:14];
    nickLabel.text = @"编辑昵称";
    [myScrollView addSubview:nickLabel];
    
//    //编辑昵称下划线
//    UILabel  *nickUnderLine = [[UILabel alloc] initWithFrame:CGRectMake(0 ,  nickLabel.bottom+9, kScreenWidth, 1)];
//    nickUnderLine.layer.borderWidth = 1;
//    nickUnderLine.layer.borderColor = [[JYHelpers setFontColorWithString:@"#edf1f4"] CGColor];
//    [self.view addSubview:nickUnderLine];
    
    UIView *nickEditSection = [[UIView alloc] initWithFrame:CGRectMake(-1, nickLabel.bottom+9, kScreenWidth+2, 50)];
    nickEditSection.backgroundColor = [UIColor whiteColor];
    nickEditSection.layer.borderColor = [[JYHelpers setFontColorWithString:@"#cccccc"] CGColor];
    nickEditSection.layer.borderWidth = 1;
    [myScrollView addSubview:nickEditSection];
    
    //编辑框内部的昵称头
    UILabel *nickLabel_1 = [[UILabel alloc] initWithFrame:CGRectMake(nickLabel.left,15,40,20)];
    nickLabel_1.lineBreakMode = NSLineBreakByWordWrapping;
    nickLabel_1.textAlignment = NSTextAlignmentLeft;
    nickLabel_1.backgroundColor = [UIColor clearColor];
    nickLabel_1.textColor = [JYHelpers setFontColorWithString:@"#848484"];
    nickLabel_1.font = [UIFont systemFontOfSize:15];
    nickLabel_1.text = @"昵称";
    [nickEditSection addSubview:nickLabel_1];
    
    //编辑昵称输入框
    nickEditTextField = [[JYBaseTextField alloc] initWithFrame:CGRectMake(nickLabel_1.right+45, 15, kScreenWidth-120, 20)];
    [nickEditTextField setLimitedLength:14];
    [nickEditTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [nickEditTextField setBorderStyle:UITextBorderStyleNone];
    [nickEditTextField setBackgroundColor:[UIColor clearColor]];
//    [nickEditTextField setKeyboardType:UIKeyboardTypeAlphabet];
    [nickEditTextField setReturnKeyType:UIReturnKeyDone];
    [nickEditTextField setText:[profileDataDic objectForKey:@"nick"]];
    [nickEditTextField setBaseDelegate:self];
    [nickEditTextField setFont:[UIFont systemFontOfSize:15]];
    [nickEditTextField setTextColor:[JYHelpers setFontColorWithString:@"#303030"]];
    [nickEditSection addSubview:nickEditTextField];
    
    /*************************昵称UI Section 部分结束**************************/
    
    /*************************情感状态Section 部分**************************/
    //编辑资料
    UILabel *editInfoTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(nickLabel.left,nickEditSection.bottom+25,80,20)];
    editInfoTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    editInfoTitleLabel.textAlignment = NSTextAlignmentLeft;
    editInfoTitleLabel.backgroundColor = [UIColor clearColor];
    editInfoTitleLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
    editInfoTitleLabel.font = [UIFont systemFontOfSize:14];
    editInfoTitleLabel.text = @"编辑资料";
    [myScrollView addSubview:editInfoTitleLabel];
    
    //情感状态区域编辑
    marrageStatuSection = [[UIView alloc] initWithFrame:CGRectMake(-1, editInfoTitleLabel.bottom+9, kScreenWidth+2, 50)];
    marrageStatuSection.backgroundColor = [UIColor whiteColor];
    marrageStatuSection.layer.borderColor = [[JYHelpers setFontColorWithString:@"#cccccc"] CGColor];
    marrageStatuSection.layer.borderWidth = 1;
    [myScrollView addSubview:marrageStatuSection];
    
    //情感状态标题
    UILabel *marrageStatuTitle = [[UILabel alloc] initWithFrame:CGRectMake(nickLabel.left, 15, 80, 20)];
    marrageStatuTitle.textAlignment = NSTextAlignmentLeft;
    marrageStatuTitle.backgroundColor = [UIColor clearColor];
    marrageStatuTitle.textColor = [JYHelpers setFontColorWithString:@"#848484"];
    marrageStatuTitle.font = [UIFont systemFontOfSize:15];
    marrageStatuTitle.text = @"情感状态";
    [marrageStatuSection addSubview:marrageStatuTitle];
    
    //情感状态内容
    marrageStatusContent = [[UILabel alloc] initWithFrame:CGRectMake(nickEditTextField.left,  marrageStatuTitle.top, kScreenWidth+2 -nickEditTextField.left, 20)];
    marrageStatusContent.textAlignment = NSTextAlignmentLeft;
    marrageStatusContent.backgroundColor = [UIColor clearColor];
    marrageStatusContent.textColor = [JYHelpers setFontColorWithString:@"#303030"];
    marrageStatusContent.font = [UIFont systemFontOfSize:15];
    marrageStatusContent.text = [[profileOptionDic objectForKey:@"marriage"] objectForKey:ToString([profileDataDic objectForKey:@"marriage"])];
    marrageStatusContent.userInteractionEnabled = YES;
    [marrageStatusContent setTag:101];
    [marrageStatuSection addSubview:marrageStatusContent];
    UITapGestureRecognizer *marrageStatusTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editColumnAction:)];
    [marrageStatusContent addGestureRecognizer:marrageStatusTap];
    
    //更多
    marrageStatusMore = [[UIImageView alloc]initWithFrame:CGRectMake(marrageStatusContent.width-20-2, 3, 8, 13)];
    [marrageStatusMore setUserInteractionEnabled:YES];
//    [marrageStatusMore setFrame:];
//    [marrageStatusMore setBackgroundImage:[UIImage imageNamed:@"more_gray"] forState:UIControlStateNormal];
//    [marrageStatusMore setBackgroundImage:[UIImage imageNamed:@"more_blue"] forState:UIControlStateHighlighted];
    [marrageStatusMore setImage:[UIImage imageNamed:@"more_gray"]];
    [marrageStatusContent addSubview:marrageStatusMore];
    /*************************情感状态Section 部分结束**************************/
    
    [self layoutSectionSix];
   
}
- (void)layoutSectionSix{
    /*************************资料编辑Section 部分**************************/
    //以下是细分远项 包含7项 每项高度都为50
    if (sectionSix) {
        [sectionSix removeFromSuperview];
    }
    CGFloat sectionSixHeight = 350;
    if (![[profileDataDic objectForKey:@"marriage"] isEqualToString:@"1"]) {
        sectionSixHeight = 50*4;
    }
    sectionSix = [[UIView alloc] initWithFrame:CGRectMake(-1, marrageStatuSection.bottom+15, kScreenWidth+2, sectionSixHeight)];//  350 = 50*7
    sectionSix.backgroundColor = [UIColor whiteColor];
    sectionSix.layer.borderColor = [[JYHelpers setFontColorWithString:@"#cccccc"] CGColor];
    sectionSix.layer.borderWidth = 1;
    [myScrollView addSubview:sectionSix];
    
    //省分城市
    UILabel * districtLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 15, 40, 20)];
    districtLabel.textAlignment = NSTextAlignmentLeft;
    districtLabel.backgroundColor = [UIColor clearColor];
    districtLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
    districtLabel.font = [UIFont systemFontOfSize:15];
    districtLabel.text = @"地区";
    [sectionSix addSubview:districtLabel];
    
    //城市
    NSString *province = [[JYShareData sharedInstance].province_code_dict objectForKey:ToString([profileDataDic objectForKey:@"live_location"])];
    NSString *city = [[JYShareData sharedInstance].city_code_dict  objectForKey:ToString([profileDataDic objectForKey:@"live_sublocation"])];
    cityContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(marrageStatusContent.left ,  districtLabel.top, sectionSix.width-marrageStatusContent.left, 20)];
    cityContentLabel.textAlignment = NSTextAlignmentLeft;
    cityContentLabel.backgroundColor = [UIColor clearColor];
    cityContentLabel.textColor = [JYHelpers setFontColorWithString:@"#303030"];
    cityContentLabel.font = [UIFont systemFontOfSize:15];
    if ([JYHelpers isEmptyOfString:province]) {
        province = @"不限";
    }
    if ([JYHelpers isEmptyOfString:city]) {
        city = @"不限";
    }
    
    if ([province isEqualToString:@"不限"] && [city isEqualToString:@"不限"]) {
        [cityContentLabel setText:@"请选择地区"];
        [cityContentLabel setTextColor:kTextColorLightGray];
    }else{
        cityContentLabel.text = [NSString stringWithFormat:@"%@, %@",province,city];
    }
    cityContentLabel.userInteractionEnabled = YES;
    [sectionSix addSubview:cityContentLabel];
    cityContentLabel.tag = 102;
    [cityContentLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editColumnAction:)]];
    
    //城市更多箭头
    UIImageView * cityEditMore = [[UIImageView alloc] initWithFrame:CGRectMake(cityContentLabel.width - 2 - 20,5, 8, 13)];
    [cityEditMore setImage:[UIImage imageNamed:@"more_gray"]];
    cityEditMore.backgroundColor = [UIColor clearColor];
    [cityContentLabel addSubview:cityEditMore];
    
    UILabel  *cityUnderLine = [[UILabel alloc] initWithFrame:CGRectMake(districtLabel.left ,  cityContentLabel.bottom+15, sectionSix.width-districtLabel.left, 1)];
    cityUnderLine.userInteractionEnabled = YES;
    cityUnderLine.layer.borderWidth = 1;
    cityUnderLine.layer.borderColor = [[JYHelpers setFontColorWithString:@"#edf1f4"] CGColor];
    [sectionSix addSubview:cityUnderLine];
    
    //常驻地title
    UILabel * frequentlyLabel = [[UILabel alloc] initWithFrame:CGRectMake(districtLabel.left, cityUnderLine.bottom+15, 40, 20)];
    frequentlyLabel.textAlignment = NSTextAlignmentLeft;
    frequentlyLabel.backgroundColor = [UIColor clearColor];
    frequentlyLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
    frequentlyLabel.font = [UIFont systemFontOfSize:15];
    frequentlyLabel.text = @"常驻";
    [sectionSix addSubview:frequentlyLabel];
    
    //    //常驻地更多箭头
    //    UIImageView * frequentlyEditMore = [[UIImageView alloc] initWithFrame:CGRectMake(marrageStatusMore.left,frequentlyLabel.top+5, 8, 13)];
    //    [frequentlyEditMore setImage:[UIImage imageNamed:@"more_gray"]];
    //    frequentlyEditMore.backgroundColor = [UIColor clearColor];
    //    [sectionSix addSubview:frequentlyEditMore];
    
    //编辑常驻地内容
    frequentlyEditContent = [[JYBaseTextField alloc] initWithFrame:CGRectMake(cityContentLabel.left, frequentlyLabel.top, kScreenWidth-cityContentLabel.left-10, 20)];
    [frequentlyEditContent setLimitedLength:20];
    [frequentlyEditContent setClearButtonMode:UITextFieldViewModeWhileEditing];
    [frequentlyEditContent setBorderStyle:UITextBorderStyleNone];
    [frequentlyEditContent setBackgroundColor:[UIColor clearColor]];
    //    [frequentlyEditContent setKeyboardType:UIKeyboardTypeAlphabet];
    [frequentlyEditContent setReturnKeyType:UIReturnKeyDone];
    [frequentlyEditContent setPlaceholder:@"请填写常驻地"];
    [frequentlyEditContent setText:[profileDataDic objectForKey:@"address"]];
    [frequentlyEditContent setBaseDelegate:self];
    [frequentlyEditContent setFont:[UIFont systemFontOfSize:15]];
    [frequentlyEditContent setTextColor:[JYHelpers setFontColorWithString:@"#303030"]];
    [sectionSix addSubview:frequentlyEditContent];
    
    UILabel  *frequentlyUnderLine = [[UILabel alloc] initWithFrame:CGRectMake(districtLabel.left ,  frequentlyEditContent.bottom+15, sectionSix.width-districtLabel.left, 1)];
    frequentlyUnderLine.userInteractionEnabled = YES;
    frequentlyUnderLine.layer.borderWidth = 1;
    frequentlyUnderLine.layer.borderColor = [[JYHelpers setFontColorWithString:@"#edf1f4"] CGColor];
    [sectionSix addSubview:frequentlyUnderLine];
    //存储不为单身的时候 常驻地的bottom
    CGFloat lastBottom = frequentlyLabel.bottom;
    
    if ([ToString([profileDataDic objectForKey:@"marriage"]) isEqualToString:@"1"]) {
        //生日
        UILabel *birthdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(districtLabel.left, frequentlyLabel.bottom+30, 40, 20)];
        birthdayLabel.textAlignment = NSTextAlignmentLeft;
        birthdayLabel.backgroundColor = [UIColor clearColor];
        birthdayLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
        birthdayLabel.font = [UIFont systemFontOfSize:15];
        birthdayLabel.text = @"生日";
        [sectionSix addSubview:birthdayLabel];
        
        //生日内容
        birthdayContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(marrageStatusContent.left ,  birthdayLabel.top, kScreenWidth-cityContentLabel.left, 20)];
        birthdayContentLabel.textAlignment = NSTextAlignmentLeft;
        birthdayContentLabel.backgroundColor = [UIColor clearColor];
        birthdayContentLabel.textColor = [JYHelpers setFontColorWithString:@"#303030"];
        birthdayContentLabel.font = [UIFont systemFontOfSize:15];
        //    NSLog(@"%@",[JYShareData sharedInstance].profile_dict );
        if ([[profileDataDic objectForKey:@"birthday"] isEqualToString:@"0000-00-00"]) {
            birthdayContentLabel.text = @"请选择出生日期";
            [birthdayContentLabel setTextColor:[JYHelpers setFontColorWithString:@"#b9b9b9"]];
        }else{
            NSLog(@"%@,%@",[profileDataDic objectForKey:@"animal"],[profileDataDic objectForKey:@"star"]);
//            NSString * animal = [[profileOptionDic objectForKey:@"animal"] objectForKey:ToString([profileDataDic objectForKey:@"animal"])];
            NSString *birth = [JYHelpers birthdayTransformToCentery:[profileDataDic objectForKey:@"birthday"]];
            NSString * mystar = [[profileOptionDic objectForKey:@"star"] objectForKey:ToString([profileDataDic objectForKey:@"star"])];
            birthdayContentLabel.text = [NSString stringWithFormat:@"%@,%@",birth,mystar];
        }
        
        birthdayContentLabel.userInteractionEnabled = YES;
        [sectionSix addSubview:birthdayContentLabel];
        birthdayContentLabel.tag = 103;
        UITapGestureRecognizer *birthdayTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editColumnAction:)];
        [birthdayContentLabel addGestureRecognizer:birthdayTap];
        
        //生日更多箭头
        UIImageView * birthdayEditMore = [[UIImageView alloc] initWithFrame:CGRectMake(birthdayContentLabel.width - 20,5, 8, 13)];
        [birthdayEditMore setImage:[UIImage imageNamed:@"more_gray"]];
        birthdayEditMore.backgroundColor = [UIColor clearColor];
        [birthdayContentLabel addSubview:birthdayEditMore];
        
        UILabel  *birthdayUnderLine = [[UILabel alloc] initWithFrame:CGRectMake(districtLabel.left ,  birthdayContentLabel.bottom+15, sectionSix.width-districtLabel.left, 1)];
        birthdayUnderLine.layer.borderWidth = 1;
        birthdayUnderLine.layer.borderColor = [[JYHelpers setFontColorWithString:@"#edf1f4"] CGColor];
        [sectionSix addSubview:birthdayUnderLine];
        
        //身高
        UILabel *heightLabel = [[UILabel alloc] initWithFrame:CGRectMake(birthdayLabel.left, birthdayLabel.bottom+30, 40, 20)];
        heightLabel.textAlignment = NSTextAlignmentLeft;
        heightLabel.backgroundColor = [UIColor clearColor];
        heightLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
        heightLabel.font = [UIFont systemFontOfSize:15];
        heightLabel.text = @"身高";
        [sectionSix addSubview:heightLabel];
        
        //身高内容
        heightContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(birthdayContentLabel.left ,  heightLabel.top, kScreenWidth-cityContentLabel.left, 20)];
        heightContentLabel.textAlignment = NSTextAlignmentLeft;
        heightContentLabel.backgroundColor = [UIColor clearColor];
        heightContentLabel.textColor = [JYHelpers setFontColorWithString:@"#303030"];
        heightContentLabel.font = [UIFont systemFontOfSize:15];
        heightContentLabel.userInteractionEnabled = YES;
        NSString *heightStr = [[profileOptionDic objectForKey:@"height" ] objectForKey:[NSString stringWithFormat:@"%ld",(long)[[profileDataDic objectForKey:@"height"] integerValue]]];
        if ([JYHelpers isEmptyOfString:heightStr]) {
            [heightContentLabel setText:@"请选择身高"];
            [heightContentLabel setTextColor:[JYHelpers setFontColorWithString:@"#b9b9b9"]];
        }else{
            heightContentLabel.text = heightStr;
        }
        
        [sectionSix addSubview:heightContentLabel];
        heightContentLabel.tag = 104;
        [heightContentLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editColumnAction:)]];
        
        //身高更多箭头
        UIImageView * heightEditMore = [[UIImageView alloc] initWithFrame:CGRectMake(marrageStatusMore.left,5, 8, 13)];
        [heightEditMore setImage:[UIImage imageNamed:@"more_gray"]];
        heightEditMore.backgroundColor = [UIColor clearColor];
        [heightContentLabel addSubview:heightEditMore];
        
        UILabel  *heightUnderLine = [[UILabel alloc] initWithFrame:CGRectMake(districtLabel.left ,  heightContentLabel.bottom+15, sectionSix.width-districtLabel.left, 1)];
        heightUnderLine.layer.borderWidth = 1;
        heightUnderLine.layer.borderColor = [[JYHelpers setFontColorWithString:@"#edf1f4"] CGColor];
        [sectionSix addSubview:heightUnderLine];
        
        //体重
        UILabel *weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(heightLabel.left, heightLabel.bottom+30, 40, 20)];
        weightLabel.textAlignment = NSTextAlignmentLeft;
        weightLabel.backgroundColor = [UIColor clearColor];
        weightLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
        weightLabel.font = [UIFont systemFontOfSize:15];
        weightLabel.text = @"体重";
        [sectionSix addSubview:weightLabel];
        
        //体重内容
        weightContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(heightContentLabel.left ,  weightLabel.top, kScreenWidth-cityContentLabel.left-10, 20)];
        weightContentLabel.textAlignment = NSTextAlignmentLeft;
        weightContentLabel.backgroundColor = [UIColor clearColor];
        weightContentLabel.textColor = [JYHelpers setFontColorWithString:@"#303030"];
        weightContentLabel.userInteractionEnabled = YES;
        weightContentLabel.font = [UIFont systemFontOfSize:15];
        NSString *weightStr = [[profileOptionDic objectForKey:@"weight"] objectForKey:ToString([profileDataDic objectForKey:@"weight"])];
        if ([JYHelpers isEmptyOfString:weightStr]) {
            [weightContentLabel setTextColor:kTextColorLightGray];
            [weightContentLabel setText:@"请选择体重"];
        }else{
            weightContentLabel.text = weightStr;
        }
        
        [sectionSix addSubview:weightContentLabel];
        weightContentLabel.tag = 105;
        [weightContentLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editColumnAction:)]];
        
        //体重更多箭头
        UIImageView * weightEditMore = [[UIImageView alloc] initWithFrame:CGRectMake(marrageStatusMore.left,5, 8, 13)];
        [weightEditMore setImage:[UIImage imageNamed:@"more_gray"]];
        weightEditMore.backgroundColor = [UIColor clearColor];
        [weightContentLabel addSubview:weightEditMore];
        
        UILabel  *weightUnderLine = [[UILabel alloc] initWithFrame:CGRectMake(districtLabel.left ,  weightContentLabel.bottom+15, sectionSix.width-districtLabel.left, 1)];
        weightUnderLine.layer.borderWidth = 1;
        weightUnderLine.layer.borderColor = [[JYHelpers setFontColorWithString:@"#edf1f4"] CGColor];
        [sectionSix addSubview:weightUnderLine];
        lastBottom = weightLabel.bottom;
    }
    
    //职业
    UILabel *workLabel = [[UILabel alloc] initWithFrame:CGRectMake(districtLabel.left, lastBottom+30, 40, 20)];
    workLabel.textAlignment = NSTextAlignmentLeft;
    workLabel.backgroundColor = [UIColor clearColor];
    workLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
    workLabel.font = [UIFont systemFontOfSize:15];
    workLabel.text = @"职业";
    [sectionSix addSubview:workLabel];
    
    //职业内容
    workContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(cityContentLabel.left ,  workLabel.top, kScreenWidth-cityContentLabel.left-10, 20)];
    workContentLabel.textAlignment = NSTextAlignmentLeft;
    workContentLabel.backgroundColor = [UIColor clearColor];
    workContentLabel.userInteractionEnabled = YES;
    workContentLabel.textColor = [JYHelpers setFontColorWithString:@"#303030"];
    workContentLabel.font = [UIFont systemFontOfSize:15];
    NSString *careerStr = [[profileOptionDic objectForKey:@"career"] objectForKey:ToString([profileDataDic objectForKey:@"career"])];
    if ([JYHelpers isEmptyOfString:careerStr]) {
        [workContentLabel setText:@"请选择职业"];
        [workContentLabel setTextColor:kTextColorLightGray];
    }else{
        workContentLabel.text = careerStr;
    }
    [sectionSix addSubview:workContentLabel];
    workContentLabel.tag = 106;
    [workContentLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editColumnAction:)]];
    
    //职业更多箭头
    UIImageView * workEditMore = [[UIImageView alloc] initWithFrame:CGRectMake(marrageStatusMore.left,5, 8, 13)];
    [workEditMore setImage:[UIImage imageNamed:@"more_gray"]];
    workEditMore.backgroundColor = [UIColor clearColor];
    [workContentLabel addSubview:workEditMore];
    
    UILabel  *workUnderLine = [[UILabel alloc] initWithFrame:CGRectMake(districtLabel.left ,  workContentLabel.bottom+15, sectionSix.width-districtLabel.left, 1)];
    workUnderLine.layer.borderWidth = 1;
    workUnderLine.layer.borderColor = [[JYHelpers setFontColorWithString:@"#edf1f4"] CGColor];
    [sectionSix addSubview:workUnderLine];
    
    
    //公司
    companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(workLabel.left, workLabel.bottom+30, 40, 20)];
    companyLabel.textAlignment = NSTextAlignmentLeft;
    companyLabel.backgroundColor = [UIColor clearColor];
    companyLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
    companyLabel.font = [UIFont systemFontOfSize:15];
    NSString *companyText;
    NSString *companyContent;
    NSString *placeHolderText;
    if ([workContentLabel.text isEqualToString:@"学生"]) {//如果当前职业为学生 公司部分变成学校
        companyText = @"学校";
        schoollOrCompany = @"school";
        companyContent = [profileDataDic objectForKey:@"school"];
        placeHolderText = @"请填写学校";
    }else{
        schoollOrCompany = @"company_name";
        companyContent = [profileDataDic objectForKey:@"company_name"];
        companyText = @"公司";
        placeHolderText = @"请填写公司";
    }
    companyLabel.text = companyText;
    [sectionSix addSubview:companyLabel];
    
    //公司内容
    companyEditTextField = [[JYBaseTextField alloc] initWithFrame:CGRectMake(workContentLabel.left, companyLabel.top, kScreenWidth-cityContentLabel.left-10, 20)];
    [companyEditTextField setLimitedLength:20];
    [companyEditTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [companyEditTextField setBorderStyle:UITextBorderStyleNone];
    [companyEditTextField setBackgroundColor:[UIColor clearColor]];
    //    [companyEditTextField setKeyboardType:UIKeyboardTypeAlphabet];
    [companyEditTextField setReturnKeyType:UIReturnKeyDone];
    [companyEditTextField setPlaceholder:placeHolderText];
    [companyEditTextField setText:companyContent];
    [companyEditTextField setBaseDelegate:self];
    [companyEditTextField setFont:[UIFont systemFontOfSize:15]];
    [companyEditTextField setTextColor:[JYHelpers setFontColorWithString:@"#303030"]];
    [sectionSix addSubview:companyEditTextField];
    
    
    UILabel  *companyUnderLine = [[UILabel alloc] initWithFrame:CGRectMake(districtLabel.left ,  companyEditTextField.bottom+15, sectionSix.width-districtLabel.left, 1)];
    companyUnderLine.layer.borderWidth = 1;
    companyUnderLine.layer.borderColor = [[JYHelpers setFontColorWithString:@"#edf1f4"] CGColor];
    [sectionSix addSubview:companyUnderLine];
    
    [myScrollView setContentSize:CGSizeMake(kScreenWidth, sectionSix.bottom+10)];
    /*************************资料编辑Section 部分结束**************************/

}
//点击对应的Label触发手势进入编辑界面 每个Label设置有tag值 通过tag值来区分点击
- (void)editColumnAction:(UITapGestureRecognizer*)tap{
//    editType
//    1 情感
//    2 地区
//    3 生日
//    4 身高
//    5 体重
//    6 职业
    [self bgClicked];
    NSInteger tag = tap.view.tag - 100;
    NSLog(@"%ld",(long)tag);
    JYProfileEditDetailController *editVC = [[JYProfileEditDetailController alloc] init];
    switch (tag) {
        case 1:
        {
            editVC.title = @"情感状态";
            editVC.contentText = marrageStatusContent.text;
        }
            break;
        case 2:
        {
            editVC.title = @"地区";
            editVC.contentText = cityContentLabel.text;
        }
            break;
        case 3:
        {
            editVC.title = @"生日";
            editVC.contentText = birthdayContentLabel.text;

        }
            break;
        case 4:
        {
            editVC.title = @"身高";
            editVC.contentText = heightContentLabel.text;
        }
            break;
        case 5:
        {
            editVC.title = @"体重";
            editVC.contentText = weightContentLabel.text;
        }
            break;
        case 6:
        {
            editVC.title = @"职业";
            editVC.contentText = workContentLabel.text;
        }
            break;
        default:
            break;
    }
    [editVC setProfileDataDic:[NSMutableDictionary dictionaryWithDictionary:profileDataDic]];
    editVC.editType = (int)tag;
    editVC.delegate = self;
    [self.navigationController pushViewController:editVC animated:YES];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    [theTextField resignFirstResponder];
    
    return YES;
}
//开始输入的时候判断是否需要改变frame
- (BOOL)textFieldShouldBeginEditing:(UITextField *)theTextField{
    
    offSet = myScrollView.contentOffset.y;//存储变化之前的scrollView偏移量 方便键盘消失时还原
    currentTxtFieldBottm = theTextField.superview.bottom;//存储当前textField父视图的底部高度
    /*当点击的是 常住地时  因为他的父视图为存储 7 个栏目的视图 
     而常住地 在第二个位置  所以需要减去 50*5 这样使文本框刚好在键盘上面
     */
    if (theTextField == frequentlyEditContent) {
        NSInteger count = [ToString([profileDataDic objectForKey:@"marriage"]) isEqualToString:@"1"] ? 5 : 2;
        currentTxtFieldBottm = currentTxtFieldBottm - 50*count;
    }
    return YES;
}
- (void)showPromptTip:(NSString *)tip{
    [[JYAppDelegate sharedAppDelegate] showPromptTip:tip withTipCenter:CGPointMake(kScreenWidth/2, kScreenHeight/2 - 30)];
}
#pragma mark - save action
//保存
- (void)saveChanges{
    [self bgClicked];
    
    if ([JYHelpers isEmptyOfString:nickEditTextField.text]) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"请填写昵称"];
        return;
    }

    [self showProgressHUD:@"保存中..." toView:self.view];
    if (avtar) {
        [self _requestUploadAvatarPhoto:avtar];
    }else{
        [self postDataToHttp:profileDataDic];
    }
}
- (void)bgClicked{
    [nickEditTextField resignFirstResponder];
    [companyEditTextField resignFirstResponder];
    [frequentlyEditContent resignFirstResponder];
}
#pragma mark - Notification
//- (void)keyboardWillShow:(NSNotification*)aNotification{
//    NSLog(@"%s",__func__);
//}
//
//- (void)keyboardWillHide:(NSNotification*)aNotification{
//    NSLog(@"%s",__func__);
//}
- (void)keyboardWillChangeFrame:(NSNotification*)noti{
    shouldHideKeyboard = NO;
//    if (currentTxtFieldBottm == nickEditTextField.superview.bottom) {
//        return;
//    }
    NSDictionary *dic = noti.userInfo;
    //下面分别为键盘弹出通知的动画  时间  起始位置  结束位置   差值
    CGFloat duration = [[dic objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat beginY = [[dic objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].origin.y;
    CGFloat endY = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    CGRect rect = [[dic objectForKeyedSubscript:UIKeyboardFrameEndUserInfoKey] CGRectValue];

    CGFloat distance = beginY - endY;
    
    //当前scrollView的可视范围
    CGFloat visualHeight = kScreenHeight - kNavigationBarHeight - kStatusBarHeight;
    CGFloat textFieldHeightFromTop = currentTxtFieldBottm - offSet;//当前文本框相对于可视范围最上方的高度
    CGFloat keyBoardHeight = rect.size.height;//键盘高度
    
    if (visualHeight  < textFieldHeightFromTop + keyBoardHeight  && distance > 0){
        NSLog(@"keyboard show");
        [UIView animateWithDuration:duration animations:^{
            [myScrollView setContentOffset:CGPointMake(0, currentTxtFieldBottm -visualHeight + keyBoardHeight)];
 
        } completion:^(BOOL finished) {
            shouldHideKeyboard = YES;
        }];

    }else{
        NSLog(@"keyboard hide");

        [UIView animateWithDuration:duration animations:^{
            [myScrollView setContentOffset:CGPointMake(0, offSet)];
        }];

    }
}

- (void) postNotificationRefreshData{
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshProfileInfoNotification object:nil userInfo:nil];
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (shouldHideKeyboard) {
        [self bgClicked];
    }
}
#pragma mark - JYProfileDelegate
//资料更新的上传FWQ
- (void)postDataToHttp:(NSDictionary *)dataDic{
    
    //    [self showProgressHUD:@"保存中,请稍后..." toView:self.view];
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"profile" forKey:@"mod"];
    [parametersDict setObject:@"update_user_info" forKey:@"func"];
    NSMutableDictionary *fieldsDict = [NSMutableDictionary dictionary];
    [fieldsDict setObject:nickEditTextField.text forKey:@"nick"];
    
    NSString *birthday = [dataDic objectForKey:@"birthday"];
    NSString *height = [dataDic objectForKey:@"height"];
    NSString *weight = [dataDic objectForKey:@"weight"];
    NSString *live_sublocation = [dataDic objectForKey:@"live_sublocation"];
    NSString *live_location = [dataDic objectForKey:@"live_location"];
    NSString *marriage = [dataDic objectForKey:@"marriage"];
    NSString *career = [dataDic objectForKey:@"career"];
    
    if (birthday) {
        [fieldsDict setObject:[dataDic objectForKey:@"birthday"] forKey:@"birthday"];

    }
    if (height) {
        [fieldsDict setObject:height forKey:@"height"];

    }
    if (weight) {
        [fieldsDict setObject:weight forKey:@"weight"];

    }
    if (live_sublocation) {
        [fieldsDict setObject:live_sublocation forKey:@"live_sublocation"];

    }
    if (live_location) {
        [fieldsDict setObject:live_location forKey:@"live_location"];

    }
    if (marriage) {
        [fieldsDict setObject:marriage forKey:@"marriage"];

    }
    if (career) {
        [fieldsDict setObject:career forKey:@"career"];

    }
    if (![JYHelpers isEmptyOfString:frequentlyEditContent.text]) {
        [fieldsDict setObject:frequentlyEditContent.text forKey:@"address"];
    }
    if (![JYHelpers isEmptyOfString:companyEditTextField.text]) {
        [fieldsDict setObject:companyEditTextField.text forKey:schoollOrCompany];
    }
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:fieldsDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] forKey:@"uid"];
    [postDict setObject:jsonString forKey:@"fields"];
    //    [postDict setObject:_passwordTextField.text forKey:@"password"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        [self dismissProgressHUDtoView:self.view];
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        
        if (iRetcode == 1) {
            NSLog(@"保存成功");
            [[JYAppDelegate sharedAppDelegate] showTip:@"保存成功"];
            [profileDataDic setObject:frequentlyEditContent.text forKey:@"address"];
            [profileDataDic setObject:companyEditTextField.text forKey:schoollOrCompany];
            [profileDataDic setObject:nickEditTextField.text forKey:@"nick"];
            [[JYShareData sharedInstance] setMyself_profile_dict:profileDataDic];
            
            if ([[JYProfileData sharedInstance] updateMyProfileWithNewProfileDic:profileDataDic]) {
                NSLog(@"更新成功");
                [[NSNotificationCenter defaultCenter] postNotificationName:kDynamicListRefreshTableNotify object:self userInfo:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshProfileInfoNotification object:nil];
            }else{
                NSLog(@"更新失败")
            }
            
        } else {
            NSLog(@"保存失败");
        }
        [self.navigationController popViewControllerAnimated:YES];
       
    } failure:^(id error) {
        [self dismissProgressHUDtoView:self.view];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"%@", error);
        
    }];
}
//当下一级选择职业时调用 查看职业是否选择了学生
- (void)careerDidSelectedStudent:(BOOL)isStu{
    if (isStu) {
        companyLabel.text = @"学校";
        companyEditTextField.text = [profileDataDic objectForKey:@"school"];
        [companyEditTextField setPlaceholder:@"请填写学校"];
        schoollOrCompany = @"school";
    }else{
        companyLabel.text = @"公司";
        [companyEditTextField setPlaceholder:@"请填写公司"];
        [companyEditTextField setText:[profileDataDic objectForKey:@"company_name"]];
        schoollOrCompany = @"company_name";
    }
    
}
//下层修改以后通过代理修改当前界面
- (void)modifyContentTextWithEditType:(int)editType content:(NSString*)contentText andNewProfileDic:(NSDictionary *)profileDic{
    profileDataDic = [NSMutableDictionary dictionaryWithDictionary:profileDic];
    switch (editType) {
        case 1:
            marrageStatusContent.text = contentText;
            [marrageStatusContent setTextColor:kTextColorBlack];
            [self layoutSectionSix];
//            [profileDataDic setObject:codeStr forKey:@"marriage"];
            break;
        case 2:
            cityContentLabel.text = contentText;
            [cityContentLabel setTextColor:kTextColorBlack];
//            [profileDataDic setObject:codeStr forKey:@"live_location"];
//            [profileDataDic setObject:subCodeStr forKey:@"live_sublocation"];
            break;
        case 3:
            birthdayContentLabel.text = contentText;
            [birthdayContentLabel setTextColor:kTextColorBlack];
//            [profileDataDic setObject:codeStr forKey:@"birthday"];
            break;
        case 4:
            heightContentLabel.text = contentText;
            [heightContentLabel setTextColor:kTextColorBlack];
//            [profileDataDic setObject:codeStr forKey:@"height"];
            break;
        case 5:
            weightContentLabel.text = contentText;
            [weightContentLabel setTextColor:kTextColorBlack];
//            [profileDataDic setObject:codeStr forKey:@"weight"];
            break;
        case 6:
//            [profileDataDic setObject:codeStr forKey:@"career"];
            workContentLabel.text = contentText;
            [workContentLabel setTextColor:kTextColorBlack];
            break;
        default:
            break;
    }
}
//- (void)setContentLabel:(UILabel*)label text:(NSString*)text{
//    
//    cityContentLabel.text = contentText;
//    [cityContentLabel setTextColor:kTextColorBlack];
//
//}
- (void)tapHeadViewGesture:(UIGestureRecognizer *)gesture
{
    NSLog(@" gesture");
    // 上传头像
    // 初始化actionsheet
    [self _initActionSheetView];
    
}

// 初始化
- (void)_initActionSheetView
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"设置头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            if (![JYHelpers canUseCamera]) {
                [JYHelpers showCameraAuthDeniedAlertView];
                return;
            }
            // 相机拍摄 2.1
            UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
            cameraPicker.delegate =self;
            cameraPicker.allowsEditing =YES;
            cameraPicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:cameraPicker animated:YES completion:NULL];
        }
            break;
        case 1:
        {
            // 从手机相册选择
            UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
            cameraPicker.delegate =self;
            cameraPicker.allowsEditing =YES;
            cameraPicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            cameraPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:cameraPicker animated:YES completion:NULL];
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - UIImagePickerController delegate
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 3.1
    avtar = [info objectForKey:UIImagePickerControllerEditedImage];
    
    // 上传头像请求
//    [self _requestUploadAvatarPhoto:image];
    [avatarImg setImage:avtar];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// 上传头像
- (void)_requestUploadAvatarPhoto:(UIImage *)image
{
//    [self showProgressHUD:@"保存中..." toView:self.view];
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"avatar" forKey:@"mod"];
    [parametersDict setObject:@"upload_useravatar" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    NSString * uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    [postDict setObject:uid forKey:@"uid"];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:imageData forKey:@"upload"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict dataDict:dataDict formDict:nil success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        [self dismissProgressHUDtoView:self.view];
        if (iRetcode == 1) {
//            [[JYAppDelegate sharedAppDelegate] showTip:kAvatarUpdateSuccess];
            [avatarImg setImage:image];
            NSDictionary * rAvatar = [responseObject objectForKey:@"data"];
            NSLog(@"上传成功");
            if ([rAvatar isKindOfClass:[NSDictionary class]]) {
                NSMutableDictionary *avatarsDic = [NSMutableDictionary dictionary];
                [avatarsDic setObject:[rAvatar objectForKey:@"pic100"] forKey:@"100"];
                [avatarsDic setObject:[rAvatar objectForKey:@"pic150"] forKey:@"150"];
                [avatarsDic setObject:[rAvatar objectForKey:@"pic200"] forKey:@"200"];
                [avatarsDic setObject:[rAvatar objectForKey:@"pic50"] forKey:@"50"];
                [avatarsDic setObject:[rAvatar objectForKey:@"pic600"] forKey:@"600"];
                [avatarsDic setObject:[rAvatar objectForKey:@"pid"] forKey:@"pid"];
                
//                NSMutableDictionary *newProfileDic = [NSMutableDictionary dictionaryWithDictionary:profileDataDic];
                [profileDataDic setObject:avatarsDic forKey:@"avatars"];
                
                [[JYShareData sharedInstance] setMyself_profile_dict:profileDataDic];
                
                [[JYProfileData sharedInstance] updateMyProfileWithNewProfileDic:profileDataDic];
                
                [self postDataToHttp:profileDataDic];
            }
            
        } else {
            [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        }
        
    } failure:^(id error) {
        [self dismissProgressHUDtoView:self.view];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"%@", error);
        
    }];
    
    
}

////修改常驻地
//- (void) updateFrequentlyAddress{
//    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
//    [parametersDict setObject:@"profile" forKey:@"mod"];
//    [parametersDict setObject:@"update_user_address" forKey:@"func"];
//    
//    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
//    [postDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] forKey:@"uid"];
//    [postDict setObject:[profileDataDic objectForKey:@"address"] forKey:@"address"];
//    
//    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
//        
//        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
//        
//        if (iRetcode == 1) {
//            NSLog(@"修改常驻地成功");
//        } else {
//            NSLog(@"修改常驻地失败");
//        }
//        
//    } failure:^(id error) {
//        
//        NSLog(@"%@", error);
//        
//    }];
//}

////修改公司名字 或 学校名字
//- (void) updateCompanyName{
//    
//    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
//    [parametersDict setObject:@"profile" forKey:@"mod"];
//    
//    if ([schoollOrCompany isEqualToString:@"school_name"]) {
//      [parametersDict setObject:@"update_user_school_name" forKey:@"func"];
//    }else{
//      [parametersDict setObject:@"update_user_company_name" forKey:@"func"];
//    }
//    
//    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
//    //[postDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] forKey:@"uid"];
//    [postDict setObject:[profileDataDic objectForKey:schoollOrCompany] forKey:schoollOrCompany];
//    
//    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
//        
//        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
//        
//        if (iRetcode == 1) {
//            NSLog(@"修改公司名称成功");
//        } else {
//            NSLog(@"修改公司名称失败");
//        }
//        
//    } failure:^(id error) {
//        
//        NSLog(@"%@", error);
//        
//    }];
//}
//- (void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
