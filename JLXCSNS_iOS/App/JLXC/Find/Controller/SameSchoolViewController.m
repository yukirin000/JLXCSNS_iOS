//
//  SameSchoolViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/19.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "SameSchoolViewController.h"
#import "IMGroupModel.h"
#import "UIImageView+WebCache.h"
#import "OtherPersonalViewController.h"

//同校人Model
@interface SameSchoolModel : NSObject

//用户id
@property (nonatomic, assign) NSInteger uid;

//姓名
@property (nonatomic, copy) NSString * name;

//姓名
@property (nonatomic, copy) NSString * sign;

//姓别 0为男 1为女
@property (nonatomic, assign) NSInteger sex;

//头像图
@property (nonatomic, copy) NSString * head_image;

//头像缩略图
@property (nonatomic, copy) NSString * head_sub_image;

//是否是好友
@property (nonatomic, assign) BOOL is_friend;

@end

@implementation SameSchoolModel

@end

@interface SameSchoolViewController ()


@end

@implementation SameSchoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //如果自己没填学校
    if ([UserService sharedService].user.school_code.length < 1) {
        [self showWarn:@"你没填学校=_="];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    self.refreshTableView.frame = CGRectMake(0, kNavBarAndStatusHeight, self.viewWidth, self.viewHeight-kNavBarAndStatusHeight);
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

#define CellIdentifier @"contactCell"
#pragma mark- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell       = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle          = UITableViewCellSelectionStyleNone;
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    SameSchoolModel * sameSchool = self.dataArr[indexPath.row];
    //头像
    CustomImageView * imageView  = [[CustomImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
    imageView.backgroundColor    = [UIColor grayColor];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[ToolsManager completeUrlStr:sameSchool.head_sub_image]]];
    [cell.contentView addSubview:imageView];

    //昵称
    CustomLabel * nameLabel = [[CustomLabel alloc] initWithFontSize:15];
    CGSize size             = [ToolsManager getSizeWithContent:sameSchool.name andFontSize:15 andFrame:CGRectMake(0, 0, 200, 20)];
    nameLabel.frame         = CGRectMake(imageView.right+10, imageView.y+5, size.width, 20);
    nameLabel.text          = sameSchool.name;
    [cell.contentView addSubview:nameLabel];

    //性别
    CustomLabel * sexLabel  = [[CustomLabel alloc] initWithFontSize:15];
    sexLabel.frame          = CGRectMake(nameLabel.right+10, imageView.y+5, 50, 20);
    [cell.contentView addSubview:sexLabel];

    if (sameSchool.sex == SexBoy) {
        sexLabel.text      = @"男";
        sexLabel.textColor = [UIColor blueColor];
    }else if (sameSchool.sex == SexGirl) {
        sexLabel.text      = @"女";
        sexLabel.textColor = [UIColor colorWithRed:1 green:204/255.f blue:204/255.f alpha:1.0];
    }

    //签名
    CustomLabel * signLabel = [[CustomLabel alloc] initWithFontSize:14];
    signLabel.frame         = CGRectMake(nameLabel.x, nameLabel.bottom, 200, 20);
    signLabel.text          = sameSchool.sign;
    [cell.contentView addSubview:signLabel];

    //添加按钮
    CustomButton * addBtn   = [[CustomButton alloc] initWithFontSize:15];
    addBtn.frame            = CGRectMake(self.viewWidth-60, 15, 50, 30);
    //如果已经添加了
    if (sameSchool.is_friend == GroupHasAdd) {
        addBtn.backgroundColor = [UIColor darkGrayColor];
        [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addBtn setTitle:@"已添加" forState:UIControlStateNormal];
    }else{
        addBtn.backgroundColor = [UIColor yellowColor];
        addBtn.tag             = indexPath.row;
        [addBtn addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
        [addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [addBtn setTitle:@"添加" forState:UIControlStateNormal];
        
    }
    
    [cell.contentView addSubview:addBtn];
    
    return cell;
}

#pragma mark- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SameSchoolModel * sameSchool       = self.dataArr[indexPath.row];
    OtherPersonalViewController * opvc = [[OtherPersonalViewController alloc] init];
    opvc.uid                           = sameSchool.uid;
    [self pushVC:opvc];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

#pragma mark- method response
- (void)addFriend:(CustomButton *)sender
{
    
    SameSchoolModel * sameSchool = self.dataArr[sender.tag];
    [self addFriendCommitWith:sameSchool];
}

#pragma mark- private method
- (void)loadAndhandleData
{
    
    NSString * url = [NSString stringWithFormat:@"%@?page=%d&user_id=%ld&school_code=%@", kGetSameSchoolListPath, self.currentPage, [UserService sharedService].user.uid, [UserService sharedService].user.school_code];
    debugLog(@"%@", url);
    [HttpService getWithUrlString:url andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        debugLog(@"%@", responseData);
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            
            //下拉刷新清空数组
            if (self.isReloading) {
                [self.dataArr removeAllObjects];
            }
            self.isLastPage = [responseData[HttpResult][@"is_last"] boolValue];
            NSArray * list = responseData[HttpResult][HttpList];
            //数据处理
            for (NSDictionary * sameSchoolDic in list) {
                SameSchoolModel * sameSchool = [[SameSchoolModel alloc] init];
                sameSchool.sign              = sameSchoolDic[@"sign"];
                sameSchool.sex               = [sameSchoolDic[@"sex"] integerValue];
                sameSchool.name              = sameSchoolDic[@"name"];
                sameSchool.uid               = [sameSchoolDic[@"uid"] integerValue];
                sameSchool.head_sub_image    = sameSchoolDic[@"head_sub_image"];
                sameSchool.head_image        = sameSchoolDic[@"head_image"];
                sameSchool.is_friend         = [sameSchoolDic[@"is_friend"] boolValue];
                [self.dataArr addObject:sameSchool];
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
- (void)addFriendCommitWith:(SameSchoolModel *)sameSchool
{
    //kAddFriendPath
    NSDictionary * params = @{@"user_id":[NSString stringWithFormat:@"%ld", [UserService sharedService].user.uid],
                              @"friend_id":[NSString stringWithFormat:@"%ld", sameSchool.uid]
                              };
    
    debugLog(@"%@ %@", kAddFriendPath, params);
    [self showLoading:@"添加中^_^"];
    //添加好友
    [HttpService postWithUrlString:kAddFriendPath params:params andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        debugLog(@"%@", responseData);
        int status = [responseData[HttpStatus] intValue];
        
        if (status == HttpStatusCodeSuccess) {
            
            IMGroupModel * group = [IMGroupModel findByGroupId:[ToolsManager getCommonGroupId:sameSchool.uid]];
            //如果存在
            if (group) {
                group.groupTitle     = sameSchool.name;
                group.avatarPath     = sameSchool.head_image;
                group.isRead         = YES;
                group.isNew          = NO;
                group.currentState   = GroupHasAdd;
                [group update];
            }else{
                //保存群组信息
                group = [[IMGroupModel alloc] init];
                group.type           = ConversationType_PRIVATE;
                //targetId
                group.groupId        = [ToolsManager getCommonGroupId:sameSchool.uid];
                group.groupTitle     = sameSchool.name;
                group.isNew          = NO;
                group.avatarPath     = sameSchool.head_image;
                group.isRead         = YES;
                group.currentState   = GroupHasAdd;
                group.owner          = [UserService sharedService].user.uid;
                [group save];
            }
            
            //添加成功
            [self showComplete:responseData[HttpMessage]];
//            //发送消息通知
//            [[PushService sharedInstance] pushAddFriendMessageWithTargetID:group.groupId];
            sameSchool.is_friend = YES;
            
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

@end
