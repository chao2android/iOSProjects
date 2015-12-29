//
//  ServiceViewController.h
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-5.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseADViewController.h"
#import <MapKit/MapKit.h>

typedef void (^saveData)(NSString *IdStr);
typedef void (^saveMakeData)(NSString *address,NSString *mobile ,NSString * realname,NSString * region_id,NSString * region_name,NSString * retime);
@interface ServiceViewController : BaseADViewController<UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate,CLLocationManagerDelegate> {
    UITableView *mTableView;
    MKMapView *mMapView;
    CLLocationManager *locationManager;
    BOOL mbLoaded;
}
@property (copy, nonatomic) saveMakeData mblock;
@property (copy, nonatomic) saveData block;
@property (nonatomic, assign) BOOL is_free;
@property (nonatomic, strong) NSMutableArray *mArray;

@end
