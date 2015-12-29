//
//  LocationManage.m
//  imdaliIphone
//
//  Created by carson on 12/24/13.
//  Copyright (c) 2013 imdali. All rights reserved.
//

#import "JYLocationManage.h"
#import "JYShareData.h"

@interface JYLocationManage ()

@end

static JYLocationManage * kGetInstance = nil;

@implementation JYLocationManage

//坐标和区域
+ (JYLocationManage *)shareInstance
{
    @synchronized(self) {
        if (!kGetInstance) {
            kGetInstance = [[JYLocationManage alloc] init];
        }
    }
    return kGetInstance;
}

- (void)startLocationManager
{
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        [[NSNotificationCenter defaultCenter] postNotificationName:kLocationDidFinishedNotification object:[NSNumber numberWithBool:NO]];
        return;
    }
    if ([CLLocationManager locationServicesEnabled]) {

        //5.18修改 实现重新定位功能
        if (self.locationManager == nil) {
            self.locationManager = [[CLLocationManager alloc] init];
            [self.locationManager setDelegate:self];
        } else {
//            if (self.locationManager.delegate == nil) {
                [self.locationManager setDelegate:self];
//            }
        }

//        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        self.locationManager.distanceFilter = 100.0f;
        
        if (SYSTEM_VERSION>=8) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        
        [self.locationManager startUpdatingLocation];
//        if (self.locationManager.location != nil) {
//            
//            NSString *longitude = [NSString stringWithFormat:@"%.6lf", self.locationManager.location.coordinate.longitude];
//            NSString *latitude = [NSString stringWithFormat:@"%.6lf", self.locationManager.location.coordinate.latitude];
//
////            [[NSUserDefaults standardUserDefaults] setDouble:self.locationManager.location.coordinate.longitude forKey:@"Longitude"];
////            [[NSUserDefaults standardUserDefaults] setDouble:self.locationManager.location.coordinate.latitude forKey:@"Latitude"];
//            [[NSUserDefaults standardUserDefaults] setObject:longitude forKey:@"Longitude"];
//            [[NSUserDefaults standardUserDefaults] setObject:latitude forKey:@"Latitude"];
//            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Locationed"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//           
//        }
    }
    
}

- (void)stopLocationManager
{
	[self.locationManager stopUpdatingLocation];
	self.locationManager.delegate = nil;
    
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{


}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"error-->%@",[error localizedDescription]);
    
}
- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations
{
    
    for (CLLocation *location in locations) {
        //经纬坐标
        self.coordinate = location.coordinate;
//        NSLog(@"纬度:%f,经度：%f",self.coordinate.latitude, self.coordinate.longitude);
        
        [[NSUserDefaults standardUserDefaults] setDouble:location.coordinate.longitude forKey:@"Longitude"];
        [[NSUserDefaults standardUserDefaults] setDouble:location.coordinate.latitude forKey:@"Latitude"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Locationed"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //位置反编码
        [self reverseGeo:location];
        
        BOOL isAutoLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"isAutoLogin"];
        if (isAutoLogin) {
            
            [NSThread detachNewThreadSelector:@selector(updateLoaction) toTarget:self withObject:nil];
        }
    }
    
    if (locations != nil) {
        //停止更新定位
        [manager stopUpdatingLocation];
    }
}

//位置反编码
- (void)reverseGeo:(CLLocation *)location
{
    
    CLGeocoder *geo = [[CLGeocoder alloc] init];
    
    [geo reverseGeocodeLocation:location
              completionHandler:^(NSArray *placemarks, NSError *error) {
                  for (CLPlacemark *placeMark in placemarks) {
                      
                      // 完整的详细地址
                      NSLog(@"市/区/县:%@",placeMark.subLocality);
                      NSLog(@"市:%@",placeMark.administrativeArea);
                      
                      NSString *str = [NSString stringWithFormat:@"%@%@", placeMark.administrativeArea, placeMark.subLocality];
                      NSLog(@"当前城市 %@", str);
                      
                      NSMutableString *str1 = [[NSMutableString alloc] initWithString:placeMark.administrativeArea];
                      NSMutableString *str2 = [[NSMutableString alloc] initWithString:placeMark.subLocality];
                      
                      NSString *currentProvinceStr = nil;
                      NSString *currentCityStr = nil;
                      
                      if ([str1 hasSuffix:@"市"]) {
                          
                          currentProvinceStr = [str1 stringByReplacingOccurrencesOfString:@"市" withString:@""];
                      } else if ([str1 hasSuffix:@"省"]) {
                          currentProvinceStr = [str1 stringByReplacingOccurrencesOfString:@"省" withString:@""];
                      }
                      
                      if ([str2 hasSuffix:@"市"]) {
                          currentCityStr = [str2 stringByReplacingOccurrencesOfString:@"市" withString:@""];
                      } else if ([str2 hasSuffix:@"县"]) {
                          currentCityStr = [str2 stringByReplacingOccurrencesOfString:@"县" withString:@""];
                      } else if ([str2 hasSuffix:@"区"]) {
                          currentCityStr = [str2 stringByReplacingOccurrencesOfString:@"区" withString:@""];
                      }
                      
                      [[NSNotificationCenter defaultCenter] postNotificationName:kLocationDidFinishedNotification object:currentProvinceStr];
                      [[NSUserDefaults standardUserDefaults] setObject:currentProvinceStr forKey:@"currentProvince"];
                      [[NSUserDefaults standardUserDefaults] setObject:currentCityStr forKey:@"currentCity"];
                      [[NSUserDefaults standardUserDefaults] synchronize];
                      
                  }
              }];
}

// 定位出错时被调
- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kLocationDidFinishedNotification object:nil];
    
    NSLog(@"获取经纬度失败，失败原因：%@", [error description]);
}

- (void)updateLoaction{
    //    public boolean update_lnglat(int uid, lng 经度, lat 纬度)
    NSDictionary *paraDic = @{@"mod":@"login",
                              @"func":@"update_lnglat"
                              };
    NSDictionary *postDic = @{
                              @"uid":ToString([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]),
                              @"lng":[SharedDefault objectForKey:@"Longitude"],
                              @"lat":[SharedDefault objectForKey:@"Latitude"]
                              };
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            //do any addtion here...
        }
    } failure:^(id error) {
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];
}

@end
