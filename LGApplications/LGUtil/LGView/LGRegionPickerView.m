//
//  LGRegionPickerView.m
//  HumanResource
//
//  Created by 李刚 on 2019/10/18.
//  Copyright © 2019 ligang. All rights reserved.
//

#import "LGRegionPickerView.h"
#define kPickerHeight   260

@interface LGRegionPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSMutableArray *provinces;     // 所有省份
@property (nonatomic, strong) NSMutableArray *cities;         // 当前省份的所有城市

@end


@implementation LGRegionPickerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cities = [NSMutableArray array];
        [self setUpSubviews];
    }
    return self;
}

- (void)setUpSubviews{

    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    self.alpha = 0;

    _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kPickerHeight+kBottomBarHeight)];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contentView];

    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, kScreenWidth-100, 44)];
    _titleLabel.font = kFontWithName(kFontNamePingFangSCMedium, 14);
    _titleLabel.textColor = kColorDark;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:_titleLabel];

    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, 50, 44)];
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



    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, self.width, _contentView.height-44-kBottomBarHeight)];
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    if ([_pickerView numberOfComponents]&& [_pickerView numberOfRowsInComponent:0]) {
        [_pickerView selectRow:0 inComponent:0 animated:NO];
    }

    [_contentView addSubview:_pickerView];

}

#pragma mark   -  设置数据
- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLabel.text = title;
}


- (NSMutableArray *)provinces{
    if (_provinces == nil) {
        _provinces = [NSMutableArray array];

        NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city" ofType:@"json"]];

        // 省份
        _provinces = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
        // 默认为全国
        NSDictionary *tempDic = _provinces.firstObject;
        _selectID = tempDic[@"id"];
        _selectedProvince = tempDic[@"name"];
        _selectedCity = tempDic[@"name"];
    }
    return _provinces;
}


+ (NSString *)cityWithID:(NSString *)cityID{
    return [[self alloc] cityWithID:cityID];
}

- (NSString *)cityWithID:(NSString *)cityID{
    if (cityID.length<6)    return @"";
    NSString *address = @"";
    NSString *pID = [[cityID substringToIndex:2] stringByAppendingString:@"0000"];  // 省ID
    NSString *cID = [[cityID substringToIndex:4] stringByAppendingString:@"00"];    // 市ID

    // 拿到省
    for (int i = 0; i<self.provinces.count; i++) {
        if ([pID isEqualToString:self.provinces[i][@"id"]]) {

            address = [address stringByAppendingString:self.provinces[i][@"name"]];
            self.cities = self.provinces[i][@"cities"];
            break;
        }
    }

    for (int i = 0; i<self.cities.count; i++) {
        NSString *city = self.cities[i][@"name"];
        if ([cID isEqualToString:self.cities[i][@"id"]]) {
            address = [address stringByAppendingString:@" "];
            address = [address stringByAppendingString:city];
            break;
        }
    }
    return address;
}


- (void)setAddress:(NSString *)address{
    _address = address;
    if (address == nil || address.length <= 0) return;
    NSArray *arr = [address componentsSeparatedByString:@" "];
    NSString *province = arr.firstObject;
    NSString *city = arr.lastObject;

    NSDictionary *provinceDic = self.provinces[0];
    NSDictionary *cityDic = nil;
    NSArray *cityArray = nil;

    _selectedProvince = province;
    _selectedCity = city;

    // 匹配省份
    for (int i = 0; i<self.provinces.count; i++) {
        provinceDic = self.provinces[i];
        if ([province isEqualToString:provinceDic[@"name"]]) {

            cityArray = provinceDic[@"cities"];
            cityDic = cityArray.firstObject;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.cities = [cityArray mutableCopy];
                self->_selectID = cityDic[@"id"];
                [self.pickerView reloadComponent:1];
                [self.pickerView selectRow:i inComponent:0 animated:YES];
            }];
            break;
        }
    }

    // 匹配城市
    for (int j = 0; j < cityArray.count; j++) {
        cityDic = cityArray[j];
        if ([city isEqualToString:cityDic[@"name"]]){

            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self->_selectID = cityDic[@"id"];
                [self.pickerView selectRow:j inComponent:1 animated:YES];
            }];
            break;
        }
    }
}

#pragma mark   -  点击确定事件

- (void)sureButtonClick{

    if (_selectTitle ==nil) {
        _selectTitle = [NSString stringWithFormat:@"%@ %@",_selectedProvince,_selectedCity];
    }

    if (self.delegate &&[self.delegate respondsToSelector:@selector(regionPickerView:selectedTitle:)]) {
        [self.delegate regionPickerView:self selectedTitle:_selectTitle];
    }
    [self disMissPicker];
    NSLog(@"%@",_selectTitle);

}

#pragma mark   -  显示 && 取消
- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
        self.contentView.top = kScreenHeight - kPickerHeight - kBottomBarHeight;
    }];
}

- (void)disMissPicker{

    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        self.contentView.top = kScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

    if (self.delegate &&[self.delegate respondsToSelector:@selector(regionPickerViewDidDisMiss:)]) {
        [self.delegate regionPickerViewDidDisMiss:self];
    }
}

#pragma mark   -  代理

// 选中回调
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    NSString *selectID = @"";
    NSDictionary * tempDic;
    if (component == 0) {

        if (row < _provinces.count) {
            tempDic = _provinces[row];
            _selectedProvince = tempDic[@"name"];
            _cities =  tempDic[@"cities"];
            selectID = tempDic[@"id"];
            
            if (_cities.count) {
                tempDic = _cities.firstObject;
            }
            _selectedCity = tempDic[@"name"];
            _selectID = tempDic[@"id"];

            [pickerView reloadAllComponents];
            [pickerView selectRow:0 inComponent:1 animated:YES];
        }

    }else if(component == 1){

        // 拿到数据源
        NSDictionary *tempDic = nil;
        if (row < self.cities.count) {
            tempDic = self.cities[row];
        }
        _selectID = tempDic[@"id"];
        _selectedCity = tempDic[@"name"];
    }

    if ([_selectedCity isEqualToString:@"全部"]) {
        _selectedCity = _selectedProvince;
        _selectTitle = _selectedProvince;
    }else{
        _selectTitle = [NSString stringWithFormat:@"%@ %@",_selectedProvince,_selectedCity];
    }
}

#pragma mark - 数据源
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    if (component == 0) {
        return self.provinces.count;
    }else if(component == 1){
        return self.cities.count;
    }
    return 0;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return kScreenWidth/2.0;
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

    CGFloat itemW = (kScreenWidth-40)/2.0;
    NSDictionary * tempDic;
    if (component == 0) {
        titleLabel.frame = CGRectMake(20, 0, itemW, 55);

        tempDic = _provinces[row];
        title = [tempDic objectForKey:@"name"];
    }
    else if(component == 1){
        titleLabel.frame = CGRectMake(0, 0, itemW, 55);

        if (row < self.cities.count) {
            tempDic = _cities[row];
        }
        title = [tempDic objectForKey:@"name"];

    }
    titleLabel.text = title;

    return titleLabel;
}
@end
