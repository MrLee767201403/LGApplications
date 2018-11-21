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
@property (nonatomic, assign) BOOL singleButton;

@property (nonatomic, assign) NSTextAlignment alignment;

@property (nonatomic, copy) CompleteBlock yesHandle;
@property (nonatomic, copy) CompleteBlock noHandle;

- (instancetype)initWithContent:(NSString *)content;
- (void)show;
- (void)disMiss;
@end
