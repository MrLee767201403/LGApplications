//
//  LGDatePickerView.m
//  HumanResource
//
//  Created by 李刚 on 2019/10/12.
//  Copyright © 2019 ligang. All rights reserved.
//

#import "LGDatePickerView.h"
#define kPickerHeight   260

@interface LGDatePickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSMutableArray *years;
@property (nonatomic, strong) NSMutableArray *months;
@property (nonatomic, strong) UILabel *titleLabel;

@end


@implementation LGDatePickerView

- (NSMutableArray *)years{
    if (_year == nil) {

        int year = [[NSUtil stringWithDate:[NSDate date] format:@"yyyy"] intValue];
        NSMutableArray *years = @[].mutableCopy;
        for (int i = 1970; i <= year; i++) {
            [years addObject:NSStringFormat(@"%d",i)];
        }
        [years addObject:@"至今"];
        _years = [NSMutableArray arrayWithArray:years];
    }
    return _years;
}

- (NSMutableArray *)months{
    if (_months == nil) {
        _months = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"].mutableCopy;
    }
    return _months;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpSubViews];
        _year = [NSUtil stringWithDate:[NSDate date] format:@"yyyy"];;
        _month = [NSUtil stringWithDate:[NSDate date] format:@"MM"];;
        self.date = [NSString stringWithFormat:@"%@.%@",self.year,self.month];
    }
    return self;
}

- (void)setUpSubViews{

    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    self.alpha = 0;

    _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kPickerHeight)];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contentView];

    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, kScreenWidth-100, 44)];
    _titleLabel.font = kFontWithName(kFontNamePingFangSCMedium, 14);
    _titleLabel.textColor = kColorDark;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:_titleLabel];

    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    closeBtn.titleLabel.font = kFontWithSize(14);
    [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
    [closeBtn setTitleColor:kColorGray forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(disMissPicker) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:closeBtn];

    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 55, 0, 50, 44)];
    sureBtn.titleLabel.font = kFontWithSize(14);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:kColorRed forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:sureBtn];


    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, self.width, _contentView.height-40)];
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    if ([_pickerView numberOfComponents]&& [_pickerView numberOfRowsInComponent:0]) {
        [_pickerView selectRow:0 inComponent:0 animated:NO];
    }

    [_contentView addSubview:_pickerView];
}

- (void)setDate:(NSString *)date{
    _date = date;
    if (date == nil || date.length <= 0) return;

    if ([date isEqualToString:@"至今"]) {
        _year = date;
        [_pickerView selectRow:self.years.count-1 inComponent:0 animated:NO];
        [_pickerView selectRow:0 inComponent:1 animated:NO];
    }
    else if(date.length == 7){
        _year = [date substringToIndex:4];
        _month = [date substringFromIndex:date.length-2];
        [_pickerView selectRow:[self.years indexOfObject:_year] inComponent:0 animated:NO];
        [_pickerView selectRow:[self.months indexOfObject:_month] inComponent:1 animated:NO];
    }
}

- (void)setIsStart:(BOOL)isStart{
    _isStart = isStart;

    if (isStart) {
        [self.years removeObject:@"至今"];
        self.year = self.years.lastObject;
    }
    [self.pickerView reloadAllComponents];
}
#pragma mark   -  点击确定

- (void)sureButtonClick{

    if ([self.year isEqualToString:@"至今"]) {
        _date = self.year;
        _month = @"";
    }else{
        _date = [NSString stringWithFormat:@"%@.%@",self.year,self.month];
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(datePickerView:selectedDate:)]) {
        [self.delegate datePickerView:self selectedDate:self.date];
    }
    [self disMissPicker];
}

#pragma mark   -  显示 && 取消
- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
        self.contentView.top = kScreenHeight - kPickerHeight;
    }];
}

- (void)disMissPicker{

    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        self.contentView.frame = CGRectMake(0, kScreenHeight, self.contentView.width, self.contentView.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

    if (self.delegate && [self.delegate respondsToSelector:@selector(datePickerViewDidDisMiss:)]) {
        [self.delegate datePickerViewDidDisMiss:self];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self disMissPicker];
}

#pragma mark   -  代理

// 选中回调
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    if (component == 0) {
        self.year = self.years[row];
        [pickerView reloadAllComponents];
    }
    else{
        self.month = self.months[row];
    }

    // 如果选的是今年
    NSString *year = [NSUtil stringWithDate:[NSDate date] format:@"yyyy"];
    if ([self.year isEqualToString:year]) {

        NSString *month = [NSUtil stringWithDate:[NSDate date] format:@"MM"];

        // 如果大于当月
        if (self.month.integerValue>month.integerValue) {
            [pickerView selectRow:[self.months indexOfObject:month] inComponent:1 animated:YES];
            self.month = month;
        }
    }

    if ([self.year isEqualToString:@"至今"]) {
        _date = self.year;
    }else{
        _date = [NSString stringWithFormat:@"%@.- %@",self.year,self.month];
    }
}

#pragma mark - 数据源
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    if (component == 0) {
        return self.years.count;
    }else if(component == 1){
        return self.months.count;
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return (kScreenWidth-30)/2.0;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 55;
}



/**  自定义样式*/
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{

    UILabel *titleLabel;
    if (view == nil) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth-30)/2, 55)];
        titleLabel.textColor = kColorDark;
        titleLabel.font = kFontWithSize(16);
        titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    else{
        titleLabel = (UILabel *)view;
    }


    if (component == 0) {
        titleLabel.text = self.years[row];
    }
    else{
        titleLabel.text = [self.year isEqualToString:@"至今"]?nil: self.months[row];
    }
    return titleLabel;
}
@end
