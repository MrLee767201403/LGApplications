//
//  LGToastView.m
//  FollowerTracker
//
//  Created by 李刚 on 2018/9/17.
//  Copyright © 2018年 Mr.Lee. All rights reserved.
//

#import "LGToastView.h"


@interface LGToastView ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) LGRefreshView *loadingView;

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) NSTimeInterval delay; // 默认1.5秒
@property (nonatomic, assign) NSInteger type;

@end



@implementation LGToastView

#pragma mark   -  Loading
/**  loading 显示在窗口*/
+ (instancetype)showLoading:(NSString *)text{
    if ([self loadingForView:kAppDelegate.window]) {
        return [self loadingForView:kAppDelegate.window];
    }
    else{
        LGToastView *toast = [[self alloc] initWithLoading:text];
        [kAppDelegate.window addSubview:toast];
        return toast;
    }
}

/**  loading 显示在View 导航栏可以操作*/
+ (instancetype)showLoadingInView:(NSString *)text{
    LGToastView *toast = [[self alloc] initWithLoading:text];
    [[NSUtil currentController].view addSubview:toast];
    return toast;
}

- (instancetype)initWithLoading:(NSString *)text
{
    self = [super init];
    if (self) {
        [self setUpSubviews];
        [self setText:text];
        self.contentView.alpha = 1;
        self.loadingView = [[LGRefreshView alloc] init];
        [self.loadingView beginRefresh];
        [self.contentView addSubview:self.loadingView];
        [self setLayoutWithType:2];

    }
    return self;
}

+ (void)hideToast{
    [NSUtil performBlockOnMainThread:^{
        [[self loadingForView:kAppDelegate.window] hideLoading];
        [[self loadingForView:[NSUtil currentController].view] hideLoading];
    }];
}

+ (LGToastView *)loadingForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (LGToastView *)subview;
        }
    }
    return nil;
}


- (void)hideLoading{
    if (self.type != 2) return;
    [self.loadingView endRefresh];
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        self.contentView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



#pragma mark   -  Toast
+ (instancetype)showToastWithError:(NSString *)error{
    return [self showToastWithError:error afterDelay:1.5];
}
+ (instancetype)showToastWithSuccess:(NSString *)success{
    return [self showToastWithSuccess:success afterDelay:1.5];
}
+ (instancetype)showToastWithError:(NSString *)error afterDelay:(NSTimeInterval)delay{
    return [self showToastWithText:error image:Image(@"toast_error") afterDelay:delay];
}
+ (instancetype)showToastWithSuccess:(NSString *)success afterDelay:(NSTimeInterval)delay{
    return [self showToastWithText:success image:Image(@"toast_success") afterDelay:delay];
}

+ (instancetype)showToastWithText:(NSString *)text image:(UIImage *)image afterDelay:(NSTimeInterval)delay{
    return [[self alloc] initWithText:text image:image afterDelay:delay];
}

- (instancetype)initWithText:(NSString *)text image:(UIImage *)image afterDelay:(NSTimeInterval)delay
{
    self = [super init];
    if (self) {
        [self setUpSubviews];
        [self setLayoutWithType:0];
        [self setText:text];
        [self setImage:image];
        [self setDelay:delay];
        [self show];
    }
    return self;
}



#pragma mark   - HUD
/**  带大图片 1.5秒自动消失*/
+ (instancetype)showSuccessWithMessage:(NSString *)message{
    return [[self alloc] initWithImage:Image(@"HUD_success") message:message];
}

+ (instancetype)showErrorWithMessage:(NSString *)message{
    return [[self alloc] initWithImage:Image(@"HUD_error") message:message];
}

+ (instancetype)showInfoWithMessage:(NSString *)message{
    return [[self alloc] initWithImage:Image(@"HUD_info") message:message];
}

+ (instancetype)showWarnWithMessage:(NSString *)message{
    return [[self alloc] initWithImage:Image(@"HUD_warn") message:message];
}

- (instancetype)initWithImage:(UIImage *)image message:(NSString *)message{

    self = [super init];
    if (self) {
        [self setUpSubviews];
        [self setLayoutWithType:1];
        [self setText:message];
        [self setImage:image];
        [self setDelay:1.5];
        [self show];
    }
    return self;
}

#pragma mark   - 布局
- (void)setUpSubviews{
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);

    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.66];
    self.contentView.layer.cornerRadius = 4;
    self.contentView.alpha = 0;
    self.iconView = [[UIImageView alloc] init];
    self.iconView.contentMode = UIViewContentModeCenter;

    self.textLabel = [[UILabel alloc] init];
    self.textLabel.font = kFontWithSize(14);
    self.textLabel.textColor = kColorWhite;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.numberOfLines = 0;

    [self addSubview:self.contentView];
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.textLabel];
}


- (void)setLayoutWithType:(NSInteger)type{

    _type = type;

    // 条形 小图
    if (type == 0) {
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
    // 方形 大图
    else if(type == 1){

        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-30);
            make.width.mas_lessThanOrEqualTo(kScreenWidth-(140*kScale));
            make.width.mas_greaterThanOrEqualTo(90);
            make.height.mas_greaterThanOrEqualTo(90);
        }];

        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(12);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];

        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(-20);
            make.top.equalTo(self.iconView.mas_bottom).offset(10);
            make.bottom.equalTo(self.contentView).offset(-20);
        }];
    }
    // loading
    else if(type == 2){
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-30);
            make.width.mas_lessThanOrEqualTo(kScreenWidth-(140*kScale));
            make.width.mas_greaterThanOrEqualTo(90);
            make.height.mas_greaterThanOrEqualTo(90);
        }];

        [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(self.text.length ? 12 : 20);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];

        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(-20);
            make.top.equalTo(self.loadingView.mas_bottom).offset(10);

            if (self.text.length) {
                make.bottom.equalTo(self.contentView).offset(-20);
            }
        }];
    }
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


#pragma mark   -  导航栏Tip
/**  导航栏顶部显示*/
+ (instancetype)showTipWithMessage:(NSString *)message{
    return [[self alloc] initTipWithMessage:message afterDelay:1.5];
}

+ (instancetype)showTipWithMessage:(NSString *)message afterDelay:(NSTimeInterval)delay{
    return [[self alloc] initTipWithMessage:message afterDelay:delay];
}

- (instancetype)initTipWithMessage:(NSString *)message afterDelay:(NSTimeInterval)delay{
    self = [super init];
    if (self) {

        self.frame = CGRectMake(0, -kNavBarHeight, kScreenWidth, kNavBarHeight);
        self.backgroundColor = kColorBlue;

        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, kStatusBarHeight, kScreenWidth-40, kNavBarHeight-kStatusBarHeight)];
        self.textLabel.font = kFontWithSize(14);
        self.textLabel.text = message;
        self.textLabel.textColor = kColorWhite;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.numberOfLines = 0;

        [self addSubview:self.textLabel];
        [[UIApplication sharedApplication].keyWindow addSubview:self];

        [UIView animateWithDuration:0.2 animations:^{
            self.top = 0;
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.top = -kNavBarHeight;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }];
    }
    return self;
}

@end
