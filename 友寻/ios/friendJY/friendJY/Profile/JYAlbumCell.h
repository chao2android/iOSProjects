//
//  AZXGroupImageCell.h
//  imAZXiPhone
//
//  Created by 高 斌 on 14-8-12.
//  Copyright (c) 2014年 高 斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYAlbumModel.h"

@interface JYAlbumCell : UICollectionViewCell
{
//    UIImageView *_imageView;
}
@property (nonatomic, strong) UIImageView *imageView;

- (void)layoutWithModel:(JYAlbumModel *)localImageModel;

@end
