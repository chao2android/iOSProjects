//
//  CitySelectView.h
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-11-20.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDownManager.h"

@interface CitySelectView : UIView {
    UIScrollView *mScrollView;
}

@property (nonatomic, strong) NSString *mCity;
@property (nonatomic, strong) NSMutableArray *mArray;
@property (nonatomic, strong) ImageDownManager *mDownManager;

- (void)RefreshView;

@end