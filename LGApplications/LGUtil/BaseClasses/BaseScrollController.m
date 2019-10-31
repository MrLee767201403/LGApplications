//
//  AppDelegate.h
//  HumanResource
//
//  Created by 李刚 on 2019/10/10.
//  Copyright © 2019 ligang. All rights reserved.
//


#import "BaseScrollController.h"

@interface BaseScrollController ()

@end

@implementation BaseScrollController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.height)];
    _scrollView.delegate = self;
    _scrollView.contentInset = UIEdgeInsetsMake(0, 0, kBottomBarHeight, 0);
    _scrollView.contentSize = CGSizeMake(kScreenWidth, self.view.height-kBottomBarHeight);
    _scrollView.alwaysBounceVertical = YES;

    [self.view addSubview:_scrollView];

    if (self.navigationController.childViewControllers.count>1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:@"back" target:self action:@selector(back)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat viewH = self.scrollView.height-self.scrollView.contentInset.top-self.scrollView.contentInset.bottom;
        CGFloat contentH = viewH;

        for (UIView *view in self.scrollView.subviews) {
            if([view isKindOfClass:UIImageView.class]) continue;
            contentH = view.bottom > contentH ? view.bottom :contentH;
        }
        contentH += contentH > viewH ? 20:0;
        [self.scrollView setContentSize:CGSizeMake(kScreenWidth, contentH)];
    });

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}
@end
