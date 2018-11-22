//
//  CommonCell.m
//  Trainee
//
//  Created by 李刚 on 2018/5/9.
//  Copyright © 2018年 Mr.Lee. All rights reserved.
//

#import "CommonCell.h"

@interface CommonCell ()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIImageView *accessView;
@property (nonatomic, strong) UILabel *titleView;
@property (nonatomic, strong) UILabel *detailView;
@property (nonatomic, strong) id target;
@property (nonatomic, assign) SEL actoin;

@property (nonatomic, strong) MASConstraint *titleW;
@property (nonatomic, strong) MASConstraint *titleLeft;
@property (nonatomic, strong) MASConstraint *detailRight;

@end


@implementation CommonCell

+ (instancetype)cellWithTop:(CGFloat)top icon:(UIImage *)icon title:(NSString *)title{
    return [self cellWithTop:top icon:icon title:title target:nil action:nil];
}
+ (instancetype)cellWithTop:(CGFloat)top icon:(UIImage *)icon title:(NSString *)title target:(id)target action:(SEL)action{
    return  [[self alloc] initWithTop:top icon:icon title:title target:target action:action];
}

- (instancetype)initWithTop:(CGFloat)top icon:(UIImage *)icon title:(NSString *)title target:(id)target action:(SEL)action{
    self = [super initWithFrame:CGRectMake(0, top, kScreenWidth, 60)];
    if (self) {
        if (target && action) {
            [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        }
        _icon = icon;
        _title = title;
        _target = target;
        _actoin = action;
        [self setUpSubviews];
    }
    return self;
}

- (void)setUpSubviews{
    self.backgroundColor = [UIColor whiteColor];
    [self setBackgroundColor:kColorHighlighted forState:UIControlStateHighlighted];

    CGFloat titleW = [self.title sizeWithAttributes:@{NSFontAttributeName:kFontNormal}].width+1;
    
    self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(19, 20, 22, 22)];
    self.iconView.image = self.icon;
    
    self.titleView = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, 60, 20)];
    self.titleView.font = kFontNormal;
    self.titleView.text = self.title;
    self.titleView.textColor = kColorDark;
    
    self.detailView = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, self.width-60, 20)];
    self.detailView.font = kFontNormal;
    self.detailView.textColor = kColorGray;
    self.detailView.textAlignment = NSTextAlignmentRight;

    self.accessView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width-35, 20, 15, 20)];
    self.accessView.image = Image(@"icon_right");
    self.accessView.hidden = !(self.target && self.actoin);
    self.accessView.contentMode = UIViewContentModeCenter;
    
    self.line = [[UIView alloc] initWithFrame:CGRectMake(0, 53.3, self.width, 0.7)];
    self.line.backgroundColor = kColorSeparator;
    
    [self addSubview:self.iconView];
    [self addSubview:self.titleView];
    [self addSubview:self.detailView];
    [self addSubview:self.accessView];
    [self addSubview:self.line];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        _titleLeft = make.left.equalTo(self).offset(self.icon?52:20);
        make.centerY.equalTo(self);
        _titleW = make.width.mas_equalTo(titleW);
    }];
    
    [self.accessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.size.mas_equalTo(CGSizeMake(15, 20));
        make.centerY.equalTo(self);
    }];
    
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleView.mas_right).offset(10);
        make.top.equalTo(self).offset(10);
        make.centerY.equalTo(self);
        _detailRight = make.right.equalTo(self).offset(-20);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.height.mas_equalTo(0.7);
    }];
    
}

- (void)setTitle:(NSString *)title{
    CGFloat titleW = [title sizeWithAttributes:@{NSFontAttributeName:kFontNormal}].width+1;
    _title = title;
    _titleView.text = title;
    _titleW.mas_equalTo(titleW);

}

- (void)setIcon:(UIImage *)icon{
    _icon = icon;
    _iconView.image = icon;
    _titleLeft.offset(icon?40:0);
}

- (void)setDetail:(NSString *)detail{
    _detail = detail;
    _detailView.text = detail;
    
    if (detail.length) self.showAccessView = NO;
}

- (void)setShowAccessView:(BOOL)showAccessView{
    _showAccessView = showAccessView;
    _accessView.hidden = !showAccessView;
    _detailRight.offset = showAccessView ? -40 : -20;
}

- (void)setDetailColor:(UIColor *)detailColor{
    _detailColor = detailColor;
    _detailView.textColor = detailColor;
}
@end
