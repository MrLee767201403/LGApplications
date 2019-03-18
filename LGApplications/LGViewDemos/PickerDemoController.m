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
@property (nonatomic, strong) UIButton *button4;
@property (nonatomic, strong) UIButton *button5;

@end

@implementation PickerDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"PickerViewDemo";
    
    self.button1 = [self buttonWithTop:150 title:@"默认"];
    self.button2 = [self buttonWithTop:self.button1.bottom+20 title:@"地区"];
    self.button3 = [self buttonWithTop:self.button2.bottom+20 title:@"时间"];
    self.button4 = [self buttonWithTop:self.button3.bottom+20 title:@"自定义"];
    self.button5 = [self buttonWithTop:self.button4.bottom+20 title:@"对象"];
}


- (UIButton *)buttonWithTop:(CGFloat)top title:(NSString *)title{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(30, top, kScreenWidth-60, 45)];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundColor:kColorWithFloat(0xfc3030)];
    [button addTarget:self action:@selector(buttonClicK:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    return button;
}

- (void)buttonClicK:(UIButton *)button{
    
    if (self.pickerView) {
        [self.pickerView disMissPicker];
        self.pickerView = nil;
    }
    
    if (button == self.button1) {
        self.pickerView = [[LGPickerView alloc] initWithType:PickerTypeDefault];
        self.pickerView.delegate = self;
        self.pickerView.options = @[@"110",@"119",@"120",@"999",@"12358",@"12306",@"10086",@"10000",];
    }
    else if (button == self.button2) {
        self.pickerView = [[LGPickerView alloc] initWithType:PickerTypeDistrict];
        self.pickerView.delegate = self;
    }
    else if (button == self.button3) {
        self.pickerView = [[LGPickerView alloc] initWithType:PickerTypeDate];
        self.pickerView.delegate = self;
    }
    else if (button == self.button4) {
        self.pickerView = [[LGPickerView alloc] initWithType:PickerTypeCustom];
        self.pickerView.column = 2;
        self.pickerView.options_1 = @[@"iOS",@"Java",@"JavaScript",@"PHP",@"Python",@"HTML5",@".NET"];
        self.pickerView.options_2 = @[@"4k-6k",@"6k-8k",@"8k-10k",@"10k-12k",@"12k-15k"];
        self.pickerView.delegate = self;
    }
    else if (button == self.button5) {
        self.pickerView = [[LGPickerView alloc] initWithType:PickerTypeObject];
        self.pickerView.optionObjects = @[@{@"name":@"name1",@"id":@"100001"},@{@"name":@"name2",@"id":@"100002"},
                                          @{@"name":@"name3",@"id":@"100003"},@{@"name":@"name4",@"id":@"100004"},
                                          @{@"name":@"name5",@"id":@"100005"},@{@"name":@"name6",@"id":@"100006"}];
        self.pickerView.showKey = @"name";
        self.pickerView.delegate = self;
    }

    [self.pickerView show];
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
        case PickerTypeCustom:
            [self.button4 setTitle:selectedTitle forState:UIControlStateNormal];
            break;
        case PickerTypeObject:
            [self.button5 setTitle:selectedTitle forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
}

@end
