//
//  LGRangeSlider.m
//  Lit
//
//  Created by 李刚 on 2019/7/2.
//  Copyright © 2019 ligang. All rights reserved.
//

#import "LGRangeSlider.h"
#define kGap    10.0

@interface LGRangeSlider ()
@property (nonatomic, strong) UIView *bottomView;   // 主干
@property (nonatomic, strong) UIView *trackView;    // 选中部分

@property (nonatomic, assign) CGFloat minOffset;    //
@property (nonatomic, assign) CGFloat maxOffset;
@property (nonatomic, assign) CGFloat unitWidth;

@property (nonatomic, assign) BOOL minTouchOn;
@property (nonatomic, assign) BOOL maxTouchOn;

@end


@implementation LGRangeSlider

- (instancetype)init
{
    return [self initWithFrame:CGRectMake(35, 0, kScreenWidth-100, 25)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpSubviews];
    }
    return self;
}

- (CGFloat)unitWidth{
    _unitWidth = self.bottomView.width/(self.maxValue - self.minValue); // 1个数值的宽度
    return _unitWidth;
}

- (void)setUpSubviews{

    _minTouchOn = NO;
    _maxTouchOn = NO;
    _minValue = 16;
    _maxValue = 99;
    _selectedMinValue = 16;
    _selectedMaxValue = 24;

    _tintColor = kColorWithFloat(0xE5EAEF);
    _trackColor = kColorWithFloat(0xFF4B6D);

    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(kGap, 11, self.width-20, 3)];
    self.bottomView.backgroundColor = kColorWithFloat(0xE5EAEF);
    self.bottomView.layer.cornerRadius = 1.5;

    self.trackView = [[UIView alloc] initWithFrame:CGRectMake(kGap, 11, 20, 3)];
    self.trackView.backgroundColor = kColorWithFloat(0xFF4B6D);
    self.trackView.layer.cornerRadius = 1.5;

    self.minView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 21, 21)];
    self.minView.image = Image(@"slider");

    self.maxView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 2, 21, 21)];
    self.maxView.image = Image(@"slider");

    [self addSubview:self.bottomView];
    [self addSubview:self.trackView];
    [self addSubview:self.minView];
    [self addSubview:self.maxView];

    [self updateTrack];
}

- (void)setSelectedMaxValue:(NSInteger)selectedMaxValue{
    selectedMaxValue = selectedMaxValue > self.maxValue ? self.maxValue : selectedMaxValue;
    _selectedMaxValue = selectedMaxValue;
    [self updateTrack];
}

- (void)setSelectedMinValue:(NSInteger)selectedMinValue{
    selectedMinValue = selectedMinValue < self.minValue ? self.minValue : selectedMinValue;
    _selectedMinValue = selectedMinValue;
    [self updateTrack];
}

- (void)updateTrack{
    CGFloat trackX = kGap+(self.selectedMinValue-self.minValue)*self.unitWidth;
    CGFloat trackW = (self.selectedMaxValue - self.selectedMinValue)*self.unitWidth;
    self.trackView.frame = CGRectMake(trackX, 11, trackW, 3);
    self.minView.centerX = trackX;
    self.maxView.centerX = self.trackView.right;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchPoint = [touch locationInView:self];

    if(CGRectContainsPoint(self.minView.frame, touchPoint)){
        self.minTouchOn = YES;
        self.minOffset = touchPoint.x - self.minView.centerX;
    }

    if(CGRectContainsPoint(self.maxView.frame, touchPoint)){
        self.maxTouchOn = YES;
        self.maxOffset = touchPoint.x - self.maxView.centerX;
    }

    return YES;
}


- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{

    if(!self.minTouchOn && !self.maxTouchOn ){
        return YES;
    }

    CGPoint touchPoint = [touch locationInView:self];

    if(self.minTouchOn){

        CGFloat x = touchPoint.x - self.minOffset;
        CGFloat newValue = (x-kGap)/self.unitWidth + self.minValue;
        if(!self.maxTouchOn || newValue < self.selectedMinValue){
            self.maxTouchOn = NO;
            newValue = MAX(self.minValue, newValue);            // 不能小于最小值
            newValue = MIN(self.selectedMaxValue, newValue);    // 不能大于选中的最大值
            self.selectedMinValue = roundf(newValue);
        }
        else if (newValue == self.selectedMinValue){

        }
        else{
            self.minTouchOn = NO;  // （maxView 被选中） 并且 （新值>已选的最小值） minView 取消选中 由maxView滑动
        }
    }

    if(self.maxTouchOn){
        CGFloat x = touchPoint.x - self.maxOffset;
        CGFloat newValue = (x-kGap)/self.unitWidth + self.minValue;

        if(!self.minTouchOn || newValue > self.selectedMaxValue){
            self.minTouchOn = NO;
            newValue = MIN(self.maxValue, newValue);
            newValue = MAX(self.selectedMinValue, newValue);
            self.selectedMaxValue = roundf(newValue);
        }
        else if (newValue == self.selectedMinValue){

        }
        else{
            self.maxTouchOn = NO;  // （minView 被选中） 并且 （新值<=已选的最大值） maxView 取消选中  由minView滑动
        }
    }
    [self updateTrack];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    return YES;
}


- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{

    [self updateTrack];
    self.minTouchOn = NO;
    self.maxTouchOn = NO;
    [self sendActionsForControlEvents:UIControlEventValueChanged];

}
@end





@implementation LGSlider

- (instancetype)init
{
    return [self initWithFrame:CGRectMake(35, 50, kScreenWidth-100, 20)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.minimumValue = 0;
        self.maximumValue = 100;
        self.tintColor = kColorRed;
        self.layer.cornerRadius = 1.5;

        UIImage *maxImage = [UIImage imageWithColor:kColorWithFloat(0xE5EAEF) size:CGSizeMake(kScreenWidth-100, 3)];
        maxImage = [maxImage imageWithCornerRadius:1.5];
        [self setMaximumTrackImage:maxImage forState:UIControlStateNormal];

        UIImage *minImage = [UIImage imageWithColor:kColorRed size:CGSizeMake(kScreenWidth-100, 3)];
        minImage = [minImage imageWithCornerRadius:1.5];
        [self setMinimumTrackImage:minImage forState:UIControlStateNormal];

        [self setThumbImage:Image(@"slider") forState:UIControlStateNormal];
        [self setThumbImage:Image(@"slider") forState:UIControlStateHighlighted];

    }
    return self;
}

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
{
    rect.origin.x = rect.origin.x - 5 ;
    rect.origin.y = 0;
    rect.size.width = rect.size.width +10;
    rect.size.height = 21;
    return CGRectInset ([super thumbRectForBounds:bounds trackRect:rect value:value], 10 , 10);
}

- (CGRect)trackRectForBounds:(CGRect)bounds
{
    bounds.size.height = 3;
    bounds.origin.y = 9;
    self.layer.cornerRadius = 1.5;

    return bounds;
}
@end
