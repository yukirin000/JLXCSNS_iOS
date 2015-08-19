//
//  FriendSettingViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/30.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "FriendSettingViewController.h"
#import "IMGroupModel.h"
#import "AddRemarkViewController.h"
#import "ReportOffenceViewController.h"

@interface FriendSettingViewController ()

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSArray * settingArr;

@end

@implementation FriendSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTable];
    
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- layout
#define CellIdentifier @"settingCell"
- (void)createTable
{
    self.tableView                = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusHeight+20, self.viewWidth, self.viewHeight-kNavBarAndStatusHeight) style:UITableViewStylePlain];
    self.tableView.delegate       = self;
    self.tableView.dataSource     = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    [self.view addSubview:self.tableView];
    
    self.settingArr = @[@"修改备注",@"删除好友",@"举报"];
}

- (void)configUI
{
    
}

#pragma mark- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.settingArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.backgroundColor   = [UIColor lightGrayColor];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //标题label
    CustomLabel * titleLabel = [[CustomLabel alloc] initWithFontSize:16];
    titleLabel.frame         = CGRectMake(10, 10, 200, 40);
    titleLabel.textColor     = [UIColor blackColor];
    titleLabel.text          = self.settingArr[indexPath.row];
    [cell.contentView addSubview:titleLabel];
    
    return cell;
}
#pragma mark- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 1:
            {
                NSString * title = [NSString stringWithFormat:@"确认要删除%@吗？", self.deleteName];
                UIAlertView  * deleteAlert = [[UIAlertView alloc] initWithTitle:title message:@"TA将消失在你的好友列表" delegate:self cancelButtonTitle:StringCommonCancel otherButtonTitles:StringCommonConfirm, nil];
                [deleteAlert show];
            }
            break;
        case 0:
            {
                AddRemarkViewController * arVC = [[AddRemarkViewController alloc] init];
                arVC.frinedId                  = self.friendId;
                [self pushVC:arVC];
            }
        case 2:
            {
                ReportOffenceViewController * reportVC = [[ReportOffenceViewController alloc] init];
                reportVC.reportUid                     = self.friendId;
                [self pushVC:reportVC];

            }
            
        default:
            break;
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self deleteFriendCommit];
    }
    
}

#pragma mark- private method
//删除好友
- (void)deleteFriendCommit
{
    //kAddFriendPath
    NSDictionary * params = @{@"user_id":[NSString stringWithFormat:@"%ld", [UserService sharedService].user.uid],
                              @"friend_id":[NSString stringWithFormat:@"%ld", self.friendId]
                              };
    
    debugLog(@"%@ %@", kDeleteFriendPath, params);
    [self showLoading:@"删除中"];
    //添加好友
    [HttpService postWithUrlString:kDeleteFriendPath params:params andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        debugLog(@"%@", responseData);
        int status = [responseData[HttpStatus] intValue];
        
        if (status == HttpStatusCodeSuccess) {
            //删除成功
            [self showComplete:responseData[HttpMessage]];
            IMGroupModel * group = [[IMGroupModel alloc] init];
            //targetId
            group.groupId        = [ToolsManager getCommonGroupId:self.friendId];
            group.owner          = [UserService sharedService].user.uid;
            [group remove];
            //清除会话
            [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_PRIVATE targetId:group.groupId];
            
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
