//
//  EmptyView.m
//  Lit
//
//  Created by 李刚 on 2019/8/5.
//  Copyright © 2019 ligang. All rights reserved.
//

#import "EmptyView.h"

@interface EmptyView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *textLabel;

@end


@implementation EmptyView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpSubviews];
    }
    return self;
}

- (void)setUpSubviews{
    self.userInteractionEnabled = NO;

    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-180)/2, 0, 180, 180)];
    self.imageView.image = Image(@"error_empty");
    self.imageView.contentMode = UIViewContentModeBottom;
    self.imageView.centerX = self.centerX;

    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, self.imageView.bottom+40, kScreenWidth-50, 60)];
    self.textLabel.font = kFontWithSize(16);
    self.textLabel.textColor = kColorGray;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.numberOfLines = 0;

    self.text = @"暂无数据";

    [self addSubview:self.imageView];
    [self addSubview:self.textLabel];
}

- (void)setText:(NSString *)text{
    _text = text;
    self.textLabel.text = text;
}

- (void)showInView:(UIView *)view{

    if ([view isKindOfClass:UITableView.class]) {
        UITableView *tableView = (UITableView *)view;
        self.frame = CGRectMake(0, tableView.tableHeaderView.height, view.width, view.height - tableView.tableHeaderView.height);
    }else{
        self.frame = view.frame;
    }
    self.imageView.centerY = (self.height-300)/2.0;
    self.imageView.centerX = self.centerX;
    self.textLabel.top = self.imageView.bottom+10;
    self.backgroundColor = view.backgroundColor;

    [view addSubview:self];
}

- (void)disMiss{
    [self removeFromSuperview];
}
@end





@implementation ErrorView

- (void)setUpSubviews{
    [super setUpSubviews];
    self.text = @"网络连接失败";
    self.imageView.image = Image(@"error_faild");

//    UIButton *retryButton = [[UIButton alloc] initWithFrame:CGRectMake(35, kScreenHeight-kBottomBarHeight-171, kScreenWidth-70, 48)];
//    retryButton.titleLabel.font = kFontWithName(kFontNamePingFangSCMedium, 16);
//    retryButton.layer.cornerRadius = 24;
//    retryButton.layer.borderColor = kColorRed.CGColor;
//    retryButton.layer.borderWidth = 1;
//    retryButton.clipsToBounds = YES;
//    [retryButton setTitle:@"重试" forState:UIControlStateNormal];
//    [retryButton setTitleColor:kColorWhite forState:UIControlStateNormal];
//    [retryButton addTarget:self action:@selector(retryButtonEvent) forControlEvents:UIControlEventTouchUpInside];
//
//    [self addSubview:retryButton];
}


- (void)retryButtonEvent{
    [self disMiss];
    if (self.retryBlock) self.retryBlock();
}
@end
