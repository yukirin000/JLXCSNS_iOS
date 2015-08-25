//
//  ChoiceLocationViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/14.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "ChoiceLocationViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@interface ChoiceLocationViewController ()<MAMapViewDelegate, AMapSearchDelegate,UISearchBarDelegate>

/*!
 @property
 @brief 展示列表的TableView
 */
@property UISearchBar *searchBar;

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) AMapSearchAPI *search;

@property (nonatomic, strong) MAUserLocation * currentLocation;

@end

@implementation ChoiceLocationViewController
{
    ChoiceLocationBlock _choiceBlock;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavBarTitle:@"我在这里"];
    
    [self initMap];
    
    [self configUI];
}

- (void)configUI
{
//    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.refreshTableView.frame.size.width, 0)];
//    [_searchBar setDelegate:self];
//    [_searchBar setPlaceholder:@"搜索"];
//    [_searchBar sizeToFit];
//    [_searchBar setTranslucent:YES];
//    [self.refreshTableView setTableHeaderView:_searchBar];
    
    UIView * headBackView        = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 80)];
    headBackView.backgroundColor = [UIColor colorWithHexString:ColorLightWhite];
    [self.refreshTableView setTableHeaderView:headBackView];
    
    CustomButton * topNoBtn  = [[CustomButton alloc] initWithFrame:CGRectMake(10, 10, self.refreshTableView.frame.size.width-20, 60)];
    topNoBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    topNoBtn.backgroundColor = [UIColor whiteColor];
    [topNoBtn setTitle:@"不显示了吧" forState:UIControlStateNormal];
    [topNoBtn setTitleColor:[UIColor colorWithHexString:ColorDeepBlack] forState:UIControlStateNormal];
    [topNoBtn addTarget:self action:@selector(noLocationPress:) forControlEvents:UIControlEventTouchUpInside];
    [headBackView addSubview:topNoBtn];
}

#pragma mark- override
//下拉刷新
- (void)refreshData
{
    [super refreshData];
    
    [self searchPoiByCenterCoordinate];
    
}

//加载更多
- (void)loadingData
{
    [super loadingData];
    [self searchPoiByCenterCoordinate];
    
}

#pragma mark - AMapSearchDelegate
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
//        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        self.currentLocation = userLocation;
        self.mapView.showsUserLocation = NO;
        [self searchPoiByCenterCoordinate];
        
    }
}

#pragma mark - AMapSearchDelegate
- (void)searchRequest:(id)request didFailWithError:(NSError *)error
{
//    NSLog(@"%s: searchRequest = %@, errInfo= %@", __func__, [request class], error);
    [self refreshFinish];
}
/* POI 搜索回调. */
- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)respons
{
//    NSLog(@"!!!!!!!!");
//    for (AMapPOI *p in respons.pois) {
//        NSLog(@"%@ %@ %@", p.name, p.type, p.uid);
//    }

    //小于20最后一页
    if (respons.pois.count < 20)
    {
        self.isLastPage = YES;
    }
    
    //如果刚刷新结束 删除所有内容
    if (self.isReloading) {
        [self.dataArr removeAllObjects];
    }
    [self.dataArr addObjectsFromArray:respons.pois];
    //统一刷新
    [self reloadTable];
}


#pragma mark- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMapPOI * mapPoi = self.dataArr[indexPath.row];
    
    if (_choiceBlock) {
        _choiceBlock(mapPoi.name);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

#pragma mark - Search Bar Delegate
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar; {
    
    //数据初始化
    self.currentPage = 1;
    [searchBar resignFirstResponder];
    [self refreshData];
}


#pragma mark- private method
- (void)noLocationPress:(id)sender
{
    if (_choiceBlock) {
        _choiceBlock(@"");
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

//设置选中之后的block
- (void)setChoickBlock:(ChoiceLocationBlock)block
{
    _choiceBlock = [block copy];
}

/*! 重写该方法定制Cell*/
- (void)handleTableViewContentWith:(UITableViewCell *)cell andIndexPath:(NSIndexPath *)indexPath
{
    AMapPOI * mapPoi         = self.dataArr[indexPath.row];

    CustomLabel * titleLabel = [[CustomLabel alloc] initWithFrame:CGRectMake(25, 0, self.viewWidth-25, 45)];
    titleLabel.font          = [UIFont systemFontOfSize:15];
    titleLabel.textColor     = [UIColor colorWithHexString:ColorDeepBlack];
    titleLabel.text          = mapPoi.name;
    [cell.contentView addSubview:titleLabel];

    UIView * lineView        = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.viewWidth, 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:ColorLightGary];
    [cell.contentView addSubview:lineView];
}

- (void)initMap
{
    self.mapView                   = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate          = self;
    self.mapView.showsUserLocation = YES;
    self.search                    = [[AMapSearchAPI alloc] initWithSearchKey:[MAMapServices sharedServices].apiKey Delegate:self];
    
}

/* 根据中心点坐标来搜周边的POI. */
- (void)searchPoiByCenterCoordinate
{
    AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
    
    request.searchType        = AMapSearchType_PlaceAround;
    CLLocationCoordinate2D cc = self.currentLocation.location.coordinate;
    request.location          = [AMapGeoPoint locationWithLatitude:cc.latitude longitude:cc.longitude];
    request.radius            = 1000;
    request.keywords          = self.searchBar.text;
    request.offset            = 20;
    request.page              = self.currentPage;
    /* 按照距离排序. */
    request.sortrule          = 1;
    request.requireExtension  = YES;
    
    [self.search AMapPlaceSearch:request];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
