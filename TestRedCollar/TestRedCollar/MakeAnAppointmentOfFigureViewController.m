//
//  MakeAnAppointmentOfFigureViewController.m
//  TestRedCollar
//
//  Created by MC on 14-7-29.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "MakeAnAppointmentOfFigureViewController.h"
#import "CheckListViewController.h"
#import "AreaListViewController.h"
#import "CityListViewController.h"
#import "AutoAlertView.h"
#import "DatePickerViewController.h"
@interface MakeAnAppointmentOfFigureViewController ()
{
    UIScrollView *_scrollView;
    UILabel *_nameDesLabel;
    UITextField *_nameField;
    UILabel *_numberDesLabel;
    UITextField *_numberField;
    UILabel *_addressDesLabel;
    UITextField *_addressField;
    
    UILabel *_serviceAddressDesLabel;
    UILabel *_timeDesLabel;
    UIView *_mBackView;
    UIButton *_keyboardCancleBut;
    UILabel *_areaDesLabel;
    
    NSString *_areaName;
    NSString *_areaId;
    NSString *_cityName;
    NSString *_cityId;
}
@end

@implementation MakeAnAppointmentOfFigureViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self RegisterForKeyboardNotifications];
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"预约量体";
    if (!self.is_free) {
        self.title = @"预约上门量体";
    }
    self.view.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, _scrollView.frame.size.height+1);
    [self.view addSubview:_scrollView];
    
    _keyboardCancleBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _keyboardCancleBut.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.contentSize.height);
    [_keyboardCancleBut addTarget:self action:@selector(OnCancelClick) forControlEvents:UIControlEventTouchUpInside];
    
    _mBackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-35, self.view.frame.size.width, 35)];
    _mBackView.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    //_mBackView.backgroundColor = [UIColor yellowColor];
    _mBackView.userInteractionEnabled = YES;
    _mBackView.hidden = YES;
    [self.view addSubview:_mBackView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(10, 2, 40, 30);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:WORDGRAYCOLOR forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(OnCancelClick) forControlEvents:UIControlEventTouchUpInside];
    [_mBackView addSubview:cancelBtn];
    
    UILabel *tiLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 25)];
    tiLabel.center = CGPointMake(self.view.bounds.size.width/2,15);
    tiLabel.text = @"请输入";
    tiLabel.textAlignment = 1;
    tiLabel.font = [UIFont systemFontOfSize:16];
    tiLabel.textColor = [UIColor darkGrayColor];
    [_mBackView addSubview:tiLabel];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(self.view.frame.size.width-50, 2, 40, 30);
    [sendBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sendBtn setTitleColor:WORDGRAYCOLOR forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(OnSendClick) forControlEvents:UIControlEventTouchUpInside];
    [_mBackView addSubview:sendBtn];
    
    UIImageView *bg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, self.view.bounds.size.width-20, _scrollView.frame.size.height-30)];
    bg.backgroundColor = [UIColor whiteColor];
    bg.userInteractionEnabled = YES;
    [_scrollView addSubview:bg];
    
    if (!self.is_free) {
        UILabel *noticLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, bg.bounds.size.width-20, 20)];
        noticLabel.text = @"上门量体需收取80元服务费";
        noticLabel.textColor = WORDREDCOLOR;
        noticLabel.textAlignment = 1;
        [bg addSubview:noticLabel];
    }
    for (int i =0 ; i<6; i++) {
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 45+45*(i+1), self.view.frame.size.width-20, 0.5)];
        line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [bg addSubview:line];
    }
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15+45, 70, 20)];
    nameLabel.text = @"上门量体";
    nameLabel.textColor = [UIColor darkGrayColor];
    nameLabel.font = [UIFont systemFontOfSize:16];
    if (self.is_free) {
        nameLabel.hidden = YES;
    }
    [bg addSubview:nameLabel];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15+45+45, 75, 20)];
    nameLabel.text = @"真实姓名：";
    nameLabel.textColor = WORDGRAYCOLOR;
    nameLabel.font = [UIFont systemFontOfSize:15];
    [bg addSubview:nameLabel];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15+45*3, 75, 20)];
    nameLabel.text = @"手机号码：";
    nameLabel.textColor = WORDGRAYCOLOR;
    nameLabel.font = [UIFont systemFontOfSize:15];
    [bg addSubview:nameLabel];
    
    int iHight = 15+45*4;
    //if (!self.is_free) {
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15+45*4, 75, 20)];
        nameLabel.text = @"详细地址：";
        nameLabel.textColor = WORDGRAYCOLOR;
        nameLabel.font = [UIFont systemFontOfSize:15];
        [bg addSubview:nameLabel];
        
        _addressDesLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 15+45*4, 200, 20)];
        _addressDesLabel.text = @"请输入详细地址";
        _addressDesLabel.font = [UIFont systemFontOfSize:14];
        _addressDesLabel.textColor = WORDGRAYCOLOR;
        [bg addSubview:_addressDesLabel];
        
        _addressField= [[UITextField alloc]initWithFrame:CGRectMake(85, 15+45*4, 200, 20)];
        _addressField.delegate = self;
        _addressField.font = [UIFont systemFontOfSize:15];
        _addressField.textColor = WORDGRAYCOLOR;
        _addressField.tag = 3;
        //_numberField.backgroundColor = [UIColor redColor];
        [bg addSubview:_addressField];
        iHight+=45;
    
    
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, iHight, 75, 20)];
    nameLabel.text = @"预约时间：";
    nameLabel.textColor = WORDGRAYCOLOR;
    nameLabel.font = [UIFont systemFontOfSize:15];
    [bg addSubview:nameLabel];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, iHight+45, 75, 20)];
    nameLabel.text = @"服务地区：";
    nameLabel.textColor = WORDGRAYCOLOR;
    nameLabel.font = [UIFont systemFontOfSize:15];
    [bg addSubview:nameLabel];
    
    _nameDesLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 15+45*2, 200, 20)];
    _nameDesLabel.text = @"请输入真实姓名";
    _nameDesLabel.font = [UIFont systemFontOfSize:14];
    _nameDesLabel.textColor = WORDGRAYCOLOR;
    [bg addSubview:_nameDesLabel];
    
    _nameField = [[UITextField alloc]initWithFrame:CGRectMake(85, 15+45*2, 200, 20)];
    _nameField.delegate = self;
    _nameField.font = [UIFont systemFontOfSize:15];
    _nameField.textColor = WORDGRAYCOLOR;
    _nameField.tag = 0;
    //_nameField.backgroundColor = [UIColor redColor];
    [bg addSubview:_nameField];
    
    _numberDesLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 15+45*3, 200, 20)];
    _numberDesLabel.text = @"请输入真实手机号码";
    _numberDesLabel.font = [UIFont systemFontOfSize:15];
    _numberDesLabel.textColor = WORDGRAYCOLOR;
    [bg addSubview:_numberDesLabel];
    
    _numberField = [[UITextField alloc]initWithFrame:CGRectMake(85, 15+45*3, 200, 20)];
    _numberField.delegate = self;
    _numberField.font = [UIFont systemFontOfSize:15];
    _numberField.textColor = WORDGRAYCOLOR;
    _numberField.tag = 1;
    //_numberField.backgroundColor = [UIColor redColor];
    [bg addSubview:_numberField];
    
    
    
    _timeDesLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, iHight, 200, 20)];
    _timeDesLabel.text = @"请选择预约时间";
    _timeDesLabel.font = [UIFont systemFontOfSize:14];
    _timeDesLabel.textColor = WORDGRAYCOLOR;
    _timeDesLabel.userInteractionEnabled = YES;
    [bg addSubview:_timeDesLabel];
    UITapGestureRecognizer *timeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(timeTapClick)];
    [_timeDesLabel addGestureRecognizer:timeTap];
    
    _areaDesLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, iHight+45, 200, 20)];
    _areaDesLabel.text = @"请选择地区";
    _areaDesLabel.font = [UIFont systemFontOfSize:14];
    _areaDesLabel.textColor = WORDGRAYCOLOR;
    _areaDesLabel.userInteractionEnabled = YES;
    [bg addSubview:_areaDesLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapClick)];
    [_areaDesLabel addGestureRecognizer:tap];
    
    UIButton *OKBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    OKBtn.frame = CGRectMake(5, iHight+45*2, 290, 44);
    [OKBtn setBackgroundImage:[UIImage imageNamed:@"OK_btn.png"] forState:UIControlStateNormal];
    [OKBtn addTarget:self action:@selector(OKBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:OKBtn];
    
}
- (void)timeTapClick{
    DatePickerViewController *dvc = [[DatePickerViewController alloc]init];
    dvc.block = ^(NSString *date){
        _timeDesLabel.text = date;
    };
    [self.navigationController pushViewController:dvc animated:YES];
}
- (void)TapClick{
    CityListViewController *cvc = [[CityListViewController alloc]init];
    cvc.index = 1;
    cvc.block = ^(NSString *name,NSString *uid){
        _cityName = name;
        _cityId = uid;
        _areaDesLabel.text = [NSString stringWithFormat:@"中国%@%@",_areaName,_cityName];
    };
    
    AreaListViewController *avc = [[AreaListViewController alloc]init];
    avc.CityListViewController = cvc;
    avc.state = @"2";
    avc.index = 1;
    avc.block = ^(NSString *name,NSString *uid){
        _areaName = name;
        _areaId = uid;
        NSLog(@"_areaName--->%@",_areaName);
    };
    [self.navigationController pushViewController:avc animated:YES];
    
}
- (void)OKBtnClick{
    
    //NSString *address,NSString *mobile ,NSString * realname,NSString * region_id,NSString * region_name,NSString * retime
    if (_addressField.text && _numberField.text && _nameField.text && _areaId && _cityId && _cityName && _areaName && _timeDesLabel.text) {
        NSString *idStr = [NSString stringWithFormat:@"2,%@,%@",_areaId,_cityId];
        NSString *nameStr = [NSString stringWithFormat:@"中国,%@,%@",_areaName,_cityName];
        
        self.block(_addressField.text,_numberField.text,_nameField.text,idStr,nameStr,_timeDesLabel.text);
        
        
        NSArray *arr = self.navigationController.viewControllers;
        for (int i=0; i<arr.count; i++) {
            UIViewController *Controller = arr[i];
            if (Controller && [Controller isKindOfClass:[CheckListViewController class]]) {
                [self.navigationController popToViewController:Controller animated:YES];
                return;
            }
        }
    }
    else{
        [AutoAlertView ShowMessage:@"请输入完整信息"];
    }
}
- (void)ResignFirstResponder{
    [_addressField resignFirstResponder];
    //[_serviceField resignFirstResponder];
    [_nameField resignFirstResponder];
    [_numberField resignFirstResponder];
}
- (void)OnSendClick{
    _mBackView.hidden = YES;
    _mBackView.frame = CGRectMake(0, self.view.frame.size.height-35, self.view.frame.size.width, 35);
    [_keyboardCancleBut removeFromSuperview];
    [self ResignFirstResponder];
}
- (void)OnCancelClick{
    if (!_mBackView.hidden) {
        [_keyboardCancleBut removeFromSuperview];
        _mBackView.hidden = YES;
        _mBackView.frame = CGRectMake(0, self.view.frame.size.height-35, self.view.frame.size.width, 35);
    }
    [self ResignFirstResponder];
}
- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    NSLog(@"----->%d",textField.tag);
    if ([textField.text isEqual:@""]) {
        if (textField.tag == 0) {
            _nameDesLabel.hidden = NO;
        }
        else if(textField.tag == 1){
            _numberDesLabel.hidden = NO;
        }
        //        else if(textField.tag == 2){
        //            _serviceAddressDesLabel.hidden = NO;
        //        }
        else if(textField.tag == 3){
            _addressDesLabel.hidden = NO;
        }
        else if(textField.tag == 4){
            _timeDesLabel.hidden = NO;
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"%d",textField.tag);
    if (textField.tag == 0) {
        _nameDesLabel.hidden = YES;
    }
    else if(textField.tag == 1){
        _numberDesLabel.hidden = YES;
        [_scrollView setContentOffset:CGPointMake(0, 30) animated:YES];
    }
    else if(textField.tag == 2){
        //        _serviceAddressDesLabel.hidden = YES;
        //        [_scrollView setContentOffset:CGPointMake(0, 75) animated:YES];
    }
    else if(textField.tag == 3){
        _addressDesLabel.hidden = YES;
        [_scrollView setContentOffset:CGPointMake(0, 120) animated:YES];
    }
    else if(textField.tag == 4){
        _timeDesLabel.hidden = YES;
        [_scrollView setContentOffset:CGPointMake(0, 165) animated:YES];
    }
    
}
- (void)RegisterForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)KeyboardWillShow:(NSNotification *)notif
{
    
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    [_scrollView addSubview:_keyboardCancleBut];
    
    int iHeight = keyboardSize.height;
    //    if (iHeight>35) {
    //        iHeight -= 35;
    //    }
    _mBackView.hidden = NO;
    NSLog(@"keyboardWasShown%d", iHeight);
    [UIView animateWithDuration:0.1 animations:^{
        _mBackView.frame = CGRectMake(0, self.view.frame.size.height-iHeight-35, self.view.frame.size.width, 35);
    } completion:nil];
}
- (void)KeyboardWillHidden:(NSNotification *)not
{
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
