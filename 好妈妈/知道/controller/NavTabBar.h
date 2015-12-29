//
//  NavTabBar.h
//  好妈妈
//
//  Created by Hepburn Alex on 14-5-16.
//  Copyright (c) 2014年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NavTabBar;

@protocol NavTabBarDelegate <NSObject>

- (void)OnNavTabSelect:(NavTabBar *)sender;

@end

@interface NavTabBar : UIView {
    UIButton *mSelectBtn;
}

@property (nonatomic, assign) id<NavTabBarDelegate> delegate;
@property (nonatomic, assign) int miIndex;

@end
