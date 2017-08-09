//
//  ChildController.m
//  LGApplications
//
//  Created by 李刚 on 2017/6/14.
//  Copyright © 2017年 李刚. All rights reserved.
//

#import "ChildController.h"

@interface ChildController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ChildController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = @"只是测试数据而已,何必在意内容";
    
    return cell;
}




- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    // tableView不参与滑动 让rootScrollView
    // 整个头部滑上去后,再下滑时,由于惯性,tableView顶部的弹性
    if (self.tableView.contentOffset.y< 0 && self.rootScrollView.contentOffset.y > 0) {
        
        // 让底部的rootScrollView回弹
        if (self.rootScrollView.contentOffset.y < 0){
            [self.rootScrollView setContentOffset:CGPointZero animated:YES];
        }
        else{
           
            self.rootScrollView.contentOffset = CGPointMake(0, self.rootScrollView.contentOffset.y +scrollView.contentOffset.y);
             [self.tableView setContentOffset:CGPointZero];
        }
        
        if (self.rootScrollView.contentOffset.y<0 && scrollView.isDragging == NO) {
            [self.rootScrollView setContentOffset:CGPointZero animated:YES];
        }
        
        
    }
    // 只有当self.rootScrollView 偏移大于scrollEnabledPoint  tableView参与滑动
    else{
        
        // 小于 scrollEnabledPoint
        if (self.rootScrollView.contentOffset.y < self.scrollEnabledPoint ) {
            // 将tableView的偏移设置给rootScrollView
            CGFloat offset = self.rootScrollView.contentOffset.y +scrollView.contentOffset.y;
            offset = offset > self.scrollEnabledPoint ? self.scrollEnabledPoint : offset ;
            [self.rootScrollView setContentOffset:CGPointMake(0, offset)];
            [self.tableView setContentOffset:CGPointZero];
        }
        
        // 理论上此时rootScrollView不该小于0 (tableView快速滑动 减速时会出现)
        if (self.rootScrollView.contentOffset.y < 0) {
            [self.rootScrollView setContentOffset:CGPointZero animated:YES];
        }
        
        // 大于scrollEnabledPoint tableView滑动
        
    }
    
    
    // 正在拖拽
    if (scrollView.isDragging && self.rootScrollView.contentOffset.y<= 0) {
        [self.tableView setContentOffset:CGPointZero];
    }
    
}

// 拖拽结束 手指松开
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentOffset.y <= 0 && self.rootScrollView.contentOffset.y<0) {
        [self.rootScrollView setContentOffset:CGPointZero animated:YES];
    }
}


@end
