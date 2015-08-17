//
//  ChatRoomDetailViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/9.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "ChatRoomDetailViewController.h"
#import "ChatRoomPersonalModel.h"
#import "UIImageView+WebCache.h"
#import "OtherPersonalViewController.h"
#import "ChatRoomMemberCell.h"
#import "ChatRoomChatController.h"

enum{
    //自己离开
    LeaverSelf  = 1,
    //踢出别人
    LeaverOther = 2
};

@interface ChatRoomDetailViewController ()

//集合视图
@property (nonatomic, strong) UICollectionView * collectionView;
//数据源
@property (nonatomic, strong) NSMutableArray * dataSource;
//当前人数
@property (nonatomic, strong) CustomLabel * numLabel;
//标志label数组
@property (nonatomic, strong) NSMutableArray * tagLabelArr;
//当前状态 是不是删除模式
@property (nonatomic, assign) BOOL isDeleteMode;
//要踢的人
@property (nonatomic, strong) ChatRoomPersonalModel * kickMemberModel;

//当前提醒状态
@property (nonatomic, assign) NSInteger currentNotifyStatus;

@end

@implementation ChatRoomDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navBar setNavTitle:self.chatRoomModel.chatroom_title];
    self.tagLabelArr = [[NSMutableArray alloc] init];
    self.dataSource = [[NSMutableArray alloc] init];
    
    [self initCollection];
    [self getData];
    
    
    //获取提醒状态
    [[RCIMClient sharedRCIMClient] getConversationNotificationStatus:ConversationType_GROUP targetId:[ToolsManager getChatroomIMId:self.chatRoomModel.cid] success:^(RCConversationNotificationStatus nStatus) {
        self.currentNotifyStatus = nStatus;
        
        __weak typeof(self) sself = self;
        NSString * disturbTitle = self.currentNotifyStatus == DO_NOT_DISTURB? @"不屏蔽" : @"屏蔽";
        
        [self.navBar setRightBtnWithContent:disturbTitle andBlock:^{
            
            //设置屏蔽
            dispatch_async(dispatch_get_main_queue(), ^{
                [sself showLoading:@"处理中"];
            });
            
            NSString * targetId = [ToolsManager getChatroomIMId:sself.chatRoomModel.cid];
            BOOL isblock = sself.currentNotifyStatus;
            
            [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_GROUP targetId:targetId isBlocked:isblock success:^(RCConversationNotificationStatus nStatus) {
                sself.currentNotifyStatus = nStatus;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [sself showComplete:@"设置成功"];
                    [sself.navBar.rightBtn setTitle:self.currentNotifyStatus == DO_NOT_DISTURB? @"不屏蔽" : @"屏蔽" forState:UIControlStateNormal];
                });
            } error:^(RCErrorCode status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [sself showWarn:@"设置失败"];
                });
            }];

        }];
    } error:^(RCErrorCode status) {
        
    }];
