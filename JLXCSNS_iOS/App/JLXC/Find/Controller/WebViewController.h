//
//  WebViewController.h
//  EwChat
//
//  Created by EnwaySoft on 14-7-3.
//  Copyright (c) 2014年 老邢Thierry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
/*!
    WebView封装
 */
@interface WebViewController : BaseViewController<UIWebViewDelegate>
{
    UIWebView *_zWebView; 
}

@property NSURL *webURL;

@property (nonatomic, copy) NSString * topTitle;

@end
