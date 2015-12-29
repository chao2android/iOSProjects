//
//  LocationManage.h
//  imdaliIphone
//
//  Created by carson on 12/24/13.
//  Copyright (c) 2013 imdali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "NSDictionary+Additions.h"

@interface JYLocationManage : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate; //经纬度

+ (JYLocationManage *) shareInstance;

- (void)startLocationManager;

- (void)stopLocationManager;



@end
