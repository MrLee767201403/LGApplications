//
//  UIDefines.h
//  FrameWork
//
//  Created by 李刚 on 2017/5/9.
//  Copyright © 2017年 李刚. All rights reserved.
//


#ifndef UIDefines_h
#define UIDefines_h


static NSString *kFontNamePingFangSCRegular = @"PingFangSC-Regular";
static NSString *kFontNamePingFangSCSemibold = @"PingFangSC-Semibold";
static NSString *kFontNamePingFangSCMedium = @"PingFangSC-Medium";
static NSString *kFontNamePingFangSCLight = @"PingFangSC-Light";


#define kBoldFontWithName(Name,F)    [NSUtil fontWithName:Name size:F bold:YES]
#define kFontWithName(Name,F)        [NSUtil fontWithName:Name size:F bold:NO]
#define kBoldFont(size)              [UIFont boldSystemFontOfSize:size]


#define kFontWithSize(F)        kFontWithName(kFontNamePingFangSCRegular, (F))
#define kFontNavigation         kFontWithName(kFontNamePingFangSCSemibold, 18)

#define Image(name)                 [UIImage imageNamed:name]
#define NSStringFormat(format,...)  [NSString stringWithFormat:format,##__VA_ARGS__]

// 版本信息
#define kSystemVersion  [UIDevice.currentDevice.systemVersion floatValue]
#define iOS9Later       (kSystemVersion >= 9.0f)
#define iOS10Later      (kSystemVersion >= 10.0f)
#define iOS11Later      (kSystemVersion >= 11.0f)
#define iOS12Later      (kSystemVersion >= 12.0f)

// 获得屏幕宽高
#define kStatusBarHeight        ([[UIApplication sharedApplication] statusBarFrame].size.height*1.0)
#define kScreenWidth            [UIScreen mainScreen].bounds.size.width
#define kScreenHeight           [UIScreen mainScreen].bounds.size.height
#define kNavBarHeight           (kStatusBarHeight + 44)
#define kBottomBarHeight        (kStatusBarHeight >20 ? 34.0 : 0)
#define kViewHeight             (kScreenHeight - kNavBarHeight)     // 除去导航栏View的高度
#define kContentHeight          (kViewHeight - kBottomBarHeight)    // 安全区的高度

#define kScaleH                 kScreenHeight/667.0
#define kScale                  kScreenWidth/375.0
#define kScaling(f)             kScale * f
#define kScales(f)              (iphonePlus_5_5 ?  1.1:1) * f  //   只针对Plus做缩放
/**  只针对小屏幕缩放*/
#define kScaleSmallH            (kScreenHeight<600 ?  kScale:1)
#define kScaleSmallW            (kScreenHeight<600 ?  kScale:1)

// UIApplication
#define kApplication            [UIApplication sharedApplication]
#define kAppDelegate            ((AppDelegate*)[[UIApplication sharedApplication] delegate])


// 手机型号
#define iphone4_3_5             (kScreenHeight<500)
#define iphone5_4_0             (kScreenHeight==568)
#define iphone6_4_7             (kScreenHeight==667)
#define iphonePlus_5_5          (kScreenHeight==736)
#define iphoneX                 (kStatusBarHeight>20)


// 获得RGB颜色
#define kColorWithRGB(r, g, b)          [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kColorRGBAlpha(r, g, b, a)      [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define kColorWithFloat(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]


// 主要颜色
#define kColorSeparator             (kColorWithFloat(0xE5E5E5))   // 分割线
#define kColorHighlighted           (kColorWithFloat(0xf2f2f2))   // Cell高亮
#define kColorDisable               (kColorWithFloat(0xC8C8C8))
#define kColorBackground            (kColorWithFloat(0xF8F8F8))   // 界面背景色
#define kColorMainTheme             (kColorWithFloat(0x5CD5A9))   // 主题色
#define kColorButtonHL              (kColorWithFloat(0x70c8a7))   // 主题高亮
#define kColorLink                  (kColorWithFloat(0x1da0fd))   // 链接

#define kColorGreen                 (kColorWithFloat(0x28b7a3))   // 绿色
#define kColorBlue                  (kColorWithFloat(0x1da0fd))   // 蓝色
#define kColorWhite                 (kColorWithFloat(0xFFFFFF))   // 白色
#define kColorRed                   (kColorWithFloat(0xFF4B6D))   // 红色
#define kColorDark                  (kColorWithFloat(0x323232))   // 暗黑
#define kColorText                  (kColorWithFloat(0x666666))   // 深灰
#define kColorGray                  (kColorWithFloat(0x828F9F))   // 中灰
#define kColorLightGray             (kColorWithFloat(0x999999))   // 亮灰


// 自定义Log
#ifdef DEBUG
#define LGLog(fmt, ...) NSLog((@"%s [Line %d] \n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define LGLog(...)
#endif


#endif /* UIDefines_h */
