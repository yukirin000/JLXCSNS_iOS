//
//  NotifyNewsViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/25.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "NotifyNewsViewController.h"
#import "NewsPushModel.h"
#import "NewsPushCell.h"
#import "NewsDetailViewController.h"
#import "IMGroupModel.h"
#import "NewFriendsListViewController.h"
#import "UIImageView+WebCache.h"

@interface NotifyNewsViewController ()

//好友列表
@property (nonatomic, strong) UITableView * pushTableView;
//好友数据源
@property (nonatomic, strong) NSMutableArray * dataArr;
//新的朋友请求数组
@property (nonatomic, strong) NSMutableArray * recentFriendsArr;
//没有点进添加列表看的新朋友
@property (nonatomic ,assign) NSInteger unReadNum;

@end

@implementation NotifyNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化列表
    [self initTable];
    //注册通知
    [self registerNotify];
    [self configUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [NewsPushModel setIsRead];
    //顶部消息通知未读提示更新
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_REFRESH object:nil];
    
    [self refreshData];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- layout
//初始化新的朋友
- (void)initNewsFriends
{
    //未读的新朋友
    self.unReadNum  = [IMGroupModel unReadNewFriendsCount];
    if (self.recentFriendsArr == nil) {
        self.recentFriendsArr = [[NSMutableArray alloc] init];
        [self.recentFriendsArr addObjectsFromArray:[IMGroupModel findThreeNewFriends]];
    }else{
        [self.recentFriendsArr removeAllObjects];
        [self.recentFriendsArr addObjectsFromArray:[IMGroupModel findThreeNewFriends]];
    }
}

- (void)configUI
{
//    __weak typeof(self) sself = self;
//    [self.navBar setRightBtnWithContent:@"清空" andBlock:^{
//        
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:StringCommonPrompt message:@"确认要清空么?" delegate:sself cancelButtonTitle:StringCommonCancel otherButtonTitles:StringCommonConfirm, nil];
//        [alert show];
//        
//    }];
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//        [self setNeedsStatusBarAppearanceUpdate];
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    }
}

- (void)initTable
{
    self.dataArr = [[NSMutableArray alloc] init];
    
    self.pushTableView            = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [DeviceManager getDeviceWidth], [DeviceManager getDeviceHeight]-kNavBarAndStatusHeight-kTabBarHeight) style:UITableViewStylePlain];
    self.pushTableView.delegate   = self;
    self.pushTableView.dataSource = self;
    [self.view addSubview:self.pushTableView];
}

#pragma mark- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellId = [NSString stringWithFormat:@"pushNews%ld", indexPath.row];
    
    //新的好友部分
    if (indexPath.row == 0) {

        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        //标题
        CustomLabel * titleLabel = [[CustomLabel alloc] initWithFontSize:15];
        titleLabel.textColor     = [UIColor blackColor];
        titleLabel.text          = @"新的请求";
        titleLabel.frame         = CGRectMake(10, 20, 80, 20);
        [cell.contentView addSubview:titleLabel];
        //循环列表
        for (int i=0; i<self.recentFriendsArr.count; i++) {
            //新好友
            IMGroupModel * newModel    = self.recentFriendsArr[i];
            CGRect frame = CGRectMake(titleLabel.right + 10 + 60*i, 5, 50, 50);
            CustomImageView * newHeadImageView = [[CustomImageView alloc] initWithFrame:frame];
            [newHeadImageView sd_setImageWithURL:[NSURL URLWithString:[ToolsManager completeUrlStr:newModel.avatarPath]] placeholderImage:[UIImage imageNamed:@"testimage"]];
            [cell.contentView addSubview:newHeadImageView];
        }

        if (self.unReadNum > 0) {
            CustomLabel * unReadLabel       = [[CustomLabel alloc] initWithFontSize:15];
            [unReadLabel setFontBold];
            unReadLabel.layer.cornerRadius  = 10;
            unReadLabel.layer.masksToBounds = YES;
            unReadLabel.textAlignment       = NSTextAlignmentCenter;
            unReadLabel.frame               = CGRectMake([DeviceManager getDeviceWidth]-40, 20, 20, 20);
            NSInteger num = self.unReadNum;
            if (num > 99) {
                num = 99;
            }
            unReadLabel.text            = [NSString stringWithFormat:@"%ld",num];
            unReadLabel.textColor       = [UIColor whiteColor];
            unReadLabel.backgroundColor = [UIColor redColor];
            [cell.contentView addSubview:unReadLabel];
        }
        return cell;
    }
    
    NewsPushCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[NewsPushCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NewsPushModel * push = self.dataArr[indexPath.row-1];
    [cell setContentWithModel:push];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NewsPushModel * push = self.dataArr[indexPath.row-1];
    [push remove];
    [self.dataArr removeObject:push];
    [self.pushTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return NO;
    }
    
    return YES;
}

#pragma mark- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //新的朋友
    if (indexPath.row == 0) {

        NewFriendsListViewController * nflVC = [[NewFriendsListViewController alloc] init];
        [self.navigationController pushViewController:nflVC animated:YES];
        return;
    }
    
    NewsDetailViewController * ndvc = [[NewsDetailViewController alloc] init];
    NewsPushModel * news            = self.dataArr[indexPath.row-1];
    ndvc.newsId                     = news.news_id;
//    [self pushVC:ndvc];
    [self.navigationController pushViewController:ndvc animated:YES];
}

#pragma mark- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [NewsPushModel removeAll];
        
        [self.pushTableView reloadData];
    }
}

#pragma mark- private method
- (void)refreshData
{
    if (self.dataArr.count > 0) {
        [self.dataArr removeAllObjects];
    }
    [self initNewsFriends];
    [self.dataArr addObjectsFromArray:[NewsPushModel findAll]];
    [self.pushTableView reloadData];
    
    //徽标跟新
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TAB_BADGE object:nil];
    
}

- (void)registerNotify
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newsPushReciver:) name:NOTIFY_NEWS_PUSH object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFriendsTable) name:NOTIFY_NEW_GROUP object:nil];
}

- (void)newsPushReciver:(NSNotification *)notify
{
    [self refreshData];
}

#pragma mark- private method
- (void)refreshFriendsTable
{
    [self initNewsFriends];
    [self.pushTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
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