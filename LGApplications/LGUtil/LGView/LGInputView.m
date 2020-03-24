//
//  LGInputView.m
//  LGApplications
//
//  Created by 李刚 on 2017/8/11.
//  Copyright © 2017年 李刚. All rights reserved.
//

#import "LGInputView.h"

// 默认高度
#define kBaseLineHeight  25
#define kMaxHeight       120.f

@interface LGInputView ()<UITextViewDelegate>
@property (nonatomic, assign) CGFloat currentTextH;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIButton *sendButton;

@end

@implementation LGInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initCommon];
        [self setUpSubviews];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectMake(0, kContentHeight-50, kScreenWidth, 50)];
}


/**  自己缺啥按钮可以往里加  比如切换语言,切换表情键盘 */
- (void)setUpSubviews{
    self.backgroundColor = kColorWhite;

    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(47, 5, kScreenWidth-62, 40)];
    self.contentView.backgroundColor = kColorWithFloat(0xF6F7F9);
    self.contentView.layer.cornerRadius = 19;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.borderColor = kColorWithFloat(0xDDE3E9).CGColor;
    self.contentView.layer.borderWidth = 0.5;

    _textView = [[LGTextView alloc] initWithFrame:CGRectMake(10, 5, kScreenWidth-115, 25)];
    self.textView.backgroundColor = kColorBackground;
    self.textView.delegate = self;
    self.textView.scrollEnabled = NO;
    self.textView.showsVerticalScrollIndicator = NO;
    self.textView.showsHorizontalScrollIndicator = NO;
    self.textView.textContainerInset = UIEdgeInsetsMake(7, 0, 4, 0);
    self.textView.font = kFontWithSize(16);
    self.textView.textColor = kColorDark;
    self.textView.placeholder = @"Input a Message";
    self.textView.placeholderColor = kColorGray;


    _imageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 47, 50)];
    [self.imageButton setImage:Image(@"input_image") forState:UIControlStateNormal];
    [self.imageButton addTarget:self action:@selector(imageButtonEvent) forControlEvents:UIControlEventTouchUpInside];

//    _emojiButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 38)];
//    [self.emojiButton setImage:Image(@"input_emoji") forState:UIControlStateNormal];
//    [self.emojiButton setImage:Image(@"input_keyboard") forState:UIControlStateSelected];
//    [self.emojiButton addTarget:self action:@selector(emojiButtonEvent:) forControlEvents:UIControlEventTouchUpInside];

    self.sendButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-115, 0, 53, 38)];
    [self.sendButton setImage:Image(@"input_send") forState:UIControlStateNormal];
    [self.sendButton addTarget:self action:@selector(sendButtonEvent) forControlEvents:UIControlEventTouchUpInside];

//    [self.contentView addSubview:self.emojiButton];
    [self.contentView addSubview:self.textView];
    [self.contentView addSubview:self.sendButton];
    [self addSubview:self.imageButton];
    [self addSubview:self.contentView];

    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(47);
        make.top.equalTo(self).offset(5);
        make.bottom.equalTo(self).offset(-5);
        make.width.mas_equalTo(kScreenWidth - 62);
        make.height.mas_lessThanOrEqualTo(self.maxHeight+10);
    }];

    [self.imageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.width.mas_equalTo(47);
        make.height.mas_equalTo(50);
    }];

//    [self.emojiButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.bottom.equalTo(self.contentView);
//        make.width.mas_equalTo(40);
//        make.height.mas_equalTo(38);
//    }];

    // contentView高40, 16号字下 textView一行的高度大概40
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.width.mas_equalTo(kScreenWidth-115);
        make.top.equalTo(self.contentView).offset(3);
        make.bottom.equalTo(self.contentView);
    }];

    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(38);
        make.width.mas_equalTo(53);
    }];

}

- (void)sendButtonEvent{
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputView:didSendMessage:)] && self.textView.text) {
        [self.delegate inputView:self didSendMessage:self.textView.text];
    }
    self.textView.text = nil;
    [self textViewDidChange:self.textView];
}

- (void)imageButtonEvent{
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewDidTapImage:)]) {
        [self.delegate inputViewDidTapImage:self];
    }
}

- (void)emojiButtonEvent:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputView:didTapEmoji:)]) {
        [self.delegate inputView:self didTapEmoji:sender.selected];
    }
}

- (void)initCommon{
    self.backgroundColor = [UIColor whiteColor];
    
    _maxHeight = kMaxHeight;
    _currentTextH = kBaseLineHeight;
    _canNewLine = YES;
    _trackKeyboard = YES;

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
        _textView.placeholder = placeholder;
    }
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    if (_placeholderColor != placeholderColor) {
        _placeholderColor = placeholderColor;
        _textView.placeholderColor = placeholderColor;
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
    // 不用允许换行
    if (_canNewLine == NO && [text isEqualToString:@"\n"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewDidTapReturn:)]) {
            [self.delegate inputViewDidTapReturn:self];

            self.textView.text = nil;
            [self textViewDidChange:self.textView];
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
   
    _text = textView.text;
    [self adjustHeight];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewDidChange:)]) {
        [self.delegate inputViewDidChange:self];
    }
}


- (BOOL)becomeFirstResponder{
    return [self.textView becomeFirstResponder];
}
#pragma mark   - 文字改变
- (void)adjustHeight{
    
    // 计算文本的高度
    CGSize constraintSize;
    constraintSize.width = _textView.width-10;
    constraintSize.height = MAXFLOAT;
    CGFloat height = [_textView.text boundingRectWithSize:constraintSize
                                                  options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                               attributes:@{NSFontAttributeName:_textView.font}
                                                  context:nil].size.height +5; // 最小高 减去 一行的高度
    height = MAX(height, kBaseLineHeight);

    CGFloat offset = 0;

    // 避免多次重复调用
    if (_currentTextH == height || (height > _maxHeight && _textView.scrollEnabled == YES)) {
        return;
    }
    else{

        if (height > _maxHeight) {
            offset =  _currentTextH - _maxHeight;
            _currentTextH = _maxHeight;
            _textView.scrollEnabled = YES;
        }else{
            offset = _currentTextH - height;
            _currentTextH = height;
            _textView.scrollEnabled = NO;
        }
    }

    // 改变自身高度 并告诉代理做出相应调整
    [UIView animateWithDuration:0.1 animations:^{
        self.height = self.currentTextH + 25;
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
    if (!self.trackKeyboard) return;

    CGRect rect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:(UIViewAnimationCurve)[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue]];

    self.y = rect.origin.y - self.height - kNavBarHeight;
    [UIView commitAnimations];

    if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewKeyboardWillShow:keyboardFrame:duration:)]) {
        [self.delegate inputViewKeyboardWillShow:self keyboardFrame:rect duration:duration];
    }
}

//
- (void)keyboardWillHide:(NSNotification *)notification
{
    if (!self.trackKeyboard) return;

    CGRect rect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:(UIViewAnimationCurve)[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue]];
    self.y = kContentHeight-self.height;
    [UIView commitAnimations];

    if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewKeyboardWillHide:keyboardFrame:duration:)]) {
        [self.delegate inputViewKeyboardWillHide:self keyboardFrame:rect duration:duration];
    }
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
