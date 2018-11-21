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
    UILabel *_contentLabel;
    UILabel *_titleLabel;
    UIButton *_noButton;
    UIButton *_okButton;
    UIView *_line1;
    UIView *_line2;

    NSString *_content;
}

- (instancetype)initWithContent:(NSString *)content
{
    self = [super init];
    if (self) {
        _content = content;
        _title = @"提示";
        _yesTitle = @"确定";
        _noTitle = @"取消";
        [self setUpSubViews];

    }
    return self;
}

- (void)setUpSubViews{

    CGFloat height = [_content boundingRectWithSize:CGSizeMake(kScreenWidth-134, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFontLagre} context:nil].size.height+1;

    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    self.alpha = 0;


    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.transform = CGAffineTransformMakeScale(0.05, 0.05);
    _contentView.layer.cornerRadius = 6;
    _contentView.clipsToBounds = YES;

    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, kScreenWidth-134, 19)];
    _titleLabel.font = kFontWithName(kFontNamePingFangSCSemibold, 18);
    _titleLabel.text = _title;
    _titleLabel.textColor = kColorDark;
    _titleLabel.textAlignment = NSTextAlignmentCenter;

    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = kFontNormal;
    _contentLabel.text = _content;
    _contentLabel.textColor = kColorDark;
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.numberOfLines = 0;


    _noButton = [[UIButton alloc] init];
    _noButton.titleLabel.font = kFontLagre;
    [_noButton setTitle:_noTitle forState:UIControlStateNormal];
    [_noButton setTitleColor:kColorDark forState:UIControlStateNormal];
    [_noButton addTarget:self action:@selector(noButtonClick) forControlEvents:UIControlEventTouchUpInside];

    _okButton = [[UIButton alloc] init];
    _okButton.titleLabel.font = kFontLagre;
    [_okButton setTitle:_yesTitle forState:UIControlStateNormal];
    [_okButton setTitleColor:kColorMainTheme forState:UIControlStateNormal];
    [_okButton addTarget:self action:@selector(okButtonClick) forControlEvents:UIControlEventTouchUpInside];

    _line1 = [[UIView alloc] init];
    _line1.backgroundColor = kColorSeparator;

    _line2 = [[UIView alloc] init];
    _line2.backgroundColor = kColorSeparator;

    [self addSubview:_contentView];
    [_contentView addSubview:_titleLabel];
    [_contentView addSubview:_contentLabel];
    [_contentView addSubview:_okButton];
    [_contentView addSubview:_noButton];
    [_contentView addSubview:_line1];
    [_contentView addSubview:_line2];


    CGFloat contentH = height + 77;
    contentH = contentH < 120 ? 120 : contentH;
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(kScreenWidth-104);
        make.height.mas_greaterThanOrEqualTo(contentH);
    }];

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(15);
        make.right.equalTo(_contentView).offset(-15);
        make.top.equalTo(_contentView).offset(20);
        make.height.mas_equalTo(19);
    }];

    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentView).offset(57);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(kScreenWidth-134);
        make.centerX.equalTo(_contentView);
    }];

    [_noButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.equalTo(_contentView);
        make.top.equalTo(_contentLabel.mas_bottom).offset(20);
        make.right.equalTo(_contentView.mas_centerX);
        make.height.mas_equalTo(45);
    }];

    [_okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(_contentView);
        make.top.equalTo(_contentLabel.mas_bottom).offset(20);
        make.left.equalTo(_contentView.mas_centerX);
        make.height.mas_equalTo(45);
    }];

    [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_contentView);
        make.bottom.equalTo(_contentView).offset(-45.5);
        make.height.mas_equalTo(0.5);
    }];

    [_line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.equalTo(_contentView);
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(45);
    }];
}

- (void)setSingleButton:(BOOL)singleButton{
    _singleButton = singleButton;

    if (singleButton == YES) {
        [_okButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.left.equalTo(_contentView);
            make.top.equalTo(_contentLabel.mas_bottom).offset(20);
            make.height.mas_equalTo(45);
        }];

        _noButton.hidden = YES;
        _line2.hidden = YES;
    }
}


- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLabel.text = title;
}

- (void)setYesTitle:(NSString *)yesTitle{
    _yesTitle = yesTitle;
    [_okButton setTitle:yesTitle forState:UIControlStateNormal];
}


- (void)setNoTitle:(NSString *)noTitle{
    _noTitle = noTitle;
    [_noButton setTitle:noTitle forState:UIControlStateNormal];
}


- (void)setAlignment:(NSTextAlignment)alignment{
    _alignment = alignment;
    _contentLabel.textAlignment = alignment;
}

#pragma mark   -  Method
- (void)noButtonClick{
    [self disMiss];
    if (_noHandle) {
        _noHandle();
    }
}

- (void)okButtonClick{
    [self disMiss];
    if (_yesHandle) {
        _yesHandle();
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

@end
