//
//  JYRegisterInfoController.m
//  friendJY
//
//  Created by 高斌 on 15/3/3.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYRegisterInfoController.h"
#import "JYPickEmotionStatusController.h"
#import "JYHttpServeice.h"
#import "JYAppDelegate.h"
#import "JYShareData.h"
#import "JYGetPhoneContactsController.h"

@interface JYRegisterInfoController ()
{
    CGFloat offSet;//键盘弹出之前 scrollView的Y偏移量
    JYPickEmotionStatusController *pickEmotionStatusController;
}
@property (nonatomic, strong) UIScrollView *myScrollView;

@end

@implementation JYRegisterInfoController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [self setTitle:@"填写信息"];
        _emotionStatusIndex = 1;
    }
    
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    pickEmotionStatusController = [[JYPickEmotionStatusController alloc] init];
    [pickEmotionStatusController setJyDelegate:self];
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    _currentGenderIndex = 1;
    [_myScrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTap:)]];
    _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight)];
    [_myScrollView setShowsHorizontalScrollIndicator:NO];
    [_myScrollView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:_myScrollView];
    //欢迎加入***\n填写你的信息，让好友更容易找到你
    NSString *welcomeStr = [NSString stringWithFormat:@"欢迎加入友寻\n填写你的信息，让好友更容易找到你"];
    CGSize welcomeStrSize = [welcomeStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *welcomeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, welcomeStrSize.width, welcomeStrSize.height)];
    [welcomeLab setCenter:CGPointMake(kScreenWidth/2, welcomeLab.center.y)];
    [welcomeLab setTextAlignment:NSTextAlignmentCenter];
    [welcomeLab setNumberOfLines:0];
    [welcomeLab setBackgroundColor:[UIColor clearColor]];
    [welcomeLab setUserInteractionEnabled:YES];
    [welcomeLab setFont:[UIFont systemFontOfSize:14.0f]];
    [welcomeLab setTextColor:kTextColorGray];
    [welcomeLab setText:welcomeStr];
    [_myScrollView addSubview:welcomeLab];
    
    //头像设置
    _avatarImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, welcomeLab.bottom+20, 100, 100)];
    [_avatarImage setClipsToBounds:YES];
    [_avatarImage.layer setCornerRadius:_avatarImage.width/2];
    [_avatarImage setCenter:CGPointMake(kScreenWidth/2, _avatarImage.center.y)];
    [_avatarImage setUserInteractionEnabled:YES];
    [_avatarImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTap:)]];
    [_avatarImage setImage:[UIImage imageNamed:@"register_avatar_upload.png"]];
    [_avatarImage setBackgroundColor:[UIColor lightGrayColor]];
    [_myScrollView addSubview:_avatarImage];
    
    //TextField背景图片
    UIImageView *textBgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, _avatarImage.bottom+30, kScreenWidth, 44*3)];
    [textBgImage setBackgroundColor:[UIColor whiteColor]];
    [_myScrollView addSubview:textBgImage];
    
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
    [_myScrollView addSubview:nickLab];
    
    _nickTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, textBgImage.top, kScreenWidth-100-15, 44)];
    [_nickTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_nickTextField setBorderStyle:UITextBorderStyleNone];
    [_nickTextField setTextAlignment:NSTextAlignmentRight];
    [_nickTextField setPlaceholder:@"1-14位中英文"];
    [_nickTextField setDelegate:self];
    [_nickTextField setBackgroundColor:[UIColor clearColor]];
    [_nickTextField setReturnKeyType:UIReturnKeyDone];
    [_myScrollView addSubview:_nickTextField];
    
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
    [_myScrollView addSubview:genderLab];
    
    //男
    _maleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_maleBtn setFrame:CGRectMake(kScreenWidth-170, _nickTextField.bottom, 85, 44)];
    [_maleBtn setTitle:@"男" forState:UIControlStateNormal];
    [_maleBtn setTitleColor:kTextColorGray forState:UIControlStateNormal];
    [_maleBtn setTitleColor:kTextColorWhite forState:UIControlStateSelected];
    [_maleBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [_maleBtn setBackgroundImage:[UIImage imageNamed:@"register_gender_normal.png"] forState:UIControlStateNormal];
    [_maleBtn setBackgroundImage:[UIImage imageNamed:@"register_gender_selected.png"] forState:UIControlStateSelected];
    [_maleBtn setSelected:YES];
    [_maleBtn addTarget:self action:@selector(maleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_myScrollView addSubview:_maleBtn];
    
    //女
    _femaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_femaleBtn setFrame:CGRectMake(_maleBtn.right, _nickTextField.bottom, _maleBtn.width, _maleBtn.height)];
    [_femaleBtn setTitle:@"女" forState:UIControlStateNormal];
    [_femaleBtn setTitleColor:kTextColorGray forState:UIControlStateNormal];
    [_femaleBtn setTitleColor:kTextColorWhite forState:UIControlStateSelected];
    [_femaleBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [_femaleBtn setBackgroundImage:[UIImage imageNamed:@"register_gender_normal.png"] forState:UIControlStateNormal];
    [_femaleBtn setBackgroundImage:[UIImage imageNamed:@"register_gender_selected.png"] forState:UIControlStateSelected];
    [_femaleBtn setSelected:NO];
    [_femaleBtn addTarget:self action:@selector(femaleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_myScrollView addSubview:_femaleBtn];

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
    [_myScrollView addSubview:emotionLab];
    
    _emotionStatusLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-15-8-10-100, textBgImage.top+88, 100, 44)];
    [_emotionStatusLab setBackgroundColor:[UIColor clearColor]];
    [_emotionStatusLab setText:@"请选择"];
    [_emotionStatusLab setFont:[UIFont systemFontOfSize:14.0f]];
    [_emotionStatusLab setTextColor:kTextColorGray];
    [_emotionStatusLab setTextAlignment:NSTextAlignmentRight];
    [_emotionStatusLab setUserInteractionEnabled:YES];
    [_emotionStatusLab addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emotionStatusLabTap:)]];
    [_myScrollView addSubview:_emotionStatusLab];
    
    UIImageView *moreImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-15-8, 0, 8, 13)];
    [moreImage setCenter:CGPointMake(moreImage.center.x, textBgImage.bottom-22)];
    [moreImage setImage:[UIImage imageNamed:@"register_more.png"]];
    [_myScrollView addSubview:moreImage];
    
    UIImageView *line_1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, textBgImage.top, kScreenWidth, 1)];
    [line_1 setBackgroundColor:kBorderColorGray];
    [_myScrollView addSubview:line_1];
    
    UIImageView *line_2 = [[UIImageView alloc] initWithFrame:CGRectMake(15, textBgImage.top+44, kScreenWidth-15, 1)];
    [line_2 setBackgroundColor:kBorderColorGray];
    [_myScrollView addSubview:line_2];
    
    UIImageView *line_3 = [[UIImageView alloc] initWithFrame:CGRectMake(_maleBtn.left, _maleBtn.top, 1, 44)];
    [line_3 setBackgroundColor:kBorderColorGray];
    [_myScrollView addSubview:line_3];
    
    UIImageView *line_4 = [[UIImageView alloc] initWithFrame:CGRectMake(15, textBgImage.top+88, kScreenWidth-15, 1)];
    [line_4 setBackgroundColor:kBorderColorGray];
    [_myScrollView addSubview:line_4];
    
    UIImageView *line_5 = [[UIImageView alloc] initWithFrame:CGRectMake(0, textBgImage.bottom, kScreenWidth, 1)];
    [line_5 setBackgroundColor:kBorderColorGray];
    [_myScrollView addSubview:line_5];
    
