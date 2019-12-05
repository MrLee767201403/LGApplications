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


@class LGCustomSearchBar;
@protocol LGSearchBarDelegate <UITextFieldDelegate>

- (void)customSearchBar:(LGCustomSearchBar *)searchBar textDidChange:(NSString *)searchText;
@end

@interface LGCustomSearchBar : UITextField

@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, weak) id<LGSearchBarDelegate> searchDelegate;
@property (nonatomic, assign) CGFloat navicationOffset; // 修复导航栏frame

@end
NS_ASSUME_NONNULL_END
