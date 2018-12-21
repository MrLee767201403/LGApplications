//
//  UIDefines.h
//  FrameWork
//
//  Created by 李刚 on 2017/5/9.
//  Copyright © 2017年 李刚. All rights reserved.
//

#ifndef UIDefines_h
#define UIDefines_h
static NSString *kFontNameDINAlternateBold = @"DINAlternate-Bold";
static NSString *kFontNameDINCondMedium = @"DINCond-Medium";
static NSString *kFontNamePingFangSCRegular = @"PingFangSC-Regular";
static NSString *kFontNamePingFangSCSemibold = @"PingFangSC-Semibold";
static NSString *kFontNamePingFangSCMedium = @"PingFangSC-Medium";
static NSString *kFontNamePingFangSCLight = @"PingFangSC-Light";

#define kBoldFontWithName(Name,F)    [NSUtil fontWithName:Name size:F bold:YES]
#define kFontWithName(Name,F)        [NSUtil fontWithName:Name size:F bold:NO]
#define kBoldFont(size)              [UIFont boldSystemFontOfSize:size]


// 字体字号
#define kFontSmallMost          kFontWithSize(9)
#define kFontSmallMore          kFontWithSize(11)
#define kFontSmall              kFontWithSize(12)
#define kFontMiddle             kFontWithSize(13)
#define kFontNormal             kFontWithSize(14)
#define kFontLagre              kFontWithSize(15)
#define kFontLagreMore          kFontWithSize(16)
#define kFontLagreVery          kFontWithSize(18)
#define kFontLagreMost          kFontWithSize(20)

#define kFontWithSize(F)        kFontWithName(kFontNamePingFangSCRegular, (F))
#define kFontNavigation         kFontWithName(kFontNamePingFangSCMedium, 18)


#define Image(name)             [UIImage imageNamed:name]

// 版本信息
#define kSystemVersion  [UIDevice.currentDevice.systemVersion floatValue]
#define iOS9Later       (kSystemVersion >= 9.0f)
#define iOS10Later      (kSystemVersion >= 10.0f)
#define iOS11Later      (kSystemVersion >= 11.0f)


// 获得屏幕宽高
#define kScreenWidth            [UIScreen mainScreen].bounds.size.width
#define kScreenHeight           [UIScreen mainScreen].bounds.size.height
#define kNavigationHeight       (iphoneX ? 88 : 64)
#define kContentHeight          (kScreenHeight - kNavigationHeight)

#define kScale                  kScreenWidth/375
#define kScaling(f)             kScale * f
#define kScales(f)              (iphonePlus_5_5 ?  1.1:1) * f  //   只针对Plus做缩放

// UIApplication
#define kApplication            [UIApplication sharedApplication]
#define kAppDelegate            [UIApplication sharedApplication].delegate


// 手机型号
#define iphone4_3_5     ([UIScreen mainScreen].bounds.size.height<500.0f)
#define iphone5_4_0     ([UIScreen mainScreen].bounds.size.height==568.0f)
#define iphone6_4_7     ([UIScreen mainScreen].bounds.size.height==667.0f)
#define iphonePlus_5_5  ([UIScreen mainScreen].bounds.size.height>700.0f)
#define iphoneX         ([UIScreen mainScreen].bounds.size.height>800.0f)


// 获得RGB颜色
#define kColorWithRGB(r, g, b)          [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kColorRGBAlpha(r, g, b, a)      [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define kColorWithFloat(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]


// 主要颜色
#define kColorSeparator             (kColorWithFloat(0xCCCCCC))   // 分割线
#define kColorHighlighted           (kColorWithFloat(0xf2f2f2))   // Cell高亮
#define kColorDisable               (kColorWithFloat(0xCCCCCC))
#define kColorBackground            (kColorWithFloat(0xeeeeee))   // 界面背景色
#define kColorMainTheme             (kColorWithFloat(0x5CD5A9))   // 主题色
#define kColorButtonHL              (kColorWithFloat(0x70c8a7))   // 主题高亮

#define kColorWhite                 (kColorWithFloat(0xFFFFFF))   // 白色
#define kColorRed                   (kColorWithFloat(0xf0735d))   // 淡红
#define kColorDark                  (kColorWithFloat(0x333333))   // 暗黑
#define kColorText                  (kColorWithFloat(0x666666))   // 深灰
#define kColorGray                  (kColorWithFloat(0x999999))   // 中灰
#define kColorLightGray             (kColorWithFloat(0xb3b3b3))   // 浅灰


// 自定义Log
#ifdef DEBUG
#define NSLog(format, ...)  do{ \
fprintf(stderr, "<文件来源: %s : 第%d行>\n<当前方法: %s>\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],__LINE__, __func__); \
(NSLog)((@"\n"@"输出结果: "format), ##__VA_ARGS__); \
fprintf(stderr, "******************分界线*****************\n\n"); \
} while(0); \

#else
#define NSLog(format, ...)
#endif


#endif /* UIDefines_h */
