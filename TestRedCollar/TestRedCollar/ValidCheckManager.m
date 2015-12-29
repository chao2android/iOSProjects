//
//  ValidCheckManager.m
//  Test1510Cloud
//
//  Created by Hepburn Alex on 13-10-22.
//  Copyright (c) 2013年 Hepburn Alex. All rights reserved.
//

#import "ValidCheckManager.h"
#import "JSON.h"

static ValidCheckManager *gCheckManager = nil;

@implementation ValidCheckManager

@synthesize mbInvalid;

+ (ValidCheckManager *)Share {
    if (!gCheckManager) {
        gCheckManager = [[ValidCheckManager alloc] init];
    }
    return gCheckManager;
}

- (id)init {
    self = [super init];
    if (self) {
        mbInvalid = NO;
    }
    return self;
}

- (void)dealloc {
    [self Cancel];
    [super dealloc];
}

- (void)Cancel {
    if (mDownManager) {
        mDownManager.delegate = nil;
        [mDownManager Cancel];
        [mDownManager release];
        mDownManager = nil;
    }
}

- (void)OnLoadSuccess:(ImageDownManager *)sender {
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    NSLog(@"%@", dict);
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSNumber *result = [dict objectForKey:@"result"];
        if (result) {
            if ([result intValue] == 1) {
                mbInvalid = NO;
            }
            else {
                mbInvalid = YES;
            }
        }
    }
}

- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}

- (void)CheckValid {
    if (mDownManager) {
        return;
    }
    mDownManager = [[ImageDownManager alloc] init];
    mDownManager.delegate = self;
    mDownManager.OnImageDown = @selector(OnLoadSuccess:);
    mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    [mDownManager GetImageByStr:@"http://115.28.37.140/jiaoyan/rctailor_jiaoyan.php"];
}


@end
