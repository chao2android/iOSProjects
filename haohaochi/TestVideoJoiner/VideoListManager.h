//
//  VideoListManager.h
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-11-12.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoListManager : NSObject {
    
}

@property (nonatomic, strong) NSMutableArray *mArray;

+ (VideoListManager *)Share;
- (void)AddVideoToList:(NSArray *)array index:(int)index;
- (NSArray *)VideosAtIndex:(int)index;
- (UIImage *)ThumbAtIndex:(int)index;
- (UIImage *)SubThumbAtIndex:(int)index subindex:(int)subindex;
- (int)GetTotalSeconds:(int)index;
- (BOOL)HasAllVideo;
- (NSArray *)GetAllVideos;
- (NSArray *)GetAllVideos2;
- (void)CleanVideos;
- (void)DelVideoAtIndex:(int)index subindex:(int)subindex;

@end
