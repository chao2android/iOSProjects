//
//  PopAlertView.h
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-12-4.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopAlertView : UIView {
    UIImageView *mImageView;
    CGPoint mCenter;
}

- (void)ShowAlert:(NSString *)alertImage;

@end
