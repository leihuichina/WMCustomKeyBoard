

#import <UIKit/UIKit.h>


typedef void(^SendBlock)(void);
typedef void(^SelectedBlock)(NSInteger row);
typedef void(^AddBlock)(void);

@interface EmojiToolBar : UIView

#pragma mark - -----Properties-----
@property (strong, nonatomic) UIButton *sendBtn;
@property (copy, nonatomic) SendBlock sendBlock;
@property (copy, nonatomic) SelectedBlock selectedBlock;
@property (copy, nonatomic) AddBlock addBlock;
@property (assign, nonatomic) BOOL showAddBtn;
@property (strong, nonatomic) UICollectionView *toolBarCollection;
@property (strong, nonatomic) NSMutableArray *toolBarAry;


#pragma mark - -----Methods-----
/**
 *初始化一个EmojiToolBar对象
 *@param   初始化的对象   宽高一定，不可修改
 */
+ (EmojiToolBar *)sharedToolBar;

- (void)sendEmojis:(SendBlock)block;

- (void)selectedToolBar:(SelectedBlock)block;

- (void)addBtnClicked:(AddBlock)block;
- (void)changeSelectAndReload:(NSInteger)index;
@end
