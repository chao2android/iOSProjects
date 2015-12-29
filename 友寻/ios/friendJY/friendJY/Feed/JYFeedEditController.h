//
//  JYFeedEditController.h
//  friendJY
//
//  Created by ouyang on 3/31/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//

#import "JYBaseController.h"
#import "JYFeedModel.h"
typedef void(^RefreshFeedList)(JYFeedModel *mFeedModel);

@interface JYFeedEditController : JYBaseController <UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UIAlertViewDelegate>

@property(nonatomic,strong) NSString *content;
@property(nonatomic,strong) UIImage *picImage;//图片数组里面存image对象
@property(nonatomic,strong) NSString *picId;//图片id
@property(nonatomic,assign) NSInteger formId;//1-动态过来，2-个人资料，3-查看图片

@property(nonatomic, copy) RefreshFeedList refreshFeedListBlock;
@end
