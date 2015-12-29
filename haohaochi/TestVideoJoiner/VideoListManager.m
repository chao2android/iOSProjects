//
//  VideoListManager.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-11-12.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "VideoListManager.h"
#import "MediaSelectManager.h"
#import "VideoUrlInfo.h"

static VideoListManager *gVideoListManager = nil;

@implementation VideoListManager

+ (VideoListManager *)Share {
    if (!gVideoListManager) {
        gVideoListManager = [[VideoListManager alloc] init];
    }
    return gVideoListManager;
}

- (void)CleanVideos {
    self.mArray = [[NSMutableArray alloc] initWithCapacity:10];
    for (int i = 0; i < 5; i ++) {
        [self.mArray addObject:[NSMutableDictionary dictionary]];
    }
}

- (id)init {
    self = [super init];
    if (self) {
        self.mArray = [[NSMutableArray alloc] initWithCapacity:10];
        for (int i = 0; i < 5; i ++) {
            [self.mArray addObject:[NSMutableDictionary dictionary]];
        }
    }
    return self;
}

- (void)dealloc {
    self.mArray = nil;
}

- (NSArray *)GetAllVideos2 {
    NSMutableArray *newarray = [NSMutableArray arrayWithCapacity:10];
    int index = 0;
    for (NSDictionary *dict in self.mArray) {
        NSArray *tmparray = [dict objectForKey:@"videos"];
        for (NSDictionary *tmpdict in tmparray) {
            VideoUrlInfo *info = [[VideoUrlInfo alloc] init];
            info.mUrl = [tmpdict objectForKey:@"url"];
            info.mfTime = [[tmpdict objectForKey:@"time"] floatValue];
            info.mfStartTime = [[tmpdict objectForKey:@"starttime"] floatValue];
            if (index == 0 || index == 2 || index == 4) {
                info.mbSoundLow = YES;
            }
            [newarray addObject:info];
        }
        index ++;
    }
    return newarray;
}

- (NSArray *)GetAllVideos {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    for (NSDictionary *dict in self.mArray) {
        NSArray *tmparray = [dict objectForKey:@"videos"];
        if (tmparray) {
            for (NSDictionary *tmpdict in tmparray) {
                [array addObject:[tmpdict objectForKey:@"url"]];
            }
        }
    }
    return array;
}

- (int)GetTotalSeconds:(int)index {
    NSArray *array =  [self VideosAtIndex:index];
    float fSecond = 0;
    for (NSDictionary *dict in array) {
        float fTime = [[dict objectForKey:@"time"] floatValue];
        fSecond += fTime;
    }
    return fSecond;
}

- (NSArray *)VideosAtIndex:(int)index {
    NSMutableDictionary *dict = [self.mArray objectAtIndex:index];
    return [dict objectForKey:@"videos"];
}

- (UIImage *)ThumbAtIndex:(int)index {
    NSMutableDictionary *dict = [self.mArray objectAtIndex:index];
    return [dict objectForKey:@"thumb"];
}

- (UIImage *)SubThumbAtIndex:(int)index subindex:(int)subindex {
    NSMutableDictionary *dict = [self.mArray objectAtIndex:index];
    NSArray *array = [dict objectForKey:@"videos"];
    if (subindex < array.count && subindex >= 0) {
        NSDictionary *tmpdict = [array objectAtIndex:subindex];
        NSURL *url = [tmpdict objectForKey:@"url"];
        return [MediaSelectManager GetSnapshotOfVideo:url.path];
    }
    return nil;
}

- (void)DelVideoAtIndex:(int)index subindex:(int)subindex {
    NSMutableDictionary *dict = [self.mArray objectAtIndex:index];
    NSMutableArray *array = [dict objectForKey:@"videos"];
    if (subindex < array.count && subindex >= 0) {
        NSDictionary *tmpdict = [array objectAtIndex:subindex];
        [array removeObject:tmpdict];
        if (array.count == 0) {
            [dict removeObjectForKey:@"thumb"];
        }
    }
}

- (BOOL)HasAllVideo {
    for (int i = 0; i < 5; i ++) {
        NSArray *array = [self VideosAtIndex:i];
        if (!array) {
            return NO;
        }
    }
    return YES;
}

- (void)AddVideoToList:(NSArray *)array index:(int)index {
    if (index < 0 || index >= self.mArray.count) {
        return;
    }
    if (!array || array.count == 0) {
        return;
    }
    NSDictionary *tmpdict = [array objectAtIndex:0];
    NSURL *url = [tmpdict objectForKey:@"url"];
    UIImage *image = [MediaSelectManager GetSnapshotOfVideo:url.path];
    NSMutableDictionary *dict = [self.mArray objectAtIndex:index];
    [dict setObject:array forKey:@"videos"];
    if (image) {
        [dict setObject:image forKey:@"thumb"];
    }
}

@end
