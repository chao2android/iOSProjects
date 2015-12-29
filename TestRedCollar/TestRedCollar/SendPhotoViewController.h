//
//  SendPhotoViewController.h
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseADViewController.h"

@interface SendPhotoViewController : BaseADViewController<UITextViewDelegate> {
    UITextView *mTextView;
    UILabel *mlbDesc;
    UIImageView *mImageView;
}

@property (nonatomic, strong) UIImage *mImage;

@end
