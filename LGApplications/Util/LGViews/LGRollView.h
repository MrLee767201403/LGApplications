//
//  LGRollView.h
//  LGApplications
//
//  Created by 李刚 on 2017/9/9.
//  Copyright © 2017年 李刚. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,Direction) {
    DirectionTop = 0,            // 默认
    DirectionLeft,
    DirectionBottom,
    DirectionRight
};


/**  循环滚动的广告条*/
@interface LGRollView : UIView
@property (nonatomic, assign)Direction direction; // 滚动方向
@property (nonatomic, weak)UIButton *button;
@property (nonatomic, assign, readonly) NSInteger index;
@property (nonatomic, strong) NSArray *titles;


/**  titles  second:每次滚动的间隔*/
-(void)setTitles:(NSArray *)array duration:(CGFloat)second;
@end
