//
//  SingleChoiceDemo.h
//  LGApplications
//
//  Created by 李刚 on 2017/6/8.
//  Copyright © 2017年 李刚. All rights reserved.
//

#import "BaseController.h"

@interface SingleChoiceDemo : BaseController

@end



#pragma mark   -----------------      问题模型      --------------------------

@interface QuestionModel : NSObject
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *answer_1;
@property (nonatomic, strong) NSString *answer_2;
@property (nonatomic, strong) NSString *answer_3;
@property (nonatomic, strong) NSString *answer_4;
@property (nonatomic, strong) NSString *questionID;
@property (nonatomic, assign) NSInteger type;  // 区分判断还是选择

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)questionWithDictionary:(NSDictionary *)dict;
+ (NSMutableDictionary *)dictionaryWith:(QuestionModel *)qusetion;
@end






#pragma mark   -----------------      选项Cell      --------------------------


@interface QusetionCell : UITableViewCell

@property (nonatomic, assign) BOOL select;


- (void)setTitle:(NSString *)title select:(BOOL)select;
@end
