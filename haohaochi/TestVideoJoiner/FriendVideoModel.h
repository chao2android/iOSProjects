//
//  FriendVideoModel.h
//  TestVideoJoiner
//
//  Created by MC on 14-12-1.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendVideoModel : NSObject

@property (nonatomic, strong) NSString *headPic;
@property (nonatomic, strong) NSString *goodCount;
@property (nonatomic, strong) NSString *foodName;
@property (nonatomic, strong) NSString *videoPic;
@property (nonatomic, assign) BOOL isLike;
@property (nonatomic, assign) BOOL isFavorite;
@property (nonatomic, strong) NSString *type;

@end
