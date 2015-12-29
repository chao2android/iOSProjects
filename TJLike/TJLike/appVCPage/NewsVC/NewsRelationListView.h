//
//  NewsRelationListView.h
//  TJLike
//
//  Created by MC on 15/4/12.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsRelationNewsList.h"

@interface NewsRelationListView : UIView

@property (nonatomic, assign)id mDelegate;
@property (nonatomic, assign)SEL onClick;

- (void)LoadContent:(NewsRelationNewsList *)info;

@end

