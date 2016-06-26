//
//  MMHFetchModel.m
//  MamHao
//
//  Created by SmartMin on 15/3/31.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import <objc/runtime.h>
#import "MMHFetchModel.h"
#import "MMHetchModelProperty.h"
#import <AFNetworking/AFNetworking.h>


@implementation NSArray (MMHFetchModel)


- (NSArray *)modelArrayOfClass:(Class)modelClass {
    NSMutableArray *modelArray = [NSMutableArray array];
    for (id object in self) {
        if ([object isKindOfClass:[NSArray class]]) {
            [modelArray addObject:[object modelArrayOfClass:modelClass]];
        } else if ([object isKindOfClass:[NSDictionary class]]){
            [modelArray addObject:[[modelClass alloc] initWithJSONDict:object]];
        } else {
            [modelArray addObject:object];
        }
    }
    return modelArray;
}


@end


#pragma mark - NSDictionary+MMHFetchModel


@interface NSDictionary (MMHFetchModel)

- (NSDictionary *)modelDictionaryWithClass:(Class)modelClass;

@end


@implementation NSDictionary (MMHFetchModel)


- (NSDictionary *)modelDictionaryWithClass:(Class)modelClass {
    NSMutableDictionary *modelDictionary = [NSMutableDictionary dictionary];
    for (NSString *key in self) {
        id object = [self objectForKey:key];
        if ([object isKindOfClass:[NSDictionary class]]) {
            [modelDictionary setObject:[[modelClass alloc] initWithJSONDict:object] forKey:key];
        } else if ([object isKindOfClass:[NSArray class]]) {
            [modelDictionary setObject:[object modelArrayOfClass:modelClass] forKey:key];
        } else {
            [modelDictionary setObject:object forKey:key];
        }
    }
    return modelDictionary;
}


@end


#pragma mark - MMHFetchModel


static const char *MMHFecthModelKeyMapperKey;
static const char *MMHFetchModelPropertiesKey;


@interface MMHFetchModel()

- (void)setupCachedKeyMapper;
- (void)setupCachedProperties;

@property (nonatomic, strong) NSDictionary *modelKeyJSONKeyMapper;

@end


@implementation MMHFetchModel


- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupCachedKeyMapper];
        [self setupCachedProperties];
    }
    return self;
}


- (instancetype)initWithJSONDict:(NSDictionary *)dict {
    self = [self init];
    if (self) {
        [self injectJSONData:dict];
    }
    return self;
}


#pragma mark - MMHFetchModel Configuration


