//
//  TextViewCell.m
//  Trainee
//
//  Created by 李刚 on 2018/5/9.
//  Copyright © 2018年 Mr.Lee. All rights reserved.
//

#import "TextViewCell.h"


@interface TextViewCell ()<UITextViewDelegate>
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) MASConstraint *lineRightConstraint;
@end

@implementation TextViewCell



- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.masksToBounds = YES;
        [self setUpSubviews];
    }
    return self;
}

- (void)setUpSubviews{
    
    self.backgroundColor = [UIColor whiteColor];
    
    _line = [[UIView alloc] init];
    _line.backgroundColor = kColorSeparator;

    _iconView = [[UIImageView alloc] init];
    _iconView.contentMode = UIViewContentModeCenter;
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = kFontNormal;
    _nameLabel.textColor = kColorDark;
    
    _textView = [[LGTextView alloc] init];
    _textView.font = kFontNormal;
    _textView.textColor = kColorDark;
    _textView.placeholderColor = kColorGray;
    _textView.textAlignment = NSTextAlignmentRight;
    _textView.scrollEnabled = NO;
    
    [self addSubview:_line];
    [self addSubview:_iconView];
    [self addSubview:_nameLabel];
    [self addSubview:_textView];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.bottom.equalTo(self);
        make.right.equalTo(self).offset(-10);
        make.height.mas_offset(0.7);
    }];
    
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(19);
        make.top.equalTo(self).offset(20);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(52);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self).offset(20);
        make.height.mas_equalTo(20);
    }];

    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(48.5);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(_nameLabel).offset(-7);
        make.bottom.equalTo(self).offset(-8);
    }];
}

- (void)setIcon:(UIImage *)icon{
    _icon = icon;
    _iconView.image = icon;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _nameLabel.text = title;
    
    CGFloat width = [title sizeWithAttributes:@{NSFontAttributeName:kFontNormal}].width+1;
    
    if (title.length == 0) {
        [_textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(48.5);
        }];
    }
    else{
        [_textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(width+62);
        }];
    }
    
    if (width > kScreenWidth - 80) {
        [_textView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nameLabel.mas_bottom).offset(3);
            make.left.equalTo(self).offset(48.5);
            make.right.equalTo(self).offset(-15);
            make.bottom.equalTo(self).offset(-8);
        }];
    }
}

- (void)setAttributeTitle:(NSAttributedString *)attributeTitle{
    _attributeTitle = attributeTitle.mutableCopy;
    _nameLabel.attributedText = attributeTitle;
    _textView.hidden = YES;
}

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    _textView.placeholder = placeholder;
}

- (void)setContent:(NSString *)content{
    _textView.text = content;
}

- (void)setLineRight:(CGFloat)lineRight{
    _lineRight = lineRight;
    _lineRightConstraint.offset = -lineRight;
}

- (NSString *)content{
    return _textView.text;
}


+ (instancetype)textCellWithIcon:(UIImage *)icon
                           title:(NSString *)title
                      placeholder:(NSString *)placeholder
                          content:(NSString *)content{
    
    TextViewCell *cell = [[TextViewCell alloc] init];
    cell.title = title;
    cell.placeholder = placeholder;
    cell.content = content;
    cell.icon = icon;
    
    return cell;
}

@end
