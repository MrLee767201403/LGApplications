//
//  LGTextView.h
//  LGApplications
//
//  Created by 李刚 on 2017/5/9.
//  Copyright © 2017年 李刚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGTextView : UITextView

/**  placeholder*/
@property (nonatomic, copy) NSString *placeholder;

/**  placeholderColor 默认亮灰 字体默认与textView一致*/
@property (nonatomic, strong) UIColor *placeholderColor;

/**  要自定义其他属性 可以拿到Label自己修改*/
@property (nonatomic, strong) UILabel *placeholderLabel;

@end
