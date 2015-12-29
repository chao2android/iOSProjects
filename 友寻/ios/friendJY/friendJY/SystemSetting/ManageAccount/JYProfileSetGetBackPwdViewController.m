
//
//  JYProfileSetGetBackPwdViewController.m
//  friendJY
//
//  Created by coder_zhang on 15/4/1.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYProfileSetGetBackPwdViewController.h"
//#import "JYModifyPwdController.h"
#import "JYHttpServeice.h"
#import "JYAppDelegate.h"
#define kSettingGetCheckCodeBtnWidth 120.0f

@interface JYProfileSetGetBackPwdViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *checkCode;
@property (nonatomic, assign) NSInteger seconds;
//发送验证码按钮
@property (nonatomic, strong) UIButton *getCheckCodeBtn;
//验证码发送成功显示
@property (nonatomic, strong) UILabel *didSendCodeLab;
//验证码输入错误
@property (nonatomic, strong) UILabel *wrongCodeLab;

@property (nonatomic, strong) UITextField *password;
@property (nonatomic, strong) UITextField *confirmPassword;

@end

@implementation JYProfileSetGetBackPwdViewController

- (NSArray *)cellTitleArr{
    if (_cellTitleArr == nil) {
        _cellTitleArr = @[@[@"手机验证码"],@[@"输入新密码",@"再次输入新密码"]];
    }
    return _cellTitleArr;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_checkCode becomeFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";
    _seconds = kReacquireCodeWaitSecond;
    //下一步按钮
    UIBarButtonItem *nextBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(nextStepAction)];
    self.navigationItem.rightBarButtonItem = nextBtn;
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)]];
    // Do any additional setup after loading the view.
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self initCell:cell withIndexPath:indexPath];
    return cell;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSettingFirstHeaderViewHeight)];
        [view setBackgroundColor:kSettingDefaultBgColor];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kSettingFirstHeaderViewHeight-1, kScreenWidth, 1)];
        [lineView.layer setBorderColor:[[JYHelpers setFontColorWithString:@"#cccccc"] CGColor]];
        [lineView.layer setBorderWidth:1];
        [view addSubview:lineView];
        return view;

    }else{
        UIView *footerView = [[UIView alloc] init];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, -1, kScreenWidth, 1)];
        line.layer.borderColor = [[JYHelpers setFontColorWithString:@"#cccccc"] CGColor];
        line.layer.borderWidth = 1;
        [footerView addSubview:line];
        
        _didSendCodeLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, kScreenWidth - 30, 30)];
        NSMutableString *phoneNum = [NSMutableString stringWithString:self.phoneNum];
        NSRange range;
        range.location = 3;
        range.length = 4;
        [phoneNum replaceCharactersInRange:range withString:@"****"];
        _didSendCodeLab.text = [NSString stringWithFormat:@"我们已经向您登录的手机号 %@ 发送了验证码",phoneNum];
        [_didSendCodeLab setNumberOfLines:2];
        [_didSendCodeLab adjustsFontSizeToFitWidth];
        _didSendCodeLab.font = [UIFont systemFontOfSize:12.0f];
        _didSendCodeLab.textColor = [UIColor darkGrayColor];
        _didSendCodeLab.alpha = 0;
        [footerView addSubview:_didSendCodeLab];
        
        _wrongCodeLab = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_didSendCodeLab.frame), 120, 15)];
        [_wrongCodeLab setText:@"验证码输入错误"];
        _wrongCodeLab.font = [UIFont systemFontOfSize:12.0f];
        _wrongCodeLab.textColor = [UIColor redColor];
        _wrongCodeLab.alpha = 0;
        [footerView addSubview:_wrongCodeLab];
        [footerView setFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        
        UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 59, kScreenWidth, 1)];
        lineview.layer.borderColor = [[JYHelpers setFontColorWithString:@"#cccccc"] CGColor];
        lineview.layer.borderWidth = 1;
        [footerView addSubview:lineview];
        return footerView;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return kSettingFirstHeaderViewHeight;
    }else{
        return 60;
    }
}
//初始化cell.contentView子视图
- (void)initCell:(UITableViewCell*)cell withIndexPath:(NSIndexPath*)indexPath{
    
    NSString *text = self.cellTitleArr[indexPath.section][indexPath.row];
    //动态获取label的宽度
    CGFloat widthlabel = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, widthlabel, 20)];
    label.text = self.cellTitleArr[indexPath.section][indexPath.row];
    //    label.backgroundColor = [UIColor orangeColor];
    label.font = [UIFont systemFontOfSize:15];
    [cell.contentView addSubview:label];
    
    if (indexPath.section == 0) {
        
        _checkCode = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + 10.0f, 15, kScreenWidth - kSettingGetCheckCodeBtnWidth - CGRectGetMaxX(label.frame) - 20.0f, 15)];
        _checkCode.placeholder = @"请输入验证码";
        _checkCode.delegate = self;
        [_checkCode setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
        _checkCode.keyboardType = UIKeyboardTypeNumberPad;
        //    checkCode.backgroundColor = [UIColor orangeColor];
        [cell.contentView addSubview:_checkCode];
        
        _getCheckCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _getCheckCodeBtn.frame = CGRectMake(CGRectGetMaxX(_checkCode.frame)+10, 0, kSettingGetCheckCodeBtnWidth, cell.bounds.size.height);
        [_getCheckCodeBtn setBackgroundImage:[UIImage imageNamed:@"check_nomal"] forState:UIControlStateNormal];
        [_getCheckCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _getCheckCodeBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [_getCheckCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_getCheckCodeBtn addTarget:self action:@selector(getCheckCode:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:_getCheckCodeBtn];
        
    }else{
        
        NSString *str = @"再次输入新密码";
        CGFloat width = [str sizeWithFont:[UIFont systemFontOfSize:15]].width;

        if (indexPath.row == 0) {
            _password = [[UITextField alloc] initWithFrame:CGRectMake(15 + width + 10, 12, kScreenWidth - 15 - width - 60, 20)];
            //        textField.keyboardType = UIKeyboardTypeNumberPad;
            _password.secureTextEntry = YES;
            _password.clearButtonMode = UITextFieldViewModeWhileEditing;
            [_password setBackgroundColor:[UIColor whiteColor]];
            [_password setFont:[UIFont systemFontOfSize:15]];
            [_password setPlaceholder:@"请输入6~20位密码"];
            
            [_password setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
            
            _password.clearsOnBeginEditing = YES;
            [_password setDelegate:self];
            [cell.contentView addSubview:_password];
            
        }else{
             _confirmPassword = [[UITextField alloc] initWithFrame:CGRectMake(15 + width + 10, 12, kScreenWidth - 15 - width - 60, 20)];
            //        textField.keyboardType = UIKeyboardTypeNumberPad;
            //        [textField setKeyboardType:UIKeyboardTypeDefault];
            _confirmPassword.secureTextEntry = YES;
            _confirmPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
            [_confirmPassword setBackgroundColor:[UIColor whiteColor]];
            [_confirmPassword setFont:[UIFont systemFontOfSize:15]];
            
            
            [_confirmPassword setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
            
            _confirmPassword.clearsOnBeginEditing = YES;
            [_confirmPassword setDelegate:self];
            //将textField添加到pwdTextFieldArr数组中方便管理
            [cell.contentView addSubview:_confirmPassword];
            [_confirmPassword setPlaceholder:@"与新密码一致"];
        }
    
    }

}


//- (void)initFooterView{
//
//    
//    
//    
//    _tableView.tableFooterView = footerView;
//    
//}
- (void)getCheckCode:(UIButton*)sender{
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"login" forKey:@"mod"];
    [parametersDict setObject:@"find_password_get_checkcode" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:self.phoneNum forKey:@"mobile"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            
            NSLog(@"成功");
            [[JYAppDelegate sharedAppDelegate] showTip:kVerificationCodeSentSuccess];
            [_getCheckCodeBtn setEnabled:NO];
            [_getCheckCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
            [_getCheckCodeBtn setBackgroundImage:[UIImage imageNamed:@"check_selected"] forState:UIControlStateNormal];
            [_didSendCodeLab setAlpha:1.0f];
            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
            //显示已发送提示以及启动定时器
            
//            _sysCheckCode = [NSString stringWithFormat:@"%ld",(long)[[responseObject objectForKey:@"data"] integerValue]];
            
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
//隐藏键盘
- (void)keyboardHide{
    NSLog(@"隐藏键盘");
    [_checkCode resignFirstResponder];
}
//开始输入验证码的时候让验证码输入错误提示消失
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self.wrongCodeLab setAlpha:0.0f];
    return YES;
}

//点击下一步调用的方法
- (void)nextStepAction{
    
    if (_checkCode.text.length < 6) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"请输入正确的验证码"];
        return;
    }
    if (_password.text.length < 6) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"请输入有效的密码"];
        return;
    }
    if (![_password.text isEqualToString:_confirmPassword.text]) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"两次密码输入不一致"];
        return;
    }
    [self setNewPassword];
    
}
//定时器每一秒调用的方法
- (void)timerFireMethod:(NSTimer *)timer
{
    if (_seconds == 1) {//定时结束
        [timer invalidate];
        _seconds = kReacquireCodeWaitSecond;
        [_getCheckCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        [_getCheckCodeBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_getCheckCodeBtn setBackgroundImage:[UIImage imageNamed:@"check_nomal"] forState:UIControlStateNormal];
        [_getCheckCodeBtn setEnabled:YES];
    } else {
        _seconds--;
        NSString *title = [NSString stringWithFormat:@"%ld秒后可重新发送",(long)_seconds];
        [_getCheckCodeBtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
//        [_waitLab sizeToFit];
        [_getCheckCodeBtn setTitle:title forState:UIControlStateDisabled];
    }
}

- (void)setNewPassword{
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"login" forKey:@"mod"];
    [parametersDict setObject:@"set_new_password" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:self.phoneNum forKey:@"mobile"];
    [postDict setObject:_checkCode.text forKey:@"code"];
    [postDict setObject:_password.text forKey:@"new"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        
        if (iRetcode == 1) {
            
            //密码修改成功
            [self.navigationController popViewControllerAnimated:YES];
            [[JYAppDelegate sharedAppDelegate] showTip:@"密码修改成功"];
            
        }else if (iRetcode == -3){
            [[JYAppDelegate sharedAppDelegate] showTip:@"验证码输入错误"];
        }else if (iRetcode == -2){
            [[JYAppDelegate sharedAppDelegate] showTip:@"手机号尚未注册"];
        }else {
            //密码修改失败
            [[JYAppDelegate sharedAppDelegate] showTip:@"密码修改失败"];
            
        }
        
    } failure:^(id error) {
        
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];

}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField isEqual:_checkCode]) {
        if (textField.text.length == 6 && ![string isEqualToString:@""]) {
            return NO;
        }
    }else{
        if (textField.text.length == 20 && ![string isEqualToString:@""]) {
            return NO;
        }
    }
    
    return YES;
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
