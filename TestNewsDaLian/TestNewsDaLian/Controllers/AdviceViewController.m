//
//  AdviceViewController.m
//  TestNewsDaLian
//
//  Created by dxy on 14/12/23.
//  Copyright (c) 2014年 zp. All rights reserved.
//

#import "AdviceViewController.h"

@interface AdviceViewController ()
{

    UITextField * _textField;
    UITextView * _textView;
    UILabel * _tishiLabel;
}
@end

@implementation AdviceViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.title = @"意见反馈";
    [self AddLeftImageBtn:[UIImage imageNamed:@"goBack.png"] target:self action:@selector(GoBack)];
    [self AddRightTextBtn:@"发表" target:self action:@selector(upload)];
}

#pragma mark - 发布按钮
-(void)upload{//还没有
    

    
    if (_textView.text.length<10) {
        [DxyCustom showAlertViewTitle:@"提示" message:@"输入内容不能少于10个字" delegate:self];
    }else{
    
        [DxyCustom showAlertViewTitle:@"提示" message:@"发表成功" delegate:self];
    }
    

}


- (void)OnLoadFinish:(ImageDownManager *)sender {
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    
}

- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}

- (void)dealloc {
    [self Cancel];
}

- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}





- (void)viewDidLoad {
    [super viewDidLoad];
    [self uiConfig];
    // Do any additional setup after loading the view.
}

#pragma mark - UI布局
- (void)uiConfig{
    self.view.backgroundColor = [UIColor whiteColor];
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 15, MainScreenWidth - 20, 147)];
    _textView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:_textView];
    
    _tishiLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 50)];
    if (_textView.text.length == 0) {
        _tishiLabel.text = @"请输入您的宝贵意见，以便我们快速改进，不少于10个字哦";
    }else{
        _tishiLabel.text = @"";
    }
    _tishiLabel.numberOfLines = 2;
    _tishiLabel.enabled = NO;//lable必须设置为不可用
    _tishiLabel.textColor = [UIColor lightGrayColor];
    _tishiLabel.backgroundColor = [UIColor clearColor];
    [_textView addSubview:_tishiLabel];

    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, _textView.frame.origin.y + _textView.frame.size.height + 20, MainScreenWidth - 20, 40)];
    _textField.placeholder = @"QQ,邮箱或者电话";
    _textField.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    _textField.delegate = self;
    [self.view addSubview:_textField];
    
}
- (void)textViewDidChange:(UITextView *)textView{
    
    
        if (textView.text.length == 0) {
            _tishiLabel.text = @"请输入您的宝贵意见，以便我们快速改进，不少于10个字哦";
        }else{
            _tishiLabel.text = @"";
        }
    

}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_textView resignFirstResponder];
    [_textField resignFirstResponder];
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
