//
//  ChildController.h
//  LGApplications
//
//  Created by 李刚 on 2017/6/14.
//  Copyright © 2017年 李刚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChildController : UIViewController

// containController 里面,纵向滑动的ScrollView(最底部)
@property (nonatomic, strong) UIScrollView *rootScrollView;

// 显示数据的列表
@property (nonatomic, strong) UITableView *tableView;

// rootScrollView的偏移为这么多时,tableView才可以滑动
@property (nonatomic, assign) CGFloat scrollEnabledPoint;

@end
