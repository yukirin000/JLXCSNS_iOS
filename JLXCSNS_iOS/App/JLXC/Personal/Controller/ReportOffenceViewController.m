//
//  ReportOffenceViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/29.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "ReportOffenceViewController.h"

@interface ReportOffenceViewController ()

@property (nonatomic, strong) PlaceHolderTextView * placeHolderTextView;

@property (nonatomic, strong) CustomButton * confirmBtn;

@end

@implementation ReportOffenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self initWidget];
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- layout
- (void)initWidget
{
    self.placeHolderTextView = [[PlaceHolderTextView alloc] initWithFrame:CGRectMake(kCenterOriginX(300), kNavBarAndStatusHeight+40, 300, 150) andPlaceHolder:@"请输入愤怒的举报内容！"];
    self.confirmBtn          = [[CustomButton alloc] init];
    
    
    [self.view addSubview:self.placeHolderTextView];
    [self.view addSubview:self.confirmBtn];
    
}

- (void)configUI
{

    self.placeHolderTextView.delegate = self;
    self.confirmBtn.frame             = CGRectMake(kCenterOriginX(100), self.placeHolderTextView.bottom+30, 100, 30);
    self.confirmBtn.backgroundColor   = [UIColor darkGrayColor];
    
    [self.confirmBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.confirmBtn addTarget:self action:@selector(confirmReport:) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark- override
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.placeHolderTextView resignFirstResponder];
}

#pragma mark- placeHolder 使用该控件时需要加上这个代理方法
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
- (void)confirmReport:(id)sender
{
    [self uploadReport];
}

#pragma mark- private method
- (void)uploadReport
{
    NSString * report = self.placeHolderTextView.text;
    
    NSDictionary * params = @{@"uid":[NSString stringWithFormat:@"%ld", [UserService sharedService].user.uid],
                              @"report_uid":[NSString stringWithFormat:@"%ld", self.reportUid],
                              @"report_content":report};
    
    [self showLoading:@"举报中..."];
    
    [HttpService postWithUrlString:kReportOffencePath params:params andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {

        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            [self showComplete:responseData[HttpMessage]];
            [self.navigationController popViewControllerAnimated:YES];
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