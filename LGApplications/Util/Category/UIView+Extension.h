//
//  UIView+Extension.h
//  FrameWork
//
//  Created by 李刚 on 17/5/9.
//  Copyright (c) 2017年 李刚. All rights reserved.
//


typedef enum {
    
    LeftToRight = 0,
    TopToBottom,
    
} ColorDirection;


#import <UIKit/UIKit.h>

@interface UIView (Extension)

/** Get the left point of a view. */
@property (nonatomic) CGFloat left;

/** Get the top point of a view. */
@property (nonatomic) CGFloat top;

/** Get the right point of a view. */
@property (nonatomic) CGFloat right;

/** Get the bottom point of a view. */
@property (nonatomic) CGFloat bottom;


@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGPoint origin;


/**  设置渐变色*/
- (void)setGradientColors:(NSArray *)colors direction:(ColorDirection)direction;

/**  移除所有子控件*/
- (void)removeAllSubviews;

@end