//    [[RCIMClient sharedRCIMClient] getConversationNotificationStatus:ConversationType_GROUP targetId:[ToolsManager getChatroomIMId:self.chatRoomModel.cid] completion:^(RCConversationNotificationStatus nStatus) {
//        
//        self.currentNotifyStatus = nStatus;
//        
//        __weak typeof(self) sself = self;
//        NSString * disturbTitle = self.currentNotifyStatus == DO_NOT_DISTURB? @"不屏蔽" : @"屏蔽";
//        
//        [self.navBar setRightBtnWithContent:disturbTitle andBlock:^{
//            
//            //设置屏蔽
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [sself showLoading:@"处理中"];
//            });
//            
//            NSString * targetId = [ToolsManager getChatroomIMId:sself.chatRoomModel.cid];
//            BOOL isblock = sself.currentNotifyStatus;
//            
//            [[RCIMClient sharedClient] setConversationNotificationStatus:ConversationType_GROUP targetId:targetId isBlocked:isblock completion:^(RCConversationNotificationStatus nStatus) {
//                sself.currentNotifyStatus = nStatus;
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [sself showComplete:@"设置成功"];
//                    [sself.navBar.rightBtn setTitle:self.currentNotifyStatus == DO_NOT_DISTURB? @"不屏蔽" : @"屏蔽" forState:UIControlStateNormal];
//                });
//                
//            } error:^(RCErrorCode status) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [sself showWarn:@"设置失败"];
//                });
//            }];
//            
//        }];
//        
//    } error:^(RCErrorCode status) {
//        
//    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark- layout
#define CellIdetifier @"collectCell"
//初始化 集合视图
- (void)initCollection
{
    UICollectionViewFlowLayout * collectLayout = [[UICollectionViewFlowLayout alloc] init];
    collectLayout.itemSize                     = CGSizeMake(130, 60);
    collectLayout.minimumInteritemSpacing      = 15;
    collectLayout.minimumLineSpacing           = 20;
    collectLayout.sectionInset                 = UIEdgeInsetsMake(15, 15, 5, 15);
    
    self.collectionView                 = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusHeight, self.viewWidth, self.viewHeight-kNavBarAndStatusHeight) collectionViewLayout:collectLayout];
    self.collectionView.backgroundColor = [UIColor grayColor];
    self.collectionView.delegate        = self;
    self.collectionView.dataSource      = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[ChatRoomMemberCell class] forCellWithReuseIdentifier:CellIdetifier];
    //注册头部view
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
    
    //当前人数label
    self.numLabel          = [[CustomLabel alloc] initWithFontSize:15];
}

#pragma mark- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChatRoomMemberCell * cell     = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdetifier forIndexPath:indexPath];
    ChatRoomPersonalModel * model   = self.dataSource[indexPath.row];
    [cell setContentWithModel:model];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView * crv  = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head" forIndexPath:indexPath];
    crv.backgroundColor             = [UIColor grayColor];
    
    //背景图
    CustomImageView * backImageView = [[CustomImageView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 100)];
    NSURL * url = [NSURL URLWithString:[ToolsManager completeUrlStr:self.chatRoomModel.chatroom_background]];
    [backImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"testimage"]];
    [crv addSubview:backImageView];
    
    //加入按钮
    CustomButton * joinBtn          = [[CustomButton alloc] initWithFrame:CGRectMake(kCenterOriginX(300), backImageView.bottom+5, 300, 20)];
    if (self.hasJoin) {
        [joinBtn setTitle:@"退出聊天室" forState:UIControlStateNormal];
        joinBtn.backgroundColor = [UIColor redColor];
        [joinBtn addTarget:self action:@selector(leaveClick:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [joinBtn setTitle:@"加入一起嗨" forState:UIControlStateNormal];
        [joinBtn addTarget:self action:@selector(joinClick:) forControlEvents:UIControlEventTouchUpInside];
    }

    [crv addSubview:joinBtn];
    
    //人数
    self.numLabel.frame                  = CGRectMake(0, joinBtn.bottom+5, self.viewWidth, 20);
    self.numLabel.backgroundColor        = [UIColor darkGrayColor];
    self.numLabel.textColor              = [UIColor blackColor];
    self.numLabel.text                   = [NSString stringWithFormat:@"           %ld个小伙伴正在聊天", self.chatRoomModel.current_quantity];
    [crv addSubview:self.numLabel];
    //标签
    //增加新label
    for (int i=0; i<self.chatRoomModel.tagArr.count; i++) {
        NSString * tagStr = self.chatRoomModel.tagArr[i];
        //标签
        CustomLabel * tagLabel          = [[CustomLabel alloc] initWithFontSize:FONT_SIZE_TAG];
        tagLabel.userInteractionEnabled = YES;
        tagLabel.backgroundColor        = [UIColor darkGrayColor];
        tagLabel.textColor              = [UIColor blackColor];
        tagLabel.text                   = tagStr;
        
        //设置位置
        CGSize size = [ToolsManager getSizeWithContent:tagLabel.text andFontSize:FONT_SIZE_TAG andFrame:CGRectMake(0, 0, 100, 20)];
        if (i == 0) {
            tagLabel.frame = CGRectMake(5, backImageView.height-30, size.width, 20);
        }else{
            CustomLabel * previousLabel = self.tagLabelArr[i-1];
            tagLabel.frame = CGRectMake(previousLabel.right+5, previousLabel.y, size.width, 20);
        }
        [backImageView addSubview:tagLabel];
        [self.tagLabelArr addObject:tagLabel];
    }
    
    return crv;
}

#pragma mark- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChatRoomPersonalModel * model      = self.dataSource[indexPath.row];
    //点击删除按钮
    if (model.isDeleteCell) {
        ChatRoomMemberCell * cell = (ChatRoomMemberCell *)[collectionView cellForItemAtIndexPath:indexPath];
        //删除状态
        self.isDeleteMode = !self.isDeleteMode;
        [cell setIsDelete:self.isDeleteMode];
        
        NSNumber * state = [NSNumber numberWithBool:self.isDeleteMode];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_DELETE_MEMBER object:state];
        
        return;
    }
    
    //删除状态
    if (self.isDeleteMode) {
        
        //点击的人
        self.kickMemberModel = model;
        
        if (self.chatRoomModel.user_id == model.uid) {
            [self showWarn:@"群主不能退出自己的群！！！"];
            return;
        }
        
        NSString * message = [NSString stringWithFormat:@"你真的要踢出%@吗？", model.name];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:StringCommonPrompt message:message delegate:self cancelButtonTitle:StringCommonCancel otherButtonTitles:StringCommonConfirm, nil];
        alert.tag           = LeaverOther;
        [alert show];
        
    }else{
        OtherPersonalViewController * opvc = [[OtherPersonalViewController alloc] init];
        opvc.uid                           = model.uid;
        [self pushVC:opvc];
    }
    
}

