//
//  MaterialSelectView.h
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-5.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MaterialSelectView;

@protocol MaterialSelectViewDelegate <NSObject>

- (void)OnMaterialSelect:(MaterialSelectView *)sender;

@end

@interface MaterialSelectView : UIView {
    UIScrollView *mScrollView;
    UIImageView *mCoverView;
    UIImageView *mPopView;
}

@property (nonatomic, assign) int miIndex;
@property (nonatomic, assign) id<MaterialSelectViewDelegate> delegate;

@end
