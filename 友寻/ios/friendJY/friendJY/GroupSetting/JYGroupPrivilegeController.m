//
//  JYGroupPrivilegeController.m
//  friendJY
//
//  Created by 高斌 on 15/4/17.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYGroupPrivilegeController.h"
#import "JYHttpServeice.h"

@interface JYGroupPrivilegeController ()

@end

@implementation JYGroupPrivilegeController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"权限设置"];
        
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
    
    for (int i=0; i<6; i++) {
        
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 34+i*44, kScreenWidth, 44)];
        [bgView setTag:100+i];
        [bgView setUserInteractionEnabled:YES];
        [bgView setBackgroundColor:kTextColorWhite];
        [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewTap:)]];
        [self.view addSubview:bgView];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, bgView.top+13, kScreenWidth-15-5-17-15, 18)];
        [titleLab setFont:[UIFont systemFontOfSize:16.0f]];
        [titleLab setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:titleLab];
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(15, bgView.bottom-1, kScreenWidth-15, 1)];
        [line setBackgroundColor:kBorderColorGray];
        [self.view addSubview:line];
        
        if (i==0) {
            [bgView setUserInteractionEnabled:NO];
            [titleLab setTextColor:kTextColorGray];
            [titleLab setText:@"权限设置"];
        } else {
            [bgView setUserInteractionEnabled:YES];
            [titleLab setTextColor:kTextColorBlack];
            [titleLab setText:self.privilegeList[i-1]];
        }
    }
    
    _selectedImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_choose.png"]];
    _selectedIndex = [self.infoModel.privilege integerValue];
    [_selectedImageV setFrame:CGRectMake(kScreenWidth-15-17, 34+44+_selectedIndex*44+15, 17, 15)];
    [self.view addSubview:_selectedImageV];
    
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

- (void)bgViewTap:(UITapGestureRecognizer *)tap
{
    _selectedIndex = tap.view.tag-100-1;
    [_selectedImageV setFrame:CGRectMake(kScreenWidth-15-17, 34+44+_selectedIndex*44+15, 17, 15)];

}

- (void)saveBtnClick:(UIButton *)btn
{
    NSLog(@"保存");
    [self requestUpdateGroup];
}

#pragma mark - request

//更新群组信息
- (void)requestUpdateGroup
{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"chat" forKey:@"mod"];
    [parametersDict setObject:@"update_group" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:self.groupModel.group_id forKey:@"group_id"];
    [postDict setObject:self.groupModel.title forKey:@"title"];
    [postDict setObject:self.groupModel.intro forKey:@"intro"];
    [postDict setObject:[NSString stringWithFormat:@"%ld", _selectedIndex] forKey:@"privilege"];
    [postDict setObject:self.infoModel.status forKey:@"status"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        NSLog(@"%@", [responseObject objectForKey:@"retmean"]);
        
        if (iRetcode == 1) {
            
            BOOL result = [[[responseObject objectForKey:@"data"] objectForKey:@"result"] boolValue];
            if (result) {
                //成功
                [self.infoModel setPrivilege:[NSString stringWithFormat:@"%ld", _selectedIndex]];
                
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
