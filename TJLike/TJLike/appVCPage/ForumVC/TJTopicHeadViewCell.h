//
//  TJTopicHeadViewCell.h
//  TJLike
//
//  Created by IPTV_MAC on 15/4/11.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopicHeadNoticeDelegate <NSObject>

- (void)tapBoticeEvent:(NSString *)strid;

@end

@interface TJTopicHeadViewCell : UITableViewCell

@property (nonatomic, weak) id<TopicHeadNoticeDelegate> delegate;
- (void)bindModel:(id)model;

@end
