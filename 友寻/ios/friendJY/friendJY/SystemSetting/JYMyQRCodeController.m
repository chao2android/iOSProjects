//
//  JYMyQRCodeController.m
//  friendJY
//
//  Created by chenxiangjing on 15/6/9.
//  Copyright (c) 2015年 友寻. All rights reserved.
//

#import "JYMyQRCodeController.h"
#import "JYQRCodeGenerator.h"
#import "JYShareData.h"
#import "JYProfileModel.h"
#import "JYShareData.h"
#import "JYProfileModel.h"

@interface JYMyQRCodeController ()

@property (nonatomic, strong) UIImageView *myCodeImageView;

@property (nonatomic, strong) UIImage *codeImage;

@end

@implementation JYMyQRCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutSubviews];
}
- (void)layoutSubviews{
    
    _myCodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    [_myCodeImageView setCenter:CGPointMake(kScreenWidth/2, 170)];
    [_myCodeImageView setUserInteractionEnabled:YES];
    [_myCodeImageView setContentMode:UIViewContentModeTop];
    [_myCodeImageView setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"我的二维码"];
    [self.view addSubview:_myCodeImageView];
    [self getCodeImage];
}
- (void)getCodeImage{
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_avatar",ToString([SharedDefault objectForKey:@"uid"])]];
    
//    NSLog(@"avatarPath = %@",path);
    UIImage *codeImage = [JYQRCodeGenerator qrImageForString:[NSString stringWithFormat:@"http://m.iyouxun.com/wechat/share_profile/?uid=%@",ToString([SharedDefault objectForKey:@"uid"])] imageSize:_myCodeImageView.width];
    NSData *imageData = [NSData dataWithContentsOfFile:path];
    
    if (imageData == nil) {
        NSURL *avatarUrl = [NSURL URLWithString:[JYShareData sharedInstance].myself_profile_model.avatars[@"200"]];
        imageData = [NSData dataWithContentsOfURL:avatarUrl];
    }//没有数据 下载。
    
    UIImage *avtarImage = [[UIImage alloc] initWithData:imageData];
    codeImage = [JYQRCodeGenerator twoDimensionCodeImage:codeImage withAvatarImage:avtarImage];
    
    [self.myCodeImageView setImage:codeImage];
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(_myCodeImageView.left, _myCodeImageView.bottom+20, _myCodeImageView.width, 60)];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bgView];
    
    UIImageView *avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(_myCodeImageView.left+5, _myCodeImageView.bottom + 25, 50, 50)];
    [avatarView setImage:avtarImage];
    [self.view addSubview:avatarView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(avatarView.right + 10, avatarView.top, _myCodeImageView.width - avatarView.width - 10 - 10, 20)];
    [nameLabel setTextColor:kTextColorBlack];
    [nameLabel setFont:[UIFont systemFontOfSize:15]];
    [nameLabel setText:[NSString stringWithFormat:@"%@的友寻二维码",[JYShareData sharedInstance].myself_profile_model.nick]];
    [self.view addSubview:nameLabel];
    
    JYProfileModel *userProfileModel = [JYShareData sharedInstance].myself_profile_model;
    if (![userProfileModel.live_location isEqualToString:@"0"]) {
        
        NSString *province = @" ";
        //过滤 不限
        if (![userProfileModel.live_location isEqualToString:@"0"]) {
            province = [[JYShareData sharedInstance].province_code_dict objectForKey:userProfileModel.live_location];
        }
        NSString *city = @" ";
        if (![userProfileModel.live_sublocation isEqualToString:@"0"]) {
            city = [[JYShareData sharedInstance].city_code_dict  objectForKey:userProfileModel.live_sublocation];
        }
        //过滤 空串
        NSString *province_city = @" ";
        if (province && city) {
            province_city = [NSString stringWithFormat:@"%@ %@", province, city];
        }
        
        UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom, nameLabel.width, 30)];
        [cityLabel setTextColor:kTextColorBlack];
        [cityLabel setFont:[UIFont systemFontOfSize:15]];
        [cityLabel setText:province_city];
        [self.view addSubview:cityLabel];
        
    }
 
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    NSLog(@"QR dealloc");
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
