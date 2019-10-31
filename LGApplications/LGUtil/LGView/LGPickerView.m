//
//  LGPickerView.m
//  LGApplications
//
//  Created by 李刚 on 2017/6/5.
//  Copyright © 2017年 李刚. All rights reserved.
//

#import "LGPickerView.h"
@interface LGPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSMutableArray *provinces;     // 所有省份
@property (nonatomic, strong) NSMutableArray *cities;         // 当前省份的所有城市
@property (nonatomic, strong) NSMutableArray *districts;     // 当前城市的所有地区
@end

@implementation LGPickerView

#pragma mark   -  初始化

- (instancetype)initWithType:(PickerType)type
{
    self = [super init];
    if (self) {
        _type = type;
        _cities = [NSMutableArray array];
        _districts = [NSMutableArray array];
        [self setUpSubViews];
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
    _titleLabel.font = kFontWithSize(18);
    _titleLabel.textColor = kColorDark;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:_titleLabel];

    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    closeBtn.titleLabel.font = kFontWithName(kFontNamePingFangSCMedium, 16);
    [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
    [closeBtn setTitleColor:kColorMainTheme forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(disMissPicker) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:closeBtn];

    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 55, 0, 50, 44)];
    sureBtn.titleLabel.font = kFontWithName(kFontNamePingFangSCMedium, 16);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:kColorMainTheme forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:sureBtn];



    if (_type != PickerTypeDate) {
        UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, self.width, _contentView.height-44)];
        picker.backgroundColor = [UIColor whiteColor];
        picker.delegate = self;
        picker.dataSource = self;
        if ([picker numberOfComponents]&& [picker numberOfRowsInComponent:0]) {
            [picker selectRow:0 inComponent:0 animated:NO];
        }

        _pickerView = picker;
        [_contentView addSubview:picker];
    }else{

        UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, self.width, _contentView.height-40)];
        picker.backgroundColor = [UIColor whiteColor];
        picker.datePickerMode = UIDatePickerModeDate;

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [picker setMinimumDate:[dateFormatter dateFromString:@"1970-1-1"]];
        [picker setDate:[dateFormatter dateFromString:@"1993-1-1"]];
        _datePicker = picker;
        [_contentView addSubview:picker];
    }

}

#pragma mark   -  设置数据
- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLabel.text = title;
}
- (void)setOptions:(NSArray *)options{
    _options = options;
    [_pickerView reloadAllComponents];
}

- (void)setOptionObjects:(NSArray *)optionObjects{
    _optionObjects= optionObjects;
    [_pickerView reloadAllComponents];
}

- (NSMutableArray *)provinces{
    if (_provinces == nil) {
        _provinces = [NSMutableArray array];

        NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"region" ofType:@"json"]];

        // 省份
        _provinces = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
        // 当前默认省份
        NSDictionary *tempDic = _provinces[0];
        _selectedProvince = tempDic[@"name"];

        // 城市
        _cities = tempDic[@"cities"];
        tempDic = _cities[0];
        _selectedCity = tempDic[@"name"];

        // 地区
        _districts = tempDic[@"districts"];
        tempDic = _districts[0];
        _selectDistrict = tempDic[@"name"];
        _selectID = tempDic[@"id"];

        if ([_selectedCity isEqualToString:@"市辖区"]) {
            _selectedCity = @"";
        }
        if ([_selectDistrict isEqualToString:@"市辖区"]) {
            _selectDistrict = @"";
        }
    }
    return _provinces;
}


