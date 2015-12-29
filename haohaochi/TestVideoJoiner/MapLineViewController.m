//
//  MapLineViewController.m
//  TestVideoJoiner
//
//  Created by MC on 14-12-3.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "MapLineViewController.h"
#import "LocationManager.h"

@interface MapLineViewController () {
}


@end

@implementation MapLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"地图";
    [self AddLeftImageBtn:[UIImage imageNamed:@"3_03.png"] target:self action:@selector(GoBack)];

    mMapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    mMapView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [mMapView setZoomLevel:16];
    mMapView.showsUserLocation = YES;//显示定位图层
    self.view = mMapView;
    
    [self AddPointAnnotation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)AddPointAnnotation {
    // 添加一个PointAnnotation
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc] init];
    CLLocationCoordinate2D coor;
    coor.latitude = self.mLatitude;
    coor.longitude = self.mLongitude;
    annotation.coordinate = coor;
    annotation.title = self.mName;
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

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //    NSLog(@"heading is %@",userLocation.heading);
}

//处理位置坐标更新
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation:%f, %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    mMapView.showsUserLocation = YES;//显示定位图层
    [mMapView updateLocationData:userLocation];
}

- (void)viewWillAppear:(BOOL)animated {
    [mMapView viewWillAppear];
    mMapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    [mMapView updateLocationData:[LocationManager Share].mLocation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [mMapView viewWillDisappear];
    mMapView.delegate = nil; // 不用时，置nil
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
