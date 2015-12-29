//
//  PersonalizedSignatureViewController.m
//  TestRedCollar
//
//  Created by MC on 14-7-24.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "PersonalizedSignatureViewController.h"
#import "MyCusttomFabricModel.h"
#import "NetImageView.h"
#import "LocationBtn.h"
#import "AutoAlertView.h"
@interface PersonalizedSignatureViewController ()
{
    UITextView *_textView;
    UIScrollView *_scrollView;
    UILabel *_mLabel;
    UIView *_mBackView;
    
    UIButton *_fontSeleBtn;
    UIButton *_colorSeleBtn;
    UIButton *_loacSeleBtn;
    
}
@end

@implementation PersonalizedSignatureViewController

@synthesize fontArray,locationArray,colorArray,a,b,c,emb;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self RegisterForKeyboardNotifications];
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated{
    int mA = a;
    int mB = b;
    int mC = c;
    self.block(_textView.text,mA,mB,mC);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"个性签名";
    self.view.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightTextBtn:@"完成" target:self action:@selector(SaveText)];
    //[self dealData];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    [self createTextView];
    [self createBottomView];
    
}
- (void)createBottomView
{
    UIImageView *Bg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 145, self.view.bounds.size.width-20, 250)];
    Bg.image = [UIImage imageNamed:@"personalized_Signature_bg.png"];
    Bg.userInteractionEnabled = YES;
    [_scrollView addSubview:Bg];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 25, 50, 20)];
    nameLabel.text = @"字体：";
    nameLabel.textColor = [UIColor darkGrayColor];
    nameLabel.font = [UIFont systemFontOfSize:15];
    //nameLabel.backgroundColor = [UIColor redColor];
    [Bg addSubview:nameLabel];
    
    for (int i = 0; i<fontArray.count; i++) {
        MyCusttomFabricModel *model = fontArray[i];
        double w = (self.view.bounds.size.width-130-8*5)/4;
        double h = w;
        double x = 65 + i * (w+8);
        double y = 10;
        
        NetImageView *img = [[NetImageView alloc]initWithFrame:CGRectMake(x, y, w, h)];
        img.mImageType = TImageType_CutFill;
        [Bg addSubview:img];
        [img GetImageByStr:model.part_small];
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(x-3, y-3, w+6, h+6);
        [btn setBackgroundImage:[UIImage imageNamed:@"custtom_sele_btn.png"] forState:UIControlStateSelected];
        btn.tag = 900+i;
        [btn addTarget:self action:@selector(FontBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [Bg addSubview:btn];
        if (i==a) {
            _fontSeleBtn=btn;
            _fontSeleBtn.selected =YES;
        }
    }
    
    
    
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 70, 50, 20)];
    nameLabel.text = @"颜色：";
    nameLabel.textColor = [UIColor darkGrayColor];
    nameLabel.font = [UIFont systemFontOfSize:15];
    [Bg addSubview:nameLabel];
    for (int i = 0; i<colorArray.count; i++) {
        MyCusttomFabricModel *model = colorArray[i];
        double w = (self.view.bounds.size.width-130-8*5)/4;
        double h = w;
        double x = 65 + i * (w+8);
        double y = 66;
        if (i > 4) {
            x = 65 + (i-5) * (w+8);
            y = 66+w+11;
        }
        NetImageView *img = [[NetImageView alloc]initWithFrame:CGRectMake(x, y, w, h)];
        img.mImageType = TImageType_CutFill;
        [Bg addSubview:img];
        [img GetImageByStr:model.s_img];
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(x-3, y-3, w+6, h+6);
        [btn setBackgroundImage:[UIImage imageNamed:@"custtom_sele_btn.png"] forState:UIControlStateSelected];
        btn.tag = 900+i;
        [btn addTarget:self action:@selector(ColorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [Bg addSubview:btn];
        if (i==b) {
            _colorSeleBtn=btn;
            _colorSeleBtn.selected =YES;
        }
    }
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 155, 50, 20)];
    nameLabel.text = @"位置：";
    nameLabel.textColor = [UIColor darkGrayColor];
    nameLabel.font = [UIFont systemFontOfSize:15];
    [Bg addSubview:nameLabel];
    
    for (int i = 0; i<locationArray.count; i++) {
        MyCusttomFabricModel *model = locationArray[i];
        double w = 140;
        double h = 20;
        double x = 65;
        double y = 158 + i * 22;
        LocationBtn *btn = [LocationBtn buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(x, y, w, h);
        [btn setImage:[UIImage imageNamed:@"place_nor.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"place_select.png"] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setTitle:model.part_name forState:UIControlStateNormal];
        btn.tag = 1200+i;
        [btn addTarget:self action:@selector(OnSelePlace:) forControlEvents:UIControlEventTouchUpInside];
        [Bg addSubview:btn];
        if (i==c) {
            _loacSeleBtn = btn;
            _loacSeleBtn.selected = YES;
        }
    }
}
- (void)FontBtnClick:(UIButton *)btn
{
    _fontSeleBtn.selected = NO;
    _fontSeleBtn = btn;
    _fontSeleBtn.selected = YES;
    
    a = btn.tag-900;
}

- (void)ColorBtnClick:(UIButton *)btn
{
    _colorSeleBtn.selected=NO;
    _colorSeleBtn = btn;
    _colorSeleBtn.selected = YES;

    b = btn.tag-900;
}
- (void)OnSelePlace:(UIButton *)btn
{
    _loacSeleBtn.selected = NO;
    _loacSeleBtn = btn;
    _loacSeleBtn.selected = YES;
    c = btn.tag-1200;
}
- (void)createTextView
{
    UIImageView *headBg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width-20, 115)];
    headBg.image = [UIImage imageNamed:@"personalized_Signature_bg.png"];
    [_scrollView addSubview:headBg];
    
    _textView = [[UITextView alloc]initWithFrame:headBg.frame];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.delegate = self;
    _textView.textColor = [UIColor darkGrayColor];
    _textView.text = emb;
    [_scrollView addSubview:_textView];
    
    _mLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 120, 20)];
    if (_textView.text.length == 0 || [_textView.text  isEqual: @" "]) {
        _mLabel.text = @"输入签名内容...";
    }
    _mLabel.backgroundColor = [UIColor clearColor];
    _mLabel.textColor = WORDGRAYCOLOR;
    _mLabel.font = [UIFont systemFontOfSize:16];
    [_textView addSubview:_mLabel];
    
    _mBackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-35, self.view.frame.size.width, 35)];
    _mBackView.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
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
    
}
- (void)OnSendClick{
    _mBackView.hidden = YES;
    _mBackView.frame = CGRectMake(0, self.view.frame.size.height-35, self.view.frame.size.width, 35);
    [_textView resignFirstResponder];
    NSLog(@"---->%@",_textView.text);
}
- (void)OnCancelClick{
    _mBackView.hidden = YES;
    _mBackView.frame = CGRectMake(0, self.view.frame.size.height-35, self.view.frame.size.width, 35);
    [_textView resignFirstResponder];
    _textView.text = @"";
    _mLabel.hidden = NO;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidDisappear:(BOOL)animated
{
    _mBackView.hidden = YES;
}

- (void)SaveText
{
    if (_textView.text.length==0) {
        [AutoAlertView ShowMessage:@"请输入签名内容"];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textViewDidChange:(UITextView *)textView {
    if (!_mLabel.hidden) {
        _mLabel.hidden = (textView.text && textView.text.length>0);
    }
}

- (void)RegisterForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)KeyboardWillShow:(NSNotification *) notif{
    NSDictionary *info = [notif userInfo];
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

- (void)KeyboardWillHidden:(NSNotification *) notif{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
