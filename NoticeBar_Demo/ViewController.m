//
//  ViewController.m
//  NoticeBar_Demo
//
//  Created by yingcan on 17/2/24.
//  Copyright © 2017年 guoxuan. All rights reserved.
//

#import "ViewController.h"
#import "NoticeBar.h"
#import "NoticeWebViewController.h"

@interface ViewController ()
@property (nonatomic, copy) NSArray * testNoticeArray;

@end

@implementation ViewController
- (NSArray *)testNoticeArray
{
    if (!_testNoticeArray) {
        _testNoticeArray = [NSArray arrayWithObjects:
                            @{@"title":@"大家注意:这是我的github！",@"linkUrl":@"https://github.com/guoxuanlaiye"},
                            @{@"title":@"国家把土地还给人民，你更买不起房子了",@"linkUrl":@"https://www.baidu.com"},
                            @{@"title":@"剁手剁手",@"linkUrl":@"https://www.taobao.com"},
                            @{@"title":@"你猜不猜",@"linkUrl":@"https://www.taobao.com"},
                            @{@"title":@"<三生三世十里桃花>的最大问题在于不会抄",@"linkUrl":@"https://www.baidu.com"},nil];
        
    }
    return _testNoticeArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    NoticeBar * noticeBar = [[NoticeBar alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 40)];
    [noticeBar setNoticeData:self.testNoticeArray];
    noticeBar.noticeButtonClickBlock = ^(NSString * linkUrl) {
        NSLog(@"点击了跳转链接 --%@\n",linkUrl);
        NoticeWebViewController * noticeWebVC = [[NoticeWebViewController alloc]init];
        noticeWebVC.linkUrl = linkUrl;
        [self.navigationController pushViewController:noticeWebVC animated:YES];
    };
    [self.view addSubview:noticeBar];
}

@end
