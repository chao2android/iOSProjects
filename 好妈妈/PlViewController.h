//
//  PlViewController.h
//  好妈妈
//
//  Created by iHope on 13-10-30.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmoKeyboardView.h"
#import "AnalysisClass.h"
#import "TishiView.h"
@interface PlViewController : UIViewController<UITextViewDelegate,AnalysisClassDelegate>
{
    TishiView * tishiView;
    AnalysisClass * analysis;
    EmoKeyboardView * emokeyView;
    UITextView * contentTextView;
    UIView * inputView;
}
@property (retain,nonatomic)NSString * idString;
@end
