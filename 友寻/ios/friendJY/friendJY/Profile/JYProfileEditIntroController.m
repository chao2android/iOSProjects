//
//  JYProfileEditIntroController.m
//  friendJY
//
//  Created by ouyang on 3/19/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//

#import "JYProfileEditIntroController.h"
#import "JYShareData.h"
#import "AFNetworking.h"
#import "NSString+URLEncoding.h"
#import "JYHttpServeice.h"
#import "JYAppDelegate.h"
#import "JYProfileData.h"

@interface JYProfileEditIntroController ()
{
    NSDictionary * profileDataDic;
    UITextView *signContentTextView;
    CGFloat currentKeyBoardHeight;
    BOOL isEdited;
}

@end

@implementation JYProfileEditIntroController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"个性签名"];
    isEdited = NO;
    profileDataDic = [JYShareData sharedInstance].myself_profile_dict;
    
    NSString * myStr = [profileDataDic objectForKey:@"intro"];
    //签名内容
    signContentTextView = [[UITextView alloc] initWithFrame:CGRectMake(10,  15, kScreenWidth - 20, 200)]; //初始化大小并自动释放
    signContentTextView.textColor = [JYHelpers setFontColorWithString:@"#303030"];//设置textview里面的字体颜色
    signContentTextView.font = [UIFont fontWithName:@"Arial" size:15.0];//设置字体名字和字体大小
    signContentTextView.backgroundColor = [UIColor whiteColor];//设置它的背景颜色
    [signContentTextView setReturnKeyType:UIReturnKeyDone];
    signContentTextView.layer.borderColor = [[JYHelpers setFontColorWithString:@"#cccccc"] CGColor];
    signContentTextView.layer.borderWidth = 1;
    signContentTextView.delegate = self;//设置它的委托方法
    
    if (myStr.length>0) {
        signContentTextView.text = myStr;//设置它显示的内容
    }else{
        signContentTextView.text = @"请输入个性签名";//设置它显示的内容
    }
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgClicked)]];
    [self.view addSubview: signContentTextView];//加入到整个页面中
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoradChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];

}
- (void)keyBoradChangeFrame:(NSNotification*)noti{
    NSDictionary *userInfo = [noti userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    currentKeyBoardHeight = keyboardRect.size.height;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)bgClicked{
    [signContentTextView resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)backAction{
    if (![[profileDataDic objectForKey:@"intro"] isEqualToString:signContentTextView.text]) {//有改动采取操作
        if (isEdited) {
            //删除空格
            NSMutableString *mutStr = [NSMutableString stringWithString:signContentTextView.text];
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
            NSString *text = @"";//默认为空
            //回车 和空格删除之后的字符串 mutstr
            if (mutStr.length != 0) {
                //有改动并且改动有效
                text = signContentTextView.text;
            }
            NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
            [parametersDict setObject:@"profile" forKey:@"mod"];
            [parametersDict setObject:@"update_user_intro" forKey:@"func"];
            
            NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
            [postDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] forKey:@"uid"];
            [postDict setObject:text forKey:@"intro"];
            
            [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
                NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
                if (iRetcode == 1) {
//                    if (mutStr.length != 0) {
                        [[JYAppDelegate sharedAppDelegate] showTip:@"个性签名修改成功"];
//                    }else{
//                        [[JYAppDelegate sharedAppDelegate] showTip:@"个性签名删除成功"];
//                    }
                    
                    NSMutableDictionary *newProfileDic = [NSMutableDictionary dictionaryWithDictionary:profileDataDic];
                    [newProfileDic setObject:signContentTextView.text forKey:@"intro"];
                    
                    [[JYShareData sharedInstance] setMyself_profile_dict:newProfileDic];
                    
                    if ([self.delegate respondsToSelector:@selector(profileIntroDidChanged:)]) {
                        [self.delegate profileIntroDidChanged:signContentTextView.text];
                    }
                    
                    [[JYProfileData sharedInstance] updateMyProfileWithNewProfileDic:newProfileDic];
                    
                    //                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [[JYAppDelegate sharedAppDelegate] showTip:@"个性签名修改失败"];
                }
            } failure:^(id error) {
                
                NSLog(@"%@", error);
                [self dismissProgressHUDtoView:self.view];
                [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
            }];
   
        }
    }
    [super backAction];
}
- (void)leaveEditMode {
    
    [self.view resignFirstResponder];
    
}

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
        NSLog(@"str=%@; 本次长度=%lu",str,(unsigned long)[str length]);
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
//没有签名，开始输入时提示置空
    NSString * myStr = [profileDataDic objectForKey:@"intro"];
    if (myStr.length == 0) {
        [textView setText:@""];
    }
    isEdited = YES;
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
