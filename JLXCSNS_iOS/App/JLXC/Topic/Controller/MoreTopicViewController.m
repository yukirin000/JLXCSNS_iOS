//
//  MoreTopicViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/9/24.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "MoreTopicViewController.h"
#import "TopicNewsViewController.h"
#import "TopicCategoryModel.h"
#import "MoreTopicCell.h"
#import "TopicCategoryModel.h"
#import "UIImageView+WebCache.h"

@interface MoreTopicViewController ()

//话题圈子模型
@property (nonatomic, strong) TopicCategoryModel * categoryModel;

//头部背景View
@property (nonatomic, strong) UIView * headBackView;
//背景图片
@property (nonatomic, strong) CustomImageView * backImageView;
//名字
@property (nonatomic, strong) CustomLabel * categoryNameLabel;
//描述
@property (nonatomic, strong) CustomLabel * categoryDescLabel;

@end

@implementation MoreTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWidget];
    [self configUI];
    
    self.refreshTableView.frame = CGRectMake(0, kNavBarAndStatusHeight, self.viewWidth, self.viewHeight-kNavBarAndStatusHeight);
    //加载数据
    [self loadAndhandleData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- layout
- (void)initWidget
{
    self.categoryModel     = [[TopicCategoryModel alloc] init];
    //顶部背景
    self.headBackView      = [[UIView alloc] init];
    self.backImageView     = [[CustomImageView alloc] init];
    self.categoryNameLabel = [[CustomLabel alloc] init];
    self.categoryDescLabel = [[CustomLabel alloc] init];
    
    [self.headBackView addSubview:self.backImageView];
    [self.headBackView addSubview:self.categoryNameLabel];
    [self.headBackView addSubview:self.categoryDescLabel];
    
}

- (void)configUI
{
    if (self.categoryName == nil) {
        self.categoryName = @"话题频道";
    }
    [self setNavBarTitle:self.categoryName];
    
    self.headBackView.frame                = CGRectMake(0, 0, self.viewWidth, 145);
    self.backImageView.frame               = self.headBackView.bounds;
    self.backImageView.contentMode         = UIViewContentModeScaleAspectFill;
    self.backImageView.layer.masksToBounds = YES;

    self.categoryNameLabel.frame           = CGRectMake(13, 90, self.viewWidth, 30);
    [self.categoryNameLabel setFontBold];
    self.categoryNameLabel.font            = [UIFont systemFontOfSize:17];
    self.categoryNameLabel.textColor       = [UIColor colorWithHexString:ColorWhite];

    self.categoryDescLabel.frame           = CGRectMake(13, 120, self.viewWidth, 20);
    self.categoryDescLabel.font            = [UIFont systemFontOfSize:13];
    self.categoryDescLabel.textColor       = [UIColor colorWithHexString:ColorWhite];

    UIView * nameBackView                  = [[UIView alloc] initWithFrame:CGRectMake(0, 85, self.viewWidth, 60)];
    nameBackView.backgroundColor           = [UIColor blackColor];
    nameBackView.alpha                     = 0.5;
    [self.headBackView addSubview:nameBackView];
    [self.headBackView insertSubview:nameBackView aboveSubview:self.backImageView];
    self.refreshTableView.tableHeaderView = self.headBackView;
}

#pragma override
//下拉刷新
- (void)refreshData
{
    [super refreshData];
    [self loadAndhandleData];
}
//加载更多
- (void)loadingData
{
    [super loadingData];
    [self loadAndhandleData];
}

#pragma mark- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopicModel * topic             = self.dataArr[indexPath.row];
    TopicNewsViewController * tnVC = [[TopicNewsViewController alloc] init];
    tnVC.topicID                   = topic.topic_id;
    tnVC.topicName                 = topic.topic_name;
    [self pushVC:tnVC];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

#pragma mark- UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * cellid = [NSString stringWithFormat:@"%@%ld", @"visitList", indexPath.row];
    MoreTopicCell * cell = [self.refreshTableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[MoreTopicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    [cell setContentWith:self.dataArr[indexPath.row]];
    return cell;
}

#pragma mark- method response

#pragma mark- private method
- (void)loadAndhandleData
{
    
    NSString * url = [NSString stringWithFormat:@"%@?page=%d&category_id=%ld", kGetCategoryTopicListPath, self.currentPage, self.categoryId];
    debugLog(@"%@", url);
    [HttpService getWithUrlString:url andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            
            //下拉刷新清空数组
            if (self.isReloading) {
                [self.dataArr removeAllObjects];
            }
            self.isLastPage = [responseData[HttpResult][@"is_last"] boolValue];
            NSArray * list = responseData[HttpResult][HttpList];
            NSDictionary * result = responseData[HttpResult];
            if ([result objectForKey:@"category"]) {
                NSDictionary * dic                = [result objectForKey:@"category"];
                self.categoryModel.category_name  = [dic objectForKey:@"category_name"];
                self.categoryModel.category_desc  = [dic objectForKey:@"category_desc"];
                self.categoryModel.category_cover = [dic objectForKey:@"category_cover"];
            }else{
                self.categoryModel.category_name        = @"全部话题频道";
                self.categoryModel.category_desc        = @"全宇宙的事情都在这里讨论";
            }
            //刷新头部样式
            self.categoryDescLabel.text = self.categoryModel.category_desc;
            self.categoryNameLabel.text = self.categoryModel.category_name;
            [self.backImageView sd_setImageWithURL:[NSURL URLWithString:[ToolsManager completeUrlStr:self.categoryModel.category_cover]] placeholderImage:[UIImage imageNamed:@"group_main_background"]];
            
            //数据处理
            for (NSDictionary * dic in list) {
                TopicModel * topic          = [[TopicModel alloc] init];
                topic.topic_id              = [dic[@"topic_id"] integerValue];
                topic.topic_cover_image     = dic[@"topic_cover_image"];
                topic.topic_cover_sub_image = dic[@"topic_cover_sub_image"];
                topic.topic_name            = dic[@"topic_name"];
                topic.topic_detail          = dic[@"topic_detail"];
                topic.has_news              = [dic[@"has_news"] boolValue];
                topic.news_count            = [dic[@"news_count"] integerValue];
                topic.member_count          = [dic[@"member_count"] integerValue];
                [self.dataArr addObject:topic];
            }
            [self reloadTable];
        }else{
            [self showWarn:responseData[HttpMessage]];
            self.isReloading = NO;
            [self.refreshTableView refreshFinish];
        }
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.isReloading = NO;
        [self.refreshTableView refreshFinish];
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
