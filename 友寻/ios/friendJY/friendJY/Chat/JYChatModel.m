//
//  JYChatModel.m
//  friendJY
//
//  Created by 高斌 on 15/3/23.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYChatModel.h"

@implementation JYChatModel

- (NSDictionary*)attributeMapDictionary
{
    
    NSDictionary *mapAtt = @{
                             @"iid"         : @"iid",
                             @"msgType"     : @"msgType",
                             @"avatar"      : @"avatar",
                             @"chatMsg"     : @"chatMsg",
                             @"fromUid"     : @"fromUid",
                             @"nick"        : @"nick",
                             @"msgFrom"     : @"msgFrom",
                             @"sex"         : @"sex",
                             @"time"        : @"time",
                             @"sendStatus"  : @"sendStatus",
                             @"readStatus"  : @"readStatus",
                             @"fileUrl"     : @"fileUrl",
                             @"voiceLength" : @"voiceLength",
                             @"imgWidth"    : @"imgWidth",
                             @"imgHeight"   : @"imgHeight",
                             @"sendType"    : @"sendType",
                             @"ext"         : @"ext",
                             @"is_sys_tip"  : @"is_sys_tip"
                             };
//    content = "\U6536\U5230\U4e00\U6761\U8bed\U97f3";
//    ext =             {
//        dur = 5;
//        uid = 2090850;
//        vid = 298750;
//        voice = "http://p.friendly.dev/09/08/fa75cfc3dec2753c75b0c2bf303429d9_chat/voice_MjA5MDg1MHwyOTg3NTB8dm9pY2UuaXlvdXh1bi5jb20..amr";
//    };
//    iid = 3675150;
//    msgtype = 2;
//    oid = 2157450;
//    sendtime = 1431942432;
//    status = 0;
//    type = 2;

    return mapAtt;
}

@end
