//
//  CoolCommentView.h
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-5.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoolCommentView : UIView<UITextViewDelegate> {
    UITextView *mTextView;
    UILabel *mlbDesc;
    UIView *mBackView;
}
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL sendClick;
@end