- (NSString *)districtWithID:(NSString *)areaID{
    if (areaID.length<6)    return @"";
    NSString *address = @"";
    NSString *pID = [[areaID substringToIndex:2] stringByAppendingString:@"0000"];  // 省ID
    NSString *cID = [[areaID substringToIndex:4] stringByAppendingString:@"00"];    // 市ID
    NSString *dID = areaID;                                                         // 区ID

    // 拿到省
    for (int i = 0; i<self.provinces.count; i++) {
        if ([pID isEqualToString:self.provinces[i][@"id"]]) {

            address = [address stringByAppendingString:self.provinces[i][@"name"]];
            self.cities = self.provinces[i][@"cities"];
            break;
        }
    }

    for (int i = 0; i<self.cities.count; i++) {
        if ([cID isEqualToString:self.cities[i][@"id"]]) {
            address = [address stringByAppendingString:self.cities[i][@"name"]];
            self.districts = self.cities[i][@"districts"];
            break;
        }
    }

    for (int i = 0; i<self.districts.count; i++) {
        if ([dID isEqualToString:self.districts[i][@"id"]]) {
            address = [address stringByAppendingString:self.districts[i][@"name"]];
            break;
        }
    }

    return address;
}

+ (NSString *)districtWithID:(NSString *)areaID{
    return [[self alloc] districtWithID:areaID];
}

#pragma mark   -  设置初始值
//
//- (void)setAddress:(NSString *)address{
//    _address = address;
//    if (address == nil) return;
//    NSArray *arr = [address componentsSeparatedByString:@" "];
//    NSString *province = arr.firstObject;
//    NSString *city = arr[1];
//    NSString *district = arr.lastObject;
//
//    // 直辖市
//    if (arr.count == 2) {
//        city = province;
//    }
//
//    NSDictionary *provinceDic = self.provinces[0];
//    NSDictionary *cityDic = nil;
//    NSString *districtStr = nil;
//    NSArray *cityArray = nil;
//    NSArray *districtArray = nil;
//
//    _selectedProvince = province;
//    _selectedCity = city;
//    _selectDistrict = district;
//
//    // 匹配省份
//    for (int i = 0; i<self.provinces.count; i++) {
//        provinceDic = self.provinces[i];
//
//        if ([province isEqualToString:provinceDic[@"name"]]) {
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                [_pickerView selectRow:i inComponent:0 animated:YES];
//            }];
//            cityArray = provinceDic[@"cities"];
//            break;
//        }
//    }
//
//    // 匹配城市
//    for (int j = 0; j < cityArray.count; j++) {
//        cityDic = cityArray[j];
//        if ([city isEqualToString:cityDic[@"name"]]){
//            districtArray = cityDic[@"districts"];
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                [_pickerView selectRow:j inComponent:1 animated:YES];
//            }];
//
//            break;
//        }
//    }
//
//    // 匹配地区
//    for (int k = 0; k < districtArray.count; k++) {
//        districtStr = districtArray[k];
//        if ([district isEqualToString:districtStr]){
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                [_pickerView selectRow:k inComponent:2 animated:YES];
//            }];
//            break;
//        }
//    }
//}

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

#pragma mark   -  点击确定事件

- (void)sureButtonClick{

    if (_selectTitle ==nil) {
        if (_type == PickerTypeDefault) {
            _selectTitle = _options.count>_currentIndex ?  _options[_currentIndex]: @"";
        }else if (_type == PickerTypeDistrict){
            _selectTitle = [NSString stringWithFormat:@"%@ %@ %@",_selectedProvince,_selectedCity,_selectDistrict];
            // 直辖市
            if ([_selectedProvince isEqualToString:_selectedCity]) {
                _selectTitle = [NSString stringWithFormat:@"%@ %@",_selectedCity,_selectDistrict];
            }
        }else if (_type == PickerTypeDate) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            _selectTitle = [dateFormatter stringFromDate:_datePicker.date];
        }else if (_type == PickerTypeCustom){
            _selectTitle = @"";

            if (_selectColumn1 == nil || _selectColumn1.length == 0) {
                _selectColumn1 = _options_1.count ? _options_1.firstObject :@"";
            }

            if (_selectColumn2 == nil || _selectColumn2.length == 0) {
                _selectColumn2 = _options_2.count ? _options_2.firstObject :@"";
            }

            if (_selectColumn3 == nil || _selectColumn3.length == 0) {
                _selectColumn3 = _options_3.count ? _options_3.firstObject :@"";
            }

            _selectTitle = [NSString stringWithFormat:@"%@ %@",_selectTitle,_selectColumn1];
            _selectTitle = [NSString stringWithFormat:@"%@ %@",_selectTitle,_selectColumn2];
            _selectTitle = [NSString stringWithFormat:@"%@ %@",_selectTitle,_selectColumn3];
        }else if (_type == PickerTypeObject) {

            if (self.optionObjects.count>_currentIndex) {
                id object = self.optionObjects[_currentIndex];
                _selectObject = object;
                _selectTitle = [[object valueForKey:self.showKey] description];
            }else{
                _selectTitle = @"";
                _selectObject = self.optionObjects.firstObject;
            }
        }

    }

    //    // 直辖市
    //    if ([_selectedProvince isEqualToString:_selectedCity]) {
    //        _selectTitle = [NSString stringWithFormat:@"%@ %@",_selectedCity,_selectDistrict];
    //    }

    if (self.delegate &&[self.delegate respondsToSelector:@selector(pickerView:selectedTitle:)]) {
        [self.delegate pickerView:self selectedTitle:_selectTitle];
    }
    [self disMissPicker];
    NSLog(@"%@",_selectTitle);

}

