//
//  LGAlertView.h
//  IQTest
//
//  Created by 李刚 on 2017/7/19.
//  Copyright © 2017年 Mr.Lee. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LGAlertView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *noTitle;
@property (nonatomic, copy) NSString *yesTitle;
@property (nonatomic, assign) BOOL singleButton;  // 此时只显示 确定按钮

@property (nonatomic, assign) NSTextAlignment alignment;

@property (nonatomic, copy) ActionBlock yesHandle;
@property (nonatomic, copy) ActionBlock noHandle;

- (instancetype)initWithContent:(NSString *)content;
- (void)show;
- (void)disMiss;
@end
