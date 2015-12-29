//
//  EmoKeyboardView.h
//  TestEmotion
//
//  Created by Hepburn Alex on 13-6-13.
//  Copyright (c) 2013年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmoKeyboardView : UIView<UIScrollViewDelegate> {
    UIScrollView *mScrollView;
    NSArray *mEmoArray;
    UIPageControl *mPointView;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL OnEmoSelect;
@property (nonatomic, assign) SEL OnSendClick;
+ (NSString *)GetEmoImage:(NSString *)name;
+ (NSString *)FormatEmoText:(NSString *)text;
- (id)initWithFrame:(CGRect)frame button:(BOOL)sender;
@end
