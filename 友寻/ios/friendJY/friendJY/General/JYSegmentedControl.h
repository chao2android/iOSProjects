//
//  AZXSegmentedControl.h
//  imAZXiPhone
//
//  Created by 高 斌 on 14-7-10.
//  Copyright (c) 2014年 高 斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYSegmentedControl : UISegmentedControl
{
    NSMutableArray *_buttons;
    NSMutableArray *_titles;
}

- (id)initWithItems:(NSArray *)array;
- (void)insertSegmentWithImage:(UIImage *)image  atIndex:(NSUInteger)segment animated:(BOOL)animated;
- (void)setImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)segment;
- (void)setSelectedImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)segment;
- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment;

@end
