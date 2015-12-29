//
//  WTVHomePosterView.h
//  WiseTV
//
//  Created by littlezl on 14-9-25.
//  Copyright (c) 2014年 tjgdMobilez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTVHomePosterView : UIView

/**
 *  显示海报详细信息
 */
@property (nonatomic, strong) RACCommand *showPosterDetailCommand;

/**
 *  根据海报信息列表，创建海报页面并返回
 *
 *  @param posterInfoArr 海报信息列表
 *  @param frame         海报尺寸
 *
 *  @return 海报视图
 */
-(UIView *)posterViewWithInfo:(NSArray *)posterInfoArr withFrame:(CGRect)frame;

/**
 *  海报开始滚动，view appear时启动
 */
-(void)timerStart;
/**
 *  海报停止滚动，view disappear时停止
 */
-(void)timerStop;

@end
