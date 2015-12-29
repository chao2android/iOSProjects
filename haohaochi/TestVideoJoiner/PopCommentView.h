//
//  PopCommentView.h
//  TestHebei
//
//  Created by Hepburn Alex on 14-6-19.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDownManager.h"
#import "BaseADView.h"

@interface PopCommentView : BaseADView<UIActionSheetDelegate> {
    UIView *mPopView;
    UITextView *mTextView;
}

@property (nonatomic, strong) NSString *mVideoID;
@property (nonatomic, strong) ImageDownManager *mDownManager;

@end
