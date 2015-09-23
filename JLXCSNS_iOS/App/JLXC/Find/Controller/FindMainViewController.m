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
#import "FindUtils.h"

@interface FindMainViewController ()<RefreshDataDelegate,RecommendDelegate>

@end

@implementation FindMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.refreshTableView.frame = CGRectMake(0, kNavBarAndStatusHeight, self.viewWidth, self.viewHeight-kNavBarAndStatusHeight-kTabBarHeight);
    
    [self configUI];
    
    [self loadAndhandleData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- layout
- (void)configUI
{
    [self setNavBarTitle:@"找同学"];
    
//    __weak typeof(self) sself = self;
//    [self.navBar setRightBtnWithContent:@"" andBlock:^{
//        QRcodeViewController * qrVC = [[QRcodeViewController alloc] init];
//        [sself pushVC:qrVC];
//    }];
//    [self.navBar.rightBtn setImage:[UIImage imageNamed:@"qrcode_scan_btn_normal"] forState:UIControlStateNormal];
//    [self.navBar.rightBtn setImage:[UIImage imageNamed:@"qrcode_scan_btn_press"] forState:UIControlStateHighlighted];
    
    //顶部背景
    UIView * backView                   = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 0)];
    backView.backgroundColor            = [UIColor colorWithHexString:ColorLightWhite];

    //搜索框按钮
    CustomButton * searchBtn            = [[CustomButton alloc] initWithFontSize:14];
    searchBtn.backgroundColor           = [UIColor colorWithHexString:ColorWhite];
    searchBtn.frame                     = CGRectMake(kCenterOriginX((self.viewWidth-40)), 10, self.viewWidth-40, 30);
    [searchBtn setTitle:@"搜索昵称、HelloHa号" forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setTitleColor:[UIColor colorWithHexString:ColorLightBlack] forState:UIControlStateNormal];
    [backView addSubview:searchBtn];

    //通讯录按钮
    CustomButton * contactBtn           = [[CustomButton alloc] init];
    [contactBtn setImage:[UIImage imageNamed:@"friend_btn_phonebook_normal"] forState:UIControlStateNormal];
    [contactBtn setImage:[UIImage imageNamed:@"friend_btn_phonebook_click"] forState:UIControlStateHighlighted];
    contactBtn.backgroundColor          = [UIColor colorWithHexString:ColorWhite];
    contactBtn.imageEdgeInsets          = UIEdgeInsetsMake(10, 0, 0, 0);
    contactBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    contactBtn.frame                    = CGRectMake(0, 50, self.viewWidth/2, 80);
    [backView addSubview:contactBtn];

    CustomLabel * contactLabel          = [[CustomLabel alloc] initWithFontSize:15];
    contactLabel.frame                  = CGRectMake(0, contactBtn.height-30, contactBtn.width, 20);
    contactLabel.textAlignment          = NSTextAlignmentCenter;
    contactLabel.text                   = @"通讯录中的小伙伴";
    contactLabel.textColor              = [UIColor colorWithHexString:ColorLightBlack];
    [contactBtn addSubview:contactLabel];

    //同校按钮
    CustomButton * schoolBtn            = [[CustomButton alloc] init];
    [schoolBtn setImage:[UIImage imageNamed:@"friend_btn_schoolmate_normal"] forState:UIControlStateNormal];
    [schoolBtn setImage:[UIImage imageNamed:@"friend_btn_schoolmate_click"] forState:UIControlStateHighlighted];
    schoolBtn.backgroundColor           = [UIColor colorWithHexString:ColorWhite];
    schoolBtn.imageEdgeInsets           = UIEdgeInsetsMake(10, 0, 0, 0);
    schoolBtn.contentVerticalAlignment  = UIControlContentVerticalAlignmentTop;
    schoolBtn.frame                     = CGRectMake(self.viewWidth/2, 50, self.viewWidth/2, 80);
    [backView addSubview:schoolBtn];
    CustomLabel * schoolLabel           = [[CustomLabel alloc] initWithFontSize:15];
    schoolLabel.frame                   = CGRectMake(0, contactBtn.height-30, contactBtn.width, 20);
    schoolLabel.textAlignment           = NSTextAlignmentCenter;
    schoolLabel.textColor               = [UIColor colorWithHexString:ColorLightBlack];
    schoolLabel.text                    = @"同校中的小伙伴";
    [schoolBtn addSubview:schoolLabel];

    UIView * verticalLine               = [[UIView alloc] initWithFrame:CGRectMake(self.viewWidth/2, schoolBtn.y+5, 1, schoolBtn.height-10)];
    verticalLine.backgroundColor        = [UIColor colorWithHexString:ColorLightGary];
    [backView addSubview:verticalLine];

    //标题
    CustomLabel * listTitleLabel        = [[CustomLabel alloc] initWithFontSize:15];
    listTitleLabel.frame                = CGRectMake(15, schoolBtn.bottom+10, 200, 20);
    listTitleLabel.text                 = @"可能认识的同学 ╭(′▽`)╯";
    listTitleLabel.textColor            = [UIColor colorWithHexString:ColorLightBlack];
    [backView addSubview:listTitleLabel];
    
    backView.height = listTitleLabel.bottom+3;
    [self.refreshTableView setTableHeaderView:backView];
    
    [contactBtn addTarget:self action:@selector(contactClick:) forControlEvents:UIControlEventTouchUpInside];
    [schoolBtn addTarget:self action:@selector(sameSchoolClick:) forControlEvents:UIControlEventTouchUpInside];
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
//    MyNewsListViewController * mnlvc      = [[MyNewsListViewController alloc] init];
//    mnlvc.isOther                         = YES;
//    mnlvc.uid                             = recommendModel.uid;
//    [self pushVC:mnlvc];
    OtherPersonalViewController  * opvc = [[OtherPersonalViewController alloc] init];
    opvc.uid                            = recommendModel.uid;
    [self pushVC:opvc];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendFriendModel * recommendModel = self.dataArr[indexPath.row];
    
    if (recommendModel.imageArr.count > 0) {
        return 85+self.viewWidth/4.5;
    }
    
    return 80;
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
            
            //添加好友处理
            IMGroupModel * group = [[IMGroupModel alloc] init];
            group.groupId        = [ToolsManager getCommonGroupId:recommentModel.uid];
            group.groupTitle     = recommentModel.name;
            group.avatarPath     = recommentModel.head_image;
            [FindUtils addFriendWith:group];
            
            //添加成功
            [self showComplete:responseData[HttpMessage]];
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
