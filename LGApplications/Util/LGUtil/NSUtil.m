//
//  NSUtil.m
//  FrameWork
//
//  Created by 李刚 on 2017/5/10.
//  Copyright © 2017年 李刚. All rights reserved.
//

#import "NSUtil.h"

@implementation NSUtil


/**  获取网络状态*/
+ (NetWorkStatus)getNetWorkStatus;
{
    UIApplication *application = [UIApplication sharedApplication];
    NSArray *subviews = [[[application valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    
    NSNumber *dataNetWorkItemView = nil;
    
    for (id subView in subviews) {
        if ([subView isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetWorkItemView = subView;
            break;
        }
    }
    
    switch ([[dataNetWorkItemView valueForKey:@"dataNetworkType"]integerValue]) {
        case 0:
        {
            return NetWorkStatusNotReachable;
        }
            break;
        case 1:
        {
            return NetWorkStatusReachableViaWWAN;
        }
            break;
        case 2:
        {
            return NetWorkStatusReachableViaWWAN;
        }
            break;
        case 3:
        {
            return NetWorkStatusReachableViaWWAN;
        }
        default:
        {
            return NetWorkStatusReachableViaWiFi;
        }
            break;
    }
    
}

/**  获取网络类型*/
+ (NetWorkType)getNetWorkType{
    
        UIApplication *application = [UIApplication sharedApplication];
        NSArray *subviews = [[[application valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
        
        NSNumber *dataNetWorkItemView = nil;
        
        for (id subView in subviews) {
            if ([subView isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
                dataNetWorkItemView = subView;
                break;
            }
        }
        
        switch ([[dataNetWorkItemView valueForKey:@"dataNetworkType"]integerValue]) {
            case 0:
            {
                return NetWorkTypeNotReachable;
            }
                break;
            case 1:
            {
                return NetWorkTypeReachableVia2G;
            }
                break;
            case 2:
            {
                return NetWorkTypeReachableVia3G;
            }
                break;
            case 3:
            {
                return NetWorkTypeReachableVia4G;
            }
            default:
            {
                return NetWorkTypeReachableViaWiFi;
            }
                break;
        }
}


/**  获取版本号*/
+ (NSString *)getAppVersion;
{
    NSString *key = @"CFBundleShortVersionString";
    NSString *version = [NSBundle mainBundle].infoDictionary[key];
    
    return version;
}

/**  获取UUID*/
+ (NSString *)getUUID{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    NSString *string = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return string;
}


#pragma mark   -  文件管理(缓存) FileManager
/**  路径是否存在*/
+ (BOOL)isExistPath:(NSString *)path{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

/**  文件是否存在*/
+ (BOOL)isExistFile:(NSString *)file{
    BOOL isDirectory;
    return [[NSFileManager defaultManager] fileExistsAtPath:file isDirectory:&isDirectory] && !isDirectory;
}

/**  文件夹是否存在*/
+ (BOOL)isExistDirectory:(NSString *)directory{
    BOOL isDirectory;
    return [[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:&isDirectory] && isDirectory;
}

/**  移除某目录下的文件*/
+ (BOOL)removePath:(NSString *)path{
    return [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

/**  Document下文件路径*/
+ (NSString *)getDocumentFilePath:(NSString *)file{
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [document stringByAppendingPathComponent:file];
}

/**  缓存路径*/
+ (NSString *)getCachePath{
    NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [cache stringByAppendingPathComponent:@"Cache"];
}

/**  Cache下文件路径*/
+ (NSString *)getCacheFilePath:(NSString *)file{
    
    NSString *dir = [self getCachePath];
    if ([self isExistDirectory:dir] == NO)
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [dir stringByAppendingPathComponent:file];
}


/**  缓存大小*/
+ (unsigned long long)getCacheSize{
    NSString *dir = [self getCachePath];
    
    //
    unsigned long long size = 0;
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:dir];
    for (NSString *file in files)
    {
        NSString *path = [dir stringByAppendingPathComponent:file];
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
        size += [dict fileSize];
    }
    
    return size;
}

/**  清除缓存*/
+ (void)clearCache{
    [[NSFileManager defaultManager] removeItemAtPath:[self getCachePath] error:nil];
}

/**  自动清除缓存*/
+ (void)autoClearCache{
    
    // 默认七天
    NSTimeInterval defaultSec = 7*24*3600;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *dir = [self getCachePath];
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:dir];
        NSDate *now = [NSDate date];
        for (NSString *file in files)
        {
            if ([[file pathExtension] isEqualToString:@"plist"]) {
                continue;
            }
            NSString *path = [dir stringByAppendingPathComponent:file];
            NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
            
            NSTimeInterval sec = [now timeIntervalSinceDate:[dict fileCreationDate]];
            if (sec >= defaultSec) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            }
        }
    });
}


/**  判断是否为国内手机号码*/
+ (BOOL)isPhoneNumberInChina:(NSString *)phoneNumber{
    
    /**
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    
    NSString *mobileNumberRegEx = @"^1[358]\\d{9}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileNumberRegEx];
    return ([regextestmobile evaluateWithObject:phoneNumber]);
}

/**  判断是否是邮箱地址*/
+ (BOOL)isEmailAddress:(NSString *)email{
    NSString *emailRegEx =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    return [regExPredicate evaluateWithObject:[email lowercaseString]];
}


/**  判断身份证是否合法*/
+ (BOOL)isIDCard:(NSString *)idCard{
    NSString *idCardRegex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", idCardRegex];
    return [regExPredicate evaluateWithObject:idCard];
}

/**  是否是空字符串*/
+ (BOOL)isEmptyString:(NSString *)string
{
    if (string && [string isKindOfClass:[NSString class] ] && [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0)
    {
        return NO;
    }
    return YES;

}

#pragma mark   -  时间/日期
/**  是不是今天*/
+ (BOOL)isToday:(NSDate *)date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *nowString = [formatter stringFromDate:[NSDate date]];
    NSString *dateString = [formatter stringFromDate:date];
    return [nowString isEqualToString:dateString];
}

/**  是不是今年*/
+ (BOOL)isThisYear:(NSDate *)date{
    // 比较日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear ;
    NSDateComponents *components =[calendar components:unit fromDate:date toDate:[NSDate date] options:0];
    return components.year == 0;
}


/**  最近时间*/
+ (NSString *)relativeTime:(NSDate *)date
{
    NSTimeInterval t = [[NSDate date] timeIntervalSinceDate:date];
    if (t < 0 || t == 0 || t < 60) {
        return @"刚刚";
    }
    if (t < 60 * 60) {
        return [NSString stringWithFormat:@"%ld分钟前", (long)(t/60)];
    }
    if (t < 60 * 60 * 24) {
        return [NSString stringWithFormat:@"%ld小时前", (long)(t/(60 * 60))];
    }
    if (t < 60 * 60 * 24 * 31) {
        return [NSString stringWithFormat:@"%ld天前", (long)(t/(60 * 60 * 24))];
    }
    return @"30天前";
}


/**  最近的日期*/
+ (NSString *)relativeDate:(NSDate *)date
{
    
    
    // 日期格式化类
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    // 设置日期格式(y:年,M:月,d:日,H:时,m:分,s:秒)
    format.dateFormat = @"yyyy-MM-dd";
    
    
    NSDate * currtentDate = [NSDate date];
    
//    // 比较日历
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
//    // 这个返回的是相差多久
//    // 比如差12个小时, 无论在不在同一天 day都是0
//    // NSDateComponents *components = [calendar components:unit fromDate:date toDate:currtentDate options:0];
//    NSDateComponents *currentCalendar =[calendar components:unit fromDate:currtentDate];
//    NSDateComponents *targetCalendar =[calendar components:unit fromDate:date];
//    
//    BOOL isYear = currentCalendar.year == targetCalendar.year;
//    BOOL isMonth = currentCalendar.month == targetCalendar.month;
//    BOOL isDay = currentCalendar.day == targetCalendar.day;
    
    NSDateComponents *components = [NSUtil compareCalendar:date];
    
    // 比较时间
    NSTimeInterval t = [currtentDate timeIntervalSinceDate:date];
    
    // 一分钟内
    if (t < 60) {
        return @"刚刚";
    }
    // 一小时内
    else if (t < 60 * 60) {
        return [NSString stringWithFormat:@"%ld分钟前", (long)(t/60)];
    }
    // 今天
    else if (components.year == 0 && components.month == 0 && components.day == 0) {
        if (t/3600 > 3) {
            format.dateFormat = @"HH:mm";
            return [format stringFromDate:date];
        }
        return [NSString stringWithFormat:@"%zd小时前", (int)t/3600];
    }
    // 昨天
    else if (components.year == 0 && components.month == 0 && components.day == 1) {
        format.dateFormat = @"昨天 HH:mm";
        return [format stringFromDate:date];
    }
    // 前天
    else if (components.year == 0 && components.month == 0 && components.day == 2) {
        return @"前天";
    }
    // 今年
    else if (components.year == 0) {
        format.dateFormat = @"MM-dd";
        return [format stringFromDate:date];
    }
    // 今年以前
    return [format stringFromDate:date];;
}


/**  根据日期返回字符串*/
+ (NSString *)stringWithDate:(NSDate *)date format:(NSString *)format {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:format];
    return [outputFormatter stringFromDate:date];;
}

/**  根据字符串返回日期*/
+ (NSDate *)dateWithString:(NSString *)string format:(NSString *)format {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];    
    return [inputFormatter dateFromString:string];;
}



/**  比较两个日期,年月日, 时分秒 各相差多久
 *   先判断年 若year>0   则相差这么多年,后面忽略
 *   再判断月 若month>0  则相差这么多月,后面忽略
 *   再判断日 若day>0    则相差这么多天,后面忽略(0是今天,1是昨天,2是前天)
 *          若day=0    则是今天 返回相差的总时长
 */
+ (NSDateComponents *)compareCalendar:(NSDate *)date{
    
    NSDate * currtentDate = [NSDate date];
    
    // 比较日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 这个返回的是相差多久
    // 比如差12个小时, 无论在不在同一天 day都是0
    // NSDateComponents *components = [calendar components:unit fromDate:date toDate:currtentDate options:0];
    NSDateComponents *currentCalendar =[calendar components:unit fromDate:currtentDate];
    NSDateComponents *targetCalendar =[calendar components:unit fromDate:date];
    
    BOOL isYear = currentCalendar.year == targetCalendar.year;
    BOOL isMonth = currentCalendar.month == targetCalendar.month;
    BOOL isDay = currentCalendar.day == targetCalendar.day;
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    if (isYear) {
        if (isMonth) {
            if (isDay) {
                // 时分秒
                components = [calendar components:unit fromDate:date toDate:currtentDate options:0];
            }
            [components setValue:(currentCalendar.day - targetCalendar.day) forComponent:NSCalendarUnitDay];
        }
        [components setValue:(currentCalendar.month - targetCalendar.month) forComponent:NSCalendarUnitMonth];
    }
    [components setValue:(currentCalendar.year - targetCalendar.year) forComponent:NSCalendarUnitYear];
    return components;
}




// 划线
- (void)drawLine:(CGContextRef)context startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint lineColor:(UIColor *)lineColor lineWidth:(CGFloat)width {
    
    // [super drawRect:rect];
    // CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetShouldAntialias(context, YES ); //抗锯齿
    CGColorSpaceRef Linecolorspace1 = CGColorSpaceCreateDeviceRGB();
    CGContextSetStrokeColorSpace(context, Linecolorspace1);
    CGContextSetLineWidth(context, width);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextStrokePath(context);
    CGColorSpaceRelease(Linecolorspace1);
}



@end
