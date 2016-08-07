//
//  QGHAddAddressViewController.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/10.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHAddAddressViewController.h"
#import "QGHCommonEditCell.h"
#import "QGHCommonCellTableViewCell.h"
#import "MMHSelectAddressView.h"
#import "MMHNetworkAdapter+ReceiptAddress.h"


static NSString *const QGHAddAddressEditCellIdentifier = @"QGHCommonEditCellIdentifier";
static NSString *const QGHAddAddressCommonCellIdentifier = @"QGHAddAddressCommonCellIdentifier";


@interface QGHAddAddressViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISwitch *defaultSwitch;
@property (nonatomic, assign) BOOL waitToHideKeyboard;
@property (nonatomic, strong) QGHAddAddressModel *addAddressModel;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, weak) UITextField *nameField;
@property (nonatomic, weak) UITextField *phoneField;
@property (nonatomic, weak) UITextField *addressField;


@end


@implementation QGHAddAddressViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收货地址";
    if (!self.transferAddressModel) {
        self.transferAddressModel = [[QGHReceiptAddressModel alloc] init];
        self.transferAddressModel.isdefault = @"2";
    }
//    self.addAddressModel = [[QGHAddAddressModel alloc] init];
//    if (self.transferAddressModel) {
//        self.addAddressModel.name = self.transferAddressModel.username;
//        self.addAddressModel.phone = self.transferAddressModel.phone;
//        self.addAddressModel.province = self.transferAddressModel.province;
//        self.addAddressModel.city = self.transferAddressModel.city;
//        self.addAddressModel.area = self.transferAddressModel.area;
//        self.addAddressModel.isDefault = [self.transferAddressModel.isdefault isEqualToString:@"1"]? YES : NO;
//    }
    [self makeTableView];
}


- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    [_tableView registerNib:[UINib nibWithNibName:@"QGHCommonEditCell" bundle:nil] forCellReuseIdentifier:QGHAddAddressEditCellIdentifier];
    [_tableView registerNib:[UINib nibWithNibName:@"QGHCommonEditCell" bundle:nil] forCellReuseIdentifier:QGHAddAddressCommonCellIdentifier];
    _tableView.tableFooterView = [self tableViewFooterView];
    [self.view addSubview:_tableView];
}


- (UIView *)tableViewFooterView {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mmh_screen_width(), 108)];
    
    _confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, mmh_screen_width() - 30, 48)];
//    _confirmButton.backgroundColor = C20;
    [_confirmButton setBackgroundImage:[UIImage patternImageWithColor:C20] forState:UIControlStateNormal];
    [_confirmButton setBackgroundImage:[UIImage patternImageWithColor:C5] forState:UIControlStateDisabled];
    [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmButton setTitleColor:C21 forState:UIControlStateNormal];
    _confirmButton.titleLabel.font = F5;
    _confirmButton.layer.cornerRadius = 5;
    _confirmButton.layer.masksToBounds = YES;
    _confirmButton.enabled = NO;
    [_confirmButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:_confirmButton];
    
    return footer;
}


