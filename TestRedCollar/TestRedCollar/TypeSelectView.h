//
//  TypeSelectView.h
//  TestHebei
//
//  Created by Hepburn Alex on 14-6-4.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TypeSelectView : UIScrollView {
    UIImageView *mLineView;
}
@property (nonatomic, assign) int miIndex;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL OnTypeSelect;
@property (nonatomic, strong) NSArray *mArray;

- (void)reloadData;

- (void)SelectType:(int)index;

@end
