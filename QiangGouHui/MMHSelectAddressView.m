////
////  MMHSelectAddressView.m
////  MamHao
////
////  Created by fishycx on 16/1/16.
////  Copyright © 2016年 Mamahao. All rights reserved.
////
//
//#import "MMHSelectAddressView.h"
//#import "MMHAddressSingleModel.h"
////#import "MMHNetworkAdapter+Address.h"
////#import "MMHAddressModel.h"
//
//
//#import <MAMapKit/MAMapKit.h>
//#import <AMapSearchKit/AMapSearchAPI.h>
//#import "MMHGeoCodeAnnotation.h"
//#import "MMHCurrentLocationModel.h"
//#import "MMHLocationManager.h"
//
//@interface MMHSelectAddressView ()<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, MAMapViewDelegate, AMapSearchDelegate>
//
//
//@property (strong, nonatomic) UIPickerView *pickView;
//
//@property (nonatomic, strong) MMHAddressSingleModel *addressSingleModel;
////省 数组
//@property (strong, nonatomic) NSArray *provienceList;
////城市 数组
//@property (strong, nonatomic) NSArray *cityArr;
////区县 数组
//@property (strong, nonatomic) NSArray *areaArr;
//
//@property (nonatomic, strong) UITextField *textField;
//
//@property (nonatomic, strong) MMHAddressModel *currentModel;
//
//
//@property (nonatomic, strong) MMHAddressModel *selectedProvienceModel;
//@property (nonatomic, strong) MMHAddressCityModel *selectedCityModel;
//@property (nonatomic, strong) MMHAddressAreaModel *selectedAreaModel;
//
//
//@property (nonatomic,strong)AMapSearchAPI *search;                              /**< searchAPI*/
//
//
//@end
//
//
//@implementation MMHSelectAddressView
//
//- (UIPickerView *)pickView {
//    if (!_pickView) {
//        self.pickView = [[UIPickerView alloc] init];
//        _pickView.backgroundColor = [UIColor whiteColor];
//        _pickView.delegate = self;
//        _pickView.dataSource = self;
//    }
//    return _pickView;
//}
//
//
//- (instancetype)init{
//    
//    if (self = [super init]) {
//        self.frame = [UIScreen mainScreen].bounds;
//        self.pickView.delegate = self;
//        self.pickView.dataSource = self;
//        self.textField = [[UITextField alloc] init];
//        self.textField.inputView = self.pickView;
//        
//        
//        UIBarButtonItem *cancleBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelSelect:)];
//        cancleBtn.tintColor = [UIColor grayColor];
//        UIBarButtonItem *confirmBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(confirmSelect:)];
//        confirmBtn.tintColor = [UIColor colorWithCustomerName:@"蓝"];
//        cancleBtn.tintColor = [UIColor colorWithCustomerName:@"蓝"];
//        UIBarButtonItem *flexBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
//        toolBar.tintColor = [UIColor whiteColor];
//        [toolBar setItems:@[cancleBtn,flexBtn,confirmBtn]];
//        self.textField.inputAccessoryView = toolBar;
//
//        
//        [self.textField becomeFirstResponder];
//        [self addSubview:self.textField];
//
//    }
//    return self;
//}
//
//
//
//- (void)cancelSelect:(UIBarButtonItem *)sender {
//    [self.textField resignFirstResponder];
//    [self hide];
//}
//
//
//-(void)confirmSelect:(UIBarButtonItem *)sender {
//    sender.enabled = !sender.enabled;
//    if (self.selectedProvienceModel == nil) {
//        return;
//    }
//    if (self.selectedCityModel == nil) {
//        return;
//    }
//    
//    if (self.selectedAreaModel == nil) {
//        return;
//    }
//    
//    
//    [self searchGeocodeWithKey:[NSString stringWithFormat:@"%@%@%@", self.selectedProvienceModel.prvName, self.selectedCityModel.cityName, self.selectedAreaModel.areaName] adcode:self.selectedAreaModel.areaId];
//}
//
//
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
//    if ([self.textField isFirstResponder]) {
//        [self.textField resignFirstResponder];
//        [self hide];
//    }
//}
//
//
//- (NSDictionary *)getAddressInfo{
//    NSString *filePath = [NSString filePathWithName:@"addressInfo"];
//    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
//        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
//        return dic;
//    }
//    return nil;
//    
//}
//
//
//
//
//#pragma mark - fetchData
//
//
//- (BOOL)loadLocalData{
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
//}
//
//
//- (void)fetchAddressInfo {
//    //加载本地数据，同时请求网络数据。数据回来更新。
//    if (![self loadLocalData]) {
//        [self showProcessingView];
//    }
//    __weak __typeof(self) weakSelf = self;
//    [[MMHNetworkAdapter sharedAdapter] fetchAddressInfoFrom:self succeededHandler:^(NSArray *cityAreaList) {
//        if (!weakSelf) {
//            return ;
//        }
//        __strong typeof(weakSelf)strongSelf = weakSelf;
//        [strongSelf hideProcessingView];
//        strongSelf.provienceList = cityAreaList;
//        
//        MMHAddressModel *selectedProvienceModel = self.provienceList[0];
//        self.selectedProvienceModel = selectedProvienceModel;
//        if (selectedProvienceModel != nil) {
//            self.cityArr = selectedProvienceModel.city;
//        }
//        MMHAddressCityModel *cityModel = self.cityArr[0];
//        self.selectedCityModel = cityModel;
//        self.areaArr = cityModel.area;
//        self.selectedAreaModel  = self.areaArr[0];
//        [strongSelf.pickView reloadAllComponents];
//        
//        
//    } failedHandler:^(NSError *error) {
//        if (!weakSelf) {
//            return ;
//        }
//        __strong typeof(weakSelf)strongSelf =weakSelf;
//        [strongSelf showTipsWithError:error];
//    }];
//}
//
//
//#pragma  mark - function
//
//- (void)show {
//    [self fetchAddressInfo];
//    [self createSearch];
//    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
//    UIView *topView = [win.subviews firstObject];
//    [topView addSubview:self];
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
//        [self layoutIfNeeded];
//    }];
//}
//
//- (void)hide {
//    [self.textField removeFromSuperview];
//    self.textField = nil;
//    [UIView animateWithDuration:0.3 animations:^{
//        self.alpha = 0;
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//    }];
//}
//
//
//
//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    [self hide];
//}
//
//
//#pragma mark - UIPickViewDelegate 
//
//
//#pragma mark - UIPickerViewDataSource
//
//
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
//    if (self.provienceList == nil) {
//        return 0;
//    }
//    return 3;
//}
//
//
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
//    if (component == 0) {
//        return self.provienceList.count;
//    }
//    if (component == 1) {
//        return self.cityArr.count;
//    }
//    if (component == 2) {
//        return self.areaArr.count;
//    }
//    return 0;
//}
//
//
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    NSLog(@"省%ld", [pickerView selectedRowInComponent:0]);
//    NSLog(@"市%ld", [pickerView selectedRowInComponent:1]);
//    NSLog(@"区%ld", [pickerView selectedRowInComponent:2]);
//    
//    switch (component) {
//        case 0:
//        {
//            MMHAddressModel *selectedProvienceModel = self.provienceList[row];
//            self.selectedProvienceModel = selectedProvienceModel;
//            if (selectedProvienceModel != nil) {
//                self.cityArr = selectedProvienceModel.city;
//            }
//            [pickerView reloadComponent:1];
//            [self.pickView selectRow:0 inComponent:1 animated:YES];
//
//            MMHAddressCityModel *cityModel = selectedProvienceModel.city[0];
//            self.selectedCityModel = cityModel;
//            self.areaArr = cityModel.area;
//            self.selectedAreaModel = self.areaArr[0];
//            [pickerView reloadComponent:2];
//            [self.pickView selectRow:0 inComponent:2 animated:YES];
//
//            
//        }
//            break;
//        case 1:
//        {
//            MMHAddressCityModel *cityModel = self.cityArr[row];
//            self.selectedCityModel = cityModel;
//            self.areaArr = cityModel.area;
//            self.selectedAreaModel = self.areaArr[0];
//            [pickerView reloadComponent:2];
//            [self.pickView selectRow:0 inComponent:2 animated:YES];
//
//        }
//            break;
//        case 2:
//        {
//            self.selectedAreaModel  = self.areaArr[row];
//
//        }
//            break;
//        default:
//            break;
//    }
//}
//
//
//- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    
//    switch (component) {
//        case 0:
//        {
//            MMHAddressModel *provienceModel = self.provienceList[row];
//            return provienceModel.prvName;
//        }
//            break;
//        case 1:
//        {
//            MMHAddressCityModel *cityModel = self.cityArr[row];
//            return cityModel.cityName;
//        }
//            break;
//        case 2:
//        {
//            MMHAddressAreaModel *areaModel = self.areaArr[row];
//            return areaModel.areaName;
//        }
//            break;
//            
//        default:
//            break;
//    }
//    return @"";
//}
//
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
//
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
//
//- (void)dealloc {
//    self.pickView.delegate = nil;
//    [self.pickView removeFromSuperview];
//}
//
//@end
