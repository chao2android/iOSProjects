//
//  MainInformationViewController.m
//  TJLike
//
//  Created by MC on 15/4/12.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "MainInformationViewController.h"
#import "AutoAlertView.h"
#import "ModifyPasswordViewController.h"

@interface MainInformationViewController ()

{
    UIImageView *iconView;
    UITextField *nameLabel;
    UITextField *signLabel;
    UITextField *numLabel;
    UITextField *birthLabel;
    UITextField *sexLabel;
}

@end

@implementation MainInformationViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.naviController setNaviBarTitle:@"编辑资料"];
    [self.naviController setNavigationBarHidden:NO];
    [self.naviController setNaviBarDefaultLeftBut_Back];
    [self.naviController setNaviBarRightBtn:[self GetRightBtn]];
}

- (void)OnModifyClick {
    /*
    nameLabel;
    signLabel;
    numLabel;
    birthLabel;
    sexLabel*/
    if (nameLabel.text.length == 0) {
        [AutoAlertView ShowMessage:@"请填写昵称"];
        return;
    }
    if (signLabel.text.length == 0) {
        signLabel.text =@"";
    }
    if (birthLabel.text.length == 0) {
        birthLabel.text =@"";
    }
    if (nameLabel.text.length == 0) {
        [AutoAlertView ShowMessage:@"请填写昵称"];
        return;
    }
    NSString *sex = @"女";
    if (sexLabel.text.length == 0) {
        
    }else{
        if ([sexLabel.text isEqualToString:@"男"]) {
            sex = @"男";
        }
    }
    
     NSString *urlStr = [NSString stringWithFormat:@"http://www.zounai.com/index.php/api/UpdateUserInfo"];
     NSMutableDictionary *dict = [NSMutableDictionary dictionary];
     [dict setObject:UserManager.userInfor.userId forKey:@"uid"];
    [dict setObject:nameLabel.text forKey:@"nickname"];
    [dict setObject:signLabel.text forKey:@"signature"];
    [dict setObject:birthLabel.text forKey:@"birthday"];
    [dict setObject:sex forKey:@"sex"];
    
     [[HttpClient postRequestWithPath:urlStr para:dict] subscribeNext:^(NSDictionary *info) {
         NSLog(@"修改信息----》%@",info);
         [AutoAlertView ShowMessage:@"修改成功"];
         UserManager.userInfor.nickName = nameLabel.text;
         UserManager.userInfor.signature= signLabel.text;
         UserManager.userInfor.birthday = birthLabel.text;
         self.mBlock();
     } error:^(NSError *error) {
     HttpClient.failBlock(error);
         
         
     }];
    
}

