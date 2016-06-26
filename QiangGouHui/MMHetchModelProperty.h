//
//  MMHetchModelProperty.h
//  MamHao
//
//  Created by SmartMin on 15/3/31.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 相关知识请参见Runtime文档
 Type Encodings https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1
 Property Type String https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html#//apple_ref/doc/uid/TP40008048-CH101-SW6
 */
typedef NS_ENUM(NSUInteger, QSFetchModelPropertyValueType) {
    MMHClassPropertyValueTypeNone = 0,
    MMHClassPropertyTypeChar,
    MMHClassPropertyTypeInt,
    MMHClassPropertyTypeShort,
    MMHClassPropertyTypeLong,
    MMHClassPropertyTypeLongLong,
    MMHClassPropertyTypeUnsignedChar,
    MMHClassPropertyTypeUnsignedInt,
    MMHClassPropertyTypeUnsignedShort,
    MMHClassPropertyTypeUnsignedLong,
    MMHClassPropertyTypeUnsignedLongLong,
    MMHClassPropertyTypeFloat,
    MMHClassPropertyTypeDouble,
    MMHClassPropertyTypeBool,
    MMHClassPropertyTypeVoid,
    MMHClassPropertyTypeCharString,
    MMHClassPropertyTypeObject,
    MMHClassPropertyTypeClassObject,
    MMHClassPropertyTypeSelector,
    MMHClassPropertyTypeArray,
    MMHClassPropertyTypeStruct,
    MMHClassPropertyTypeUnion,
    MMHClassPropertyTypeBitField,
    MMHClassPropertyTypePointer,
    MMHClassPropertyTypeUnknow
};


@interface MMHetchModelProperty : NSObject
@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) QSFetchModelPropertyValueType valueType;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, assign) Class objectClass;
@property (nonatomic, strong) NSArray *objectProtocols;
@property (nonatomic, assign) BOOL isReadonly;

- (id)initWithName:(NSString *)name typeString:(NSString *)typeString;

@end
