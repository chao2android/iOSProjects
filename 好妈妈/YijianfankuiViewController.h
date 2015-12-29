//
//  YijianfankuiViewController.h
//  好妈妈
//
//  Created by iHope on 13-10-17.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnalysisClass.h"
@class TishiView;
@interface YijianfankuiViewController : UIViewController<AnalysisClassDelegate>
{
    AnalysisClass * analysis;
}
@property (retain,nonatomic)UITextView * contentTextView;
@property (retain,nonatomic)TishiView * tishiView;

@end
