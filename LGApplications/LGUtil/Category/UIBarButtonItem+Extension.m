
#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)
+(UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action Image:(NSString *)image HighImage:(NSString *)highImage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)tilte norImage:(NSString *)norImage higImage:(NSString *)higImage titleColor:(UIColor *)titleColor tagert:(id)target action:(SEL)action
{
    // 创建按钮
    UIButton *btn = [[UIButton alloc] init];
    // 设置按钮属性
    if (tilte != nil && ![tilte isEqualToString:@""]) {
        [btn setTitle:tilte forState:UIControlStateNormal];
    }
    
    if (norImage != nil && ![norImage isEqualToString:@""]) {
        [btn setImage:[UIImage imageNamed:norImage] forState:UIControlStateNormal];
    }
    
    if (higImage != nil && ![higImage isEqualToString:@""]) {
        [btn setImage:[UIImage imageNamed:higImage] forState:UIControlStateHighlighted];
    }
    
    if (titleColor != nil) {
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
    }
    [btn.titleLabel setFont:kFontWithSize(16)];
    [btn setTitleColor:kColorWithFloat(0x999999) forState:UIControlStateDisabled];
    // 设置size
    [btn sizeToFit];
    
    // 添加方法
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    // 返回自定义UIBarButtonItem
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (UIBarButtonItem *)initWithImage:(NSString *)imageName target:(id)target action:(SEL)action{
    return [self initWithImage:Image(imageName) style:UIBarButtonItemStylePlain target:target action:action];
}
- (UIBarButtonItem *)initWithTitle:(NSString *)title target:(id)target action:(SEL)action{
    UIBarButtonItem *item = [self initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    [item setTitleTextAttributes:@{NSFontAttributeName:kFontWithSize(12),NSForegroundColorAttributeName:kColorDark} forState:UIControlStateNormal];
    return item;

}
- (UIBarButtonItem *)initWithTitle:(NSString *)title image:(NSString *)imageName target:(id)target action:(SEL)action{
     return [self initWithTitle:title color:kColorDark image:imageName target:target action:action];
}

- (UIBarButtonItem *)initWithTitle:(NSString *)title color:(UIColor *)color image:(NSString *)imageName target:(id)target action:(SEL)action{
    UIButton *button = [[UIButton alloc] init];
    button.titleLabel.font = kFontWithSize(12);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setImage:Image(imageName) forState:UIControlStateNormal];
    [button layoutButtonWithEdgeInsetsStyle:LGButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    [button sizeToFit];
    return [self initWithCustomView:button];
}
@end
