

#import "WMEmojiManager.h"
#import "WMEmotionModel.h"
#import "WMEmotionAttachment.h"
@interface WMEmojiManager ()
@property (nonatomic, assign)float zoomValue;
@end
@implementation WMEmojiManager
@synthesize gifGroupSource = _gifGroupSource;
#pragma mark - Init
+ (instancetype)sharedEmoji {
    static WMEmojiManager *emoji = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        emoji = [[WMEmojiManager alloc]init];
        emoji.zoomValue = 4.0;
    });
    return emoji;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self emojisAry];
        [self usedEmojiAry];
        [self emotionAllAr];
        [self reloadOtherReaource];
//        //加载大表情
//        self.gifGroupSource = [EmotionMarketManager manager].hadDownEmotionAr;
    }
    return self;
}
//加载gif大表情
- (void)reloadGif{
    [self.emotionAllAr removeAllObjects];
    [self.emotionAllAr addObjectsFromArray:self.smallEmotionAr];
    self.toolBarImageAr = [NSMutableArray arrayWithArray:[self.toolBarImageAr subarrayWithRange:NSMakeRange(0, 3)]];
//    for (WMEmotionMarketModel *emotionModel in self.gifGroupSource) {
//         NSString * path = [NSString stringWithFormat:@"%@/%@/%@/source/%@/emotion.json", [WMCache defaultCache].emotionPath, [WMUser user].userId, emotionModel.expressionId, emotionModel.pathName];
//        NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
//        if (!jsonData) {
//            continue;
//        }
//        NSMutableDictionary *dicInfo = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
//        NSArray * sourceAr = [dicInfo valueForKey:@"data"];
//        NSLog(@"sourceAr = %@", sourceAr);
//        NSMutableArray * array = [NSMutableArray arrayWithCapacity:1];
//        for (NSDictionary * dic in sourceAr) {
//            WMEmotionModel * model = [[WMEmotionModel alloc] initWithGifDic:dic];
//            model.gifPath = [NSString stringWithFormat:@"%@/%@/%@/source/%@/%@",[WMCache defaultCache].emotionPath, [WMUser user].userId, emotionModel.expressionId,emotionModel.pathName, model.gif];
//            [array addObject:model];
//        }
//        [self.emotionAllAr addObject:array];
//        [self.toolBarImageAr addObject:[NSString stringWithFormat:@"%@/%@/%@/source/%@/%@",[WMCache defaultCache].emotionPath, [WMUser user].userId, emotionModel.expressionId,emotionModel.pathName, @"cover.png"]];
//    }
}
- (void)reloadOtherReaource{
    //黑凤梨
    NSString * path = [[NSBundle mainBundle] pathForResource:@"small.json" ofType:nil];
    NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
   
    NSMutableDictionary *dicInfo = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSArray * sourceAr = [dicInfo valueForKey:@"data"];
   
    NSLog(@"sourceAr = %@", sourceAr);
    
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary * dic in sourceAr) {
        WMEmotionModel * model = [[WMEmotionModel alloc] initWithDic:dic];
        [array addObject:model];
        [self.allCustomEmotionDic setObject:model forKey:model.chName];
    }
    
    //手绘表情
    NSString * path1 = [[NSBundle mainBundle] pathForResource:@"draw.json" ofType:nil];
    NSData *jsonData1 = [NSData dataWithContentsOfFile:path1 options:NSDataReadingMappedIfSafe error:nil];
    
    NSMutableDictionary *dicInfo1 = [NSJSONSerialization JSONObjectWithData:jsonData1 options:NSJSONReadingMutableContainers error:nil];
    NSArray * sourceAr1 = [dicInfo1 valueForKey:@"data"];
    NSMutableArray * array1 = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary * dic in sourceAr1) {
        WMEmotionModel * model = [[WMEmotionModel alloc] initWithDic:dic];
        [array1 addObject:model];
        [self.allCustomEmotionDic setObject:model forKey:model.chName];
    }
   
    [self.emotionAllAr addObject:array];
    [self.smallEmotionAr addObject:array];
    [self.emotionAllAr addObject:array1];
    [self.smallEmotionAr addObject:array1];
    self.smallPage += ceil(array.count / kPageCount);
}
#pragma mark - Lazy load
- (NSMutableArray *)emotionAllAr{
    if (!_emotionAllAr) {
        self.emotionAllAr = [NSMutableArray array];
        [_emotionAllAr addObject:self.emojisAry];
//        [_emotionAllAr addObject:self.usedEmojiAry];
    }
    return _emotionAllAr;
}
- (NSMutableArray *)smallEmotionAr{
    if (!_smallEmotionAr) {
        self.smallEmotionAr = [NSMutableArray array];
        [_smallEmotionAr addObject:self.emojisAry];
    }
    return _smallEmotionAr;
}
- (NSMutableArray *)emojisAry {
    if (!_emojisAry) {
        NSDictionary *dic = [self getEmojisDic];
        _emojisAry = [NSMutableArray new];
        [_emojisAry addObjectsFromArray:dic[@"normal"]];
       self.smallPage += ceil(_emojisAry.count / kPageCount);
    }
    return _emojisAry;
}

