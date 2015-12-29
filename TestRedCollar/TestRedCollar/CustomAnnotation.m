//
//  CustomAnnotation.m
//  TestRedCollar
//
//  Created by MC on 14-8-19.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "CustomAnnotation.h"

@implementation CustomAnnotation

@synthesize coordinate, title, subtitle;
-(id) initWithCoordinate:(CLLocationCoordinate2D) coords
{
    if (self = [super init]) {
        coordinate = coords;
    }
    return self;
}


@end



