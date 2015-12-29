//
//  JYOpenRegisterController.m
//  friendJY
//
//  Created by 高斌 on 15/3/6.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYOpenRegisterController.h"
#import "JYShareData.h"
#import "JYAppDelegate.h"
#import "JYHttpServeice.h"
#import <UIImageView+WebCache.h>
#import <ShareSDK/ShareSDK.h>
#import "JYGetPhoneContactsController.h"

@interface JYOpenRegisterController ()<UIScrollViewDelegate>
{
    UITextField *currentEditTextField;
    UIScrollView *myScrollView;
    CGFloat offSet;
    UIButton *saveBtn;
    NSString *sysCheckCode;
    JYPickEmotionStatusController *pickEmotionStatusController;
    
    BOOL shouldHideKeyboard;
}

@end

@implementation JYOpenRegisterController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"补充信息"];
        
        _seconds = kReacquireCodeWaitSecond;
        _currentGenderIndex = 1;//默认男
        _emotionStatusIndex = 1;//默认单身

        shouldHideKeyboard = NO;
    }
    
    return self;
}

- (void)backAction{
    [super backAction];
    if ([ShareSDK hasAuthorizedWithType:ShareTypeWeixiSession]) {
        [ShareSDK cancelAuthWithType:ShareTypeWeixiSession];
    }
    if ([ShareSDK hasAuthorizedWithType:ShareTypeQQSpace]) {
        [ShareSDK cancelAuthWithType:ShareTypeQQSpace];
    }
    if ([ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo]) {
        [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self bgTap];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    pickEmotionStatusController = [[JYPickEmotionStatusController alloc] init];
    [pickEmotionStatusController setJyDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
     myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight)];
    [myScrollView setShowsHorizontalScrollIndicator:NO];
    [myScrollView setShowsVerticalScrollIndicator:NO];
    [myScrollView setBackgroundColor:[UIColor clearColor]];
    [myScrollView setDelegate:self];
    [self.view addSubview:myScrollView];
    
    [myScrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTap)]];
    
    //头像设置
    _avatarImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, 100, 100)];
    [_avatarImage setCenter:CGPointMake(kScreenWidth/2, _avatarImage.center.y)];
    [_avatarImage setClipsToBounds:YES];
    [_avatarImage.layer setCornerRadius:_avatarImage.width/2];
    [_avatarImage setUserInteractionEnabled:YES];
    [_avatarImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTap:)]];
    NSString *avatarUrl = @"";
    NSString *nickName = @"";
    BOOL isMale = YES;
    switch (_loginType) {
        case sinaLogin:
        {
            avatarUrl = [_sourceDic objectForKey:@"avatar_large"];
            nickName = [_sourceDic objectForKey:@"name"];
            if (![[_sourceDic objectForKey:@"gender"] isEqualToString:@"m"]) {
                isMale = NO;
            }
        }
            break;
        case weChatLogin:
        {

            avatarUrl = [_sourceDic objectForKey:@"headimgurl"];
            nickName = [_sourceDic objectForKey:@"nickname"];
            if (![ToString([_sourceDic objectForKey:@"sex"]) isEqualToString:@"1"]) {
                isMale = NO;
            }
        }
            break;
            case qqLogin:
        {
            avatarUrl = [_sourceDic objectForKey:@"figureurl_qq_2"];
            nickName = [_sourceDic objectForKey:@"nickname"];
            if ([[_sourceDic objectForKey:@"gender"] isEqualToString:@"女"]) {
                isMale = NO;
            }
        }
            break;
        default:
            break;
    }
    [_avatarImage sd_setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed:@"register_avatar_upload.png"]];
//    [_avatarImage setImage:[UIImage imageNamed:@"register_avatar_upload.png"]];
    [_avatarImage setBackgroundColor:[UIColor lightGrayColor]];
    [myScrollView addSubview:_avatarImage];
    
    //TextField背景图片
    UIImageView *textBgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, _avatarImage.bottom+30, kScreenWidth, 44*3)];
    [textBgImage setBackgroundColor:[UIColor whiteColor]];
    [myScrollView addSubview:textBgImage];
