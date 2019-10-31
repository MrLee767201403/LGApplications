//
//  LGTextView.m
//  LGApplications
//
//  Created by 李刚 on 2017/5/9.
//  Copyright © 2017年 李刚. All rights reserved.
//

#import "LGTextView.h"

@implementation LGTextView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpPlaceholderLabel];
        [self addObserver];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpPlaceholderLabel];
        [self addObserver];
    }
    return self;
}

- (void)addObserver{
    // 当用户通过键盘修改了self的文字，self就会自动发出一个UITextViewTextDidChangeNotification通知
    // 一旦发出上面的通知，就会调用self的textDidChange方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
}

- (void)setUpPlaceholderLabel{
    
    _placeholderLabel = [[UILabel alloc] init];
    _placeholderLabel.numberOfLines = 0;
    _placeholderLabel.backgroundColor = [UIColor clearColor];
    
    
    // 默认字体 颜色
    _placeholderLabel.textColor = [UIColor lightGrayColor];
    _placeholderLabel.font = [UIFont systemFontOfSize:12];

    [self addSubview:_placeholderLabel];
    
}



- (void)setPlaceholder:(NSString *)placeholder{
    
    _placeholder = [placeholder copy];
    _placeholderLabel.text = placeholder;
    [self setNeedsLayout];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    _placeholderLabel.textColor = placeholderColor;
}

/**  修改字体后重新设置placeholderLabel*/
- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    _placeholderLabel.font = font;
    [self setNeedsLayout];
}


/**  textView文字修改 显示或隐藏placeholderLabel*/
- (void)setText:(NSString *)text
{
    [super setText:text];
    [self textDidChange];
}


/**   重新计算子控件的fame*/
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _placeholderLabel.y = 7.5;
    _placeholderLabel.x = 5;
     _placeholderLabel.width = self.width - 2 *  _placeholderLabel.x;
    // 根据文字计算label的高度
    CGSize maxSize = CGSizeMake( _placeholderLabel.width, MAXFLOAT);
    CGSize placehoderSize = [_placeholder boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_placeholderLabel.font} context:nil].size;
    _placeholderLabel.height = placehoderSize.height;
    
    [_placeholderLabel.text sizeWithAttributes:@{NSFontAttributeName:_placeholderLabel.font}];
}



- (void)textDidChange{
    _placeholderLabel.hidden = (self.text.length != 0);
}
@end
