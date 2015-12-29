//
//  JYModifyPhoneNumController.m
//  friendJY
//
//  Created by coder_zhang on 15/4/1.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYModifyPhoneNumController.h"
#import "JYAppDelegate.h"

@interface JYModifyPhoneNumController ()<UITextFieldDelegate>
{
    BOOL canChangeNum;
}
@property (nonatomic, strong) UILabel *didSendCodeLab;

@property (nonatomic, copy) NSString *sysCheckCode;

@property (nonatomic, strong) UILabel *wrongCodeLab;

@property (nonatomic, strong) NSMutableArray *txFArr;

@property (nonatomic, strong) UIButton *getCodeBtn;

@property (nonatomic, assign) NSInteger seconds;

@end

@implementation JYModifyPhoneNumController
- (NSArray *)cellTitleArr{
    if (_cellTitleArr == nil) {
        _cellTitleArr = @[@[@"当前手机号",@"输入新号码",@"手机验证码"]];
    }
    return _cellTitleArr;
}
- (NSMutableArray *)txFArr{
    if (_txFArr == nil) {
        _txFArr = [NSMutableArray array];
    }
    return _txFArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _seconds = kReacquireCodeWaitSecond;
    [_tableView setRowHeight:44];
    canChangeNum = NO;
    [self setTitle:@"修改登录手机号"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(numChangeDone)];
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [(UITextField*)_txFArr[0] becomeFirstResponder];

}
- (void)initFooterView{

    UIView *footerView = [[UIView alloc] init];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, -1, kScreenWidth, 1)];
    line.layer.borderColor = [[JYHelpers setFontColorWithString:@"#cccccc"] CGColor];
    line.layer.borderWidth = 1;
    [footerView addSubview:line];
    
    _didSendCodeLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, kScreenWidth - 30, 30)];
//    NSMutableString *phoneNum = [NSMutableString stringWithString:self.phoneNum];
//    NSRange range;
//    range.location = 3;
//    range.length = 4;
//    [phoneNum replaceCharactersInRange:range withString:@"****"];
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
    
    //    _waitLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - kSettingGetCheckCodeBtnWidth, 10, kSettingGetCheckCodeBtnWidth, 40)];
    //    [_waitLab setAlpha:0.0f];
    //    [_waitLab setTextAlignment:NSTextAlignmentCenter];
    //    [_waitLab setBackgroundColor:kBorderColorGray];
    //    [_waitLab setNumberOfLines:2];
    //    [_waitLab setFont:[UIFont systemFontOfSize:10.0f]];
    //    [footerView addSubview:_waitLab];
    
    _tableView.tableFooterView = footerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    cell.textLabel.text = self.cellTitleArr[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.textLabel.textColor = kTextColorBlack;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selected = NO;
    
    CGFloat width = [cell.textLabel.text sizeWithFont:[UIFont systemFontOfSize:15.0f]].width;
    UITextField *txf = [[UITextField alloc] init];
    [txf setDelegate:self];
    txf.keyboardType = UIKeyboardTypeNumberPad;
    if (indexPath.row == 2) {
        [txf setFrame:CGRectMake(15 + width + 20, 12, kScreenWidth - 35 - width - 120, 20)];
        [txf setFont:[UIFont systemFontOfSize:15]];
        _getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _getCodeBtn.frame = CGRectMake(kScreenWidth - 120, 0, 120, 44);
        _getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        //        [_getCodeBtn setBackgroundColor:[UIColor redColor]];
        [_getCodeBtn setBackgroundImage:[UIImage imageNamed:@"check_nomal"] forState:UIControlStateNormal];
        [_getCodeBtn addTarget:self action:@selector(getCheckCode) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:_getCodeBtn];
    }else{
        [txf setFrame:CGRectMake(15 + width + 20, 14, kScreenWidth - 35 - width - 15, 20)];
        if (indexPath.row == 0) {
            [txf setPlaceholder:@"请输入原手机号"];
        }else{
            [txf setPlaceholder:@"请输入新手机号"];
        }
        [txf setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];

//        [txf setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
        
    }
//    if (indexPath.row == 0) {
//        if (self.phoneNum) {
//            [txf setText:self.phoneNum];
//        }
//        [txf setEnabled:NO];
//    }
    [self.txFArr addObject:txf];
    [cell addSubview:txf];
    
    return cell;
}

