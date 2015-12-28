//
//  VideoStatusManager.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-12-12.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "VideoStatusManager.h"

@implementation VideoStatusManager

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSDictionary *)GetVideoInfo:(NSArray *)array :(NSString *)videoid {
    NSString *userid = kkUserID;
    for (NSDictionary *dict in array) {
        NSString *tmpvideoid = [dict objectForKey:@"vid"];
        NSString *tmpuserid = [dict objectForKey:@"uid"];
        if ([tmpuserid isEqualToString:userid] && [tmpvideoid isEqualToString:videoid]) {
            return dict;
        }
    }
    return nil;
}

- (void)AddToWantGo:(NSString *)videoid {
    NSDictionary *dict = [self GetVideoInfo:self.mWantGoArray :videoid];
    if (dict) {
        return;
    }
    [self.mWantGoArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:videoid, @"vid", kkUserID, @"uid", nil]];
}

- (void)AddToHaveGo:(NSString *)videoid {
    NSDictionary *dict = [self GetVideoInfo:self.mHaveGoArray :videoid];
    if (dict) {
        return;
    }
    [self.mHaveGoArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:videoid, @"vid", kkUserID, @"uid", nil]];
}

- (void)DelWantGo:(NSString *)videoid {
    NSDictionary *dict = [self GetVideoInfo:self.mWantGoArray :videoid];
    if (dict) {
        [self.mWantGoArray removeObject:dict];
    }
}

- (void)DelHaveGo:(NSString *)videoid {
    NSDictionary *dict = [self GetVideoInfo:self.mWantGoArray :videoid];
    if (dict) {
        [self.mHaveGoArray removeObject:dict];
    }
}

- (BOOL)IsWantGo:(NSString *)videoid {
    NSDictionary *dict = [self GetVideoInfo:self.mWantGoArray :videoid];
    if (dict) {
        return YES;
    }
    return NO;
}

- (BOOL)IsHaveGo:(NSString *)videoid {
    NSDictionary *dict = [self GetVideoInfo:self.mHaveGoArray :videoid];
    if (dict) {
        return YES;
    }
    return NO;
}

@end