- (void)setupCachedKeyMapper {
    if (objc_getAssociatedObject(self.class, &MMHFecthModelKeyMapperKey) == nil) {
        NSDictionary *dict = [self modelKeyJSONKeyMapper];
        if (dict.count) {
            objc_setAssociatedObject(self.class, &MMHFecthModelKeyMapperKey, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
}


- (void)setupCachedProperties {
    if (objc_getAssociatedObject(self.class, &MMHFetchModelPropertiesKey) == nil) {
        NSMutableDictionary *propertyMap = [NSMutableDictionary dictionary];
        Class class = [self class];
        while (class != [MMHFetchModel class]) {
            unsigned int propertyCount;
            objc_property_t *properties = class_copyPropertyList(class, &propertyCount);
            for (unsigned int i = 0; i < propertyCount; i++) {
                
                objc_property_t property = properties[i];
                const char *propertyName = property_getName(property);
                NSString *name = [NSString stringWithUTF8String:propertyName];
                const char *propertyAttrs = property_getAttributes(property);
                NSString *typeString = [NSString stringWithUTF8String:propertyAttrs];
                MMHetchModelProperty *modelProperty = [[MMHetchModelProperty alloc] initWithName:name typeString:typeString];
                if (!modelProperty.isReadonly) {
                    [propertyMap setValue:modelProperty forKey:modelProperty.name];
                }
            }
            free(properties);
            
            class = [class superclass];
        }
        objc_setAssociatedObject(self.class, &MMHFetchModelPropertiesKey, propertyMap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}


#pragma mark - MMHFetchModel Runtime Injection


- (void)injectJSONData:(id)dataObject {
    NSDictionary *keyMapper = objc_getAssociatedObject(self.class, &MMHFecthModelKeyMapperKey);
    NSDictionary *properties = objc_getAssociatedObject(self.class, &MMHFetchModelPropertiesKey);
    
    if ([dataObject isKindOfClass:[NSArray class]]) {
        MMHetchModelProperty *arrayProperty = nil;
        Class class = NULL;
        for (MMHetchModelProperty *property in [properties allValues]) {
            NSString *valueProtocol = [property.objectProtocols firstObject];
            class = NSClassFromString(valueProtocol);
            if ([valueProtocol isKindOfClass:[NSString class]] && [class isSubclassOfClass:[MMHFetchModel class]]) {
                arrayProperty = property;
                break;
            }
        }
        
        if (arrayProperty && class) {
            id value = [(NSArray *) dataObject modelArrayOfClass:class];
            [self setValue:value forKey:arrayProperty.name];
        }
    } else if ([dataObject isKindOfClass:[NSDictionary class]]) {
        for (MMHetchModelProperty *property in [properties allValues]) {
            NSString *jsonKey = property.name;
            NSString *mapperKey = [keyMapper objectForKey:jsonKey];
            jsonKey = mapperKey ?: jsonKey;
            
            id jsonValue = [dataObject objectForKey:jsonKey];
            id propertyValue = [self valueForProperty:property withJSONValue:jsonValue];
            
            if (propertyValue) {
                [self setValue:propertyValue forKey:property.name];
            } else {
                id resetValue = (property.valueType == MMHClassPropertyTypeObject) ? nil : @(0);
                [self setValue:resetValue forKey:property.name];
            }
        }
    }
}


- (id)valueForProperty:(MMHetchModelProperty *)property withJSONValue:(id)value {
    id resultValue = value;
    if (value == nil || [value isKindOfClass:[NSNull class]]) {
        resultValue = nil;
    } else {
        if (property.valueType != MMHClassPropertyTypeObject) {
            if ([value isKindOfClass:[NSString class]]) {
                if (property.valueType == MMHClassPropertyTypeInt ||
                    property.valueType == MMHClassPropertyTypeUnsignedInt||
                    property.valueType == MMHClassPropertyTypeShort||
                    property.valueType == MMHClassPropertyTypeUnsignedShort) {
                    resultValue = [NSNumber numberWithInt:[(NSString *)value intValue]];
                }
                if (property.valueType == MMHClassPropertyTypeLong ||
                    property.valueType == MMHClassPropertyTypeUnsignedLong ||
                    property.valueType == MMHClassPropertyTypeLongLong ||
                    property.valueType == MMHClassPropertyTypeUnsignedLongLong){
                    resultValue = [NSNumber numberWithLongLong:[(NSString *)value longLongValue]];
                }
                if (property.valueType == MMHClassPropertyTypeFloat) {
                    resultValue = [NSNumber numberWithFloat:[(NSString *)value floatValue]];
                }
                if (property.valueType == MMHClassPropertyTypeDouble) {
                    resultValue = [NSNumber numberWithDouble:[(NSString *)value doubleValue]];
                }
                if (property.valueType == MMHClassPropertyTypeChar) {
                    //对于BOOL而言，@encode(BOOL) 为 c 也就是signed char
                    resultValue = [NSNumber numberWithBool:[(NSString *)value boolValue]];
                }
            }
        } else {
            Class valueClass = property.objectClass;
            if ([valueClass isSubclassOfClass:[MMHFetchModel class]] &&
                [value isKindOfClass:[NSDictionary class]]) {
                resultValue = [[valueClass alloc] initWithJSONDict:value];
            }
            
            if ([valueClass isSubclassOfClass:[NSString class]] &&
                ![value isKindOfClass:[NSString class]]) {
                resultValue = [NSString stringWithFormat:@"%@",value];
            }
            
            if ([valueClass isSubclassOfClass:[NSNumber class]] &&
                [value isKindOfClass:[NSString class]]) {
                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
                resultValue = [numberFormatter numberFromString:value];
            }
            
            NSString *valueProtocol = [property.objectProtocols lastObject];
            if ([valueProtocol isKindOfClass:[NSString class]]) {
                Class valueProtocolClass = NSClassFromString(valueProtocol);
                if (valueProtocolClass != nil) {
                    if ([valueProtocolClass isSubclassOfClass:[MMHFetchModel class]]) {
                        //array of models
                        if ([value isKindOfClass:[NSArray class]]) {
                            resultValue = [(NSArray *) value modelArrayOfClass:valueProtocolClass];
                        }
                        //dictionary of models
                        if ([value isKindOfClass:[NSDictionary class]]) {
                            resultValue = [(NSDictionary *)value modelDictionaryWithClass:valueProtocolClass];
                        }
                    }
                }
            }
        }
    }
    return resultValue;
}


- (instancetype)initWithJSONDict:(NSDictionary *)dict keyMap:(NSDictionary *)keyMap
{
    self = [self init];
    if (self) {
        self.modelKeyJSONKeyMapper = keyMap;
        [self setupCachedKeyMapper];
        [self setupCachedProperties];
        [self injectJSONData:dict];
    }
    return self;
}


- (NSArray *)propertiesForCoding {
    return nil;
}


- (NSArray *)propertiesForDescription {
    return [self propertiesForCoding];
}


- (NSString *)description {
    NSMutableString *result = [NSMutableString string];
    
    [result appendString:[super description]];
    [result appendString:@": "];
    
    NSArray *properties = [self propertiesForDescription];
    for (NSString *key in properties) {
        id value = [self valueForKey:key];
        [result appendFormat:@"%@ = %@, ", key, value];
    }
    
    return result;
}


@end