- (void)getCheckCode{
    UITextField *txfOld = (UITextField*)[self.txFArr objectAtIndex:0];
    if (![txfOld.text isEqualToString:self.phoneNum]) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"请输入正确的原号码"];
        return;
    }
    UITextField *txf = (UITextField*)[self.txFArr objectAtIndex:1];
    if (txf.text.length < 11 || ![JYHelpers isPhoneNumber:txf.text]) {
        [_wrongCodeLab setText:@"请输入正确的新号码"];
        [_wrongCodeLab setAlpha:1];
//        [[JYAppDelegate sharedAppDelegate] showTip:@"请输入正确的手机号码"];
        return;
    }
    
    [self requestMobileExists];

}

- (void)numChangeDone{
//http://client.friendly.dev/cmiajax/?mod=login&func=update_user_mobile&mobile=188XXX&code=188XXX&old_mobile=188XXX
    
    if (!canChangeNum) {
        [_wrongCodeLab setText:@"请先获取验证码"];
        [_wrongCodeLab setAlpha:1];
        return;
    }
    
    UITextField *txf = (UITextField*)[self.txFArr objectAtIndex:1];
    if (txf.text.length < 11 || ![JYHelpers isPhoneNumber:txf.text]) {
        [_wrongCodeLab setText:@"请输入正确的手机号码"];
        [_wrongCodeLab setAlpha:1];
//        [[JYAppDelegate sharedAppDelegate] showTip:@"请输入正确的手机号码"];
        return;
    }
    UITextField *txfCheck = (UITextField*)[self.txFArr objectAtIndex:2];
    if (txfCheck.text.length < 6) {
        [_wrongCodeLab setText:@"请输入正确的验证码"];
        [_wrongCodeLab setAlpha:1];
        return;
    }
    [self requestPostNewPhoneNum];
//    UITextField *txf = (UITextField*)[self.txFArr objectAtIndex:1];
    
        //检查手机号
}
//判断手机是否存在
- (void)requestMobileExists
{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"register" forKey:@"mod"];
    [parametersDict setObject:@"mobile_exists" forKey:@"func"];
    
    UITextField *txf = (UITextField*)[self.txFArr objectAtIndex:1];
    NSMutableDictionary *formDict = [NSMutableDictionary dictionary];
    [formDict setObject:txf.text forKey:@"mobile"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict formDict:formDict success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        
        if (iRetcode == 1) {
            
            //更改手机号
            [self requestGetCheckCode];

        } else if (iRetcode == -1) {
            
            //手机号已经注册
            NSLog(@"%@", [responseObject objectForKey:@"retmean"]);
            [[JYAppDelegate sharedAppDelegate] showTip:@"该手机号已经注册"];
            
        } else if (iRetcode == -2) {
//            retcode = "-2";
//            retmean = "no register with this mobile";
            //手机号不合法
            NSLog(@"%@", [responseObject objectForKey:@"retmean"]);
            [self requestGetCheckCode];
//            [[JYAppDelegate sharedAppDelegate] showTip:kPleaseEnterValidPhoneNumber];
        } else {
            [self requestGetCheckCode];
        }
        
    } failure:^(id error) {
        
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        
    }];
    
}

