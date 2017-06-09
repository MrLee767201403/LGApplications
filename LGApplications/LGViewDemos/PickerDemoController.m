//
//  PickerDemoController.m
//  LGApplications
//
//  Created by 李刚 on 2017/6/7.
//  Copyright © 2017年 李刚. All rights reserved.
//

#import "PickerDemoController.h"
#import "LGPickerView.h"

@interface PickerDemoController ()<PickerViewDelegate>
@property (nonatomic, strong) LGPickerView *pickerView;

@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIButton *button3;

@end

@implementation PickerDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"PickerViewDemo";
    
    self.button1 = [[UIButton alloc] initWithFrame:CGRectMake(30, 200, kScreenWidth-60, 45)];
    self.button2 = [[UIButton alloc] initWithFrame:CGRectMake(30, self.button1.bottom+20, kScreenWidth-60, 45)];
    self.button3 = [[UIButton alloc] initWithFrame:CGRectMake(30, self.button2.bottom+20, kScreenWidth-60, 45)];
    
    self.button1.backgroundColor = kColorWithFloat(0xfc3030);
    self.button2.backgroundColor = kColorWithFloat(0xfc3030);
    self.button3.backgroundColor = kColorWithFloat(0xfc3030);
    [self.button1 setTitle:@"默认" forState:UIControlStateNormal];
    [self.button2 setTitle:@"地区" forState:UIControlStateNormal];
    [self.button3 setTitle:@"时间" forState:UIControlStateNormal];
    
    [self.button1 addTarget:self action:@selector(buttonClicK:) forControlEvents:UIControlEventTouchUpInside];
    [self.button2 addTarget:self action:@selector(buttonClicK:) forControlEvents:UIControlEventTouchUpInside];
    [self.button3 addTarget:self action:@selector(buttonClicK:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.button1];
    [self.view addSubview:self.button2];
    [self.view addSubview:self.button3];

}

- (void)buttonClicK:(UIButton *)button{
    
    if (self.pickerView) {
        [self.pickerView removeFromSuperview];
        self.pickerView = nil;
    }
    
    if (button == self.button1) {
        self.pickerView = [[LGPickerView alloc] initWithType:PickerTypeDefault];
        self.pickerView.delegate = self;
        self.pickerView.options = @[@"110",@"119",@"120",@"999",@"12358",@"12306",@"10086",@"10000",];
    }
    if (button == self.button2) {
        self.pickerView = [[LGPickerView alloc] initWithType:PickerTypeDistrict];
        self.pickerView.delegate = self;
    }
    if (button == self.button3) {
        self.pickerView = [[LGPickerView alloc] initWithType:PickerTypeDate];
        self.pickerView.delegate = self;
    }
    
    [self.view addSubview:self.pickerView];
}



- (void)pickerView:(LGPickerView *)pickerView selectedTitle:(NSString *)selectedTitle{
    
    switch (pickerView.type) {
        case PickerTypeDefault:
            [self.button1 setTitle:selectedTitle forState:UIControlStateNormal];
            break;
        case PickerTypeDistrict:
            [self.button2 setTitle:selectedTitle forState:UIControlStateNormal];
            break;
        case PickerTypeDate:
            [self.button3 setTitle:selectedTitle forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
}

@end
