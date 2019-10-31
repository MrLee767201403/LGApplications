//
//  LGSwitch.h
//  Lit
//
//  Created by 李刚 on 2019/7/12.
//  Copyright © 2019 ligang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LGSwitch;

@protocol LGSwitchDelegate <NSObject>

@optional
- (void)switchValueChange:(LGSwitch *)mineSwitch on:(BOOL)on;

@end


/**  只有用户点击 才会出发事件 代码设置状态不触发事件*/
@interface LGSwitch : UIControl
/** 开关开启状态的顶部滑块颜色 默认是白色 */
@property (nonatomic, strong) UIColor *onTintColor;
/** 开关开启状态的底部背景颜色 默认是红色 */
@property (nonatomic, strong) UIColor *onBackgroundColor;
/** 开关关闭状态的顶部滑块颜色 默认是白色 */
@property (nonatomic, strong) UIColor *offTintColor;
/** 开关关闭状态的底部背景颜色 默认是灰色 */
@property (nonatomic, strong) UIColor *offBackgroundColor;
/** 开关的风格颜色 边框颜色 默认是白色 */
@property(nonatomic, strong) UIColor *tintColor;
/** 查看开关打开状态, 默认为关闭 */
@property (nonatomic, getter=isOn) BOOL on;

/** 设置开关状态, animated : 是否有动画 不响应事件，只有点击的时候才会响应 */
- (void)setOn:(BOOL)newOn animated:(BOOL)animated;

/** delegate */
@property (nonatomic, weak) id <LGSwitchDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
