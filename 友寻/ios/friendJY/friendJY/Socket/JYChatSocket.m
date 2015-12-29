//
//  IMChatSocket.m
//  JiaYuan
//
//  Created by lixiaopeng on 11-10-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "JYChatSocket.h"
#import "JYEncrypt.h"
#import "Reachability.h"
#import "NSDictionary+Additions.h"
//#import "UserManage.h"
//#import "CJSONDeserializer.h"
//#import "Common.h"

#define SocketTest 0

@implementation JYChatSocket


- (void)reachabilityChanged:(NSNotification* )note
{
	Reachability* curReach = [note object];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    
    switch (netStatus)
    {
        case NotReachable:
        {
            break;
        }
        case ReachableViaWWAN:
        case ReachableViaWiFi:
        {
            //NSLog(@"net can  use");
            [self startWork];
            break;
        }
    }    
}

- (void)initWithData {

    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector: @selector(reachabilityChanged:) 
                                                 name: kReachabilityChangedNotification 
                                               object: nil];
}

- (id)init {
    
    self = [super init];
    if (self) {
        [self initWithData];
    }
    return self;
}


- (void)dealloc {
    
    [self stopWork];
    self.autoRefreshTimer = nil;
    
    [_asyncSocket release];
    _asyncSocket = nil;
    
    [super dealloc];
}

- (BOOL)isConnected
{
    return [self.asyncSocket isConnected];
}

- (void)dealReceiveMessage:(NSDictionary *)dictionary {
    
//    NSLog(@"dealReceiveMessage:%@",dictionary);
    if ([_jyDelegate respondsToSelector:@selector(dealSocketReceiveMsg:)]) {
        [_jyDelegate performSelector:@selector(dealSocketReceiveMsg:) withObject:dictionary];
    }
}

- (BOOL)sendMessage:(NSString*)msgStr {
    
    NSData *data = [msgStr dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger len = [data length];
    NSUInteger len2 = htonl(len);
    NSData *lenData = [NSData dataWithBytes:(char *)&len2 length:sizeof(len2)];

    if ([self.asyncSocket isConnected]) {
        
        [self.asyncSocket writeData:lenData withTimeout:-1 tag:11];
        [self.asyncSocket writeData:data withTimeout:-1 tag:11];
        return YES;
        
    } else {
        
        [self startWork];
        return NO;
    }
}

- (void)startWork {
    
    [self stopWork];
    tryTimes ++;
    [self connectServer:JY_SOCKET_HOST port:JY_HOST_PORT];
}

- (void)stopWork {

    [autoRefreshTimer invalidate];
    self.autoRefreshTimer = nil;
    if (_asyncSocket) {
        [_asyncSocket disconnect];
        _asyncSocket.delegate = nil;
    }
    self.asyncSocket = nil;
}

- (void)sendHeartJumpCmd {
    isJump = NO;
    [self sendMessage:@"{\"cmd\":14,\"data\":\"ok\"}"];
}

- (void)refreshTimer {

    if (tryTimes < 10) {
        [self setNextTimer:40*60];
    } else {
        tryTimes = 0;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kUDSocketServer"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self setNextTimer:100*60];
    }
}

- (void)autoRefresh {
    
    NSLog(@"autoRefresh");
    
    if (isJump) {
    
        [self sendHeartJumpCmd];
        [self refreshTimer];
        
    } else {
        
        [self startWork];
    }

    
}

- (void)setNextTimer:(NSTimeInterval)interval {
    
    if (autoRefreshTimer) {
        [autoRefreshTimer invalidate];
    }
    self.autoRefreshTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(autoRefresh) userInfo:nil repeats:false];
}

#pragma mark - ConnectionSoket

