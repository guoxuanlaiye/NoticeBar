//
//  NoticeBar.h
//  NoticeBar_Demo
//
//  Created by yingcan on 17/2/24.
//  Copyright © 2017年 guoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeBar : UIView
@property (nonatomic, copy) NSArray * noticeData;
//这里可以根据需求回调不同类型的数据

//@property (nonatomic, copy) void (^noticeButtonClickBlock)(NSInteger index);
@property (nonatomic, copy) void (^noticeButtonClickBlock)(NSString * linkUrl);

@end
