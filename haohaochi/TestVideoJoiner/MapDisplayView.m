//
//  MapDisplayView.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-12-11.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "MapDisplayView.h"

@implementation MapDisplayView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        mMapView = [[BMKMapView alloc] initWithFrame:self.bounds];
        mMapView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [mMapView setZoomLevel:16];
        mMapView.showsUserLocation = YES;//显示定位图层
        [self addSubview:mMapView];
    }
    return self;
}

- (void)AddPointAnnotation:(float)latitude :(float)longitude :(NSString *)name {
    // 添加一个PointAnnotation
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc] init];
    CLLocationCoordinate2D coor;
    coor.latitude = latitude;
    coor.longitude = longitude;
    annotation.coordinate = coor;
    annotation.title = name;
    [mMapView addAnnotation:annotation];
    
    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(coor,BMKCoordinateSpanMake(0.01, 0.01));
    BMKCoordinateRegion adjustedRegion = [mMapView regionThatFits:viewRegion];
    [mMapView setRegion:adjustedRegion animated:YES];
}

// Override
- (BMKAnnotationView *)_mapView:(BMKMapView *)_mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}

- (void)viewWillAppear {
    [mMapView viewWillAppear];
    mMapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

- (void)viewWillDisappear {
    [mMapView viewWillDisappear];
    mMapView.delegate = nil; // 不用时，置nil
}

@end
