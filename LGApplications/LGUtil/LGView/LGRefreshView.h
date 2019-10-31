//
//  LGRefreshView.h
//  Lit
//
//  Created by 李刚 on 2019/7/26.
//  Copyright © 2019 ligang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LGRefreshView : UIView

@property (nonatomic, assign, readonly)BOOL isAnimation;

@property (nonatomic, copy) NSString *imageName;

/** 初始化 0:自定义图片选转, 1:系统activity 默认是0(直接调用initWithFrame即可)*/
- (instancetype)initWithFrame:(CGRect)frame animationType:(NSInteger)type;

/** 根据偏移设置旋转*/
- (void)circlingImageByOffset:(CGFloat)offset;

/** 开始刷新*/
- (void)beginRefresh;

/** 结束刷新*/
- (void)endRefresh;
@end


NS_ASSUME_NONNULL_END
