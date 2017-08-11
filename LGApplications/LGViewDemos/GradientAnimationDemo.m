//
//  GradientAnimationDemo.m
//  LGApplications
//
//  Created by 李刚 on 2017/6/9.
//  Copyright © 2017年 李刚. All rights reserved.
//

#import "GradientAnimationDemo.h"

/* 思路: 1.titleView上面盖一个完全一样的View,
        2.对上面盖的这个View进行裁剪,只留下滑块那部分
        3.滑动的时候改变裁剪的位置
        4.设置上面盖的View的maskView为滑块,实现裁剪,滑动时改变滑块的位置
   使用: 一般用于两个VC之间的切换
   扩展: 如果不需要滑块,只需要把addFrontView里面的backView的背景色注释掉,可以在下面加个line做指示器
 */

@interface GradientAnimationDemo ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *alphaView;         // 滑块
@property (nonatomic, strong) UIView *titleView;         // 导航栏titleView

@end

@implementation GradientAnimationDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubViews];
}


- (void)setUpSubViews{
    
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth-88, 44)];
    self.navigationItem.titleView = self.titleView;

    // 添加两个选择标签
    [self addBottomView];
    [self addFrontView];
 
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * 2,self.scrollView.bounds.size.height);
    [self.view addSubview:self.scrollView];
    
    UIView *view1 = [[UIView alloc] initWithFrame:self.view.bounds];
    view1.backgroundColor = kColorBackground;
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, self.view.height)];
    view2.backgroundColor = kColorWithFloat(0xF6833C);
    
    [self.scrollView addSubview:view1];
    [self.scrollView addSubview:view2];
}



- (void)addBottomView {
    
    // 背景View
    UIView *backView = [[UIView alloc] initWithFrame:self.titleView.bounds];
    [self.titleView addSubview:backView];

    // 标题1
    UIButton *leftItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.titleView.width/2, self.titleView.height)];
    leftItem.titleLabel.font = kFontNavigation;
    [leftItem setTitle:@"LeftItem" forState:UIControlStateNormal];
    [leftItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(changeViewController:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:leftItem];
    
    // 标题2
    UIButton *rightItem = [[UIButton alloc] initWithFrame:CGRectMake(self.titleView.width/2, 0, self.titleView.width/2, self.titleView.height)];
    rightItem.titleLabel.font = kFontNavigation;
    [rightItem setTitle:@"RightItem" forState:UIControlStateNormal];
    [rightItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightItem addTarget:self action:@selector(changeViewController:) forControlEvents:UIControlEventTouchUpInside];

    [backView addSubview:rightItem];
}


- (void)addFrontView {
    
    // 背景View
    UIView *backView = [[UIView alloc] initWithFrame:self.titleView.bounds];
    backView.backgroundColor = kColorWithFloat(0xfc3050);    // 这是滑块的颜色
    backView.userInteractionEnabled = NO;
    [self.titleView addSubview:backView];
    
    // 标题1
    UIButton *leftItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.titleView.width/2, self.titleView.height)];
    leftItem.titleLabel.font = kFontNavigation;
    [leftItem setTitle:@"LeftItem" forState:UIControlStateNormal];
    [leftItem setTitleColor:kColorWithFloat(0x131117) forState:UIControlStateNormal];
    [backView addSubview:leftItem];
    
    // 标题2
    UIButton *rightItem = [[UIButton alloc] initWithFrame:CGRectMake(self.titleView.width/2, 0, self.titleView.width/2, self.titleView.height)];
    rightItem.titleLabel.font = kFontNavigation;
    [rightItem setTitle:@"RightItem" forState:UIControlStateNormal];
    [rightItem setTitleColor:kColorWithFloat(0x131117) forState:UIControlStateNormal];
    [backView addSubview:rightItem];
    
    // 滑块.即当前选中
    self.alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, self.titleView.width/2, 24)];
    self.alphaView.backgroundColor = kColorWithFloat(0xfc3050);
    self.alphaView.layer.cornerRadius = 12.f;
    backView.maskView = self.alphaView;

}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offset = scrollView.contentOffset.x;
    CGFloat scale = offset/self.view.width;
    self.alphaView.x = self.alphaView.width *scale;;
}



- (void)changeViewController:(UIButton *)sender{
    if ([sender.currentTitle isEqualToString:@"LeftItem"]) {
//        _currentVC = self.childViewControllers[0];
        [self.scrollView setContentOffset:CGPointZero animated:YES];
    }else{
//        _currentVC = self.childViewControllers[1];
        [self.scrollView setContentOffset:CGPointMake(self.view.width, 0) animated:YES];
    }
}



@end
