

#import <UIKit/UIKit.h>

#pragma mark - inputView
@interface UIColor (MyColor)

+ (UIColor *)backgroundColor;

+ (UIColor *)borderColor;

+ (UIColor *)bigBorderColor;


#pragma mark - SendBtn Color

+ (UIColor *)sendBgNormalColor;

+ (UIColor *)sendBgHighlightedColor;

+ (UIColor *)sendTitleNormalColor;

+ (UIColor *)sendTitleHighlightedColor;

#pragma mark - pageController color

+ (UIColor *)pageIndicatorTintColor;

+ (UIColor *)currentPageIndicatorTintColor;

#pragma mark - EmojiCell

+ (UIColor *)emojiBgColor;

#pragma mark - EmojiToolBar

+ (UIColor *)lineColor;

@end
