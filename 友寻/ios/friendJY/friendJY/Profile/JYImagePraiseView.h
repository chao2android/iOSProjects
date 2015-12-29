//
//  JYImagePraiseView.h
//  friendJY
//
//  Created by aaa on 15/7/2.
//  Copyright (c) 2015年 友寻. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYImagePraiseModel.h"

typedef void(^PraiseFinish)();
typedef void(^CanclePraiseFinish)();
typedef void (^AvaClick)(NSInteger uid);

@interface JYImagePraiseView : UIView

@property (nonatomic, strong)JYImagePraiseModel *praiseModel;
@property (nonatomic, copy) PraiseFinish praiseFinishBlock;
@property (nonatomic, copy) CanclePraiseFinish canclePraiseBlock;
@property (nonatomic, copy) AvaClick avaClickBlock;
@property (nonatomic, strong) NSString *fuid;

@end
