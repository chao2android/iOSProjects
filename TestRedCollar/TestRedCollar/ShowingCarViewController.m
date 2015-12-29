//
//  ShowingCarViewController.m
//  TestRedCollar
//
//  Created by MC on 14-7-11.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ShowingCarViewController.h"
#import "ImageDownManager.h"
#import "JSON.h"
@interface ShowingCarViewController ()
{
    ImageDownManager *_getCartManager;
}
@end

@implementation ShowingCarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:0.91 alpha:1.0];
    self.title = @"购物车";
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
    
    
    //测试获取购物车
    [self getCart];

}
- (void)dealloc {
    [self Cancel];
}
- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(_getCartManager);
}
- (void)getCart
{
    [self StartLoading];
    _getCartManager = [[ImageDownManager alloc] init];
    _getCartManager.delegate = self;
    _getCartManager.OnImageDown = @selector(OnGetCartFinish:);
    _getCartManager.OnImageFail = @selector(OnLoadFail:);
    NSString *urlstr = [NSString stringWithFormat:@"%@flow.php",SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //rctailor.ec51.com.cn/soaapi/soap/flow.php?act=getCart&pageSize=1&pageIndex=1&token=639d8b5b131b90e28b3e66ca2b86c800
    //NSString *idStr = [NSString stringWithFormat:@"%d",self.model.id];
    [dict setObject:kkToken forKey:@"token"];
    [dict setObject:@"getCart" forKey:@"act"];
    [dict setObject:@"1" forKey:@"pageSize"];
    [dict setObject:@"1" forKey:@"pageIndex"];
    [_getCartManager PostHttpRequest:urlstr :dict];
}
- (void)OnGetCartFinish:(ImageDownManager *)sender
{
    NSDictionary *dict = [sender.mWebStr JSONValue];
    NSLog(@"----->%@",dict);
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        //NSLog(@"----->%@",[dict objectForKey:@"msg"]);
        //[AutoAlertView ShowAlert:@"提示" message:[dict objectForKey:@"msg"]];
    }
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    NSLog(@"下载失败");
    [self Cancel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