//    UIButton *emotionStatusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [emotionStatusBtn setFrame:CGRectMake(0, emotionLab.top-10, kScreenWidth, 40)];
//    [emotionStatusBtn setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.5f]];
//    [emotionStatusBtn addTarget:self action:@selector(emotionStatusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_myScrollView addSubview:emotionStatusBtn];
    
    //保存
//    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [saveBtn setFrame:CGRectMake(20, emotionLab.bottom+100, kScreenWidth-40, 60)];
//    [saveBtn setBackgroundColor:[UIColor lightGrayColor]];
//    [saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
//    [saveBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
//    [_myScrollView addSubview:saveBtn];
    
    _completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_completeBtn setFrame:CGRectMake(15, textBgImage.bottom+50, kScreenWidth-30, 44)];
    UIImage *saveBtnAvailableImage = [[UIImage imageNamed:@"login_confirm_btn_available.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [_completeBtn setBackgroundImage:saveBtnAvailableImage forState:UIControlStateNormal];
    UIImage *saveBtnUnavailableImage = [[UIImage imageNamed:@"login_confirm_btn_unavailable.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [_completeBtn setBackgroundImage:saveBtnUnavailableImage forState:UIControlStateDisabled];
    [_completeBtn setBackgroundColor:[UIColor lightGrayColor]];
    [_completeBtn setTitle:@"保存" forState:UIControlStateNormal];
    [_completeBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
    [_completeBtn setEnabled:NO];
    [_completeBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_myScrollView addSubview:_completeBtn];
    
    [_myScrollView setContentSize:CGSizeMake(kScreenWidth, _completeBtn.bottom+50)];
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

- (void)bgTap:(UITapGestureRecognizer *)tap
{
    [_nickTextField resignFirstResponder];
}

- (void)avatarTap:(UITapGestureRecognizer *)tap
{    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    [sheet showInView:_myScrollView];
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

- (void)saveBtnClick:(UIButton *)btn
{
    NSLog(@"保存");
    
    [self requestDoRegisterAll];
}

#pragma mark - request

- (void)requestDoRegisterAll
{
    [self showProgressHUD:@"加载中..." toView:self.view];
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"register" forKey:@"mod"];
    [parametersDict setObject:@"do_register_all" forKey:@"func"];
    
    NSMutableDictionary *formDict = [NSMutableDictionary dictionary];
    [formDict setObject:self.phoneNumber forKey:@"mobile"];
    [formDict setObject:self.verificationCode forKey:@"mobile_code"];
    [formDict setObject:self.password forKey:@"password"];
    [formDict setObject:_nickTextField.text forKey:@"nick"];
    [formDict setObject:[NSString stringWithFormat:@"%ld", (long)_currentGenderIndex] forKey:@"sex"];
    [formDict setObject:[NSString stringWithFormat:@"%ld", (long)_emotionStatusIndex] forKey:@"marriage"];
//    [formDict setObject:@"" forKey:@"openid"];
//    [formDict setObject:@"" forKey:@"openid_type"];
//    [formDict setObject:@"" forKey:@"access_token"];
//    [formDict setObject:@"" forKey:@"f"];

    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:UUID forKey:@"reg_meid"];
    [postDict setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey] forKey:@"reg_version"]; 
    [postDict setObject:@"100" forKey:@"reg_channel_id"];
    [postDict setObject:@"ios" forKey:@"reg_mtype"];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    if (_avatarData) {
        [dataDict setObject:_avatarData forKey:@"upload"];
    }
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict dataDict:dataDict formDict:formDict success:^(id responseObject) {
        [self dismissProgressHUDtoView:self.view];
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            
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
            [[NSUserDefaults standardUserDefaults] setObject:self.phoneNumber forKey:@"phone"];
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isAutoLogin"];
            
            [SharedDefault setBool:YES forKey:kUDPushShakeOption];
            [SharedDefault setBool:YES forKey:kUDPushSoundOption];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotification object:nil];
//            -1 参数错误  mobile mobile_code password
//            -2 数据库事物异常
//            -3 手机号格式错误或者已经存在
//            -4 密码长度
//            -5 数据库插入数据异常
//            -7 手机验证码
//            -8 性别
//            -9 情感状态
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

    } failure:^(id error) {
        [self dismissProgressHUDtoView:self.view];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        
    }];
    
}
#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    offSet = _myScrollView.contentOffset.y;
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSString *content = textField.text;
    if (!content) {
        content = @"";
    }
    if (content.length>14) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"昵称最多14个字"];
        _nickTextField.text = [content substringToIndex:14];
    }
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)isAllSpace:(NSString *)string{
    int num = 0;
    for (int i = 0; i<string.length; i++) {
        NSString *subString = [string substringWithRange:NSMakeRange(i, 1)];
        if ([subString isEqualToString:@" "]) {
            num++;
        }
    }
    // 全是空格 返回no  不是返回yes
    return num != string.length;
}
#pragma mark - Notification

