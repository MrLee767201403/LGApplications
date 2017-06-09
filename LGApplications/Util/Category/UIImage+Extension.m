//
//  UIImage+Extension.m
//  LGApplications
//
//  Created by 李刚 on 2017/6/7.
//  Copyright © 2017年 李刚. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)


+ (UIImage *) imageWithColor:(UIColor *)color{
    
    CGSize size = CGSizeMake(1, 1);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


+ (UIImage *)imageWithGradientColors:(NSArray *)colors rect:(CGRect)rect direction:(ColorDirection)direction
{
    //创建CGContextRef
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //创建CGMutablePathRef
    CGMutablePathRef path = CGPathCreateMutable();
    
    //绘制Path
    CGPathMoveToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMidX(rect), CGRectGetMaxY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect), CGRectGetMaxY(rect));
    CGPathCloseSubpath(path);
    
    //绘制渐变
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0.0, 1.0};
    
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
    
    
    //具体方向可根据需求修改
    CGPoint startPoint,endPoint;
    switch (direction) {
        case LeftToRight:
        {
            startPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
            endPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
            break;
        }
        case TopToBottom:
        {
            startPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
            endPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
            break;
        }
        default:
            break;
    }
    
    CGContextSaveGState(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    //释放CGMutablePathRef
    CGPathRelease(path);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

@end
