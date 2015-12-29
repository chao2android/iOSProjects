//
//  TabbarView.h
//  FansEnd
//
//  Created by iHope on 13-10-12.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TabbarView;

@protocol SelectTabbarDelegate <NSObject>

- (void)OnTabSelect:(TabbarView *)sender;
- (BOOL)CanSelectTab:(TabbarView *)sender :(int)index;

@end

@interface TabbarView : UIView {
    UIImageView *imageView;
    UIImageView *imageView1;
    
    UIView *grayView;
    UIView *redView;
    UIView *upView;
}

@property (nonatomic, assign) int miIndex;
@property (nonatomic, strong) UIButton *selectBtn;

@property(nonatomic, assign) id<SelectTabbarDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withImageArray:(NSArray*)array;
- (void)selectNumber:(int)number;

@end
