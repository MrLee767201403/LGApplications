//
//  LGToastView.m
//  Trainee
//
//  Created by 李刚 on 2018/9/17.
//  Copyright © 2018年 Mr.Lee. All rights reserved.
//

#import "LGToastView.h"


@interface LGToastView ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) NSTimeInterval delay; // 默认2秒
@end



@implementation LGToastView

#pragma mark   -  便利初始化
+ (instancetype)showToastWithError:(NSString *)error{
    return [self showToastWithError:error afterDelay:1.5];
}
+ (instancetype)showToastWithSuccess:(NSString *)success{
    return [self showToastWithSuccess:success afterDelay:1.5];
}
+ (instancetype)showToastWithError:(NSString *)error afterDelay:(NSTimeInterval)delay{
    return [self showToastWithText:error image:Image(@"icon_error") afterDelay:delay];
}
+ (instancetype)showToastWithSuccess:(NSString *)success afterDelay:(NSTimeInterval)delay{
    return [self showToastWithText:success image:Image(@"icon_success") afterDelay:delay];
}

+ (instancetype)showToastWithText:(NSString *)text image:(UIImage *)image afterDelay:(NSTimeInterval)delay{
    return [[self alloc] initWithText:text image:image afterDelay:delay];
}


- (instancetype)initWithText:(NSString *)text image:(UIImage *)image afterDelay:(NSTimeInterval)delay
{
    self = [super init];
    if (self) {
        [self setUpSubviews];
        [self setText:text];
        [self setImage:image];
        [self setDelay:delay];
        [self show];
    }
    return self;
}

- (void)setUpSubviews{
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);

    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.66];
    self.contentView.layer.cornerRadius = 4;
    self.contentView.alpha = 0;
    self.iconView = [[UIImageView alloc] init];
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.font = kFontNormal;
    self.textLabel.textColor = kColorWhite;
    self.textLabel.numberOfLines = 0;

    [self addSubview:self.contentView];
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.textLabel];

    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-30);
        make.width.mas_lessThanOrEqualTo(kScreenWidth-(140*kScale));
        make.height.mas_greaterThanOrEqualTo(40);
    }];

    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.contentView).offset(12);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];

    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-20);
        make.top.equalTo(self.contentView).offset(10);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
}

- (void)setImage:(UIImage *)image{
    _image = image;
    _iconView.image = image;
}

- (void)setText:(NSString *)text{
    _text = text;
    _textLabel.text = text;
}


- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];

    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.alpha = 1;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:self.delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.contentView.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }];
}

@end
