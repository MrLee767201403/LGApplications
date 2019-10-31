//
//  AppDelegate.h
//  HumanResource
//
//  Created by 李刚 on 2019/10/10.
//  Copyright © 2019 ligang. All rights reserved.
//


#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseScrollController : BaseViewController<UIScrollViewDelegate>
@property (nonatomic, strong, readonly) UIScrollView *scrollView;

@end

NS_ASSUME_NONNULL_END
