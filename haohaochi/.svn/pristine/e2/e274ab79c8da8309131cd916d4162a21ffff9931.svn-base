//
//  VideoUploadManager.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-12-3.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "VideoUploadManager.h"
#import "DWTools.h"

static VideoUploadManager *gVideoUploadManager = nil;

@implementation VideoUploadManager

+ (VideoUploadManager *)Share {
    if (!gVideoUploadManager) {
        gVideoUploadManager = [[VideoUploadManager alloc] init];
    }
    return gVideoUploadManager;
}

- (id)init {
    self = [super init];
    if (self) {
        self.mUploads = [[NSMutableArray alloc] initWithCapacity:10];
        [self addTimer];
    }
    return self;
}

- (void)dealloc {
    self.mUploads = nil;
    [self removeTimer];
}

- (NSString *)GetUploadPath {
    return [kDocumentPath stringByAppendingPathComponent:@"MyVideos"];
}

- (NSString *)GetVideoPath {
    NSString *dirpath = [self GetUploadPath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dirpath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dirpath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd-HH-mm-SS";
    NSString *time = [formatter stringFromDate:[NSDate date]];
    NSString *filename = [NSString stringWithFormat:@"%@.mov", time];
    return [dirpath stringByAppendingPathComponent:filename];
}

- (NSString *)GetThumbPath {
    NSString *dirpath = [self GetUploadPath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dirpath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dirpath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd-HH-mm-SS";
    NSString *time = [formatter stringFromDate:[NSDate date]];
    NSString *filename = [NSString stringWithFormat:@"%@.jpg", time];
    return [dirpath stringByAppendingPathComponent:filename];
}

- (void)AddToVideoList:(NSURL *)url image:(UIImage *)thumb :(DWUploadInfo *)info {
    if (!url) {
        return;
    }
    NSString *videopath = [self GetVideoPath];
    [[NSFileManager defaultManager] moveItemAtPath:url.path toPath:videopath error:nil];
    
    NSString *thumbpath = [self GetThumbPath];
    NSData *data = UIImageJPEGRepresentation(thumb, 0.8);
    [data writeToFile:thumbpath atomically:YES];
    
    [self addVideoFileToUpload:@"美食" video:videopath thumb:thumbpath :info];
}

# pragma mark - processer
- (void)addVideoFileToUpload:(NSString *)tag video:(NSString *)videopath thumb:(NSString *)thumbpath :(DWUploadInfo *)info
{
    info.mThumbPath = thumbpath;
    
    DWUploadItem *item = [[DWUploadItem alloc] init];
    item.videoUploadStatus = DWUploadStatusWait;
    item.videoPath = [item GetFormatPath:videopath];
    item.videoTitle = info.mTitle;
    item.videoTag = tag;
    item.videoDescripton = info.mContent;
    item.videoUploadProgress = 0.0f;
    item.videoUploadedSize = 0;
    item.mVideoInfo = info;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:videopath]) {
        item.videoUploadStatus = DWUploadStatusLoadLocalFileInvalid;
    }
    else {
        NSError *error = nil;
        // 文件不存在则不设置
        item.videoThumbnailPath = thumbpath;
        item.videoFileSize = [DWTools getFileSizeWithPath:videopath Error:&error];
        if (error) {
            item.videoUploadStatus = DWUploadStatusLoadLocalFileInvalid;
            NSLog(@"getFileSizeWithPath failed: %@", [error localizedDescription]);
            item.videoFileSize = 0;
        }
    }
    [self.uploadItems.items addObject:item];
    NSLog(@"add item: %@", item);
    NSLog(@"self.uploadItems.items: %@", self.uploadItems.items);
}

- (void)setUploadBlockWithItem:(DWUploadItem *)item
{
    DWUploader *uploader = item.uploader;
    
    uploader.progressBlock = ^(float progress, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
        item.videoUploadProgress = progress;
        item.videoUploadedSize = totalBytesWritten;
        
        [self updateCellProgress:item];
    };
    
    uploader.finishBlock = ^() {
        NSLog(@"uploader finish；%@", item.uploadContext);
        item.videoUploadStatus = DWUploadStatusFinish;
        [self updateUploadStatus:item];
        
        self.uploadItems.isBusy = NO;
        [self UploadToServer:item];
    };
    
    uploader.failBlock = ^(NSError *error) {
        NSLog(@"error: %@", [error localizedDescription]);
        item.uploader = nil;
        item.videoUploadStatus = DWUploadStatusFail;
        [self updateUploadStatus:item];
        
        self.uploadItems.isBusy = NO;
    };
    
    uploader.pausedBlock = ^(NSError *error) {
        NSLog(@"error: %@", [error localizedDescription]);
        item.videoUploadStatus = DWUploadStatusPause;
        [self updateUploadStatus:item];
        
        self.uploadItems.isBusy = NO;
    };
    
    uploader.videoContextForRetryBlock = ^(NSDictionary *videoContext) {
        NSLog(@"context: %@", videoContext);
        item.uploadContext = videoContext;
    };
}

- (void)videoUploadStartWithItem:(DWUploadItem *)item
{
    NSLog(@"videoUploadStartWithItem");
    item.uploader = [[DWUploader alloc] initWithUserId:DWACCOUNT_USERID
                                                andKey:DWACCOUNT_APIKEY
                                      uploadVideoTitle:item.videoTitle
                                      videoDescription:item.videoDescripton
                                              videoTag:item.videoTag
                                             videoPath:item.videoPath
                                             notifyURL:@"http://www.bokecc.com/"];
    
    item.videoUploadStatus = DWUploadStatusUploading;
    [self updateUploadStatus:item];
    
    DWUploader *uploader = item.uploader;
    
    uploader.timeoutSeconds = 20;
    
    [self setUploadBlockWithItem:item];
    
    [uploader start];
}

