//
//  SendCommentView.h
//  TJLike
//
//  Created by MC on 15/4/7.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendCommentView : UIView
{
    UITextView *mTextView;
    UIView *mBackView;
}
@property (nonatomic, strong) NSString *nid;

- (void)HiddenView;
@end
