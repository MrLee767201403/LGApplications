//
//  AppDelegate.h
//  HumanResource
//
//  Created by 李刚 on 2019/10/10.
//  Copyright © 2019 ligang. All rights reserved.
//


#import "BaseTableViewController.h"

@interface BaseTableViewController ()<NSObject>
@property (nonatomic, strong) LGHttpRequest *request;
@property (nonatomic, strong) NSString *nextPage;
@property (nonatomic, strong) NSString *lastRequestTime;
@property (nonatomic, strong) EmptyView *emptyView;
@property (nonatomic, strong) ErrorView *errorView;
@property (nonatomic, strong) NSString *reuseIdentifier;
@property (nonatomic, assign) BOOL loading;  // 是否在加载中

@end

@implementation BaseTableViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _style = UITableViewStylePlain;
        _dataArray = [NSMutableArray array];
        _reuseIdentifier = nil;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self baseTableVCSetUpSubviews];

}

- (void)baseTableVCSetUpSubviews{

    self.edgesForExtendedLayout = UIRectEdgeTop;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kViewHeight) style:self.style];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, kBottomBarHeight, 0);
    _tableView.backgroundColor = kColorWhite;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    _refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    _refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _refreshHeader.y = -_refreshHeader.height;
    _refreshFooter.pullingPercent = 0.0;

    [_tableView addSubview:_refreshHeader];
    [_tableView addSubview:_refreshFooter];
    [self.view addSubview:_tableView];
}

- (void)setCellClass:(Class)cellClass{
    _cellClass = cellClass;
    [self registerReuseCell:cellClass];
}

