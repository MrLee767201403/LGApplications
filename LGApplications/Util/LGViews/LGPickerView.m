//
//  LGPickerView.m
//  LGApplications
//
//  Created by 李刚 on 2017/6/5.
//  Copyright © 2017年 李刚. All rights reserved.
//

#import "LGPickerView.h"


@interface LGPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, strong)NSMutableArray *citys;         // 当前省份的所有城市
@property (nonatomic, strong)NSMutableArray *provinces;     // 所有省份

@property (nonatomic, strong)NSMutableDictionary *provinceDic;  // 当前省份
@property (nonatomic, strong)NSMutableDictionary *cityDic;      // 当前省份 当前城市
@end

@implementation LGPickerView

- (void)setOptions:(NSArray *)options{
    _options = options;
    [_pickerView reloadAllComponents];
}

- (NSMutableArray *)provinces{
    if (_provinces == nil) {
        _provinces = [NSMutableArray array];
        
        NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"district" ofType:@"json"]];
        
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        // 省份
        _provinces = dic[@"citys"];
        _provinceDic = _provinces[0];
        _selectedProvince = _provinceDic[@"name"];
        
        // 城市
        _citys = _provinceDic[@"child"];
        _cityDic = _citys[0];
        _selectedCity = _cityDic[@"name"];
    }
    return _provinces;
}

- (instancetype)initWithType:(PickerType)type
{
    self = [super initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kPickerHeight)];
    if (self) {
        _type = type;
        _citys = [NSMutableArray array];
        _provinceDic = [NSMutableDictionary dictionary];
        _cityDic = [NSMutableDictionary dictionary];
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 40)];
    topView.backgroundColor = kColorBackground;
    [self addSubview:topView];
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [closeBtn setImage:[UIImage imageNamed:@"close_button_icon"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(disMissPicker) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:closeBtn];
    
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 40, 0, 40, 40)];
    [sureBtn setImage:[UIImage imageNamed:@"complete_button_icon"] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:sureBtn];
    
    if (_type != PickerTypeDate) {
        UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, self.width, self.height-40)];
        picker.backgroundColor = [UIColor whiteColor];
        picker.delegate = self;
        picker.dataSource = self;
        if ([picker numberOfComponents]&& [picker numberOfRowsInComponent:0]) {
            [picker selectRow:0 inComponent:0 animated:NO];
        }
        
        _pickerView = picker;
        [self addSubview:picker];
    }else{
        
        UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, self.width, self.height-40)];
        picker.backgroundColor = [UIColor whiteColor];
        picker.datePickerMode = UIDatePickerModeDate;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [picker setMaximumDate:[NSDate date]];
        [picker setMinimumDate:[dateFormatter dateFromString:@"1888-1-1"]];
        [picker setDate:[dateFormatter dateFromString:@"1993-1-1"]];
        _datePicker = picker;
        [self addSubview:picker];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.top = kScreenHeight - 64 - kPickerHeight;
    }];
}

- (void)setDistrict:(NSString *)district{
    _district = district;
    if (district == nil) return;
    NSString *province = [district componentsSeparatedByString:@" "].firstObject;
    NSString *city = [district componentsSeparatedByString:@" "].lastObject;
   
    NSDictionary *provinceDic = self.provinces[0];
    NSDictionary *cityDic = nil;
    NSArray *cityArray = nil;
    
    _selectedProvince = province;
    _selectedCity = city;
    
    // 匹配省份
    for (int i = 0; i<self.provinces.count; i++) {
        provinceDic = self.provinces[i];
        
        if ([province isEqualToString:provinceDic[@"name"]]) {
            [_pickerView selectRow:i inComponent:0 animated:YES];
            cityArray = provinceDic[@"child"];
            break;
        }
    }
    
    // 匹配城市
    for (int j = 0; j < cityArray.count; j++) {
        cityDic = cityArray[j];
        if ([city isEqualToString:cityDic[@"name"]]){
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [_pickerView selectRow:j inComponent:1 animated:YES];
            }];
            
            break;
        }
    }
}

- (void)setDateString:(NSString *)dateString{
    _dateString = dateString;
    if (dateString == nil) return;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [_datePicker setDate:[dateFormatter dateFromString:dateString]];
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    [_pickerView selectRow:currentIndex inComponent:0 animated:YES];
}

- (void)sureButtonClick{
    
    if (_selectTitle ==nil) {
        if (_type == PickerTypeDefault) {
            _selectTitle = _options.count>_currentIndex ?  _options[_currentIndex]: @"";
        }else if (_type == PickerTypeDistrict){
            _selectTitle = [NSString stringWithFormat:@"%@ %@",_selectedProvince,_selectedCity];
        }else if (_type == PickerTypeDate) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            _selectTitle = [dateFormatter stringFromDate:_datePicker.date];
        }
    }
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(pickerView:selectedTitle:)]) {
        [self.delegate pickerView:self selectedTitle:_selectTitle];
    }
    [self disMissPicker];
    NSLog(@"%@",_selectTitle);

}

- (void)disMissPicker{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, kScreenHeight, self.width, self.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(pickerViewDidDisMiss:)]) {
        [self.delegate pickerViewDidDisMiss:self];
    }
}


// 选中回调
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (_type == PickerTypeDefault) {
        _selectTitle = _options[row];
    }else{
        
        if (component == 0) {
            NSMutableDictionary *provinceDic = self.provinces[row];
            _selectedProvince = provinceDic[@"name"];
            _citys = provinceDic[@"child"];
            
            NSMutableDictionary *cityDic = _citys[0];
            _selectedCity = cityDic[@"name"];
            
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView reloadComponent:1];
        }else if (component == 1){
            NSMutableDictionary *cityDic = _citys[row];
            _selectedCity = cityDic[@"name"];
        }
        _selectTitle = [NSString stringWithFormat:@"%@ %@",_selectedProvince,_selectedCity];
    }
}

#pragma mark - 数据源
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (_type == PickerTypeDefault) {
        return 1;
    }else{
        return 2;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    // 基本信息选项
    if (_type == PickerTypeDefault) {
        return self.options.count;
    }
    
    // 地区
    else{
        if (component == 0) {
            return self.provinces.count;
        }else{
            return self.citys.count;
        }
    }
}


//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    if (_type == PickerTypeDefault) {
//        return self.options[row];
//    }else{
//        if (component == 0) {
//            self.provinceDic = self.provinces[row];   // 每个省份的数据
//            self.citys = self.provinceDic[@"child"];  // 当前省份所有成市
//            [pickerView reloadComponent:1];
//            return self.provinceDic[@"name"];
//        }else{
//           
//            self.cityDic = self.citys[row];            // 当前省份的 每个城市数据
//            return self.cityDic[@"name"];
//        }
//    }
//}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{

    if (_type == PickerTypeDistrict) {
        return (kScreenWidth-30)/3.0;
    }else{
        return (kScreenWidth-30)/([pickerView numberOfComponents]*1.0);
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 55;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = kColorWithFloat(0x131117);
    titleLabel.font = kFontMiddle;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
    NSString * title = @"";
    if (_type == PickerTypeDefault) {
        title = self.options[row];
    }else{
        
        if (component == 0) {
            self.provinceDic = self.provinces[row];   // 每个省份的数据
            self.citys = self.provinceDic[@"child"];  // 当前省份所有成市
            [pickerView reloadComponent:1];
            title = self.provinceDic[@"name"];
        }else{
            
            self.cityDic = self.citys[row];            // 当前省份的 每个城市数据
            title = self.cityDic[@"name"];
        }
        
    }
    titleLabel.text = title;
    return titleLabel;
}
@end
