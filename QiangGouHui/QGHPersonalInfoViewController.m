//
//  QGHPersonalInfoViewController.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/22.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHPersonalInfoViewController.h"
#import "QGHCommonCellTableViewCell.h"
#import "QGHChangeNickNameViewController.h"
#import "QGHReceiptAddressViewController.h"


static NSString *const QGHPersonalAvatarCommonCellIdentifier = @"QGHPersonalAvatarCommonCellIdentifier";
static NSString *const QGHPersonalInfoCommonCellIdentifier = @"QGHPersonalInfoCommonCellIdentifier";


@interface QGHPersonalInfoViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;

@end


@implementation QGHPersonalInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人信息";
    self.dataSource = @[@"头像", @"昵称", @"性别", @"居住地", @"收货地址"];
    
    [self makeTableView];
    
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存 " style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
    self.navigationItem.rightBarButtonItem = saveItem;
}


- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableView registerNib:[UINib nibWithNibName:@"QGHCommonCellTableViewCell" bundle:nil] forCellReuseIdentifier:QGHPersonalAvatarCommonCellIdentifier];
    [_tableView registerNib:[UINib nibWithNibName:@"QGHCommonCellTableViewCell" bundle:nil] forCellReuseIdentifier:QGHPersonalInfoCommonCellIdentifier];
    
    [self.view addSubview:_tableView];
}


#pragma mark - UITalbeView DataSource and Delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        QGHCommonCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHPersonalAvatarCommonCellIdentifier forIndexPath:indexPath];
        if (![cell.contentView viewWithTag:1000]) {
            MMHImageView *avatar = [[MMHImageView alloc] init];
            avatar.layer.cornerRadius = 20;
            [cell.contentView addSubview:avatar];
            [avatar mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.arrow.mas_left).offset(-15);
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.width.and.height.mas_equalTo(40);
            }];
            avatar.tag = 1000;
        }
        cell.title = self.dataSource[indexPath.row];
        cell.subTitle = @"";
        return cell;
    } else {
        QGHCommonCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHPersonalInfoCommonCellIdentifier forIndexPath:indexPath];
        cell.title = self.dataSource[indexPath.row];
        cell.subTitle = @"";
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 80;
    } else {
        return 48;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"选择图片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self takeAlbum];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self takePhoto];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //TODO
        }];
        [actionSheet addAction:action1];
        [actionSheet addAction:action2];
        [actionSheet addAction:cancelAction];
        
        [self.navigationController presentViewController:actionSheet animated:YES completion:nil];
    } else if (indexPath.row == 1) {
        QGHChangeNickNameViewController *changeNickNameVC = [[QGHChangeNickNameViewController alloc] initWithNickName:@"fuck"];
        [self.navigationController pushViewController:changeNickNameVC animated:YES];
    } else if (indexPath.row == 2) {
        [self takeSex];
    } else if (indexPath.row == 3) {
        
    } else {
        QGHReceiptAddressViewController *receiptAddressVC = [[QGHReceiptAddressViewController alloc] init];
        [self.navigationController pushViewController:receiptAddressVC animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark - UIImagePickerControllerDelegate


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
//    [self updatePortraitWithImage:editedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark - private methods


- (void)takeAlbum {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}


- (void)takePhoto {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        AppAlertViewController *alert = [[AppAlertViewController alloc] initWithParentController:self];
        [alert showAlert:@"提示" message:@"当前相机不可用" sureTitle:nil cancelTitle:@"确定" sure:nil cancel:nil];
    }
}


- (void)takeSex {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"选择图片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"帅哥" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //TODO
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"美女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //TODO
    }];
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    [self.navigationController presentViewController:actionSheet animated:YES completion:nil];
}


#pragma mark - Action


- (void)saveAction {

}


@end
