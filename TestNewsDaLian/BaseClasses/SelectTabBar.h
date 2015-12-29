//
//  SelectTabBar.h
//  TestRedCollar
//
//  Created by iHope on 14-1-23.
//  Copyright (c) 2014年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelectTabBar;

@protocol SelectTabBarDelegate <NSObject>

- (void)OnTabSelect:(SelectTabBar *)sender;
- (BOOL)CanSelectTab:(SelectTabBar *)sender :(int)index;

@end

@interface SelectTabBar : UIImageView {
}

@property(nonatomic, assign) int miIndex;
@property(nonatomic, assign) id delegate;
@property(nonatomic, assign) SEL OnForumTabSelect;

@end
