//
//  CommonCell.h
//  Trainee
//
//  Created by 李刚 on 2018/5/9.
//  Copyright © 2018年 Mr.Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonCell : UIButton
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) UIColor *detailColor;

@property (nonatomic, assign) BOOL showAccessView;

+ (instancetype)cellWithTop:(CGFloat)top icon:(UIImage *)icon title:(NSString *)title;
+ (instancetype)cellWithTop:(CGFloat)top icon:(UIImage *)icon title:(NSString *)title target:(id)target action:(SEL)action;
@end

