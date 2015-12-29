//
//  VideoTimelineView.h
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-11-12.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopAlertView.h"

@interface VideoTimelineView : UIView<UIScrollViewDelegate> {
    UIScrollView *mScrollView;
    UIButton *mFinishBtn;
    PopAlertView *mAlertView;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL OnAddressSelect;
@property (nonatomic, assign) SEL OnPageSelect;
@property (nonatomic, assign) SEL OnFinishSelect;
@property (nonatomic, assign) SEL OnGoBack;

- (void)reloadData;

@end
