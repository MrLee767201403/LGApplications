//
//  LGInputView.h
//  LGApplications
//
//  Created by 李刚 on 2017/8/11.
//  Copyright © 2017年 李刚. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LGInputView;
@protocol LGInputViewDelegate <NSObject>

@optional

- (void)inputView:(LGInputView *)inputView didSendMessage:(NSString *)message;
- (void)inputView:(LGInputView *)inputView didTapEmoji:(BOOL)emoji;
- (void)inputViewDidTapImage:(LGInputView *)inputView;

/**  高度变化回调*/
- (void)inputView:(LGInputView *)inputView heightDidChange:(CGFloat)height;

/**  回车点击事件 canNewLine为NO时有效,canNewLine默认为YES*/
- (BOOL)inputViewDidTapReturn:(LGInputView *)inputView;

/**  键盘显示隐藏*/
- (void)inputViewKeyboardWillHide:(LGInputView *)inputView keyboardFrame:(CGRect)frame duration:(NSTimeInterval)duration;
- (void)inputViewKeyboardWillShow:(LGInputView *)inputView keyboardFrame:(CGRect)frame duration:(NSTimeInterval)duration;

// 
#pragma mark   -  textView 代理
- (BOOL)inputViewShouldBeginEditing:(LGInputView *)inputView;
- (BOOL)inputViewShouldEndEditing:(LGInputView *)inputView;
- (void)inputViewDidBeginEditing:(LGInputView *)inputView;
- (void)inputViewDidEndEditing:(LGInputView *)inputView;
- (BOOL)inputView:(LGInputView *)inputView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)inputViewDidChange:(LGInputView *)inputView;

@end

@interface LGInputView : UIView
@property (nonatomic, strong) UIFont   *font;                   //  默认15号,此时高度34刚好
@property (nonatomic, copy)   NSString *text;
@property (nonatomic, strong) UIColor  *textColor;

@property (nonatomic, copy)   NSString *placeholder;            //  仅支持一行
@property (nonatomic, strong) UIColor  *placeholderColor;
@property (nonatomic, weak) id<LGInputViewDelegate> delegate;

/**
 *  用于更改intputView未涉及的属性 例如UIReturnKeyType
 */
@property (nonatomic, strong, readonly) LGTextView *textView;
@property (nonatomic, strong, readonly) UIButton *imageButton;
@property (nonatomic, strong, readonly) UIButton *emojiButton;


/**  输入框最大高度*/
@property (nonatomic, assign) CGFloat   maxHeight;
/**  是否可以换行*/
@property (nonatomic, assign) BOOL      canNewLine;
/**  是否跟随键盘*/
@property (nonatomic, assign) BOOL      trackKeyboard;

@end
