

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action Image:(NSString *)image HighImage:(NSString *)highImage;
+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)tilte norImage:(NSString *)norImage higImage:(NSString *)higImage titleColor:(UIColor *)titleColor tagert:(id)target action:(SEL)action;

- (UIBarButtonItem *)initWithImage:(NSString *)imageName target:(id)target action:(SEL)action;
- (UIBarButtonItem *)initWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (UIBarButtonItem *)initWithTitle:(NSString *)title image:(NSString *)imageName target:(id)target action:(SEL)action;
- (UIBarButtonItem *)initWithTitle:(NSString *)title color:(UIColor *)color image:(NSString *)imageName target:(id)target action:(SEL)action;
@end
