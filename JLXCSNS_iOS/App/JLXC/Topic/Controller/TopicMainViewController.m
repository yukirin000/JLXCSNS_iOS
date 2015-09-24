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
#import "TopicCategoryView.h"
#import "TopicCategoryModel.h"
#import "MoreTopicViewController.h"
#import "TopicNewsViewController.h"

@interface TopicMainViewController ()<TopicCategoryDelegate>

//弹出视图背景
@property (nonatomic, strong) UIView * popBackView;
//屏幕遮罩
@property (nonatomic, strong) UIView * screenCoverView;
//顶部类别图片
@property (nonatomic, strong) CustomImageView * categoryImageView;
//循环滚动集合
@property (nonatomic, strong) UICollectionView * collectionView;
//数据源
@property (nonatomic, strong) NSMutableArray * dataSource;
//当前的类别模型 ID0为全部
@property (nonatomic, strong) TopicCategoryModel * categoryModel;
//类别view
@property (nonatomic, strong) TopicCategoryView * categoryView;
//类别数组
@property (nonatomic, strong) NSMutableArray * categoryList;
//当前的类别
@property (nonatomic, strong) TopicCategoryModel * currentCategoryModel;

@end

@implementation TopicMainViewController

#pragma mark- lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化集合
    [self initColloction];
    
    [self initWidget];
    [self configUI];
    [self registerNotify];
    //获取数据
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark- layout
- (void)initWidget
{
    self.categoryView          = [[TopicCategoryView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight-kNavBarAndStatusHeight)];
    self.categoryView.delegete = self;
    
    self.dataSource        = [[NSMutableArray alloc] init];
    self.screenCoverView   = [[UIView alloc] init];
    self.popBackView       = [[UIView alloc] init];
    self.categoryImageView = [[CustomImageView alloc] init];
    
    [self.navBar addSubview:self.categoryImageView];
    [self.view addSubview:self.screenCoverView];
    [self.view addSubview:self.popBackView];
    [[[UIApplication sharedApplication].delegate window] addSubview:self.categoryView];

    __weak typeof(self) sself = self;
    [self.navBar setRightBtnWithContent:@"" andBlock:^{
        [sself showRightPopView];
    }];
    //遮罩点击消失
    UITapGestureRecognizer * dissmissTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissCover:)];
    [self.screenCoverView addGestureRecognizer:dissmissTap];
    //类别点击
    UITapGestureRecognizer * categoryTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(categoryTap:)];
    [self.navBar addGestureRecognizer:categoryTap];

}

- (void)configUI
{
    [self setNavBarTitle:@"话题频道"];
    [self.navBar.rightBtn setImage:[UIImage imageNamed:@"group_more_operate"] forState:UIControlStateNormal];
    
    self.categoryView.hidden              = YES;
    self.categoryView.layer.masksToBounds = YES;
    
    self.categoryImageView.image                  = [UIImage imageNamed:@"arrow_down"];
    self.categoryImageView.frame                  = CGRectMake(self.viewWidth/2+35, self.navBar.titleLabel.y+13, 18, 18);
    
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
    [moreTopicBtn addTarget:self action:@selector(moreTopicClick:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TopicModel * topic             = self.dataSource[indexPath.row];
    TopicNewsViewController * tnVC = [[TopicNewsViewController alloc] init];
    tnVC.topicID                   = topic.topic_id;
    tnVC.topicName                 = topic.topic_name;
    [self pushVC:tnVC];
}

//循环滚动
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

#pragma mark- TopicCategoryDelegate
- (void)colorChange:(NSString *)colorStr
{
    [UIView animateWithDuration:0.2 animations:^{
        self.navBar.backgroundColor = [UIColor colorWithHexString:colorStr];
    }];
}
//选择类别
- (void)categorySelect:(TopicCategoryModel *)topic
{
    self.navBar.rightBtn.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.categoryView.frame          = CGRectMake(0, kNavBarAndStatusHeight, self.viewWidth, 0);
        self.categoryImageView.transform = CGAffineTransformIdentity;
        self.navBar.backgroundColor      = [UIColor colorWithHexString:ColorYellow];
    } completion:^(BOOL finished) {
        self.categoryView.hidden = YES;
    }];
    
    [self setNavBarTitle:topic.category_name];
    //数据更新
    self.categoryModel = topic;
    [self getData];
}

