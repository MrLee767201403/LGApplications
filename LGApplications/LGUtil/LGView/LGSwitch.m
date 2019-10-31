//
//  LGSwitch.m
//  Lit
//
//  Created by 李刚 on 2019/7/12.
//  Copyright © 2019 ligang. All rights reserved.
//

#import "LGSwitch.h"
const CGFloat space = 3.3;

@interface LGSwitch ()
@property (nonatomic, strong) UIImageView *topView;
@property (nonatomic, strong) UIImageView *bottomView;
@end



@implementation LGSwitch

- (instancetype)init
{
    return [self initWithFrame:CGRectMake(0, 0, 30, 20)];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _on = NO;
        _onTintColor = kColorWhite;
        _onBackgroundColor = kColorRed;
        _offTintColor = kColorWhite;
        _offBackgroundColor = kColorWithFloat(0xACB8C7);
        _tintColor = kColorWhite;
        [self setUpSubviews];
    }
    return self;
}

- (void)setUpSubviews{

    self.layer.cornerRadius = self.height/2.0;
    self.layer.masksToBounds = YES;

    self.bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.topView = [[UIImageView alloc] initWithFrame:CGRectMake(space, space, self.height-2*space, self.height-2*space)];
    self.topView.layer.cornerRadius = self.topView.height/2.0;
    [self addSubview:self.bottomView];
    [self addSubview:self.topView];

    [self setSwitchColorWithStatus:_on];
}

- (void)setOn:(BOOL)newOn animated:(BOOL)animated userEvent:(BOOL)event{
    CGFloat newX = newOn ? self.width - self.topView.width - space: space;

    [UIView animateWithDuration:animated ? 0.2 : 0.0 animations:^{
        self.topView.x = newX;
        [self setSwitchColorWithStatus:newOn];
    }completion:^(BOOL finished) {

        // 初始化 || 设置不可以点击 不调相应的方法
        if (event == NO || self.enabled == NO || self.userInteractionEnabled == NO) {
            return ;
        }

        if (finished) {
            // delegate
            if ([self.delegate respondsToSelector:@selector(switchValueChange:on:)]) {
                [self.delegate switchValueChange:self on:newOn];
            }
            // action
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }];
    _on = newOn;
}

- (void)setOn:(BOOL)newOn animated:(BOOL)animated {
    [self setOn:newOn animated:animated userEvent:NO];
}

- (void)setOn:(BOOL)on{
    [self setOn:on animated:YES];
}

- (void)setSwitchColorWithStatus:(BOOL)on {
    self.bottomView.backgroundColor = on ? _onBackgroundColor : _offBackgroundColor;
    self.topView.backgroundColor = on ? _onTintColor : _offTintColor;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self setOn:!_on animated:YES userEvent:YES];
}

// 开关开启状态的顶部滑块颜色 默认是白色
- (void)setOnTintColor:(UIColor *)onTintColor {
    _onTintColor = onTintColor;
    [self setSwitchColorWithStatus:_on];
}

// 开关开启状态的底部背景颜色 默认是红色
- (void)setOnBackgroundColor:(UIColor *)onBackgroundColor {
    _onBackgroundColor = onBackgroundColor;
    [self setSwitchColorWithStatus:_on];
}

// 开关关闭状态的顶部滑块颜色 默认是白色
- (void)setOffTintColor:(UIColor *)offTintColor {
    _offTintColor = offTintColor;
    [self setSwitchColorWithStatus:_on];

}

// 开关关闭状态的底部背景颜色 默认是浅灰色
- (void)setOffBackgroundColor:(UIColor *)offBackgroundColor {
    _offBackgroundColor = offBackgroundColor;
    [self setSwitchColorWithStatus:_on];
}

//// 开关的风格颜色 边框颜色 默认是白色
//- (void)setTintColor:(UIColor *)tintColor {
//    _tintColor = tintColor;
//    self.topView.layer.borderColor = self.bottomView.layer.borderColor = tintColor.CGColor;
//    self.topView.layer.borderWidth = self.bottomView.layer.borderWidth = 0.5f;
//}


@end
