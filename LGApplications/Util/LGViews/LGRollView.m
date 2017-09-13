//
//  LGRollView.m
//  LGApplications
//
//  Created by 李刚 on 2017/9/9.
//  Copyright © 2017年 李刚. All rights reserved.
//

#import "LGRollView.h"

@implementation LGRollView

{
    UIButton *_label;
}
//if not create with nib this will be called
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //do something
        self.layer.masksToBounds = YES;
        _label = [UIButton buttonWithType:UIButtonTypeCustom];
        _label.frame = frame;
        _label.hidden = YES;
        [_label setTitleColor:kColorWithFloat(0x131117) forState:UIControlStateNormal];
        _label.titleLabel.font = kFontSmall;
        _label.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        self.button = _label;
        [self addSubview:_label];
    }
    return self;
}

-(void)setTitles:(NSArray *)array duration:(CGFloat)second{
    
    if (array.count!=0) {
        _titles = array;
        
        _label.hidden = NO;
        [_label setTitle:array[0] forState:UIControlStateNormal];
        _label.frame = self.bounds;
        
        _index = 0;
        [self startScroll:second];
    }else{
        [_label setTitle:@"默认信息..." forState:UIControlStateNormal];
    }
}

- (void)setTitles:(NSArray *)titles{
    _titles = titles;
    _index = 0;
}

- (CGFloat)widthWithString:(NSString *)string
{
    UIFont *font= _label.titleLabel.font;
    CGSize size = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : font} context:nil].size;
    return size.width+20.0;
}

- (void)startScroll:(NSInteger)seconds
{
    [self fadeLayer:_label.layer];
    _index++;
    if (_index == _titles.count) {
        _index = 0;
    }
    NSString *tempStr = _titles[_index];
    [_label setTitle:tempStr forState:UIControlStateNormal];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startScroll:seconds];;
    });
}

//渐隐
-(void)fadeLayer:(CALayer *)layer{
    //CATransition
    CATransition *animation = [CATransition animation];
    //    animation.delegate = self;
    animation.duration = .5;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    //    animation.type = kCATransitionFade;
    animation.type = @"push";
    
    if (self.direction == DirectionTop) {
        animation.subtype = kCATransitionFromTop;
    }else if (self.direction == DirectionLeft){
        animation.subtype = kCATransitionFromLeft;
    }else if (self.direction == DirectionBottom){
        animation.subtype = kCATransitionFromBottom;
    }else if (self.direction == DirectionRight){
        animation.subtype = kCATransitionFromRight;
    }else{
        animation.subtype = kCATransitionFromTop;
    }
    
    [layer addAnimation:animation forKey:@"animation"];
}



@end
