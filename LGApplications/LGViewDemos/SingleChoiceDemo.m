//
//  SingleChoiceDemo.m
//  LGApplications
//
//  Created by 李刚 on 2017/6/8.
//  Copyright © 2017年 李刚. All rights reserved.
//



#pragma mark   -  几点解释
// 只提供一个思路,所以MVC都弄到一起了
// 每道题是一个分区,问题是分区头部,选项是分区里的Cell
// 界面都好实现,主要是每个分区的单项选择,思路如下:
/*
 
 1.无论选哪个cell,点击的那个肯定变为选中
 
 2.用数组记录答过的题的索引(分区)   AND  用字典记录答的那道题(section)的答案(indexPath)
 
 3.用section 作为key (核心) indexPath为值 记录答过的题和答案
 
 4.对于答过的题,需要取消原来选中
 
   // 包含则表示答过
   if ([self.selectedSections containsObject:@(indexPath.section)])
 
   // 拿到原来的选项
   NSIndexPath *selectIndexPath = [self.selectedIndexPaths objectForKey:key];
   // 移除原来的选项
   [self.selectedIndexPaths removeObjectForKey:key];
   // 添加新的选项
   [self.selectedIndexPaths setObject:indexPath forKey:key];
 
 5.对于没答过的题直接记录
 
  // 记录该题已经答过
  [self.selectedSections addObject:@(indexPath.section)];
  // 添加新的选项并记录
  [self.selectedIndexPaths setValue:indexPath forKey:key];
 
 
 6.tableViewCell复用的时候,也是根据selectedIndexPaths判断的
 
 */







#import "SingleChoiceDemo.h"

@interface SingleChoiceDemo ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *questions;

@property (nonatomic, strong) NSMutableDictionary *selectedIndexPaths;      // 选中答案的索引
@property (nonatomic, strong) NSMutableArray *selectedSections;             // 已经答过的索引
@property (nonatomic, strong) NSString *answers;                            // 答案

@end

@implementation SingleChoiceDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.title = @"考评测试";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = kColorBackground;
    
    [self setTableHeaderAndFooter];
    [self.view addSubview:self.tableView];
    
    
    self.questions = [NSMutableArray array];
    self.selectedSections = [NSMutableArray array];
    self.selectedIndexPaths = [NSMutableDictionary dictionary];
    [self loadData];
    
}


- (void)setTableHeaderAndFooter{
    // 头部
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    headerView.backgroundColor = kColorBackground;
    
    UILabel *titleLabel= [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth-15, 40)];
    titleLabel.font = kFontLagre;
    titleLabel.text = @"根据问题选择正确的答案";
    titleLabel.textColor = kColorWithFloat(0x131117);
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39, kScreenWidth, 1)];
    line.backgroundColor = kColorSeparator;
    
    [headerView addSubview:titleLabel];
    [headerView addSubview:line];
    
    // 底部
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    
    UIButton *commitButton = [[UIButton alloc] initWithFrame:CGRectMake(35, 35/2.0, kScreenWidth-70, 45)];
    commitButton.layer.cornerRadius = 5.0;
    commitButton.layer.masksToBounds = YES;
    commitButton.titleLabel.font = kFontLagreMost;
    [commitButton setTitle:@"提 交" forState:UIControlStateNormal];
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitButton setBackgroundColor:kColorMainTheme forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(commitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:commitButton];
    
    
    self.tableView.tableHeaderView = headerView;
    self.tableView.tableFooterView = footerView;
}


