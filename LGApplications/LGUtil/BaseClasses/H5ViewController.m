//
//  H5ViewController.m
//  HongBao
//
//  Created by 李刚 on 2019/12/26.
//  Copyright © 2019 ligang. All rights reserved.
//

#import "H5ViewController.h"
#import <WebKit/WebKit.h>

@interface H5ViewController ()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
//@property (nonatomic, strong) UIView *navBar;
//@property (nonatomic, strong) UILabel *titleLabel;
//@property (nonatomic, strong) UIButton *cancnelButton;
@end

@implementation H5ViewController
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}


- (instancetype)initWithUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        _url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavBarHeight)];
//    self.navBar.backgroundColor = kColorWhite;
//
//    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kNavBarHeight-50, 200, 50)];
//    self.titleLabel.font = kFontNavigation;
//    self.titleLabel.text = self.title;
//    self.titleLabel.textColor = kColorDark;
//    self.titleLabel.textAlignment = NSTextAlignmentCenter;
//    self.titleLabel.centerX = kScreenWidth/2.0;
//
//    self.cancnelButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-71, kNavBarHeight-45, 61, 40)];
//    self.cancnelButton.titleLabel.font = kFontWithSize(16);
//    [self.cancnelButton setTitle:@"cancel" forState:UIControlStateNormal];
//    [self.cancnelButton setTitleColor:kColorWithFloat(0x828F9F) forState:UIControlStateNormal];
//    [self.cancnelButton addTarget:self action:@selector(cancnelButtonEvent) forControlEvents:UIControlEventTouchUpInside];
//
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight-0.3, kScreenWidth, 0.3)];
//    line.backgroundColor = kColorWithFloat(0x555555);
//
//    [self.navBar addSubview:line];
//    [self.navBar addSubview:self.titleLabel];
//    [self.navBar addSubview:self.cancnelButton];
//    [self.view addSubview:self.navBar];

    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, kViewHeight)];
    self.webView.backgroundColor = kColorWhite;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];

    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:self.url.url];
    [self.webView loadRequest:request];
}

- (void)cancnelButtonEvent{
    [self.webView stopLoading];

    if (self.backBlock) {
        self.backBlock();
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self back];
    }
}

- (void)back{
    [self.webView stopLoading];

    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else{
        [self.view resignFirstResponder];
        [super back];
    }
}
@end
