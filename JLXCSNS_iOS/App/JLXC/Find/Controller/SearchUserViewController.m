//
//  SearchUserViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/20.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "SearchUserViewController.h"
#import "IMGroupModel.h"
#import "UIImageView+WebCache.h"
#import "OtherPersonalViewController.h"

//查人Model
@interface FindUserModel : NSObject

//用户id
@property (nonatomic, assign) NSInteger uid;

//姓名
@property (nonatomic, copy) NSString * name;

//头像图
@property (nonatomic, copy) NSString * head_image;

//头像缩略图
@property (nonatomic, copy) NSString * head_sub_image;

//是否是好友
@property (nonatomic, assign) BOOL is_friend;

//0是正常的 1是第一行搜索号码
@property (nonatomic, assign) NSInteger type;

@end

@implementation FindUserModel

@end

@interface SearchUserViewController ()

//搜索栏
@property (nonatomic, strong) UISearchBar * searchBar;

//当前的搜索内容
@property (nonatomic, copy) NSString * currentContnet;

@end

@implementation SearchUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- layout
- (void)configUI
{
    [self setNavBarTitle:@"搜索"];
    
    self.refreshTableView.frame = CGRectMake(0, kNavBarAndStatusHeight, self.viewWidth, self.viewHeight-kNavBarAndStatusHeight);
    self.refreshTableView.bottomLoading = @"请输入搜索内容.....";
    [self.refreshTableView canLoadingMore];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.refreshTableView.frame.size.width, 0)];
    self.searchBar.tintColor = [UIColor greenColor];
    [self.searchBar setDelegate:self];
    [self.searchBar setPlaceholder:@"搜索昵称/哈哈号"];
    [self.searchBar sizeToFit];
    [self.searchBar setTranslucent:YES];
    [self.refreshTableView setTableHeaderView:self.searchBar];
    
}

