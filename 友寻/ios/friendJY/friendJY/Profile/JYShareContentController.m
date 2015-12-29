//
//  JYShareContentController.m
//  friendJY
//
//  Created by chenxiangjing on 15/4/24.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYShareContentController.h"
#import <UIImageView+WebCache.h>
#import "JYAppDelegate.h"
#import "JYShareData.h"

@interface JYShareContentController ()

@property (nonatomic, strong) UITextView *shareTextView;

@property (nonatomic, strong) UIImageView *shareImageView;

@end

@implementation JYShareContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setImageUrl:[[[JYShareData sharedInstance].myself_profile_dict objectForKey:@"avatars"] objectForKey:@"600"]];
    [self layoutSubviews];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_shareTextView becomeFirstResponder];
}
- (void)layoutSubviews{
    
    [self setTitle:@"分享给好友"];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, 50, 40)];
    [leftBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(cancelClickedAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 50, 40)];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [rightBtn setTitle:@"发送" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(sendClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    _shareTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 10, kScreenWidth - 30, 120)];
    [_shareTextView setFont:[UIFont systemFontOfSize:14]];
    [_shareTextView setClipsToBounds:YES];
    [_shareTextView setTextColor:kTextColorGray];
    [_shareTextView setTextAlignment:NSTextAlignmentNatural];
//    [_shareTextView setContentInset:UIEdgeInsetsMake(10, 15, 10, 15)];
//    _shareTextView setBackgroundColor:[]
    [_shareTextView setText:_content];
    [self.view addSubview:_shareTextView];
    
    _shareImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, _shareTextView.bottom +15, 60, 60)];
    [_shareImageView setUserInteractionEnabled:YES];
    [_shareImageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl]];
    [self.view addSubview:_shareImageView];
}
#pragma mark - button Action
- (void)cancelClickedAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)sendClickedAction:(UIButton*)sender{
    [sender setEnabled:NO];
    [self showProgressHUD:@"发送中..." toView:self.view];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"test_img" ofType:@"jpeg"];
    id<ISSCAttachment>image = [ShareSDK imageWithUrl:_imageUrl];
    id<ISSContent>publishContent = [ShareSDK content:_shareTextView.text
                                      defaultContent:@""
                                               image:image
                                               title:[NSString stringWithFormat:@"我是%@，我在友寻。",[[JYShareData sharedInstance].myself_profile_dict objectForKey:@"nick"]]
                                                 url:[NSString stringWithFormat:@"http://m.iyouxun.com/wechat/friend_invite/?uid=%@",ToString([SharedDefault objectForKey:@"uid"])]
                                         description:nil
                                           mediaType:SSPublishContentMediaTypeNews];

    [ShareSDK shareContent:publishContent
                      type:ShareTypeSinaWeibo
               authOptions:nil
             statusBarTips:YES
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSResponseStateSuccess) {
                            [self dismissProgressHUDtoView:self.view];
                            [[JYAppDelegate sharedAppDelegate] showTip:@"发送成功!"];
                            [self.navigationController popViewControllerAnimated:YES];
                        }
    }];
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
