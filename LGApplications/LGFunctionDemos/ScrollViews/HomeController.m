//
//  HomeController.m
//  ScrollViews
//
//  Created by 李刚 on 2017/6/30.
//  Copyright © 2017年 Mr.Lee. All rights reserved.
//

#import "HomeController.h"
#import "ListController.h"

@interface HomeController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIView *headerView;                       // 盖在tableView上面的头部, 假装是tableView的headerView
@property (nonatomic, strong) UIScrollView *backgroundScrollView;       // 最底部横向ScrollView
@property (nonatomic, strong) ListController *currentVC;

@property (nonatomic, strong) UIButton *navigationBar;

@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    [self setUpSubviews];
}


- (void)setUpSubviews{
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.backgroundScrollView.delegate = self;
    self.backgroundScrollView.pagingEnabled = YES;
    self.backgroundScrollView.bounces = NO;
    if (@available(iOS 11.0, *)) {
        self.backgroundScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.backgroundScrollView.contentInset = UIEdgeInsetsZero;
    self.backgroundScrollView.showsVerticalScrollIndicator = NO;
    self.backgroundScrollView.showsHorizontalScrollIndicator = NO;
    self.backgroundScrollView.contentSize = CGSizeMake(kScreenWidth*2, kScreenHeight);
    
    self.headerView = [self getHeaderView];
    [self.headerView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(headerPan:)]];
    
    ListController *list1 = [[ListController alloc] init];
    ListController *list2 = [[ListController alloc] init];
    list1.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    list2.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight);
    [self.backgroundScrollView addSubview:list1.view];
    [self.backgroundScrollView addSubview:list2.view];
    [self addChildViewController:list1];
    [self addChildViewController:list2];
    [self.view addSubview:self.backgroundScrollView];
    [self.view addSubview:self.headerView];
    
    self.currentVC = list1;
    [list1.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [list2.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];

    [self.view addSubview:self.navigationBar];

}


- (void)headerPan:(UIPanGestureRecognizer *)pan{
    // 触点移动的绝对距离
    
    // CGPoint location = [pan locationInView:self.view];
    // 移动两点之间的相对距离
    CGPoint translation = [pan translationInView:self.view];
    UIScrollView *scrollView = self.currentVC.tableView;
    CGFloat offsetY = scrollView.contentOffset.y-translation.y;
    
    // 模仿一下scrollView下拉回弹(0 到 -150)
    if (offsetY > -150){
        [scrollView setContentOffset:CGPointMake(0, offsetY)];
    }
    
    if (pan.state == UIGestureRecognizerStateEnded && offsetY<0) {
        [scrollView setContentOffset:CGPointZero animated:YES];
    }
    
    [pan setTranslation:CGPointZero inView:self.view];
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat offset = [change[NSKeyValueChangeNewKey] CGPointValue].y;
        UITableView *tableView = object;
        
//        if ([self.currentVC isRefreshing]) {
//            return;
//        }

        // 头部显示一半或全部
        if (offset<=150 && offset>=0) {
            self.headerView.y = -offset;
            self.headerView.height =  264;
            
            // 让其他的tableView同步偏移量
            for (ListController *vc in self.childViewControllers) {
                if (vc.tableView.contentOffset.y != tableView.contentOffset.y) {
                    vc.tableView.contentOffset = tableView.contentOffset;
                }
            }
        }
        // 头部完全滑出屏幕
        else if(offset>150){ // 悬停
            self.headerView.y = -150;
            self.headerView.height =  264;
            
            // 其他偏移量依然小于150的 设置成150
            for (ListController *vc in self.childViewControllers) {
                if (vc.tableView.contentOffset.y < 150) {
                    vc.tableView.contentOffset = CGPointMake(vc.tableView.contentOffset.x, 150);
                }
            }
        }
        // 被下拉状态
        else if (offset<0){
            self.headerView.y = 0;
            self.headerView.height =  264 - offset;
            
            // 让其他的tableView同步偏移量
            for (ListController *vc in self.childViewControllers) {
                if (vc.tableView.contentOffset.y != tableView.contentOffset.y) {
                    vc.tableView.contentOffset = tableView.contentOffset;
                }
            }
        }
        
        self.navigationBar.alpha = offset/150.0;
    }
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self adjustOffset];
}


- (void)changeVC:(UIButton *)button{
    if ([button.currentTitle isEqualToString:@"left"]) {
        [self.backgroundScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else{
        [self.backgroundScrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
    }
    [self adjustOffset];
}

- (void)adjustOffset{
    
    // 计算出最大偏移量(三个tableView里面偏移最大值)
    CGFloat maxOffsetY = 0;
    for (ListController *vc in self.childViewControllers) {
        if (vc.tableView.contentOffset.y > maxOffsetY) {
            maxOffsetY = vc.tableView.contentOffset.y;
        }
    }
    
    // 如果最大偏移量大于150，让没滑到达临界值的,设置到临界值处
    if (maxOffsetY <=150) return;
    for (ListController *vc in self.childViewControllers) {
        if (vc.tableView.contentOffset.y < 150) {
            vc.tableView.contentOffset = CGPointMake(0, 150);
        }
    }
}

- (UIView *)getHeaderView{

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 264)];
    view.backgroundColor = [UIColor redColor];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = Image(@"girl");

    UIButton *left = [[UIButton alloc] init];
    [left setTitle:@"left" forState:UIControlStateNormal];
    [left setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [left setBackgroundColor:kColorWithFloat(0xf5f5f5) forState:UIControlStateNormal];
    [left addTarget:self action:@selector(changeVC:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *right = [[UIButton alloc] init];
    [right setTitle:@"right" forState:UIControlStateNormal];
    [right setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [right setBackgroundColor:kColorWithFloat(0xf5f5f5) forState:UIControlStateNormal];
    [right addTarget:self action:@selector(changeVC:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2.0, 18, 1, 14)];
    line.backgroundColor = [UIColor blackColor];
    
    [view addSubview:imageView];
    [view addSubview:left];
    [view addSubview:right];
    [view addSubview:line];
    
    // 用约束实现下拉放大效果
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(view);
        make.bottom.equalTo(view).offset(-50);
    }];
    
    [left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2, 50));
    }];
    
    [right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2, 50));
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.centerY.equalTo(left);
        make.size.mas_equalTo(CGSizeMake(1, 15));
    }];

    return view;
}

- (UIButton *)navigationBar{
    if (_navigationBar == nil) {
        _navigationBar = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
        _navigationBar.alpha = 0;
        [_navigationBar setBackgroundColor:kColorMainTheme forState:UIControlStateNormal];
        [_navigationBar setTitle:@"你好啊" forState:UIControlStateNormal];
        [_navigationBar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    return _navigationBar;
}
@end
