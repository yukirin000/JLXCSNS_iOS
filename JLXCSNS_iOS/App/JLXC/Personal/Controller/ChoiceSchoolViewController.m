//
//  ChoiceSchollViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/12.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "ChoiceSchoolViewController.h"
#import "RegisterInformationViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@interface SchoolModel : NSObject

//s.code,s.name,d.name districtName, c.name cityName, s.level
/*! 学校代码*/
@property (nonatomic, copy) NSString * schoolCode;
/*! 学校姓名*/
@property (nonatomic, copy) NSString * schoolName;
/*! 区名*/
@property (nonatomic, copy) NSString * districtName;
/*! 城市名*/
@property (nonatomic, copy) NSString * cityName;
/*! 级别 2为高中 1为初中*/
@property (nonatomic, assign) NSInteger level;

@end

@implementation SchoolModel
@end

@interface ChoiceSchoolViewController ()<MAMapViewDelegate, AMapSearchDelegate,UISearchBarDelegate>
/*!
 @property
 @brief 展示列表的TableView
 */
@property UISearchBar *searchBar;

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) AMapSearchAPI *search;
//当前位置
@property (nonatomic, strong) MAUserLocation * currentLocation;
//当前位置详情
@property (nonatomic, strong) AMapReGeocodeSearchResponse * mapReGeocodeSearchResponse;
//关键字搜索
//@property (nonatomic, assign) BOOL isKeyWord;
////当前关键字
//@property (nonatomic, copy) NSString * keyWords;

@end

@implementation ChoiceSchoolViewController
{
    ChoiceSchoolBlock _choiceSchoolBlock;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showLoading:@"定位中...."];
    
    [self initMap];

    [self configUI];
    
//    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
//        NSLog(@"没打开");
//    }else{
//        NSLog(@"打开");
//    }
    
}

- (void)configUI
{
    
    [self.navBar setNavTitle:@"选择学校"];
    
    //头部背景
    UIView * headView          = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.refreshTableView.frame.size.width, 30)];
    headView.backgroundColor   = [UIColor colorWithHexString:ColorLightWhite];
    //搜索bar
    _searchBar                 = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.refreshTableView.frame.size.width, 0)];
    _searchBar.backgroundColor = [UIColor clearColor];
    _searchBar.tintColor       = [UIColor colorWithHexString:ColorOrange];
    UIView * searchView = self.searchBar.subviews[0];
    searchView.backgroundColor = [UIColor colorWithHexString:ColorLightGary];
    for (UIView *view in self.searchBar.subviews) {
        // for before iOS7.0
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
            break;
        }
        // for later iOS7.0(include)
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    
    [_searchBar setDelegate:self];
    [_searchBar setPlaceholder:@"伙计你的学校是.."];
    [_searchBar sizeToFit];
    [_searchBar setTranslucent:YES];
    [headView addSubview:_searchBar];
    //提示lable
    CustomLabel * topPromptLabel   = [[CustomLabel alloc] initWithFrame:CGRectMake(10, _searchBar.bottom-2, 200, 20)];
    topPromptLabel.text            = @"猜你在这些学校(·ω＜)";
    topPromptLabel.textColor       = [UIColor colorWithHexString:ColorDeepGary];
    topPromptLabel.font            = [UIFont systemFontOfSize:10];

    headView.height                = topPromptLabel.bottom;
    [headView addSubview:topPromptLabel];

    [self.refreshTableView setTableHeaderView:headView];
}

#pragma mark- override
//下拉刷新
- (void)refreshData
{
    [super refreshData];
    
    //下拉刷新 不使用关键字刷新
//    self.keyWords = @"";
    self.searchBar.text = @"";
//    self.isKeyWord = NO;
    [self getSchoolListWithAdcode:self.mapReGeocodeSearchResponse.regeocode.addressComponent.adcode andName:self.searchBar.text];
}

