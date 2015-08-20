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
#import "FindUtils.h"

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
    
    [self setNavBarTitle:@"同校的好友~"];
    
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
    
    cell.selectionStyle            = UITableViewCellSelectionStyleNone;
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    SameSchoolModel * sameSchool   = self.dataArr[indexPath.row];
    //头像
    CustomImageView * imageView    = [[CustomImageView alloc] initWithFrame:CGRectMake(10, 10, 45, 45)];
    imageView.layer.cornerRadius   = 2;
    imageView.layer.masksToBounds  = YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:[ToolsManager completeUrlStr:sameSchool.head_sub_image]] placeholderImage:[UIImage imageNamed:DEFAULT_AVATAR]];
    [cell.contentView addSubview:imageView];

    //昵称
    CustomLabel * nameLabel        = [[CustomLabel alloc] initWithFontSize:15];
    CGSize size                    = [ToolsManager getSizeWithContent:sameSchool.name andFontSize:15 andFrame:CGRectMake(0, 0, 200, 20)];
    nameLabel.frame                = CGRectMake(imageView.right+10, imageView.y+3, size.width, 20);
    nameLabel.font                 = [UIFont systemFontOfSize:FontListName];
    nameLabel.textColor            = [UIColor colorWithHexString:ColorDeepBlack];
    nameLabel.text                 = sameSchool.name;
    [cell.contentView addSubview:nameLabel];

    //性别
    CustomImageView * sexImageView = [[CustomImageView alloc] init];
    sexImageView.frame             = CGRectMake(nameLabel.right+5, imageView.y+5, 15, 15);
    if (sameSchool.sex == SexBoy) {
        sexImageView.image             = [UIImage imageNamed:@"sex_boy"];
    }else if (sameSchool.sex == SexGirl) {
        sexImageView.image             = [UIImage imageNamed:@"sex_girl"];
    }
    [cell.contentView addSubview:sexImageView];
    
    //签名
    CustomLabel * signLabel        = [[CustomLabel alloc] initWithFontSize:14];
    signLabel.frame                = CGRectMake(nameLabel.x, nameLabel.bottom+1, 200, 20);
    signLabel.font                 = [UIFont systemFontOfSize:FontListContent];
    signLabel.textColor            = [UIColor colorWithHexString:ColorDeepGary];
    signLabel.text                 = sameSchool.sign;
    [cell.contentView addSubview:signLabel];

    //添加按钮
    CustomButton * addBtn          = [[CustomButton alloc] initWithFontSize:15];
    addBtn.frame                   = CGRectMake(self.viewWidth-65, 17, 50, 23);
    //如果已经添加了
    if (sameSchool.is_friend == GroupHasAdd) {
        [addBtn setImage:[UIImage imageNamed:@"friend_btn_isadd"] forState:UIControlStateNormal];
        addBtn.enabled = NO;
    }else{
        addBtn.enabled = YES;
        [addBtn setImage:[UIImage imageNamed:@"friend_btn_add"] forState:UIControlStateNormal];
    }
    [cell.contentView addSubview:addBtn];
    
    UIView * lineView        = [[UIView alloc] initWithFrame:CGRectMake(10, 64, [DeviceManager getDeviceWidth], 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:ColorLightGary];
    [cell.contentView addSubview:lineView];
    
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
    return 65.0f;
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

            //添加好友处理
            IMGroupModel * group = [[IMGroupModel alloc] init];
            group.groupId        = [ToolsManager getCommonGroupId:sameSchool.uid];
            group.groupTitle     = sameSchool.name;
            group.avatarPath     = sameSchool.head_image;
            [FindUtils addFriendWith:group];
            
            //添加成功
            [self showComplete:responseData[HttpMessage]];
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
