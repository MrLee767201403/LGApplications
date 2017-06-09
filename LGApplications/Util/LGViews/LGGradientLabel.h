//
//  LGGradientLabel.h
//  LGApplications
//
//  Created by 李刚 on 2017/6/9.
//  Copyright © 2017年 李刚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGGradientLabel : UILabel

/**  默认由左向右*/
@property (nonatomic, assign) ColorDirection direction;

/**  颜色数组*/
// 例: label.colors = @[(id)[UIColor greenColor].CGColor,(id)[UIColor yellowColor].CGColor];
@property (nonatomic, strong) NSArray *colors;
@end
