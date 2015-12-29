//
//  JYPickEmotionStatusController.h
//  friendJY
//
//  Created by 高斌 on 15/3/5.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYBaseController.h"

@protocol JYPickEmotionStatusDelegate <NSObject>

//完成情感状态的选择
- (void)pickEmotionStatusCompleteWithIndex:(NSNumber *)indexPath;

@end

@interface JYPickEmotionStatusController : JYBaseController<UITableViewDelegate, UITableViewDataSource>
{
    NSDictionary *_emotionStatusDict;
    UITableView *_table;
    //NSIndexPath *_selectedIndexPath;
}

@property (nonatomic, assign) id<JYPickEmotionStatusDelegate> jyDelegate;
@property (nonatomic, assign) NSInteger seleStatues;

@end
