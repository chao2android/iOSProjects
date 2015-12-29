//
//  BaobaoJintianViewController.h
//  好妈妈
//
//  Created by iHope on 13-10-29.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "MBProgressHUD.h"

@interface BaobaoJintianViewController : UIViewController<UIWebViewDelegate,UIScrollViewDelegate,SKPaymentTransactionObserver,SKProductsRequestDelegate,UIAlertViewDelegate,UIAlertViewDelegate>
{
    MBProgressHUD *myHUD;
    UIWebView * myWebView;
    UIImageView * dingBgView;
}
@property (retain,nonatomic)NSString * webViewString;
@end
