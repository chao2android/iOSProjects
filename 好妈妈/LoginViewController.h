//
//  LoginViewController.h
//  好妈妈
//
//  Created by iHope on 13-9-23.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AnalysisClass.h"
@class TishiView;
@interface LoginViewController : UIViewController<UITextFieldDelegate,CLLocationManagerDelegate,AnalysisClassDelegate>
@property (retain,nonatomic)TishiView * tishiView;
@property (retain,nonatomic)UITextField * zhanghaoTextField;
@property (retain,nonatomic)UITextField * mimaTextField;
@property (retain,nonatomic)NSMutableDictionary * oldDictionary;
@property (retain,nonatomic)NSMutableDictionary * postDictionary;
@end
