//
//  NSUtil.m
//  FrameWork
//
//  Created by 李刚 on 2017/5/10.
//  Copyright © 2017年 李刚. All rights reserved.
//

#import "NSUtil.h"
#import <AdSupport/AdSupport.h>
#import <objc/runtime.h>
#import "KeyChainStore.h"

@implementation NSUtil

/**  获取版本号*/
+ (NSString *)getAppVersion;
{
    NSString *key = @"CFBundleShortVersionString";
    NSString *version = [NSBundle mainBundle].infoDictionary[key];

    return version;
}

/**  获取UUID*/
+ (NSString *)getUUID{
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

/**  获取UUID*/
+ (NSString *)getUUIDByKeyChain{
    NSString*strUUID = (NSString*)[KeyChainStore load:@"com.cloudshixi.trainee.usernamepassword"];

    //首次执行该方法时，uuid为空
    if([strUUID isEqualToString:@""]|| !strUUID)
    {

        // 获取UUID
        strUUID = [self getUUID];

        if(strUUID.length ==0 || [strUUID isEqualToString:@"00000000-0000-0000-0000-000000000000"])
        {
            //生成一个uuid的方法
            CFUUIDRef uuidRef= CFUUIDCreate(kCFAllocatorDefault);
            strUUID = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault,uuidRef));
            CFRelease(uuidRef);
        }

        //将该uuid保存到keychain
        [KeyChainStore save:@"com.cloudshixi.trainee.usernamepassword" data:strUUID];

    }
    return strUUID;
}

#pragma mark   -  在主线程执行某操作
+ (void)performBlockOnMainThread:(CompleteBlock)block{
    if ([[NSThread currentThread] isMainThread]) {
        block();
    }else{
        dispatch_sync(dispatch_get_main_queue(), ^{
            block();
        });
    }
}

#pragma mark   - 返回当前类的所有属性
+ (instancetype)getProperties:(Class)className{

    // 获取当前类的所有属性
    unsigned int count;// 记录属性个数
    objc_property_t *properties = class_copyPropertyList(className, &count);
    // 遍历
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {

        // An opaque type that represents an Objective-C declared property.
        // objc_property_t 属性类型
        objc_property_t property = properties[i];
        // 获取属性的名称 C语言字符串
        const char *cName = property_getName(property);
        // 转换为Objective C 字符串
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        [mArray addObject:name];
    }

    return mArray.copy;
}

+ (UIViewController *)currentController{

    if ([kAppDelegate.window.rootViewController isKindOfClass:UINavigationController.class] || [kAppDelegate.window.rootViewController isKindOfClass:UITabBarController.class]) {
        return [self getVisibleViewControllerWithRootVC:kAppDelegate.window.rootViewController];
    }else{
        UIViewController *VC = kAppDelegate.window.rootViewController;
        if (VC.presentedViewController) {
            if ([VC.presentedViewController isKindOfClass:UINavigationController.class]||
                [VC.presentedViewController isKindOfClass:UITabBarController.class]) {
                return [self getVisibleViewControllerWithRootVC:VC.presentedViewController];
            }else{
                return VC.presentedViewController;
            }
        }
        else{
            return VC;
        }
    }
}

/**
 * 私有方法
 * rootVC必须是UINavigationController 或 UITabBarController 及其子类
 */
+ (UIViewController *)getVisibleViewControllerWithRootVC:(UIViewController *)rootVC{

    if ([rootVC isKindOfClass:UINavigationController.class]) {
        UINavigationController *nav = (UINavigationController *)rootVC;
        // Return modal navigation controller's top view controller
        if ([nav.visibleViewController isKindOfClass:UINavigationController.class]) {
            UINavigationController *presentdNav = (UINavigationController *)nav.visibleViewController;
            return presentdNav.visibleViewController;
        }
        else if ([nav.visibleViewController isKindOfClass:UITabBarController.class]){
            return [self getVisibleViewControllerWithRootVC:nav.visibleViewController];
        }
        // Return modal view controller if it exists. Otherwise the top view controller.
        else{
            return nav.visibleViewController;
        }
    }
    else if([rootVC isKindOfClass:UITabBarController.class]){
        UITabBarController *tabVC = (UITabBarController *)rootVC;
        UINavigationController *nav = (UINavigationController *)tabVC.selectedViewController;
        return [self getVisibleViewControllerWithRootVC:nav];
    }else{
        return rootVC;
    }
}
#pragma mark   -  获取启动图
+ (UIImage *)getLaunchImage{

    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString *launchImage = nil;

    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);

        // 横屏改成 @"Landscape"
        if (CGSizeEqualToSize(imageSize, viewSize) && [@"Portrait" isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    return [UIImage imageNamed:launchImage];
}

#pragma mark   -  设置
// 设置导航栏底部黑线
+ (void)setNavigationBarLine:(UIView *)view hidden:(BOOL)hidden
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0)
    {
        view.hidden = hidden;
        return;
    }
    for (UIView *subview in view.subviews) {
        [self setNavigationBarLine:subview hidden:hidden];
    }
    return ;
}

#pragma mark   -  NSUserDefaults
+ (void)saveValue:(id)value forKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (id)getValueForKey:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
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

+ (NSString *)getDocumentPath{

    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [document stringByAppendingPathComponent:@"AppDocument"];;
}

/**  Document下文件路径*/
+ (NSString *)getDocumentFilePath:(NSString *)file{

    NSString *dir = [self getDocumentPath];
    if ([self isExistDirectory:dir] == NO)
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [dir stringByAppendingPathComponent:file];

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

/**  Cache下文件夹 没有时会创建一个*/
+ (NSString *)getCacheDirectory:(NSString *)directory{
    NSString *dir = [self getCachePath];
    if ([self isExistDirectory:dir] == NO)
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    dir = [dir stringByAppendingPathComponent:directory];
    if ([self isExistDirectory:dir] == NO)
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return dir;
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


    NSString *mobileNumberRegEx = @"^1\\d{10}$|^0\\d{9,11}$";

    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileNumberRegEx];
    return ([regextestmobile evaluateWithObject:phoneNumber]);
}


