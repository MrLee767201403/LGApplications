//
//  AppDelegate.h
//  HumanResource
//
//  Created by 李刚 on 2019/10/10.
//  Copyright © 2019 ligang. All rights reserved.
//


#import "BaseNavigationController.h"

@interface BaseNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation BaseNavigationController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //默认开启系统右划返回
    self.interactivePopGestureRecognizer.enabled = YES;
    self.interactivePopGestureRecognizer.delegate = self;
    self.delegate = self;
    

    UINavigationBar *navBar = [UINavigationBar appearance];
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = kColorDark;
    textAttrs[NSFontAttributeName] = kFontNavigation;
    [navBar setTitleTextAttributes:textAttrs];
    navBar.barTintColor = kColorWhite;
    navBar.translucent = NO;
    navBar.tintColor = kColorDark;
}

#pragma mark   -  状态栏
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

#pragma mark   -  屏幕旋转
- (BOOL)shouldAutorotate{
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return  self.topViewController.supportedInterfaceOrientations;
}

- (void)dealloc
{
    self.interactivePopGestureRecognizer.delegate = nil;
    self.delegate = nil;
}


//根视图禁用右划返回
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    //输入sn页和添加结算卡页 禁止返回
    BaseViewController *VC = self.childViewControllers[self.childViewControllers.count -1];

    if (VC && [VC isMemberOfClass:[BaseViewController class]]){
        return VC.popGestureEnabled;
    }
    return self.childViewControllers.count == 1 ? NO : YES;
}

@end
