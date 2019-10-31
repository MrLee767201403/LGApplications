//
//  IndexSectionView.m
//  Tutor
//
//  Created by 李刚 on 2018/11/19.
//  Copyright © 2018 Mr.Lee. All rights reserved.
//

#import "IndexSectionView.h"

#define kIndexViewWidth           25.0f

@interface IndexSectionView()

@property (nonatomic) NSUInteger currentSection;
@property (nonatomic, assign) NSUInteger numberOfSections;

@end

@implementation IndexSectionView

- (id)initWithTitles:(NSArray *)titles{


    if (self = [super init]) {

        self.frame = CGRectMake(kScreenWidth-kIndexViewWidth, kContentHeight*0.1, kIndexViewWidth, kContentHeight*0.8);
        _numberOfSections = titles.count;
        _titleArray = titles;
    }
    return self;
}

- (void)setSubViews{

    CGFloat labelH = kContentHeight*0.8/self.titleArray.count;
    for (NSUInteger i=0; i < self.titleArray.count; i++) {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, i*labelH, kIndexViewWidth, labelH)];
        label.text = self.titleArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = kColorDark;
        label.font = kFontWithName(kFontNamePingFangSCMedium, 12);
        [self addSubview:label];
    }
}

#pragma mark - UIResponder Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    CGFloat ratio = location.y / self.height;

    NSUInteger newSection = ratio*_numberOfSections;

    if (newSection != _currentSection) {
        _currentSection = newSection;
        [_delegate indexSectionView:self didSelecteedTitle:self.titleArray[_currentSection] atSectoin:_currentSection];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    CGFloat ratio = location.y / self.height;

    NSUInteger newSection = ratio*_numberOfSections;

    if (newSection != _currentSection) {
        _currentSection = newSection;

        if (newSection < _numberOfSections) {
            if (_delegate) {
                [_delegate indexSectionView:self didSelecteedTitle:self.titleArray[_currentSection] atSectoin:_currentSection];
            }
            else{
                // **Perhaps call the table view directly
            }
        }
    }
}


- (NSArray *)titleArray{
    if (_titleArray == nil) {
        _titleArray = @[@"★",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"H",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    }
    return _titleArray;
}
@end
