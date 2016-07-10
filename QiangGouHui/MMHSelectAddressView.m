//
//  MMHSelectAddressView.m
//  MamHao
//
//  Created by fishycx on 16/1/16.
//  Copyright © 2016年 Mamahao. All rights reserved.
//

#import "MMHSelectAddressView.h"
#import "MMHAddressSingleModel.h"
//#import "MMHNetworkAdapter+Address.h"
//#import "MMHAddressModel.h"


//#import <MAMapKit/MAMapKit.h>
//#import <AMapSearchKit/AMapSearchAPI.h>
//#import "MMHGeoCodeAnnotation.h"
//#import "MMHCurrentLocationModel.h"
//#import "MMHLocationManager.h"

@interface MMHSelectAddressView ()<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>


@property (strong, nonatomic) UIPickerView *pickView;

//@property (nonatomic, strong) MMHAddressSingleModel *addressSingleModel;
@property (nonatomic, strong) NSDictionary *areaDict;

//省 数组
@property (strong, nonatomic) NSArray *provienceList;
//城市 数组
@property (strong, nonatomic) NSArray *cityArr;
//区县 数组
@property (strong, nonatomic) NSArray *areaArr;

@property (nonatomic, strong) UITextField *textField;

//@property (nonatomic, strong) MMHAddressModel *currentModel;


//@property (nonatomic, strong) MMHAddressModel *selectedProvienceModel;
//@property (nonatomic, strong) MMHAddressCityModel *selectedCityModel;
//@property (nonatomic, strong) MMHAddressAreaModel *selectedAreaModel;
@property (nonatomic, copy) NSString *selectedProvience;
@property (nonatomic, copy) NSString *selectedCity;
@property (nonatomic, copy) NSString *selectedArea;

//@property (nonatomic,strong)AMapSearchAPI *search;                              /**< searchAPI*/


@end


@implementation MMHSelectAddressView

- (UIPickerView *)pickView {
    if (!_pickView) {
        self.pickView = [[UIPickerView alloc] init];
        _pickView.backgroundColor = [UIColor whiteColor];
        _pickView.delegate = self;
        _pickView.dataSource = self;
    }
    return _pickView;
}


- (instancetype)init{
    
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.pickView.delegate = self;
        self.pickView.dataSource = self;
        self.textField = [[UITextField alloc] init];
        self.textField.inputView = self.pickView;
        
        
        UIBarButtonItem *cancleBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelSelect:)];
        UIBarButtonItem *confirmBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(confirmSelect:)];
        confirmBtn.tintColor = [UIColor colorWithHexString:@"447ed8"];
        cancleBtn.tintColor = [UIColor colorWithHexString:@"447ed8"];
        UIBarButtonItem *flexBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        toolBar.tintColor = [UIColor whiteColor];
        [toolBar setItems:@[cancleBtn,flexBtn,confirmBtn]];
        self.textField.inputAccessoryView = toolBar;

        
        [self.textField becomeFirstResponder];
        [self addSubview:self.textField];

    }
    return self;
}



- (void)cancelSelect:(UIBarButtonItem *)sender {
    [self.textField resignFirstResponder];
    [self hide];
}


-(void)confirmSelect:(UIBarButtonItem *)sender {
    sender.enabled = !sender.enabled;
    if (self.selectedProvience == nil) {
        return;
    }
    if (self.selectedCity == nil) {
        return;
    }
    
    if (self.selectedArea == nil) {
        return;
    }
    
    self.callback(self.selectedProvience, self.selectedCity, self.selectedArea);
    [self hide];
//    [self searchGeocodeWithKey:[NSString stringWithFormat:@"%@%@%@", self.selectedProvienceModel.prvName, self.selectedCityModel.cityName, self.selectedAreaModel.areaName] adcode:self.selectedAreaModel.areaId];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
        [self hide];
    }
}


- (NSDictionary *)getAddressInfo{
    NSString *filePath = [NSString filePathWithName:@"addressInfo"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
        return dic;
    }
    return nil;
    
}




#pragma mark - fetchData


- (void)loadLocalData{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"address"
                                                   ofType:@"plist"];
    NSDictionary *areaDict = [NSDictionary dictionaryWithContentsOfFile:path];
    self.areaDict = areaDict;
    self.cityArr = [self getCityList:self.provienceList.firstObject];
    self.areaArr = [self getAreaList:self.provienceList.firstObject city:self.cityArr.firstObject];
    
    self.selectedProvience = self.provienceList.firstObject;
    self.selectedCity = self.cityArr.firstObject;
    self.selectedArea = self.areaArr.firstObject;
    
    [self.pickView reloadAllComponents];
//    NSArray *provinceKeys = [[self.areaDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//        NSNumber *num1 = (NSNumber *)obj1;
//        NSNumber *num2 = (NSNumber *)obj2;
//        return [num1 integerValue] < [num2 integerValue];
//    }];
//    
//    NSMutableArray *provinceArr = [NSMutableArray array];
//    for (NSNumber *provinceKey in areaDict) {
//        NSDictionary *
//    }
//    
//    NSDictionary *dic = [self getAddressInfo];
//    NSArray *array = dic[@"data"];
//    NSArray *modelList = [array transformedArrayUsingHandler:^id(id originalObject, NSUInteger index) {
//        return [[MMHAddressModel alloc] initWithJSONDict:originalObject];
//    }];
//    self.provienceList = modelList;
//    MMHAddressModel *selectedProvienceModel = self.provienceList[0];
//    self.selectedProvienceModel = selectedProvienceModel;
//    if (selectedProvienceModel != nil) {
//        self.cityArr = selectedProvienceModel.city;
//    }
//    MMHAddressCityModel *cityModel = self.cityArr[0];
//    self.selectedCityModel = cityModel;
//    self.areaArr = cityModel.area;
//    self.selectedAreaModel  = self.areaArr[0];
//    [self.pickView reloadAllComponents];
//    if (modelList.count != 0) {
//        return YES;
//    }
//    return NO;
}




