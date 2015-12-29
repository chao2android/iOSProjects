//
//  JYGroupIntroController.m
//  friendJY
//
//  Created by 高斌 on 15/4/17.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYGroupIntroController.h"
#import "JYHttpServeice.h"
#import "JYAppDelegate.h"

@interface JYGroupIntroController ()<UITextViewDelegate>
{
    UILabel *otisLabel;
}
@end

@implementation JYGroupIntroController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"群组介绍"];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setFrame:CGRectMake(0, 0, 65, 44)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [saveBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
    [saveBtn setTitleColor:kTextColorBlue forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveBarBtn = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    [self.navigationItem setRightBarButtonItem:saveBarBtn];
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 34, kScreenWidth, 200)];
    [bgView setBackgroundColor:kTextColorWhite];
    [self.view addSubview:bgView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, bgView.top+20, 65, 18)];
    [titleLab setFont:[UIFont systemFontOfSize:16.0f]];
    [titleLab setTextColor:kTextColorGray];
    [titleLab setBackgroundColor:[UIColor clearColor]];
    [titleLab setText:@"群组介绍"];
    [self.view addSubview:titleLab];
    
    
    
    _nameTV = [[UITextView alloc] initWithFrame:CGRectMake(titleLab.right+13, bgView.top+12, kScreenWidth-15-titleLab.width-13-15, 176)];
    [_nameTV setBackgroundColor:[UIColor clearColor]];
    [_nameTV setFont:[UIFont systemFontOfSize:16.0f]];
    [_nameTV setText:self.infoModel.intro];
    _nameTV.layer.borderWidth = 1;
    _nameTV.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _nameTV.delegate = self;
    [self.view addSubview:_nameTV];
    
    otisLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 8, 120, 20)];
    [otisLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [otisLabel setTextColor:kTextColorGray];
    [otisLabel setBackgroundColor:[UIColor clearColor]];
    [otisLabel setText:@"请输入群组介绍"];
    otisLabel.hidden = _nameTV.text.length!=0;
    [_nameTV addSubview:otisLabel];
}



- (void)textViewDidChange:(UITextView *)textView{
    NSString *content = textView.text;
    if (!content) {
        content = @"";
    }
    
    otisLabel.hidden = content.length != 0;
    
    if (content.length > 50) {
        textView.text = [content substringToIndex:50];
        [textView resignFirstResponder];
        [[JYAppDelegate sharedAppDelegate] showTip:@"群组介绍最多50字"];
    }
    
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

- (void)saveBtnClick:(UIButton *)btn
{
    NSLog(@"保存");
//    NSString * str = [_nameTV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    if([JYHelpers isEmptyOfString:str]){
//        [[JYAppDelegate sharedAppDelegate] showTip:@"请输入群组介绍"];
//    }else{
        [self requestUpdateGroup];
//    }
    
}

#pragma mark - request

//更新群组信息
- (void)requestUpdateGroup
{
    [_nameTV resignFirstResponder];
    [self showProgressHUD:@"数据发送中" toView:self.view];
    
    NSString * str = [_nameTV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"chat" forKey:@"mod"];
    [parametersDict setObject:@"update_group" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:self.groupModel.group_id forKey:@"group_id"];
    [postDict setObject:self.groupModel.title forKey:@"title"];
    [postDict setObject:str forKey:@"intro"];
    [postDict setObject:self.infoModel.privilege forKey:@"privilege"];
    [postDict setObject:self.infoModel.status forKey:@"status"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        [self dismissProgressHUDtoView:self.view];
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        NSLog(@"%@", [responseObject objectForKey:@"retmean"]);
        
        if (iRetcode == 1) {
            
            BOOL result = [[[responseObject objectForKey:@"data"] objectForKey:@"result"] boolValue];
            if (result) {
                //成功
                [self.infoModel setIntro:_nameTV.text];
                [self.groupModel setIntro:_nameTV.text];
                self.finishBlick(_nameTV.text);
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                //失败
            }
            
        } else {
            
        }
        
    } failure:^(id error) {
        
        
    }];
}


@end
