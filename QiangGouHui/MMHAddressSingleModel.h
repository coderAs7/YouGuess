////
////  MMHAddressSingleModel.h
////  MamHao
////
////  Created by SmartMin on 15/4/20.
////  Copyright (c) 2015年 Mamhao. All rights reserved.
////
//
//#import "MMHFetchModel.h"
//@import CoreLocation;
//
//
//@protocol MMHAddressSingleModel <NSObject>
//@end
//
//
//@interface MMHAddressSingleModel : MMHFetchModel
//
//+ (MMHAddressSingleModel *)sharedAddress;
//
//@property (nonatomic,copy)NSString *deliveryAddrId;         /**< 收货地址唯一id*/
//@property (nonatomic,copy)NSString *provinceId;               /**< 浙江省Id*/
//@property (nonatomic,copy)NSString *cityId;                   /**< 城市Id*/
//@property (nonatomic, copy) NSString *shortGPSAddress;      /**< 短定位地址 */
//@property (nonatomic,copy)NSString *gpsAddress;             /**< GPS定位地址*/
//@property (nonatomic,copy)NSString *addrDetail;             /**< 详细地址*/
//@property (nonatomic,copy)NSString *consignee;              /**< 联系人*/
//@property (nonatomic,copy)NSString *phone;                  /**< 联系电话*/
//@property (nonatomic,copy)NSString *telephone;              /**< 座机*/
//@property (nonatomic,assign)BOOL isDefault;                 /**< 是否默认 0是，1否*/
//@property (nonatomic,copy)NSString *areaId;                 /**< 区域id*/
//@property (nonatomic,assign)CLLocationDegrees lng;                    /**< 精度*/
//@property (nonatomic,assign)CLLocationDegrees lat;                    /**< 维度*/
//
//
//@property (nonatomic,strong)NSString *province;
//@property (nonatomic,strong)NSString *city;
//@property (nonatomic,strong)NSString *area;
//
//- (id)initWithDictionary:(NSDictionary *)dictionary;
//- (NSDictionary *)dictionary;
//
//- (NSString *)provinceAndCityAndArea;
//- (NSString *)street;
//@end
