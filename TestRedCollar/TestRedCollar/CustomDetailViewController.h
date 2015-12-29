//
//  CustomDetailViewController.h
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-4.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseADViewController.h"
#import "MaterialSelectView.h"

@interface CustomDetailViewController : BaseADViewController<UIActionSheetDelegate, MaterialSelectViewDelegate> {
    UIButton *mTypeBtn;
    NSTimer *mTimer;
    UIImageView *mImageView;
}

@end
