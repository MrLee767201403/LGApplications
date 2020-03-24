//
//  SliderDemo.m
//  LGApplications
//
//  Created by 李刚 on 2020/3/24.
//  Copyright © 2020 李刚. All rights reserved.
//

#import "SliderDemo.h"
#import "LGRangeSlider.h"

@interface SliderDemo ()
@property (nonatomic, strong) LGSlider *distanceSlider;
@property (nonatomic, strong) LGRangeSlider *ageSlider;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *ageLabel;

@end

@implementation SliderDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"SliderDemo";
    
    self.distanceSlider = [[LGSlider alloc] init];
    self.distanceSlider.top = 100;
    [self.distanceSlider addTarget:self action:@selector(distanceSliderEvent) forControlEvents:UIControlEventValueChanged];

    self.ageSlider = [[LGRangeSlider alloc] init];
    self.ageSlider.top = 200;
    [self.ageSlider addTarget:self action:@selector(ageSliderEvent) forControlEvents:UIControlEventValueChanged];

    self.distanceLabel = [self labelWithTitle:@"0" top:50];
    self.ageLabel = [self labelWithTitle:@"18-26" top:150];

    [self.view addSubview:self.distanceSlider];
    [self.view addSubview:self.ageSlider];
    [self.view addSubview:self.distanceLabel];
    [self.view addSubview:self.ageLabel];

}


- (void)distanceSliderEvent{
    NSString *distance = [NSString stringWithFormat:@"%ld mile",(long)roundf(self.distanceSlider.value)];

    self.distanceLabel.text = distance;
}

- (void)ageSliderEvent{
    NSString *minAge = [NSString stringWithFormat:@"%ld",(long)self.ageSlider.selectedMinValue];
    NSString *maxAge = [NSString stringWithFormat:@"%ld",(long)self.ageSlider.selectedMaxValue];
    NSString *age = [NSString stringWithFormat:@"%@ - %@",minAge,maxAge];
    self.ageLabel.text = age;
}

- (UILabel *)labelWithTitle:(NSString *)title top:(CGFloat)top
{
    UILabel *label = [[UILabel alloc] init];
    label.font = kFontWithSize(14);
    label.text = title;
    label.textColor = kColorDark;
    label.frame = CGRectMake(35, top, kScreenWidth-100, 30);
    return label;
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
