//
//  TypeSelectView.h
//  TestHebei
//
//  Created by Hepburn Alex on 14-6-4.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TypeSelectView;
@protocol TypeSelectViewDelegate <NSObject>
@required

- (void)TypeSelectViewSelectType:(int)mIndex WithId:(int) cid;

@end

@interface TypeSelectView : UIScrollView {
    UIImageView *mLineView;
}
@property (nonatomic, assign) id<TypeSelectViewDelegate> mDelegate;
@property (nonatomic, assign) int miIndex;
@property (nonatomic, strong) NSMutableArray *mArray;

- (void)reloadData;

- (void)SelectType:(int)index;

@end
