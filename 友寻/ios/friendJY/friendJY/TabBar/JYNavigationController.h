//
//  JYNavigationController.h
//  friendJY
//
//  Created by 高斌 on 15/2/28.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYNavigationController : UINavigationController
{
    UILabel *_titleLab;
}

- (void)setTitleLabText:(NSString *)title;

@end
