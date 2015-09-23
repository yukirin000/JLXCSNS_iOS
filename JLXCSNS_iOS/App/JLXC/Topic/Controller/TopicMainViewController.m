//
//  TopicMainViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/9/23.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "TopicMainViewController.h"
#import "CreateTopicViewController.h"
#import "TopicMainCell.h"
@interface TopicMainViewController ()

//弹出视图背景
@property (nonatomic, strong) UIView * popBackView;
//屏幕遮罩
@property (nonatomic, strong) UIView * screenCoverView;

//循环滚动集合
@property (nonatomic, strong) UICollectionView * collectionView;
//数据源
@property (nonatomic, strong) NSMutableArray * dataSource;

//当前的类别ID 0为全部
@property (nonatomic, assign) NSInteger categoryID;

@end

@implementation TopicMainViewController

#pragma mark- lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWidget];
    [self configUI];
    //初始化集合
    [self initColloction];
    //获取数据
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark- layout
- (void)initWidget
{
    self.dataSource      = [[NSMutableArray alloc] init];
    self.screenCoverView = [[UIView alloc] init];
    self.popBackView     = [[UIView alloc] init];

    [self.view addSubview:self.screenCoverView];
    [self.view addSubview:self.popBackView];

    __weak typeof(self) sself = self;
    [self.navBar setRightBtnWithContent:@"" andBlock:^{
        [sself showRightPopView];
    }];

    UITapGestureRecognizer * dissmissTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissCover:)];
    [self.screenCoverView addGestureRecognizer:dissmissTap];
}

- (void)configUI
{
    [self setNavBarTitle:@"话题频道"];
    [self.navBar.rightBtn setImage:[UIImage imageNamed:@"group_more_operate"] forState:UIControlStateNormal];
    //右上角PopView
    self.popBackView.backgroundColor     = [UIColor colorWithHexString:ColorWhite];
    self.popBackView.layer.masksToBounds = YES;
    self.screenCoverView.frame           = self.view.bounds;
    self.screenCoverView.hidden          = YES;
    
    //频道列表
    CustomButton * moreTopicBtn  = [[CustomButton alloc] initWithFrame:CGRectMake(0, 0, 80, 45)];
    moreTopicBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [moreTopicBtn setTitle:@" 频道列表" forState:UIControlStateNormal];
    [moreTopicBtn setTitleColor:[UIColor colorWithHexString:ColorBrown] forState:UIControlStateNormal];
    [moreTopicBtn setImage:[UIImage imageNamed:@"group_more"] forState:UIControlStateNormal];
    //创建频道
    CustomButton * createTopicBtn  = [[CustomButton alloc] initWithFrame:CGRectMake(0, 45, 80, 45)];
    createTopicBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [createTopicBtn setTitle:@" 创建频道" forState:UIControlStateNormal];
    [createTopicBtn setTitleColor:[UIColor colorWithHexString:ColorBrown] forState:UIControlStateNormal];
    [createTopicBtn setImage:[UIImage imageNamed:@"group_create"] forState:UIControlStateNormal];
    [createTopicBtn addTarget:self action:@selector(createTopicClick:) forControlEvents:UIControlEventTouchUpInside];

    [self.popBackView addSubview:createTopicBtn];
    [self.popBackView addSubview:moreTopicBtn];
    
}
#define CollectID @"collectID"
//初始化集合
- (void)initColloction
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection              = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize                     = CGSizeMake(self.viewWidth, self.viewHeight-kNavBarAndStatusHeight-kTabBarHeight);
    layout.minimumInteritemSpacing      = 0;
    layout.minimumLineSpacing           = 0;

    //集合
    self.collectionView                                = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusHeight, self.viewWidth, self.viewHeight-kNavBarAndStatusHeight-kTabBarHeight) collectionViewLayout:layout];
    self.collectionView.bounces                        = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor                = [UIColor colorWithHexString:ColorWhite];
    self.collectionView.pagingEnabled                  = YES;
    self.collectionView.delegate                       = self;
    self.collectionView.dataSource                     = self;
    self.collectionView.backgroundView                 = [[CustomImageView alloc] initWithImage:[UIImage imageNamed:@"topic_background"]];
    [self.collectionView registerClass:[TopicMainCell class] forCellWithReuseIdentifier:CollectID];
    
    [self.view addSubview:self.collectionView];
}

#pragma mark- UICollectionViewDataSource, UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TopicMainCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectID forIndexPath:indexPath];
    [cell setContentWith:self.dataSource[indexPath.row]];
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger position = scrollView.contentOffset.x/self.viewWidth;
    if (position == 0) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count-2 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    if (position == self.dataSource.count-1) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

#pragma mark- method response
- (void)createTopicClick:(id)sender
{
    CreateTopicViewController * ctvc = [[CreateTopicViewController alloc] init];
    [self pushVC:ctvc];
}

- (void)dismissCover:(UITapGestureRecognizer *)ges
{
    self.screenCoverView.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.popBackView.frame         = CGRectMake(self.viewWidth-35, 55, 0, 0);
        self.navBar.rightBtn.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark- private method
- (void)showRightPopView
{
    self.screenCoverView.hidden = NO;
    self.popBackView.frame      = CGRectMake(self.viewWidth-35, 55, 0, 0);
    [UIView animateWithDuration:0.2 animations:^{
        self.popBackView.frame         = CGRectMake(self.viewWidth-90, 55, 80, 90);
        self.navBar.rightBtn.transform = CGAffineTransformMakeRotation(M_PI_4);
    }];
    
}

- (void)getData
{
    NSString * path = [kGetTopicHomeListPath stringByAppendingFormat:@"?user_id=%ld&category_id=%ld", [UserService sharedService].user.uid, self.categoryID];
    debugLog(@"%@", path);
    [HttpService getWithUrlString:path andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        NSInteger state = [responseData[HttpStatus] integerValue];
        if (state == HttpStatusCodeSuccess) {
            NSArray * topics = responseData[HttpResult][HttpList];
            //没内容
            if (topics.count < 1) {
                return ;
            }
            [self.dataSource removeAllObjects];
            for (NSDictionary * dic in topics) {
                TopicModel * topic      = [[TopicModel alloc] init];
                topic.topic_id          = [dic[@"topic_id"] integerValue];
                topic.topic_cover_image = dic[@"topic_cover_image"];
                topic.topic_name        = dic[@"topic_name"];
                topic.topic_detail      = dic[@"topic_detail"];
                topic.news_count        = [dic[@"news_count"] integerValue];
                topic.member_count      = [dic[@"member_count"] integerValue];
                [self.dataSource addObject:topic];
            }
            //在第一个和最后一个插入 最后一个和第一个 形成一个循环效果
            [self.dataSource insertObject:[self.dataSource[self.dataSource.count-1] copy] atIndex:0];
            [self.dataSource insertObject:[self.dataSource[1] copy] atIndex:self.dataSource.count];
            
            //刷新
            [self.collectionView reloadData];
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];            
            
        }else{
            [self showWarn:responseData[HttpMessage]];
        }
        
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
