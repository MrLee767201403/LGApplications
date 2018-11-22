//
//  LGToastView.h
//  Trainee
//
//  Created by 李刚 on 2018/9/17.
//  Copyright © 2018年 Mr.Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

/**  类似MBProgressHUD*/
@interface LGToastView : UIView
+ (instancetype)showToastWithError:(NSString *)error;
+ (instancetype)showToastWithSuccess:(NSString *)success;
+ (instancetype)showToastWithError:(NSString *)error afterDelay:(NSTimeInterval)delay;
+ (instancetype)showToastWithSuccess:(NSString *)success afterDelay:(NSTimeInterval)delay;
@end