- (NSMutableArray *)usedEmojiAry {
    if (!_usedEmojiAry) {
        _usedEmojiAry = [self getLocalUsedEmojis];
    }
    return _usedEmojiAry;
}

- (void)addUsedEmojiAryObject:(NSString *)object{
//    for (NSString *str in self.usedEmojiAry){
//        if ([str isEqualToString:object]) {
//            [_usedEmojiAry removeObject:object];
//            break;
//        }
//    }
//    [self.usedEmojiAry insertObject:object atIndex:0];
//    [self saveUsedEmojisToLocal:_usedEmojiAry];
}

- (NSArray *)getEmojisDataSourceFromLocal {
    NSInteger row = _selectedRow;
    NSArray *ary = [NSArray new];
    switch (row) {
        case 0:
            ary = self.emojisAry;
            break;
        case 1:
            ary = self.usedEmojiAry;
            break;
        default:
            break;
    }
    return ary;
}
#pragma mark - NSUserDefaults  本地数据存取 、清空
- (void)saveUsedEmojisToLocal:(NSMutableArray *)ary {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:ary forKey:@"UsedEmojis"];
    [defaults synchronize];
}

- (NSMutableArray *)getLocalUsedEmojis{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *ary = [defaults objectForKey:@"UsedEmojis"];
    [defaults synchronize];
    NSMutableArray *returnAry = [NSMutableArray new];
    //从本地取出来的数组是NSCFArray类型 不是 NSMutableArray
    if (ary != nil) {
        [returnAry addObjectsFromArray:ary];
    }
    return returnAry;
}

- (void)clearUsedEmojis {
    //清空表情数据
}


- (NSMutableDictionary *)allCustomEmotionDic{
    if (!_allCustomEmotionDic) {
        self.allCustomEmotionDic = [NSMutableDictionary dictionary];
    }
    return _allCustomEmotionDic;
}
#pragma mark - 解析json 数据
- (NSDictionary *)getEmojisDic{
    static NSDictionary *__emojisDic = nil;
    if (!__emojisDic){
        NSString *path = [[NSBundle mainBundle] pathForResource:emojiPath ofType:emojiType];
        NSData *emojiData = [[NSData alloc] initWithContentsOfFile:path];
        __emojisDic = [NSJSONSerialization JSONObjectWithData:emojiData options:NSJSONReadingAllowFragments error:nil];
    }
    return __emojisDic;
}

- (NSMutableArray *)toolBarImageAr{
    if (!_toolBarImageAr) {
        self.toolBarImageAr = [NSMutableArray arrayWithObjects:toolBarEmoji, toolBarLoving,toolBarDraw, nil];
    }
    return _toolBarImageAr;
}