- (void)videoUploadResumeWithItem:(DWUploadItem *)item
{
    NSLog(@"videoUploadResumeWithItem");
    if (item.uploadContext) {
        NSMutableDictionary *newdict = [NSMutableDictionary dictionary];
        [newdict setDictionary:item.uploadContext];
        NSString *filepath = [newdict objectForKey:@"filepath"];
        if (filepath) {
            filepath = [item GetFormatPath:filepath];
            [newdict setObject:filepath forKey:@"filepath"];
        }
        
        if (!item.uploader) {
            item.uploader = [[DWUploader alloc] initWithVideoContext:newdict];
        }
        
        item.videoUploadStatus  = DWUploadStatusUploading;
        [self updateUploadStatus:item];
        item.uploader.timeoutSeconds = 20;
        [self setUploadBlockWithItem:item];
        
        [item.uploader resume];
        
        return;
    }
    
    item.uploader = nil;
    [self videoUploadStartWithItem:item];
}

- (void)videoUploadPauseWithItem:(DWUploadItem *)item
{
    if (!item.uploader) {
        return;
    }
    
    [item.uploader pause];
    item.videoUploadStatus = DWUploadStatusPause;
    [self updateUploadStatus:item];
}

- (void)updateUploadStatus:(DWUploadItem *)item {
    NSDictionary *dict = [NSDictionary dictionaryWithObject:item forKey:@"item"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UploadStatus object:nil userInfo:dict];
}

- (void)updateCellProgress:(DWUploadItem *)item {
    NSDictionary *dict = [NSDictionary dictionaryWithObject:item forKey:@"item"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UploadProgress object:nil userInfo:dict];
}

# pragma mark - timer

- (void)addTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerHandler) userInfo:nil repeats:YES];
}

- (void)removeTimer
{
    [self.timer invalidate];
}

- (void)timerHandler
{
    //NSLog(@"self.uploadItems.item count: %ld", (long)self.uploadItems.items.count);
    if (self.uploadItems.isBusy) {
        NSLog(@"busy");
        return;
    }
    
    DWUploadItem *item = nil;
    NSInteger index = 0;
    for (item in self.uploadItems.items) {
        if (item.videoUploadStatus == DWUploadStatusWait) {
            break;
        }
        index++;
    }
    
    if (!item) {
        //NSLog(@"queue is empty");
        return;
    }
    
    // 开始下载
    NSLog(@"upload start item: %@", item);
    
    self.uploadItems.isBusy = YES;
    [self videoUploadStartWithItem:item];
}

- (void)UploadToServer:(DWUploadItem *)item {
    ASIDownManager *down = [[ASIDownManager alloc] init];
    down.delegate = self;
    down.OnImageDown = @selector(OnLoadFinish:);
    down.OnImageFail = @selector(OnLoadFail:);
    
    [self.mUploads addObject:down];
    
    NSString *urlstr = [NSString stringWithFormat:@"%@/mobileapi/video/video_add", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:item.mVideoInfo.mTitle forKey:@"title"];
    [dict setObject:item.mVideoInfo.mContent forKey:@"content"];
    [dict setObject:[NSString stringWithFormat:@"%f", item.mVideoInfo.mLatitude] forKey:@"x"];
    [dict setObject:[NSString stringWithFormat:@"%f", item.mVideoInfo.mLongitude] forKey:@"y"];
    [dict setObject:item.mVideoInfo.mAddress forKey:@"xy_name"];
    [dict setObject:item.mVideoInfo.mCityID forKey:@"cid"];
    [dict setObject:[item.uploadContext objectForKey:@"videoid"] forKey:@"src"];
    [dict setObject:kkUserID forKey:@"uid"];
    [down PostHttpRequest:urlstr :dict :item.mVideoInfo.mThumbPath :@"image"];
}

- (void)TestUpload {
    ASIDownManager *down = [[ASIDownManager alloc] init];
    down.delegate = self;
    down.OnImageDown = @selector(OnLoadFinish:);
    down.OnImageFail = @selector(OnLoadFail:);
    
    [self.mUploads addObject:down];
    
    NSString *thumbpath = [self GetUploadPath];
    thumbpath = [thumbpath stringByAppendingPathComponent:@"2014-12-10-13-46-37.jpg"];
    
    NSString *urlstr = [NSString stringWithFormat:@"%@/mobileapi/video/video_add", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"测试一下" forKey:@"title"];
    [dict setObject:@"测试测试测试测试测试测试测试测试测试测试测试测试" forKey:@"content"];
    [dict setObject:@"40.03" forKey:@"x"];
    [dict setObject:@"116.314" forKey:@"y"];
    [dict setObject:@"北京市海淀区上第七街一号" forKey:@"xy_name"];
    [dict setObject:@"1" forKey:@"cid"];
    [dict setObject:@"FB299624E1F9847F9C33DC5901307461" forKey:@"src"];
    [dict setObject:@"28" forKey:@"uid"];
    [down PostHttpRequest:urlstr :dict :thumbpath :@"image"];
}

- (void)OnLoadFinish:(ASIDownManager *)sender {
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [sender Cancel];
    [self.mUploads removeObject:sender];
    NSLog(@"OnUpLoadFinish:%@", dict);
}

- (void)OnLoadFail:(ASIDownManager *)sender {
    [sender Cancel];
    [self.mUploads removeObject:sender];
    NSLog(@"OnUpLoadFail");
}
@end
