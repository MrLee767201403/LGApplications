//
//  AppDelegate.h
//  HumanResource
//
//  Created by 李刚 on 2019/10/10.
//  Copyright © 2019 ligang. All rights reserved.
//


#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class DataModel;
@interface BaseTableViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, assign) UITableViewStyle style;   // [super viewDidLoad] 之前调用
@property (nonatomic, assign) BOOL allwaysRefreshOnAppear;  // 每次视图显示的时候刷新  默认NO

/**  下拉刷新和上拉加载*/
@property (nonatomic, strong) MJRefreshNormalHeader *refreshHeader;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *refreshFooter;

@property (nonatomic, strong) Class modelClass; // model必须是DataModel的子类 必须重写其initWithDictionary:方法
@property (nonatomic, strong) Class cellClass; // cell的model必须是DataModel的子类 必须重写其initWithDictionary:方法


/**  @require 注册cell的类型*/
- (void)registerReuseCell:(Class)cellClass; // cell的model必须是DataModel的子类 必须重写其initWithDictionary:方法

/**  @require 由子类返回当前的请求*/
- (LGHttpRequest *)getCurrentRequest;

/**  请求的数据*/
@property (nonatomic, strong, readonly) NSMutableArray *dataArray;

/**  请求成功的回调*/
@property (nonatomic, copy) SuccessHandle complete;

/**  请求失败的回调*/
@property (nonatomic, copy) ErrorHandle failure;

/**  下拉刷新*/
- (void)refreshData;

/**  加载更多*/
- (void)loadMoreData;

/**  获取缓存*/
- (void)loadCache;

/**  是否显示错误页面*/
- (void)showErrorView:(BOOL)show;

/**  是否显示空页面*/
- (void)showEmpetyView:(BOOL)show;
@end



@interface UITableViewCell (Extension)
@property (nonatomic, strong, nullable) NSIndexPath *indexPath; //cell做删除操作时indexPath 会变
@property (nonatomic, strong, nullable) DataModel *dataModel;
@end

@interface DataModel : NSObject
/**  除了字典和数组外 其他的类型都会转出NSString*/
- (instancetype)initWithDictionary:(nullable NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END