#pragma  mark - function

- (void)show {
//    [self fetchAddressInfo];
//    [self createSearch];
    [self loadLocalData];
    
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    UIView *topView = [win.subviews firstObject];
    [topView addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        [self layoutIfNeeded];
    }];
}

- (void)hide {
    [self.textField removeFromSuperview];
    self.textField = nil;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self hide];
}


#pragma mark - UIPickViewDelegate 


#pragma mark - UIPickerViewDataSource


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.provienceList == nil) {
        return 0;
    }
    return 3;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provienceList.count;
    }
    if (component == 1) {
        return self.cityArr.count;
    }
    if (component == 2) {
        return self.areaArr.count;
    }
    return 0;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"省%ld", [pickerView selectedRowInComponent:0]);
    NSLog(@"市%ld", [pickerView selectedRowInComponent:1]);
    NSLog(@"区%ld", [pickerView selectedRowInComponent:2]);
    
    switch (component) {
        case 0:
        {
            self.selectedProvience = self.provienceList[row];
            if (self.selectedProvience != nil) {
                self.cityArr = [self getCityList:self.selectedProvience];
            }
            [pickerView reloadComponent:1];
            [self.pickView selectRow:0 inComponent:1 animated:YES];

//            MMHAddressCityModel *cityModel = selectedProvienceModel.city[0];
            self.selectedCity = self.cityArr.firstObject;
            self.areaArr = [self getAreaList:self.selectedProvience city:self.selectedCity];
            self.selectedArea = self.areaArr.firstObject;
            [pickerView reloadComponent:2];
            [self.pickView selectRow:0 inComponent:2 animated:YES];

            
        }
            break;
        case 1:
        {
//            MMHAddressCityModel *cityModel = self.cityArr[row];
            self.selectedCity = self.cityArr[row];
            self.areaArr = [self getAreaList:self.selectedProvience city:self.selectedCity];
            self.selectedArea = self.areaArr.firstObject;
            [pickerView reloadComponent:2];
            [self.pickView selectRow:0 inComponent:2 animated:YES];

        }
            break;
        case 2:
        {
            self.selectedArea  = self.areaArr[row];

        }
            break;
        default:
            break;
    }
}


- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    switch (component) {
        case 0:
        {
            return self.provienceList[row];
        }
            break;
        case 1:
        {
            return self.cityArr[row];
        }
            break;
        case 2:
        {
            return self.areaArr[row];
        }
            break;
            
        default:
            break;
    }
    return @"";
}


- (NSArray *)provienceList {
    if (!_provienceList) {
        _provienceList = [self.areaDict.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSString *str1 = (NSString *)obj1;
            NSString *str2 = (NSString *)obj2;
            return [str1 compare:str2];
        }];
    }
    
    return _provienceList;
}


- (NSArray *)getCityList:(NSString *)province {
    NSDictionary *cityAreaDict = self.areaDict[province];
    return [cityAreaDict.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *str1 = (NSString *)obj1;
        NSString *str2 = (NSString *)obj2;
        return [str1 compare:str2];
    }];
}


- (NSArray *)getAreaList:(NSString *)province city:(NSString *)city {
    NSDictionary *cityAreaDict = self.areaDict[province];
    NSArray *areaArr = [cityAreaDict objectForKey:city];
    return [areaArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *str1 = (NSString *)obj1;
        NSString *str2 = (NSString *)obj2;
        return [str1 compare:str2];
    }];
}


//#pragma mark - AMapSearchAPI
//
//
//-(void)createSearch {
//    self.search = [[AMapSearchAPI alloc] initWithSearchKey:[MAMapServices sharedServices].apiKey Delegate:nil];
//    self.search.delegate = self;
//}
//
//
//- (void)clearSearch {
//    self.search.delegate = nil;
//}
//


//#pragma mark - 地理编码 搜索
//
//
//- (void)searchGeocodeWithKey:(NSString *)key adcode:(NSString *)adcode {
//    if (key.length == 0) {
//        return;
//    }
////    [self showProcessingView];
//    
//    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
//    geo.address = key;
//    
//    if (self.selectedAreaModel.areaName.length > 0) {
//        geo.city = @[self.selectedAreaModel.areaName];
//    }
//    
//    [self.search AMapGeocodeSearch:geo];
//    
//}
//
///* 地理编码回调.*/
//- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response {
//    if (response.geocodes.count == 0) {
//        AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
//        geo.address = self.selectedCityModel.cityName;
//        [self.search AMapGeocodeSearch:geo];
//        return;
//    }
//    
//    AMapGeocode *firstObject = response.geocodes.firstObject;
//    
//    MMHAddressSingleModel *blockModel = [[MMHAddressSingleModel alloc] init];
//    blockModel.province = firstObject.province;
//    blockModel.city = firstObject.city;
//    blockModel.area = firstObject.district;
//    blockModel.areaId = self.selectedAreaModel.areaId;
//    blockModel.cityId = self.selectedCityModel.cityId;
//    blockModel.lat = firstObject.location.latitude;
//    blockModel.lng = firstObject.location.longitude;
//    blockModel.provinceId = self.selectedProvienceModel.prvId;
////    [self hideProcessingView];
//    [self hide];
//    if (self.callback) {
//        self.callback(blockModel);
//    }
//}
//

- (void)dealloc {
    self.pickView.delegate = nil;
    [self.pickView removeFromSuperview];
}

@end
