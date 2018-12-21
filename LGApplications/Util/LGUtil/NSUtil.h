//
//  NSUtil.h
//  FrameWork
//
//  Created by 李刚 on 2017/5/10.
//  Copyright © 2017年 李刚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef void(^ResultBlock)(NSDictionary *result);
typedef void(^StringBlock)(NSString *text);
typedef void(^CompleteBlock)(void);

@interface NSUtil : NSObject

#pragma mark   -  设备
/**  获取版本号*/
+ (NSString *)getAppVersion;

/**  获取UUID*/
+ (NSString *)getUUID;

/**  获取UUID*/
+ (NSString *)getUUIDByKeyChain;

#pragma mark   -  在主线程执行某操作
+ (void)performBlockOnMainThread:(CompleteBlock)block;

#pragma mark   - 返回当前类的所有属性
+ (instancetype)getProperties:(Class)className;

#pragma mark   -  获取启动图
+ (UIImage *)getLaunchImage;

#pragma mark   -  设置
/**  设置导航栏黑线*/
+ (void)setNavigationBarLine:(UIView *)view hidden:(BOOL)hidden;

+ (UIViewController *)currentController;

#pragma mark   -  NSUserDefaults
+ (void)saveValue:(id)value forKey:(NSString *)key;
+ (id)getValueForKey:(NSString *)key;

#pragma mark   -  文件管理(缓存) FileManager
/**  路径是否存在*/
+ (BOOL)isExistPath:(NSString *)path;

/**  文件是否存在*/
+ (BOOL)isExistFile:(NSString *)file;

/**  文件夹是否存在*/
+ (BOOL)isExistDirectory:(NSString *)directory;

/**  移除某目录下的文件*/
+ (BOOL)removePath:(NSString *)path;

/**  Document下文件路径 没有时会创建一个*/
+ (NSString *)getDocumentFilePath:(NSString *)file;

/**  Cache下文件路径(比如.plist) 没有时会创建一个*/
+ (NSString *)getCacheFilePath:(NSString *)file;

/**  Cache下文件夹 没有时会创建一个*/
+ (NSString *)getCacheDirectory:(NSString *)directory;

/**  缓存大小*/
+ (unsigned long long)getCacheSize;

/**  清除缓存*/
+ (void)clearCache;

/**  自动清除缓存*/
+ (void)autoClearCache;

#pragma mark   -  账号检测

/**  判断是否为国内手机号码*/
+ (BOOL)isPhoneNumberInChina:(NSString *)phoneNumber;

/**  密码校验
 *  密码长度最少6位
 *  大写字母，小写字母，数字，特殊符号四选二
 */
+ (BOOL)checkPassword:(NSString *)password;

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


#pragma mark   -  图片
/**  压缩图片*/
+ (UIImage *)imageWithOriginalImage:(UIImage *)image;

/**  压缩图片 压缩质量 0 -- 1*/
+ (UIImage *)imageWithOriginalImage:(UIImage *)image quality:(CGFloat)quality;

/**  压缩图片成Data*/
+ (NSData *)dataWithOriginalImage:(UIImage *)image;


#pragma mark   -  Font
/**  bold为YES: 在指定的字体名没有对应字体的时 使用系统粗体*/
+ (UIFont *)fontWithName:(NSString *)name size:(CGFloat)size bold:(BOOL)bold;
+ (UIFont *)fontWithFamily:(NSString *)family name:(NSString *)name size:(CGFloat)size;


#pragma mark   -  HTML to String
+ (NSAttributedString *)htmlToAttribute:(NSString *)html;
+ (NSString *)attributeToHtml:(NSAttributedString *)attributeString;
@end
