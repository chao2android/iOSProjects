//
//  JYChatGetLocalPhoto.h
//  friendJY
//
//  Created by ouyang on 6/11/15.
//  Copyright (c) 2015 友寻. All rights reserved.
//

#import "JYBaseController.h"
#import "JYGroupImageCell.h"

@class JYChatGetLocalPhoto;

@protocol JYChatGetLocalPhotoDelegate <NSObject>

@required

- (void)JYChatLocalPhotoSelected:(JYChatGetLocalPhoto *)chatLocalPhoto selectedImage:(JYLocalImageModel *)imageModel;

@optional


@end

@interface JYChatGetLocalPhoto : JYBaseController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id<JYChatGetLocalPhotoDelegate> delegate;

@end
