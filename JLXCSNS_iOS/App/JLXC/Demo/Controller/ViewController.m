//
//  ViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/8.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "ViewController.h"
#import "HttpService.h"
#import "TestListViewController.h"
#import "CusTabBarViewController.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createWidget];
    [self configUI];

}

#pragma mark- layout
//创建控件
- (void) createWidget
{
    CustomButton * btn  = [[CustomButton alloc] init];
    btn.frame = CGRectMake(100, 200, 100, 100);
    btn.backgroundColor = [UIColor grayColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(testClick) forControlEvents:UIControlEventTouchUpInside];
    
//    [self showLoading:@"网络请求"];
//    debugLog(@"%@", kTestPath);
//    [HttpService getWithUrlString:@"https://www.baidu.com" andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
//        debugLog(@"%@", responseData);
//        debugLog(@"%@", [responseData class]);
//        [self hideLoading];
//    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
//        debugLog(@"%@", error.localizedDescription);
//        [self showWarn:error.localizedDescription];
//    }];
    
}
//编辑UI
- (void) configUI
{
    debugLog(@"%@", NSHomeDirectory());
    [self setNavBarTitle:@"测试标题"];
    
}

#pragma mark- UIScrollViewDelegate

#pragma mark- UITableViewDelegate

#pragma mark- event Response

- (void)testClick
{
//    ViewController * vc = [[ViewController alloc] init];
//    [self pushVC:vc];

    CusTabBarViewController * ctbvc = [[CusTabBarViewController alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:ctbvc];
    [self presentViewController:nav animated:YES completion:nil];
    
//    [self pushVC:ctbvc];
//    [self.navigationController pushViewController:ctbvc animated:YES];
    
//    NSData * data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ToastWarn@2x" ofType:@"png"]];
//    
//    [self showLoading:@"上传"];
//    debugLog(@"%@", kDownLoadPath);
//
//    [HttpService postFileWithUrlString:kDownLoadPath params:nil files:@[@{FileDataKey:data,FileNameKey:@"test.png"}] andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
//        debugLog(@"%@", responseData);
//        [self hideLoading];
//    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
//        debugLog(@"%@", error.localizedDescription);
//        [self showWarn:error.localizedDescription];
//    }];
    
    
}



#pragma mark- private methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