#pragma mark - UITalbeView DataSource and Delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    } else {
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            QGHCommonEditCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHAddAddressEditCellIdentifier forIndexPath:indexPath];
            cell.title = @"联系人";
            cell.placeHolder = @"收货人姓名";
            cell.textField.delegate = self;
            cell.textField.tag = 1000;
            cell.textField.keyboardType = UIKeyboardTypeDefault;
            self.nameField = cell.textField;
            if (self.transferAddressModel.username.length > 0) {
                self.nameField.text = self.transferAddressModel.username;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else if (indexPath.row == 1) {
            QGHCommonEditCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHAddAddressEditCellIdentifier forIndexPath:indexPath];
            cell.title = @"联系电话";
            cell.placeHolder = @"请输入联系电话";
            cell.textField.delegate = self;
            cell.textField.tag = 1001;
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            self.phoneField = cell.textField;
            if (self.transferAddressModel.phone > 0) {
                self.phoneField.text = self.transferAddressModel.phone;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else if (indexPath.row == 2) {
            QGHCommonEditCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHAddAddressCommonCellIdentifier forIndexPath:indexPath];
            cell.title = @"地区";
            cell.placeHolder = @"省／市／区";
            NSString *text = @"";
            if (self.transferAddressModel.province.length + self.transferAddressModel.city.length + self.transferAddressModel.area.length > 0) {
                text = [NSString stringWithFormat:@"%@%@%@", self.transferAddressModel.province, self.transferAddressModel.city, self.transferAddressModel.area];
            }
            cell.textField.text = text;
            cell.textField.userInteractionEnabled = NO;
            cell.textField.keyboardType = UIKeyboardTypeDefault;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            QGHCommonEditCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHAddAddressEditCellIdentifier forIndexPath:indexPath];
            cell.title = @"详细地址";
            cell.placeHolder = @"具体的详细地址（如街道、门牌号）";
            cell.textField.delegate = self;
            cell.textField.tag = 1002;
            cell.textField.keyboardType = UIKeyboardTypeDefault;
            self.addressField = cell.textField;
            if (self.transferAddressModel.address > 0) {
                cell.textField.text = self.transferAddressModel.address;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }

    } else {
        static NSString *cellIdentifier = @"cellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            _defaultSwitch = [[UISwitch alloc] init];
            [_defaultSwitch addTarget:self action:@selector(switchChangeAction) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = _defaultSwitch;
            if (self.transferAddressModel.isdefault > 0) {
                _defaultSwitch.on = [self.transferAddressModel.isdefault isEqualToString:@"1"] ? YES : NO;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.textLabel.text = @"设为默认收货地址";
        cell.textLabel.font = F3;
        cell.textLabel.textColor = C8;
        
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 2) {
        MMHSelectAddressView *selectAddressView = [[MMHSelectAddressView alloc] init];
        selectAddressView.callback = ^(NSString *province, NSString *city, NSString *area) {
            self.transferAddressModel.province = province;
            self.transferAddressModel.city = city;
            self.transferAddressModel.area = area;
            [self.tableView reloadData];
        };
        [selectAddressView show];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001;
}


#pragma mark - UITextFieldDelegate


- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 1000) {
        self.transferAddressModel.username = textField.text;
    } else if (textField.tag == 1001) {
        self.transferAddressModel.phone = textField.text;
    } else if (textField.tag == 1002) {
        self.transferAddressModel.address = textField.text;
    }
    
    [self updateConfirmState];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.nameField resignFirstResponder];
    [self.phoneField resignFirstResponder];
    [self.addressField resignFirstResponder];
}


#pragma mark - private methods


- (void)updateConfirmState {
    BOOL enable = NO;
    if (self.transferAddressModel.username.length > 0 &&
        self.transferAddressModel.phone.length > 0 &&
        self.transferAddressModel.address.length > 0 &&
        self.transferAddressModel.province.length > 0 &&
        self.transferAddressModel.city.length > 0 &&
        self.transferAddressModel.area.length > 0) {
        enable = YES;
    }
    
    self.confirmButton.enabled = enable;
}


#pragma mark - Actions


- (void)switchChangeAction {
    self.transferAddressModel.isdefault = self.defaultSwitch.on ? @"1": @"2";
}


- (void)confirmButtonAction {
    if (self.transferAddressModel.phone.length != 11) {
        [self.view showTips:@"请输入正确的手机号码"];
        return;
    }
    
    [self.view showProcessingView];
    [[MMHNetworkAdapter sharedAdapter] addOrModifyAddressFrom:self deliveryId:nil addAddressModel:self.transferAddressModel succeededHandler:^{
        [self.view hideProcessingView];
        if (self.addressEditBlock) {
            [self.view showTips:@"修改收货地址成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.addressEditBlock();
            });
        } else {
            [self.view showTips:@"添加收货地址成功"];
            if (self.addAddressBlock) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.addAddressBlock();
                });
            }
        }
        [self performSelector:@selector(popWithAnimation) withObject:nil afterDelay:1];
    } failedHandler:^(NSError *error) {
        [self.view hideProcessingView];
        [self.view showTipsWithError:error];
    }];
}


@end