//    ShareSDK getUserInfoWithType:<#(ShareType)#> field:<#(NSString *)#> fieldType:<#(SSUserFieldType)#> authOptions:<#(id<ISSAuthOptions>)#> result:<#^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error)result#>
    //昵称

    NSString *nickStr = [NSString stringWithFormat:@"昵称"];
    CGSize nickStrSize = [nickStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *nickLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, nickStrSize.width, nickStrSize.height)];
    [nickLab setCenter:CGPointMake(nickLab.center.x, textBgImage.top+22)];
    [nickLab setBackgroundColor:[UIColor clearColor]];
    [nickLab setFont:[UIFont systemFontOfSize:14.0f]];
    [nickLab setTextAlignment:NSTextAlignmentLeft];
    [nickLab setTextColor:kTextColorGray];
    [nickLab setText:nickStr];
    [myScrollView addSubview:nickLab];
    
    _nickTextField = [[JYBaseTextField alloc] initWithFrame:CGRectMake(100, textBgImage.top, kScreenWidth-100-15, 44)];
    [_nickTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_nickTextField setBorderStyle:UITextBorderStyleNone];
    [_nickTextField setTextAlignment:NSTextAlignmentRight];
    [_nickTextField setPlaceholder:@"1-14位中英文"];
    [_nickTextField setDelegate:self];
    [_nickTextField setLimitedLength:14];
    [_nickTextField setBackgroundColor:[UIColor clearColor]];
    [myScrollView addSubview:_nickTextField];
    [_nickTextField setText:nickName];
    //性别
    NSString *genderStr = [NSString stringWithFormat:@"性别"];
    CGSize genderStrSize = [genderStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *genderLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, genderStrSize.width, genderStrSize.height)];
    [genderLab setCenter:CGPointMake(nickLab.center.x, textBgImage.top+44+22)];
    [genderLab setBackgroundColor:[UIColor clearColor]];
    [genderLab setFont:[UIFont systemFontOfSize:14.0f]];
    [genderLab setTextAlignment:NSTextAlignmentLeft];
    [genderLab setTextColor:kTextColorGray];
    [genderLab setText:genderStr];
    [myScrollView addSubview:genderLab];
    
    //男
    _maleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_maleBtn setFrame:CGRectMake(kScreenWidth-170, _nickTextField.bottom, 85, 44)];
    [_maleBtn setTitle:@"男" forState:UIControlStateNormal];
    [_maleBtn setTitleColor:kTextColorGray forState:UIControlStateNormal];
    [_maleBtn setTitleColor:kTextColorWhite forState:UIControlStateSelected];
    [_maleBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [_maleBtn setBackgroundImage:[UIImage imageNamed:@"register_gender_normal.png"] forState:UIControlStateNormal];
    [_maleBtn setBackgroundImage:[UIImage imageNamed:@"register_gender_selected.png"] forState:UIControlStateSelected];
//    [_maleBtn setSelected:YES];
    [_maleBtn addTarget:self action:@selector(maleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:_maleBtn];
    
    //女
    _femaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_femaleBtn setFrame:CGRectMake(_maleBtn.right, _nickTextField.bottom, _maleBtn.width, _maleBtn.height)];
    [_femaleBtn setTitle:@"女" forState:UIControlStateNormal];
    [_femaleBtn setTitleColor:kTextColorGray forState:UIControlStateNormal];
    [_femaleBtn setTitleColor:kTextColorWhite forState:UIControlStateSelected];
    [_femaleBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [_femaleBtn setBackgroundImage:[UIImage imageNamed:@"register_gender_normal.png"] forState:UIControlStateNormal];
    [_femaleBtn setBackgroundImage:[UIImage imageNamed:@"register_gender_selected.png"] forState:UIControlStateSelected];
//    [_femaleBtn setSelected:NO];
    [_femaleBtn addTarget:self action:@selector(femaleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:_femaleBtn];
    if (isMale) {
        [_maleBtn setSelected:YES];
        [_femaleBtn setSelected:NO];
    }else{
        [_maleBtn setSelected:NO];
        [_femaleBtn setSelected:YES];
    }
    //情感状态
    NSString *emotionStr = [NSString stringWithFormat:@"情感状态"];
    CGSize emotionStrSize = [emotionStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *emotionLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, emotionStrSize.width, emotionStrSize.height)];
    [emotionLab setCenter:CGPointMake(emotionLab.center.x, textBgImage.top+88+22)];
    [emotionLab setBackgroundColor:[UIColor clearColor]];
    [emotionLab setFont:[UIFont systemFontOfSize:14.0f]];
    [emotionLab setTextAlignment:NSTextAlignmentLeft];
    [emotionLab setTextColor:kTextColorGray];
    [emotionLab setText:emotionStr];
    [myScrollView addSubview:emotionLab];
    
    _emotionStatusLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-15-8-10-100, textBgImage.top+88, 100, 44)];
    [_emotionStatusLab setBackgroundColor:[UIColor clearColor]];
    [_emotionStatusLab setText:@"请选择"];
    [_emotionStatusLab setFont:[UIFont systemFontOfSize:14.0f]];
    [_emotionStatusLab setTextColor:kTextColorGray];
    [_emotionStatusLab setTextAlignment:NSTextAlignmentRight];
    [_emotionStatusLab setUserInteractionEnabled:YES];
    [_emotionStatusLab addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emotionStatusLabTap:)]];
    [myScrollView addSubview:_emotionStatusLab];
    
    UIImageView *moreImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-15-8, 0, 8, 13)];
    [moreImage setCenter:CGPointMake(moreImage.center.x, textBgImage.bottom-22)];
    [moreImage setImage:[UIImage imageNamed:@"register_more.png"]];
    [myScrollView addSubview:moreImage];
    
    UIImageView *line_1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, textBgImage.top, kScreenWidth, 1)];
    [line_1 setBackgroundColor:kBorderColorGray];
    [myScrollView addSubview:line_1];
    
    UIImageView *line_2 = [[UIImageView alloc] initWithFrame:CGRectMake(15, textBgImage.top+44, kScreenWidth-15, 1)];
    [line_2 setBackgroundColor:kBorderColorGray];
    [myScrollView addSubview:line_2];
    
    UIImageView *line_3 = [[UIImageView alloc] initWithFrame:CGRectMake(_maleBtn.left, _maleBtn.top, 1, 44)];
    [line_3 setBackgroundColor:kBorderColorGray];
    [myScrollView addSubview:line_3];
    
    UIImageView *line_4 = [[UIImageView alloc] initWithFrame:CGRectMake(15, textBgImage.top+88, kScreenWidth-15, 1)];
    [line_4 setBackgroundColor:kBorderColorGray];
    [myScrollView addSubview:line_4];
    
    UIImageView *line_5 = [[UIImageView alloc] initWithFrame:CGRectMake(0, textBgImage.bottom, kScreenWidth, 1)];
    [line_5 setBackgroundColor:kBorderColorGray];
    [myScrollView addSubview:line_5];
    
    //TextField背景图片
    UIImageView *phoneNumberBgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, textBgImage.bottom+30, kScreenWidth, 44*2)];
    [phoneNumberBgImage setBackgroundColor:[UIColor whiteColor]];
    [myScrollView addSubview:phoneNumberBgImage];
    
    //中国 +86
    NSString *chinaStr = [NSString stringWithFormat:@"中国 +86"];
    CGSize chinaStrSize = [chinaStr sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *chinaLab = [[UILabel alloc] initWithFrame:CGRectMake(15, phoneNumberBgImage.top+14, chinaStrSize.width, 16)];
    [chinaLab setText:chinaStr];
    [chinaLab setBackgroundColor:[UIColor clearColor]];
    [chinaLab setTextAlignment:NSTextAlignmentCenter];
    [chinaLab setFont:[UIFont systemFontOfSize:14.0f]];
    [chinaLab setTextColor:kTextColorBlack];
    [myScrollView addSubview:chinaLab];
    
    //手机号
    _phoneNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(chinaLab.right+40, phoneNumberBgImage.top, kScreenWidth-15-chinaLab.width-40-10, 44)];
    [_phoneNumberTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_phoneNumberTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [_phoneNumberTextField setBorderStyle:UITextBorderStyleNone];
    [_phoneNumberTextField setBackgroundColor:[UIColor clearColor]];
    [_phoneNumberTextField setPlaceholder:kPleaseEnterPhoneNumber];
    [_phoneNumberTextField setDelegate:self];
    [myScrollView addSubview:_phoneNumberTextField];
    
    //验证码
    _verCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, phoneNumberBgImage.top+44, kScreenWidth-15-120, 44)];
    [_verCodeTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_verCodeTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [_verCodeTextField setBorderStyle:UITextBorderStyleNone];
    [_verCodeTextField setBackgroundColor:[UIColor clearColor]];
    [_verCodeTextField setPlaceholder:@"验证码"];
    [_verCodeTextField setDelegate:self];
    [myScrollView addSubview:_verCodeTextField];
    
    //获取验证码
    _getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_getCodeBtn setFrame:CGRectMake(_verCodeTextField.right, phoneNumberBgImage.top+44, 120, 44)];
    //    [_getCodeBtn setBackgroundColor:kTextColorBlue];
    [_getCodeBtn setBackgroundImage:[UIImage imageNamed:@"register_get_code_btn_enable.png"] forState:UIControlStateNormal];
    [_getCodeBtn setBackgroundImage:[UIImage imageNamed:@"register_get_code_btn_disenable.png"] forState:UIControlStateDisabled];
    //    [_getCodeBtn.titleLabel setFont:[UIFont fontWithName:@"Arial" size:12.0f]];
    [_getCodeBtn addTarget:self action:@selector(getCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:_getCodeBtn];
    
    _getCodeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _getCodeBtn.width, _getCodeBtn.height)];
    [_getCodeLab setBackgroundColor:[UIColor clearColor]];
    [_getCodeLab setFont:[UIFont systemFontOfSize:14.0f]];
    [_getCodeLab setTextColor:[UIColor whiteColor]];
    [_getCodeLab setText:@"获取验证码"];
    [_getCodeLab setTextAlignment:NSTextAlignmentCenter];
    [_getCodeBtn addSubview:_getCodeLab];
    
    UIImageView *line_6 = [[UIImageView alloc] initWithFrame:CGRectMake(0, phoneNumberBgImage.top, kScreenWidth, 1)];
    [line_6 setBackgroundColor:kBorderColorGray];
    [myScrollView addSubview:line_6];
    
    UIImageView *line_7 = [[UIImageView alloc] initWithFrame:CGRectMake(chinaLab.right+20, phoneNumberBgImage.top+5, 1, 34)];
    [line_7 setBackgroundColor:kBorderColorGray];
    [myScrollView addSubview:line_7];
    
    UIImageView *line_8 = [[UIImageView alloc] initWithFrame:CGRectMake(0, phoneNumberBgImage.top+44, kScreenWidth-120, 1)];
    [line_8 setBackgroundColor:kBorderColorGray];
    [myScrollView addSubview:line_8];
    
    UIImageView *line_9 = [[UIImageView alloc] initWithFrame:CGRectMake(0, phoneNumberBgImage.bottom, kScreenWidth, 1)];
    [line_9 setBackgroundColor:kBorderColorGray];
    [myScrollView addSubview:line_9];
    
    //保存
     saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setFrame:CGRectMake(15, phoneNumberBgImage.bottom+20, kScreenWidth-30, 44)];
    UIImage *saveBtnAvailableImage = [[UIImage imageNamed:@"login_confirm_btn_available.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [saveBtn setBackgroundImage:saveBtnAvailableImage forState:UIControlStateNormal];
    UIImage *saveBtnUnavailableImage = [[UIImage imageNamed:@"login_confirm_btn_unavailable.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [saveBtn setBackgroundImage:saveBtnUnavailableImage forState:UIControlStateDisabled];
    [saveBtn setBackgroundColor:[UIColor lightGrayColor]];
    [saveBtn setTitle:@"完成" forState:UIControlStateNormal];
    [saveBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
    [saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setEnabled:NO];
    [myScrollView addSubview:saveBtn];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkEditCompleted:) userInfo:nil repeats:YES];
    [myScrollView setContentSize:CGSizeMake(kScreenWidth, saveBtn.bottom+20)];
}
//- (void)bgClicked{
//    
//    [_nickTextField resignFirstResponder];
//    [_phoneNumberTextField resignFirstResponder];
//    [_verCodeTextField resignFirstResponder];
//
//}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

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

- (void)checkEditCompleted:(NSTimer*)timer{
    if (_nickTextField.text.length != 0 && _emotionStatusLab.text.length != 0 && _phoneNumberTextField.text.length == 11 && _verCodeTextField.text.length == 6) {
        [saveBtn setEnabled:YES];
        [timer invalidate];
    }
}
- (void)bgTap
{
    [_nickTextField resignFirstResponder];
    [_phoneNumberTextField resignFirstResponder];
    [_verCodeTextField resignFirstResponder];

}

- (void)avatarTap:(UITapGestureRecognizer *)tap
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    [sheet showInView:self.view];
}

- (void)maleBtnClick:(UIButton *)maleBtn
{
    if (!maleBtn.selected) {
        [maleBtn setSelected:YES];
        _currentGenderIndex = 1;
        [_femaleBtn setSelected:NO];
    }
}

- (void)femaleBtnClick:(UIButton *)femaleBtn
{
    if (!femaleBtn.selected) {
        [femaleBtn setSelected:YES];
        _currentGenderIndex = 0;
        [_maleBtn setSelected:NO];
    }
}

- (void)emotionStatusLabTap:(UITapGestureRecognizer *)tap
{
    NSLog(@"情感状态");
    pickEmotionStatusController.seleStatues = _emotionStatusIndex-1;
    [self.navigationController pushViewController:pickEmotionStatusController animated:YES];
}

- (void)getCodeBtnClick:(UIButton *)btn
{
    [btn setEnabled:NO];
    if ([JYHelpers isPhoneNumber:_phoneNumberTextField.text]) {
        
        //检查手机号
        [self requestMobileExists];
        
    } else {
        [btn setEnabled:YES];
        [[JYAppDelegate sharedAppDelegate] showTip:kPleaseEnterValidPhoneNumber];
    }
}

- (void)saveBtnClick:(UIButton *)btn
{
    if ([_emotionStatusLab.text isEqualToString:@"请选择"]){
        [[JYAppDelegate sharedAppDelegate] showTip:@"请选择情感状态"];
        return;
    }
    NSLog(@"保存")
    [self requestDoRegisterAll];
}

- (void)timerFireMethod:(NSTimer *)timer
{
    if (_seconds == 1) {
        [timer invalidate];
        _seconds = kReacquireCodeWaitSecond;
        //        [_getCodeBtn setSelected:NO];
        //        [_getCodeBtn setBackgroundColor:kTextColorBlue];
        [_getCodeLab setText:@"获取验证码"];
        [_getCodeBtn setEnabled:YES];
    } else {
        _seconds--;
        //        [_getCodeBtn setSelected:YES];
        //        [_getCodeBtn setBackgroundColor:kTextColorGray];
        NSString *title = [NSString stringWithFormat:@"重新发送%ld",(long)_seconds];
        [_getCodeLab setText:title];
        [_getCodeBtn setEnabled:NO];
    }
}

#pragma mark - request

//判断手机是否存在
- (void)requestMobileExists
{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"register" forKey:@"mod"];
    [parametersDict setObject:@"mobile_exists" forKey:@"func"];
    
    
    NSMutableDictionary *formDict = [NSMutableDictionary dictionary];
    [formDict setObject:_phoneNumberTextField.text forKey:@"mobile"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict formDict:formDict success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        
        if (iRetcode == 1) {
            
            //手机号没有注册
            [self requestGetCheckCode];
            
        } else if (iRetcode == -1) {
            
            //手机号已经注册
            NSLog(@"%@", [responseObject objectForKey:@"retmean"]);
            [[JYAppDelegate sharedAppDelegate] showTip:kPhoneNumberAlreadyRegisterPleaseLogin];
            [self backAction];
            
        } else if (iRetcode == -2) {
            
            //手机号不合法
            NSLog(@"%@", [responseObject objectForKey:@"retmean"]);
            [[JYAppDelegate sharedAppDelegate] showTip:kPleaseEnterValidPhoneNumber];
        } else {}
        
    } failure:^(id error) {
        
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        
    }];
    
}

