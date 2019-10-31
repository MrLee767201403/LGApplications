//
//  LGRangeSlider.h
//  Lit
//
//  Created by 李刚 on 2019/7/2.
//  Copyright © 2019 ligang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LGRangeSlider : UIControl
@property (nonatomic, strong) UIColor *tintColor;  //
@property (nonatomic, strong) UIColor *trackColor;

@property (nonatomic, strong) UIImageView *minView; // 左边的滑动点
@property (nonatomic, strong) UIImageView *maxView; // 右边的滑动点

/**  最小值 默认16*/
@property (nonatomic, assign) NSInteger minValue;

/**  最大值 默认99*/
@property (nonatomic, assign) NSInteger maxValue;

/**  选中最小值 默认18*/
@property (nonatomic, assign) NSInteger selectedMinValue;

/**  选中最大值 默认26*/
@property (nonatomic, assign) NSInteger selectedMaxValue;

@end


@interface LGSlider : UISlider

@end
NS_ASSUME_NONNULL_END
