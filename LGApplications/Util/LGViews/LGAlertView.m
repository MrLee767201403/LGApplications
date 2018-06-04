//
//  LGAlertView.m
//  IQTest
//
//  Created by 李刚 on 2017/7/19.
//  Copyright © 2017年 Mr.Lee. All rights reserved.
//

#import "LGAlertView.h"
@implementation LGAlertView
{
    UIView *_contentView;
    UILabel *_titleLabel;
    UILabel *_contentLabel;
    
    NSString *_content;
    NSString *_title;
    
    UIButton *_closeButton;
    UIButton *_confirmButton;
    NSString *_confirmTitle;    // 如果有Title 就显示两个按钮, 没有显示一个
    
    LGAlertBlock _cancelHandle;
    LGAlertBlock _confirmHandle;
}

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content confirmTitle:(NSString *)confirmTitle;
{
    self = [super init];
    if (self) {
        _title = title;
        _content = content;
        _confirmTitle = confirmTitle;
        [self setUpSubViews];
        
    }
    return self;
}

- (void)setUpSubViews{
    
    CGFloat height = [_content boundingRectWithSize:CGSizeMake(kScreenWidth-160, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFontLagre} context:nil].size.height+1;
    
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    self.alpha = 0;
    
    
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.cornerRadius = 8;
    _contentView.layer.masksToBounds = YES;
    _contentView.transform = CGAffineTransformMakeScale(0.05, 0.05);
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = kFontSmall;
    _titleLabel.text = _title;
    _titleLabel.textColor = kColorText;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = kFontLagre;
    _contentLabel.textColor = kColorText;
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.numberOfLines = 0;
    
    
    _closeButton = [[UIButton alloc] init];
    _closeButton.titleLabel.font = kFontMiddle;
    _closeButton.layer.cornerRadius = 5;
    _closeButton.layer.masksToBounds = YES;
    [_closeButton setTitle:@"取消" forState:UIControlStateNormal];
    [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_closeButton setBackgroundColor:kColorDisable forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(colseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_contentView];
    [_contentView addSubview:_titleLabel];
    [_contentView addSubview:_contentLabel];
    [_contentView addSubview:_closeButton];
    
    // 确认按钮
    if (_confirmTitle) {
        
        _confirmButton = [[UIButton alloc] init];
        _confirmButton.titleLabel.font = kFontMiddle;
        _confirmButton.layer.cornerRadius = 5;
        _confirmButton.layer.masksToBounds = YES;
        [_confirmButton setTitle:_confirmTitle forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton setBackgroundColor:kColorMainTheme forState:UIControlStateNormal];
        [_confirmButton setBackgroundColor:kColorButtonHL forState:UIControlStateHighlighted];
        
        [_confirmButton addTarget:self
                           action:@selector(confirmButtonClick)
                 forControlEvents:UIControlEventTouchUpInside];
        
        [_contentView addSubview:_confirmButton];
    }
    
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(kScreenWidth-110);
        make.height.mas_greaterThanOrEqualTo(height + 110.f);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentView).offset(20);
        make.left.right.equalTo(_contentView);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(kScreenWidth-160);
        make.centerX.equalTo(_contentView);
    }];
    
    if (_confirmButton) {
        [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentLabel.mas_bottom).offset(30);
            make.bottom.equalTo(_contentView).offset(-18);
            make.left.equalTo(_contentLabel);
            make.right.equalTo(_contentView.mas_centerX).offset(-8);
            make.height.mas_equalTo(35);
        }];
        
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_confirmButton);
            make.bottom.equalTo(_confirmButton);
            make.left.equalTo(_contentView.mas_centerX).offset(8);
            make.right.equalTo(_contentLabel);
            make.height.mas_equalTo(35);
        }];
        
    }
    else{
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentLabel.mas_bottom).offset(30);
            make.bottom.equalTo(_contentView).offset(-18);
            make.left.right.equalTo(_contentLabel);
            make.height.mas_equalTo(35);
        }];
        
        [_closeButton setBackgroundColor:kColorMainTheme forState:UIControlStateNormal];
        [_closeButton setBackgroundColor:kColorButtonHL forState:UIControlStateHighlighted];
        
    }
    
    _contentLabel.text = _content;
}



#pragma mark   -  Method
- (void)colseButtonClick{
    [self disMiss];
    if (_cancelHandle) {
        _cancelHandle(_closeButton);
    }
}

- (void)confirmButtonClick{
    [self disMiss];
    if (_confirmHandle) {
        _confirmHandle(_confirmButton);
    }
}

- (void)show{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
        _contentView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}
- (void)disMiss{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        _contentView.transform = CGAffineTransformMakeScale(0.05, 0.05);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    // 拿到触摸点
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    // 触摸点相对于内容部分的位置
    point = [_contentView.layer convertPoint:point fromLayer:self.layer];
    // 如果触摸点不在内容部分 则让弹窗消失
    if (![_contentView.layer containsPoint:point]) {
        [self disMiss];
    }
}

- (void)setCancelBlock:(LGAlertBlock)handle{
    _cancelHandle = handle;
}

- (void)setConfirmBlock:(LGAlertBlock)handle{
    _confirmHandle = handle;
}

#pragma mark   -  Setter Method
- (void)setCancelTitle:(NSString *)cancelTitle{
    _cancelTitle = cancelTitle;
    [_closeButton setTitle:cancelTitle forState:UIControlStateNormal];
}

@end