//根据字符串获取对应表情
- (WMEmotionModel *)emoticonWithText:(NSString *)text{
    return [self.allCustomEmotionDic valueForKey:text];
}
//根据表情模型生成表情的attributedString
- (NSMutableAttributedString *)attributedStringWithEmoticon:(WMEmotionModel *)emotion width:(CGFloat)width{
    // 创建附件
    WMEmotionAttachment * attachment =  [WMEmotionAttachment new];
    // 设置附件的大小
    attachment.bounds = CGRectMake( 0, -4,  width + self.zoomValue, width + self.zoomValue);
    // 给附件添加图片
    attachment.image = [UIImage imageNamed:emotion.png];
    // 将表情名称赋值给attachment附件
    attachment.chName = emotion.chName;
    // 创建一个属性文本,属性文本有一个附件,附件里面有一张图片
    
    NSAttributedString * attrString = [NSMutableAttributedString attributedStringWithAttachment:attachment];
    return [attrString mutableCopy];
}

// 字符串中的表情字符串转化为表情
- (NSAttributedString *)emoticonAttributeTextWithText:(NSString *)text emoticonWidth:(CGFloat)width{
    //将文本转化为attributedText备用
    NSMutableAttributedString * tempAttributeText = [[NSMutableAttributedString alloc] initWithString:text];
    //定义一份可变字符串用来获取表情字符串的range
    NSMutableString * tempText = [[NSMutableString alloc] initWithString:text];
    //用"["分隔字符串
    NSArray * temp = [text componentsSeparatedByString:@"["];
    
    for (NSString * str in temp) {
        //若分隔后的字符串中还包含"]"，就有可能是自定义表情字符串
        if ([str containsString:@"]"]) {
            NSArray * subTemp = [str componentsSeparatedByString:@"]"];
            if (subTemp.count > 0) {
                NSString * emoStr = subTemp[0];
                //拼接上完整的表情字符串
                NSString * emoticonText = [NSString stringWithFormat:@"[%@]", emoStr];
                //获取range
                NSRange range = [tempText rangeOfString:emoticonText];
                //根据表情字符串查找表情模型
                WMEmotionModel * model =  [self emoticonWithText:emoticonText];
                if (model) {
                    //若找到表情模型，将可变字符串中的表情字符串替换为空字符串（以便下次获取range正确）
                    [tempText replaceCharactersInRange:range withString:@" "];
                    //而attributeText则将表情字符串替换为表情
                    [tempAttributeText replaceCharactersInRange:range withAttributedString:[self attributedStringWithEmoticon:model width:width]];
                    
                }
            }
        }
    }
    return tempAttributeText;
}


// 获取带表情图片的字符串
- (NSString *)changeEmotionToString:(NSAttributedString *)attributedString{
   __block NSString * temp = @"";
    // 遍历属性
    [attributedString enumerateAttributesInRange:NSMakeRange(0, attributedString.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        WMEmotionAttachment * attachment = attrs[@"NSAttachment"];
        if ([attachment isKindOfClass:[WMEmotionAttachment class]]) {
            temp = [attachment.chName stringByAppendingString:temp];;
        }
        else{
            //截取字符串
            NSString * str = [attributedString.string substringWithRange:range];
            // 拼接
            temp = [str stringByAppendingString:temp];
        }
    }];
       // 返回拼接好的字符串
    return temp;
}

