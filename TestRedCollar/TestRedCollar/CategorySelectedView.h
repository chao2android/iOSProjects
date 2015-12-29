//
//  CategorySelectedView.h
//  TestRedCollar
//
//  Created by MC on 14-8-3.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategorySelectedView : UIScrollView{
    UIImageView *mLineView;
}

@property (nonatomic, assign) int miIndex;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL OnTypeSelect;
@property (nonatomic, strong) NSArray *mArray;
@property (nonatomic, strong) UIColor *Color;
- (void)reloadData;
- (void)reloadColor;
- (void)SelectType:(int)index;

@end
