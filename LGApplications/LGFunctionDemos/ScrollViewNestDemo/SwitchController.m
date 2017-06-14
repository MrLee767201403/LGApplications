//
//  SwitchController.m
//  LGApplications
//
//  Created by 李刚 on 2017/6/14.
//  Copyright © 2017年 李刚. All rights reserved.
//

#import "SwitchController.h"
#import "ChildController.h"



/* 思路 :监听tableView 的滑动,如果头部没有滑出屏幕,就把tableView的偏移置零,拿到本次滑动的偏移加给_rootScrollView;
        如果滑出屏幕就由tableView响应滑动事件
        为了让滑动头部时也有反应,可以键值观察,监听_rootScrollView的偏移,控制器可滑动性
        大部分代码是可以直接拿去用的,只需替换headerView 个两个自控制器,自控制器里加三个属性,然后把监听ScrollView的方法搬过去
 */

#define kTableHeight    kScreenHeight - 64.0
#define kItemWidth      80


@interface SwitchController ()<UIScrollViewDelegate>
/**  _rootScrollView是否可以滑动*/
@property (nonatomic, assign) BOOL rootScrollEnabled;

@end

@implementation SwitchController

{
    
    UIImageView *_headerView;
    
    UIScrollView *_rootScrollView;          // 纵向
    UIScrollView *_contentScrollView;       // 横向
    ChildController *_currentVC;            // 当前选中的VC
    UIButton *_leftItem;                    // 左标题
    UIButton *_rightItem;                   // 右标题
    UIView *_indicator;                     // 选中指示器
    UIView *_titleView;                     // 标题
    UIView *_titleCell;                     // 标题栏

    CGFloat _contentHeight;                 // _rootScrollView内容高度
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setSubViews];
}


#pragma mark   -  创建子视图
- (void)setSubViews{
    
    // 最底部纵向_rootScrollView
    _rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64.0)];
    _rootScrollView.backgroundColor = kColorBackground;
    _rootScrollView.scrollEnabled = NO;
    [self.view addSubview:_rootScrollView];
    
    // 上面头部
    _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200.0)];
    _headerView.image = [UIImage imageNamed:@"image"];
    [self addView:_headerView];
    
    // 标题栏
    _titleCell = [[UIView alloc] initWithFrame:CGRectMake(0, _headerView.bottom, kScreenWidth, 40.0)];
    [_titleCell addSubview:[self getTitleView]];
    [self addView:_titleCell];
    
    // 自控制器及其View
    [self setChildViewController];
}


- (void)setChildViewController{
    // 子控制器
    ChildController *VC1 = [[ChildController alloc] init];
    ChildController *VC2 = [[ChildController alloc] init];
    [self addChildViewController:VC1];
    [self addChildViewController:VC2];
    VC1.rootScrollView = _rootScrollView;
    VC2.rootScrollView = _rootScrollView;
    
    VC1.view.frame = CGRectMake(0, 0, kScreenWidth, kTableHeight);
    VC2.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kTableHeight);
    _currentVC = VC1;
    
    
    // 横向的scrollView上添加 自控制器的VC
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _contentHeight, kScreenWidth, kTableHeight)];
    _contentScrollView.delegate = self;
    _contentScrollView.showsVerticalScrollIndicator = NO;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.bounces = YES;
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.contentSize = CGSizeMake(self.view.width*2, kTableHeight);
    [_contentScrollView addSubview:VC1.view];
    [_contentScrollView addSubview:VC2.view];
    [self addView:_contentScrollView];
    
    
    // 其实就是 头部+标题栏的高度
    VC1.scrollEnabledPoint = (_contentHeight - _contentScrollView.height );
    VC2.scrollEnabledPoint = (_contentHeight - _contentScrollView.height );
    
    // 通过键值观察,控制是底部的_rootScrollView滑动,还是上面自控制器的tableView滑动
    [_rootScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
}



