//
//  ZTListVIew.h
//  TJLike
//
//  Created by MC on 15/4/9.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsListInfo.h"

@interface ZTListVIew : UIView



@property (nonatomic, strong)NewsListInfo *info;
@property (nonatomic, assign)id mDelegate;
@property (nonatomic, assign)SEL onClick;

- (void)LoadContent:(NewsListInfo *)info;

@end
