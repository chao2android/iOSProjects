//
//  WTVEnlargeView.h
//  WTVPhotoDemo
//
//  Created by IPTV_MAC on 15/2/13.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTVEnlargeView : UIView

-(instancetype)initLargeImageWithStartPoint:(CGPoint)point largeImageUrl:(NSString *)largeImageUrl andPlaceholderImage:(UIImage *)showImage;
- (void)showLargeView;
@end
