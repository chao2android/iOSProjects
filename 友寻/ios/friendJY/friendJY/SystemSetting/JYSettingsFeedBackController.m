//
//  JYSettingsFeedBackController.m
//  friendJY
//
//  Created by chenxiangjing on 15/5/22.
//  Copyright (c) 2015年 友寻. All rights reserved.
//

#import "JYSettingsFeedBackController.h"
#import "JYAppDelegate.h"
#import "JYHttpServeice.h"

@interface JYSettingsFeedBackController ()<UITextViewDelegate>
{
    UITextView *signContentTextView;
    CGFloat currentKeyBoardHeight;
    BOOL isFirstTimeEditing;
}

@end

@implementation JYSettingsFeedBackController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"反馈建议"];
    isFirstTimeEditing = YES;
    //内容
    signContentTextView = [[UITextView alloc] initWithFrame:CGRectMake(10,  15, kScreenWidth - 20, 200)]; //初始化大小并自动释放
    signContentTextView.textColor = [JYHelpers setFontColorWithString:@"#303030"];//设置textview里面的字体颜色
    signContentTextView.font = [UIFont fontWithName:@"Arial" size:15.0];//设置字体名字和字体大小
    signContentTextView.backgroundColor = [UIColor whiteColor];//设置它的背景颜色
    [signContentTextView setReturnKeyType:UIReturnKeyDone];
    signContentTextView.layer.borderColor = [[JYHelpers setFontColorWithString:@"#cccccc"] CGColor];
    signContentTextView.layer.borderWidth = 1;
    signContentTextView.delegate = self;//设置它的委托方法
    [signContentTextView setTextColor:kTextColorGray];
    signContentTextView.text = @"请填写你的反馈建议内容";//设置它显示的内容
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65, 44)];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setTitleColor:kTextColorBlue forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [button addTarget:self action:@selector(commitClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:button]];
    
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgClicked)]];
    [self.view addSubview: signContentTextView];//加入到整个页面中
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoradChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}
#pragma mark - Click Handler && Gestures
//http://c.friendly.dev/cmiajax/?mod=feedback&func=add_feedback&content=他哦了啦咯啦咯啦咯啦咯
- (void)commitClicked{
    
    NSMutableString *mutStr = [NSMutableString stringWithString:signContentTextView.text];
    //删除空格
    NSRange range = [mutStr rangeOfString:@" "];
    while (range.location != NSNotFound) {
        [mutStr deleteCharactersInRange:range];
        range = [mutStr rangeOfString:@" "];
    }
    //删除回车
    range = [mutStr rangeOfString:@"\n"];
    while (range.location != NSNotFound) {
        [mutStr deleteCharactersInRange:range];
        range = [mutStr rangeOfString:@"\n"];
    }
    //回车 和空格删除之后的字符串 mutstr
    if (mutStr.length == 0 || [signContentTextView.text isEqualToString:@"请填写你的反馈建议内容"]) {
        //输入内容无效
        if (currentKeyBoardHeight > kScreenHeight/2 - 20) {
            [[JYAppDelegate sharedAppDelegate] showPromptTip:@"请输入有效内容" withTipCenter:CGPointMake(kScreenWidth/2, kScreenHeight/2 - 30)];
        }else{
            [[JYAppDelegate sharedAppDelegate] showTip:@"请输入有效内容"];
        }
        return;
    }

    NSDictionary *paraDic = @{@"mod":@"feedback",
                              @"func":@"add_feedback"
                              };
    NSDictionary *postDic = @{
                              @"content":signContentTextView.text
                              };
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            //do any addtion here...
            if ([[responseObject objectForKey:@"data"] boolValue]) {
                [[JYAppDelegate sharedAppDelegate] showTip:@"提交成功!"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    } failure:^(id error) {
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];
}
- (void)bgClicked{
    [signContentTextView resignFirstResponder];
}
#pragma mark - Notifications
- (void)keyBoradChangeFrame:(NSNotification*)noti{
    NSDictionary *userInfo = [noti userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    currentKeyBoardHeight = keyboardRect.size.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [textView resignFirstResponder];
        //在这里做你响应return键的代码
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    bool isChinese;//判断当前输入法是否是中文
    if ([[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString: @"en-US"]) {
        isChinese = false;
    }
    else
    {
        isChinese = true;
    }
    
    NSString *str = [textView.text stringByReplacingOccurrencesOfString:@"?" withString:@""];
    if (isChinese) { //中文输入法下
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            NSLog(@"汉字");
            if ( str.length>=101) {
                if (currentKeyBoardHeight > kScreenHeight/2 - 20) {
                    [[JYAppDelegate sharedAppDelegate] showPromptTip:@"最多输入100个汉字" withTipCenter:CGPointMake(kScreenWidth/2, kScreenHeight/2 - 30)];
                }else{
                    [[JYAppDelegate sharedAppDelegate] showTip:@"最多输入100个汉字"];
                }
                NSString *strNew = [NSString stringWithString:str];
                [textView setText:[strNew substringToIndex:100]];
            }
        }
        else
        {
            NSLog(@"输入的英文还没有转化为汉字的状态");
            
        }
    }else{
        NSLog(@"str=%@; 本次长度=%d",str,[str length]);
        if ([str length]>=101) {
            if (currentKeyBoardHeight > kScreenHeight/2 - 20) {
                [[JYAppDelegate sharedAppDelegate] showPromptTip:@"最多输入100个汉字" withTipCenter:CGPointMake(kScreenWidth/2, kScreenHeight/2 - 30)];
            }else{
                [[JYAppDelegate sharedAppDelegate] showTip:@"最多输入100个汉字"];
            }
            NSString *strNew = [NSString stringWithString:str];
            [textView setText:[strNew substringToIndex:100]];
        }
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (isFirstTimeEditing) {
        [textView setText:@""];
        [textView setTextColor:kTextColorBlack];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    return YES;
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