#pragma mark- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{

    return CGSizeMake([DeviceManager getDeviceWidth], 150);
}

#pragma mark- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == LeaverSelf) {
        if (buttonIndex == 1) {
            [self leaveChatroomWithKickId:[UserService sharedService].user.uid];
        }
    }
    
    if (alertView.tag == LeaverOther) {
        if (buttonIndex == 1) {
            [self leaveChatroomWithKickId:self.kickMemberModel.uid];
        }
    }
    
}

#pragma mark- method response
- (void)joinClick:(id)sender
{
    //kJoinChatRoomPath
    NSDictionary * params = @{@"user_id":[NSString stringWithFormat:@"%ld", [UserService sharedService].user.uid],
                              @"user_name":[UserService sharedService].user.name,
                              @"chatroom_id":[NSString stringWithFormat:@"%ld", self.chatRoomModel.cid]};
    
    debugLog(@"%@ %@", kJoinChatRoomPath, params);
    [self showLoading:@"添加中^_^"];
    //添加好友
    [HttpService postWithUrlString:kJoinChatRoomPath params:params andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        debugLog(@"%@", responseData);
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            //添加成功
            [self showComplete:responseData[HttpMessage]];
            
            //进入页面
            ChatRoomChatController *conversationVC = [[ChatRoomChatController alloc]init];
            conversationVC.conversationType        = ConversationType_GROUP;
            conversationVC.targetId                = [ToolsManager getChatroomIMId:self.chatRoomModel.cid];
            conversationVC.userName              = self.chatRoomModel.chatroom_title;
            [self.navigationController pushViewController:conversationVC animated:YES];
            
        }else{
            [self showWarn:responseData[HttpMessage]];
        }
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showWarn:StringCommonNetException];
    }];
}

- (void)leaveClick:(id)sender
{
    if (self.chatRoomModel.user_id == [UserService sharedService].user.uid) {
        [self showWarn:@"群主不能退出自己的群！！！"];
        return;
    }
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:StringCommonPrompt message:@"你真的决定头也不回的退出么？" delegate:self cancelButtonTitle:StringCommonCancel otherButtonTitles:StringCommonConfirm, nil];
    alert.tag           = LeaverSelf;
    [alert show];
    
}

