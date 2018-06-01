//
//  TextViewCell.h
//  Trainee
//
//  Created by 李刚 on 2018/5/9.
//  Copyright © 2017年 Mr.Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGTextView.h"

/**  
  *带输入框的
  *可以带标题
  *文字过长时自动折行
  *外面加约束时 需设置最小高度 才能折行
 */
@interface TextViewCell : UIView

/**  icon*/
@property (nonatomic, strong) UIImage *icon;

/**  title*/
@property (nonatomic, strong) NSString *title;

/**  placeholder*/
@property (nonatomic, strong) NSString *placeholder;

/**  content*/
@property (nonatomic, strong) NSString *content;

/**  分割线*/
@property (nonatomic, strong, readonly) UIView *line;
@property (nonatomic, assign) CGFloat lineRight;

@property (nonatomic, strong) LGTextView *textView;

/**  title*/
@property (nonatomic, strong) NSMutableAttributedString *attributeTitle;


+ (instancetype)textCellWithIcon:(UIImage *)icon
                           title:(NSString *)title
                      placeholder:(NSString *)placeholder
                          content:(NSString *)content;
@end
