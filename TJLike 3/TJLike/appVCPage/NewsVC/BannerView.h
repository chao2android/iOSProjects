//
//  BannerView.h
//  TJLike
//
//  Created by MC on 15-3-30.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsBannerInfo.h"

@interface BannerView : UIView

@property(nonatomic, assign)id delegate;
@property(nonatomic, assign)SEL OnClick;
@property(nonatomic, strong)NewsBannerInfo *mInfo;

- (void)LoadContent:(NewsBannerInfo *)info;

@end