/**  注册cell的类型*/
- (void)registerReuseCell:(Class)cellClass{
    self.reuseIdentifier = NSStringFromClass(cellClass);
    [self.tableView registerClass:cellClass forCellReuseIdentifier:self.reuseIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (([self.dataArray count] <= 0 && self.loading == NO) || self.allwaysRefreshOnAppear) {
        [self.refreshHeader beginRefreshing];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.reuseIdentifier forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.cellDelegate = self;
    if (indexPath.row < self.dataArray.count) {
        cell.dataModel = self.dataArray[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (LGHttpRequest *)request{
    _request = [self getCurrentRequest];
    if (self.nextPage) {
        [_request.params setValue:self.nextPage forKey:@"nextpage"];
        [_request.params setValue:self.nextPage forKey:@"page"];
    }

    if (self.lastRequestTime.length) {
        [_request.params setValue:self.lastRequestTime forKey:@"time"];
    }
    return _request;
}

/**  由子类返回当前的请求*/
- (LGHttpRequest *)getCurrentRequest{
    LGLog(@"Error: 子类未实现requset方法");
    [self.refreshHeader endRefreshing];
    [self.refreshFooter endRefreshing];
    self.refreshFooter.hidden = YES;
    return nil;
}

/**  获取缓存*/
- (void)loadCache{
    [self requestData:YES];
}

/**  下拉刷新*/
- (void)refreshData{
    [self requestData:NO];
}



/**  是否显示错误页面*/
- (void)showErrorView:(BOOL)show{
    if (show) {
        [self.errorView showInView:self.tableView];
    }else{
        [self.errorView removeFromSuperview];
    }
}

/**  是否显示空页面*/
- (void)showEmpetyView:(BOOL)show{
    if (show) {
        [self.emptyView showInView:self.tableView];
    }else{
        [self.emptyView removeFromSuperview];
    }
}



#pragma mark   -  网络请求
/**  加载更多*/
- (void)loadMoreData{
    __weak typeof(self) weakSelf = self;
    self.loading = YES;
    [self.request startRequsetWithSuccess:^(LGHttpResult * _Nonnull result) {
        [weakSelf.refreshFooter endRefreshing];

        if (result.code == 0) {
            [weakSelf requestDidSuccess:result];
        }else{
            [weakSelf requestDidFailure:result];
        }
        self.loading = NO;
    } failure:^(LGHttpResult * _Nonnull result) {
        [weakSelf.refreshFooter endRefreshing];
        [weakSelf requestDidFailure:result];
        self.loading = NO;
    }];
}


/** 首次加载*/
- (void)requestData:(BOOL)cache{
    __weak typeof(self) weakSelf = self;
    self.nextPage = @"";

    if (cache) {
        [self.request getCacheDataSuccess:^(LGHttpResult * _Nonnull result) {

            if (result.code == 0) {
                [self.dataArray removeAllObjects];
                [weakSelf requestDidSuccess:result];
            }
        } failure:nil];
    }else{
        self.loading = YES;
        [self.request startRequsetWithSuccess:^(LGHttpResult * _Nonnull result) {

            if (result.code == 0) {
                [self.dataArray removeAllObjects];
                [weakSelf requestDidSuccess:result];
            }else{
                [weakSelf requestDidFailure:result];
            }
            self.loading = NO;
        } failure:^(LGHttpResult * _Nonnull result) {
            [weakSelf requestDidFailure:result];
            self.loading = NO;
        }];
    }
}

- (void)requestDidSuccess:(LGHttpResult *)result{

    if ([result.data stringForKey:@"nextPage"]) {
        self.nextPage = [result.data valueForKey:@"nextPage"];
    }

    if ([result.data stringForKey:@"lastRequestTime"]) {
        self.lastRequestTime = [result.data valueForKey:@"lastRequestTime"];
    }

    NSArray *listArray = [result.data valueForKey:@"list"];
    // 字典转模型
    for (int i = 0; i<listArray.count; i++) {
        NSDictionary *dict = listArray[i];
        Class modelClass = self.modelClass;
        DataModel *dataModel = [[modelClass alloc] initWithDictionary:dict];
        [self.dataArray addObject:dataModel];
    }

    [self showEmpetyView:self.dataArray.count==0];
    [self showErrorView:NO];

    [self.tableView reloadData];
    self.refreshFooter.hidden = YES;

    if (self.refreshHeader.refreshing) {
        [self.refreshHeader endRefreshing];
    }

    if (self.complete) {
        self.complete(result);
    }
}

- (void)requestDidFailure:(LGHttpResult *)result{

    [self showEmpetyView:NO];
    [self showErrorView:self.dataArray.count == 0];

    self.refreshFooter.hidden = YES;

    if (self.refreshHeader.refreshing) {
        [self.refreshHeader endRefreshing];
    }

    if (self.failure) {
        self.failure(result);
    }

    LGLog(@"requestDidFailure:%@",result.message);
}



#pragma mark   -  懒加载
- (EmptyView *)emptyView{
    if (_emptyView == nil) {
        _emptyView = [[EmptyView alloc] init];
    }
    return _emptyView;
}

- (ErrorView *)errorView{
    if (_errorView == nil) {
        _errorView = [[ErrorView alloc] init];
    }
    return _errorView;
}
@end








@implementation UITableViewCell (Extension)

@dynamic indexPath;
@dynamic dataModel;
@dynamic cellDelegate;

static NSString *indexPathKey = @"indexPathKey";
static NSString *dataModelKey = @"dataModelKey";
static NSString *cellDelegateKey = @"cellDelegateKey";

- (void)setDataModel:(DataModel *)dataModel{
    objc_setAssociatedObject(self, &dataModelKey, dataModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

- (void)setIndexPath:(NSIndexPath *)indexPath{
    objc_setAssociatedObject(self, &indexPathKey, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setCellDelegate:(id<NSObject>)cellDelegate{
    objc_setAssociatedObject(self, &cellDelegateKey, cellDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DataModel *)dataModel{
    return objc_getAssociatedObject(self, &dataModelKey);
}

- (NSIndexPath *)indexPath{
    return objc_getAssociatedObject(self, &indexPathKey);
}

- (id<NSObject>)cellDelegate{
    return objc_getAssociatedObject(self, &cellDelegateKey);
}

@end


@implementation DataModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

    // [Example] change property id to productID

    //  if([key isEqualToString:@"id"]) {
    //      self.productID = value;
    //      return;
    //  }
    // show undefined key
    NSLog(@"%@.h have undefined key '%@', the key's type is '%@'.", NSStringFromClass([self class]), key, [value class]);
}

- (void)setValue:(id)value forKey:(NSString *)key {

    // 过滤空值
    if ([value isKindOfClass:[NSNull class]] || value == nil) {
        [super setValue:@"" forKey:key];
    }
    // 对象
    else if([value isKindOfClass:NSString.class]){
        [super setValue:value forKey:key];
    }
    // Number 转 字符串
    else if([value respondsToSelector:@selector(stringValue)]){
        [super setValue:[value stringValue] forKey:key];
    }
    else if ([value isKindOfClass:NSArray.class]){

        NSArray *list = (NSArray *)value;
        NSMutableArray *modelList = [NSMutableArray array];
        NSString *className = [[self objectClassInArray] valueForKey:key];
        Class modelClass = NSClassFromString(className);

        if (className.length && [modelClass isSubclassOfClass:DataModel.class]) {
            for (int i = 0; i<[list count]; i++) {
                DataModel *dataModel = [[modelClass alloc] initWithDictionary:list[i]];
                [modelList addObject:dataModel];
            }
            [super setValue:modelList forKey:key];
        }else{
            [super setValue:value forKey:key];
        }
    }else if ([value isKindOfClass:NSDictionary.class]){
        NSString *className = [[self objectClassInDictionary] valueForKey:key];
        Class modelClass = NSClassFromString(className);
        if (className.length && [modelClass isSubclassOfClass:DataModel.class]) {
            DataModel *dataModel = [[modelClass alloc] initWithDictionary:value];
            [super setValue:dataModel forKey:key];
        }else{
            [super setValue:value forKey:key];
        }
    }
    else{
        [super setValue:[value description] forKey:key];
    }
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {

    if ([dictionary isKindOfClass:[NSDictionary class]]) {

        if (self = [super init]) {
            [self setValuesForKeysWithDictionary:dictionary];
        }
    }
    return self;
}

#pragma mark   -  子类实现
- (NSDictionary *)objectClassInArray{
    return @{};
}
- (NSDictionary *)objectClassInDictionary{
    return @{};
}
@end

