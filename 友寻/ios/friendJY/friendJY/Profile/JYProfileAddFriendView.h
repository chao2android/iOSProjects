//
//  JYProfileAddFriendView.h
//  friendJY
//
//  Created by chenxiangjing on 15/6/11.
//  Copyright (c) 2015年 友寻. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface JYProfileAddFriendView : UIView
{
@private
    UIView *_contentView;
}

@property (nonatomic, copy) void (^AddFriendBlock)();
@property (nonatomic, copy) void (^RemoveBlock)();

- (void)show;
- (void)remove;

@end
