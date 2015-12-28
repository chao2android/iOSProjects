//
//  ShowWantGoView.h
//  TestVideoJoiner
//
//  Created by MC on 14-12-4.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowWantGoView : UIView {
    UIImageView *mBotView;
}

@property (nonatomic, retain)UIImageView *titlePic;
@property (nonatomic, retain)UILabel *titleLabel;
@property (nonatomic, retain)UIImageView *mFlagView;


+(void)ShowWantGo;
+(void)ShowHaveGo:(BOOL)love;

@end
