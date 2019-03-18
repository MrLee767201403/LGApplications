//
//  LGNotificationManager.h
//  Trainee
//
//  Created by 李刚 on 2018/12/26.
//  Copyright © 2018 Mr.Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

static NSNotificationName const _Nullable kCheckinNotification = @"CheckinNotification";
static NSString *const _Nullable kCheckinNotificationSwitchKey = @"kCheckinNotificationSwitchKey";

NS_ASSUME_NONNULL_BEGIN

@interface LGNotificationManager : NSObject

/**  签到通知的标题 默认：签到提醒*/
@property (nonatomic, copy, nullable) NSString *title;
/**  签到通知的内容 默认：同学，今天签到了么*/
@property (nonatomic, copy, nullable) NSString *content;


#pragma mark   -  方法
+ (instancetype)shareManager;

/** 设置签到通知*/
- (void)resetCheckinNotifications;  // 每次九点半以前签到成功的时候调用
- (void)cancelAllNotification;
- (void)cancelNotificationWithIdentifier:(NSString *)identifier;
- (void)removeAllDeliveredNotifications __IOS_AVAILABLE(10.0);
@end

NS_ASSUME_NONNULL_END
