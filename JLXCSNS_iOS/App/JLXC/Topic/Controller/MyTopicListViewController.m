//
//  MyTopicListViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/9/26.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "MyTopicListViewController.h"
#import "TopicNewsViewController.h"
#import "MyTopicCell.h"
#import "TopicModel.h"

@interface MyTopicListViewController ()

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation MyTopicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavBarTitle:@"我的频道"];
    [self initTable];
    
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#define CellID @"cell"
#pragma mark- layout
- (void)initTable
{
    self.dataSource                = [[NSMutableArray alloc] init];

    self.tableView                 = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusHeight, self.viewWidth, self.viewHeight-kNavBarAndStatusHeight) style:UITableViewStylePlain];
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:ColorLightWhite];
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[MyTopicCell class] forCellReuseIdentifier:CellID];
}

#pragma mark- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTopicCell * cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    [cell setContentWith:self.dataSource[indexPath.row]];
    return cell;
}

#pragma mark- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopicModel * topic             = self.dataSource[indexPath.row];
    TopicNewsViewController * tnVC = [[TopicNewsViewController alloc] init];
    tnVC.topicID                   = topic.topic_id;
    tnVC.topicName                 = topic.topic_name;
    [self pushVC:tnVC];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

#pragma mark- private method
- (void)getData
{
    
    NSString * url = [NSString stringWithFormat:@"%@?&user_id=%ld", kGetMyTopicListPath, [UserService sharedService].user.uid];
    debugLog(@"%@", url);
    [HttpService getWithUrlString:url andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            
            //下拉刷新清空数组
            [self.dataSource removeAllObjects];
            NSArray * list = responseData[HttpResult][HttpList];
            
            //数据处理
            for (NSDictionary * dic in list) {
                TopicModel * topic          = [[TopicModel alloc] init];
                topic.topic_id              = [dic[@"topic_id"] integerValue];
                topic.topic_cover_sub_image = dic[@"topic_cover_sub_image"];
                topic.topic_name            = dic[@"topic_name"];
                topic.member_count          = [dic[@"member_count"] integerValue];
                topic.unread_news_count     = [dic[@"unread_news_count"] integerValue];
                [self.dataSource addObject:topic];
            }
            
            [self.tableView reloadData];
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
