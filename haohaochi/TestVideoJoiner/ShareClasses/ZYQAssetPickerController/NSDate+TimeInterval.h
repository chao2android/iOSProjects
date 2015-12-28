//
//  NSDate+TimeInterval.h
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-11-26.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface NSDate (TimeInterval)

+ (NSDateComponents *)componetsWithTimeInterval:(NSTimeInterval)timeInterval;
+ (NSString *)timeDescriptionOfTimeInterval:(NSTimeInterval)timeInterval;

@end

@interface ALAsset (ALTimeInterval)

@property (nonatomic, readonly) NSTimeInterval duration;
@property (nonatomic, readonly) BOOL landscape;
@property (nonatomic, readonly) CGSize natureSize;

@end