/**  加载数据*/
- (void)loadData{
    

    NSArray *array = @[
                       @{
                           @"answer_2":@"答案二",
                           @"answer_1":@"答案一",
                           @"answer_4":@"答案四",
                           @"id":@1,
                           @"detail":@"人工智能开发如何推动第二次工业发展第1题",
                           @"answer_3":@"答案三",
                           @"type":@1
                           },
                       @{
                           @"answer_2":@"答案二",
                           @"answer_1":@"答案一",
                           @"answer_4":@"答案四",
                           @"id":@2,
                           @"detail":@"人工智能开发如何推动第二次工业发展第2题",
                           @"answer_3":@"答案三",
                           @"type":@1
                           },
                       @{
                           @"answer_2":@"答案二",
                           @"answer_1":@"答案一",
                           @"answer_4":@"答案四",
                           @"id":@3,
                           @"detail":@"人工智能开发如何推动第二次工业发展第3题",
                           @"answer_3":@"答案三",
                           @"type":@1
                           },
                       @{
                           @"answer_2":@"答案二",
                           @"answer_1":@"答案一",
                           @"answer_4":@"答案四",
                           @"id":@4,
                           @"detail":@"人工智能开发如何推动第二次工业发展第4题",
                           @"answer_3":@"答案三",
                           @"type":@1
                           },
                       @{
                           @"answer_2":@"答案二",
                           @"answer_1":@"答案一",
                           @"answer_4":@"答案四",
                           @"id":@5,
                           @"detail":@"人工智能开发如何推动第二次工业发展第5题",
                           @"answer_3":@"答案三",
                           @"type":@1
                           },
                       @{
                           @"answer_2":@"答案二",
                           @"answer_1":@"答案一",
                           @"answer_4":@"答案四",
                           @"id":@6,
                           @"detail":@"人工智能开发如何推动第二次工业发展第6题",
                           @"answer_3":@"答案三",
                           @"type":@1
                           },
                       @{
                           @"answer_2":@"答案二",
                           @"answer_1":@"答案一",
                           @"id":@7,
                           @"detail":@"人工智能开发如何推动第二次工业发展第6题",
                           @"type":@2
                           },
                       
                       ];
    
    for (int i = 0; i<array.count; i++) {
        NSDictionary *dic = array[i];
        QuestionModel *qusetion = [QuestionModel questionWithDictionary:dic];
        [self.questions addObject:qusetion];
    }
    
    

    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.questions.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    QuestionModel *question = self.questions[section];
    
    // 判断
    if (question.type == 2) {
        return 2;
    }
    // 选择
    else{
        return 4;
    }
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QuestionModel *question = self.questions[indexPath.section];
    
    NSString *string = @"";
    
    if (indexPath.row == 0) {
        string = question.answer_1;
    }
    else if (indexPath.row == 1) {
        string = question.answer_2;
    }
    else if (indexPath.row == 2) {
        string = question.answer_3;
    }
    else if (indexPath.row == 3) {
        string = question.answer_4;
    }
    
    CGFloat height = [string boundingRectWithSize:CGSizeMake(kScreenWidth-60, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFontMiddle} context:nil].size.height;
    
    return height + 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QusetionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionCell"];
    QuestionModel *qustion = self.questions[indexPath.section];
    
    
    if (cell == nil) {
        cell = [[QusetionCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"QuestionCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSString *answer = @"";
    
    switch (indexPath.row) {
        case 0:
            answer = qustion.answer_1;
            break;
        case 1:
            answer = qustion.answer_2;
            break;
        case 2:
            answer = qustion.answer_3;
            break;
        case 3:
            answer = qustion.answer_4;
            break;
        default:
            break;
    }
    
    
    if (qustion.type == 2) {
        answer = indexPath.row == 0 ? @"对":@"错";
    }
    
    NSString *key = [NSString stringWithFormat:@"题号:%ld",indexPath.section];
    // 拿到选中的选项
    NSIndexPath *selectIndexPath = [self.selectedIndexPaths objectForKey:key];
    
    // 判断是不是选择了该选项
    BOOL select = selectIndexPath != nil && selectIndexPath == indexPath;
    
    [cell setTitle:answer select:select];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 设置选中
    QusetionCell *cell =  [tableView cellForRowAtIndexPath:indexPath];
    cell.select = YES;
    
    NSString *key = [NSString stringWithFormat:@"题号:%ld",indexPath.section];
    
    // 先判断这道题答过没有
    
    // 答过
    if ([self.selectedSections containsObject:@(indexPath.section)]) {
        
        // 拿到原来的选项
        NSIndexPath *selectIndexPath = [self.selectedIndexPaths objectForKey:key];
        
        // 是否修改选项
        if (indexPath != selectIndexPath) {
            
            // 移除原来的选项
            [self.selectedIndexPaths removeObjectForKey:key];
            
            // 取消其选中
            QusetionCell *selectCell =  [tableView cellForRowAtIndexPath:selectIndexPath];
            selectCell.select = NO;
            
            // 添加新的选项
            [self.selectedIndexPaths setObject:indexPath forKey:key];
        }
    }
    // 没答过
    else{
        
        // 记录该题已经答过
        [self.selectedSections addObject:@(indexPath.section)];
        // 添加新的选项并记录
        [self.selectedIndexPaths setValue:indexPath forKey:key];
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    QuestionModel *question = self.questions[section];
    NSString *detail = [NSString stringWithFormat:@"Q%ld: %@",section+1,question.detail];
    CGFloat height = [detail boundingRectWithSize:CGSizeMake(kScreenWidth-30, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFontMiddle} context:nil].size.height;
    return height+15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    QuestionModel *question = self.questions[section];
    NSString *detail = [NSString stringWithFormat:@"Q%ld: %@",section+1,question.detail];
    
    CGFloat height = [detail boundingRectWithSize:CGSizeMake(kScreenWidth-30, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFontMiddle} context:nil].size.height;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height+15)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, kScreenWidth-30, headerView.height-5)];
    detailLabel.font = kFontMiddle;
    detailLabel.text = detail;
    detailLabel.textColor = kColorMainTheme;
    
    [headerView addSubview:detailLabel];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


- (void)commitButtonClick:(UIButton *)button{
    
    
    // 题没答完
    if (self.selectedSections.count < self.questions.count) {
        
        NSString *message = [NSString stringWithFormat:@"还有%ld道题没有作答",self.questions.count - self.selectedSections.count];
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertVC addAction:cancel];
        [self presentViewController:alertVC animated:YES completion:nil];
      
    }
    // 提交
    else{
        
        NSString *questionIDs = @"";
        NSString *answers = @"";
        
        
        for (NSIndexPath *indexPath in self.selectedIndexPaths.allValues) {
            
            if (indexPath)
            {
                QuestionModel *question = self.questions[indexPath.section];
                questionIDs = [questionIDs stringByAppendingString:[NSString stringWithFormat:@"%@,",question.questionID]];
                
                // 选择题
                if (question.type == 1) {
                    answers = [answers stringByAppendingString:[NSString stringWithFormat:@"%ld,",indexPath.row+1]];
                }
                // 判断题 0 对 1 错
                else{
                    answers = [answers stringByAppendingString:[NSString stringWithFormat:@"%ld,",indexPath.row]];
                }
            }
        }
        
        if ([questionIDs hasSuffix:@","]) {
            questionIDs = [questionIDs substringToIndex:questionIDs.length-1];
        }
        
        if ([answers hasSuffix:@","]) {
            answers = [answers substringToIndex:answers.length-1];
        }
        
        NSString * str = [NSString stringWithFormat:@"问题:%@\n答案:%@",questionIDs,answers];
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertVC addAction:cancel];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}


@end










#pragma mark   -----------------      问题模型      --------------------------

@implementation QuestionModel
{
    NSDictionary *_dict;
}


+(instancetype)questionWithDictionary:(NSDictionary *)dict{
    return [[self alloc] initWithDictionary:dict];
}


+ (NSMutableDictionary *)dictionaryWith:(QuestionModel *)qusetion{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:qusetion.detail forKey:@"detail"];
    [dic setValue:qusetion.answer_1 forKey:@"answer_1"];
    [dic setValue:qusetion.answer_2 forKey:@"answer_2"];
    [dic setValue:qusetion.answer_3 forKey:@"answer_3"];
    [dic setValue:qusetion.answer_4 forKey:@"answer_4"];
    [dic setValue:qusetion.questionID forKey:@"id"];
    [dic setValue:@(qusetion.type) forKey:@"type"];
    return dic;
    
}

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    
    self = [super init];
    if (self) {
        
        _dict = dict;
        
        self.detail = [self stringForKey:@"detail"];
        self.answer_1 = [self stringForKey:@"answer_1"];
        self.answer_2 = [self stringForKey:@"answer_2"];
        self.answer_3 = [self stringForKey:@"answer_3"];
        self.answer_4 = [self stringForKey:@"answer_4"];
        self.questionID = [self stringForKey:@"id"];
        self.type = [[dict objectForKey:@"type"] integerValue];
    }
    return self;
}