/**  密码校验
 *  密码长度最少6位
 *  大写字母，小写字母，数字，特殊符号四选二
 */
+ (BOOL)checkPassword:(NSString *)password{

    // 大写字母，小写字母，数字，特殊符号四选二
    NSString *passwordRegEx = @"^(?![A-Z]+$)(?![a-z]+$)(?!\\d+$)(?![\\W_]+$)\\S{6,16}$";
    // 大写字母，小写字母，数字，特殊符号四选二
    //NSString *passwordRegEx = @"^(?![a-zA-Z]+$)(?![A-Z0-9]+$)(?![A-Z\\W_]+$)(?![a-z0-9]+$)(?![a-z\\W_]+$)(?![0-9\\W_]+$)[a-zA-Z0-9\\W_]{6,16}$";
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegEx];
    return ([regExPredicate evaluateWithObject:password]);
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
        return [NSString stringWithFormat:@"%d小时前", (int)t/3600];
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


#pragma mark   -  图片
/**  压缩图片*/
+ (UIImage *)imageWithOriginalImage:(UIImage *)image{
    // 宽高比
    CGFloat ratio = image.size.width/image.size.height;

    // 目标大小
    CGFloat targetW = 1280;
    CGFloat targetH = 1280;

    // 宽高均 <= 1280，图片尺寸大小保持不变
    if (image.size.width<1280 && image.size.height<1280) {
        return image;
    }
    // 宽高均 > 1280 && 宽高比 > 2，
    else if (image.size.width>1280 && image.size.height>1280){

        // 宽大于高 取较小值(高)等于1280，较大值等比例压缩
        if (ratio>1) {
            targetH = 1280;
            targetW = targetH * ratio;
        }
        // 高大于宽 取较小值(宽)等于1280，较大值等比例压缩
        else{
            targetW = 1280;
            targetH = targetW / ratio;
        }

    }
    // 宽或高 > 1280
    else{
        // 宽图 图片尺寸大小保持不变
        if (ratio>2) {
            targetW = image.size.width;
            targetH = image.size.height;
        }
        // 长图 图片尺寸大小保持不变
        else if (ratio<0.5){
            targetW = image.size.width;
            targetH = image.size.height;
        }
        // 宽大于高 取较大值(宽)等于1280，较小值等比例压缩
        else if (ratio>1){
            targetW = 1280;
            targetH = 1280 / ratio;
        }
        // 高大于宽 取较大值(高)等于1280，较小值等比例压缩
        else{
            targetH = 1280;
            targetW = 1280 * ratio;
        }
    }

    image = [[NSUtil alloc] imageCompressWithImage:image targetHeight:targetH targetWidth:targetW];


    return image;
}

/**  重绘*/
- (UIImage *)imageCompressWithImage:(UIImage *)sourceImage targetHeight:(CGFloat)targetHeight targetWidth:(CGFloat)targetWidth
{
    //    CGFloat targetHeight = (targetWidth / sourceImage.size.width) * sourceImage.size.height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth, targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**  压缩图片 压缩质量 0 -- 1*/
+ (UIImage *)imageWithOriginalImage:(UIImage *)image quality:(CGFloat)quality{

    UIImage *newImage = [self imageWithOriginalImage:image];
    NSData *imageData = UIImageJPEGRepresentation(newImage, quality);
    return [UIImage imageWithData:imageData];
}

/**  压缩图片成Data*/
+ (NSData *)dataWithOriginalImage:(UIImage *)image{
    return UIImageJPEGRepresentation([self imageWithOriginalImage:image], 1);
}

#pragma mark   -  Font
+ (UIFont *)fontWithName:(NSString *)name size:(CGFloat)size bold:(BOOL)bold{
    UIFont *font = [UIFont fontWithName:name size:size];
    // 如果没有 就用系统字体
    if (font == nil || name == nil) {
        font = bold ? [UIFont boldSystemFontOfSize:size] : [UIFont systemFontOfSize:size];
    }
    return font;
}
+ (UIFont *)fontWithFamily:(NSString *)family name:(NSString *)name size:(CGFloat)size{

    UIFontDescriptor *attributeFontDescriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:
                                                 @{UIFontDescriptorFamilyAttribute:family,
                                                   UIFontDescriptorNameAttribute:name,
                                                   UIFontDescriptorSizeAttribute:@(size)}];
    UIFont * font = [UIFont fontWithDescriptor:attributeFontDescriptor size:size];
    if (font == nil) font = [UIFont systemFontOfSize:size];
    return font;
}


#pragma mark   -  HTML to String
+ (NSAttributedString *)htmlToAttribute:(NSString *)html
{
    NSData *data = [html dataUsingEncoding:NSUnicodeStringEncoding];
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    NSAttributedString *attribute = [[NSAttributedString alloc]initWithData:data
                                                                    options:options
                                                         documentAttributes:nil
                                                                      error:nil];
    return attribute;
}

// 将 attr 转 html
+ (NSString *)attributeToHtml:(NSAttributedString *)attributeString
{
    NSString *htmlString;
    NSDictionary *exportParams = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]};

    NSData *htmlData = [attributeString dataFromRange:NSMakeRange(0, attributeString.length) documentAttributes:exportParams error:nil];

    htmlString = [[NSString alloc] initWithData:htmlData encoding: NSUTF8StringEncoding];
    return htmlString;
}
@end
