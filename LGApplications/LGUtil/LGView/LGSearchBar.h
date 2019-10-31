//
//  LGSearchBar.h
//  HumanResource
//
//  Created by 李刚 on 2019/10/16.
//  Copyright © 2019 ligang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LGSearchBar : UISearchBar
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, assign) BOOL alignmentCenter;

- (instancetype)initWithSearchIcon:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
