//
//  UserStatusManager.m
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-8-8.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "UserStatusManager.h"
#import "JSON.h"
#import "FansInfoModel.h"

@implementation UserStatusManager

@synthesize delegate, OnLoadStatus;

- (void)dealloc {
    [self Cancel];
}

#pragma mark - ImageDownManager

- (void)Cancel{
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (void)GetUserStatus:(NSString *)userid {
    if (self.mDownManager) {
        return;
    }
    self.mDownManager = [[ImageDownManager alloc] init];
    self.mDownManager.delegate = self;
    self.mDownManager.OnImageDown = @selector(OnLoadStatusFinish:);
    self.mDownManager.OnImageFail = @selector(OnLoadFail:);

    NSString *urlstr = [NSString stringWithFormat:@"%@club.php", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"getUserInfo" forKey:@"act"];
    [dict setObject:userid forKey:@"userid"];
    [dict setObject:kkUserID forKey:@"mineuserid"];
    
    [self.mDownManager PostHttpRequest:urlstr :dict];
}

- (void)OnLoadStatusFinish:(ImageDownManager *)sender {
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = [dict objectForKey:@"list"];
        FansInfoModel *model = [[FansInfoModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        self.mbNotice = [model.isfollow boolValue];
        if (delegate && OnLoadStatus) {
            SafePerformSelector([delegate performSelector:OnLoadStatus withObject:self]);
        }
    }
}

- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}

@end
