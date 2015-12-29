//
//  ProximityMonitor.h
//  TestPinBang
//
//  Created by Hepburn Alex on 13-7-4.
//  Copyright (c) 2013年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProximityMonitor : NSObject

+ (ProximityMonitor *)Share;
- (void)StartMonitor;
- (void)StopMonitor;

@end
