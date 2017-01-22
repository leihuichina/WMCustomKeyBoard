


#import "WMEmojiKeyboard.h"
#import "UIView+Frame.h"
#import "UIColor+MyColor.h"
#import "WMEmojiManager.h"
#import "EmojiToolBar.h"
#import "EmojiCollectionView.h"
#import "WMHeader.h"
#import "WMEmotionModel.h"
#import "WMEmotionAttachment.h"
@interface WMEmojiKeyboard ()
@property (strong, nonatomic) EmojiToolBar *emojiToolBar;
@property (strong, nonatomic) EmojiCollectionView *emojiView;

@end

@implementation WMEmojiKeyboard

#pragma mark - 初始化
+ (WMEmojiKeyboard *)sharedKeyboard {
//    static HCEmojiKeyboard *_sharedKeyboard = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _sharedKeyboard = [HCEmojiKeyboard new];
//    });
//    return _sharedKeyboard;
    //多处使用可能都要修改所以暂不使用单例初始化
    return [self new];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _showAddBtn = YES;
        self.frame = CGRectMake(0, 0, ScreenWidth, (kCollectionHeight+kPageControlHeight));
    }
    return self;
}
- (void)dealloc{
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"emotionSelected" object:nil];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"emotionDelete" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"gifEmotionGroupChange" object:nil];
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self addSubview:self.emojiView];
    [self addSubview:self.emojiToolBar];
    if (!self.showGif) {
        self.emojiView.dataSource = [WMEmojiManager sharedEmoji].smallEmotionAr;
        self.emojiToolBar.toolBarAry = [[WMEmojiManager sharedEmoji].toolBarImageAr subarrayWithRange:NSMakeRange(0, smallEmtionCount)];
    }
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertEmoji:) name:@"emotionSelected" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteEmojis) name:@"emotionDelete" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadKeyboard) name:@"gifEmotionGroupChange" object:nil];

}

#pragma mark - lazy load

- (EmojiCollectionView *)emojiView {
    WS(wSelf);
    if (!_emojiView) {
        _emojiView = [EmojiCollectionView sharedCollection];
        _emojiView.center = CGPointMake(ScreenWidth/2, CGRectGetHeight(_emojiView.frame)/2);
        _emojiView.selectedBlock = ^(NSInteger index){
            [wSelf chanToolBarSelect:index];
        };
        _emojiView.emotionAction = ^(id info, BOOL isDelete){
            if (isDelete) {
                [wSelf deleteEmojis];
            }
            else{
                [wSelf insertEmoji:info];
            }
        };
    }
    return _emojiView;
}


- (void)chanToolBarSelect:(NSInteger)index{
    [_emojiToolBar changeSelectAndReload:index];
}
- (void)changeEmotionView:(NSInteger )index{
    [_emojiView reloadSection:index];
}
- (EmojiToolBar *)emojiToolBar {
    WS(wSelf);
    if (!_emojiToolBar) {
        self.emojiToolBar = [EmojiToolBar sharedToolBar];
        [_emojiToolBar changeSelectAndReload:0];
        _emojiToolBar.center = CGPointMake(ScreenWidth/2, CGRectGetHeight(self.emojiView.frame)+CGRectGetHeight(_emojiToolBar.frame)/2);
        _emojiToolBar.showAddBtn = _showAddBtn;
        [_emojiToolBar addBtnClicked:^{
            wSelf.addBlock();
        }];
        [_emojiToolBar sendEmojis:^{
             wSelf.block();
            while ([wSelf.textInput hasText]) {
                [wSelf.textInput deleteBackward];
            }
        }];
        //切换工具栏的表情
        [_emojiToolBar selectedToolBar:^(NSInteger row) {
            [wSelf changeEmotionView:row];
        }];
        
        if (self.showClasses) {
            _emojiToolBar.toolBarCollection.hidden = NO;
        }
        else{
            _emojiToolBar.toolBarCollection.hidden = YES;
        }
        _emojiToolBar.sendBtn.hidden = !_showSend;
    }
    return _emojiToolBar;
}


#pragma mark - setter

- (void)setTextInput:(id<UITextInput>)textInput {
    if ([textInput isKindOfClass:[UITextView class]]) {
        self.font = [(UITextView *)textInput font];
        [(UITextView *)textInput setInputView:self];
    }else if ([textInput isKindOfClass:[UITextField class]]){
        [(UITextField *)textInput setInputView:self];
        self.font = [(UITextField *)textInput font];

    }
    _textInput = textInput;
}

//zuo yong ???
//- (void)changeKeyboard{
//    [(UIControl *)_textInput resignFirstResponder];
//    [(UITextView *)_textInput setInputView:nil];
//    [(UIControl *)_textInput becomeFirstResponder];
//}

#pragma mark - 收到表情处发来的通知之后的响应
//将输入框中最后一个表情删除
- (void)deleteEmojis{
    [_textInput deleteBackward];
    [[UIDevice currentDevice] playInputClick];
    [self textChanged];
    //输入框没有文字之后，改变EmojiToolBar中sendBtn的状态
    if (![_textInput hasText]) {
//        _emojiToolBar.sendBtn.enabled = NO;
//        [_emojiToolBar.sendBtn setTitleColor:[UIColor sendTitleNormalColor] forState:UIControlStateNormal];
//        _emojiToolBar.sendBtn.backgroundColor = [UIColor sendBgNormalColor];
    }
}

