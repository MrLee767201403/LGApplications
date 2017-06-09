//
//  ActionSheetDemo.m
//  LGApplications
//
//  Created by 李刚 on 2017/6/7.
//  Copyright © 2017年 李刚. All rights reserved.
//

#import "ActionSheetDemo.h"
#import "LGActionSheet.h"

@interface ActionSheetDemo ()<LGActionSheetDelegate>
@property (nonatomic, strong) UIButton *button;

@end

@implementation ActionSheetDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"ActionSheetDemo";
    
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(30, 200, kScreenWidth-60, 45)];
    
    self.button.backgroundColor = kColorWithFloat(0xfc3030);
    [self.button setTitle:@"弹出" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(buttonClicK:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
  
}

- (void)buttonClicK:(UIButton *)button{
    LGActionSheet *actionSheet = [[LGActionSheet alloc] initWithTitle:@"这是标题(可以没有)" subTitles:@[@"加为好友",@"拉黑",@"举报",@"拉黑并举报",@"删除"] delegate:self];
    [actionSheet show];
}


- (void)actionSheet:(LGActionSheet *)actionSheet clickedAtIndex:(NSInteger)buttonIndex{
    
    NSString *title = [NSString stringWithFormat:@"%@:%@",actionSheet.actionTitle,actionSheet.subTitles[buttonIndex]] ;
    
    [self.button setTitle:title forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
