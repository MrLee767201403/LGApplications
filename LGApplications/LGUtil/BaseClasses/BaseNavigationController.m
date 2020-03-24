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


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        NSLog(@"ViewController init: %@", NSStringFromClass([self class]));
        self.popGestureEnabled = YES;
        self.presentationFullScreen = YES;
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
        self.navigationBarHidden = NO;
    }

    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}

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


// 根视图禁用右划返回
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    BaseViewController *VC = self.childViewControllers[self.childViewControllers.count -1];

    if (self.childViewControllers.count <= 1) {
        return NO; // 修复偶尔PUSH页面卡死的问题
    }
    else if (VC && [VC isMemberOfClass:[BaseViewController class]]){
        return VC.popGestureEnabled && self.popGestureEnabled;
    }else{
         return YES;
    }
}

@end



@implementation UINavigationController (Extension)

- (void)popToViewControllerWithClassName:(NSString *)className animated:(BOOL)animated{

    for (UIViewController *VC in self.childViewControllers) {
        if ([VC isKindOfClass:NSClassFromString(className)]) {
            [self popToViewController:VC animated:animated];
            return;
        }
    }
    [self popToRootViewControllerAnimated:animated];
}

- (void)popViewControllerWithCount:(NSInteger)count animated:(BOOL)animated{
    count = MAX(count, 1);
    NSInteger totalCount  = self.childViewControllers.count;
    NSInteger index = MAX(totalCount-count-1, 0);
    UIViewController *VC = self.childViewControllers[index];
    [self popToViewController:VC animated:animated];
}
@end
