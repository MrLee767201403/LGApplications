//
//  LGPickerView.h
//  LGApplications
//
//  Created by 李刚 on 2017/6/5.
//  Copyright © 2017年 李刚. All rights reserved.
//


#import <UIKit/UIKit.h>
#define kPickerHeight 260

typedef enum : NSUInteger {
    PickerTypeDefault,  // 默认样式 穿options即可
    PickerTypeDate,     // 日期样式 系统默认datePicker
    PickerTypeDistrict, // 地区 省市区3级联动  依赖region.json文件
    PickerTypeCustom,   // 自定义样式 传入有几栏 每一栏的数据 最多三栏 不能联动
    PickerTypeObject,   // 直接传入一个数据optionObjects(里面是字典) 并设置显示哪一个属性showKey
} PickerType;

@class LGPickerView;
@protocol PickerViewDelegate <NSObject>

- (void)pickerView:(LGPickerView *)pickerView selectedTitle:(NSString *)selectedTitle;
@optional
- (void)pickerViewDidDisMiss:(LGPickerView *)pickerView;
@end

@interface LGPickerView : UIView

#pragma mark   - PickerTypeDefault 每个选项是字符串
/** 这些是您要传给我的  PickerTypeDefault 时必须设置options*/
@property (nonatomic, assign) PickerType type;
@property (nonatomic, weak) id<PickerViewDelegate>delegate;
@property (nonatomic, strong) NSArray *options;       // 数组里是字符串
@property (nonatomic, strong) NSString *title;


#pragma mark   - PickerTypeObject 每个选项是字典
/**  比如字典
 {
    @"name":@"通信工程"
    @"id":@"100001"
 }
 * 要显示通信工程 则showKey传 name
 * 要显示100001 则showKey传 id
 */
@property (nonatomic, strong) NSArray <NSDictionary *>* optionObjects; // 数组里是字典
@property (nonatomic, strong) NSString *showKey;   // 要显示的数据的键

#pragma mark   - PickerTypeCustom 每个选项是字符串
/**  自定义样式*/
@property (nonatomic, assign) NSInteger column; // 有几栏 1，2，3
@property (nonatomic, strong) NSArray *options_1;   // 第一栏数据源
@property (nonatomic, strong) NSArray *options_2;   // 第二栏数据源
@property (nonatomic, strong) NSArray *options_3;   // 第三栏数据源

#pragma mark   - PickerTypeDate
/** 自动滚动到这个日期*/
@property (nonatomic, strong) NSString *dateString;
/** 自动滚动到这个城市 省市区之间用空格隔开 而且传入的省市区的和数据源的严格相当*/
@property (nonatomic, strong) NSString *address;
/** 自动滚动到这个索引 ,（一栏的数据更新后会回传）*/
@property (nonatomic, assign) NSInteger currentIndex;




#pragma mark   - 这些是我处理完返回给你的
@property (nonatomic, strong, readonly) UIPickerView *pickerView;
@property (nonatomic, strong, readonly) UIDatePicker *datePicker;

#pragma mark   - PickerTypeDistrict
/**  地区选择*/
@property (nonatomic, strong, readonly) NSString *selectedCity;
@property (nonatomic, strong, readonly) NSString *selectedProvince;
@property (nonatomic, strong, readonly) NSString *selectDistrict;
@property (nonatomic, strong, readonly) NSString *selectTitle;
@property (nonatomic, strong, readonly) NSString *selectID;


#pragma mark   - PickerTypeObject 每个选项是字典
@property (nonatomic, strong, readonly) id selectObject;

#pragma mark   - PickerTypeCustom 每个选项是字符串
@property (nonatomic, strong, readonly) NSString *selectColumn1;
@property (nonatomic, strong, readonly) NSString *selectColumn2;
@property (nonatomic, strong, readonly) NSString *selectColumn3;

- (instancetype)initWithType:(PickerType)type;
- (void)show;
- (void)disMissPicker;

+ (NSString *)districtWithID:(NSString *)areaID;
@end

