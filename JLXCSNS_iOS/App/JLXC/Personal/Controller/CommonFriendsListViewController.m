//
//  CommonFriendsListViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/2.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "CommonFriendsListViewController.h"
#import "CommonFriendModel.h"
#import "OtherPersonalViewController.h"
#import "UIImageView+WebCache.h"

@interface CommonFriendsListViewController ()

//集合视图
@property (nonatomic, strong) UICollectionView * collectionView;

//数据源
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation CommonFriendsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [[NSMutableArray alloc] init];
    
    //初始化 集合视图
    [self loadAndhandleData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- layout
#define CellIdetifier @"collectCell"
//初始化 集合视图
- (void)initCollection
{
    UICollectionViewFlowLayout * collectLayout = [[UICollectionViewFlowLayout alloc] init];
    collectLayout.itemSize                     = CGSizeMake(60, 60);
    collectLayout.minimumInteritemSpacing      = 15;
    collectLayout.minimumLineSpacing           = 20;
    collectLayout.sectionInset                 = UIEdgeInsetsMake(15, 16, 5, 16);
    
    self.collectionView                 = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusHeight, self.viewWidth, self.viewHeight-kNavBarAndStatusHeight) collectionViewLayout:collectLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellIdetifier];
    self.collectionView.delegate        = self;
    self.collectionView.dataSource      = self;
    [self.view addSubview:self.collectionView];
    
}

#pragma mark- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdetifier forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    CommonFriendModel * model   = self.dataSource[indexPath.row];
    CustomImageView * imageView = [[CustomImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[ToolsManager completeUrlStr:model.head_sub_image]] placeholderImage:[UIImage imageNamed:@"testimage"]];
    [cell.contentView addSubview:imageView];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CommonFriendModel * model          = self.dataSource[indexPath.row];
    OtherPersonalViewController * opvc = [[OtherPersonalViewController alloc] init];
    opvc.uid                           = model.uid;
    [self pushVC:opvc];
    
}

#pragma mark- private method
- (void)loadAndhandleData
{
    
    NSString * url = [NSString stringWithFormat:@"%@?uid=%ld&current_id=%ld", kGetCommonFriendsListPath, self.uid, [UserService sharedService].user.uid];
    debugLog(@"%@", url);
    [HttpService getWithUrlString:url andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        debugLog(@"%@", responseData);
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            
            //下拉刷新清空数组
            NSArray * list = responseData[HttpResult][HttpList];
            //数据处理
            for (NSDictionary * commonDic in list) {
                CommonFriendModel * model = [[CommonFriendModel alloc] init];
                model.uid                 = [commonDic[@"friend_id"] integerValue];
                model.head_sub_image      = commonDic[@"head_sub_image"];
                [self.dataSource addObject:model];
            }
            
        }else{
            [self showWarn:responseData[HttpMessage]];
        }
        
        [self initCollection];
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showWarn:StringCommonNetException];
    }];
    
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
