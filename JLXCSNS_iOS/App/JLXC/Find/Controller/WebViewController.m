//
//  WebViewController.m
//  EwChat
//
//  Created by EnwaySoft on 14-7-3.
//  Copyright (c) 2014年 老邢Thierry. All rights reserved.
//

#import "WebViewController.h"
@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _zWebView                = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.navBar.frame.size.height, self.view.frame.size.width, (self.view.frame.size.height-self.navBar.frame.size.height))];
    _zWebView.delegate       = self;
    [_zWebView scalesPageToFit];
    [self.view addSubview:_zWebView];

    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:_webURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    [_zWebView loadRequest:urlRequest];

    [self.navBar setNavTitle:self.topTitle];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //获取所加载网页的title
    NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self.navBar setNavTitle:theTitle];
    
    if ([theTitle length] < 1) {
        [self.navBar setNavTitle:self.topTitle];
    }
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"error : %@",error.description);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
