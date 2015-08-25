//
//  BrowseImageListViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/4.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "BrowseImageListViewController.h"
#import "BrowseImageView.h"
#import "ImageModel.h"

@interface BrowseImageListViewController ()

//底部collection
@property (nonatomic, strong) UICollectionView * collectionView;

//pageContol
@property (nonatomic, strong) UIPageControl * pageControl;

@end

@implementation BrowseImageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.backgroundColor = [UIColor clearColor];

    [self configUI];
    
    [self initCollection];
    
    [self initPageControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- layout
- (void)configUI
{
    __weak typeof(self) sself = self;
    [self.navBar setLeftBtnWithContent:nil andBlock:^{
        [sself dismissViewControllerAnimated:YES completion:nil];
    }];
}

#define CellIdetifier @"browseCell"
//初始化 集合视图
- (void)initCollection
{
    UICollectionViewFlowLayout * collectLayout = [[UICollectionViewFlowLayout alloc] init];
    collectLayout.itemSize                     = CGSizeMake(self.viewWidth, self.viewHeight);
    collectLayout.scrollDirection              = UICollectionViewScrollDirectionHorizontal;
    collectLayout.minimumInteritemSpacing      = 0;
    collectLayout.minimumLineSpacing           = 0;
    collectLayout.sectionInset                 = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.collectionView                 = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight) collectionViewLayout:collectLayout];
    self.collectionView.pagingEnabled   = YES;
    self.collectionView.backgroundColor = [UIColor blackColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellIdetifier];
    self.collectionView.delegate        = self;
    self.collectionView.dataSource      = self;
    [self.view addSubview:self.collectionView];
    
    [self.view sendSubviewToBack:self.collectionView];
    
    NSIndexPath * path = [NSIndexPath indexPathForRow:self.num inSection:0];
    //滚动到 相应的位置
    [self.collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
}

- (void)initPageControl
{
    
    self.pageControl                               = [[UIPageControl alloc] initWithFrame:CGRectMake(kCenterOriginX(300), self.viewHeight-50, 300, 30)];
    //有几页
    self.pageControl.numberOfPages                 = self.dataSource.count;
    //当前页
    self.pageControl.currentPage                   = self.num;
    self.pageControl.enabled                       = NO;
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.pageIndicatorTintColor        = [UIColor grayColor];
//    [self.pageControl addTarget:self action:@selector(pageChange:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.pageControl];
    
}

#pragma mark- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdetifier forIndexPath:indexPath];
    if (cell) {

        ImageModel * image                = self.dataSource[indexPath.row];
        BrowseImageView * browseImageView = [[BrowseImageView alloc] initWithFrame:self.view.bounds];
        browseImageView.urlStr            = [ToolsManager completeUrlStr:image.url];
        [cell.contentView addSubview:browseImageView];
    }
    
    return cell;
}

#pragma mark- UIScorllViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger pageNum = scrollView.contentOffset.x/scrollView.width;
    _pageControl.currentPage = pageNum;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSInteger pageNum = scrollView.contentOffset.x/scrollView.width;
    _pageControl.currentPage = pageNum;
}

#pragma mark- method reponse



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
