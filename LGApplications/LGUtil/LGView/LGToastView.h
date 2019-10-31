//
//  LGToastView.h
//  FollowerTracker
//
//  Created by 李刚 on 2018/9/17.
//  Copyright © 2018年 Mr.Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGRefreshView.h"

@interface LGToastView : UIView

/**  loading 显示在窗口*/
+ (instancetype)showLoading:(NSString *)text;
/**  loading 显示在View 导航栏可以操作*/
+ (instancetype)showLoadingInView:(NSString *)text;
+ (void)hideToast;

/**  提示*/
+ (instancetype)showToastWithError:(NSString *)error;
+ (instancetype)showToastWithSuccess:(NSString *)success;
+ (instancetype)showToastWithError:(NSString *)error afterDelay:(NSTimeInterval)delay;
+ (instancetype)showToastWithSuccess:(NSString *)success afterDelay:(NSTimeInterval)delay;


/**  带大图片 1.5秒自动消失*/
+ (instancetype)showSuccessWithMessage:(NSString *)message;
+ (instancetype)showErrorWithMessage:(NSString *)message;
+ (instancetype)showInfoWithMessage:(NSString *)message;
+ (instancetype)showWarnWithMessage:(NSString *)message;

/**  导航栏顶部显示*/
+ (instancetype)showTipWithMessage:(NSString *)message;
+ (instancetype)showTipWithMessage:(NSString *)message afterDelay:(NSTimeInterval)delay;

@end
