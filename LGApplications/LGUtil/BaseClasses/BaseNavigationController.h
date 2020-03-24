//
//  AppDelegate.h
//  HumanResource
//
//  Created by 李刚 on 2019/10/10.
//  Copyright © 2019 ligang. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface BaseNavigationController : UINavigationController
@property (nonatomic, assign) BOOL popGestureEnabled;
@property (nonatomic, assign) BOOL presentationFullScreen; // 默认全屏弹起控制器

@end

@interface UINavigationController (Extension)
/**  pop到指定的控制器*/
- (void)popToViewControllerWithClassName:(NSString *)className animated:(BOOL)animated;

/**  pop多次 count：次数*/
- (void)popViewControllerWithCount:(NSInteger)count animated:(BOOL)animated;
@end
