//
//  UIDefines.h
//  FrameWork
//
//  Created by 李刚 on 2017/5/9.
//  Copyright © 2017年 李刚. All rights reserved.
//

#ifndef UIDefines_h
#define UIDefines_h

// 字体字号
#define kFontSmallMost          [UIFont systemFontOfSize:9]
#define kFontSmallMore          [UIFont systemFontOfSize:11]
#define kFontSmall              [UIFont systemFontOfSize:12]
#define kFontMiddle             [UIFont systemFontOfSize:13]
#define kFontLagre              [UIFont systemFontOfSize:15]
#define kFontLagreMore          [UIFont systemFontOfSize:16]
#define kFontLagreMost          [UIFont systemFontOfSize:18]

#define kFontNavigation         [UIFont fontWithName:@"Helvetica" size:16]




// 版本信息
#define kSystemVersion  [UIDevice.currentDevice.systemVersion floatValue]
#define iOS7Later       (kSystemVersion >= 7.0f)
#define iOS8Later       (kSystemVersion >= 8.0f)
#define iOS9Later       (kSystemVersion >= 9.0f)
#define iOS10Later      (kSystemVersion >= 10.0f)


// 获得屏幕宽高
#define kScreenWidth            [UIScreen mainScreen].bounds.size.width
#define kScreenHeight           [UIScreen mainScreen].bounds.size.height


// 屏幕frame,bounds,size,Application
#define kScreenFrame            [UIScreen mainScreen].bounds
#define kScreenBounds           [UIScreen mainScreen].bounds
#define kScreenSize             [UIScreen mainScreen].bounds.size
#define Application             [UIApplication sharedApplication]


// 手机型号
#define iphone4_3_5     ([UIScreen mainScreen].bounds.size.height<500.0f)
#define iphone5_4_0     ([UIScreen mainScreen].bounds.size.height==568.0f)
#define iphone6_4_7     ([UIScreen mainScreen].bounds.size.height==667.0f)
#define iphonePlus_5_5  ([UIScreen mainScreen].bounds.size.height==736.0f || [UIScreen mainScreen].bounds.size.height==414.0f)


// 获得RGB颜色
#define kColorWithRGB(r, g, b)          [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kColorRGBAlpha(r, g, b, a)      [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define kColorWithFloat(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]


// 主要颜色
#define kColorSeparator             (kColorWithFloat(0xeeeeee))   // 分割线
#define kColorHighlighted           (kColorWithFloat(0xf2f2f2))
#define kColorBackground            (kColorWithFloat(0xf3f3f3))   // 界面背景色
//#define kColorMainTheme             (kColorWithFloat(0xfc3050))   // 界面背景色
#define kColorMainTheme             (kColorWithFloat(0x00a79a))   // 界面背景色


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
