//
//  JYTabBarController.h
//  friendJY
//
//  Created by 高斌 on 15/2/27.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYTabBarController : UITabBarController<UINavigationControllerDelegate>
{
    UIImageView *_tabBarBgImage;
    NSInteger _lastSelectedIndex;
    UIImageView *_messageCountBgImage; //消息右上角红色数字
    UILabel *_messageCountLab;
    UIImageView * _feedNewMsgBgImage;
}

- (void)hiddenTabBar:(BOOL)hidden;

@end
