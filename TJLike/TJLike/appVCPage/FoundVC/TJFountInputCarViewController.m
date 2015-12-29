//
//  TJFountInputCarViewController.m
//  TJLike
//
//  Created by MC on 15/4/13.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJFountInputCarViewController.h"
#import "PickerSelectView.h"
#import "TJFoundShowCarViewController.h"
#import "AutoAlertView.h"

@interface TJFountInputCarViewController ()
{
    UILabel *mLabel1;
    UITextField *mField;
    PickerSelectView *mPickerView;
}
@end

@implementation TJFountInputCarViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.naviController setNaviBarTitle:@"违章查询"];
    [self.naviController setNavigationBarHidden:NO];
    [self.naviController setNaviBarDefaultLeftBut_Back];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:240/250.f green:240/250.f blue:240/250.f alpha:1];
    
    UIImageView *topView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 80)];
    topView.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
    [self.view addSubview:topView];
    
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 50, 50)];
    icon.image = [UIImage imageNamed:@"fonud_1_"];
    [topView addSubview:icon];
    
    UILabel *mLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, 200, 80)];
    mLabel.backgroundColor = [UIColor clearColor];
    mLabel.textColor = [UIColor blackColor];
    mLabel.font = [UIFont systemFontOfSize:15];
    mLabel.text = @"请输入您的车型和车牌号";
    [topView addSubview:mLabel];
    
    for (int i = 0; i<2; i++) {
        UIView *mView = [[UIView alloc]initWithFrame:CGRectMake(0, 154+i*45, SCREEN_WIDTH, 45)];
        mView.backgroundColor = [UIColor whiteColor];
        mView.userInteractionEnabled = YES;
        [self.view addSubview:mView];
        
        for (int i = 0; i<2; i++) {
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, i*44.75, SCREEN_WIDTH, 0.25)];
            lineView.backgroundColor = [UIColor lightGrayColor];
            [mView addSubview:lineView];
        }
        
        UILabel *mLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 120, 45)];
        mLabel.backgroundColor = [UIColor clearColor];
        mLabel.textColor = [UIColor blueColor];
        mLabel.font = [UIFont systemFontOfSize:16];
        mLabel.text = i==0?@"车型：":@"车牌号  津：";
        [mView addSubview:mLabel];
        
        if (i==0) {
            mLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH-120, 45)];
            mLabel1.textColor = [UIColor blackColor];
            mLabel1.font = [UIFont systemFontOfSize:18];
            mLabel1.backgroundColor = [UIColor clearColor];
            mLabel1.text = @"小型汽车";
            [mView addSubview:mLabel1];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = mView.bounds;
            btn.backgroundColor = [UIColor clearColor];
            [btn addTarget:self action:@selector(Choose) forControlEvents:UIControlEventTouchUpInside];
            [mView addSubview:btn];
            
        }else{
            mField = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH-120, 45)];
            mField.placeholder = @"请输入您的车牌号";
            mField.inputAccessoryView = [self GetInputAccessoryView];
            mField.font = [UIFont systemFontOfSize:15];
            mField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [mView addSubview:mField];
        }
    }
    
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(15, SCREEN_HEIGHT-150, self.view.frame.size.width-30, 44);
    [loginBtn setBackgroundColor:[UIColor grayColor]];
    [loginBtn setTitle:@"查询" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [loginBtn addTarget:self action:@selector(OnRegisterClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
}
- (void)OnRegisterClick{
    if (mField.text.length==0) {
        [AutoAlertView ShowMessage:@"请输入车牌号"];
        return;
    }
    TJFoundShowCarViewController *ctrl = [[TJFoundShowCarViewController alloc]init];
    ctrl.CarId = mField.text;
    [self.naviController pushViewController:ctrl animated:YES];
}

- (void)Choose{
    [self ShowPickView];
}
- (void)ShowPickView{
    [self RemovePickView];
    mPickerView = [[PickerSelectView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-260, self.view.frame.size.width, 260)];
    mPickerView.backgroundColor = [UIColor whiteColor];
    mPickerView.delegate = self;
    mPickerView.OnPickerSelect = @selector(OnPickSelect:);
    mPickerView.OnPickerCancel = @selector(RemovePickView);
    [self.view addSubview:mPickerView];
    [mPickerView reloadData:@[@"小型车辆",@"大型车辆"]];
}

- (void)RemovePickView {
    @autoreleasepool {
        if (mPickerView) {
            [mPickerView removeFromSuperview];
            mPickerView = nil;
        }
    }
}

- (void)OnPickSelect:(PickerSelectView *)sender {
    mLabel1.text = sender.mSelectStr;
    
    [self RemovePickView];
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
