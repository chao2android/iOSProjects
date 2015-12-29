//
//  ADLoadManager.h
//  好妈妈
//
//  Created by Hepburn Alex on 14-5-15.
//  Copyright (c) 2014年 iHope. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageDownManager.h"
#import "NetImageView.h"

@interface ADLoadManager : NSObject {
    ImageDownManager *mDownManager;
    NetImageView *mImageView;
}

@property (nonatomic, assign) BOOL mbDefaultAD;
@property (nonatomic, assign) NSString *mADUrlStr;
@property (nonatomic, readonly) UIImage *mADImage;
@property (nonatomic, readonly) CGRect mADFrame;

+ (ADLoadManager *)Share;
- (void)GetADImage;
- (CGRect)GetADFrame;

@end
