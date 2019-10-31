//
//  LGGradientLabel.m
//  LGApplications
//
//  Created by 李刚 on 2017/6/9.
//  Copyright © 2017年 李刚. All rights reserved.
//

#import "LGGradientLabel.h"

/*
 思路: 把label的文字画到context上去(画文字的作用主要是设置 layer 的mask)
      还有一种方法是 CAGradientLayer 设置渐变图层,不需要自定义Label,但是每次使用都得写一堆,有兴趣的可以自己搜,网上很多的
 
 */

@implementation LGGradientLabel

- (void)drawRect:(CGRect)rect
{
    
    NSLog(@"%@",NSStringFromCGRect(rect));
    
    // 拿到文字Rect
    CGSize textSize = [self.text sizeWithAttributes:@{NSFontAttributeName : self.font}];
    CGRect textRect = (CGRect){0, 0, textSize};
    
    NSLog(@"textRect:%@",NSStringFromCGRect(rect));

    // 画文字
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.textColor set];
    [self.text drawWithRect:rect options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.font} context:nil];
    
    // 坐标
    CGContextTranslateCTM(context, 0.0f, rect.size.height - (rect.size.height - textSize.height) * 0.5);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    
    CGImageRef alphaMask = NULL;
    alphaMask = CGBitmapContextCreateImage(context);
    
    // 清除之前画的文字
    CGContextClearRect(context, rect);
    
    // 设置mask
    CGContextClipToMask(context, rect, alphaMask);
    
    // 翻转坐标,画渐变色
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)self.colors, nil);
    CGPoint startPoint = CGPointMake(textRect.origin.x,
                                     textRect.origin.y);
    CGPoint endPoint = CGPointMake(textRect.origin.x + textRect.size.width,
                                   textRect.origin.y + textRect.size.height);
    if(self.direction == TopToBottom)
    {
        endPoint = CGPointMake(textRect.origin.x, textRect.origin.y + textRect.size.height);
    }
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    // 释放内存
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    CFRelease(alphaMask);
}

@end
