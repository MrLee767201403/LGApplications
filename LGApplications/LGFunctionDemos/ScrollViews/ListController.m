//
//  ListController.m
//  ScrollViews
//
//  Created by 李刚 on 2017/6/30.
//  Copyright © 2017年 Mr.Lee. All rights reserved.
//

#import "ListController.h"

@interface ListController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 添加tableView
    self.navigationController.navigationBar.hidden = YES;

    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    // 占位View
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 264)];
    self.tableView.tableHeaderView = headerView;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        
    }
    cell.textLabel.text = [NSString stringWithFormat:@"闲来无事卖个萌 %ld",indexPath.row];
    return cell;
}
@end
