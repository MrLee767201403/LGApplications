//
//  LGActionSheet.m
//
//  Created by  Mr.Lee on 16/11/3.
//  Copyright © 2016年  Mr.Lee. All rights reserved.
//

// cell 高度
#define kCellHeigth 44.0
#import "LGActionSheet.h"

@interface LGActionSheet ()<UITableViewDelegate,UITableViewDataSource>
@property (assign, nonatomic) CGRect tableFrame;
@property (assign, nonatomic) CGFloat tableHeight;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIViewController *presentVC;

@end


@implementation LGActionSheet

#pragma mark - 初始化方法
+ (LGActionSheet *)actionSheetWithTitle:(NSString *)title subTitles:(NSArray *)titles delegate:(id<LGActionSheetDelegate>) actionDelegate;
{
    LGActionSheet *actionSheet = [[LGActionSheet alloc] initWithTitle:title subTitles:titles delegate:actionDelegate];
    return actionSheet;
}

- (LGActionSheet *)initWithTitle:(NSString *)title subTitles:(NSArray *)titles delegate:(id<LGActionSheetDelegate>) actionDelegate;
{
    self = [super init];
    if (self) {
        _actionTitle = title;
        _subTitles = titles;
        _actionDelegate = actionDelegate;
        
        // 默认值
        _closeOnTouch = YES;
        _closeOnClick = YES;
        
        _titleFont = kFontMiddle;
        _titleColor = kColorWithFloat(0x8d8c92);
        _subTitleFont = kFontLagre;
        _subTitleColor = kColorWithFloat(0x131117);
        _separatorColor = kColorSeparator;
        
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        
        // 一开始在屏幕外
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, height,width, self.tableHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        
        // tableView 应该显示的位置
        _tableFrame = CGRectMake(0, height - _tableHeight, width, _tableHeight);
        
        // 背景色有待确定
        self.backgroundColor = [UIColor colorWithRed:10/255.0 green:10/255.0 blue:10/255.0 alpha:0];
        _tableView.backgroundColor = kColorBackground;

    }
    return self;
}

#pragma mark - 弹出与关闭

// 弹出
- (void)show{
    self.frame = [UIScreen mainScreen].bounds;
    [UIApplication.sharedApplication.delegate.window addSubview:self];;

    // 从屏幕外动态弹出
    [UIView animateWithDuration:0.3 animations:^{
        // 背景色有待修改
        self.backgroundColor = [UIColor colorWithRed:10/255.0 green:10/255.0 blue:10/255.0 alpha:0.5];
        self.tableView.frame = self.tableFrame;
    }];
}


// 关闭
- (void)disMiss{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0] ;
        CGRect frame = self.tableView.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height;
        self.tableView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    if (self.closeOnTouch)  [self disMiss];
}

#pragma mark - tableView 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        // 标题和其他
        return self.actionTitle ? self.subTitles.count + 1 :self.subTitles.count;
    }else{
        // 取消
        return 1;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIColor *color  = self.subTitleColor;
    UIFont *font = self.subTitleFont;
    NSString * title = @"";
    UITableViewCellSelectionStyle style = UITableViewCellSelectionStyleGray;
    // 取消
    if (indexPath.section == 1) {
        title = @"取消";
    }
    else{
        // 有标题
        if (self.actionTitle) {
            // 标题 AND 样式
            if (indexPath.row == 0) {
                title = self.actionTitle;
                font =  self.titleFont;;
                color = self.titleColor;
                style = UITableViewCellSelectionStyleNone;
            }
            // 其他 子标题
            else{
                if (self.subTitles.count) {
                    title = self.subTitles[indexPath.row - 1];
                    // if ([title containsString:@"删除"])  color = kColorWithFloat(0xfc3050);
                }
            }
        }
        // 没标题
        else{
            title = self.subTitles[indexPath.row];
            // if ([title containsString:@"删除"])  color = kColorWithFloat(0xfc3050);
        }
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"actionCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"actionCell"];
     
        // 选中背景色
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = kColorHighlighted;
        cell.selectedBackgroundView = view;
        
        // 分割线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kCellHeigth - 0.5, self.frame.size.width, 0.5)];
        line.backgroundColor = self.separatorColor;
        [cell.contentView addSubview:line];
    }
    
    // 选中样式
    cell.selectionStyle = style;
    
    // 隐藏每个分区最后一个cell的分割线
    UIView *line = cell.contentView.subviews.lastObject;
    line.hidden = indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1;
    
    
    // 设置cell文字
    cell.textLabel.font = font;
    cell.textLabel.text = title;
    cell.textLabel.textColor = color;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;

    return cell;
}

#pragma mark - tableView 代理
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) return 0.0;
    return 5.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCellHeigth;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 取消
    if (indexPath.section == 1) {
        
        if ([self.actionDelegate respondsToSelector:@selector(actionSheetCancel)]) {
            [self.actionDelegate actionSheetCancel];
        }
        [self disMiss];
        return;
    }
    
    // 其他
    if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(actionSheet:clickedAtIndex:)]) {
        // 如果点击标题
        if (self.actionTitle && indexPath.row == 0) return;
        
        // 点击其他
        NSInteger index = self.actionTitle ? indexPath.row - 1 :indexPath.row;
        [self.actionDelegate actionSheet:self clickedAtIndex:index];
    }
    if (self.closeOnClick)  [self disMiss];
}


#pragma mark - get methed
- (CGFloat)tableHeight{
     _tableHeight = (self.actionTitle ? (self.subTitles.count + 2) : (self.subTitles.count + 1)) *kCellHeigth + 5.0;
    return _tableHeight;
}


#pragma mark - setter methed
- (void)setTitleColor:(UIColor *)titleColor{
    if (_titleColor != titleColor) {
        _titleColor  = titleColor;
    }
}

- (void)setTitleFont:(UIFont *)titleFont{
    if (_titleFont != titleFont) {
        _titleFont  = titleFont;
    }
}


- (void)setSubTitleColor:(UIColor *)subTitleColor{
    if (_subTitleColor != subTitleColor) {
        _subTitleColor  = subTitleColor;
    }
}

- (void)setSubTitleFont:(UIFont *)subTitleFont{
    if (_subTitleFont != subTitleFont) {
        _subTitleFont  = subTitleFont;
    }
}

- (void)setSeparatorColor:(UIColor *)separatorColor{
    if (_separatorColor != separatorColor) {
        _separatorColor = separatorColor;
    }
}
@end