//加载更多
- (void)loadingData
{
    [super loadingData];
    //关键字
//    if (self.isKeyWord) {
    [self getSchoolListWithAdcode:self.mapReGeocodeSearchResponse.regeocode.addressComponent.adcode andName:self.searchBar.text];
//    }else{
//        //区域
//        [self getSchoolListWithAdcode:self.mapReGeocodeSearchResponse.regeocode.addressComponent.adcode andName:@""];
//    }
}

#pragma mark - AMapSearchDelegate
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    
    if(updatingLocation)
    {
        //取出当前位置的坐标
        debugLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        self.currentLocation = userLocation;
        self.mapView.showsUserLocation = NO;
//        [self searchPoiByCenterCoordinate];
        
        [self searchReGeocodeWithCoordinate:self.currentLocation.location.coordinate];
    }
}
//失败
- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    //失败也获取列表
    [self getSchoolListWithAdcode:self.mapReGeocodeSearchResponse.regeocode.addressComponent.adcode andName:self.searchBar.text];
}

#pragma mark - AMapSearchDelegate
- (void)searchRequest:(id)request didFailWithError:(NSError *)error
{
    [self getSchoolListWithAdcode:self.mapReGeocodeSearchResponse.regeocode.addressComponent.adcode andName:self.searchBar.text];
//    debugLog(@"%s: searchRequest = %@, errInfo= %@", __func__, [request class], error);
    [self refreshFinish];
}
///* POI 搜索回调. */
//- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)respons
//{
//    for (AMapPOI *p in respons.pois) {
//        debugLog(@"%@ %@ %@", p.name, p.type, p.uid);
//    }
//    
//    //如果刚刷新结束 删除所有内容
//    if (self.isReloading) {
//        [self.dataArr removeAllObjects];
//    }
//    
//    //如果是第一页搜索的话 重置数据源
//    if (self.isKeyWord && self.currentPage == 1) {
//        [self.dataArr removeAllObjects];
//        [super refreshData];
//    }
//    
//    [self.dataArr addObjectsFromArray:respons.pois];
//
//    
//    NSMutableArray * removeArr = [[NSMutableArray alloc] init];
//    for (AMapPOI * poi in self.dataArr) {
//        //去除不携带关键字的对象
//        if ([poi.name rangeOfString:@"学校"].location != NSNotFound) {
//            continue;
//        }else if ([poi.name rangeOfString:@"中学"].location != NSNotFound) {
//            continue;
//        }else if ([poi.name rangeOfString:@"初中"].location != NSNotFound) {
//            continue;
//        }else if ([poi.name rangeOfString:@"职"].location != NSNotFound) {
//            continue;
//        }else{
//            [removeArr addObject:poi];
//        }
//    }
//    [self.dataArr removeObjectsInArray:removeArr];
//    
//    //小于30最后一页
//    if (respons.pois.count < 30)
//    {
//        self.isLastPage = YES;
//    }
//    //统一刷新
//    [self reloadTable];
//}

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    
    if (response.regeocode != nil)
    {
//        debugLog(@"%@ %@ %@", response.regeocode.addressComponent.adcode, response.regeocode.addressComponent.city, response.regeocode.addressComponent.province);
        self.mapReGeocodeSearchResponse = response;
        //请求数据
        [self getSchoolListWithAdcode:response.regeocode.addressComponent.adcode andName:self.searchBar.text];
    }
}

