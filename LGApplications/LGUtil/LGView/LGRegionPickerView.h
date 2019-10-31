//
//  LGRegionPickerView.h
//  HumanResource
//
//  Created by 李刚 on 2019/10/18.
//  Copyright © 2019 ligang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LGRegionPickerView;
@protocol RegionPickerDelegate <NSObject>

- (void)regionPickerView:(LGRegionPickerView *)pickerView selectedTitle:(NSString *)selectedTitle;
@optional
- (void)regionPickerViewDidDisMiss:(LGRegionPickerView *)pickerView;
@end
@interface LGRegionPickerView : UIView
@property (nonatomic, weak) id<RegionPickerDelegate>delegate;
@property (nonatomic, strong) NSString *title;

/** 自动滚动到这个城市 省市区之间用空格隔开 而且传入的省市区的和数据源的严格相当*/
@property (nonatomic, strong) NSString *address;

@property (nonatomic, strong, readonly) UIPickerView *pickerView;

/**  地区选择*/
@property (nonatomic, strong, readonly) NSString *selectedCity;
@property (nonatomic, strong, readonly) NSString *selectedProvince;
@property (nonatomic, strong, readonly) NSString *selectTitle;
@property (nonatomic, strong, readonly) NSString *selectID;

- (void)show;
- (void)disMissPicker;

+ (NSString *)cityWithID:(NSString *)cityID;
@end
NS_ASSUME_NONNULL_END
