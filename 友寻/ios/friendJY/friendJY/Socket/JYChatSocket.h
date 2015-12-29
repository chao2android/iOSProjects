

#import <UIKit/UIKit.h>
#import "AsyncSocket.h"


@protocol JYChatSocketDelegate <NSObject>

- (void)dealSocketReceiveMsg:(NSDictionary *)msg;
- (void)didDisconnect;

@end

@interface JYChatSocket: NSObject{
    
//    AsyncSocket *asyncSocket;
    NSTimer* autoRefreshTimer;
    NSUInteger tryTimes;
    BOOL isJump;
}

@property (nonatomic, strong) AsyncSocket *asyncSocket;
@property (nonatomic, assign) id<JYChatSocketDelegate> jyDelegate;
@property (nonatomic, strong) NSTimer* autoRefreshTimer;
@property (nonatomic, assign) NSUInteger tryTimes;
@property (nonatomic, assign) BOOL isJump;

- (void)startWork;
- (void)stopWork;
- (BOOL)isConnected;

-(BOOL)sendMessage:(NSString*)msgStr;


@end
