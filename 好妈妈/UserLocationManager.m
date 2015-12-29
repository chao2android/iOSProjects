//
//  UserLocationManager.m
//  好妈妈
//
//  Created by Hepburn Alex on 14-5-15.
//  Copyright (c) 2014年 iHope. All rights reserved.
//

#import "UserLocationManager.h"

static UserLocationManager *gUserLocation = nil;

@implementation UserLocationManager

+ (UserLocationManager *)Share {
    if (!gUserLocation) {
        gUserLocation = [[UserLocationManager alloc] init];
    }
    return gUserLocation;
}

- (id)init {
    self = [super init];
    if (self) {
        self.mLat = 40;
        self.mLng = 116;
        mLocaManager = [[CLLocationManager alloc] init];
        // 接收事件的实例
        mLocaManager.delegate = self;
        // 发生事件的的最小距离间隔（缺省是不指定）
        mLocaManager.distanceFilter = kCLDistanceFilterNone;
        // 精度 (缺省是Best)
        mLocaManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return self;
}

- (void)dealloc {
    [mLocaManager release];
    [super dealloc];
}

- (void)StartLocation {
    miCount = 0;
    [mLocaManager startUpdatingLocation];
}

- (void)StopLocation {
    [mLocaManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation {
    miCount ++;
    if (miCount>2) {
        [self StopLocation];
        // 取得经纬度
        CLLocationCoordinate2D coordinate = newLocation.coordinate;
        CLLocationDegrees latitude = coordinate.latitude;
        CLLocationDegrees longitude = coordinate.longitude;
        NSLog(@"didUpdateToLocation %lf %lf",latitude,longitude);
        
        kLat = latitude;
        kLng = longitude;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_Location object:nil];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self StopLocation];
    NSLog(@"didFailWithError");
    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_Location object:nil];
}

@end
