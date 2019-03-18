//
//  AlertViewDemo.m
//  LGApplications
//
//  Created by 李刚 on 2019/3/18.
//  Copyright © 2019 李刚. All rights reserved.
//

#import "AlertViewDemo.h"
#import "LGAlertView.h"

@interface AlertViewDemo ()

@end

@implementation AlertViewDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"AlertViewDemo";

    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(30, 200, kScreenWidth-60, 45)];
    button1.backgroundColor = kColorWithFloat(0xfc3030);
    [button1 setTitle:@"弹出" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(button1ClicK) forControlEvents:UIControlEventTouchUpInside];

    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(30, button1.bottom+20, kScreenWidth-60, 45)];
    button2.backgroundColor = kColorWithFloat(0xfc3030);
    [button2 setTitle:@"弹出" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(button2ClicK) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    [self.view addSubview:button2];

}

- (void)button1ClicK{

    LGAlertView *alert = [[LGAlertView alloc] initWithContent:@"这是两个按钮的弹窗"];
    alert.yesHandle = ^{
        [LGToastView showToastWithSuccess:@"点击了确定"];
    };
    alert.noHandle = ^{
        [LGToastView showToastWithSuccess:@"点击了取消"];
    };
    [alert show];
}

- (void)button2ClicK{

    LGAlertView *alert = [[LGAlertView alloc] initWithContent:@"这是一个按钮的弹窗"];
    alert.singleButton = YES;
    alert.yesHandle = ^{
        [LGToastView showToastWithSuccess:@"点击了确定"];
    };
    [alert show];
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
