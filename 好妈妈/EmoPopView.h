//
//  EmoPopView.h
//  TestPinBang
//
//  Created by Hepburn Alex on 13-6-13.
//  Copyright (c) 2013年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmoPopView : UIImageView {
    UIImageView *mEmoView;
    UILabel *mlbName;
}

@property (readonly) UIImageView *mEmoView;
@property (readonly) UILabel *mlbName;

@end