- (void)connectServer:(NSString *)hostIp port:(UInt16)hostPort {
    
    if ([_asyncSocket isConnected]) {
        return;
    }
    
    [autoRefreshTimer invalidate];
    
    AsyncSocket *tempSocket = [[AsyncSocket alloc] initWithDelegate:self];
    [self setAsyncSocket:tempSocket];
	[tempSocket release];
    NSError *error = nil;
    [self.asyncSocket connectToHost:hostIp onPort:hostPort error:&error];
}

#pragma mark - AsyncSocketDelegate

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {

    
    NSString *hash = [[NSUserDefaults standardUserDefaults] objectForKey:@"RAW_HASH"];
    NSString *common_hash = [[NSUserDefaults standardUserDefaults] objectForKey:@"COMMON_HASH"];
    NSString *cid = [NSString stringWithFormat:@"%d", rand()];

    if( [JYHelpers isEmptyOfString:hash] || [JYHelpers isEmptyOfString:common_hash] ){
        return ;
    }
    NSString *content = [NSString stringWithFormat:@"get /live?user=%@&uid=%@&hash=%@&common_hash=%@&mid=iphone&cid=%@&ver=%@ HTTP/1.0\n\n", common_hash, common_hash, hash, common_hash, cid, @"1.0"];
//    NSString *content = [NSString stringWithFormat:@"get /live?user=%@&uid=%@&common_hash=%@&mid=iphone&cid=%@&ver=%@ HTTP/1.0\n\n", common_hash, common_hash, hash, cid, @"1.0"];

    NSLog(@"socket长连接:%@", content);
    NSData *wrdata = [content dataUsingEncoding:NSUTF8StringEncoding];
    [_asyncSocket writeData:wrdata withTimeout:-1 tag:0];
    [_asyncSocket readDataToData:[AsyncSocket CRLF2Data] withTimeout:-1 tag:0];
}

/**
 * Called when a socket has completed writing the requested data. Not called if there is an error.
 **/
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"thread(%@),onSocket:%p didWriteDataWithTag:%ld",[[NSThread currentThread] name], sock, tag);
}

/**
 * Called when a socket has completed reading the requested data into memory.
 * Not called if there is an error.
 **/
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
//   NSLog(@"ouyang-test-didReadData:%@---%ld", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],tag);
    if (tag == 0) {
        
        [_asyncSocket readDataToLength:4 withTimeout:-1 tag:1];
        
    } else if (tag == 1) {
        
        unsigned int dataLen=0;        
        uint8_t bufferLen[4];
        [data getBytes:bufferLen length:4];
        dataLen = ((bufferLen[0]<<24)&0xff000000)+((bufferLen[1]<<16)&0xff0000)+((bufferLen[2]<<8)&0xff00)+(bufferLen[3] & 0xff);
        [_asyncSocket readDataToLength:dataLen withTimeout:-1 tag:2];
        
    } else if(tag == 2) {

        NSError *jsonParsingError = nil;
        NSDictionary *dataDict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
//        NSLog(@"%@", dataDict);
        
        if (dataDict == nil) {
            [_asyncSocket readDataToLength:4 withTimeout:-1 tag:1];
            return;
        }
        
        NSUInteger type = [dataDict getIntegerValueForKey:@"cmd" defaultValue:0];
        
        [self dealReceiveMessage:dataDict];
        
        if (type == 57) {
            
            //连接了错误的ip 拿到正确的ip重新连接
            NSString *hostip = [dataDict getStringValueForKey:@"data" defaultValue:nil];
            [self stopWork];
            if (hostip) {
                
                [self connectServer:hostip port:JY_HOST_PORT];
                
            }
            
        } else {
            
            [_asyncSocket readDataToLength:4 withTimeout:-1 tag:1];
            if (type == 54){
                
                [self sendHeartJumpCmd];
                //[self setNextTimer:15];
            } else if (type == 14) {
                
                isJump = YES;
            }
            [self refreshTimer];
        }
    }
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock {

    NSLog(@"disConnect");
    
//    if ([_jyDelegate respondsToSelector:@selector(didDisconnect)]) {
//        [_jyDelegate didDisconnect];
//    }
   
}

@end
