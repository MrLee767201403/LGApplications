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
        self.hidesBottomBarWhenPushed = self.hideBottomBar;
        self.edgesForExtendedLayout = UIRectEdgeNone;
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
            UIImage *image = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        }
        else{
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" target:self action:@selector(back)];
        }
    }
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
    [NSUtil setNavigationBarLine:self.navigationController.navigationBar hidden:YES];
}


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
@end
