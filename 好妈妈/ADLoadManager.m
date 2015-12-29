//
//  ADLoadManager.m
//  好妈妈
//
//  Created by Hepburn Alex on 14-5-15.
//  Copyright (c) 2014年 iHope. All rights reserved.
//

#import "ADLoadManager.h"
#import "UserLocationManager.h"
#import "JSON.h"

static ADLoadManager *gADManager = nil;

@implementation ADLoadManager

@synthesize mADUrlStr;

+ (ADLoadManager *)Share {
    if (!gADManager) {
        gADManager = [[ADLoadManager alloc] init];
    }
    return gADManager;
}

- (void)setMADUrlStr:(NSString *)value {
    if (!value || value.length>0) {
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"adurl"];
    }
}

- (NSString *)mADUrlStr {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"adurl"];
}

- (UIImage *)mADImage {
    NSString *urlstr = self.mADUrlStr;
    if (urlstr) {
        NSString *localpath = [NetImageView GetLocalPathOfUrl:urlstr];
        if (localpath && localpath.length>0) {
            UIImage *image = [UIImage imageWithContentsOfFile:localpath];
            if (image) {
                self.mbDefaultAD = NO;
                return image;
            }
        }
    }
    self.mbDefaultAD = YES;
    return [UIImage imageNamed:@"tu@2x"];
}

- (id)init {
    self = [super init];
    if (self) {
        self.mbDefaultAD = YES;
    }
    return self;
}

- (void)dealloc {
    [self Cancel];
    [self DeleteImageView];
    [super dealloc];
}

- (void)Cancel {
    SAFE_CANCEL(mDownManager);
}

- (void)GetADImage {
    if (mDownManager) {
        return;
    }
    //屏幕尺寸
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    NSLog(@"print %f,%f",width,height);
    
    //分辨率
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    width *= scale_screen;
    height *= scale_screen;

    NSString *urlstr = [NSString stringWithFormat:@"%@getadvertlist?lat=%f&lng=%f&h=%d&w=%d", SERVER_URL, kLat, kLng, (int)height, (int)width];
    mDownManager = [[ImageDownManager alloc] init];
    mDownManager.delegate = self;
    mDownManager.OnImageDown = @selector(OnLoadSuccess:);
    mDownManager.OnImageFail = @selector(OnLoadFail:);
    [mDownManager GetImageByStr:urlstr];
}

- (void)OnLoadSuccess:(ImageDownManager *)sender {
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSString *urlstr = [dict objectForKey:@"image"];
        if (urlstr && urlstr.length>0) {
            NSLog(@"GetADImage Finish");
            self.mADUrlStr = urlstr;
            mImageView = [[NetImageView alloc] init];
            mImageView.delegate = self;
            mImageView.OnImageLoad = @selector(DeleteImageView);
            [mImageView GetImageByStr:self.mADUrlStr];
        }
    }
}

- (void)DeleteImageView {
    if (mImageView) {
        mImageView.delegate = nil;
        [mImageView release];
        mImageView = nil;
    }
}

- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}

- (CGRect)mADFrame {
    int iWidth = Screen_Width;
    int iHeight = Screen_Height;
    if (self.mADImage) {
        CGSize size = self.mADImage.size;
        iWidth = iHeight*size.width/size.height;
        if (iWidth<Screen_Width) {
            iWidth = Screen_Width;
            iHeight = iWidth*size.height/size.width;
        }
    }
    return CGRectMake((Screen_Width-iWidth)/2, (Screen_Height-iHeight)/2, iWidth, iHeight);
}

/*
 //apptest.mum360.com/web/home/index/getadvertlist?lat=&lng=&type&
 
 参数说明   type  1 图片576*960  2 图片720*1280     3图片768*1024
 Lat  纬度
 Lng  经度
 */

@end