#pragma override
//下拉刷新
- (void)refreshData
{
    [super refreshData];
    [self loadAndhandleDataWith:self.currentContnet];
}
//加载更多
- (void)loadingData
{
    [super loadingData];
    [self loadAndhandleDataWith:self.currentContnet];
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
    
    FindUserModel * find = self.dataArr[indexPath.row];
    
    if (find.type == 1) {
        
        //查找哈哈号label
        CustomLabel * hahaLabel = [[CustomLabel alloc] initWithFontSize:20];
        hahaLabel.frame         = CGRectMake(10, 10, 300, 40);
        hahaLabel.text          = [NSString stringWithFormat:@"查找哈哈号：%@", self.currentContnet];
        [cell.contentView addSubview:hahaLabel];

    }else{
        //头像
        CustomImageView * imageView  = [[CustomImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
        imageView.backgroundColor    = [UIColor grayColor];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[ToolsManager completeUrlStr:find.head_sub_image]]];
        [cell.contentView addSubview:imageView];
        
        //昵称
        CustomLabel * nameLabel = [[CustomLabel alloc] initWithFontSize:15];
        CGSize size             = [ToolsManager getSizeWithContent:find.name andFontSize:15 andFrame:CGRectMake(0, 0, 200, 20)];
        nameLabel.frame         = CGRectMake(imageView.right+10, imageView.y+5, size.width, 20);
        nameLabel.text          = find.name;
        [cell.contentView addSubview:nameLabel];
        
        //性别
        CustomLabel * sexLabel  = [[CustomLabel alloc] initWithFontSize:15];
        sexLabel.frame          = CGRectMake(nameLabel.right+10, imageView.y+5, 50, 20);
        [cell.contentView addSubview:sexLabel];
        
        //添加按钮
        CustomButton * addBtn   = [[CustomButton alloc] initWithFontSize:15];
        addBtn.frame            = CGRectMake(self.viewWidth-60, 15, 50, 30);
        //如果已经添加了
        if (find.is_friend == GroupHasAdd) {
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
    }
    
    
    return cell;
}
#pragma mark- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    FindUserModel * find       = self.dataArr[indexPath.row];
    if (find.type == 1) {
        [self searchHaHaId];
    }else{
        OtherPersonalViewController * opvc = [[OtherPersonalViewController alloc] init];
        opvc.uid                           = find.uid;
        [self pushVC:opvc];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

#pragma mark- UIScrollViewDeleagte
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - Search Bar Delegate
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar; {
    
    self.currentContnet = searchBar.text;
    self.isReloading = YES;
    [self loadAndhandleDataWith:self.currentContnet];
    [searchBar resignFirstResponder];
}

#pragma mark- method response
- (void)addFriend:(CustomButton *)sender
{
    
    FindUserModel * find = self.dataArr[sender.tag];
    [self addFriendCommitWith:find];
}


#pragma mark- private method
- (void)loadAndhandleDataWith:(NSString *)content
{
    
    NSString * url = [NSString stringWithFormat:@"%@?page=%d&user_id=%ld&content=%@", kFindUserListPath, self.currentPage, [UserService sharedService].user.uid, [content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
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
            NSArray * list  = responseData[HttpResult][HttpList];
            
            //如果是用户名格式的
            if ([ToolsManager validateUserName:content]) {
                FindUserModel * find = [[FindUserModel alloc] init];
                find.type = 1;
                [self.dataArr addObject:find];
            }
            
            //数据处理
            for (NSDictionary * findDic in list) {
                FindUserModel * find = [[FindUserModel alloc] init];
                find.name            = findDic[@"name"];
                find.uid             = [findDic[@"uid"] integerValue];
                find.head_sub_image  = findDic[@"head_sub_image"];
                find.head_image      = findDic[@"head_image"];
                find.is_friend       = [findDic[@"is_friend"] boolValue];
                [self.dataArr addObject:find];
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

- (void)searchHaHaId
{
    
    NSString * url = [NSString stringWithFormat:@"%@?helloha_id=%@", kHelloHaIdExistsPath, self.currentContnet];
    debugLog(@"%@", url);
    [self showLoading:@"查询中.."];
    [HttpService getWithUrlString:url andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        debugLog(@"%@", responseData);
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            [self hideLoading];
            
            OtherPersonalViewController * opvc = [[OtherPersonalViewController alloc] init];
            opvc.uid                           = [responseData[HttpResult][@"uid"] integerValue];
            [self pushVC:opvc];
            
        }else{
            [self showWarn:responseData[HttpMessage]];
        }
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {

        [self showWarn:StringCommonNetException];
    }];
}

//添加好友
- (void)addFriendCommitWith:(FindUserModel *)find
{
    //kAddFriendPath
    NSDictionary * params = @{@"user_id":[NSString stringWithFormat:@"%ld", [UserService sharedService].user.uid],
                              @"friend_id":[NSString stringWithFormat:@"%ld", find.uid]
                              };
    
    debugLog(@"%@ %@", kAddFriendPath, params);
    [self showLoading:@"添加中^_^"];
    //添加好友
    [HttpService postWithUrlString:kAddFriendPath params:params andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        debugLog(@"%@", responseData);
        int status = [responseData[HttpStatus] intValue];
        
        if (status == HttpStatusCodeSuccess) {
            IMGroupModel * group = [IMGroupModel findByGroupId:[ToolsManager getCommonGroupId:find.uid]];
            //如果存在
            if (group) {
                
                group.groupTitle     = find.name;
                group.avatarPath     = find.head_image;
                group.isRead         = YES;
                group.isNew          = NO;
                group.currentState   = GroupHasAdd;
                [group update];
                
            }else{
                //保存群组信息
                group = [[IMGroupModel alloc] init];
                group.type           = ConversationType_PRIVATE;
                //targetId
                group.groupId        = [ToolsManager getCommonGroupId:find.uid];
                group.groupTitle     = find.name;
                group.isNew          = NO;
                group.avatarPath     = find.head_image;
                group.isRead         = YES;
                group.currentState   = GroupHasAdd;
                group.owner          = [UserService sharedService].user.uid;
                [group save];
            }
            
            //添加成功
            [self showComplete:responseData[HttpMessage]];
//            //发送消息通知
//            [[PushService sharedInstance] pushAddFriendMessageWithTargetID:group.groupId];
            find.is_friend = YES;
            
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