//刷新attributedText的表情（例：手动输入[哈哈]，将其转化为对应的表情）【逻辑太复杂了，实在不知道微博是怎么实现的】【注释可能看不懂，因为我也不知道怎么去描述】
- (NSMutableAttributedString *)reloadAttributedText:(UITextView *)textView{

    NSAttributedString * attributedText = textView.attributedText;

    //刷新后光标应在从后面数的第几个位置上
    __block NSInteger backwardIndex = 0;
    //光标后面的子串
   NSAttributedString * backString = [attributedText attributedSubstringFromRange:NSMakeRange(textView.selectedRange.location + textView.selectedRange.length, attributedText.length - textView.selectedRange.location)];
    //光标前面的子串
    NSAttributedString * foreString = [attributedText attributedSubstringFromRange:NSMakeRange(0, textView.selectedRange.location)];
    if ([backString.string containsString:@"]"]) {
        NSRange foreRange = [foreString.string rangeOfString:@"[" options: NSBackwardsSearch];
        //若找不到[，则刷新后光标的位置可以确定为从后面数的位置上
        if (foreRange.location == NSNotFound) {
            backwardIndex = attributedText.length - (textView.selectedRange.location + textView.selectedRange.length);
        } else {
            NSRange backRange =[backString.string rangeOfString:@"]" options:NSCaseInsensitiveSearch];
            NSAttributedString * maybeEmoticonStr = [attributedText attributedSubstringFromRange: NSMakeRange(foreRange.location, textView.selectedRange.location + textView.selectedRange.length + backRange.location + 1 - foreRange.location)];
            
           __block BOOL isEmoticonStr = NO;
            [maybeEmoticonStr enumerateAttributesInRange:NSMakeRange( 0, maybeEmoticonStr.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
                WMEmotionAttachment * attachment = attrs[@"NSAttachment"];
                if ([attachment isKindOfClass:[WMEmotionAttachment class]]) {
                    isEmoticonStr = YES;
                }
                //若相等，则表示没有包含图片表情
                if (isEmoticonStr) {
                    //若包含图片表情，则刷新后光标的位置可以确定为从后面数的位置上
                    backwardIndex = attributedText.length - (textView.selectedRange.location + textView.selectedRange.length);
                }
                else{
                    if ([[WMEmojiManager sharedEmoji] emoticonWithText:maybeEmoticonStr.string]) {
                        //若此字符串是能转化为表情，则刷新后光标位置应该为"]"后面
                        backwardIndex = attributedText.length - (textView.selectedRange.location + textView.selectedRange.length + backRange.location + 1);
                    } else {
                        //若不能转化为表情，则刷新后光标的位置可以确定为从后面数的位置上
                        backwardIndex = attributedText.length - (textView.selectedRange.location + textView.selectedRange.length);
                    }
 
                }
            }];
         }
    } else {
        //光标后面的字符串不会改变，则刷新后光标的位置可以确定为从后面数的位置上
        backwardIndex = attributedText.length - (textView.selectedRange.location + textView.selectedRange.length);
    }
    //将图片表情替换成对应的字符串
    __block NSString * tempStr = @"";
    [attributedText enumerateAttributesInRange:NSMakeRange(0,attributedText.length) options: NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        WMEmotionAttachment * attachment = attrs[@"NSAttachment"];
        if ([attachment isKindOfClass:[WMEmotionAttachment class]]) {
            //若是图片表情，则拼接图片表情对应的字符串
            tempStr = [attachment.chName stringByAppendingString:tempStr];
        }
        else
        {
            //若是普通字符串，则直接拼接
            NSString * str = [textView.attributedText.string substringWithRange:range];
            // 拼接
            tempStr = [str stringByAppendingString:tempStr];
        }
    }];
    //在讲普通字符串转化成包含图片表情的attributedText
    NSAttributedString * temp = [[WMEmojiManager sharedEmoji] emoticonAttributeTextWithText:tempStr emoticonWidth: textView.font.lineHeight];
    if  (temp) {
        NSMutableAttributedString * attrString = [temp mutableCopy];
        // 给附件添加Font属性
        [attrString addAttribute:NSFontAttributeName value:textView.font range:NSMakeRange(0, temp.length)];
        textView.attributedText = attrString;
        textView.selectedRange = NSMakeRange(attributedText.length - backwardIndex, 0);
    }
    return [textView.attributedText mutableCopy];
}

- (void)setGifGroupSource:(NSArray *)gifGroupSource{
    _gifGroupSource  = gifGroupSource;
    [self reloadGif];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gifEmotionGroupChange" object:nil];
}





@end
