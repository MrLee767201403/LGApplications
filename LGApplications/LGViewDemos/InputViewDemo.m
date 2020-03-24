//
//  InputViewDemo.m
//  LGApplications
//
//  Created by 李刚 on 2020/3/24.
//  Copyright © 2020 李刚. All rights reserved.
//

#import "InputViewDemo.h"
#import "LGInputView.h"

@interface InputViewDemo ()<LGInputViewDelegate>
@property (nonatomic, strong) LGInputView *chatInputView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation InputViewDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.chatInputView = [[LGInputView alloc] init];
    self.chatInputView.delegate = self;

    self.label = [self labelWithTitle:nil top:100];

    [self.view addSubview:self.chatInputView];
    [self.view addSubview:self.label];

}

- (void)inputView:(LGInputView *)inputView didSendMessage:(NSString *)message{
    if (message.trimming.length == 0) {
        return;
    }

    self.label.text = message;
}

- (UILabel *)labelWithTitle:(NSString *)title top:(CGFloat)top
{
    CGFloat H = [title boundingRectWithSize:CGSizeMake(kScreenWidth-70, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFontWithSize(14)} context:nil].size.height;
    UILabel *label = [[UILabel alloc] init];
    label.font = kFontWithSize(14);
    label.text = title;
    label.textColor = kColorDark;
    label.frame = CGRectMake(35, top, kScreenWidth-70, H);
    return label;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
