//
//  IndexSectionView.h
//  Tutor
//
//  Created by 李刚 on 2018/11/19.
//  Copyright © 2018 Mr.Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class IndexSectionView;
@protocol IndexSectionDelegate <NSObject>

- (void)indexSectionView:(IndexSectionView *)view didSelecteedTitle:(NSString *)title atSectoin:(NSInteger)section;

@end


/**
 * 自定义tableView索引
 * self.tableView.showsVerticalScrollIndicator = NO;
 * self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 20);
 */
@interface IndexSectionView : UIView
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, weak) id<IndexSectionDelegate> delegate;

- (id)initWithTitles:(NSArray *)titles;
@end

NS_ASSUME_NONNULL_END