//获取验证码
- (void)requestGetCheckCode
{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"register" forKey:@"mod"];
    [parametersDict setObject:@"get_check_code" forKey:@"func"];
    
    NSMutableDictionary *formDict = [NSMutableDictionary dictionary];
    [formDict setObject:_phoneNumberTextField.text forKey:@"mobile"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict formDict:formDict success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        [_getCodeBtn setEnabled:YES];
        if (iRetcode == 1) {
            
            NSLog(@"成功");
            sysCheckCode = [[responseObject objectForKey:@"data"] objectForKey:@"check_code"];
            [[JYAppDelegate sharedAppDelegate] showTip:kVerificationCodeSentSuccess];
            [_getCodeBtn setEnabled:NO];
            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
            
        } else if (iRetcode == -1) {
            
            //手机号已经注册
            NSLog(@"%@", [responseObject objectForKey:@"retmean"]);
            [[JYAppDelegate sharedAppDelegate] showTip:kPhoneNumberAlreadyRegisterPleaseLogin];
            
        } else if (iRetcode == -2) {
            
            //手机号不合法
            NSLog(@"%@", [responseObject objectForKey:@"retmean"]);
            [[JYAppDelegate sharedAppDelegate] showTip:kPleaseEnterValidPhoneNumber];
            
        } else {}
        
    } failure:^(id error) {
        
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        
    }];
}
//点击保存执行注册
- (void)requestDoRegisterAll
{
    if (!sysCheckCode) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"还没有获取验证码。"];
        return;
    }
    if ([_verCodeTextField.text integerValue]  != [sysCheckCode integerValue]) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"验证码输入有误"];
        return;
    }
    [self showProgressHUD:@"加载中..." toView:self.view];
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"register" forKey:@"mod"];
    [parametersDict setObject:@"do_register_all" forKey:@"func"];
    
    NSMutableDictionary *formDict = [NSMutableDictionary dictionary];
    [formDict setObject:_phoneNumberTextField.text forKey:@"mobile"];
    [formDict setObject:_verCodeTextField.text forKey:@"mobile_code"];
    [formDict setObject:@"111111" forKey:@"password"];//第三方登录默认密码 111111
    [formDict setObject:_nickTextField.text forKey:@"nick"];
    [formDict setObject:[NSString stringWithFormat:@"%ld", (long)_currentGenderIndex] forKey:@"sex"];
    [formDict setObject:[NSString stringWithFormat:@"%ld", (long)_emotionStatusIndex] forKey:@"marriage"];
    //    [formDict setObject:@"" forKey:@"openid"];
    //    [formDict setObject:@"" forKey:@"openid_type"];
    //    [formDict setObject:@"" forKey:@"access_token"];
    //    [formDict setObject:@"" forKey:@"f"];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:UIImageJPEGRepresentation(_avatarImage.image, 1) forKey:@"upload"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:UUID forKey:@"reg_meid"];
    [postDict setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey] forKey:@"reg_version"];
    [postDict setObject:@"100" forKey:@"reg_channel_id"];
    [postDict setObject:@"ios" forKey:@"reg_mtype"];
    
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict dataDict:dataDict formDict:formDict success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            //绑定
            [self performSelectorInBackground:@selector(requestBind) withObject:nil];
            //成功
            [[JYAppDelegate sharedAppDelegate] showTip:@"注册成功"];
            
            NSDictionary *dataDict = [responseObject objectForKey:@"data"];
            NSString *token = [dataDict objectForKey:@"token"];
            NSString *uid = ToString([dataDict objectForKey:@"uid"]);
            
            dispatch_queue_t queue = dispatch_queue_create("uplist", DISPATCH_QUEUE_CONCURRENT);
            dispatch_async(queue, ^{
                sleep(3);
                [[JYShareData sharedInstance] upListAndShowProgress:NO];
            });
            
            [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"uid"];
            [[NSUserDefaults standardUserDefaults] setObject:_phoneNumberTextField.text forKey:@"phone"];
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isAutoLogin"];
            
            [SharedDefault setBool:YES forKey:kUDPushShakeOption];
            [SharedDefault setBool:YES forKey:kUDPushSoundOption];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotification object:nil];
            
        }else if (iRetcode == -1){
            [[JYAppDelegate sharedAppDelegate] showTip:@"信息错误"];
        }else if (iRetcode == -2 || iRetcode == -5){
            [[JYAppDelegate sharedAppDelegate] showTip:@"sorry，服务器异常"];
        }else if (iRetcode == -3){
            [[JYAppDelegate sharedAppDelegate] showTip:@"手机号格式错误或者已经存在"];
        }else if (iRetcode == -4){
            [[JYAppDelegate sharedAppDelegate] showTip:@"密码长度有误"];
        }else if (iRetcode == -7){
            [[JYAppDelegate sharedAppDelegate] showTip:@"手机验证码有误"];
        }else if (iRetcode == -8){
            [[JYAppDelegate sharedAppDelegate] showTip:@"性别有误"];
        }else if (iRetcode == - 9){
            [[JYAppDelegate sharedAppDelegate] showTip:@"情感状态有误"];
        }else {
            NSLog(@"%@", [responseObject objectForKey:@"retmean"]);
        }
        [self dismissProgressHUDtoView:self.view];
        
    } failure:^(id error) {
        [self dismissProgressHUDtoView:self.view];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        
    }];
    
}
//绑定
- (void)requestBind{
    
    NSString *openid_type = @"";
    switch (_loginType) {
        case weChatLogin:
            openid_type = @"1";
            break;
        case sinaLogin:
            openid_type = @"2";
            break;
        case qqLogin:
            openid_type = @"3";
            break;
        default:
            break;
    }
    
    //    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
    //    [fomatter setDateFormat:@"yyyyMMdd"];
    NSDictionary *paraDic = @{@"mod":@"login",
                              @"func":@"bind"
                              };
    
    NSString *jsonStr = [NSString stringWithFormat:@"{\"openid\":\"%@\",\"refresh_token\":\"\",\"access_token\":\"%@\",\"openid_type\":\"%@\"}",_uid,_token,openid_type];
    NSLog(@"jsonStr -> %@",jsonStr);
    NSDictionary *postDic = [NSDictionary dictionaryWithObject:jsonStr forKey:@"dat"];
    
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            //do any addtion here...
        }
    } failure:^(id error) {
        
    }];

}
#pragma mark - JYPickEmotionStatusDelegate

