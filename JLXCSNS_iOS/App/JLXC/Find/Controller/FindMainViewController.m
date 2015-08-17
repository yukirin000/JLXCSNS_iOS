//
//  FindMainViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/18.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "FindMainViewController.h"
#import "MyNewsListViewController.h"
#import "IMGroupModel.h"
#import "OtherPersonalViewController.h"
#import "RecommendFriendModel.h"
#import "SearchUserViewController.h"
#import "SameSchoolViewController.h"
#import "QRcodeViewController.h"
#import "ContactViewController.h"
#import "RecommendCell.h"

@interface FindMainViewController ()<RefreshDataDelegate,RecommendDelegate>

@end

@implementation FindMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.refreshTableView.frame = CGRectMake(0, kNavBarAndStatusHeight, self.viewWidth, self.viewHeight-kNavBarAndStatusHeight-kTabBarHeight);
    
    __weak typeof(self) sself = self;
    [self.navBar setRightBtnWithContent:@"扫一扫" andBlock:^{
        QRcodeViewController * qrVC = [[QRcodeViewController alloc] init];
        [sself pushVC:qrVC];
    }];
    
    [self loadAndhandleData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


#pragma mark- override
- (void)createRefreshView
{
    //展示数据的列表
    if ([DeviceManager getDeviceSystem] >= 7.0) {
        self.refreshTableView                 = [[RefreshTableView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusHeight, self.viewWidth, self.viewHeight-kNavBarAndStatusHeight) style:UITableViewStyleGrouped];
    }else{
        self.refreshTableView                 = [[RefreshTableView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusHeight, self.viewWidth, self.viewHeight-kNavBarAndStatusHeight) style:UITableViewStylePlain];
    }
    
    self.refreshTableView.delegate        = self;
    self.refreshTableView.dataSource      = self;
    self.refreshTableView.refreshDelegate = self;
    self.refreshTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.refreshTableView];
    self.refreshTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.refreshTableView.bounds.size.width, 0.01f)];
}

#pragma mark- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellID    = [NSString stringWithFormat:@"findCell%ld", indexPath.row];
    RecommendCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell          = [[RecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.delegate = self;
    }
    [cell setContentWithModel:self.dataArr[indexPath.row]];
    
    return cell;
}

#pragma mark- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendFriendModel * recommendModel = self.dataArr[indexPath.row];
    MyNewsListViewController * mnlvc = [[MyNewsListViewController alloc] init];
    mnlvc.isOther = YES;
    mnlvc.uid     = recommendModel.uid;
    [self pushVC:mnlvc];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendFriendModel * recommendModel = self.dataArr[indexPath.row];
    
    if (recommendModel.imageArr.count > 0) {
        return 140;
    }
    
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * backView        = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 100)];
    backView.backgroundColor = [UIColor whiteColor];
    
    //搜索框按钮
    CustomButton * searchBtn  = [[CustomButton alloc] initWithFontSize:15];
    searchBtn.backgroundColor = [UIColor darkGrayColor];
    searchBtn.frame           = CGRectMake(kCenterOriginX(200), 0, 200, 30);
    [searchBtn addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setTitle:@"搜索昵称/哈哈号" forState:UIControlStateNormal];
    [backView addSubview:searchBtn];
    
    //通讯录按钮
    CustomButton * contactBtn  = [[CustomButton alloc] initWithFontSize:15];
    [contactBtn addTarget:self action:@selector(contactClick:) forControlEvents:UIControlEventTouchUpInside];
    contactBtn.backgroundColor = [UIColor lightGrayColor];
    contactBtn.frame           = CGRectMake(0, 30, self.viewWidth/2, 70);
    [backView addSubview:contactBtn];
    CustomLabel * contactLabel = [[CustomLabel alloc] initWithFontSize:12];
    contactLabel.frame         = CGRectMake(0, 40, contactBtn.width, 20);
    contactLabel.textAlignment = NSTextAlignmentCenter;
    contactLabel.text          = @"添加通讯录好友";
    [contactBtn addSubview:contactLabel];
    
    //同校按钮
    CustomButton * schoolBtn  = [[CustomButton alloc] initWithFontSize:15];
    [schoolBtn addTarget:self action:@selector(sameSchoolClick:) forControlEvents:UIControlEventTouchUpInside];
    schoolBtn.backgroundColor = [UIColor lightGrayColor];
    schoolBtn.frame           = CGRectMake(contactBtn.right, 30, self.viewWidth/2, 70);
    [backView addSubview:schoolBtn];
    CustomLabel * schoolLabel = [[CustomLabel alloc] initWithFontSize:12];
    schoolLabel.frame         = CGRectMake(0, 40, contactBtn.width, 20);
    schoolLabel.textAlignment = NSTextAlignmentCenter;
    schoolLabel.text          = @"添加同校的好友";
    [schoolBtn addSubview:schoolLabel];
    
    return backView;
}
#pragma mark- RecommendDelegate
- (void)addFriendClick:(RecommendFriendModel *)model
{
    [self addFriendCommitWith:model];
}

