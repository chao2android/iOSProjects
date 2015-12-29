//
//  PhotoScrollView.h
//  TJLike
//
//  Created by MC on 15-4-1.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsListInfo.h"

@interface PhotoScrollView : UIView<UIScrollViewDelegate>

@property (nonatomic, strong)NewsListInfo *mlInfo;
@property (nonatomic, strong)NSString *curPageText;

@end
