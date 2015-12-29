//
//  InvoiceViewController.m
//  TestRedCollar
//
//  Created by MC on 14-7-21.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "InvoiceViewController.h"

@interface InvoiceViewController ()
{
    UIScrollView *_mScrollView;
    UIButton *_selectedBtn;
    UIImageView *_needInvoiceBg;
    UIButton *_invoiceTypeBtn;
    UITextField *_mTextField;
    UIView *_mBackView;
    NSString *_type;
    NSString *_invoicetitle;
}
@end

@implementation InvoiceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self resignToKeyboardNotif];
    }
    return self;
}
- (void)resignToKeyboardNotif{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)KeyboardWillShow:(NSNotification *)Noti{
    [_mScrollView setContentOffset:CGPointMake(0, 320+280-self.view.bounds.size.height) animated:YES];
    
    NSDictionary *info = [Noti userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    int iHeight = keyboardSize.height;
    //    if (iHeight>35) {
    //        iHeight -= 35;
    //    }
    NSLog(@"keyboardWasShown%d", iHeight);
    _mBackView.hidden = NO;
    [UIView animateWithDuration:0.1 animations:^{
        _mBackView.frame = CGRectMake(0, self.view.frame.size.height-iHeight-35, self.view.frame.size.width, 35);
    } completion:nil];
}
- (void)KeyboardWillHidden:(NSNotification *)Noti{
    [_mScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _type = @"个人";
    _invoicetitle = @"";
    self.view.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
    self.title = @"发票信息";
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
    
    _mScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _mScrollView.showsHorizontalScrollIndicator = NO;
    _mScrollView.showsVerticalScrollIndicator = NO;
    _mScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_mScrollView];
    
    int iHeight = 45;
    //int iGap = 20;
    UIView *bgVIew = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.bounds.size.width, iHeight*3)];
    bgVIew.backgroundColor = [UIColor whiteColor];
    [_mScrollView addSubview:bgVIew];
    
    _mBackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-35, self.view.frame.size.width, 35)];
    _mBackView.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    _mBackView.userInteractionEnabled = YES;
    _mBackView.hidden = YES;
    [self.view addSubview:_mBackView];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(self.view.frame.size.width-50, 2, 40, 30);
    [sendBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sendBtn setTitleColor:WORDGRAYCOLOR forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(OnSendClick) forControlEvents:UIControlEventTouchUpInside];
    [_mBackView addSubview:sendBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(10, 2, 40, 30);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:WORDGRAYCOLOR forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(OnCancelClick) forControlEvents:UIControlEventTouchUpInside];
    [_mBackView addSubview:cancelBtn];
    
    for (int i = 0 ; i<2; i++) {
        double w = self.view.bounds.size.width;
        double h = 1;
        double x = 15;
        double y = (i+1)*iHeight;
        UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, w, h)];
        if (i==0) {
            lineView.frame = CGRectMake(0, y, w, h);
        }
        lineView.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
        [bgVIew addSubview:lineView];
    }
    
    UILabel *invoiceInfo = [[UILabel alloc]initWithFrame:CGRectMake(15, 16, 120, 20)];
    invoiceInfo.text = @"发票信息";
    invoiceInfo.font = [UIFont systemFontOfSize:17];
    [bgVIew addSubview:invoiceInfo];
    
    UILabel *invoiceInfoLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 16+iHeight, 130, 20)];
    invoiceInfoLabel1.text = @"不需要发票";
    invoiceInfoLabel1.font = [UIFont systemFontOfSize:15];
    invoiceInfoLabel1.textColor = [UIColor darkGrayColor];
    [bgVIew addSubview:invoiceInfoLabel1];
    
    UILabel *invoiceInfoLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 16+iHeight*2, 130, 20)];
    invoiceInfoLabel2.text = @"索要发票";
    invoiceInfoLabel2.font = [UIFont systemFontOfSize:15];
    invoiceInfoLabel2.textColor = [UIColor darkGrayColor];
    [bgVIew addSubview:invoiceInfoLabel2];
    
    UIButton *typeBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    typeBtn1.frame =CGRectMake(self.view.bounds.size.width-50, 20+iHeight, 20, 20);
    [typeBtn1 setBackgroundImage:[UIImage imageNamed:@"invoice_namorl.png"] forState:UIControlStateNormal];
    [typeBtn1 setBackgroundImage:[UIImage imageNamed:@"invoice_sele.png"] forState:UIControlStateSelected];
    [typeBtn1 addTarget:self action:@selector(typeClick:) forControlEvents:UIControlEventTouchUpInside];
    typeBtn1.tag = 100;
    [_mScrollView addSubview:typeBtn1];
    
    UIButton *typeBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    typeBtn2.frame =CGRectMake(self.view.bounds.size.width-50, 22+iHeight*2, 20, 20);
    [typeBtn2 setBackgroundImage:[UIImage imageNamed:@"invoice_namorl.png"] forState:UIControlStateNormal];
    [typeBtn2 setBackgroundImage:[UIImage imageNamed:@"invoice_sele.png"] forState:UIControlStateSelected];
    [typeBtn2 addTarget:self action:@selector(typeClick:) forControlEvents:UIControlEventTouchUpInside];
    typeBtn2.tag = 100+1;
    [_mScrollView addSubview:typeBtn2];
    
    _needInvoiceBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10+iHeight*3, self.view.bounds.size.width, iHeight*3)];
    _needInvoiceBg.backgroundColor = [UIColor whiteColor];
    _needInvoiceBg.userInteractionEnabled = YES;
    [_mScrollView addSubview:_needInvoiceBg];
    
    if (self.index ==0) {
        typeBtn1.selected =YES;
        _selectedBtn = typeBtn1;
        _needInvoiceBg.hidden = YES;
    }
    else{
        typeBtn2.selected =YES;
        _selectedBtn = typeBtn2;
        _needInvoiceBg.hidden = NO;
    }
    
    for (int i = 0 ; i<4; i++) {
        double w = self.view.bounds.size.width;
        double h = 1;
        double x = 30;
        double y = i*iHeight;
        UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, w, h)];
        if (i==0) {
            lineView.frame = CGRectMake(15, y, w, h);
        }
        lineView.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
        [_needInvoiceBg addSubview:lineView];
    }
    UILabel *mLable = [[UILabel alloc]initWithFrame:CGRectMake(35, 10, 80, 20)];
    mLable.textColor = [UIColor grayColor];
    mLable.font = [UIFont systemFontOfSize:14];
    mLable.text = @"发票类型:";
    [_needInvoiceBg addSubview:mLable];
    
    UIButton *invoiceType = [UIButton buttonWithType:UIButtonTypeCustom];
    //invoiceType.backgroundColor = [UIColor redColor];
    invoiceType.frame = CGRectMake(105, 10, 60, 20);
    [invoiceType setImage:[UIImage imageNamed:@"place_nor.png"] forState:UIControlStateNormal];
    [invoiceType setImageEdgeInsets:UIEdgeInsetsMake(3, 8, 3, 38)];
    [invoiceType setImage:[UIImage imageNamed:@"place_select.png"] forState:UIControlStateSelected];
    [invoiceType setTitle:@"个人" forState:UIControlStateNormal];
    [invoiceType setTitleColor:WORDGRAYCOLOR forState:UIControlStateNormal];
    invoiceType.titleLabel.font = [UIFont systemFontOfSize:14];
    invoiceType.tag = 1300;
    [invoiceType addTarget:self action:@selector(invoiceTypeClick:) forControlEvents:UIControlEventTouchUpInside];
    [_needInvoiceBg addSubview:invoiceType];
    _invoiceTypeBtn = invoiceType;
    _invoiceTypeBtn.selected = YES;
    
    invoiceType = [UIButton buttonWithType:UIButtonTypeCustom];
    //invoiceType.backgroundColor = [UIColor redColor];
    invoiceType.frame = CGRectMake(175, 10, 60, 20);
    [invoiceType setImage:[UIImage imageNamed:@"place_nor.png"] forState:UIControlStateNormal];
    [invoiceType setImageEdgeInsets:UIEdgeInsetsMake(3, 8, 3, 38)];
    [invoiceType setImage:[UIImage imageNamed:@"place_select.png"] forState:UIControlStateSelected];
    [invoiceType setTitle:@"公司" forState:UIControlStateNormal];
    [invoiceType setTitleColor:WORDGRAYCOLOR forState:UIControlStateNormal];
    invoiceType.titleLabel.font = [UIFont systemFontOfSize:14];
    invoiceType.tag = 1301;
    [invoiceType addTarget:self action:@selector(invoiceTypeClick:) forControlEvents:UIControlEventTouchUpInside];
    [_needInvoiceBg addSubview:invoiceType];
    
    mLable = [[UILabel alloc]initWithFrame:CGRectMake(35, 10+iHeight, 110, 20)];
    mLable.textColor = [UIColor grayColor];
    mLable.font = [UIFont systemFontOfSize:14];
    mLable.text = @"发票内容:   服装";
    [_needInvoiceBg addSubview:mLable];
    
    mLable = [[UILabel alloc]initWithFrame:CGRectMake(35, 10+iHeight*2, 80, 20)];
    mLable.textColor = [UIColor grayColor];
    mLable.font = [UIFont systemFontOfSize:14];
    mLable.text = @"发票台头:";
    [_needInvoiceBg addSubview:mLable];
    
    _mTextField = [[UITextField alloc]initWithFrame:CGRectMake(105, 8+iHeight*2, 200, 30)];
    _mTextField.borderStyle = UITextBorderStyleRoundedRect;
    _mTextField.backgroundColor = [UIColor whiteColor];
    _mTextField.font = [UIFont systemFontOfSize:14];
    _mTextField.textColor = [UIColor grayColor];
    _mTextField.delegate = self;
    
    [_needInvoiceBg addSubview:_mTextField];
    
    UIButton *saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 10+iHeight*6+50, self.view.bounds.size.width-40, 45)];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"1_11.gif"] forState:UIControlStateNormal];
    saveBtn.tag = 102;
    [saveBtn addTarget:self action:@selector(typeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
}
- (void)OnSendClick{
    _mBackView.hidden = YES;
    _mBackView.frame = CGRectMake(0, self.view.frame.size.height-35, self.view.frame.size.width, 35);
    [_mTextField resignFirstResponder];
}
- (void)OnCancelClick{
    _mBackView.hidden = YES;
    _mBackView.frame = CGRectMake(0, self.view.frame.size.height-35, self.view.frame.size.width, 35);
    [_mTextField resignFirstResponder];
    _mTextField.text = @"";
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidDisappear:(BOOL)animated
{
    _mBackView.hidden = YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    _invoicetitle = textField.text;
    self.blocks(self.index,_type,_invoicetitle);
}
- (void)invoiceTypeClick:(UIButton *)sender
{
    _invoiceTypeBtn.selected = NO;
    _invoiceTypeBtn = sender;
    _invoiceTypeBtn.selected = YES;
    if (sender.tag==1300) {
        _type = @"个人";
    }
    else{
        _type = @"公司";
    }
    self.blocks(self.index,_type,_invoicetitle);
    
}
- (void)typeClick:(UIButton *)sender
{
    if (sender.tag == 100) {
        if (_selectedBtn == sender) {
            return;
        }
        _selectedBtn.selected = NO;
        _selectedBtn = sender;
        _selectedBtn.selected = YES;
        _needInvoiceBg.hidden = YES;
        self.index = 0;
        self.blocks(self.index,_type,_invoicetitle);
    }
    else if (sender.tag == 101){
        if (_selectedBtn == sender) {
            return;
        }
        _selectedBtn.selected = NO;
        _selectedBtn = sender;
        _selectedBtn.selected =YES;
        _needInvoiceBg.hidden = NO;
        self.index = 1;
        self.blocks(self.index,_type,_invoicetitle);
    }
    else if (sender.tag == 102){
        [self GoBack];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
