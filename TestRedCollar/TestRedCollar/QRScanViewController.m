//
//  QRScanViewController.m
//  TestPinBang
//
//  Created by Hepburn Alex on 13-6-19.
//  Copyright (c) 2013年 Hepburn Alex. All rights reserved.
//

#import "QRScanViewController.h"
#import "AutoAlertView.h"
#import "MyCustomDetailViewController.h"
#import "ThemeDetialViewController.h"

@interface QRScanViewController ()

@end

@implementation QRScanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)GoBack {
    if (mScanCtrl) {
        [mScanCtrl dismissModalViewControllerAnimated:NO];
        mScanCtrl = nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"扫描二维码");
    self.view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    self.title = @"扫描二维码";
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    
    mWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    mWebView.delegate = self;
    [self.view addSubview:mWebView];
    
    mActView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    mActView.center = self.view.center;
    mActView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:mActView];
    
    [self ShowScanView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [mActView stopAnimating];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [mActView startAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [mActView stopAnimating];
}

- (void)ShowScanView {
    mScanCtrl = [ZBarReaderViewController new];
    mScanCtrl.readerDelegate = self;
    mScanCtrl.showsZBarControls = NO;
    mScanCtrl.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = mScanCtrl.scanner;
    
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    [self presentModalViewController: mScanCtrl animated:NO];

    int iHeight = IOS_7?60:40;
    UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, iHeight)];
    topView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    topView.userInteractionEnabled = YES;
    [mScanCtrl.view addSubview:topView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, iHeight-40, 40, 40);
    [backBtn setImage:[UIImage imageNamed:@"35.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(GoBack) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    
    UIImageView *msgView = [[UIImageView alloc] initWithFrame:CGRectMake(45, mScanCtrl.view.frame.size.height-60, mScanCtrl.view.frame.size.width-90, 40)];
    msgView.image = [[UIImage imageNamed:@"chat-timeback.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:15];
    [mScanCtrl.view addSubview:msgView];
    
    UILabel *lbMsg = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, msgView.frame.size.width-20, msgView.frame.size.height)];
    lbMsg.backgroundColor = [UIColor clearColor];
    lbMsg.font = [UIFont boldSystemFontOfSize:14];
    lbMsg.textColor = [UIColor whiteColor];
    lbMsg.textAlignment = UITextAlignmentCenter;
    lbMsg.numberOfLines = 0;
    lbMsg.text = @"将二维码图案放在取景框内\r\n即可自动扫描";
    [msgView addSubview:lbMsg];
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    NSString *resstr = symbol.data;
    NSLog(@"scanresult:%@", resstr);
    [reader dismissModalViewControllerAnimated: YES];
    
    mScanCtrl = nil;
    
    self.title = @"扫描结果";
    if (resstr) {
        NSString *dissertid = [UserInfoManager GetTextBetweenStr:resstr start:@"dissertation-info-" end:@".html"];
        if (dissertid && dissertid.length>0) {
            ThemeDetialViewController *ctrl = [[ThemeDetialViewController alloc] init];
            ctrl.mBackCtrl = self.mBackCtrl;
            ctrl.mThemeID = [dissertid intValue];
            [self.navigationController pushViewController:ctrl animated:YES];
            return;
        }
        NSString *customid = [UserInfoManager GetTextBetweenStr:resstr start:@"custom-info-" end:@".html"];
        if (customid && customid.length>0) {
            MyCustomDetailViewController *ctrl = [[MyCustomDetailViewController alloc] init];
            ctrl.mBackCtrl = self.mBackCtrl;
            ctrl.IDStr = customid;
            [ctrl StartDownload];
            [self.navigationController pushViewController:ctrl animated:YES];
            return;
        }
        NSRange range = [resstr rangeOfString:@"http"];
        if (range.length>0 && range.location == 0) {
            NSURL *url = [NSURL URLWithString:resstr];
            if (url) {
                [mWebView loadRequest:[NSURLRequest requestWithURL:url]];
                return;
            }
        }
        [mWebView loadHTMLString:resstr baseURL:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
