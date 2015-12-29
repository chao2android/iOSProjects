//
//  ServiceViewController.m
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-5.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ServiceViewController.h"
#import "ServiceTableCell.h"
#import "ImageDownManager.h"
#import "JSON.h"
#import "MakeAnAppointmentOfFigureViewController.h"
//#import "ServiceInfoModel.h"
#import "CustomAnnotation.h"
#import "AutoAlertView.h"
@interface ServiceViewController ()
{
    ImageDownManager *_mDownManger;
    CLLocation *_userLocation;
    //NSMutableArray *_allAnn;
    int _dataIndex;
}
@end

@implementation ServiceViewController

@synthesize mArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        mbLoaded = NO;
        self.mArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    self.title = @"服务点";
    //_allAnn = [[NSMutableArray alloc]init];
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:[UIImage imageNamed:@"70"] target:self action:@selector(OnMapClick)];
    
    
    mTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mTableView];
    
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
}
//获取当前位置
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [locationManager stopUpdatingLocation];
    _userLocation = newLocation;
    [self stratDownd:newLocation];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"error---->%@",error);
}
- (void)dealloc {
    [self Cancel];
}

#pragma mark - ImageDownManager

- (void)Cancel{
    [self StopLoading];
    SAFE_CANCEL_ARC(_mDownManger);
}
- (void)stratDownd:(CLLocation *)cll{
    [self StartLoading];
    NSString *lat = [NSString stringWithFormat:@"%lf",cll.coordinate.latitude];
    NSString *lng = [NSString stringWithFormat:@"%lf",cll.coordinate.longitude];
    
    _mDownManger = [[ImageDownManager alloc] init];
    _mDownManger.delegate = self;
    _mDownManger.OnImageDown = @selector(OnLoadFinish:);
    _mDownManger.OnImageFail = @selector(OnLoadFail:);
    NSString *urlstr = [NSString stringWithFormat:@"%@service.php", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"index" forKey:@"act"];
    [dict setObject:@"1" forKey:@"pageIndex"];
    [dict setObject:@"60" forKey:@"pageSize"];
    [dict setObject:lat forKey:@"lat"];
    [dict setObject:lng forKey:@"lng"];
    [_mDownManger PostHttpRequest:urlstr :dict];
}
- (void)OnLoadFinish:(ImageDownManager *)sender {
    
    NSDictionary *dict = [sender.mWebStr JSONValue];
    NSLog(@"----->dict--%@",dict);
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dataListDict = [dict objectForKey:@"datalist"];
        if ([[dict objectForKey:@"datalist"] count]==0) {
            [AutoAlertView ShowAlert:@"提示" message:@"您所在地区暂时没有服务点"];
            return;
        }
        for (NSString *idKey in dataListDict) {
            NSDictionary *serviceDict =[[NSDictionary alloc]initWithDictionary:[dataListDict objectForKey:idKey]];
            [self.mArray addObject:serviceDict];
        }
        [mTableView reloadData];
    }
}

- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}

- (void)OnMapClick {
    [self AddRightImageBtn:[UIImage imageNamed:@"69"] target:self action:@selector(OnListClick)];
    if (!mMapView) {
        mbLoaded = NO;
        mMapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
        mMapView.delegate = self;
        mMapView.showsUserLocation = YES;
        [self.view addSubview:mMapView];
        
    }
    for (int i = 0; i<self.mArray.count; i++) {
        NSDictionary *dict = self.mArray[i];
        if (![dict[@"latitude"] isEqual:[NSNull null]] && ![dict[@"longitude"] isEqual:[NSNull null]]) {
            CLLocationCoordinate2D code = CLLocationCoordinate2DMake([dict[@"latitude"] floatValue], [dict[@"longitude"] floatValue]);
            CustomAnnotation *annotation = [[CustomAnnotation alloc] initWithCoordinate:code];
            NSLog(@"------------------------------------");
            annotation.title = dict[@"company_name"];
            annotation.subtitle = dict[@"serve_name"];
            _dataIndex = i;
            [mMapView addAnnotation:annotation];
        }
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    
    if (![annotation isKindOfClass:[CustomAnnotation class]]) {
        return nil;
    }
    MKPinAnnotationView *newAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation1"];
	newAnnotation.pinColor = MKPinAnnotationColorRed;
	newAnnotation.animatesDrop = YES;
	//canShowCallout: to display the callout view by touch the pin
	newAnnotation.canShowCallout=YES;
    
//    BOOL has = NO;
//    for (CustomAnnotation *ann in _allAnn) {
//        if (ann == annotation) {
//            has = YES; break;
//        }
//    }
//    NSLog(@"has is %d", has);
//    if (has == NO) {
//        [_allAnn addObject:annotation];
//    }
    UIButton *b = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [b addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    // 放大头针下标
    b.tag = _dataIndex;
    
	newAnnotation.rightCalloutAccessoryView=b;
    
	return newAnnotation;
}
- (void)buttonClick:(UIButton *)sender
{
    NSLog(@"sender.tag--->%d",sender.tag);
    NSDictionary *dict = self.mArray[sender.tag];
    NSString *idStr = dict[@"id"];
    self.block(idStr);
    
    MakeAnAppointmentOfFigureViewController *mavc = [[MakeAnAppointmentOfFigureViewController alloc]init];
    mavc.is_free = self.is_free;
    mavc.block = self.mblock;
    [self.navigationController pushViewController:mavc animated:YES];
}

- (void)OnListClick {
    [self AddRightImageBtn:[UIImage imageNamed:@"70"] target:self action:@selector(OnMapClick)];
    if (mMapView) {
        mMapView.delegate = nil;
        [mMapView removeFromSuperview];
        mMapView = nil;
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (!mbLoaded) {
        mbLoaded = YES;
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate,5000, 5000);
        MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
        [mapView setRegion:adjustedRegion animated:YES];
//        MKCoordinateRegion region;
//        region.center.latitude = userLocation.coordinate.latitude;
//        region.center.longitude = userLocation.coordinate.longitude;
//        region.span.latitudeDelta = 0.01;
//        region.span.longitudeDelta = 0.01;
//        mapView.region = region;
    }
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"CellIdentifier%d", indexPath.section];
    ServiceTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ServiceTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    [cell LoadContent:[mArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = self.mArray[indexPath.row];
    NSString *idStr = dict[@"id"];
    self.block(idStr);
    
    MakeAnAppointmentOfFigureViewController *mavc = [[MakeAnAppointmentOfFigureViewController alloc]init];
    mavc.is_free = self.is_free;
    mavc.block = self.mblock;
    [self.navigationController pushViewController:mavc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