#pragma mark   -  显示 && 取消
- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
        _contentView.top = kScreenHeight - kPickerHeight;
    }];
}

- (void)disMissPicker{

    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        _contentView.frame = CGRectMake(0, kScreenHeight, _contentView.width, _contentView.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

    if (self.delegate &&[self.delegate respondsToSelector:@selector(pickerViewDidDisMiss:)]) {
        [self.delegate pickerViewDidDisMiss:self];
    }
}




- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self disMissPicker];
}

#pragma mark   -  代理

// 选中回调
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _currentIndex = row;
    if (_type == PickerTypeDefault) {
        _selectTitle = _options[row];
    }else if(_type == PickerTypeCustom){
        if (component == 0) {
            _selectColumn1 = self.options_1[row];
        }else if (component == 1){
            _selectColumn2 = self.options_2[row];
        }else if (component == 2){
            _selectColumn3 = self.options_3[row];
        }
    }else if(_type == PickerTypeObject){
        id object = self.optionObjects[row];
        _selectObject = object;
        _selectTitle = [[object valueForKey:self.showKey] description];
    }
    else{
        NSString *selectID = @"";
        NSDictionary * dicTemp;
        if (component == 0) {

            if (row < _provinces.count) {
                dicTemp = _provinces[row];
                _selectedProvince = [dicTemp objectForKey:@"name"];
                _cities = [dicTemp objectForKey:@"cities"];
                selectID = [dicTemp objectForKey:@"id"];

                dicTemp = _cities.firstObject;
                _selectedCity = [dicTemp objectForKey:@"name"];
                _districts = [dicTemp objectForKey:@"districts"];
                selectID = [dicTemp objectForKey:@"id"];

                dicTemp = _districts.firstObject;
                _selectDistrict = _districts.firstObject ?dicTemp[@"name"]:_selectedCity;
                _selectID = _districts.firstObject ?dicTemp[@"id"]:selectID;


                [pickerView reloadAllComponents];
                [pickerView selectRow:0 inComponent:1 animated:YES];
                [pickerView selectRow:0 inComponent:2 animated:YES];
            }

        }else if(component == 1){
            if (row < _cities.count ) {
                dicTemp = _cities[row];
                _selectedCity = [dicTemp objectForKey:@"name"];
                _districts = [dicTemp objectForKey:@"districts"];
                selectID = [dicTemp objectForKey:@"id"];

                dicTemp = _districts.firstObject;
                _selectDistrict = _districts.firstObject ?dicTemp[@"name"]:_selectedCity;
                _selectID = _districts.firstObject ?dicTemp[@"id"]:selectID;

                [pickerView reloadAllComponents];
                [pickerView selectRow:0 inComponent:2 animated:YES]; // 下一级可能能没有
            }else{
                [pickerView reloadComponent:2];
            }
        }else if(component == 2)
        {
            if(row<_districts.count){
                dicTemp = _districts[row];
                _selectDistrict = [dicTemp objectForKey:@"name"];
                _selectID = [dicTemp objectForKey:@"id"];
            }else{
                _selectDistrict = @"";
            }
        }
        //        if ([_selectedCity isEqualToString:@"市辖区"]) {
        //            _selectedCity = @"";
        //        }
        //        if ([_selectDistrict isEqualToString:@"市辖区"]) {
        //            _selectDistrict = @"";
        //        }
        _selectTitle = [NSString stringWithFormat:@"%@ %@ %@",_selectedProvince,_selectedCity,_selectDistrict];
    }
}

