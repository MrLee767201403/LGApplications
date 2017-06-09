//
//  LGPickerView.h
//  LGApplications
//
//  Created by 李刚 on 2017/6/5.
//  Copyright © 2017年 李刚. All rights reserved.
//


#import <UIKit/UIKit.h>
#define kPickerHeight 250

typedef enum : NSUInteger {
    PickerTypeDefault,
    PickerTypeDate,
    PickerTypeDistrict
} PickerType;

@class LGPickerView;
@protocol PickerViewDelegate <NSObject>

- (void)pickerView:(LGPickerView *)pickerView selectedTitle:(NSString *)selectedTitle;
@optional
- (void)pickerViewDidDisMiss:(LGPickerView *)pickerView;
@end

@interface LGPickerView : UIView
/** 这些是你要传给我滴 PickerTypeDefault 时必须设置options*/
@property (nonatomic, assign) PickerType type;
@property (nonatomic, weak) id<PickerViewDelegate>delegate;
@property (nonatomic, strong)NSArray *options;

/** 自动滚动到这个日期*/
@property (nonatomic, strong)NSString *dateString;
/** 自动滚动到这个城市*/
@property (nonatomic, strong)NSString *district;
/** 自动滚动到这个索引*/
@property (nonatomic, assign)NSInteger currentIndex;


/** 这些是我处理完返回给你滴*/
@property (nonatomic, strong, readonly)UIPickerView *pickerView;
@property (nonatomic, strong, readonly) UIDatePicker *datePicker;
@property (nonatomic, strong, readonly) NSString *selectedCity;
@property (nonatomic, strong, readonly) NSString *selectedProvince;
@property (nonatomic, strong, readonly)NSString *selectTitle;

- (instancetype)initWithType:(PickerType)type;
- (void)disMissPicker;
@end
