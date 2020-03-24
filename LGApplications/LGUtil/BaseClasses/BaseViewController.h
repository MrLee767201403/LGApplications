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
@property (nonatomic, assign) BOOL presentationFullScreen; // 默认全屏弹起控制器
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;   // 默认黑色

/**  返回*/
- (void)back;


@end


@interface UIViewController (Extension)
/**  在主线程执行操作*/
- (void)performSelectorOnMainThread:(void(^)(void))block;

/**  退出 presentViewController  count：次数*/
- (void)dismissViewControllerWithCount:(NSInteger)count animated:(BOOL)animated;


/**  退出 presentViewController 到指定的控制器*/
- (void)dismissToViewControllerWithClassName:(NSString *)className animated:(BOOL)animated;

@end

