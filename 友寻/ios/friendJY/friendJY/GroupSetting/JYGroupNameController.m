//
//  JYGroupNameController.m
//  friendJY
//
//  Created by 高斌 on 15/4/17.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYGroupNameController.h"
#import "JYHttpServeice.h"
#import "JYShareData.h"
#import "JYMessageModel.h"
#import "JYChatDataBase.h"

@interface JYGroupNameController ()

@end

@implementation JYGroupNameController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"群组名字"];
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setFrame:CGRectMake(0, 0, 65, 44)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [saveBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
    [saveBtn setTitleColor:kTextColorBlue forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveBarBtn = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    [self.navigationItem setRightBarButtonItem:saveBarBtn];
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 34, kScreenWidth, 44)];
    [bgView setBackgroundColor:kTextColorWhite];
    [self.view addSubview:bgView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, bgView.top+13, 65, 18)];
    [titleLab setFont:[UIFont systemFontOfSize:16.0f]];
    [titleLab setTextColor:kTextColorGray];
    [titleLab setBackgroundColor:[UIColor clearColor]];
    [titleLab setText:@"群组名称"];
    [self.view addSubview:titleLab];
    
    _nameTF = [[UITextField alloc] initWithFrame:CGRectMake(titleLab.right+13, bgView.top+12, kScreenWidth-15-titleLab.width-13-15, 20)];
    [_nameTF setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_nameTF setBorderStyle:UITextBorderStyleNone];
    [_nameTF setBackgroundColor:[UIColor clearColor]];
    [_nameTF setFont:[UIFont systemFontOfSize:16.0f]];
    [_nameTF setText:self.infoModel.title];
//    [nameTF setDelegate:self];
    [self.view addSubview:_nameTF];
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
    NSString * str = [_nameTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([JYHelpers isEmptyOfString:str]){
        [[JYAppDelegate sharedAppDelegate] showTip:@"请输入群组名称"];
    }else{
        [self requestUpdateGroup];
    }
}

- (void)textFieldTextDidChange:(NSNotification *)notification
{
    if (_nameTF.text.length>14) {
        _nameTF.text = [_nameTF.text substringToIndex:14];
    } else {
    
    }
}

#pragma mark - request

//更新群组信息
- (void)requestUpdateGroup
{
    [_nameTF resignFirstResponder];
    [self showProgressHUD:@"数据发送中" toView:self.view];
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"chat" forKey:@"mod"];
    [parametersDict setObject:@"update_group_title" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:self.groupModel.group_id forKey:@"group_id"];
    [postDict setObject:_nameTF.text forKey:@"title"];

    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        [self dismissProgressHUDtoView:self.view];
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            
            BOOL result = [[[responseObject objectForKey:@"data"] objectForKey:@"result"] boolValue];
            if (result) {
                //成功
                NSLog(@"title-name:%@",_nameTF.text);
                self.infoModel.title = _nameTF.text;
                self.groupModel.title = _nameTF.text;
                
                //更新message列表
                NSMutableArray * msgList = [JYShareData sharedInstance].messageUserList ;
                for (int i = 0; i<msgList.count; i++) {
                    JYMessageModel * msgModel = (JYMessageModel *)msgList[i];
                    if ([msgModel.group_id integerValue] == [self.groupModel.group_id integerValue]) {
                        msgModel.title = _nameTF.text;
                        [[JYChatDataBase sharedInstance] updateGroupName:self.groupModel.group_id title:_nameTF.text];
                    }
                }
                
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                //失败
            }
            
        } else {
            
        }
        
    } failure:^(id error) {
        
        
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self hide];
    
}

- (void)hide{
    [_nameTF resignFirstResponder];
    
}

@end
