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

@end
