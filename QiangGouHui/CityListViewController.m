//
//  CityListViewController.m
//  CityList
//
//  Created by Chen Yaoqiang on 14-3-6.
//
//

#import "CityListViewController.h"
#import "QGHLocationManager.h"

@interface CityListViewController ()

@end

@implementation CityListViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.arrayHotCity = [NSMutableArray arrayWithObjects:@"北京", @"上海", @"广州", @"深圳", @"杭州", @"成都", nil];
        self.keys = [NSMutableArray array];
        self.arrayCitys = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"选择城市";
    self.view.backgroundColor = [QGHAppearance backgroundColor];
    
    [self getCityData];
    
    [self makeHeaderView];
    
	// Do any additional setup after loading the view.
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 54, mmh_screen_width(), self.view.height - 54) style:UITableViewStylePlain];
    _tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}


- (void)makeHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, mmh_screen_width(), 44)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] init];
    NSString *cityStr = [[QGHLocationManager shareManager] currentCity];
    if (cityStr.length == 0) {
        cityStr = @"无";
    }
    label.text = [NSString stringWithFormat:@"您当前定位的城市：%@", cityStr];
    label.font = F5;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    label.x = 15;
    label.centerY = 22;
    [headerView addSubview:label];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationCityTap)];
    [headerView addGestureRecognizer:tap];
    
    
    [self.view addSubview:headerView];
}


#pragma mark - 获取城市数据
-(void)getCityData
{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"citydict"
                                                   ofType:@"plist"];
    self.cities = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    [self.keys addObjectsFromArray:[[self.cities allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    
    //添加热门城市
    NSString *strHot = @"热";
    [self.keys insertObject:strHot atIndex:0];
//    [self.cities setObject:_arrayHotCity forKey:strHot];
}

#pragma mark - tableView
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString *key = [_keys objectAtIndex:section];
    if ([key rangeOfString:@"热"].location != NSNotFound) {
        return 125 + 20 + 12;
    }
    
    return 20.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *key = [_keys objectAtIndex:section];
    if ([key rangeOfString:@"热"].location != NSNotFound) {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mmh_screen_width(), 0)];

        
        UILabel *hotCityTitle = [[UILabel alloc] init];
        hotCityTitle.text = @"热门城市";
        hotCityTitle.font = F2;
        hotCityTitle.textColor = C7;
        [hotCityTitle sizeToFit];
        hotCityTitle.x = 15;
        hotCityTitle.y = 20;
        hotCityTitle.height = 12;
        [contentView addSubview:hotCityTitle];
        
        CGFloat bottom = 0;
        
        CGFloat buttonWidth = (mmh_screen_width() - 15 - 4 * 15) / 3;
        for (int i = 0; i < self.arrayHotCity.count; ++i) {
            NSString *city = self.arrayHotCity[i];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15 + (i % 3) * (15 + buttonWidth) , 20 + 12 + 15 + (i / 3) * (40 + 15), buttonWidth, 40)];
            button.backgroundColor = [UIColor whiteColor];
            [button setTitle:city forState:UIControlStateNormal];
            [button setTitleColor:C8 forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            button.layer.borderColor = C6.CGColor;
            button.layer.borderWidth = 1;
            [button addTarget:self action:@selector(hotCityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [contentView addSubview:button];
            bottom = button.bottom;
        }
        
        bottom += 15;
        
        contentView.height = bottom;
        
        return contentView;
    } else {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        bgView.backgroundColor = [QGHAppearance backgroundColor];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 250, 20)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.text = key;
        [bgView addSubview:titleLabel];
        
        return bgView;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _keys;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_keys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *key = [_keys objectAtIndex:section];
    NSArray *citySection = [_cities objectForKey:key];
    return [citySection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    NSString *key = [_keys objectAtIndex:indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.textLabel setTextColor:[UIColor blackColor]];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    NSString *city = [[_cities objectForKey:key] objectAtIndex:indexPath.row];
    if ([city hasSuffix:@"市"]) {
        city = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
    }
    cell.textLabel.text = city;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectCityBlock) {
        NSString *key = [_keys objectAtIndex:indexPath.section];
        NSString *city = [[_cities objectForKey:key] objectAtIndex:indexPath.row];
        if ([city hasSuffix:@"市"]) {
            city = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
        }
        self.selectCityBlock(city);
    }
}


- (void)locationCityTap {
    self.selectCityBlock([[QGHLocationManager shareManager] currentCity]);
}


- (void)hotCityButtonAction:(UIButton *)sender {
    self.selectCityBlock(sender.titleLabel.text);
}


@end
