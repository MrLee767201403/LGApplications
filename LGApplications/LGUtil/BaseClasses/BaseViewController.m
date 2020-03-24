//
//  AppDelegate.h
//  HumanResource
//
//  Created by 李刚 on 2019/10/10.
//  Copyright © 2019 ligang. All rights reserved.
//


#import "BaseViewController.h"

@implementation BaseViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        NSLog(@"ViewController init: %@", NSStringFromClass([self class]));
        self.hideNavigationBar = NO;
        self.popGestureEnabled = YES;
        self.hideBottomBar = YES;
        self.statusBarStyle = UIStatusBarStyleDefault;
        self.presentationFullScreen = YES;

        self.hidesBottomBarWhenPushed = self.hideBottomBar;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view setBackgroundColor:kColorWhite];
    NSArray *controllers = self.navigationController.viewControllers;
    if (self.navigationController &&controllers.count>1 && self.hideNavigationBar == NO) {
        if ((controllers[0] != self)) {
            // 设置根据TintColor渲染图片
//            UIImage *image = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:Image(@"back") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        }
        else{
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" target:self action:@selector(back)];
        }
    }
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion{
    if ([viewControllerToPresent isKindOfClass:BaseViewController.class]) {
        BaseViewController *VC = (BaseViewController *)viewControllerToPresent;
        if (VC.presentationFullScreen) {
            VC.modalPresentationStyle = UIModalPresentationFullScreen;
        }
    }
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}

- (void)back{

    NSArray *controllers = self.navigationController.viewControllers;
    if (self.navigationController && (controllers[0] != self)){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)dealloc
{
    NSLog(@"ViewController dealloc: %@", NSStringFromClass([self class]));
}

#pragma mark   -  屏幕旋转
- (BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark   -  状态栏 & 导航栏

- (void)setHideBottomBar:(BOOL)hideBottomBar{
    _hideBottomBar = hideBottomBar;
    self.hidesBottomBarWhenPushed = self.hideBottomBar;
}

- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle{
    _statusBarStyle = statusBarStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.statusBarStyle;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = self.popGestureEnabled;
    [self.navigationController setNavigationBarHidden:self.hideNavigationBar animated:animated];
}



@end





@implementation UIViewController (Extension)
/**  在主线程执行操作*/
- (void)performSelectorOnMainThread:(void(^)(void))block{
    if ([[NSThread currentThread] isMainThread]) {
        block();
    }else{
        dispatch_sync(dispatch_get_main_queue(), ^{
            block();
        });
    }
}


/**  退出 presentViewController  count：次数*/
- (void)dismissViewControllerWithCount:(NSInteger)count animated:(BOOL)animated{

    count--;
    // 不是自己，并且自己弹出过VC， 递归交给自己弹出的VC处理
    if (count>0 && self.presentingViewController) {
        [self.presentingViewController dismissViewControllerWithCount:count animated:animated];
    }
    else{
        [self dismissViewControllerAnimated:animated completion:nil];
    }
}



/**  退出 presentViewController 到指定的控制器*/
- (void)dismissToViewControllerWithClassName:(NSString *)className animated:(BOOL)animated{

    // 不是自己，并且自己弹出过VC， 递归交给自己弹出的VC处理
    if (![self.class isKindOfClass:NSClassFromString(className)] && self.presentingViewController) {
        [self.presentingViewController dismissToViewControllerWithClassName:className animated:animated];
    }else{
        [self dismissViewControllerAnimated:animated completion:nil];
    }
}

@end
