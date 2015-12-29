//
//  LocationManager.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-12-15.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "LocationManager.h"

static LocationManager *gLocationManager = nil;

@implementation LocationManager

@synthesize delegate;

+ (LocationManager *)Share {
    if (!gLocationManager) {
        gLocationManager = [[LocationManager alloc] init];
    }
    return gLocationManager;
}

- (id)init {
    self = [super init];
    if (self) {
        self.mbGetName = NO;
        self.mLocService = [[BMKLocationService alloc]init];
        self.mLocService.delegate = self;
        
        self.mSearch =[[BMKGeoCodeSearch alloc]init];
        self.mSearch.delegate = self;
    }
    return self;
}

- (void)StartLocation {
    
    [self.mLocService startUserLocationService];
}

- (void)StopLocation {
    
    [self.mLocService stopUserLocationService];
}

//处理位置坐标更新
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    //NSLog(@"didUpdateUserLocation:%f, %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    self.mLocation = userLocation;
    self.mLatitude = userLocation.location.coordinate.latitude;
    self.mLongitude = userLocation.location.coordinate.longitude;
    if (delegate && [delegate respondsToSelector:@selector(didUpdateUserLocation:)]) {
        [delegate didUpdateUserLocation:self];
    }
    if (self.mbGetName) {
        [self GetLocationGeo];
        self.mbGetName = NO;
    }
}

- (void)GetLocationGeo {
    //发起反向地理编码检索
    CLLocationCoordinate2D pt = self.mLocation.location.coordinate;
    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc] init];
    option.reverseGeoPoint = pt;
    BOOL flag = [self.mSearch reverseGeoCode:option];
    if (flag) {
        NSLog(@"反geo检索发送成功");
    }
    else {
        NSLog(@"反geo检索发送失败");
    }
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        self.mCity = result.addressDetail.city;
        if (delegate && [delegate respondsToSelector:@selector(didUpdateCityName:)]) {
            [delegate didUpdateCityName:self];
        }
        NSLog(@"onGetReverseGeoCodeResult:%@ %@", result.addressDetail.city, result.address);
        
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

@end
