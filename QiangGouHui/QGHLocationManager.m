//
//  QGHLocationManager.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/3.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHLocationManager.h"
#import <CoreLocation/CoreLocation.h>


@interface QGHLocationManager ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, copy) NSString *city;

@end


@implementation QGHLocationManager


+ (QGHLocationManager *)shareManager {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}


+ (void)startLocation {
    [[self shareManager].locationManager startUpdatingLocation];
}


- (instancetype)init {
    self = [super init];
    
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 200;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        if (ios8) {
            [_locationManager requestAlwaysAuthorization];
        }
    }
    
    return self;
}


- (NSString *)currentCity {
    if (!_city) {
        return @"广州";
    }
    
    if ([_city hasSuffix:@"市"]) {
        return [_city stringByReplacingOccurrencesOfString:@"市" withString:@""];
    }
    
    return _city;
}


#pragma mark - CLLocationManagerDelegate


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placemark = placemarks[0];
        NSString *city = placemark.locality;
        if (!city) {
            city = placemark.administrativeArea;
        }
        _city = city;
        [_locationManager stopUpdatingLocation];
        [[NSNotificationCenter defaultCenter] postNotificationName:MMHCurrentLocationNotification object:nil];
    }];
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusDenied : {
//            if ([[MMHTool userDefaultGetWithKey:MMHIsOpenLocation] isEqualToString:@"No"]) {
                UIAlertView *tempA = [[UIAlertView alloc] initWithTitle:@"当前定位服务未打开，可能会影响商品价格变化，小主去设置吧" message:@"方法：设置-隐私-定位服务-芬想-选择“始终”" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [tempA show];
            /*}*/ break;
        }
        case kCLAuthorizationStatusNotDetermined:
            if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [_locationManager requestAlwaysAuthorization];
            }
            break;
        case kCLAuthorizationStatusRestricted:{
            UIAlertView *tempA = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"定位服务无法使用！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [tempA show];
        }
        default:
            [self.locationManager startUpdatingLocation];
            break;
    }
    
//    if ([[MMHTool userDefaultGetWithKey:MMHIsOpenLocation] isEqualToString:@"No"]) {
//        [MMHTool userDefaulteWithKey:MMHIsOpenLocation Obj:@"Yes"];
//    }
}
@end