- (void)InitInfo{
    nameLabel.text = UserManager.userInfor.nickName;
    signLabel.text = UserManager.userInfor.signature;
    birthLabel.text = UserManager.userInfor.birthday;
    sexLabel.text = UserManager.userInfor.identity;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 80)];
    topView.backgroundColor = [UIColor colorWithWhite:0.80 alpha:1];
    [self.view addSubview:topView];
    
    iconView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 70, 70)];
    iconView.image = [UIImage imageNamed:@"sa_05"];
    iconView.layer.masksToBounds = YES;
    iconView.layer.cornerRadius = 70*0.5;
    [topView addSubview:iconView];
    
    UILabel *mLabel = [[UILabel alloc]initWithFrame:CGRectMake(95, 30, SCREEN_WIDTH-120, 20)];
    mLabel.backgroundColor = [UIColor clearColor];
    mLabel.textColor = [UIColor blackColor];
    mLabel.text = @"上传头像";
    mLabel.font = [UIFont systemFontOfSize:18];
    [topView addSubview:mLabel];
    
    UIView *mView = [[UIView alloc]initWithFrame:CGRectMake(0, 144, SCREEN_WIDTH, 86)];
    mView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mView];
    
    
    NSArray *textArray = @[@"昵称",@"个性签名"];
    for (int i = 0 ; i<2; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, i*43, SCREEN_WIDTH, 43)];
        [mView addSubview:view];
        
        UIImageView *nextImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20, 16, 6, 11)];
        nextImage.backgroundColor = [UIColor clearColor];
        nextImage.image = [UIImage imageNamed:@"my_08"];
        [view addSubview:nextImage];
        
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10.25, 22.5, 22.5)];
        icon.image = [UIImage imageNamed:i==0?@"my_nicheng_":@"my_qianming_"];
        [view addSubview:icon];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(52.5, 0, 100, 43)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:18];
        label.text = textArray[i];
        [view addSubview:label];
        
        if (i==0) {
            nameLabel = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, 100, 43)];
            nameLabel.backgroundColor = [UIColor clearColor];
            nameLabel.textColor = [UIColor blackColor];
            nameLabel.font = [UIFont systemFontOfSize:18];
            
            nameLabel.inputAccessoryView = [self GetInputAccessoryView];
            [view addSubview:nameLabel];
        }
        if (i==1) {
            signLabel = [[UITextField alloc]initWithFrame:CGRectMake(140, 0, 100, 43)];
            signLabel.backgroundColor = [UIColor clearColor];
            signLabel.textColor = [UIColor blackColor];
            signLabel.font = [UIFont systemFontOfSize:18];
            
            signLabel.inputAccessoryView = [self GetInputAccessoryView];
            [view addSubview:signLabel];
        }
    }
    for (int i = 0; i<3; i++) {
        UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, i*43, SCREEN_WIDTH, 0.5)];
        lineView.backgroundColor = [UIColor blackColor];
        [mView addSubview:lineView];
    }
    
    mView = [[UIView alloc]initWithFrame:CGRectMake(0, 240, SCREEN_WIDTH, 43*5)];
    mView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mView];
    
    
    textArray = @[@"手机号",@"生日",@"性别",@"绑定微博",@"修改密码"];
    NSArray *iconArray = @[@"my_shoujihao_",@"my_shengri_",@"my_xingbie_",@"my_bangding_",@"my_mima_"];
    for (int i = 0; i<5; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, i*43, SCREEN_WIDTH, 43)];
        [mView addSubview:view];
        
        
        
        UIImageView *nextImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20, 16, 6, 11)];
        nextImage.backgroundColor = [UIColor clearColor];
        nextImage.image = [UIImage imageNamed:@"my_08"];
        [view addSubview:nextImage];
        
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10.25, 22.5, 22.5)];
        icon.image = [UIImage imageNamed:iconArray[i]];
        [view addSubview:icon];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(52.5, 0, 100, 43)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:18];
        label.text = textArray[i];
        [view addSubview:label];
        
        if (i == 0) {
            numLabel = [[UITextField alloc]initWithFrame:CGRectMake(110, 0, SCREEN_WIDTH, 43)];
            numLabel.inputAccessoryView = [self GetInputAccessoryView];
            numLabel.backgroundColor = [UIColor clearColor];
            numLabel.textColor = [UIColor blackColor];
            numLabel.font = [UIFont systemFontOfSize:18];
            numLabel.enabled = NO;
            numLabel.text = @"18722506554";
            [view addSubview:numLabel];
        }
        else if(i==1){
            birthLabel = [[UITextField alloc]initWithFrame:CGRectMake(110, 0, SCREEN_WIDTH, 43)];
            birthLabel.inputAccessoryView = [self GetInputAccessoryView];
            birthLabel.backgroundColor = [UIColor clearColor];
            birthLabel.textColor = [UIColor blackColor];
            birthLabel.font = [UIFont systemFontOfSize:18];
            
            [view addSubview:birthLabel];
        }
        else if(i==2){
            sexLabel = [[UITextField alloc]initWithFrame:CGRectMake(110, 0, SCREEN_WIDTH, 43)];
            sexLabel.inputAccessoryView = [self GetInputAccessoryView];
            sexLabel.backgroundColor = [UIColor clearColor];
            sexLabel.textColor = [UIColor blackColor];
            sexLabel.font = [UIFont systemFontOfSize:18];
            
            [view addSubview:sexLabel];
        }
        
        if (i==4) {
            mView.userInteractionEnabled = YES;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = view.bounds;
            btn.backgroundColor = [UIColor clearColor];
            [btn addTarget:self action:@selector(ModifyPassword) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
        }
    }
    for (int i = 0; i<6; i++) {
        UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, i*43, SCREEN_WIDTH, 0.5)];
        lineView.backgroundColor = [UIColor blackColor];
        [mView addSubview:lineView];
    }
    
    [self InitInfo];
    
}
- (void)ModifyPassword{
    ModifyPasswordViewController *ctrl = [[ModifyPasswordViewController alloc]init];
    [self.naviController pushViewController:ctrl animated:YES];
}
- (UIView *)GetInputAccessoryView
{
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    inputView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(inputView.frame.size.width-50, 0, 50, inputView.frame.size.height);
    [btn setTitle:@"隐藏" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(OnHideKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:btn];
    
    return inputView;
}
- (void)OnHideKeyboard {
    [self.view endEditing:NO];
}


- (void)requestSaveData {
    NSString *urlStr = [NSString stringWithFormat:@"http://www.zounai.com/index.php/api/UpdateUserInfo"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"" forKey:@"nickname"];
    [dict setObject:@"" forKey:@"uid"];
    [dict setObject:@"" forKey:@"signature"];
    [dict setObject:@"" forKey:@"birthday"];
    [dict setObject:@"" forKey:@"sex"];//0女1男
    [[HttpClient postRequestWithPath:urlStr para:dict] subscribeNext:^(NSDictionary *info) {
        NSLog(@"info--------%@",info);
        
        
    } error:^(NSError *error) {
        HttpClient.failBlock(error);
    }];
    
}

- (UIButton *)GetRightBtn{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 44, 44);
    rightBtn.backgroundColor = [UIColor clearColor];
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(OnModifyClick) forControlEvents:UIControlEventTouchUpInside];
    
    return rightBtn;
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
