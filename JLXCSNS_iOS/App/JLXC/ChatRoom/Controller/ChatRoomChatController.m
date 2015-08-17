//
//  ChatRoomChatController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/13.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "ChatRoomChatController.h"
#import "NavBar.h"
#import "OtherPersonalViewController.h"
#import "ChatRoomDetailViewController.h"

@interface ChatRoomChatController ()

@property (nonatomic ,strong) NavBar * navBar;

//剩余时间标签
@property (nonatomic, strong) CustomLabel * leftTimeLabel;
//剩余时间
@property (nonatomic, assign) NSInteger leftTimeInterval;
//计时器
@property (nonatomic, strong) NSTimer * leftTimer;

@end

@implementation ChatRoomChatController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavBar];
    
    [self configUI];
    
    [self registerNotify];
    //获取剩余时间
    [self getLeftTime];

}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self.leftTimer invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark- layout
- (void)configUI
{
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    //剩余时间标志
    self.leftTimeLabel                 = [[CustomLabel alloc] initWithFontSize:15];
    self.leftTimeLabel.alpha           = 0.5;
    self.leftTimeLabel.frame           = CGRectMake(0, self.navBar.bottom+10, [DeviceManager getDeviceWidth], 20);
    self.leftTimeLabel.backgroundColor = [UIColor darkGrayColor];
    self.leftTimeLabel.textColor       = [UIColor whiteColor];
    self.leftTimeLabel.textAlignment   = NSTextAlignmentCenter;
    [self.view addSubview:self.leftTimeLabel];
    
    __weak typeof(self) sself = self;
    //右上角点击看详情
    [self.navBar setRightBtnWithContent:@"详情" andBlock:^{
        ChatRoomDetailViewController * crdvc = [[ChatRoomDetailViewController alloc] init];
        ChatRoomModel * model                = [[ChatRoomModel alloc] init];
        model.cid                            = [[sself.targetId stringByReplacingOccurrencesOfString:JLXC_CHATROOM withString:@""] integerValue];
        model.chatroom_title                 = sself.userName;
        crdvc.chatRoomModel                  = model;
        [sself.navigationController pushViewController:crdvc animated:YES];
    }];
}

- (void)createNavBar
{
    
    self.navBar = [[NavBar alloc] init];
    [self.view addSubview:self.navBar];
    __weak typeof(self) sself = self;
    //返回按钮
    [self.navBar.leftBtn setImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
    if ([DeviceManager getDeviceSystem] >= 7.0) {
        [self.navBar setLeftBtnWithFrame:CGRectMake(10, 15, 40, 50) andContent:nil andBlock:^{
            
            [sself popVC];
        }];
    }else{
        [self.navBar setLeftBtnWithFrame:CGRectMake(10, 0, 40, 50) andContent:nil  andBlock:^{
            [sself popVC];
        }];
    }
    
}

- (void)presentImagePreviewController:(RCMessageModel *)model
{
    [super presentImagePreviewController:model];
    
}

#pragma mark- override
- (void)willDisplayConversationTableCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (void)didTapCellPortrait:(NSString *)userId
{
    OtherPersonalViewController * opvc = [[OtherPersonalViewController alloc] init];
    opvc.uid = [[userId stringByReplacingOccurrencesOfString:JLXC withString:@""] integerValue];
    [self.navigationController pushViewController:opvc animated:YES];
}

//- (void)didSendMessage:(NSInteger)stauts content:(RCMessageContent *)messageCotent
//{
//    if ([messageCotent isKindOfClass:[RCImageMessage class]]) {
//        RCImageMessage * imageMessage = (RCImageMessage *)messageCotent;
//        imageMessage.extra = imageMessage.imageUrl;
//    }
//    
//    debugLog(@"%@", messageCotent);
//    
//}

- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag
{
    if (tag == 0) {
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate                  = self;
        imagePicker.sourceType                = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
        return;
    }
    
    [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
}

#pragma mark- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    RCImageMessage * imageMessage = [RCImageMessage messageWithImage:info[UIImagePickerControllerOriginalImage]];
//    imageMessage.extra            = @"ccceee";
    [self sendImageMessage:imageMessage pushContent:nil];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- private method
- (void)getLeftTime
{
    
    NSString * url = [NSString stringWithFormat:@"%@?chatroom_id=%@", kGetChatRoomLeftTimePath, [self.targetId stringByReplacingOccurrencesOfString:JLXC_CHATROOM withString:@""]];
    debugLog(@"%@", url);
    [HttpService getWithUrlString:url andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        debugLog(@"%@", responseData);
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            //剩余时间
            self.leftTimeInterval = [responseData[HttpResult] integerValue];
            //到期了的话
            if (self.leftTimeInterval < 0) {
                ALERT_SHOW(@"=_=", @"到期了....");
                [self popVC];
                //删除这个聊天室
                [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_GROUP targetId:self.targetId];
                return ;
            }
            
            [self updateLeftTime];
            self.leftTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateLeftTime) userInfo:nil repeats:YES];
            
        }else{
            ALERT_SHOW(@"=_=", @"没这群....");
            [self popVC];
            //删除这个聊天室
            [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_GROUP targetId:self.targetId];
        }
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self getLeftTime];
    }];
}

//更新时间
- (void)updateLeftTime
{
    self.leftTimeInterval --;
    //到点了
    if (self.leftTimeInterval < 0) {
        ALERT_SHOW(@"=_=", @"到期了....");
        [self.navigationController popToRootViewControllerAnimated:YES];
        //删除这个聊天室
        [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_GROUP targetId:self.targetId];
        [self.leftTimer invalidate];
        return;
    }
    
    NSInteger hour = self.leftTimeInterval/3600;
    NSInteger minute = self.leftTimeInterval/60;
    NSString * timeTitle;
    if (hour > 0) {
        timeTitle = [NSString stringWithFormat:@"剩余%ld小时",hour];
        //当前时间
        self.leftTimeLabel.text = timeTitle;
    }else if (minute > 0) {
        timeTitle = [NSString stringWithFormat:@"剩余%ld分钟",minute];
        self.leftTimeLabel.text = timeTitle;
    }else{
        if (self.leftTimeInterval>0) {
            timeTitle = [NSString stringWithFormat:@"剩余%ld秒",self.leftTimeInterval];
        }else{
            timeTitle = @"聊天室已经到期辣~";
        }
        self.leftTimeLabel.text = timeTitle;
        
    }
}

//注册通知
- (void)registerNotify
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quitChatroom:) name:NOTIFY_QUIT_CHATROOM object:nil];
    
}
//新消息发布成功刷新页面
- (void)quitChatroom:(NSNotification *)notify
{
    //被踢出去的
    if ([notify.object hasPrefix:@"kick_"]) {
        NSString * targetId = [notify.object stringByReplacingOccurrencesOfString:@"kick_" withString:@""];
        if ([targetId isEqualToString:self.targetId]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                ALERT_SHOW(StringCommonPrompt, @"你已被踢出群T_T");
                [self popVC];
                [[NSNotificationCenter defaultCenter] removeObserver:self];
            });
        }
    }
    
}

- (void)popVC
{
    for (int i=0; i<[self.navigationController viewControllers].count; i++) {
        UIViewController *viewController = [[self.navigationController viewControllers] objectAtIndex:i];
        if ([NSStringFromClass([viewController class]) isEqual:@"ChatRoomDetailViewController"]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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
