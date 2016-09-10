//
//  QGHFirstSlideViewController.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/9/10.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHFirstSlideViewController.h"
#import "MMHNetworkAdapter+FirstPage.h"
#import "QGHClassificationItem.h"
#import <UIImageView+WebCache.h>
#import "QGHClassificationCell.h"


@interface QGHFirstSlideViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<QGHClassificationItem *> *itemArr;
@property (nonatomic, strong) NSArray<QGHClassificationItem *> *dataSource;

@end


@implementation QGHFirstSlideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width * 2 / 3, self.view.bounds.size.height) style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [self fetchData];
}


- (void)fetchData {
    [[MMHNetworkAdapter sharedAdapter] fetchClassficationFrom:self succeededHandler:^(NSArray<QGHClassificationItem *> *itemArr) {
        _itemArr = itemArr;
        _dataSource = [self configureDataSource:itemArr];
        [self.tableView reloadData];
    } failedHandler:^(NSError *error) {
        //
    }];
}


- (NSInteger)numOfItemArr:(NSArray<QGHClassificationItem *> *)arr {
    NSInteger num = 0;
    for (QGHClassificationItem *item in arr) {
        if (item.isUnfold) {
            num += 1 + [self numOfItemArr:item.itemArr];
        } else {
            num += 1;
        }
    }
    
    return num;
}


- (NSArray<QGHClassificationItem *> *)configureDataSource:(NSArray<QGHClassificationItem *> *)itemArr {
    NSMutableArray *arr = [NSMutableArray array];
    for (QGHClassificationItem *item in itemArr) {
        [arr addObject:item];
        if (item.isUnfold) {
            [arr addObjectsFromArray:[self configureDataSource:item.itemArr]];
        }
    }
    
    return arr;
}


#pragma mark - UITalbeView DataSource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numOfItemArr:self.itemArr];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    
    QGHClassificationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[QGHClassificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    QGHClassificationItem *item = self.dataSource[indexPath.row];
    cell.item = item;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QGHClassificationItem *item = self.dataSource[indexPath.row];
    if (item.canUnfold) {
        item.isUnfold = !item.isUnfold;
        self.dataSource = [self configureDataSource:self.itemArr];
        [tableView reloadData];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [UIView animateWithDuration:0.5 animations:^{
        self.view.x = -mmh_screen_width();
    }];
}


@end
