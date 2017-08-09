//
//  UIImage+Extension.h
//  LGApplications
//
//  Created by 李刚 on 2017/6/7.
//  Copyright © 2017年 李刚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/**  纯色的图片*/
+ (UIImage *) imageWithColor:(UIColor *)color;

/**
 生成渐变色    UIImage实例对象
 colors      颜色数组
 rect        CGRect
 direction   方向
 */
+ (UIImage *)imageWithGradientColors:(NSArray *)colors rect:(CGRect)rect direction:(ColorDirection)direction;


/**
 *  生成圆角的图片
 *
 *  @param originImage 原始图片
 *  @param borderColor 边框原色
 *  @param borderWidth 边框宽度
 *
 *  @return 圆形图片
 */
+ (UIImage *)circleImage:(UIImage *)originImage borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;


/**
 *  生成一张高斯模糊的图片
 *
 *  @param image 原图
 *  @param blur  模糊程度 (0~1)
 *
 *  @return 高斯模糊图片
 */
+ (UIImage *)blurImage:(UIImage *)image blur:(CGFloat)blur;



/**
 *  生成原始的图片
 *
 *  @param image 图片名称
 *
 *  @return 原始图片
 */
+ (UIImage *)ImageByRenderingModeAlwaysOriginal:(UIImage *)image;

@end
