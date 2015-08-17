//
//  ChatViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/27.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "ChatViewController.h"
#import "NavBar.h"
#import "OtherPersonalViewController.h"
#import "IMGroupModel.h"

@interface ChatViewController ()

@property (nonatomic ,strong) NavBar * navBar;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavBar];
    
    [self initPlugin];
    
    [self getHeadAndName];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- layout
- (void)createNavBar
{

    self.navBar = [[NavBar alloc] init];
    [self.view addSubview:self.navBar];
    __weak typeof(self) sself = self;
    //返回按钮
    [self.navBar.leftBtn setImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
    if ([DeviceManager getDeviceSystem] >= 7.0) {
        [self.navBar setLeftBtnWithFrame:CGRectMake(10, 15, 40, 50) andContent:nil andBlock:^{
            [sself.navigationController popViewControllerAnimated:YES];
        }];
    }else{
        [self.navBar setLeftBtnWithFrame:CGRectMake(10, 0, 40, 50) andContent:nil  andBlock:^{
            [sself.navigationController popViewControllerAnimated:YES];
        }];
    }
    
}

- (void)initPlugin
{
//    [self.pluginBoardView.allItems removeObjectAtIndex:3];    
//    [self.pluginBoardView.allItems removeObjectAtIndex:2];

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

//- (void)notifyUpdateUnReadMessageCount
//{
//    
////    NSInteger count = [[RCIMClient sharedClient]getUnreadCount: @[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION), @(ConversationType_APPSERVICE), @(ConversationType_PUBLICSERVICE),@(ConversationType_GROUP)]];
//    
//    NSInteger count = [[RCIMClient sharedClient]getUnreadCount: @[@(ConversationType_PRIVATE)]];
//    debugLog(@"unread:%ld", count);
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//    });
//}

//- (void) presentImagePreviewController:(RCMessageModel*) model
//{
////    RCImageMessage * imageM = (RCImageMessage *)model.content;
////    imageM.imageUrl = @"http://rongcloud-image.ronghub.com/image%2Fjpeg%2FRC-0115-04-29_542_1432882072?e=2147483647&token=livk5rb3__JZjCtEiMxXpQ8QscLxbNLehwhHySnX:HaZJQMo5nvbDOqknuwO5A3M96_I=";
////    if (imageM.originalImage == nil) {
////        
////        imageM.originalImage = [UIImage imageNamed:@"testimage"];
//////        NSData * imageData = [[NSData alloc] initWithContentsOfFile:imageM.imageUrl];
//////
//////        UIImage * imm = [UIImage imageWithContentsOfFile:imageM.imageUrl];
//////        
//////        if (imageData) {
//////             imageM.originalImage = [UIImage imageWithData:imageData];
//////        }
////
////    }else{
////        imageM.imageUrl = @"http://rongcloud-image.ronghub.com/image%2Fjpeg%2FRC-0115-04-29_542_1432882072?e=2147483647&token=livk5rb3__JZjCtEiMxXpQ8QscLxbNLehwhHySnX:HaZJQMo5nvbDOqknuwO5A3M96_I=";
////        
////    }
//
//    [super presentImagePreviewController:model];
//
//}
//
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
    if (tag == PLUGIN_BOARD_ITEM_ALBUM_TAG) {
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

//更新名字和头像
- (void)getHeadAndName
{
    IMGroupModel * group = [IMGroupModel findByGroupId:self.targetId];
    
    if (group) {
        NSString * url = [NSString stringWithFormat:@"%@?user_id=%@",kGetImageAndNamePath, [group.groupId stringByReplacingOccurrencesOfString:JLXC withString:@""]];
        debugLog(@"%@", url);
        //获取图片 姓名
        [HttpService getWithUrlString:url andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
            
            int status = [responseData[HttpStatus] intValue];
            if (status == HttpStatusCodeSuccess) {
                NSDictionary * result = responseData[HttpResult];
                //保存组信息
                group.groupTitle = result[@"name"];
                group.avatarPath = result[@"head_image"];
                [group update];
                
            }
            
        } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {

        }];
    }
}

//
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/

@end
