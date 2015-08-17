//
//  SendCommentViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/16.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "SendCommentViewController.h"

@interface SendCommentViewController ()

@property (strong, nonatomic) PlaceHolderTextView *textView;

@end

@implementation SendCommentViewController
{
    CommentSuccessBlock _commentBlock;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWidget];
    [self configUI];
    
    //处理模态方式出现的控制器的 HUD问题
    [self initHUD];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- layout
- (void)initWidget
{
    self.textView          = [[PlaceHolderTextView alloc] init];
    self.textView.delegate = self;
    [self.view addSubview:self.textView];
}

- (void)configUI {
    
    self.view.backgroundColor = [UIColor grayColor];

    __weak typeof(self) sself = self;
    [self.navBar setRightBtnWithContent:@"发布" andBlock:^{
        [sself publishCommentClick];
    }];
    [self.navBar setLeftBtnWithContent:nil andBlock:^{
        [sself dismissViewControllerAnimated:YES completion:nil];
    }];
    self.textView.frame              = CGRectMake(24, 76, 272, 100);
    
}

- (void)initHUD
{
    self.hudProgress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hudProgress];
}

#pragma mark- UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView isKindOfClass:[PlaceHolderTextView class]]) {

        if (textView.text.length > 0) {
            [((PlaceHolderTextView *)textView) setPlaceHidden:YES];
        }else{
            [((PlaceHolderTextView *)textView) setPlaceHidden:NO];
        }
    }
}

#pragma mark- method response
- (void)publishCommentClick
{
    if (self.textView.text.length > 140) {
        ALERT_SHOW(StringCommonPrompt, @"内容不能超过140字");
        return;
    }
    
    if (self.textView.text.length < 1) {
        ALERT_SHOW(StringCommonPrompt, @"内容不能为空");
        return;
    }
    
    //[NSString stringWithFormat:@"%d", [UserService sharedService].user.uid]
    NSDictionary * params = @{@"user_id":[NSString stringWithFormat:@"%ld", [UserService sharedService].user.uid],
                              @"comment_content":self.textView.text,
                              @"is_second":@"0",
                              @"news_id":[NSString stringWithFormat:@"%ld", self.nid]};
    
    debugLog(@"%@ %@", kSendCommentPath, params);
    [self showLoading:@"评论中"];
    [HttpService postWithUrlString:kSendCommentPath params:params andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        debugLog(@"%@", responseData);
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            
            [self showComplete:@"评论成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });

        }else{
            
            [self showWarn:responseData[HttpMessage]];
        }
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showWarn:StringCommonNetException];
    }];
}

#pragma mark- private method
/*! 设置Block*/
- (void)setCommentSuccessBlock:(CommentSuccessBlock)block
{
    _commentBlock = [block copy];
}



#pragma mark- override
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self.textView resignFirstResponder];
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
