//
//  QGHCommentListViewController.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/24.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHCommentListViewController.h"
#import "QGHCommentList.h"
#import "QGHProductDetailCommentCell.h"


static NSString *const QGHProductDetailCommentTitleCellIdentifier = @"QGHProductDetailCommentTitleCellIdentifier";
static NSString *const QGHProductCommentCellIdentifier = @"QGHProductCommentCellIdentifier";


@interface QGHCommentListViewController ()<UITableViewDataSource, UITableViewDelegate, MMHTimelineDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) QGHCommentList *commentList;

@end


@implementation QGHCommentListViewController


- (instancetype)initWithGoodsId:(NSString *)goodsId {
    self = [super init];
    
    if (self) {
        _commentList = [[QGHCommentList alloc] initWithGoodsId:goodsId];
        _commentList.delegate = self;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评价";
    
    [self createTableView];
    [self.commentList refetch];
}


- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    //    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.backgroundColor = [QGHAppearance backgroundColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:QGHProductDetailCommentTitleCellIdentifier];
    [_tableView registerNib:[UINib nibWithNibName:@"QGHProductDetailCommentCell" bundle:nil]forCellReuseIdentifier:QGHProductCommentCellIdentifier];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.and.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}


#pragma mark - UITalbeView DataSource and Delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.commentList numberOfItems] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHProductDetailCommentTitleCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"商品评价(%@条，%@好评率)", self.commentList.scoreInfo.count, self.commentList.scoreInfo.star];
        cell.textLabel.font = F5;
        cell.textLabel.textColor = C8;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        QGHProductDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHProductCommentCellIdentifier forIndexPath:indexPath];
        QGHProductDetailComment *comment = [self.commentList itemAtIndex:indexPath.row - 1];
        [cell setComment:comment];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 48;
    } else {
        return 89;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat height = [self tableView:tableView heightForHeaderInSection:section];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mmh_screen_width(), height)];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}


#pragma mark - MMHTimelineDelegate


- (void)timelineDataRefetched:(MMHTimeline *)timeline {
    [self.view hideProcessingView];
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:YES];
}


- (void)timelineMoreDataFetched:(MMHTimeline *)timeline {
    [self.view hideProcessingView];
    [self.tableView reloadData];
    [self.tableView.mj_footer endRefreshing];
    if (![timeline hasMoreItems]) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView removeFooter];
    }
}


- (void)timeline:(MMHTimeline *)timeline fetchingFailed:(NSError *)error {
    [self.view hideProcessingView];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.view showTipsWithError:error];
}
@end
