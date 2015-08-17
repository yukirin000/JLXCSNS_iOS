//
//  AddRemarkViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/31.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "AddRemarkViewController.h"
#import "IMGroupModel.h"
@interface AddRemarkViewController ()

@property (nonatomic, strong) CustomTextField * remarkTextFiled;
//当前好友组
@property (nonatomic, strong) IMGroupModel * group;

@end

@implementation AddRemarkViewController
{
    RemarkBlock _changeBlock;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createWidget];
    
    [self configUI];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- layout
- (void)createWidget
{
    self.remarkTextFiled             = [[CustomTextField alloc] init];
    self.remarkTextFiled.borderStyle = UITextBorderStyleRoundedRect;
    self.remarkTextFiled.placeholder = @"请输入备注";
    [self.view addSubview:self.remarkTextFiled];
}

- (void)configUI
{
    __weak typeof(self) sself = self;
    [self.navBar setRightBtnWithContent:StringCommonSave andBlock:^{       
        [sself addRemark];
        
    }];
    
    self.remarkTextFiled.frame = CGRectMake(kCenterOriginX(300), kNavBarAndStatusHeight+20, 300, 30);
    //设置备注
    self.group = [IMGroupModel findByGroupId:[ToolsManager getCommonGroupId:self.frinedId]];
    if (self.group.groupRemark != nil && self.group.groupRemark.length > 0) {
        self.remarkTextFiled.text = self.group.groupRemark;
    }
    
}

#pragma mark- private method
- (void)setChangeBlock:(RemarkBlock)block
{
    _changeBlock = [block copy];
}

//增加备注确定
- (void)addRemark
{
//    if (self.remarkTextFiled.text.length < 1) {
//        ALERT_SHOW(StringCommonPrompt, @"备注不能为空=_=");
//        return;
//    }
    
    NSString * remark = [self.remarkTextFiled.text trim];
    
    NSDictionary * params = @{@"user_id":[NSString stringWithFormat:@"%ld", [UserService sharedService].user.uid],
                              @"friend_id":[NSString stringWithFormat:@"%ld", self.frinedId],
                              @"friend_remark":remark};
    
    [HttpService postWithUrlString:kAddRemarkPath params:params andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        debugLog(@"%@", responseData);
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            

            self.group.groupRemark = remark;
            [self.group update];

            //刷新备注
            RCUserInfo * usr = [[RCUserInfo alloc] initWithUserId:self.group.groupId name:self.group.groupTitle portrait:[ToolsManager completeUrlStr:self.group.avatarPath]];
            [[RCIM sharedRCIM] refreshUserInfoCache:usr withUserId:self.group.groupId];
            
            [self showComplete:responseData[HttpMessage]];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showWarn:responseData[HttpMessage]];
        }
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
}

#pragma mark- override
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.remarkTextFiled resignFirstResponder];
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
