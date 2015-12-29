//
//  JYProfileEditIntroController.h
//  friendJY
//
//  Created by ouyang on 3/19/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//

#import "JYBaseController.h"

@protocol JYProfileIntroDidChangedDelegate <NSObject>
@required
- (void)profileIntroDidChanged:(NSString*)newIntro;

@end

@interface JYProfileEditIntroController : JYBaseController<UITextViewDelegate>

@property (nonatomic, assign) id<JYProfileIntroDidChangedDelegate>delegate;
@end