//将选中的表情插入到输入框中
- (void)insertEmoji:(id )info{
    if ([info isKindOfClass:[NSString class]]) {
    [[UIDevice currentDevice] playInputClick];
    [_textInput insertText:info];
        
    }
    else{
        [self insertEmoticon:info];
        
//        // 创建一个属性文本,属性文本有一个附件,附件里面有一张图片
//        NSMutableAttributedString * attrString = CSEmoticonManager.attributedStringWithEmoticon(emoticon, width: font!.lineHeight)
//        // 给附件添加Font属性
//        attrString.addAttribute(NSFontAttributeName, value: font!, range: NSRange(location: 0, length: 1))
//        // 拿出textView内容
//        let temp = NSMutableAttributedString(attributedString: attributedText)
//        
//        // 获取textView选中的范围，把图片添加到已有内容里面
//        let sRange = self.selectedRange
//        temp.replaceCharactersInRange(sRange, withAttributedString: attrString)
//        
//        // 在重新赋值回去
//        attributedText = temp
//        
//        // 重新设置选中范围,让光标在插入表情后面
//        self.selectedRange = NSRange(location: sRange.location + 1, length: 0)
//        
//        //让光标位置可见
//        self.scrollRangeToVisible(self.selectedRange)
//        
//        // 手动触发textView文本改变
//        // 发送通知,文字改变
//        NSNotificationCenter.defaultCenter().postNotificationName(UITextViewTextDidChangeNotification, object: self)
//        
//        // 调用代理,文字改变
//        delegate?.textViewDidChange?(self)

    }
    [self textChanged];
    //改变EmojiToolBar中sendBtn的状态
//    [_emojiToolBar.sendBtn setTitleColor:[UIColor sendTitleHighlightedColor] forState:UIControlStateNormal];
//    _emojiToolBar.sendBtn.backgroundColor = [UIColor sendBgHighlightedColor];
}

#pragma mark -  通知、块-- 传递信息
//在这里发送通知，在对应页面的输入框的代码方法 textDidChange 中 执行其他操作
- (void)textChanged{
    if ([_textInput isKindOfClass:[UITextView class]])
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:_textInput];
    else if ([_textInput isKindOfClass:[UITextField class]])
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:_textInput];
    if (self.textInput.text.length > 0) {
        _emojiToolBar.sendBtn.enabled = YES;
    }
    else{
        _emojiToolBar.sendBtn.enabled = NO;
  
    }
}

- (void)sendEmojis:(SendBlock)block {
    self.block = block;
}

- (void)addBtnClicked:(AddBlock)block {
    
    self.addBlock = block;
}

#pragma mark - UIInputViewAudioFeedback
//1、给定制的键盘添加系统键盘按键声音  2、在键盘点击处实现[[UIDevice currentDevice] playInputClick];
- (BOOL)enableInputClicksWhenVisible{
    return YES;
}

-(void)setShowToolBar:(BOOL)showToolBar
{   _showToolBar = showToolBar;
    if (_showToolBar) {
        self.frame =  CGRectMake(self.frame.origin.x, self.frame.origin.y, self.width, (kCollectionHeight+kPageControlHeight+ kToolBarHeight));
        _emojiToolBar.hidden = NO;
    }
    else{
        self.frame =  CGRectMake(self.frame.origin.x, self.frame.origin.y, self.width, (kCollectionHeight+kPageControlHeight));
        _emojiToolBar.hidden = YES;
    }
}
- (void)setShowClasses:(BOOL)showClasses{
    
    _showClasses = showClasses;

    if (self.showClasses) {
        _emojiToolBar.toolBarCollection.hidden = NO;
    }
    else{
        _emojiToolBar.toolBarCollection.hidden = YES;
    }
}

- (void)insertEmoticon:(WMEmotionModel *)emotion{

    if (emotion.emotionType != WMEmotionType_custom) {
        if (self.gifBlock) {
            self.gifBlock(emotion);
        }
        return;
    }
        //图片表情
        // 创建一个属性文本,属性文本有一个附件,附件里面有一张图片
    NSMutableAttributedString * attrString = [[WMEmojiManager sharedEmoji] attributedStringWithEmoticon:emotion width:self.font.lineHeight];
        // 给附件添加Font属性
    [attrString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, 1)];
        // 拿出textView内容
    NSMutableAttributedString * temp = [[NSMutableAttributedString alloc] initWithAttributedString:[(UITextView *)self.textInput attributedText]];
        // 获取textView选中的范围，把图片添加到已有内容里面
    NSRange  sRange = self.textInput.selectedRange;
    [temp replaceCharactersInRange:sRange withAttributedString:attrString];
        // 在重新赋值回去
    self.textInput.attributedText = temp;
        // 重新设置选中范围,让光标在插入表情后面
    self.textInput.selectedRange = NSMakeRange(sRange.location + 1, 0);
        //让光标位置可见
    [self.textInput scrollRangeToVisible:self.textInput.selectedRange];
        // 手动触发textView文本改变
        // 发送通知,文字改变
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self.textInput];
    if (self.textInput.delegate && [self.textInput.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.textInput.delegate textViewDidChange:self.textInput];
    }
    
}

- (void)setShowGif:(BOOL)showGif{
    _showGif = showGif;
   
}

- (void)reloadKeyboard{
    if(!self.showGif)
        return;
    _emojiView.dataSource = [WMEmojiManager sharedEmoji].emotionAllAr;
    _emojiToolBar.toolBarAry = [WMEmojiManager sharedEmoji].toolBarImageAr;
}
-(void)setShowSend:(BOOL)showSend{
    _showSend = showSend;
    _emojiToolBar.sendBtn.hidden = !showSend;
}
@end
