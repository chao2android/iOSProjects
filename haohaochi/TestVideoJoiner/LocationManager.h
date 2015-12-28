//
//  LocationManager.h
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-12-15.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMapKit.h"

@class LocationManager;

@protocol LocationManagerDelegate <NSObject>

@optional

- (void)didUpdateUserLocation:(LocationManager *)locationManager;
- (void)didUpdateCityName:(LocationManager *)locationManager;

@end

@interface LocationManager : NSObject<BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate> {
    
}

@property (nonatomic, assign) float mLatitude;
@property (nonatomic, assign) float mLongitude;
@property (nonatomic, assign) BOOL mbGetName;
@property (nonatomic, assign) id<LocationManagerDelegate> delegate;
@property (nonatomic, strong) BMKLocationService *mLocService;
@property (nonatomic, strong) BMKGeoCodeSearch *mSearch;
@property (nonatomic, strong) BMKUserLocation *mLocation;
@property (nonatomic, strong) NSString *mCity;

+ (LocationManager *)Share;

- (void)StartLocation;
- (void)StopLocation;

@end
