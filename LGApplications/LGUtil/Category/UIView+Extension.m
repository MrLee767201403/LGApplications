//
//  UIView+Extension.h
//  FrameWork
//
//  Created by 李刚 on 17/5/9.
//  Copyright (c) 2017年 李刚. All rights reserved.
//


#import "UIView+Extension.h"

@implementation UIView (Extension)

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}


- (void)setOrigin:(CGPoint)origin
{
  
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}


/**  设置渐变色*/
- (void)setGradientColors:(NSArray *)colors direction:(ColorDirection)direction
{
    CGRect rect = CGRectMake(0, 0, self.width, self.height);
    
    CGPoint point0, point1;
    point0 = CGPointMake(0, 0);
    switch (direction) {
        case LeftToRight:
        {
            point1 = CGPointMake(1, 0);
            break;
        }
        case TopToBottom:
        {
            point1 = CGPointMake(0, 1);
            break;
        }
        default:
            break;
    }
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = colors;
    gradientLayer.locations = @[@0, @1.0];
    gradientLayer.startPoint = point0;
    gradientLayer.endPoint = point1;
    gradientLayer.frame = rect;
    [self.layer addSublayer:gradientLayer];
    
}

/**  移除所有子控件*/
- (void)removeAllSubviews
{
    while (self.subviews.count > 0)
    {
        UIView *child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

@end