#pragma mark- method response
//联系人点击
- (void)contactClick:(id)sender
{
    ContactViewController * cvc = [[ContactViewController alloc] init];
    [self pushVC:cvc];
}
//相同的学校点击
- (void)sameSchoolClick:(id)sender
{
    SameSchoolViewController * ssvc = [[SameSchoolViewController alloc] init];
    [self pushVC:ssvc];
}
//搜索点击
- (void)searchClick:(id)sender
{
    SearchUserViewController * suvc = [[SearchUserViewController alloc] init];
    [self pushVC:suvc];
}

#pragma mark- private method
- (void)loadAndhandleData
{
    
    NSString * url = [NSString stringWithFormat:@"%@?page=%d&user_id=%ld&school_code=%@", kRecommendFriendsListPath, self.currentPage, [UserService sharedService].user.uid, [UserService sharedService].user.school_code];
    debugLog(@"%@", url);
    [HttpService getWithUrlString:url andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
//        debugLog(@"%@", responseData);
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            
            //下拉刷新清空数组
            if (self.isReloading) {
                [self.dataArr removeAllObjects];
            }
            self.isLastPage = [responseData[HttpResult][@"is_last"] boolValue];
            NSArray * list = responseData[HttpResult][HttpList];
            for (NSDictionary * recommendDic in list) {
                RecommendFriendModel * recommend = [[RecommendFriendModel alloc] init];
                recommend.name                   = recommendDic[@"name"];
                recommend.uid                    = [recommendDic[@"uid"] integerValue];
                recommend.head_sub_image         = recommendDic[@"head_sub_image"];
                recommend.head_image             = recommendDic[@"head_image"];
                recommend.school                 = recommendDic[@"school"];
                recommend.typeDic                = recommendDic[@"type"];
                
                for (NSDictionary * imageDic in recommendDic[@"images"]) {
                    [recommend.imageArr addObject:imageDic[@"sub_url"]];
                }
                
                NSPredicate * predicate = [NSPredicate predicateWithFormat:@"uid == %ld", recommend.uid];
                //如果当前没有则添加
                if ([self.dataArr filteredArrayUsingPredicate:predicate].count < 1) {
                    [self.dataArr addObject:recommend];
                }
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


//添加好友
- (void)addFriendCommitWith:(RecommendFriendModel *)recommentModel
{
    //kAddFriendPath
    NSDictionary * params = @{@"user_id":[NSString stringWithFormat:@"%ld", [UserService sharedService].user.uid],
                              @"friend_id":[NSString stringWithFormat:@"%ld", recommentModel.uid]
                              };
    
    debugLog(@"%@ %@", kAddFriendPath, params);
    [self showLoading:@"添加中^_^"];
    //添加好友
    [HttpService postWithUrlString:kAddFriendPath params:params andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        debugLog(@"%@", responseData);
        int status = [responseData[HttpStatus] intValue];
        
        if (status == HttpStatusCodeSuccess) {
            
            IMGroupModel * group = [IMGroupModel findByGroupId:[ToolsManager getCommonGroupId:recommentModel.uid]];
            //如果存在
            if (group) {
                
                group.groupTitle     = recommentModel.name;
                group.avatarPath     = recommentModel.head_image;
                group.isRead         = YES;
                group.isNew          = NO;
                group.currentState   = GroupHasAdd;
                [group update];
                
            }else{
                //保存群组信息
                group = [[IMGroupModel alloc] init];
                group.type           = ConversationType_PRIVATE;
                //targetId
                group.groupId        = [ToolsManager getCommonGroupId:recommentModel.uid];
                group.groupTitle     = recommentModel.name;
                group.isNew          = NO;
                group.avatarPath     = recommentModel.head_image;
                group.isRead         = YES;
                group.currentState   = GroupHasAdd;
                group.owner          = [UserService sharedService].user.uid;
                [group save];
            }
            
            //添加成功
            [self showComplete:responseData[HttpMessage]];
//            //发送消息通知
//            [[PushService sharedInstance] pushAddFriendMessageWithTargetID:group.groupId];
            recommentModel.addFriend = YES;
            
        }else{
            //添加过不能在添加了
            [self showWarn:responseData[HttpMessage]];
        }
        //刷新列表
        [self.refreshTableView reloadData];
        
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
