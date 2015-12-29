//
//  ShezhiViewController.h
//  好妈妈
//
//  Created by iHope on 13-9-25.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TishiView;
@interface ShezhiViewController : UIViewController<UIAlertViewDelegate>
{
    NSMutableArray *_shareTypeArray;
    UIScrollView * mainScrollView;
}
@property (retain,nonatomic)NSMutableArray * switchArray;
@property (retain,nonatomic)TishiView * tishiView;
@end
