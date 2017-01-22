

#import <UIKit/UIKit.h>
#import "EmojiToolBar.h"

@class WMEmotionModel;
typedef void(^SendBlock)(void);
typedef void(^AddBlock)(void);
typedef void(^GifSendBlock)(WMEmotionModel * model);

@interface WMEmojiKeyboard : UIView<UIInputViewAudioFeedback>

#pragma mark - -----Properties-----

@property (strong, nonatomic) UITextView * textInput;
@property (copy, nonatomic) SendBlock block;
@property (copy, nonatomic) AddBlock addBlock;
@property (nonatomic, strong)UIFont * font;
@property (nonatomic, copy) GifSendBlock gifBlock;
/**
 * 是否需要显示添加按钮
 * @param  param    如果需要显示，那么附带的点击回传方法必须实现
 * @param  param   Default is YES
 */
@property (assign, nonatomic) BOOL showAddBtn;
@property (assign, nonatomic) BOOL showToolBar;
@property (assign, nonatomic) BOOL showClasses;//显示分类
@property (nonatomic, assign) BOOL showGif;
@property (nonatomic, assign) BOOL showSend;
#pragma mark - -----Methods-----

/**
 *初始化一个 HCEmojiKeyboard 对象
 *@param   初始化的对象    宽高一定，不可修改
 */
+ (WMEmojiKeyboard *)sharedKeyboard;

/**
 *点击了发送
 */

- (void)textChanged;
- (void)sendEmojis:(SendBlock)block;

- (void)addBtnClicked:(AddBlock)block;

@end
