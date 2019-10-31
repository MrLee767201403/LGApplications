//
//  EmptyView.h
//  Lit
//
//  Created by 李刚 on 2019/8/5.
//  Copyright © 2019 ligang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EmptyView : UIView
@property (nonatomic, copy) NSString *text;

- (void)showInView:(UIView *)view;
- (void)disMiss;
@end


@interface ErrorView : EmptyView
@property (nonatomic, copy) ActionBlock retryBlock;
@end
NS_ASSUME_NONNULL_END