- (void)pickEmotionStatusCompleteWithIndex:(NSNumber *)indexPath;
{
    _emotionStatusIndex = [indexPath integerValue]+1;
    
    NSString *key = [NSString stringWithFormat:@"%ld", (long)_emotionStatusIndex];
    [_emotionStatusLab setText:[[[NSDictionary alloc]initWithObjects:@[@"单身",@"恋爱中",@"已婚",@"保密"] forKeys:@[@"1",@"2",@"3",@"4"]] objectForKey:key]];
    
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{

    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    [imagePickerController setAllowsEditing:YES];
    //弹出时 动画风格
    [imagePickerController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    switch (buttonIndex) {
        case 0:
        {
            if (![JYHelpers canUseCamera]) {
                [JYHelpers showCameraAuthDeniedAlertView];
                return;
            }
            //拍照
            [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
            [self presentViewController:imagePickerController animated:YES completion:NULL];
        }
            break;
        case 1:
        {
            //手机相册选取
            [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [self presentViewController:imagePickerController animated:YES completion:NULL];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [_avatarImage setImage:image];
//    NSData *avatarData = UIImageJPEGRepresentation(image, 1.0);
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - Notification

//- (void)textFieldTextDidChange:(NSNotification *)notification
//{
//    NSString *content = _nickTextField.text;
//    if (content.length>10) {
//        [[JYAppDelegate sharedAppDelegate] showTip:@"昵称最多10个字"];
//        _nickTextField.text = [content substringToIndex:10];
//    }
//}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
 //手机号不能超过11位
    if ([textField isEqual:_phoneNumberTextField] && textField.text.length == 11 && ![string isEqualToString:@""]) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"手机号不能超过11位"];
        return NO;
    }
//    验证码不能超过6位
    if ([textField isEqual:_verCodeTextField] && textField.text.length == 6 && ![string isEqualToString:@""]) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"验证码不能超过6位"];
        return NO;
    }
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //防止偏移过多
    if (saveBtn.bottom + 20 - myScrollView.contentOffset.y >= KScreenVisualHeight) {
        offSet = myScrollView.contentOffset.y;
    }
    currentEditTextField = textField;

    return YES;
}
#pragma mark -Notification
- (void)keyboardWillChangeFrame:(NSNotification*)noti{
    shouldHideKeyboard = NO;
    NSDictionary *dic = noti.userInfo;
    //下面分别为键盘弹出通知的动画  时间  起始位置  结束位置   差值
    CGFloat duration = [[dic objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat beginY = [[dic objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].origin.y;
    CGFloat endY = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    CGRect rect = [[dic objectForKeyedSubscript:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat distance = beginY - endY;
    
    //当前scrollView的可视范围
    CGFloat visualHeight = kScreenHeight - kNavigationBarHeight - kStatusBarHeight;
    CGFloat textFieldHeightFromTop = currentEditTextField.bottom - offSet;//当前文本框相对于可视范围最上方的高度
//    CGFloat keyBoardHeight = distance > 0 ? distance : - distance;//键盘高度
    CGFloat keyBoardHeight = rect.size.height;//键盘高度
    
    if (visualHeight  < textFieldHeightFromTop + keyBoardHeight  && distance > 0){
        NSLog(@"keyboard show");
        [UIView animateWithDuration:duration animations:^{
            if (currentEditTextField != _nickTextField) {
                [myScrollView setContentOffset:CGPointMake(0, keyBoardHeight+saveBtn.bottom+20-KScreenVisualHeight)];
            }else{
                [myScrollView setContentOffset:CGPointMake(0, currentEditTextField.bottom -visualHeight + keyBoardHeight)];
            }
            
        } completion:^(BOOL finished) {
            shouldHideKeyboard = YES;
        }];
        
    }else{
        NSLog(@"keyboard hide");
        
        [UIView animateWithDuration:duration animations:^{
            [myScrollView setContentOffset:CGPointMake(0, offSet)];
        } completion:^(BOOL finished) {
            shouldHideKeyboard = YES;
        }];
        
    }

//    [UIView animateWithDuration:duration animations:^{
//        if (visualHeight  < textFieldHeightFromTop + keyBoardHeight  && distance > 0) {
//            //如果是键盘弹出 并且会遮住文本框
//            [myScrollView setContentOffset:CGPointMake(0, myScrollView.contentOffset.y + textFieldHeightFromTop + keyBoardHeight - visualHeight +10)];
//            shouldHideKeyboard = YES;
//        }else{
//            [myScrollView setContentOffset:CGPointMake(0, offSet)];
//        
//        }
//    }];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (shouldHideKeyboard) {
        [self bgTap];
    }
}
@end