#pragma mark - 数据源
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (_type == PickerTypeDefault) {
        return 1;
    }else if(_type == PickerTypeObject){
        return 1;
    }
    else if(_type == PickerTypeCustom){
        return self.column;
    }else{
        return 3;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    // 基本信息选项
    if (_type == PickerTypeDefault) {
        return self.options.count;
    }
    else if (_type == PickerTypeObject){
        return self.optionObjects.count;
    }
    else if (_type == PickerTypeCustom){
        if (component == 0) {
            return self.options_1.count;
        }else if(component == 1){
            return self.options_2.count;
        }
        else{
            return self.options_3.count;
        }
    }
    // 地区
    else{
        if (component == 0) {
            return self.provinces.count;
        }else if(component == 1){
            return self.cities.count;
        }
        else{
            return self.districts.count;
        }
    }
}


/**   系统样式*/
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    if (_type == PickerTypeDefault) {
//        return self.options[row];
//    }else{
//
//        NSDictionary * dicTemp;
//        if (component == 0) {
//            dicTemp = _provinces[row];
//            return [dicTemp objectForKey:@"province"];
//        }else if(component == 1){
//            dicTemp = _cities[row];
//            return [dicTemp objectForKey:@"city"];
//        }else if(component == 2)
//        {
//            return _districts[row];
//        }
//    }
//    return @"";
//}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{

    if (_type == PickerTypeDistrict || [pickerView numberOfComponents] == 3) {
        return (kScreenWidth-30)/3.0;
    }
    else if (_type == PickerTypeCustom){
        return (kScreenWidth/self.column);
    }
    else{
        return kScreenWidth;
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 55;
}

/**  自定义样式*/
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)];
    titleLabel.textColor = kColorDark;
    titleLabel.font = kFontWithSize(14);
    titleLabel.textAlignment = NSTextAlignmentCenter;

    NSString * title = @"";
    if (_type == PickerTypeDefault) {
        title = self.options[row];
    }
    else if (_type == PickerTypeObject){
        id object = self.optionObjects[row];
        title = [[object valueForKey:self.showKey] description];
    }
    else if (_type == PickerTypeCustom){
        if (component == 0) {
            title = self.options_1[row];
        }else if(component == 1){
            title = self.options_2[row];
        }
        else{
            title = self.options_3[row];
        }
    }
    else{

        CGFloat itemW = (kScreenWidth-30)/3.0;
        NSDictionary * dicTemp;
        if (component == 0) {
            titleLabel.frame = CGRectMake(0, 0, itemW, 55);
            dicTemp = _provinces[row];
            title = [dicTemp objectForKey:@"name"];
        }else if(component == 1){
            titleLabel.frame = CGRectMake(0, 0, itemW, 55);
            dicTemp = _cities[row];
            title = [dicTemp objectForKey:@"name"];
            //            if ([title isEqualToString:@"市辖区"]) {
            //                title = [dicTemp objectForKey:@"province"];
            //            }
        }else if(component == 2)
        {
            titleLabel.frame = CGRectMake(0, 0, itemW, 55);
            dicTemp = _districts[row];
            title = [dicTemp objectForKey:@"name"];
            //            if ([title isEqualToString:@"市辖区"]) {
            //                title = [dicTemp objectForKey:@"city"];
            //            }
        }

    }
    titleLabel.text = title;


    return titleLabel;
}
@end