- (void)textFieldTextDidChange:(NSNotification *)notification
{
    
    BOOL isNickName = (_nickTextField.text.length!=0) && [self isAllSpace:_nickTextField.text];
    BOOL isEmotionStatues = ![_emotionStatusLab.text isEqualToString:@"请选择"];
    
    //规范 用户名和情感状态  保存按钮才能点
    if (isNickName && isEmotionStatues)
    {
        [_completeBtn setEnabled:YES];
    } else {
        [_completeBtn setEnabled:NO];
    }
}

- (void)keyboardWillChangeFrame:(NSNotification*)noti{
    
    NSDictionary *dic = noti.userInfo;
    //下面分别为键盘弹出通知的动画  时间  起始位置  结束位置   差值
    CGFloat duration = [[dic objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat beginY = [[dic objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].origin.y;
    CGFloat endY = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    CGFloat distance = beginY - endY;
    
    //当前scrollView的可视范围
    CGFloat visualHeight = kScreenHeight - kNavigationBarHeight - kStatusBarHeight;
    CGFloat textFieldHeightFromTop = _nickTextField.bottom - offSet;//当前文本框相对于可视范围最上方的高度
    CGFloat keyBoardHeight = distance > 0 ? distance : - distance;//键盘高度
    if (keyBoardHeight < 100) {
        return;
    }
    [UIView animateWithDuration:duration animations:^{
        if (visualHeight  < textFieldHeightFromTop + keyBoardHeight  && distance > 0) {
            //如果是键盘弹出 并且会遮住文本框
            [_myScrollView setContentOffset:CGPointMake(0, offSet + textFieldHeightFromTop + keyBoardHeight - visualHeight + 20)];
        }else{
            [_myScrollView setContentOffset:CGPointMake(0, offSet)];
        }
    }];

}
#pragma mark - JYPickEmotionStatusDelegate

- (void)pickEmotionStatusCompleteWithIndex:(NSNumber *)indexPath;
{
    
    _emotionStatusIndex = [indexPath integerValue] +1;
    
    NSString *key = [NSString stringWithFormat:@"%ld", (long)_emotionStatusIndex];
    [_emotionStatusLab setText:[[[NSDictionary alloc]initWithObjects:@[@"单身",@"恋爱中",@"已婚",@"保密"] forKeys:@[@"1",@"2",@"3",@"4"]] objectForKey:key]];
    
    BOOL isNickName = (_nickTextField.text.length!=0);
    BOOL isEmotionStatues = ![_emotionStatusLab.text isEqualToString:@"请选择"];
    //规范 用户名和情感状态  保存按钮才能点
    if (isNickName && isEmotionStatues)
    {
        [_completeBtn setEnabled:YES];
    } else {
        [_completeBtn setEnabled:NO];
    }
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
    _avatarData = UIImageJPEGRepresentation(image, 1.0);
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
