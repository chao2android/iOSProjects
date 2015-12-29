//
//  TJRegistViewController.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/4.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJRegistViewController.h"
#import "TJUserInfoEditViewController.h"
#import "TJRegistViewModel.h"


#define LABELCELL_Height (30)
#define LABELCELL_Y      (35)
#define LABELCELL_WidthH (80)
#define ThirdPartHeight 167.5
#define ThirdIconWH 66.5
#define TextFieldH 50
#define LineH 0.5

static NSString *registerTitle = @"手机注册";
static NSString *forgetPasswordTitle = @"重置密码";
static NSString *bindingTitle = @"绑定手机";

static NSString *registerAlter = @"通过输入短信内的验证码,完成手机注册,注册成功后,可用手机号和密码登陆";
static NSString *forgetAlter = @"请输入您的手机号,接收短信验证码,即可修改密码,确认成功后重置密码";
static NSString *bindAlter = @"通过输入短信内的验证码,完成手机绑定,绑定成功后,可用手机号和密码登陆";



@interface TJRegistViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITextField *phoneTextField;
    UITextField *codeTextField;
    UITextField *passTextField;
    UITextField *verifyTextField;
    
    UIButton    *btnCode;
    NSTimer *timer;
    
    
    
    
}

@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) TJRegistViewModel *viewModel;

@end

@implementation TJRegistViewController

-(instancetype)init:(PageType)verifyType
{
    if (self = [super init]) {
        _viewModel = [[TJRegistViewModel alloc] init];
        self.hidesBottomBarWhenPushed=YES;
        self.pageType=verifyType;
        self.view.userInteractionEnabled = YES;
    }
    return self;
}

- (void)requestData
{
    if (self.pageType == PageType_Register) {
        [_viewModel postPhoneRegisterUserInfo:phoneTextField.text andPassWord:passTextField.text andCode:codeTextField.text finish:^{
            
            [self.view makeToast:@"注册成功" duration:2.0 position:CSToastPositionCenter];
            TJUserInfoEditViewController *editInfo = [[TJUserInfoEditViewController alloc] init];
            [self.naviController pushViewController:editInfo animated:YES];
            
        } failed:^(NSString *error) {
            
            [self.view makeToast:error duration:2.0 position:CSToastPositionCenter];
        }];
        [self.view makeToast:@"注册成功" duration:2.0 position:CSToastPositionCenter];
        TJUserInfoEditViewController *editInfo = [[TJUserInfoEditViewController alloc] init];
        [self.naviController pushViewController:editInfo animated:YES];

        
    }
    else if (self.pageType == PageType_Forget)
    {
        [_viewModel postForgetPassWord:phoneTextField.text andPassWord:passTextField.text andRepassword:verifyTextField.text andCode:codeTextField.text finish:^{
            [self.view makeToast:@"注册成功" duration:2.0 position:CSToastPositionCenter];
        } failed:^(NSString *error) {
            [self.view makeToast:error duration:2.0 position:CSToastPositionCenter];
        }];
    }
    else if (self.pageType == PageType_Bind)
    {
        
    }
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
}

- (void)inistalNavBar
{
    switch (self.pageType) {
        case PageType_Register:
            [self.naviController setNaviBarTitle:registerTitle];
            break;
        case PageType_Forget:
            [self.naviController setNaviBarTitle:forgetPasswordTitle];
            break;
        case PageType_Bind:
            [self.naviController setNaviBarTitle:bindingTitle];
            break;
        default:
            break;
    }
    [self.naviController setNaviBarTitleStyle:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NAVTITLE_COLOR_KEY,[UIFont boldSystemFontOfSize:19.0],NAVTITLE_FONT_KEY,nil]];
    UIImage *leftImg = [UIImage imageNamed:@"appui_fanhui_"];
    UIButton *leftBtn = [TJBaseNaviBarView createNaviBarBtnByTitle:nil imgNormal:@"appui_fanhui_" imgHighlight:nil withFrame:CGRectMake(0, 0, leftImg.size.width/2,leftImg.size.height/2)];
    [[leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [self.naviController popViewControllerAnimated:YES];
        
    }];
    [self.naviController setNaviBarLeftBtn:leftBtn];
    
}