#pragma mark- method response
- (void)createTopicClick:(id)sender
{
    //创建圈子
    CreateTopicViewController * ctvc = [[CreateTopicViewController alloc] init];
    [self pushVC:ctvc];
}
- (void)moreTopicClick:(id)sender
{
    MoreTopicViewController * mtvc = [[MoreTopicViewController alloc] init];
    mtvc.categoryId                = self.categoryModel.category_id;
    mtvc.categoryName              = self.categoryModel.category_name;
    [self pushVC:mtvc];
}

//遮罩点击消失
- (void)dismissCover:(UITapGestureRecognizer *)ges
{
    self.screenCoverView.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.popBackView.frame         = CGRectMake(self.viewWidth-35, 55, 0, 0);
        self.navBar.rightBtn.transform = CGAffineTransformIdentity;
    }];
}
//类别点击
- (void)categoryTap:(UITapGestureRecognizer *)ges
{
    //存在显示 不存在请求
    if (self.categoryList.count > 0) {
        [self showCategoryList];
    }else{
        if (self.categoryList == nil) {
            self.categoryList = [[NSMutableArray alloc] init];
        }
        [self showLoading:@""];
        [HttpService getWithUrlString:kGetTopicCategoryPath andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
            [self hideLoading];
            NSInteger state = [responseData[HttpStatus] integerValue];
            if (state == HttpStatusCodeSuccess) {
                NSArray * categorys = responseData[HttpResult][HttpList];
                //清空所有
                [self.categoryList removeAllObjects];
                //全部频道
                TopicCategoryModel * topic = [[TopicCategoryModel alloc] init];
                topic.category_id          = 0;
                topic.category_name        = @"话题频道";
                topic.category_desc        = @"全宇宙的事情都在这里讨论";
                topic.category_cover       = @"";
                [self.categoryList addObject:topic];
                //循环添加其他频道
                for (NSDictionary * dic in categorys) {
                    TopicCategoryModel * topic = [[TopicCategoryModel alloc] init];
                    topic.category_id          = [dic[@"category_id"] integerValue];
                    topic.category_name        = dic[@"category_name"];
                    topic.category_desc        = dic[@"category_desc"];
                    topic.category_cover       = dic[@"category_cover"];
                    [self.categoryList addObject:topic];
                }
                
                
                [self showCategoryList];
            }else{
                [self showWarn:responseData[HttpMessage]];
            }
            
        } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self showWarn:StringCommonNetException];
        }];
    }
}

#pragma mark- private method
- (void)registerNotify
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newTopicCreate:) name:NOTIFY_CREATE_TOPIC object:nil];
}

//新圈子创建
- (void)newTopicCreate:(NSNotification *)notify
{
    TopicModel * topic = notify.object;
    //删除第一个和最后一个重置位置
    [self.dataSource removeLastObject];
    [self.dataSource removeObjectAtIndex:0];
    //插入新圈子
    [self.dataSource insertObject:topic atIndex:0];
    //更新
    [self.dataSource insertObject:[self.dataSource[self.dataSource.count-1] copy] atIndex:0];
    [self.dataSource insertObject:[self.dataSource[1] copy] atIndex:self.dataSource.count];
    [self.collectionView reloadData];
}

//显示选择类别视图
- (void)showCategoryList
{
    [self.categoryView setCategoryList:self.categoryList];
    //显示
    if (self.categoryView.hidden == YES) {
        self.navBar.rightBtn.hidden = YES;
        self.categoryView.frame  = CGRectMake(0, kNavBarAndStatusHeight, self.viewWidth, 0);
        self.categoryView.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.categoryImageView.transform = CGAffineTransformMakeRotation(M_PI);
            self.categoryView.frame          = CGRectMake(0, kNavBarAndStatusHeight, self.viewWidth, self.viewHeight-kNavBarAndStatusHeight);
        }];
    }else{
        //隐藏
        self.navBar.rightBtn.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.categoryView.frame          = CGRectMake(0, kNavBarAndStatusHeight, self.viewWidth, 0);
            self.categoryImageView.transform = CGAffineTransformIdentity;
            self.navBar.backgroundColor      = [UIColor colorWithHexString:ColorYellow];
        } completion:^(BOOL finished) {
            self.categoryView.hidden = YES;
        }];
    }
}
//显示右边弹窗
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
    NSString * path = [kGetTopicHomeListPath stringByAppendingFormat:@"?user_id=%ld&category_id=%ld", [UserService sharedService].user.uid, self.categoryModel.category_id];
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
