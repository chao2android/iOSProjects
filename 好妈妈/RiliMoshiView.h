//
//  RiliMoshiView.h
//  好妈妈
//
//  Created by iHope on 13-10-18.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "AnalysisClass.h"
#import "WeirijiViewController.h"
@class TishiView;
@interface RiliMoshiView : UIView<AnalysisClassDelegate>
{
    int miYear;
    int miMonth;
    int miOffset;
    NSDate * mDate;
    NSMutableArray * dataArray;
    AnalysisClass * analysis;
    NSString * idStr;
    TishiView * tishiView;
}
- (void)analyUrl;
- (id)initWithFrame:(CGRect)frame ID:(NSString *)idString;
@property (retain,nonatomic) UIImageView * riliImageView;
@property (retain,nonatomic) UILabel * timeLabel;
@property (assign,nonatomic) id temp;
@end