- (void)buildUI
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recoveryTableView)];
//    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsHorizontalScrollIndicator = YES;
    _tableView.scrollEnabled = NO;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 10);
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self inistalNavBar];
    self.naviController.navigationBarHidden = NO;
    [NOTIFICATION_CENTER addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark -- tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 0;
            break;
        case 1:
            return 4;
            break;
        case 2:
            return 0;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 0;
            break;
        case 1:
            return 70;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
            return 60;
            break;
            
        default:
            return 0;
            break;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    [view setBackgroundColor:[UIColor yellowColor]];
    UIImage *image = [UIImage imageNamed:@"sign_2_"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, image.size.width, image.size.height)];
    [imageView setImage:image];
    [view addSubview:imageView];
    
    UILabel *lblel = [[UILabel alloc] initWithFrame:CGRectMake( imageView.frame.size.width + imageView.frame.origin.x, 0, view.frame.size.width - imageView.frame.size.width - 10, image.size.height)];
    
    switch (self.pageType) {
        case PageType_Register:
            [lblel setText:registerAlter];
            break;
        case PageType_Forget:
            [lblel setText:forgetAlter];
            break;
        case PageType_Bind:
            [lblel setText:bindAlter];
            break;
            
        default:
            break;
    }
    [lblel setFont:[UIFont systemFontOfSize:14.0]];
    [lblel setTextColor:[UIColor blackColor]];
    lblel.numberOfLines = 2;
    [view addSubview:lblel];
    

    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 2:
            return SCREEN_HEIGHT - 70 *4 - 60;
            break;
        default:
            return 0;
            break;
    }
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 70 *4 - 60 - NAVIBAR_HEIGHT - STATUSBAR_HEIGHT)];
    view.backgroundColor = [UIColor clearColor];
    
    
    UIImage *image =[UIImage imageNamed:@"sign_10_"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setFrame:CGRectMake(20, view.frame.size.height *3/4, SCREEN_WIDTH - 40, 50)];
    
    NSString *str;
    switch (self.pageType) {
        case PageType_Register:
            str = @"注册";
            break;
        case PageType_Forget:
            str = @"确认";
            break;
        case PageType_Bind:
            str = @"绑定";
            break;
            
        default:
            break;
    }
    
    [button setTitle:str forState:UIControlStateNormal];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self requestData];
        
        
    }];
    
    [view addSubview:button];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strCell = @"strCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:strCell];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
              UIView *viewA  = [self setupTableViewCellSubView:CGRectMake(15, LABELCELL_Y, LABELCELL_WidthH, LABELCELL_Height) andTitle:@"手机号"];
                phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(viewA.frame.size.width + viewA.frame.origin.x + 5, viewA.frame.origin.y, cell.frame.size.width - viewA.frame.size.width - viewA.frame.origin.x, viewA.frame.size.height)];
                phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                phoneTextField.delegate = self;
                phoneTextField.borderStyle = UITextBorderStyleNone;
                phoneTextField.placeholder = @"11位手机号码";
                phoneTextField.keyboardType=UIKeyboardTypeNumberPad;
                phoneTextField.returnKeyType=UIReturnKeyNext;
                
                [cell addSubview:viewA];
                [cell addSubview:phoneTextField];
            }
                break;
            case 1:
            {
                UIView *viewB  = [self setupTableViewCellSubView:CGRectMake(15, LABELCELL_Y, LABELCELL_WidthH, LABELCELL_Height) andTitle:@"验证码"];
                [cell addSubview:viewB];
                
                codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(viewB.frame.size.width + viewB.frame.origin.x + 5, viewB.frame.origin.y, cell.frame.size.width - viewB.frame.size.width - viewB.frame.origin.x - 100, viewB.frame.size.height)];
                codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                codeTextField.delegate = self;
                codeTextField.borderStyle = UITextBorderStyleNone;
                codeTextField.placeholder = @"手机短信验证码";
                codeTextField.keyboardType=UIKeyboardTypeNumberPad;
                codeTextField.returnKeyType=UIReturnKeyNext;
                
                
                btnCode=[[UIButton alloc]initWithFrame:CGRectMake(codeTextField.frame.origin.x + codeTextField.frame.size.width +15, codeTextField.frame.origin.y, 120, 35)];
                btnCode.backgroundColor=COLOR(242, 244, 248, 1);
                [btnCode setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btnCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                btnCode.titleLabel.font=[UIFont systemFontOfSize:12];
                btnCode.layer.cornerRadius=5;
                @weakify(self)
                [[btnCode rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                    @strongify(self)
                    
                    [self->btnCode setTitle:@"60" forState:UIControlStateNormal];
                    self->codeTextField.enabled=NO;
                    if (self->timer)
                    {[self->timer invalidate];
                        self->timer=nil;
                    }
                    self->timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
                    self->btnCode.enabled=NO;
                    if (self->codeTextField) {
                        [self->codeTextField becomeFirstResponder];
                    }
                   
                }];
                
                [cell addSubview:codeTextField];
                [cell addSubview:btnCode];

                
            }
                
                break;
            case 2:
            {
                NSString *strType = nil;
                if (self.pageType == PageType_Forget) {
                    strType = @"设置新密码";
                }
                else{
                    strType = @"设置登陆密码";
                }
                
                UIView *viewC  = [self setupTableViewCellSubView:CGRectMake(15, LABELCELL_Y, LABELCELL_WidthH, LABELCELL_Height) andTitle:strType];
                [cell addSubview:viewC];
                
                passTextField = [[UITextField alloc] initWithFrame:CGRectMake(viewC.frame.size.width + viewC.frame.origin.x + 5, viewC.frame.origin.y, cell.frame.size.width - viewC.frame.size.width - viewC.frame.origin.x, viewC.frame.size.height)];
                passTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                passTextField.delegate = self;
                passTextField.borderStyle = UITextBorderStyleNone;
                passTextField.placeholder = @"6-32位密码";
                passTextField.keyboardType=UIKeyboardTypeASCIICapable;
                passTextField.returnKeyType=UIReturnKeyNext;
                
                [cell addSubview:passTextField];
                
            }
                
                break;
            case 3:
            {
                NSString *strType = nil;
                if (self.pageType == PageType_Forget) {
                    strType = @"确认新密码";
                }
                else{
                    strType = @"重复登陆密码";
                }
                
                UIView *viewD  = [self setupTableViewCellSubView:CGRectMake(15, LABELCELL_Y, LABELCELL_WidthH, LABELCELL_Height) andTitle:strType];
                [cell addSubview:viewD];
                
                verifyTextField = [[UITextField alloc] initWithFrame:CGRectMake(viewD.frame.size.width + viewD.frame.origin.x + 5, viewD.frame.origin.y, cell.frame.size.width - viewD.frame.size.width - viewD.frame.origin.x, viewD.frame.size.height)];
                verifyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                verifyTextField.delegate = self;
                verifyTextField.borderStyle = UITextBorderStyleNone;
                verifyTextField.placeholder = @"密码确认";
                verifyTextField.keyboardType=UIKeyboardTypeASCIICapable;
                verifyTextField.returnKeyType=UIReturnKeyNext;
                
                [cell addSubview:verifyTextField];
                
            }
                
                break;
            default:
                break;
        }
    }
    else if(indexPath.section == 0)
    {
       
    }
    
    
    
    return cell;
    
}