- (void)requestGetCheckCode{
//    public array() find_mobile_get_checkcode(string mobile)

    UITextField *txf = (UITextField*)[self.txFArr objectAtIndex:1];
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"login" forKey:@"mod"];
    [parametersDict setObject:@"find_mobile_get_checkcode" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:txf.text forKey:@"mobile"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            
            NSLog(@"成功");
            _didSendCodeLab.text = [NSString stringWithFormat:@"我们已经向您登录的手机号 %@ 发送了验证码",txf.text];
            [_didSendCodeLab setAlpha:1.0f];
            //            [[JYAppDelegate sharedAppDelegate] showTip:kVerificationCodeSentSuccess];
            [_getCodeBtn setEnabled:NO];
            [_getCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
            [_getCodeBtn setBackgroundImage:[UIImage imageNamed:@"check_selected"] forState:UIControlStateNormal];
            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
            //显示已发送提示以及启动定时器
            canChangeNum = YES;
            //_sysCheckCode = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@""]];
            
        } else if (iRetcode == -1) {
            
            //手机号已经注册
            NSLog(@"%@", [responseObject objectForKey:@"retmean"]);
            [[JYAppDelegate sharedAppDelegate] showTip:kPhoneNumberAlreadyRegisterPleaseLogin];
            
        } else if (iRetcode == -2) {
            
            //手机号不合法
            NSLog(@"%@", [responseObject objectForKey:@"retmean"]);
            [[JYAppDelegate sharedAppDelegate] showTip:kPleaseEnterValidPhoneNumber];
            
        } else {
            [[JYAppDelegate sharedAppDelegate] showTip:@"验证码获取失败"];
        }
        
    } failure:^(id error) {
        
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        
    }];

}
//修改手机号
- (void)requestPostNewPhoneNum{
    
    NSDictionary *paraDic = @{@"mod":@"login",@"func":@"update_user_mobile"};
    NSDictionary *postDic = @{@"mobile":((UITextField*)self.txFArr[1]).text,@"old_mobile":self.phoneNum,@"code":((UITextField*)self.txFArr[2]).text};
//    __weak __typeof(self) weakSelf = self;
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            [[JYAppDelegate sharedAppDelegate] showTip:@"修改成功"];
            [SharedDefault setObject:((UITextField*)self.txFArr[1]).text forKey:@"phone"];
            [SharedDefault synchronize];
//            __strong typeof(self) weakself;
            if (self.finishBlock) {
                self.finishBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [[JYAppDelegate sharedAppDelegate] showTip:@"手机号修改失败：验证码不存在或已过期"];
        }
    } failure:^(id error) {
//        [self dismissProgressHUDtoView:self.view];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];
   


}
//定时器每一秒调用的方法
- (void)timerFireMethod:(NSTimer *)timer
{
    if (_seconds == 1) {//定时结束
        [timer invalidate];
        _seconds = kReacquireCodeWaitSecond;
        [_getCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        [_getCodeBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_getCodeBtn setBackgroundImage:[UIImage imageNamed:@"check_nomal"] forState:UIControlStateNormal];
        [_getCodeBtn setEnabled:YES];
    } else {
        _seconds--;
        NSString *title = [NSString stringWithFormat:@"%ld秒后可重新发送",(long)_seconds];
        [_getCodeBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        //        [_waitLab sizeToFit];
        [_getCodeBtn setTitle:title forState:UIControlStateDisabled];
    }
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (_wrongCodeLab.alpha == 1) {
        [_wrongCodeLab setAlpha:0];
    }
    if ([[_txFArr objectAtIndex:2] isEqual:textField] && textField.text.length == 6 && ![string isEqualToString:@""]) {
//       [JYAppDelegate sharedAppDelegate] showTip:@"手机号码"
        return NO;
    }else if (![[_txFArr objectAtIndex:2] isEqual:textField] && textField.text.length == 11 && ![string isEqualToString:@""]) {
        //       [JYAppDelegate sharedAppDelegate] showTip:@"手机号码"
        return NO;
    }

    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [_wrongCodeLab setAlpha:0];
}
//- (void)timerFireMethod
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
