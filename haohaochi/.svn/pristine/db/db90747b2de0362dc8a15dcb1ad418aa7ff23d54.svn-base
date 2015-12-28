//
//  ShareMethod.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-12-11.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ShareMethod.h"
#import "JSON.h"
#import "ShowChoiceView.h"
#import "ShowWantGoView.h"

static ShareMethod *gShareMethod = nil;

@implementation ShareMethod

+ (ShareMethod *)Share {
    if (!gShareMethod) {
        gShareMethod = [[ShareMethod alloc] init];
    }
    return gShareMethod;
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - ImageDownManager

- (void)Cancel {
    if (self.delegate && [self.delegate respondsToSelector:@selector(OnShareMethodFinish:)]) {
        [self.delegate OnShareMethodFinish:self];
    }
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}

#pragma mark - 举报

- (void)Report:(NSString *)videoid {
    if (_mDownManager) {
        return;
    }
    self.mDownManager = [[ImageDownManager alloc] init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnReportFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    NSString *urlstr = [NSString stringWithFormat:@"%@/mobileapi/video/zan", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:videoid forKey:@"v_id"];
    [dict setObject:kkUserID forKey:@"u_id"];
    [_mDownManager PostHttpRequest:urlstr :dict];
}

- (void)OnReportFinish:(ImageDownManager *)sender {
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSLog(@"%@", dict);
        int iStatus = [[dict objectForKey:@"status"] intValue];
        if (iStatus == 1001) {
            [AutoAlertView ShowAlert:@"提示" message:@"举报成功"];
        }
        else {
            [AutoAlertView ShowAlert:@"提示" message:@"举报失败"];
        }
    }
}

#pragma mark - 加去过

- (void)HaveGo:(VideoListModel *)model {
    self.mModel = model;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    ShowChoiceView *view = [[ShowChoiceView alloc]initWithFrame:window.bounds];
    view.delegate = self;
    view.OnChoose = @selector(YesOrNo:);
    [window addSubview:view];
}

- (void)YesOrNo:(ShowChoiceView *)sender {
    if(_mDownManager){
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(OnHaveGoStart:)]) {
        [self.delegate OnHaveGoStart:self];
    }
    _mDownManager = [[ImageDownManager alloc] init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnAddHaveGoFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    _mDownManager.userInfo = [NSNumber numberWithInt:sender.miIndex];
    
    NSString *urlstr = [NSString stringWithFormat:@"%@/mobileapi/user/User_video_qu_add", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:kkUserID forKey:@"u_id"];
    [dict setObject:self.mModel.m_id forKey:@"v_id"];
    [dict setObject:[NSString stringWithFormat:@"%d",sender.miIndex] forKey:@"love"];
    [_mDownManager GetHttpRequest:urlstr :dict];
}

- (void)OnAddHaveGoFinish:(ImageDownManager *)sender{
    NSDictionary *dict = [sender.mWebStr JSONValue];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSLog(@"%@", dict);
        int iStatus = [[dict objectForKey:@"status"] intValue];
        if (iStatus == 1001) {
            self.mModel.type = @"2";
            [ShowWantGoView ShowHaveGo:([sender.userInfo intValue] == 1)];
        }
        else if (iStatus == 1002){
            [AutoAlertView ShowAlert:@"提示" message:dict[@"error"]];
        }
    }
    [self Cancel];
}

#pragma mark - 加想去
- (void)WantGo:(VideoListModel *)model {
    self.mModel = model;
    if(_mDownManager){
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(OnWantGoStart:)]) {
        [self.delegate OnWantGoStart:self];
    }
    _mDownManager = [[ImageDownManager alloc] init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnAddWantGoFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *urlstr = [NSString stringWithFormat:@"%@/mobileapi/user/User_video_xiang_add", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:kkUserID forKey:@"u_id"];
    [dict setObject:model.m_id forKey:@"v_id"];
    [_mDownManager GetHttpRequest:urlstr :dict];
}

- (void)OnAddWantGoFinish:(ImageDownManager *)sender{
    NSDictionary *dict = [sender.mWebStr JSONValue];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSLog(@"%@", dict);
        int iStatus = [[dict objectForKey:@"status"] intValue];
        if (iStatus == 1001) {
            self.mModel.type = @"1";
            [ShowWantGoView ShowWantGo];
        }
        else if (iStatus == 1002){
            [AutoAlertView ShowAlert:@"提示" message:dict[@"error"]];
        }
    }
    [self Cancel];
}

@end
