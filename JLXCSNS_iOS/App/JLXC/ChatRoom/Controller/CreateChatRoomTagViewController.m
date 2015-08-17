//
//  CreateChatRoomTagViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/11.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "CreateChatRoomTagViewController.h"
#import "SDWebImageManager.h"
@interface CreateChatRoomTagViewController ()

//背景图片
@property (nonatomic, strong) CustomImageView * backImageView;
//标题
@property (nonatomic, strong) CustomLabel * titleLabel;
//标签tv
@property (nonatomic, strong) UITextField * labelTextField;
//点击标签按钮
@property (nonatomic, strong) CustomButton * addLabelBtn;
//标签数组
@property (nonatomic, strong) NSMutableArray * tagArr;

@end

@implementation CreateChatRoomTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tagArr = [[NSMutableArray alloc] init];
    
    [self createWidget];
    [self configUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.titleLabel.text               = self.roomTitle;
    if (self.image != nil) {
        [self.backImageView setImage:self.image];
    }else{
        [self.backImageView setImage:[UIImage imageNamed:@"testimage"]];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- layout
- (void)createWidget
{
    self.backImageView  = [[CustomImageView alloc] init];
    self.titleLabel     = [[CustomLabel alloc] init];
    self.labelTextField = [[UITextField alloc] init];
    self.addLabelBtn    = [[CustomButton alloc] initWithFontSize:15];
    
    [self.view addSubview:self.backImageView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.labelTextField];
    [self.view addSubview:self.addLabelBtn];
}

- (void)configUI
{
    
    self.backImageView.frame                  = CGRectMake(10, kNavBarAndStatusHeight+10, self.viewWidth-20, 100);
    self.backImageView.backgroundColor        = [UIColor grayColor];
    self.backImageView.userInteractionEnabled = YES;

    self.titleLabel.frame                     = CGRectMake(kCenterOriginX(260), self.backImageView.y+30, 260, 30);
    //添加标签部分
    self.labelTextField.frame                 = CGRectMake(kCenterOriginX(260), self.backImageView.bottom+15, 200, 30);
    self.labelTextField.placeholder           = @"添加标签";
    self.labelTextField.borderStyle           = UITextBorderStyleRoundedRect;

    self.addLabelBtn.frame                    = CGRectMake(self.labelTextField.right+10, self.labelTextField.y, 50, 20);
    [self.addLabelBtn addTarget:self action:@selector(addLabelClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.addLabelBtn setTitle:@"添加" forState:UIControlStateNormal];
    [self.addLabelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

    __weak typeof(self) sself = self;
    //设置完成按钮
    [self.navBar setRightBtnWithContent:StringCommonFinish andBlock:^{
        [sself finishChatRoom];
    }];
    
}

#pragma mark- UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark- method response
//完成聊天室的添加
- (void)finishChatRoom
{
    //tag用json格式发送
    NSMutableArray * tagArr = [[NSMutableArray alloc] init];
    for (CustomLabel *tagLabel in self.tagArr) {
        [tagArr addObject:tagLabel.text];
    }
    
    NSData * tagsData =[NSJSONSerialization dataWithJSONObject:tagArr options:NSJSONWritingPrettyPrinted error:nil];
    NSDictionary * params = @{@"user_id":[NSString stringWithFormat:@"%ld", [UserService sharedService].user.uid],
                              @"user_name":[UserService sharedService].user.name,
                              @"chatroom_title":self.roomTitle,
                              @"tags":[[NSString alloc] initWithData:tagsData encoding:NSUTF8StringEncoding]};
    NSArray * files;
    //头像处理
    if (self.image != nil) {
        NSString * fileName = [ToolsManager getUploadImageName];
//        files = @[@{FileDataKey:UIImagePNGRepresentation(self.image),FileNameKey:fileName}];
        files = @[@{FileDataKey:UIImageJPEGRepresentation(self.image,1.0),FileNameKey:fileName}];
        
    }

    debugLog(@"%@", kCreateChatRoomPath);
    [self showLoading:nil];
    [HttpService postFileWithUrlString:kCreateChatRoomPath params:params files:files andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        debugLog(@"%@", responseData);
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            [self showComplete:responseData[HttpMessage]];
            NSURL * url = [NSURL URLWithString:[ToolsManager completeUrlStr:responseData[HttpResult][@"image_path"]]];
            //缓存背景图
            [[SDWebImageManager sharedManager] saveImageToCache:self.image forURL:url];
            [self popToTabBarViewController];
            //发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CREATE_CHATROOM object:nil];
            //聊天id
//            NSString * chatroomId = responseData[HttpResult][@"chatroom_id"];
//            debugLog(@"%@", [ToolsManager getChatroomIMId:chatroomId.integerValue]);
            
        }else{
            
            [self showWarn:responseData[HttpMessage]];
        }
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showWarn:StringCommonNetException];
    }];
}

//添加标签
- (void)addLabelClick:(id)sender
{
    if (self.labelTextField.text.length < 1) {
        ALERT_SHOW(StringCommonPrompt, @"标签不能为空╮(╯_╰)╭");
        return;
    }
    
    if (self.labelTextField.text.length > 7) {
        ALERT_SHOW(StringCommonPrompt, @"标签不能超过七个字╮(╯_╰)╭");
        return;
    }
    
    if (self.tagArr.count >= 3) {
        ALERT_SHOW(StringCommonPrompt, @"标签不能超过三个╮(╯_╰)╭");
        self.labelTextField.text = @"";
        return;
    }
    
    //标签
    CustomLabel * tagLabel          = [[CustomLabel alloc] initWithFontSize:FONT_SIZE_TAG];
    tagLabel.userInteractionEnabled = YES;
    tagLabel.backgroundColor        = [UIColor darkGrayColor];
    tagLabel.textColor              = [UIColor blackColor];
    tagLabel.text                   = self.labelTextField.text;
    
    //设置位置
    CGSize size = [ToolsManager getSizeWithContent:tagLabel.text andFontSize:FONT_SIZE_TAG andFrame:CGRectMake(0, 0, 100, 20)];
    CGRect rect;
    if (self.tagArr.count > 0) {
        CustomLabel * label = self.tagArr.lastObject;
        rect = CGRectMake(label.right+5, label.y, size.width, 20);
    }else{
        rect = CGRectMake(5, self.backImageView.height-30, size.width, 20);
    }
    
    tagLabel.frame         = rect;
    [self.backImageView addSubview:tagLabel];
    [self.tagArr addObject:tagLabel];
    
    //点击取消标签手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelTag:)];
    [tagLabel addGestureRecognizer:tap];
    self.labelTextField.text = @"";
    [self.labelTextField resignFirstResponder];
}
//删除标签
- (void)cancelTag:(UITapGestureRecognizer *)tap
{
    //删除该标签
    CustomLabel * tagLabel = (CustomLabel *)tap.view;
    [self.tagArr removeObject:tagLabel];
    [tagLabel removeFromSuperview];
    
    //重新布局
    for (int i=0; i<self.tagArr.count; i++) {
        CustomLabel * label = self.tagArr[i];
        if (i == 0) {
            label.frame = CGRectMake(5, self.backImageView.height-30, label.width, 20);
            continue;
        }else{
            CustomLabel * previousLabel = self.tagArr[i-1];
            label.frame = CGRectMake(previousLabel.right+5, previousLabel.y, label.width, 20);
        }
    }
    
}

#pragma mark- override
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.labelTextField resignFirstResponder];
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