- (UIView *)setupTableViewCellSubView:(CGRect)frame andTitle:(NSString *)title
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] init];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setText:title];

    [label  setFont:[UIFont systemFontOfSize:20]];
    [label setTextColor:[UIColor redColor]];
    CGSize size =  [UIUtil textToSize:title fontSize:20];
    [label setFrame:CGRectMake(0, 0, size.width, frame.size.height)];
    [view addSubview:label];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(label.frame.size.width + 20,0,1, label.frame.size.height)];
    [line setBackgroundColor:[UIColor redColor]];
    [view addSubview:line];
    
    view.frame = CGRectMake(frame.origin.x, frame.origin.y, label.frame.size.width + 21, frame.size.height);
    
    return view;
    
}
-(void)countDown
{
    NSString *seconds=[NSString stringWithFormat:@"%d",[btnCode.titleLabel.text intValue]-1];
    [btnCode setTitle:seconds forState:UIControlStateNormal];
//    countDownLabel.text=seconds;
    if ([seconds intValue]==-1)
    {
        
        if (self->timer)
        {[self->timer invalidate];
            self->timer=nil;
        }
        btnCode.enabled=YES;
        [btnCode setTitle:@"发送验证码" forState:UIControlStateNormal];

        phoneTextField.enabled=YES;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

-(void)recoveryTableView
{
    [self.view endEditing:YES];
    TLog(@"%f",_tableView.contentOffset.y);
//    if (_tableView.contentOffset.y != 0) {
         [_tableView setContentOffset:CGPointMake(0,-64) animated:YES];
//    }
}
#pragma mark keyboard notification
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGFloat keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    float disY=keyboardHeight-SCREEN_HEIGHT+ThirdPartHeight+(TextFieldH+LineH+LineH/2)*3+NAVIBAR_HEIGHT+STATUSBAR_HEIGHT;

    if (disY>0) {
        [_tableView setContentOffset:CGPointMake(0.0, disY) animated:YES];
    }
}

- (void)dealloc{
    TLog(@"dealloc");
}

@end