// titleView
- (UIView *)getTitleView{

    
    _leftItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kItemWidth, 39.0)];
    _leftItem.selected = YES;
    _leftItem.titleLabel.font = kFontNavigation;
    [_leftItem setTitle:@"最新" forState:UIControlStateNormal];
    [_leftItem setTitleColor:kColorWithFloat(0x8d8c92) forState:UIControlStateNormal];
    [_leftItem setTitleColor:kColorWithFloat(0xfc3050) forState:UIControlStateSelected];
    [_leftItem addTarget:self action:@selector(changeViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    _rightItem = [[UIButton alloc] initWithFrame:CGRectMake(kItemWidth, 0, kItemWidth, 39.0)];
    _rightItem.titleLabel.font = kFontNavigation;
    [_rightItem setTitle:@"最热" forState:UIControlStateNormal];
    [_rightItem setTitleColor:kColorWithFloat(0x8d8c92) forState:UIControlStateNormal];
    [_rightItem setTitleColor:kColorWithFloat(0xfc3050) forState:UIControlStateSelected];
    [_rightItem addTarget:self action:@selector(changeViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat width = [@"蓝瘦" sizeWithAttributes:@{NSFontAttributeName:kFontNavigation}].width;
    _indicator = [[UIView alloc] initWithFrame:CGRectMake(0, 35, width, 1.0)];
    _indicator.centerX = _leftItem.centerX;
    _indicator.backgroundColor = kColorWithFloat(0xfc3050);
    
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2*kItemWidth, 40.0)];
    _titleView.centerX = kScreenWidth/2;
    [_titleView addSubview:_rightItem];
    [_titleView addSubview:_leftItem];
    [_titleView addSubview:_indicator];
    
    return _titleView;
}


//
- (void)addView:(UIView *)view{
    view.y = _contentHeight;
    _contentHeight += view.height;
    [_rootScrollView addSubview:view];
    _rootScrollView.contentSize = CGSizeMake(kScreenWidth, _contentHeight);
}

#pragma mark   -  监听事件
// 切换VC
- (void)changeViewController:(UIButton *)sender{
    
    if (sender == _leftItem) {
        _currentVC = self.childViewControllers[0];
        [_contentScrollView setContentOffset:CGPointZero animated:YES];
    }else{
        _currentVC = self.childViewControllers[1];
        [_contentScrollView setContentOffset:CGPointMake(self.view.width, 0) animated:YES];
    }
    
    if (self.rootScrollEnabled) {
        [_currentVC.tableView setContentOffset:CGPointZero];
    }
    
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    _rootScrollView.scrollEnabled = self.rootScrollEnabled;
    
    
    // 切换头部 titleView应该在titleCell上
    if (self.rootScrollEnabled) {
        
        // titleView 如果不在titleCell上
        if (_titleView.superview != _titleCell) {
            [_titleCell addSubview:_titleView];
            self.navigationItem.titleView = nil;
        }
    }
    
    // titleView应该在导航栏上
    else{
        
        // titleView 在titleCell上
        if (_titleView.superview == _titleCell) {
            
            self.navigationItem.titleView = _titleView;
            [UIView animateWithDuration:1.5 animations:^{
                _titleView.alpha = 1;
            }];
        }
    }
}

- (BOOL)rootScrollEnabled{
    
    // 头部未滑出屏幕
    if ( _rootScrollView.contentOffset.y < (_contentHeight - _contentScrollView.height )) {
        return YES;
    }
    else{
        return NO;
    }
}

#pragma mark 滑动监听  页面切换
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == _contentScrollView) {
        CGFloat offset = scrollView.contentOffset.x;
        CGFloat scale = offset/self.view.width;
        _indicator.centerX = _leftItem.centerX + kItemWidth*scale;
        
        if (offset > self.view.width/2) {
            _leftItem.selected = NO;
            _rightItem.selected = YES;
        }else{
            _leftItem.selected = YES;
            _rightItem.selected = NO;
        }
    }
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == _contentScrollView) {
        
        if (scrollView.contentOffset.x>self.view.width/2) {
            _currentVC = self.childViewControllers[1];
        }else{
            _currentVC = self.childViewControllers[0];
        }
        
        if (self.rootScrollEnabled) {
            // 这句很重要
            [_currentVC.tableView setContentOffset:CGPointZero];
        }
    }
    
}


- (void)dealloc{
    [_rootScrollView removeObserver:self forKeyPath:@"contentOffset"];
}
@end
