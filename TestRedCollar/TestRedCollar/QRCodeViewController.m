//
//  QRCodeViewController.m
//  TestRedCollarShop
//
//  Created by Hepburn Alex on 14-4-10.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "QRCodeViewController.h"
#import "JSON.h"
#import "NetImageView.h"

@interface QRCodeViewController ()

@end

@implementation QRCodeViewController
{
    NetImageView *imageView;
}

@synthesize mDownManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)connectToServer
{
    if (mDownManager) {
        return;
    }
    [self StartLoading];
    
    self.mDownManager = [[ImageDownManager alloc] init];
    mDownManager.delegate = self;
    mDownManager.OnImageDown = @selector(OnLoadFinish:);
    mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *urlstr = [NSString stringWithFormat:@"%@user.php", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"qrcode" forKey:@"act"];
    [dict setObject:kkUserID forKey:@"user_id"];
    [mDownManager PostHttpRequest:urlstr :dict];
}

- (void)Cancel
{
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (void)OnLoadFinish:(ImageDownManager *)sender
{
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        if ([[dict objectForKey:@"statusCode"] intValue] == 0) {
            [imageView GetImageByStr:[dict objectForKey:@"mqrcode"]];
        }
    }
}

- (void)OnLoadFail:(ImageDownManager *)sender
{
    [self Cancel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的二维码名片";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"qrback"]];
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
    
    imageView = [[NetImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-200)/2, (self.view.frame.size.height-200)/2, 200, 200)];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:imageView];
    
    [self connectToServer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
