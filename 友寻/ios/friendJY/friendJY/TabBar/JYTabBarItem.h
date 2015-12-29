//
//  AZXTabBarItem.h
//  imAZXiPhone
//
//  Created by 高 斌 on 14-7-21.
//  Copyright (c) 2014年 高 斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYTabBarItem : UIControl
{
    UIImageView *_itemImage;
}

- (id)initWithFrame:(CGRect)frame
        normalImage:(NSString *)normalImage
   highlightedImage:(NSString *)highlightedImage
              title:(NSString *)title;

@end
