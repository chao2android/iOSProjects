//
//  JYAboutUsController.m
//  friendJY
//
//  Created by chenxiangjing on 15/6/5.
//  Copyright (c) 2015年 友寻. All rights reserved.
//

#import "JYAboutUsController.h"

@interface JYAboutUsController ()

@end

@implementation JYAboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"关于我们"];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 60)/2, 60, 60, 60)];
    [iconImageView setBackgroundColor:[UIColor clearColor]];
    [iconImageView.layer setMasksToBounds:YES];
    [iconImageView.layer setCornerRadius:10];
    [iconImageView.layer setBorderWidth:1];
    [iconImageView.layer setBorderColor:[kTextColorLightGray CGColor]];
    [iconImageView setImage:[UIImage imageNamed:@"you_xun_icon"]];
    [self.view addSubview:iconImageView];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    CFBundleShortVersionString
    version = [NSString stringWithFormat:@"版本：%@",version];
    
    CGFloat width = [JYHelpers getTextWidthAndHeight:version fontSize:14].width;
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - width)/2, iconImageView.bottom + 10, width, 20)];
    [versionLabel setFont:[UIFont systemFontOfSize:14]];
    [versionLabel setBackgroundColor:[UIColor clearColor]];
    [versionLabel setText:version];
    [versionLabel setTextAlignment:NSTextAlignmentCenter];
    [versionLabel setTextColor:kTextColorGray];
    [self.view addSubview:versionLabel];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(40, versionLabel.bottom, kScreenWidth - 80, KScreenVisualHeight - iconImageView.bottom - 60)];
    [textView setBackgroundColor:[UIColor clearColor]];
    [textView setContentInset:UIEdgeInsetsMake(5, 10, 10, 10)];
//    [textView setTextContainerInset:UIEdgeInsetsMake(10, 10, 10, 10)];
    [textView setFont:[UIFont systemFontOfSize:15]];
    [textView setTextAlignment:NSTextAlignmentLeft];
    [textView setTextColor:[UIColor blackColor]];
    [textView setEditable:NO];
    [textView setScrollEnabled:NO];
    [textView setText:@"关于我们：\n友寻是北京友约互动信息科技有限公司开发的手机交友软件，致力于帮助单身人士从熟人圈中找到适合自己的另一半，拓展人际圈。\n\n友寻微信公众号：请直接搜索“友寻”\n友寻官方QQ群：213554767\n客服邮箱：support@iyouxun.com"];
    [self.view addSubview:textView];
    
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
