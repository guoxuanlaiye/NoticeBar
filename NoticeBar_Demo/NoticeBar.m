//
//  NoticeBar.m
//  NoticeBar_Demo
//
//  Created by yingcan on 17/2/24.
//  Copyright © 2017年 guoxuan. All rights reserved.
//

#import "NoticeBar.h"

#define NEWS_WIDTH  (self.frame.size.width-40)
#define NEWS_HEIGHT (self.frame.size.height)

@interface NoticeBar ()<UIScrollViewDelegate>
@property (nonatomic, strong) NSTimer *timer;  //定时器用于滚动轮播图

@property (nonatomic, assign) NSInteger currenPage;
@property (nonatomic, strong) UIScrollView * newsScrollView;

@property (nonatomic, strong) UIButton * upButton;
@property (nonatomic, strong) UIButton * curButton;
@property (nonatomic, strong) UIButton * downButton;

@property (nonatomic, strong) UIColor * titleColor;
@property (nonatomic, strong) UIFont * titleFont;
@end

@implementation NoticeBar
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self initialize];
        [self setupNewsView];
    }
    return self;
}
- (void)initialize {
    _titleColor = [UIColor blackColor];
    _titleFont  = [UIFont systemFontOfSize:14.0];
}
//设置基础界面
- (void)setupNewsView {
    
    self.backgroundColor = [UIColor whiteColor];
    UIImageView * noticeIcon = [[UIImageView alloc]init];
    noticeIcon.frame = CGRectMake(10.0, 11.0, 18.0, 18.0);
    noticeIcon.image   = [UIImage imageNamed:@"laba"];
    [self addSubview:noticeIcon];
    
    _newsScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(40, 0, NEWS_WIDTH, NEWS_HEIGHT)];
    _newsScrollView.contentSize   = CGSizeMake(NEWS_WIDTH, NEWS_HEIGHT * 3);
    _newsScrollView.contentOffset = CGPointMake(0, NEWS_HEIGHT);
    _newsScrollView.delegate      = self;
    _newsScrollView.scrollEnabled = NO;
    //实际上就是三个button上下来回滚😎
    UIButton * upButton = [UIButton buttonWithType:UIButtonTypeCustom];
    upButton.frame      = CGRectMake(0, 0, _newsScrollView.frame.size.width, _newsScrollView.frame.size.height);
    [upButton setTitleColor:_titleColor forState:UIControlStateNormal];
    upButton.titleLabel.font   = _titleFont;
    [upButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    self.upButton = upButton;
    [_newsScrollView addSubview:upButton];
    
    UIButton * curButton = [UIButton buttonWithType:UIButtonTypeCustom];
    curButton.frame      = CGRectMake(0, _newsScrollView.frame.size.height, _newsScrollView.frame.size.width, _newsScrollView.frame.size.height);
    [curButton setTitleColor:_titleColor forState:UIControlStateNormal];
    curButton.titleLabel.font  = _titleFont;
    [curButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [curButton addTarget:self action:@selector(currenButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    self.curButton = curButton;
    [_newsScrollView addSubview:curButton];
    
    UIButton * downButton = [UIButton buttonWithType:UIButtonTypeCustom];
    downButton.frame      = CGRectMake(0, _newsScrollView.frame.size.height * 2, _newsScrollView.frame.size.width, _newsScrollView.frame.size.height);
    [downButton setTitleColor:_titleColor forState:UIControlStateNormal];
    downButton.titleLabel.font = _titleFont;
    [downButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    self.downButton = downButton;
    [_newsScrollView addSubview:downButton];
    
    [self addSubview:_newsScrollView];
    
}
- (void)currenButtonDidClick:(UIButton *)button {
    
    if (_noticeButtonClickBlock && _noticeData.count > 0) {
        NSDictionary * dict = _noticeData[self.currenPage];
        _noticeButtonClickBlock(dict[@"linkUrl"]);
    }
}
//设置数据源
- (void)setNoticeData:(NSArray *)noticeData {
    
    _noticeData     = noticeData;
    self.currenPage = 0;
    [self updateNewsView];
    [self fireTimer];

}

//更新当前内容
- (void)updateNewsView {
    
    [self.newsScrollView setContentOffset:CGPointMake(0, NEWS_HEIGHT)];
    NSInteger pageCount = _noticeData.count;
    
    NSInteger upIndex   = (self.currenPage > 0) ? (self.currenPage - 1) : (pageCount - 1);
    NSInteger downIndex = (self.currenPage < pageCount - 1) ? (self.currenPage + 1) : 0;
    
    NSDictionary *upDic    = _noticeData[upIndex];
    NSDictionary *curDic   = _noticeData[_currenPage];
    NSDictionary *downDic  = _noticeData[downIndex];
    
    [self.upButton   setTitle:upDic[@"title"] forState:UIControlStateNormal];
    [self.curButton  setTitle:curDic[@"title"] forState:UIControlStateNormal];
    [self.downButton setTitle:downDic[@"title"] forState:UIControlStateNormal];
}
//更新当前页数
-(void)updateCurrentPageWithDirector:(BOOL)isDown{
    
    NSInteger pageCount = _noticeData.count;
    if (pageCount == 0) {
        return;
    }
    if (isDown) {
        self.currenPage = self.currenPage > 0 ? (self.currenPage - 1) : (pageCount - 1);
    } else {
        self.currenPage = (self.currenPage + 1) % pageCount;
    }
}
#pragma mark UIScrollerViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:4.0]];
    if (scrollView.contentOffset.y == 0)
    {
        [self updateCurrentPageWithDirector:YES];
    }
    else if (scrollView.contentOffset.y > CGRectGetHeight(scrollView.frame))
    {
        [self updateCurrentPageWithDirector:NO];
        
    }else{
        return;
    }
    [self updateNewsView];
}
#pragma mark 定时器处理
- (void)dealloc
{
    [self invalidateTimer];
}
//取消定时器
-(void)invalidateTimer
{
    if (_timer && [_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}
//开启定时器
-(void)fireTimer{
    [self invalidateTimer];
    //
    if (_noticeData.count > 1) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(animalImage) userInfo:nil repeats:YES];
    }
}
//定时器自动轮播
-(void)animalImage{
    [UIView animateWithDuration:0.5 animations:^{
        [self.newsScrollView setContentOffset:CGPointMake(0, NEWS_HEIGHT * 2)];
        
    } completion:^(BOOL finished) {
        if (finished) {
            [self updateCurrentPageWithDirector:NO];
            [self updateNewsView];
        }
    }];
}


@end
