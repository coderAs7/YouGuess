//
//  QGHLocationManager.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/5/29.
//  Copyright © 2016年 姚驰. All rights reserved.
//

#import "QGHLocationManager.h"
#import <CoreLocation/CoreLocation.h>

//typedef void(^CurrentAddressBlock)(AMapAddressComponent *addressComponent);


@interface QGHLocationManager ()


//@property (nonatomic, copy) CurrentAddressBlock currentAddressBlock;


@end


@implementation QGHLocationManager


+ (QGHLocationManager *)sharedLocationManager {
    __strong static QGHLocationManager *_manager = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        _manager = [[QGHLocationManager alloc] init];
    });
    
    return _manager;
}


+ (void)getArea {
    
}


//- (void)getLocationCoordinate:(CurrentAddressBlock)currentAddressBlock {
//    self.currentAddressBlock = currentAddressBlock;
//    [self startLocation];
//}


- (void)startLocation {
//    if (IS_IOS8_LATER) {
//        _locationManager = [[CLLocationManager alloc] init];
//        _locationManager.delegate = self;
//        _locationManager.distanceFilter = 200;
//        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
//    } else {
//        if (_mapView) {
//            _mapView = nil;
//        }
//        
//        _mapView = [[MKMapView alloc] init];
//        _mapView.delegate = self;
//        _mapView.showsUserLocation = YES;
//    }
}


@end
