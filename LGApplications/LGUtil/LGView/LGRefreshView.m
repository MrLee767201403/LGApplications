//
//  LGRefreshView.m
//  Lit
//
//  Created by 李刚 on 2019/7/26.
//  Copyright © 2019 ligang. All rights reserved.
//

#import "LGRefreshView.h"

@interface LGRefreshView ()
@property (nonatomic, strong) UIImageView *circleImage;
@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic, assign )NSInteger type;  // 0:自定义图片选转, 1:系统activity
@end
@implementation LGRefreshView

- (instancetype)init
{
    return [self initWithFrame:CGRectMake(kScreenWidth*0.5, 100, 50, 50)];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame animationType:1];
}

- (instancetype)initWithFrame:(CGRect)frame animationType:(NSInteger)type
{
    self = [super initWithFrame:frame];
    if (self) {
        _isAnimation = NO;
        _type = type;
        if (type == 0) {
            _circleImage = [[UIImageView alloc] initWithFrame:self.bounds];
            _circleImage.image = Image(@"loading");
            [self addSubview:_circleImage];
        }
        // 系统activity
        else{
            _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [self addSubview:_activity];
        }
        self.hidden = YES;
    }
    return self;
}


- (void)beginRefresh{
    self.hidden = NO;
    if (self.type == 0) {
        [self beginAutoCircleAnimation];
    }else{
        [self beginAutoAnimation];
    }
}

- (void)endRefresh{
    self.hidden = YES;
    if (self.type == 0) {
        [self stopAutoCircleAnimation];
    }else{
        [self stopAutoAnimation];
    }
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    _circleImage.image = Image(imageName);
}

#pragma mark -  type = 1 系统 activity
- (void)beginAutoAnimation{
    _isAnimation = YES;
    [self.activity startAnimating];
}

- (void)stopAutoAnimation{
    _isAnimation = NO;
    [self.activity stopAnimating];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if(self.circleImage) self.circleImage.frame = self.bounds;
    if(self.activity) self.activity.frame = self.bounds;
}
#pragma mark -  type = 0 自定义旋转
- (CABasicAnimation *)circleAnimation{
    CABasicAnimation *circleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    circleAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    circleAnimation.toValue   = [NSNumber numberWithFloat:2.0 * M_PI];
    circleAnimation.duration  = 0.8;
    circleAnimation.repeatCount  = MAXFLOAT;
    circleAnimation.removedOnCompletion = NO;
    return circleAnimation;
}

- (void)beginAutoCircleAnimation{
    _isAnimation = YES;
    self.transform = CGAffineTransformMakeRotation(0.0);
    [self.layer addAnimation:[self circleAnimation] forKey:@"circleAnimation"];
}

- (void)stopAutoCircleAnimation{
    _isAnimation = NO;
    CAAnimation *animation = [self.layer animationForKey:@"circleAnimation"];
    if (animation) {
        [self.layer removeAnimationForKey:@"circleAnimation"];
        self.transform = CGAffineTransformMakeRotation(0.0);
    }
}

- (void)circlingImageByOffset:(CGFloat)offset{
    if (self.hidden == YES) self.hidden = NO;
    if (offset <= 0) {
        self.transform = CGAffineTransformMakeRotation(offset/10);
    } else{
        self.transform = CGAffineTransformMakeRotation(0.0);
    }

    if (offset<0 && _isAnimation == YES) {
        [self stopAutoCircleAnimation];
        [_activity stopAnimating];
    }
}

@end
