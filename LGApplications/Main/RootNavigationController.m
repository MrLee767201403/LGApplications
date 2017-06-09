//
//  RootNavigationController.m
//  LGApplications
//
//  Created by 李刚 on 2017/6/7.
//  Copyright © 2017年 李刚. All rights reserved.
//

#import "RootNavigationController.h"

@interface RootNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation RootNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 设置导航栏
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:kColorMainTheme] forBarMetrics:UIBarMetricsDefault];
    UINavigationBar *navBar = [UINavigationBar appearance];
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = kFontNavigation;
    [navBar setTitleTextAttributes:textAttrs];
    navBar.barTintColor = kColorMainTheme;
    navBar.tintColor = [UIColor whiteColor];
    
    self.interactivePopGestureRecognizer.delegate = self;
    self.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    viewController.hidesBottomBarWhenPushed = YES;
    [super pushViewController:viewController animated:animated];
    viewController.hidesBottomBarWhenPushed = NO;
}

- (void)dealloc
{
    self.interactivePopGestureRecognizer.delegate = nil;
    self.delegate = nil;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animate
{
    if ([navigationController.viewControllers count] == 1) {
        navigationController.interactivePopGestureRecognizer.enabled = NO;
    } else {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

@end
