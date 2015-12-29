//
//  FenxiangView.h
//  好妈妈
//
//  Created by iHope on 13-9-24.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "ASIHTTPRequest.h"
@interface FenxiangView : UIView<ASIHTTPRequestDelegate>
{
    LoginViewController * longinView;
    UIView * aView;
//    UIImage* image;
//    NSString * uid;
//    NSString * ncString;
//    NSString * typeString;
//    NSTimer * SaveImageTimer;
}
@property (retain,nonatomic)NSMutableArray * shareTypeArray;
- (id)initWithFrame:(CGRect)frame cont:(id)controllerView;
@end
