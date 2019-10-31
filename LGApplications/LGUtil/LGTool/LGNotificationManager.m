//
//  LGNotificationManager.m
//  Trainee
//
//  Created by 李刚 on 2018/12/26.
//  Copyright © 2018 Mr.Lee. All rights reserved.
//

#import "LGNotificationManager.h"
static LGNotificationManager *_shareManager;

@implementation LGNotificationManager

+ (LGNotificationManager *)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareManager = [[self alloc] init];
    });
    return _shareManager;
}


/**  设置签到通知*/
- (void)resetCheckinNotifications{

    // 用户首次使用 默认开启通知
    if ([NSUtil getValueForKey:kCheckinNotificationSwitchKey] == nil) {
        [NSUtil saveValue:@(YES) forKey:kCheckinNotificationSwitchKey];
    }

    // 如果用户关闭通知，直接返回
    if([[NSUtil getValueForKey:kCheckinNotificationSwitchKey] isEqual: @(NO)]) return;

    // 取消以前的通知
    [self cancelAllNotification];

    // weekday 1:周日  2:周一, 3:周二 4:周三 5:周四 6:周五 7:周六
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSDate *zeroDate = [calendar dateFromComponents:dateComps] ;
    NSDate *notifyDate = [zeroDate dateByAddingTimeInterval:9.5*60*60]; // 每天9:30分通知

    // 未来一周 创建5个通知：星期一到星期五 (过滤掉周末 并按周重复）
    for (int i=0;i<7;i++) {

        // 从明天开始
        NSInteger notifyWeekday = [dateComps weekday]+i+1;

        // 如果是明天到下周了，矫正weekday
        if(notifyWeekday >= 8){
            notifyWeekday = notifyWeekday-7;
        }
        // 明天是周六或周日 过滤掉
        if(notifyWeekday == 7 || notifyWeekday == 1) continue;

        // 计算未来通知的时间
        NSDate *date= [notifyDate dateByAddingTimeInterval:(i+1)*60*60*24];
        NSString *identifier = [NSUtil stringWithDate:date format:@"yyyy-MM-dd"];

        if (@available(iOS 10.0, *)) {
            // weekday 2:周一, 3:周二 4:周三 5:周四 6:周五
            UNNotificationRequest *request = [self createNotificationRequestWithWeekday:notifyWeekday identifier:identifier];
            // 把通知加到UNUserNotificationCenter, 到指定触发点会被触发
            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
        }
        else{
            UILocalNotification *notification = [self createLocalNotificationWithDate:date identifier:identifier];
            [kApplication scheduleLocalNotification:notification];
        }
    }

}

/**  取消一个特定的通知*/
- (void)cancelNotificationWithIdentifier:(NSString *)identifier{
    if (@available(iOS 10.0, *)) {
        [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[identifier]];
    }
    else{

        // 获取当前所有的本地通知
        NSArray *notificaitons = [[UIApplication sharedApplication] scheduledLocalNotifications];
        if (!notificaitons || notificaitons.count <= 0) { return; }
        for (UILocalNotification *notify in notificaitons) {
            if ([[notify.userInfo objectForKey:@"identifier"] isEqualToString:identifier]) {
                [[UIApplication sharedApplication] cancelLocalNotification:notify];
                break;
            }
        }
    }

}
- (void)cancelAllNotification{
    if (@available(iOS 10.0, *)) {
        [[UNUserNotificationCenter currentNotificationCenter] removeAllDeliveredNotifications];
        [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
    }
    else{
         [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
}

/**  取消已经推过的通知*/
- (void)removeAllDeliveredNotifications{
    if (@available(iOS 10.0, *)) {
        [[UNUserNotificationCenter currentNotificationCenter] removeAllDeliveredNotifications];
    }
}



#pragma mark   -  私有方法

/**  设置指定时间通知，每周重复*/
- (UILocalNotification *)createLocalNotificationWithDate:(NSDate *)date identifier:(NSString *)identifier{

    UILocalNotification *localNotification = [[UILocalNotification alloc] init];

    // 1.设置触发时间（如果要立即触发，无需设置）
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.fireDate = date;
    localNotification.repeatInterval = NSCalendarUnitWeekday;

    // 2.设置通知标题
    localNotification.alertBody = self.title.length ? self.title:@"签到通知";
    localNotification.alertAction = self.content.length ? self.content:@"同学，今天签到没？千万不要忘了哦！";
    // localNotification.applicationIconBadgeNumber = ++kApplication.applicationIconBadgeNumber;

    // 3.设置通知的 传递的userInfo
    localNotification.userInfo = @{@"kLocalNotificationID":kCheckinNotification,@"identifier":identifier};

    return localNotification;
}


/**  每个星期的星期几 9点30通知*/
- (UNNotificationRequest *)createNotificationRequestWithWeekday:(NSInteger)weekday identifier:(NSString *)identifier __IOS_AVAILABLE(10.0){

    // 1.创建通知内容
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.sound = [UNNotificationSound defaultSound];
    content.title = self.title.length ? self.title:@"签到提醒";
    content.body = self.content.length ? self.content:@"同学，今天签到没？千万不要忘了哦！";
    //content.badge = @(++kApplication.applicationIconBadgeNumber); // 不显示角标
    content.userInfo = @{@"kLocalNotificationID":kCheckinNotification,@"identifier":identifier};

    // 2.触发模式 9点30 每周重复 ()
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.hour = 9;  // 九点
    dateComponents.minute = 30;
    dateComponents.weekday = weekday;
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComponents repeats:YES];

    // 4.设置UNNotificationRequest
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];

    return request;
}
@end
