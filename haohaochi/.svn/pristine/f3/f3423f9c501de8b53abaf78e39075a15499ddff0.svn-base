//
//  ShareMethod.h
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-12-11.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageDownManager.h"
#import "VideoListModel.h"

@class ShareMethod;

@protocol ShareMethodDelegate <NSObject>

@optional

- (void)OnHaveGoStart:(ShareMethod *)sender;
- (void)OnWantGoStart:(ShareMethod *)sender;
- (void)OnShareMethodFinish:(ShareMethod *)sender;

@end

@interface ShareMethod : NSObject {
    
}

@property (nonatomic, assign) id<ShareMethodDelegate> delegate;
@property (nonatomic, strong) VideoListModel *mModel;
@property (nonatomic, strong) ImageDownManager *mDownManager;

- (void)Report:(NSString *)videoid;
- (void)HaveGo:(VideoListModel *)model;
- (void)WantGo:(VideoListModel *)model;

+ (ShareMethod *)Share;

@end
