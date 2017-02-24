//
//  NoticeWebViewController.m
//  NoticeBar_Demo
//
//  Created by yingcan on 17/2/24.
//  Copyright © 2017年 guoxuan. All rights reserved.
//

#import "NoticeWebViewController.h"
#import <WebKit/WebKit.h>
@interface NoticeWebViewController ()

@end

@implementation NoticeWebViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    WKWebView * webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_linkUrl]];
    [webView loadRequest:request];
    [self.view addSubview:webView];
}


@end