- (NSString*)stringForKey:(NSString*)key
{
    id retObj = [NSString string];
    
    if ([_dict isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary*)_dict;
        retObj = [dict objectForKey:key];
        
        if ([retObj isKindOfClass:[NSNumber class]]) {
            retObj = [retObj stringValue];
        }
        
        if (![retObj isKindOfClass:[NSString class]]) {
            retObj = [NSString string];
        }
    }
    
    return retObj;
}
@end









#pragma mark   -----------------     选项Cell      --------------------------


@interface QusetionCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *selectButton;

@end

@implementation QusetionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _select = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUpSubViews];
    }
    
    return self;
}


- (void)setUpSubViews{
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, kScreenWidth-40, 0)];
    _titleLabel.font = kFontMiddle;
    _titleLabel.textColor = kColorWithFloat(0x131117);
    _titleLabel.numberOfLines = 0;
    
    _selectButton = [[UIButton alloc] initWithFrame:CGRectMake(15,5, 15, 15)];
    _selectButton.userInteractionEnabled = NO;
    [_selectButton setImage:[UIImage imageNamed:@"btn_unselect"] forState:UIControlStateNormal];
    [_selectButton setImage:[UIImage imageNamed:@"btn_select"] forState:UIControlStateSelected];
    
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_selectButton];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(40);
        make.top.equalTo(self.contentView).offset(5);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
    
    [_selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(5);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
}


- (void)setTitle:(NSString *)title select:(BOOL)select{
    _select = select;
    _selectButton.selected = select;
    _titleLabel.text = title;
}


- (void)setSelect:(BOOL)select{
    _select = select;
    _selectButton.selected = select;
}
@end
