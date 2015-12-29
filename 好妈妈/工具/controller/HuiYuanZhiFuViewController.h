//
//  HuiYuanZhiFuViewController.h
//  好妈妈
//
//  Created by iHope on 14-2-17.
//  Copyright (c) 2014年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "MBProgressHUD.h"
#import "ImageDownManager.h"

@interface HuiYuanZhiFuViewController : UIViewController<SKPaymentTransactionObserver,SKProductsRequestDelegate,UIAlertViewDelegate>
{
    UIImageView * tequanImageView;
    MBProgressHUD *mLoadView;
    ImageDownManager *mDownManager;
    UILabel *mlbOldPrice;
    UILabel *mlbNewPrice;
}
@end
