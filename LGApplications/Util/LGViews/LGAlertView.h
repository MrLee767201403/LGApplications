//
//  LGAlertView.h
//  IQTest
//
//  Created by 李刚 on 2017/7/19.
//  Copyright © 2017年 Mr.Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LGAlertBlack)(UIButton *button);

@interface LGAlertView : UIView

/**  取消按钮的标题*/
@property (nonatomic, copy) NSString *cancelTitle;


- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content confirmTitle:(NSString *)title;

/**  取消按钮回调*/
- (void)setCancelBlack:(LGAlertBlack)handle;
/**  确认按钮回调*/
- (void)setConfirmBlack:(LGAlertBlack)handle;
- (void)show;
- (void)disMiss;
@end
