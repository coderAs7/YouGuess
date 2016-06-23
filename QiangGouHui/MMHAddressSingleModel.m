////
////  MMHAddressSingleModel.m
////  MamHao
////
////  Created by SmartMin on 15/4/20.
////  Copyright (c) 2015年 Mamhao. All rights reserved.
////
//
//#import "MMHAddressSingleModel.h"
////#import "MMHNetworkAdapter+Product.h"
//
//
//@implementation MMHAddressSingleModel
//
//+ (MMHAddressSingleModel *)sharedAddress {
//    static MMHAddressSingleModel *currentAddress = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        currentAddress = [[MMHAddressSingleModel alloc] init];
//    });
//    return currentAddress;
//}
//
//
//- (id)initWithDictionary:(NSDictionary *)dictionary {
//    self = [self init];
//    if (self) {
//        if (dictionary[@"deliveryAddrId"]) {
//            self.deliveryAddrId = [NSString stringWithFormat:@"%@", dictionary[@"deliveryAddrId"]];
//        }
//        self.provinceId = [dictionary objectForKeys:@[@"provinceId", @"prv"]];
//        self.cityId = dictionary[@"cityId"];
//        self.shortGPSAddress = dictionary[@"shortGPSAddress"];
//        self.gpsAddress = [dictionary objectForKeys:@[@"gpsAddress", @"gpsAddr"]];
//        self.addrDetail = dictionary[@"addrDetail"];
//        self.consignee = dictionary[@"consignee"];
//        self.phone = dictionary[@"phone"];
//        self.telephone = dictionary[@"telephone"];
//        self.isDefault = [dictionary[@"isDefault"] boolValue];
//        self.areaId = dictionary[@"areaId"];
//        self.lng = [dictionary[@"lng"] doubleValue];
//        self.lat = [dictionary[@"lat"] doubleValue];
//        NSString *province = dictionary[@"province"];
//        if (province) {
//            self.province = province;
//        }
//        province = dictionary[@"prv"];
//        if (province) {
//            self.province = province;
//        }
//        province = dictionary[@"prvName"];
//        if (province) {
//            self.province = province;
//        }
//        
//        NSString *city = dictionary[@"city"];
//        if (city) {
//            self.city = city;
//        }
//        city = dictionary[@"cityName"];
//        if (city) {
//            self.city = city;
//        }
//        
//        NSString *area = dictionary[@"area"];
//        if (area) {
//            self.area = area;
//        }
//        area = dictionary[@"areaName"];
//        if (area) {
//            self.area = area;
//        }
//    }
//    return self;
//}
//
//
//- (NSDictionary *)dictionary {
//    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//    [dictionary setNullableObject:self.deliveryAddrId forKey:@"deliveryAddrId"];
//    [dictionary setNullableObject:self.provinceId forKey:@"provinceId"];
//    [dictionary setNullableObject:self.cityId forKey:@"cityId"];
//    [dictionary setNullableObject:self.areaId forKey:@"areaId"];
//    [dictionary setNullableObject:self.shortGPSAddress forKey:@"shortGPSAddress"];
//    [dictionary setNullableObject:self.gpsAddress forKey:@"gpsAddress"];
//    [dictionary setNullableObject:self.addrDetail forKey:@"addrDetail"];
//    [dictionary setNullableObject:self.consignee forKey:@"consignee"];
//    [dictionary setNullableObject:self.phone forKey:@"phone"];
//    [dictionary setNullableObject:self.telephone forKey:@"telephone"];
//    [dictionary setNullableObject:@(self.isDefault) forKey:@"isDefault"];
//    [dictionary setNullableObject:self.areaId forKey:@"areaId"];
//    [dictionary setNullableObject:@(self.lng) forKey:@"lng"];
//    [dictionary setNullableObject:@(self.lat) forKey:@"lat"];
//    [dictionary setNullableObject:self.province forKey:@"province"];
//    [dictionary setNullableObject:self.city forKey:@"city"];
//    [dictionary setNullableObject:self.area forKey:@"area"];
//    return dictionary;
//}
//
//
//- (NSDictionary *)modelKeyJSONKeyMapper{
//    return @{@"gpsAddress": @"gpsAddr", @"province": @"prv"};
//}
//
//- (NSString *)deliveryAddrId {
//    if (_deliveryAddrId) {
//        return _deliveryAddrId;
//    }
//
//    return nil;
//}
//
//- (NSString *)provinceAndCityAndArea {
//    NSMutableArray *arr = [NSMutableArray array];
//    if (self.province.length != 0) {
//        [arr addObject:self.province];
//    }
//    if (self.city.length != 0) {
//        [arr addObject:self.city];
//    }
//    if (self.area.length != 0) {
//        [arr addObject:self.area];
//    }
//    
//    NSString *str = [arr componentsJoinedByString:@" "];
//    return str;
//}
//
//- (NSString *)street {
//    NSMutableArray *arr = [NSMutableArray array];
//    if (self.gpsAddress.length != 0) {
//        [arr addObject:self.gpsAddress];
//    }
//    if (self.addrDetail.length != 0) {
//        [arr addObject:self.addrDetail];
//    }
//    
//    NSString *str = [arr componentsJoinedByString:@" "];
//    return str;
//}
//
//@end
