//
//  InputViewDemo.m
//  LGApplications
//
//  Created by 李刚 on 2017/8/11.
//  Copyright © 2017年 李刚. All rights reserved.
//

#import "InputViewDemo.h"
#import "LGInputView.h"

@interface InputViewDemo ()<LGInputViewDelegate>
@property (nonatomic, strong) UILabel *label;

@end

@implementation InputViewDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, kScreenWidth - 30, 180)];
    self.label.numberOfLines = 0;
    [self.view addSubview:self.label];
    
    LGInputView *inputView = [[LGInputView alloc] init];
    inputView.y = kScreenHeight - 64 - inputView.height;
    inputView.delegate = self;
    [self.view addSubview:inputView];
}


- (void)inputViewDidChange:(LGInputView *)inputView{
    self.label.text = inputView.text;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
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
