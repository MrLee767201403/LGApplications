//
//  MainController.m
//  LGApplications
//
//  Created by 李刚 on 2017/6/7.
//  Copyright © 2017年 李刚. All rights reserved.
//

#import "MainController.h"

@interface MainController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *viewArray;
@property (nonatomic, strong) NSArray *animationArray;
@property (nonatomic, strong) NSArray *functionArray;

@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的项目";
    NSLog(@"%@", NSStringFromCGRect([UIScreen mainScreen].bounds));

    // 让self.view从导航栏下开始显示
    self.navigationController.navigationBar.translucent = NO;
    
    // 添加tableView
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = kColorBackground;
    [self.view addSubview:self.tableView];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return self.viewArray.count;
            break;
        case 1:
            return self.animationArray.count;
            break;
        case 2:
            return self.functionArray.count;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ListCell"];
        // 选中颜色
        UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 43)];
        selectView.backgroundColor = kColorBackground;
        cell.selectedBackgroundView = selectView;
        
        // 分割线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 43, kScreenWidth, 1)];
        line.backgroundColor = kColorBackground;
        [cell.contentView addSubview:line];
    }
    
    
    // 移除每个分区最后一个cell的分隔线
    UIView *line = cell.contentView.subviews.lastObject;
    if (line.height == 1 ) {
        if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] -1) {
            line.hidden = YES;
        }
        else{
            line.hidden = NO;
        }
    }
    
    NSString *title = @"";
    NSDictionary *dic = nil;
    // 本地已知数据.无需判断每个分区有没有数据
    // 有自定义控件
    if (indexPath.section == 0 && self.viewArray.count>indexPath.row) {
        dic = self.viewArray[indexPath.row];
        title = dic[@"title"];
    }
    // 动画效果
    else if (indexPath.section == 1 && self.animationArray.count>indexPath.row){
        dic = self.animationArray[indexPath.row];
        title = dic[@"title"];
    }
    // 功能类
    else if(indexPath.section == 2 && self.functionArray.count>indexPath.row){
        dic = self.functionArray[indexPath.row];
        title = dic[@"title"];
    }
    
    cell.textLabel.text = title;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self pushToDetail:indexPath];
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.view.width - 15, 25)];
    bgView.backgroundColor = kColorRGBAlpha(243, 243, 243, 0.8);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.view.width - 15, 25)];
    label.font = kFontMiddle;
    label.textColor = kColorWithFloat(0x8d8c92);
    if (section == 0) {
        label.text = @"自定义控件";
    }
    else if(section == 1){
        label.text = @"各种动画效果";
    }
    else{
        label.text = @"功能类";
    }
    [bgView addSubview:label];
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}



- (void)pushToDetail:(NSIndexPath *)indexPath{
    
    NSString *className = @"";
    NSDictionary *dic = nil;
    
    // 自定义控件
    if (indexPath.section == 0) {
        dic = self.viewArray[indexPath.row];
        className = dic[@"ClassName"];
    }
    
    // 动画效果
    else if (indexPath.section == 1){
        dic = self.animationArray[indexPath.row];
        className = dic[@"ClassName"];
    }
    
    // 功能类
    else if (indexPath.section == 2){
        dic = self.functionArray[indexPath.row];
        className = dic[@"ClassName"];
    }
    Class VCClass = NSClassFromString(className);
    
    if (VCClass) {
        UIViewController *VC = [[VCClass alloc] init];
        
        if (VC && [VC isKindOfClass:[UIViewController class]]) {
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
    
}




#pragma mark   - 懒加载数据

- (NSArray *)viewArray{
    
    if (_viewArray == nil) {
        _viewArray = @[@{@"ClassName":@"ActionSheetDemo",@"title":@"ActionSheet"},
                       @{@"ClassName":@"PickerDemoController",@"title":@"PickerView"},
                       @{@"ClassName":@"InputViewDemo",@"title":@"InputView"},
                       @{@"ClassName":@"SingleChoiceDemo",@"title":@"SingleChoiceTableView"}];
    }
    
    return _viewArray;
}

- (NSArray *)animationArray{
    
    if (_animationArray == nil) {
        _animationArray = @[@{@"ClassName":@"GradientAnimationDemo",@"title":@"文字渐变动画"},
//                           @{@"ClassName":@"",@"title":@"帧动画"},
//                           @{@"ClassName":@"",@"title":@"缩放"}
                            ];

    }
    
    return _animationArray;
}

- (NSArray *)functionArray{
    if (_functionArray == nil) {
        _functionArray = @[@{@"ClassName":@"HomeController",@"title":@"scorllView嵌套"},
//                           @{@"ClassName":@"",@"title":@"文件下载"},
//                           @{@"ClassName":@"",@"title":@"网络视频播放"},
//                           @{@"ClassName":@"",@"title":@"大图预览"}
                           ];

    }
    return _functionArray;
}
@end
