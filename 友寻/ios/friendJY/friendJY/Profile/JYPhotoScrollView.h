//
//  AZXPhotoScrollView.h
//  imAZXiPhone
//
//  Created by coder_zhang on 14-9-10.
//  Copyright (c) 2014年 coder_zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JYPhotoTableView;
@interface JYPhotoScrollView : UIScrollView<UIScrollViewDelegate> {
    UIImageView *_imageView;
}

@property(nonatomic,strong)NSURL *url;

@property(nonatomic,strong) JYPhotoTableView *tableView;
@property(nonatomic,assign) NSInteger row;


@end
