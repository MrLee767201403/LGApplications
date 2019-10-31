//
//  LGSearchBar.m
//  HumanResource
//
//  Created by 李刚 on 2019/10/16.
//  Copyright © 2019 ligang. All rights reserved.
//

#import "LGSearchBar.h"

#define kSearchBarIconWeidth  16
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
    placeholderWidth = size.width + kSearchBarIconWeidth + kSearchBarIconSpace + self.searchTextPositionAdjustment.horizontal;

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
