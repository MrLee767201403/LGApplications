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
    UIView *_line;
    
    LGAlertBlack _cancelHandle;
    LGAlertBlack _confirmHandle;
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
    
    CGFloat height = [_content boundingRectWithSize:CGSizeMake(260, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFontLagre} context:nil].size.height+1;
    
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    self.alpha = 0;
    
    
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.cornerRadius = 8;
    _contentView.layer.masksToBounds = YES;
    _contentView.transform = CGAffineTransformMakeScale(0.05, 0.05);
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = kFontMiddle;
    _titleLabel.textColor = kColorWithFloat(0xbebcc5);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = kFontLagre;
    _contentLabel.textColor = kColorWithFloat(0x8d8c92);
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.numberOfLines = 0;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kColorSeparator;
    
    _closeButton = [[UIButton alloc] init];
    _closeButton.titleLabel.font = kFontLagre;
    [_closeButton setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    [_closeButton setTitleColor:kColorMainTheme forState:UIControlStateNormal];
    [_closeButton setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(colseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_contentView];
    [_contentView addSubview:_titleLabel];
    [_contentView addSubview:_contentLabel];
    [_contentView addSubview:line];
    [_contentView addSubview:_closeButton];
    
    // 确认按钮
    if (_confirmTitle) {
        
        _line = [[UIView alloc] init];
        _line.backgroundColor = kColorSeparator;
        
        _confirmButton = [[UIButton alloc] init];
        _confirmButton.titleLabel.font = kFontLagre;
        [_confirmButton setTitle:_confirmTitle forState:UIControlStateNormal];
        [_closeButton setTitleColor:kColorMainTheme forState:UIControlStateNormal];
        [_confirmButton setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
        [_confirmButton addTarget:self
                           action:@selector(confirmButtonClick)
                 forControlEvents:UIControlEventTouchUpInside];
       
        [_contentView addSubview:_line];
        [_contentView addSubview:_confirmButton];
    }
    
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(280, height + 100.f));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentView).offset(20);
        make.left.right.equalTo(_contentView);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(15);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(260);
        make.centerX.equalTo(_contentView);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentLabel.mas_bottom).offset(15);
        make.left.equalTo(_contentView).offset(18);
        make.right.equalTo(_contentView).offset(-18);
        make.height.mas_equalTo(1.0);
    }];
    
    if (_confirmButton) {
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom);
            make.bottom.equalTo(_contentView);
            make.left.equalTo(_contentView);
            make.width.mas_equalTo(140);
        }];
        
        [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom);
            make.bottom.equalTo(_contentView);
            make.left.equalTo(_closeButton.mas_right);
            make.width.mas_equalTo(140);
        }];
        
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_closeButton.mas_right);
            make.width.mas_equalTo(1);
            make.centerY.equalTo(_closeButton);
            make.height.mas_equalTo(20);
        }];
    }
    else{
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom);
            make.bottom.equalTo(_contentView);
            make.centerX.equalTo(_contentView);
        }];
    }
    
    _titleLabel.text = _title;
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
    [self disMiss];
}

- (void)setCancelBlack:(LGAlertBlack)handle{
    _cancelHandle = handle;
}

- (void)setConfirmBlack:(LGAlertBlack)handle{
    _confirmHandle = handle;
}

#pragma mark   -  Setter Method
- (void)setCancelTitle:(NSString *)cancelTitle{
    _cancelTitle = cancelTitle;
    [_closeButton setTitle:cancelTitle forState:UIControlStateNormal];
}


@end