//要踢的人
- (void)leaveChatroomWithKickId:(NSInteger)kickId
{
    
    //kJoinChatRoomPath
    NSDictionary * params = @{@"user_id":[NSString stringWithFormat:@"%ld", [UserService sharedService].user.uid],
                              @"kick_id":[NSString stringWithFormat:@"%ld", kickId],
                              @"chatroom_id":[NSString stringWithFormat:@"%ld", self.chatRoomModel.cid]};
    
    debugLog(@"%@ %@", kLeaveChatRoomPath, params);
    //自己退出
    if ([UserService sharedService].user.uid == kickId) {
        [self showLoading:@"退出中"];
    }else{
        //踢出中
        [self showLoading:@"踢出中"];
    }

    //添加好友
    [HttpService postWithUrlString:kLeaveChatRoomPath params:params andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        debugLog(@"%@", responseData);
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            //添加成功
            [self showComplete:responseData[HttpMessage]];
            
            if (self.isDeleteMode) {
                //被提出
                [self.dataSource removeObject:self.kickMemberModel];
                [self.collectionView reloadData];
                self.kickMemberModel = nil;
                
            }else{
                
                //如果是自己退出的 发送通知
                if (kickId == [UserService sharedService].user.uid) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_QUIT_CHATROOM object:[ToolsManager getChatroomIMId:self.chatRoomModel.cid]];
                }
                
                //自己退出
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        }else{
            [self showWarn:responseData[HttpMessage]];
        }
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showWarn:StringCommonNetException];
    }];
}

#pragma mark- private method
- (void)getData
{
    
    NSString * path = [NSString stringWithFormat:@"%@?chatroom_id=%ld", kChatRoomDetailPath, self.chatRoomModel.cid];
    debugLog(@"%@", path);
    //详情获取
    [HttpService getWithUrlString:path andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        int status = [responseData[HttpStatus] intValue];
        debugLog(@"%@", responseData);
        if (status == HttpStatusCodeSuccess) {
            
            //聊天室详情
            NSDictionary * roomDic   = responseData[HttpResult][@"info"];
            self.chatRoomModel.chatroom_title       = roomDic[@"chatroom_title"];
            self.chatRoomModel.chatroom_background  = roomDic[@"chatroom_background"];
            self.chatRoomModel.max_quantity         = [roomDic[@"max_quantity"] integerValue];
            self.chatRoomModel.chatroom_create_time = roomDic[@"chatroom_create_time"];
            self.chatRoomModel.cid                  = [roomDic[@"id"] integerValue];
            self.chatRoomModel.chatroom_duration    = roomDic[@"chatroom_duration"];
            self.chatRoomModel.user_id              = [roomDic[@"user_id"] integerValue];
            //标签
            [self.chatRoomModel.tagArr removeAllObjects];
            for (NSDictionary * tagDic in roomDic[@"tags"]) {
                [self.chatRoomModel.tagArr addObject:tagDic[@"tag_content"]];
            }

            //成员
            for (NSDictionary * memberDic in responseData[HttpResult][HttpList]) {
                ChatRoomPersonalModel * crm = [[ChatRoomPersonalModel alloc] init];
                crm.name                    = memberDic[@"name"];
                crm.head_sub_image          = memberDic[@"head_sub_image"];
                crm.school                  = memberDic[@"school"];
                crm.uid                     = [memberDic[@"uid"] integerValue];
                //如果自己加入了
                if (crm.uid == [UserService sharedService].user.uid) {
                    self.hasJoin = YES;
                }
                [self.dataSource addObject:crm];
            }
            
            //群主可以删人
            if (self.chatRoomModel.user_id == [UserService sharedService].user.uid) {
                ChatRoomPersonalModel * crm = [[ChatRoomPersonalModel alloc] init];
                crm.isDeleteCell = YES;
                [self.dataSource addObject:crm];
            }
            
            self.chatRoomModel.current_quantity = [responseData[HttpResult][HttpList] count];
            
        }else{
            
        }
        
        [self.collectionView reloadData];
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        
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
