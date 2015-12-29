//
//  QRScanViewController.h
//  TestPinBang
//
//  Created by Hepburn Alex on 13-6-19.
//  Copyright (c) 2013年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseADViewController.h"
#import "ZBarSDK.h"

@interface QRScanViewController : BaseADViewController<ZBarReaderDelegate, UIWebViewDelegate> {
    ZBarReaderViewController *mScanCtrl;
    UIWebView *mWebView;
    UIActivityIndicatorView *mActView;
}

@end
