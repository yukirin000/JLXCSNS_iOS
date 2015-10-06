//
//  TopicMemberViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/9/25.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "TopicMemberViewController.h"
#import "OtherPersonalViewController.h"
#import "UIImageView+WebCache.h"

@interface TopicMemberViewController ()

//集合视图
@property (nonatomic, strong) UICollectionView * collectionView;

//数据源
@property (nonatomic, strong) NSMutableArray * dataSource;

//全部数据
@property (nonatomic, strong) NSMutableArray * allData;

@end

@implementation TopicMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [[NSMutableArray alloc] init];
    self.allData    = [[NSMutableArray alloc] init];
    
    [self configUI];
    
    //初始化 集合视图
    [self loadAndhandleData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- layout
- (void)configUI
{
    __weak typeof(self) sself = self;
    [self.navBar setRightBtnWithContent:@"筛选" andBlock:^{
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"筛选" message:nil delegate:sself cancelButtonTitle:StringCommonCancel otherButtonTitles:@"我只看男的",@"我只看女的",@"全都看", nil];
        [alert show];
    }];
    
    [self setNavBarTitle:@"所有成员"];
}
#define CellIdetifier @"collectCell"
//初始化 集合视图
- (void)initCollection
{
    UICollectionViewFlowLayout * collectLayout = [[UICollectionViewFlowLayout alloc] init];
    collectLayout.itemSize                     = CGSizeMake(60, 80);
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
    
    UserModel * model             = self.dataSource[indexPath.row];
    //头像
    CustomImageView * imageView   = [[CustomImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    imageView.layer.cornerRadius  = 2;
    imageView.layer.masksToBounds = YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:[ToolsManager completeUrlStr:model.head_sub_image]] placeholderImage:[UIImage imageNamed:DEFAULT_AVATAR]];
    [cell.contentView addSubview:imageView];
    //姓名
    CustomLabel * nameLabel = [[CustomLabel alloc] initWithFontSize:13];
    nameLabel.textColor     = [UIColor colorWithHexString:ColorDeepBlack];
    nameLabel.frame         = CGRectMake(0, imageView.bottom, 60, 20);
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text          = model.name;
    [cell.contentView addSubview:nameLabel];
    
    return cell;
}
#pragma mark- UICollectionViewDataSource
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UserModel * model          = self.dataSource[indexPath.row];
    OtherPersonalViewController * opvc = [[OtherPersonalViewController alloc] init];
    opvc.uid                           = model.uid;
    [self pushVC:opvc];
    
}

#pragma mark- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex != 0) {
        [self siftStudentWith:buttonIndex];
    }
}

#pragma mark- private method
//筛选学生
- (void)siftStudentWith:(NSInteger)type
{
    
    NSArray * arr = [self.allData copy];
    
    NSPredicate * predicate;
    switch (type) {
        case 1:
            predicate = [NSPredicate predicateWithFormat:@"sex == 0"];
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:[arr filteredArrayUsingPredicate:predicate]];
            break;
        case 2:
            predicate = [NSPredicate predicateWithFormat:@"sex == 1"];
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:[arr filteredArrayUsingPredicate:predicate]];
            break;
        case 3:
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:arr];
            break;
        default:
            break;
    }
    
    [self.collectionView reloadData];
    
}

- (void)loadAndhandleData
{
    
    NSString * url = [NSString stringWithFormat:@"%@?topic_id=%ld", kGetTopicMemberListPath, self.topicID];
    debugLog(@"%@", url);
    [HttpService getWithUrlString:url andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        debugLog(@"%@", responseData);
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            
            //下拉刷新清空数组
            NSArray * list = responseData[HttpResult][HttpList];
            //数据处理
            for (NSDictionary * userDic in list) {
                UserModel * model    = [[UserModel alloc] init];
                model.uid            = [userDic[@"user_id"] integerValue];
                model.name           = userDic[@"name"];
                model.sex            = [userDic[@"sex"] integerValue];
                model.head_sub_image = userDic[@"head_sub_image"];
                [self.dataSource addObject:model];
            }
            self.allData = [self.dataSource copy];
            
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
