//
//  NSUtil.h
//  FrameWork
//
//  Created by 李刚 on 2017/5/10.
//  Copyright © 2017年 李刚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NetWorkStatus) {
    NetWorkStatusUnknown          = -1,     // 未知
    NetWorkStatusNotReachable     = 0,      // 无网络
    NetWorkStatusReachableViaWWAN = 1,      // GPRS
    NetWorkStatusReachableViaWiFi = 2,      // WiFi
};


typedef NS_ENUM(NSInteger, NetWorkType) {
    NetWorkTypeUnknown          = -1,     // 未知
    NetWorkTypeNotReachable     = 0,      // 无网络
    NetWorkTypeReachableViaWiFi = 1,      // WiFi
    NetWorkTypeReachableVia2G   = 2,      // 2G
    NetWorkTypeReachableVia3G   = 3,      // 3G
    NetWorkTypeReachableVia4G   = 4,      // 4G
};

@interface NSUtil : NSObject

#pragma mark   -  网络
/**  获取网络状态*/
+ (NetWorkStatus)getNetWorkStatus;

/**  获取网络类型*/
+ (NetWorkType)getNetWorkType;

#pragma mark   -  设备
/**  获取版本号*/
+ (NSString *)getAppVersion;

/**  获取UUID*/
+ (NSString *)getUUID;


#pragma mark   -  文件管理(缓存) FileManager
/**  路径是否存在*/
+ (BOOL)isExistPath:(NSString *)path;

/**  文件是否存在*/
+ (BOOL)isExistFile:(NSString *)file;

/**  文件夹是否存在*/
+ (BOOL)isExistDirectory:(NSString *)directory;

/**  移除某目录下的文件*/
+ (BOOL)removePath:(NSString *)path;

/**  Document下文件路径*/
+ (NSString *)getDocumentFilePath:(NSString *)file;

/**  Cache下文件路径*/
+ (NSString *)getCacheFilePath:(NSString *)file;

/**  缓存大小*/
+ (unsigned long long)getCacheSize;

/**  清除缓存*/
+ (void)clearCache;

/**  自动清除缓存*/
+ (void)autoClearCache;

#pragma mark   -  账号检测

/**  判断是否为国内手机号码*/
+ (BOOL)isPhoneNumberInChina:(NSString *)phoneNumber;

/**  判断是否是邮箱地址*/
+ (BOOL)isEmailAddress:(NSString *)email;

/**  检验身份证格式*/
+ (BOOL)isIDCard:(NSString *)idCard;


/**  是否是空字符串*/
+ (BOOL)isEmptyString:(NSString*)string;


#pragma mark   -  时间\日期

/**  是不是今天*/
+ (BOOL)isToday:(NSDate *)date;

/**  是不是今年*/
+ (BOOL)isThisYear:(NSDate *)date;

/**  最近时间*/
+ (NSString *)relativeTime:(NSDate *)date;

/**  最近的日期*/
+ (NSString *)relativeDate:(NSDate *)date;

/**  根据日期返回字符串*/
+ (NSString *)stringWithDate:(NSDate *)date format:(NSString *)format;

/**  根据字符串返回日期*/
+ (NSDate *)dateWithString:(NSString *)string format:(NSString *)format;
@end
