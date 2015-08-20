//
//  NewsFriendsListViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/29.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "NewFriendsListViewController.h"
#import "IMGroupModel.h"
#import "UIImageView+WebCache.h"
#import "OtherPersonalViewController.h"

@interface NewFriendsListViewController ()

//好友列表
@property (nonatomic, strong) UITableView * recentFriendsTableView;
//好友数据源
@property (nonatomic, strong) NSMutableArray * recentFriendsArr;

@end

@implementation NewFriendsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化列表
    [self initTableView];
}
//每一次进页面都重新更新数据源
- (void)viewWillAppear:(BOOL)animated
{
    [self refreshTable];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TAB_BADGE object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- layout
#define CellIdentifier @"NewsFriendsCell"
- (void)initTableView
{
    //列表
    self.recentFriendsTableView            = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusHeight, [DeviceManager getDeviceWidth], self.viewHeight-kNavBarAndStatusHeight) style:UITableViewStylePlain];
    self.recentFriendsTableView.delegate   = self;
    self.recentFriendsTableView.dataSource = self;
    [self.view addSubview:self.recentFriendsTableView];
    [self.recentFriendsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
}

- (void)initFriends
{
    if (self.recentFriendsArr == nil) {
        self.recentFriendsArr = [[NSMutableArray alloc] init];
        [self.recentFriendsArr addObjectsFromArray:[IMGroupModel findAllNewFriends]];
    }else{
        [self.recentFriendsArr removeAllObjects];
        [self.recentFriendsArr addObjectsFromArray:[IMGroupModel findAllNewFriends]];
    }
}

#pragma mark- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recentFriendsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle    = UITableViewCellSelectionStyleNone;
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //好友列表部分
    IMGroupModel * model    = self.recentFriendsArr[indexPath.row];
    //头像
    CustomImageView * headImageView = [[CustomImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:[ToolsManager completeUrlStr:model.avatarPath]] placeholderImage:[UIImage imageNamed:DEFAULT_AVATAR]];
    [cell.contentView addSubview:headImageView];
    //姓名
    CustomLabel * nameLabel = [[CustomLabel alloc] initWithFontSize:15];
    nameLabel.textColor     = [UIColor blackColor];
    nameLabel.text          = model.groupTitle;
    nameLabel.frame         = CGRectMake(headImageView.right+10, 10, 200, 20);
    [cell.contentView addSubview:nameLabel];
    
    CustomButton * addBtn   = [[CustomButton alloc] initWithFontSize:15];
    addBtn.frame            = CGRectMake(self.viewWidth-60, 15, 50, 30);
    //如果已经添加了
    if (model.currentState == GroupHasAdd) {
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMGroupModel * model = self.recentFriendsArr[indexPath.row];
    model.isNew = NO;
    [model update];
    [self refreshTable];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

#pragma mark- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    IMGroupModel * model               = self.recentFriendsArr[indexPath.row];
    OtherPersonalViewController * opvc = [[OtherPersonalViewController alloc] init];
    opvc.uid                           = [model.groupId stringByReplacingOccurrencesOfString:JLXC withString:@""].integerValue;
    [self pushVC:opvc];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

#pragma mark- method response
- (void)addFriend:(CustomButton *)sender
{
    
    IMGroupModel * imModel = self.recentFriendsArr[sender.tag];
    //用户模型
    UserModel * userModel  = [[UserModel alloc] init];
    userModel.uid          = [imModel.groupId stringByReplacingOccurrencesOfString:JLXC withString:@""].integerValue;
    userModel.name         = imModel.groupTitle;
    userModel.head_image   = imModel.avatarPath;
    [self addFriendCommitWith:userModel];
}

#pragma mark- private method
//添加好友
- (void)addFriendCommitWith:(UserModel *)imUserModel
{
    //kAddFriendPath
    NSDictionary * params = @{@"user_id":[NSString stringWithFormat:@"%ld", [UserService sharedService].user.uid],
                              @"friend_id":[NSString stringWithFormat:@"%ld", imUserModel.uid]
                              };
    
    debugLog(@"%@ %@", kAddFriendPath, params);
    [self showLoading:@"添加中^_^"];
    //添加好友
    [HttpService postWithUrlString:kAddFriendPath params:params andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        debugLog(@"%@", responseData);
        int status = [responseData[HttpStatus] intValue];

        if (status == HttpStatusCodeSuccess) {
            
            IMGroupModel * group = [IMGroupModel findByGroupId:[ToolsManager getCommonGroupId:imUserModel.uid]];
            //如果存在
            if (group) {
                
                group.groupTitle     = imUserModel.name;
                group.avatarPath     = imUserModel.head_image;
                group.isRead         = YES;
                group.isNew          = YES;
                group.currentState   = GroupHasAdd;
                [group update];
                
            }else{
                //保存群组信息
                group = [[IMGroupModel alloc] init];
                group.type           = ConversationType_PRIVATE;
                //targetId
                group.groupId        = [ToolsManager getCommonGroupId:imUserModel.uid];
                group.groupTitle     = imUserModel.name;
                group.isNew          = YES;
                group.avatarPath     = imUserModel.head_image;
                group.isRead         = YES;
                group.currentState   = GroupHasAdd;
                group.owner          = [UserService sharedService].user.uid;
                [group save];
            }
            
            //添加成功
            [self showComplete:responseData[HttpMessage]];
//            //发送消息通知
//            [[PushService sharedInstance] pushAddFriendMessageWithTargetID:group.groupId];
            
        }else{
            //添加过不能在添加了
            [self showWarn:responseData[HttpMessage]];
        }
        //刷新列表
        [self refreshTable];
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showWarn:StringCommonNetException];
    }];
}

//刷新当前列表
- (void)refreshTable
{
    [IMGroupModel hasRead];    
    [self initFriends];
    [self.recentFriendsTableView reloadData];

    
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
