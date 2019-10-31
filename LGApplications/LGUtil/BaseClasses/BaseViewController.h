//
//  AppDelegate.h
//  HumanResource
//
//  Created by 李刚 on 2019/10/10.
//  Copyright © 2019 ligang. All rights reserved.
//


#import <Foundation/Foundation.h>


/**
 * BaseViewController
 */
@interface BaseViewController : UIViewController
@property (nonatomic, assign) BOOL hideNavigationBar;   // 默认不隐藏
@property (nonatomic, assign) BOOL hideBottomBar;       // 默认隐藏
@property (nonatomic, assign) BOOL popGestureEnabled;   // 默认开启滑动返回
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;   // 默认黑色

/**  返回*/
- (void)back;

/**  在主线程执行操作*/
- (void)performSelectorOnMainThread:(void(^)(void))block;
@end
