//
//  LGInputView.m
//  LGApplications
//
//  Created by 李刚 on 2017/8/11.
//  Copyright © 2017年 李刚. All rights reserved.
//

#import "LGInputView.h"

// 默认高度
#define kBaseLineHeight  34.f
#define kMaxHeight       120.f

@interface LGInputView ()<UITextViewDelegate>
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, assign) CGFloat currentTextH;

@end

@implementation LGInputView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initCommon];
        [self setUpSubviews];
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initCommon];
        [self setUpSubviews];
    }
    return self;
}


/**  自己缺啥按钮可以往里加  比如切换语言,切换表情键盘 */
- (void)setUpSubviews{
    
    _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 7.5,  kScreenWidth-90.f, 18)];
    _placeholderLabel.font = _font;
    _placeholderLabel.text = _placeholder;
    _placeholderLabel.textColor = _placeholderColor;
    _placeholderLabel.numberOfLines = 0;
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 5, kScreenWidth-80.f, kBaseLineHeight)];
    _textView.delegate = self;
    _textView.scrollEnabled = NO;
    _textView.showsVerticalScrollIndicator = NO;
    _textView.showsHorizontalScrollIndicator = NO;
    _textView.font = _font;
    _textView.textColor = _textColor;
    _textView.layer.cornerRadius = 5;
    _textView.layer.masksToBounds = YES;
    _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _textView.layer.borderWidth = 1;
    
    [_textView addSubview:_placeholderLabel];
    [self addSubview:_textView];
    
    
    // 随便加个按钮看看
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(_textView.right+5, _textView.top+5, 55, 20)];
    [sendBtn setTitle:@"Send" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sendBtn];
    
}

- (void)send{
    self.text = @"发送成功";
}

- (void)initCommon{
    self.backgroundColor = [UIColor whiteColor];
    self.width = kScreenWidth;
    self.height = kBaseLineHeight + 10;
    
    _maxHeight = kMaxHeight;
    _currentTextH = kBaseLineHeight;
    _canNewLine = YES;
    
    _font = [UIFont systemFontOfSize:15];
    _text = nil;
    _textColor = [UIColor blackColor];
    _placeholder = @"请输入内容";
    _placeholderColor = [UIColor lightGrayColor];
    
    //监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];


}



#pragma mark   -  setter
- (void)setFont:(UIFont *)font{
    if (_font != font) {
        _font = font;
        _textView.font = font;
        _placeholderLabel.font = font;
        
        // 根据文字计算label的高度
        CGSize maxSize = CGSizeMake( _placeholderLabel.width, 120);
        CGSize placehoderSize = [_placeholder boundingRectWithSize:maxSize
                                                           options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                        attributes:@{NSFontAttributeName:_placeholderLabel.font}
                                                           context:nil].size;
        _placeholderLabel.height = placehoderSize.height;
    }
}


- (void)setText:(NSString *)text{
    if (_text != text) {
        _text = text;
        _textView.text = text;
        [self textViewDidChange:_textView];
    }
}

- (void)setTextColor:(UIColor *)textColor{
    if (_textColor != textColor) {
        _textColor = textColor;
        _textView.textColor = textColor;
    }
}

- (void)setPlaceholder:(NSString *)placeholder{
    if (_placeholder != placeholder) {
        _placeholder = placeholder;
        _placeholderLabel.text = placeholder;
        
        // 根据文字计算label的高度
        CGSize maxSize = CGSizeMake( _placeholderLabel.width, 120);
        CGSize placehoderSize = [_placeholder boundingRectWithSize:maxSize
                                                           options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                        attributes:@{NSFontAttributeName:_placeholderLabel.font}
                                                           context:nil].size;
        _placeholderLabel.height = placehoderSize.height;
    }
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    if (_placeholderColor != placeholderColor) {
        _placeholderColor = placeholderColor;
        _placeholderLabel.textColor = placeholderColor;
    }
}

#pragma mark   - UITextView 代理
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewShouldBeginEditing:)]) {
        return [self.delegate inputViewShouldBeginEditing:self];
    }
    return YES;
}


- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewShouldEndEditing:)]) {
        return [self.delegate inputViewShouldEndEditing:self];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewDidBeginEditing:)]) {
        [self.delegate inputViewDidBeginEditing:self];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewDidEndEditing:)]) {
        [self.delegate inputViewDidEndEditing:self];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSMutableString *string = [textView.text mutableCopy];
    [string replaceCharactersInRange:range withString:text];
    _placeholderLabel.hidden = string && string.length;
    
    // 不用允许换行
    if (_canNewLine == NO && [text isEqualToString:@"\n"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewDidTapReturn:)]) {
           [self.delegate inputViewDidTapReturn:self];
        }
        return NO;
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(inputView:shouldChangeTextInRange:replacementText:)])
    {
        return [self.delegate inputView:self shouldChangeTextInRange:range replacementText:text];
    }
    
    return  YES;
}
- (void)textViewDidChange:(UITextView *)textView{
   
    _placeholderLabel.hidden = textView.text && textView.text.length;
    _text = textView.text;
    [self adjustHeight];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewDidChange:)]) {
        [self.delegate inputViewDidChange:self];
    }
}

#pragma mark   - 文字改变
- (void)adjustHeight{
    
    // 计算文本的高度
    CGSize constraintSize;
    constraintSize.width = _textView.width-10;
    constraintSize.height = MAXFLOAT;
    CGFloat height = [_textView.text boundingRectWithSize:constraintSize
                                                  options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                               attributes:@{NSFontAttributeName:self.font}
                                                  context:nil].size.height + 16.f;
    
    CGFloat offset = 0;
    // 避免多次重复调用
    if (_currentTextH == height || (height > _maxHeight && _textView.scrollEnabled == YES)) {
        return;
    }
    else{
        offset = _currentTextH - height;
        _currentTextH = height;
    }
    
    // 默认高度
    if (height <= kBaseLineHeight) {
        height = kBaseLineHeight;
    }
    
    // 重新调整textView的高度
    if (height > _maxHeight) {
        _textView.height = _maxHeight;
        _textView.scrollEnabled = YES;
    }
    else{
        _textView.height = height;
        _textView.scrollEnabled = NO;
    }
    
    // 改变自身高度 并告诉代理做出相应调整
    [UIView animateWithDuration:0.1 animations:^{
        self.height = _textView.height + 10.f;
        self.y += offset;
    }];
    
    if ([self.delegate respondsToSelector:@selector(inputView:heightDidChange:)])
    {
        [self.delegate inputView:self heightDidChange:self.height];
    }
}


#pragma mark   -  键盘弹起退出
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect rect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:(UIViewAnimationCurve)[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue]];

    self.y = rect.origin.y - self.height -64;
    [UIView commitAnimations];
}

//
- (void)keyboardWillHide:(NSNotification *)notification
{

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:(UIViewAnimationCurve)[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue]];
    self.y = kScreenHeight - 64 - self.height;

    [UIView commitAnimations];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

@end
