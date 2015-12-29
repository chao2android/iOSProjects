//
//  VideoUploadManager.h
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-12-3.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIDownManager.h"
#import "DWUploadInfo.h"

@interface VideoUploadManager : NSObject {
    
}
@property (strong, nonatomic) NSMutableArray *mUploads;
@property (strong, nonatomic) DWUploadItems *uploadItems;
@property (strong, nonatomic)NSTimer *timer;

+ (VideoUploadManager *)Share;

- (void)AddToVideoList:(NSURL *)url image:(UIImage *)thumb :(DWUploadInfo *)info;

- (void)TestUpload;

- (void)videoUploadResumeWithItem:(DWUploadItem *)item;
- (void)videoUploadStartWithItem:(DWUploadItem *)item;
- (void)videoUploadPauseWithItem:(DWUploadItem *)item;
- (void)setUploadBlockWithItem:(DWUploadItem *)item;

#define kVideoUpload [VideoUploadManager Share]
#define DWUploadItemPlistFilename @"DWUpload.plist"

@end
