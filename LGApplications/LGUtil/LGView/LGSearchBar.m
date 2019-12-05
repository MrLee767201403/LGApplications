//
//  LGSearchBar.m
//  HumanResource
//
//  Created by 李刚 on 2019/10/16.
//  Copyright © 2019 ligang. All rights reserved.
//

#import "LGSearchBar.h"

#define kSearchBarIconWidth   16
#define kSearchBarIconSpace   10

@implementation LGSearchBar

- (instancetype)init
{
    return [self initWithSearchIcon:Image(@"theme_search")];
}

- (instancetype)initWithSearchIcon:(UIImage *)image
{
    self = [super init];
    if (self) {

        self.frame = CGRectMake(20, kStatusBarHeight, kScreenWidth-100, 44);
        self.placeholder = @"搜索职位/公司";
        self.searchBarStyle = UISearchBarStyleMinimal;
        self.backgroundImage = [UIImage new]; // 去边框
        self.alignmentCenter = NO;

        // searchField.backgroundColor = backColor; 失效
        UIColor *backColor = [kColorWithFloat(0xF7F7F7) colorWithAlphaComponent:0.15];
        UIImage *backImage = [UIImage imageWithColor:backColor size:CGSizeMake(self.width, 34)];
        [self setSearchFieldBackgroundImage:backImage forState:UIControlStateNormal];

        // 替换搜索图标
        [self setImage:image forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        // 调整搜索图标偏移 居左+8
        [self setPositionAdjustment:UIOffsetMake(8, 0) forSearchBarIcon:UISearchBarIconSearch];
        // 调整搜索文字偏移 居左+8
        [self setSearchTextPositionAdjustment:UIOffsetMake(8, 0)];
        // 调整searchField偏移 居左+4
        [self setSearchFieldBackgroundPositionAdjustment:UIOffsetMake(4, 0)];

        // 字体 圆角 颜色
        UITextField *searchField = [self valueForKey:@"searchField"];
        searchField.font = kBoldFontWithName(kFontNamePingFangSCSemibold, 12);
        searchField.width = self.width;
        searchField.height = 34;
        searchField.textColor = kColorWhite;
        searchField.layer.cornerRadius = 17;
        searchField.layer.masksToBounds = YES;
        searchField.backgroundColor = backColor;
        searchField.returnKeyType = UIReturnKeySearch;
        [searchField setValue:kColorWhite forKeyPath:@"placeholderLabel.textColor"];

    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];

    // 设置搜索框居中
    UITextField *searchField = [self valueForKey:@"searchField"];
    if (iOS11Later && self.alignmentCenter && !self.isFirstResponder) {
        [self setPositionAdjustment:UIOffsetMake((searchField.width-[self placeholderWidth])/2, 0) forSearchBarIcon:UISearchBarIconSearch];
    }else{
        [self setPositionAdjustment:UIOffsetMake(8, 0) forSearchBarIcon:UISearchBarIconSearch];
    }
}

- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    UITextField *searchField = [self valueForKey:@"searchField"];
    searchField.textColor = textColor;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    UITextField *searchField = [self valueForKey:@"searchField"];
    [searchField setValue:placeholderColor forKeyPath:@"placeholderLabel.textColor"];
}


- (void)setShowsCancelButton:(BOOL)showsCancelButton{

    [super setShowsCancelButton:showsCancelButton];

    if (showsCancelButton) {
        // 取消按钮 文字 颜色 字体  实际类型为UINavigationButton
        // cancelButton.titleLabel.font = kFontWithSize(12); 不生效
        UIButton *cancelButton = [self valueForKeyPath:@"cancelButton"];
        [cancelButton setTitleColor:kColorDark forState:UIControlStateNormal];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setValue:kFontWithSize(12) forKeyPath:@"titleLabel.font"];
        [cancelButton setValue:kColorDark forKeyPath:@"titleLabel.textColor"];
    }
}


// 开始编辑的时候重置为靠左
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    if (iOS11Later) {
        [self setPositionAdjustment:UIOffsetMake(8, 0) forSearchBarIcon:UISearchBarIconSearch];
    }
    // 继续传递代理方法
    if ([self.delegate respondsToSelector:@selector(searchBarShouldBeginEditing:)]) {
        return  [self.delegate searchBarShouldBeginEditing:self];
    }else{
        return YES;
    }
}

