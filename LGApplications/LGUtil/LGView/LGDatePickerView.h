//
//  LGDatePickerView.h
//  HumanResource
//
//  Created by 李刚 on 2019/10/12.
//  Copyright © 2019 ligang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LGDatePickerView;
@protocol LGDatePickerDelegate <NSObject>

- (void)datePickerView:(LGDatePickerView *)pickerView selectedDate:(NSString *)date;
@optional
- (void)datePickerViewDidDisMiss:(LGDatePickerView *)pickerView;
@end

@interface LGDatePickerView : UIView
@property (nonatomic, strong, readonly) UIPickerView *pickerView;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *month;
@property (nonatomic, strong) NSString *date;

/**  是否是是开始日期 (开始日期没有 至今)*/
@property (nonatomic, assign) BOOL isStart;

@property (nonatomic, weak) id<LGDatePickerDelegate> delegate;

- (void)show;
- (void)disMissPicker;
@end


NS_ASSUME_NONNULL_END
