//
//  JYProfileEditDetailController.h
//  friendJY
//
//  Created by chenxiangjing on 15/4/7.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYBaseController.h"

@protocol JYProfileDelegate <NSObject>

@optional

- (void)careerDidSelectedStudent:(BOOL)isStu;//当职业选择学生时需要修改
//- (void)postDataToHttp:(NSDictionary*)dataDic;//上传数据到服务器
- (void)modifyContentTextWithEditType:(int)editType content:(NSString*)contentText andNewProfileDic:(NSDictionary*)profileDic;//刷新当前更新Label

@end


@interface JYProfileEditDetailController : JYBaseController

@property (nonatomic, assign) int editType;//当前编辑类别

@property (nonatomic, strong) NSMutableDictionary * profileDataDic;

@property (nonatomic, copy) NSString *contentText;

@property (nonatomic, assign) id<JYProfileDelegate> delegate;

//@property (nonatomic, copy) block

@end
