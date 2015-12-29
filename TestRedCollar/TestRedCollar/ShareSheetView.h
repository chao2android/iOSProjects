//
//  ShareSheetView.h
//  TestHebei
//
//  Created by Hepburn Alex on 14-6-18.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocial.h"

@interface ShareSheetView : UIView<UMSocialUIDelegate> {
    UIView *shareView;
}

@property (nonatomic, strong) NSArray *mPlatforms;
@property (nonatomic, strong) NSString *mShareUrl;
@property (nonatomic, strong) NSString *mContent;
@property (nonatomic, strong) UIImage *mImage;
@property (nonatomic, assign) UIViewController *mRootCtrl;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL OnShareFinish;

@end
