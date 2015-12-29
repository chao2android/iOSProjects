//
//  AZXGroupImageCell.h
//  imAZXiPhone
//
//  Created by 高 斌 on 14-8-12.
//  Copyright (c) 2014年 高 斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYLocalImageModel.h"

@interface JYGroupImageCell : UICollectionViewCell
{
    UIImageView *_imageView;
}

@property (nonatomic, strong) UIButton *checkmarkBtn;

- (void)layoutWithModel:(JYLocalImageModel *)localImageModel;

@end
