//
//  LGActionSheet.h
//
//  Created by  Mr.Lee on 16/11/3.
//  Copyright © 2016年 Mr.Lee. All rights reserved.
//

// 背景色没设置 就是有点丑 其他没毛病
// tableView,选中的背景色都可以改
// title 太长没处理
#import <UIKit/UIKit.h>

#pragma mark - LGActionSheetDelegate
@class LGActionSheet;
@protocol LGActionSheetDelegate <NSObject>

/** 点击回调 必须实现 buttonIndex为子标题的索引 不含标题和取消*/
- (void)actionSheet:(LGActionSheet *)actionSheet clickedAtIndex:(NSInteger)buttonIndex;

@optional
/** 点击取消  取消后若要执行某些操作,可在此方法的回调中执行*/
- (void)actionSheetCancel;
@end


#pragma mark - interface
@interface LGActionSheet : UIView

// 自定义样式 都有默认值可以不传
/** 标题字体*/
@property (nonatomic, strong) UIFont *titleFont;

/** 子标题字体  */
@property (nonatomic, strong) UIFont *subTitleFont;

/** 标题颜色*/
@property (nonatomic, strong) UIColor *titleColor;

/** 子标题颜色*/
@property (nonatomic, strong) UIColor *subTitleColor;

/** 分割线颜色  默认灰色(0xdfdbdc)*/
@property (nonatomic, strong) UIColor *separatorColor;


// 事件
/** 点击title是否关闭 默认YES*/
@property (nonatomic, assign) BOOL closeOnClick;

/** 点击空白是否关闭  默认YES*/
@property (nonatomic, assign) BOOL closeOnTouch;



// 需要传入的参数
/** 标题*/
@property (nonatomic, strong) NSString *actionTitle;

/** 子标题数组*/
@property (nonatomic, strong) NSArray *subTitles;

/** 代理*/
@property (nonatomic, weak) id<LGActionSheetDelegate>actionDelegate;


#pragma mark - 方法
/** 初始化 必须调用show方法 代理不能为空*/
+ (LGActionSheet *)actionSheetWithTitle:(NSString *)title subTitles:(NSArray *)titles delegate:(id<LGActionSheetDelegate>) actionDelegate;

/** 初始化 必须调用show方法 代理不能为空*/
- (LGActionSheet *)initWithTitle:(NSString *)title subTitles:(NSArray *)titles delegate:(id<LGActionSheetDelegate>) actionDelegate;


/** 弹出*/
- (void)show;

/** 关闭*/
- (void)disMiss;
@end




/*****************************      使用方法   ****************************/
/*
 - (void)buttonClicK:(UIButton *)button{
    // 创建
    LGActionSheet *actionSheet = [[LGActionSheet alloc] initWithTitle:nil subTitles:@[@"加为好友",@"拉黑",@"举报",@"拉黑并举报",@"删除"] delegate:self];
    // 显示
    [actionSheet show];
 
 }
 
 
 - (void)actionSheet:(LGActionSheet *)actionSheet clickedAtIndex:(NSInteger)buttonIndex{
    // 做想做的事
    NSString *title = actionSheet.subTitles[buttonIndex];
 }
 
*/

/*****************************      使用方法   ****************************/

