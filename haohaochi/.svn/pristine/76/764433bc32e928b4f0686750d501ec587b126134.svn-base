//
//  VideoStatusManager.h
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-12-12.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoStatusManager : NSObject {
    
}

@property (nonatomic, strong) NSMutableArray *mWantGoArray;
@property (nonatomic, strong) NSMutableArray *mHaveGoArray;

- (BOOL)IsWantGo:(NSString *)videoid;
- (BOOL)IsHaveGo:(NSString *)videoid;
- (void)AddToWantGo:(NSString *)videoid;
- (void)AddToHaveGo:(NSString *)videoid;
- (void)DelWantGo:(NSString *)videoid;
- (void)DelHaveGo:(NSString *)videoid;

@end
