


#import <Foundation/Foundation.h>
#import "WMHeader.h"
@class WMEmotionModel;
@interface WMEmojiManager : NSObject

#pragma mark - -----Properties-----

@property (strong, nonatomic) NSMutableArray *emojisAry;
@property (strong, nonatomic) NSMutableArray *usedEmojiAry;
@property (assign, nonatomic) NSInteger selectedRow;
@property (nonatomic, strong) NSMutableArray * emotionAllAr;
@property (nonatomic, copy)NSString *pngPath;
@property (nonatomic, strong)NSMutableArray * toolBarImageAr;
@property (nonatomic, strong)NSMutableDictionary * allCustomEmotionDic;
@property (nonatomic, strong)NSMutableArray * smallEmotionAr;
@property (nonatomic, assign)NSInteger smallPage;
@property (nonatomic, copy) NSArray * gifGroupSource;
#pragma mark - -----Methods------
/**
 *初始化一个HCEmojiManager单例对象
 */
+ (instancetype)sharedEmoji;

/**
 *将选择过的表情存在·UsedEmojiAry·数组中
 *@param   object   选择过的表情
 *@return  void
 */
- (void)addUsedEmojiAryObject:(NSString *)object;

/**
 *根据row来获取表情数据源
 *@return  表情数据源（NSArray）
 */
- (NSArray *)getEmojisDataSourceFromLocal;

#pragma mark - NSUserDefaults 存取数据
/**
 *将使用过的表情存入本地
 *@param   ary   选中的row
 *@return  void
 */
- (void)saveUsedEmojisToLocal:(NSMutableArray *)ary;

/**
 *从本地取出使用过的表情
 *@return  NSMutableArray
 */
- (NSMutableArray *)getLocalUsedEmojis;

- (void)clearUsedEmojis;
//文字转表情
- (NSAttributedString *)emoticonAttributeTextWithText:(NSString *)text emoticonWidth:(CGFloat)width;
//根据表情模型生成表情的attributedString
- (NSMutableAttributedString *)attributedStringWithEmoticon:(WMEmotionModel *)emotion width:(CGFloat)width;
//根据字符串获取对应表情
- (WMEmotionModel *)emoticonWithText:(NSString *)text;

//刷新attributedText的表情（例：手动输入[哈哈]，将其转化为对应的表情）
- (NSMutableAttributedString *)reloadAttributedText:(UITextView *)textView;

//表情转文字
- (NSString *)changeEmotionToString:(NSAttributedString *)attributedString;

@end