// 结束编辑的时候设置为居中
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {

    if (iOS11Later && self.alignmentCenter && textField.text.length == 0) {
        [self setPositionAdjustment:UIOffsetMake((textField.width-[self placeholderWidth])/2, 0) forSearchBarIcon:UISearchBarIconSearch];
    }

    if ([self.delegate respondsToSelector:@selector(searchBarShouldEndEditing:)]) {
        return [self.delegate searchBarShouldEndEditing:self];
    }else{
        return YES;
    }
}


- (CGFloat)placeholderWidth {
    CGFloat placeholderWidth = 0;
    CGSize size = [self.placeholder boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kBoldFontWithName(kFontNamePingFangSCSemibold, 12)} context:nil].size;
    placeholderWidth = size.width + kSearchBarIconWidth + kSearchBarIconSpace + self.searchTextPositionAdjustment.horizontal;

    return placeholderWidth;
}

/*
 // 通过 UIBarButtonSystemItemFixedSpace 调整搜索框和导航栏按钮的间距
 UIBarButtonItem *rightItem =  [[UIBarButtonItem alloc] initWithTitle:@"乌鲁木齐市" color:kColorWhite image:@"job_location" target:self action:@selector(locationButtonEvent)];
 UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
 space.width = 7;
 self.navigationItem.rightBarButtonItems = @[rightItem,space];

 self.searchBar = [[LGSearchBar alloc] initWithSearchIcon:Image(@"job_search")];
 self.searchBar.delegate = self;
 self.navigationItem.title = nil;
 self.navigationItem.titleView = self.searchBar;
 */
@end




#pragma mark   -  自定义
@implementation LGCustomSearchBar

- (instancetype)init
{
    return [self initWithFrame:CGRectMake(20, 5, kScreenWidth-76, 34)];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = kBoldFontWithName(kFontNamePingFangSCMedium, 14);
        self.leftViewMode = UITextFieldViewModeAlways;
        self.textColor = kColorDark;
        self.tintColor = kColorDark;
        self.placeholder = @"搜索职位/公司";
        self.placeholderColor = kColorGray;
        self.iconView = [[UIImageView alloc] init];
        self.iconView.contentMode = UIViewContentModeCenter;
        self.icon = Image(@"theme_search");
        self.leftView = self.iconView;
        self.backgroundColor = kColorWithFloat(0xF5F6F7);
        self.navicationOffset = 0;
        self.layer.cornerRadius = self.height/2.0;
        self.layer.masksToBounds = YES;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat w = self.width;

    if (self.left < self.navicationOffset) {
        self.left = self.navicationOffset;
        self.width = w - self.navicationOffset;
    }
}

- (void)setIcon:(UIImage *)icon{
    _icon = icon;
    _iconView.image = icon;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    UIImage *backImage = [UIImage imageWithColor:backgroundColor size:CGSizeMake(self.width, 34)];
    [self setBackground:backImage];
}

- (void)setPlaceholder:(NSString *)placeholder{
    [super setPlaceholder:placeholder];
    [self setPlaceholderColor:self.placeholderColor];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;

    if (placeholderColor == nil || self.placeholder == nil) return;

    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:self.placeholder];
    [attString addAttribute:NSFontAttributeName value:kBoldFontWithName(kFontNamePingFangSCSemibold, 14) range:NSMakeRange(0, self.placeholder.length)];
    [attString addAttribute:NSForegroundColorAttributeName value:placeholderColor range:NSMakeRange(0, self.placeholder.length)];
    self.attributedPlaceholder = attString;
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds{
    return CGRectMake(15, 0, kSearchBarIconWidth, 34);
}

- (CGRect)textRectForBounds:(CGRect)bounds{
    CGRect rect = [super textRectForBounds:bounds];
    rect.origin.x = 39;
    return rect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds{
    CGRect rect = [super editingRectForBounds:bounds];
    rect.origin.x = 39;
    return rect;
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds{
    return CGRectMake(39, 0, bounds.size.width - 60, 34);
}

- (CGFloat)placeholderWidth {
    CGFloat placeholderWidth = 0;
    CGSize size = [self.placeholder boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kBoldFontWithName(kFontNamePingFangSCSemibold, 14)} context:nil].size;
    placeholderWidth = size.width + 30 + kSearchBarIconWidth + kSearchBarIconSpace;
    return placeholderWidth;
}


- (void)textFieldDidChange{
    if (self.searchDelegate && [self.searchDelegate respondsToSelector:@selector(customSearchBar:textDidChange:)]) {
        [self.searchDelegate customSearchBar:self textDidChange:self.text];
    }
}

@end