#pragma mark- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SchoolModel * schoolModel = self.dataArr[indexPath.row];
    
    //school school_num
    NSDictionary * params = @{@"uid":[NSString stringWithFormat:@"%ld", [UserService sharedService].user.uid],
                              @"school":schoolModel.schoolName,
                              @"school_code":schoolModel.schoolCode};
    
    debugLog(@"%@ %@", kChangeSchoolPath, params);
    [self showLoading:nil];
    //选择学校
    [HttpService postWithUrlString:kChangeSchoolPath params:params andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        
        int status = [responseData[@"status"] intValue];
        if (status == HttpStatusCodeSuccess) {
            
            [UserService sharedService].user.school      = schoolModel.schoolName;
            [UserService sharedService].user.school_code = schoolModel.schoolCode;
            //数据本地缓存
            [[UserService sharedService] saveAndUpdate];
            [self hideLoading];
            
            //非注册的时候
            if (self.notRegister) {
                if (_choiceSchoolBlock) {
                    _choiceSchoolBlock(schoolModel.schoolName);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                //注册的时候
                //填写基本信息
                RegisterInformationViewController * rivc    = [[RegisterInformationViewController alloc] init];
                [self pushVC:rivc];
                
//                //省处理
//                NSString * province = self.mapReGeocodeSearchResponse.regeocode.addressComponent.province;
//                if ([province hasSuffix:@"省"]) {
//                    province = [province substringToIndex:province.length-1];
//                }
//                //城市处理
//                NSString * city = self.mapReGeocodeSearchResponse.regeocode.addressComponent.city;
//                if ([city hasSuffix:@"市"]) {
//                    city = [city substringToIndex:city.length-1];
//                }
//                
//                if (province.length < 1 && city.length < 1) {
//                    city = @"";
//                }else{
//                    city = [NSString stringWithFormat:@"%@,%@", province, city];
//                }
//                
//                NSDictionary * params = @{@"uid":[NSString stringWithFormat:@"%ld", [UserService sharedService].user.uid],
//                                          @"field":@"city",
//                                          @"value":city};
//
//                debugLog(@"%@ %@", kChangePersonalInformationPath, params);
//                [HttpService postWithUrlString:kChangePersonalInformationPath params:params andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
//                    debugLog(@"%@", responseData);
//                    int status = [responseData[HttpStatus] intValue];
//                    if (status == HttpStatusCodeSuccess) {
//                        [UserService sharedService].user.city = city;
//                        //数据缓存
//                        [[UserService sharedService] saveAndUpdate];
//                    }
//                    
//                } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
//                    
//                }];
            }
            
        }else{
            
            [self showWarn:responseData[@"msg"]];
        }
        debugLog(@"%@", responseData);
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        debugLog(@"%@", error.domain);
        [self showWarn:StringCommonNetException];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
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

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //数据初始化
//    self.isKeyWord   = YES;
    self.currentPage = 1;
    [self getSchoolListWithAdcode:self.mapReGeocodeSearchResponse.regeocode.addressComponent.adcode andName:self.searchBar.text];

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar; {

//    //数据初始化
//    self.isKeyWord   = YES;
//    self.currentPage = 1;
//    [self getSchoolListWithAdcode:@"" andName:self.searchBar.text];
//    self.keyWords    = self.searchBar.text;
    [searchBar resignFirstResponder];
}


#pragma mark- override
/*! 重写该方法定制Cell*/
- (void)handleTableViewContentWith:(UITableViewCell *)cell andIndexPath:(NSIndexPath *)indexPath
{
    
    SchoolModel * schoolModel     = self.dataArr[indexPath.row];
    //名字
    CustomLabel * schoolNameLabel = [[CustomLabel alloc] initWithFontSize:12];
    schoolNameLabel.textColor     = [UIColor colorWithHexString:ColorDeepBlack];
    schoolNameLabel.frame         = CGRectMake(10, 5, 300, 20);
    schoolNameLabel.text          = schoolModel.schoolName;
    [cell.contentView addSubview:schoolNameLabel];
    //描述
    CustomLabel * descripLabel    = [[CustomLabel alloc] initWithFontSize:10];
    descripLabel.textColor        = [UIColor colorWithHexString:ColorDeepGary];
    descripLabel.frame            = CGRectMake(10, schoolNameLabel.bottom, 300, 20);
    NSString * schoolLevel        = schoolModel.level == 1 ? @"初中":@"高中";
    NSString * descrip            = [NSString stringWithFormat:@"%@%@◆%@", schoolModel.cityName, schoolModel.districtName,schoolLevel];
    descripLabel.text             = descrip;
    [cell.contentView addSubview:descripLabel];

    UIView * lineView             = [[UIView alloc] initWithFrame:CGRectMake(0, 49, self.viewWidth, 1)];
    lineView.backgroundColor      = [UIColor colorWithHexString:ColorLightGary];
    [cell.contentView addSubview:lineView];
    
}

#pragma makr- private method

- (void)initMap
{
    self.mapView                   = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate          = self;
    self.mapView.showsUserLocation = YES;
    self.search                    = [[AMapSearchAPI alloc] initWithSearchKey:[MAMapServices sharedServices].apiKey Delegate:self];
    
}

///* 根据中心点坐标来搜周边的POI. */
//- (void)searchPoiByCenterCoordinate
//{
//    AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
//
//    request.searchType              = AMapSearchType_PlaceAround;
//    CLLocationCoordinate2D cc       = self.currentLocation.location.coordinate;
//    request.location                = [AMapGeoPoint locationWithLatitude:cc.latitude longitude:cc.longitude];
//    request.radius                  = 5000;
//    request.keywords                = @"中学";
//    request.offset                  = 30;
//    request.page                    = self.currentPage;
//    /* 按照距离排序. */
//    request.sortrule                = 1;
//    request.requireExtension        = YES;
//    
//    [self.search AMapPlaceSearch:request];
//}

//- (void)searchPoiByKeyWord
//{
//    //构造AMapPlaceSearchRequest对象，配置关键字搜索参数
//    AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
//    poiRequest.searchType              = AMapSearchType_PlaceKeyword;
//    poiRequest.keywords                = self.searchBar.text;
//    poiRequest.requireExtension        = YES;
//    poiRequest.offset = 30;
//    poiRequest.page = self.currentPage;
//    //发起POI搜索
//    [_search AMapPlaceSearch: poiRequest];
//}

#pragma mark- private method
- (void)setChoickBlock:(ChoiceSchoolBlock)block
{
    _choiceSchoolBlock = [block copy];
}
//逆地理编码
- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension = YES;
    [self.search AMapReGoecodeSearch:regeo];
}

//获取学校列表
- (void)getSchoolListWithAdcode:(NSString *)code andName:(NSString *)name
{
    //默认北京
    if (code.length < 1 && name.length < 1) {
        code = @"110101";
    }
    
    NSString * url = [NSString stringWithFormat:@"%@?page=%d&district_code=%@&school_name=%@", kGetSchoolListPath, self.currentPage, code, [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    debugLog(@"%@", url);
    
    [HttpService getWithUrlString:url andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        int status = [responseData[HttpStatus] intValue];
        [self hideLoading];
        if (status == HttpStatusCodeSuccess) {
            
            //下拉刷新清空数组
            if (self.isReloading) {
                [self.dataArr removeAllObjects];
            }
            //如果是关键字搜索
            if (self.currentPage == 1) {
                [self.dataArr removeAllObjects];
                [super refreshData];
            }
            
            self.isLastPage = [responseData[HttpResult][@"is_last"] boolValue];
            NSArray * list = responseData[HttpResult][HttpList];
            //数据处理
            for (NSDictionary * schoolDic in list) {
                SchoolModel * schoolModel = [[SchoolModel alloc] init];
                schoolModel.schoolCode   = schoolDic[@"code"];
                schoolModel.schoolName   = schoolDic[@"name"];
                schoolModel.districtName = schoolDic[@"district_name"];
                schoolModel.cityName     = schoolDic[@"city_name"];
                schoolModel.level        = [schoolDic[@"level"] integerValue];
                [self.dataArr addObject:schoolModel];
            }
            [self reloadTable];
        }else{
            self.isReloading = NO;
            [self.refreshTableView refreshFinish];
        }
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideLoading];        
        self.isReloading = NO;
        [self.refreshTableView refreshFinish];
    }];
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
