//
//  UIButton+Extension
//  FrameWork
//
//  Created by 李刚 on 17/5/9.
//  Copyright (c) 2017年 李刚. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LGButtonEdgeInsetsStyle) {
    LGButtonEdgeInsetsStyleTop,     // image在上，label在下
    LGButtonEdgeInsetsStyleLeft,    // image在左，label在右
    LGButtonEdgeInsetsStyleBottom,  // image在下，label在上
    LGButtonEdgeInsetsStyleRight    // image在右，label在左
};

@interface UIButton (Extension)

/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(LGButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;


/**
 *  使用颜色设置按钮背景
 *  @param backgroundColor 背景颜色
 *  @param state           按钮状态
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

@end
