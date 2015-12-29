//
//  CustomAnnotation.h
//  TestRedCollar
//
//  Created by MC on 14-8-19.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface CustomAnnotation : NSObject
<MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
}
-(id) initWithCoordinate:(CLLocationCoordinate2D) coords;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@end
