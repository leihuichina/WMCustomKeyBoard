

#import "EmojiToolBar.h"
#import "UIView+Frame.h"
#import "UIColor+MyColor.h"
#import "WMEmojiManager.h"
#import "WMHeader.h"
#import "Masonry.h"
@interface ToolBarCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView * img;
@end
@implementation ToolBarCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    UIView *bgView = [[UIView alloc]initWithFrame:self.bounds];
    bgView.backgroundColor = [UIColor emojiBgColor];
    self.selectedBackgroundView = bgView;
    if (self) {
        [self addSubview:self.img];
        [_img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@32);
            make.center.equalTo(self);
        }];
    }
    return self;
}


- (UIImageView *)img{
    if (!_img) {
        self.img = [UIImageView new];
        _img.contentMode = UIViewContentModeScaleAspectFit;
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(_img.frame)-0.5, CGRectGetHeight(_img.frame)/4, 0.5, CGRectGetHeight(_img.frame)/2)];
                line.backgroundColor = [UIColor lineColor];
                [_img addSubview:line];
    }
    return _img;
}
//- (UIButton *)btn {
//    if (!_btn) {
//        _btn = [[UIButton alloc]initWithFrame:self.bounds];
//        [_btn setImageEdgeInsets:UIEdgeInsetsMake(8, 14, 8, 14)];
//        _btn.userInteractionEnabled = NO;
//        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(_btn.frame)-0.5, CGRectGetHeight(_btn.frame)/4, 0.5, CGRectGetHeight(_btn.frame)/2)];
//        line.backgroundColor = [UIColor lineColor];
//        [_btn addSubview:line];
//    }
//    return _btn;
//}

@end


@interface EmojiToolBar ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSInteger seletedRow;
    NSInteger addCount;
}
@property (strong, nonatomic) UIButton *addBtn;

@end
@implementation EmojiToolBar

@synthesize toolBarAry = _toolBarAry;
- (void)changeSelectAndReload:(NSInteger)index{
    seletedRow = index;
    [_toolBarCollection reloadData];
}
- (instancetype)init {
    self = [super init];
    addCount = 0;
//    seletedRow = [HCEmojiManager sharedEmoji].selectedRow;
    self.frame = CGRectMake(0, 0, ScreenWidth, kToolBarHeight);
    self.backgroundColor = [UIColor whiteColor];
    if (self) {
//        if (_showAddBtn) {
//            [self addSubview:self.addBtn];
//            addCount = 1;
//        }
//        [self addSubview:self.sendBtn];
//        
//        [self addSubview:self.toolBarCollection];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (_showAddBtn) {
        [self addSubview:self.addBtn];
        addCount = 1;
        _toolBarCollection.frame = CGRectMake(kSendBtnWidth*addCount, 0, ScreenWidth-kSendBtnWidth-kSendBtnWidth*addCount, kToolBarHeight);
    }
    [self addSubview:self.sendBtn];
    
    [self addSubview:self.toolBarCollection];
}

#pragma mark - 初始化
+ (EmojiToolBar *)sharedToolBar {
    
    return [self new];
    
}

#pragma mark - lazy load

- (NSMutableArray *)toolBarAry {
    if (!_toolBarAry) {
        _toolBarAry = [WMEmojiManager sharedEmoji].toolBarImageAr;
    }
    return _toolBarAry;
}

- (void)setToolBarAry:(NSMutableArray *)toolBarAry{
    _toolBarAry = toolBarAry;
    [self.toolBarCollection reloadData];
}
- (UIButton *)addBtn {
    if (!_addBtn) {
        WS(wSelf);
        _addBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kSendBtnWidth, kToolBarHeight)];
        [_addBtn setImage:[UIImage imageNamed:@"emotion_tool_add"] forState:UIControlStateNormal];
        [_addBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 4, 0)];
        [_addBtn.titleLabel setFont:[UIFont systemFontOfSize:30]];
        [_addBtn setTitleColor:[UIColor colorWithRed:95.0/255.0 green:100.0/255.0 blue:105.0/255.0 alpha:1] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(ClickedAddBtn:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(_addBtn.frame)-0.8, CGRectGetHeight(_addBtn.frame)/4, 0.8, CGRectGetHeight(_addBtn.frame)/2)];
        line.backgroundColor = [UIColor lineColor];
        UIView * redView = [[UIView alloc] init];
        redView.tag = 12301;
        redView.backgroundColor = [UIColor redColor];
        redView.layer.cornerRadius = 3.0;
        [_addBtn addSubview:redView];
        [redView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(wSelf.addBtn).offset(-5);
            make.top.equalTo(wSelf.addBtn).offset(5);
            make.width.height.equalTo(@6);
        }];
        redView.hidden = [[NSUserDefaults standardUserDefaults] boolForKey:@"clickAddGIF"];
        [_addBtn addSubview:line];
    }
    return _addBtn;
}

- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-kSendBtnWidth, 0, kSendBtnWidth, kToolBarHeight)];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        _sendBtn.enabled = NO;
//        [_sendBtn setBackgroundImage:[UIImage imageWithCornerRadius:0 fillColor:[UIColor sendBgHighlightedColor] StrokeColor:nil] forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor sendTitleHighlightedColor] forState:UIControlStateNormal];
//        [_sendBtn setBackgroundImage:[UIImage imageWithCornerRadius:0 fillColor:[UIColor sendBgNormalColor] StrokeColor:nil] forState:UIControlStateDisabled];
        [_sendBtn setTitleColor:[UIColor sendTitleNormalColor] forState:UIControlStateDisabled];
//        _sendBtn.backgroundColor = [UIColor sendBgNormalColor];
        [_sendBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_sendBtn addTarget:self action:@selector(clickedSendBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0.8, CGRectGetHeight(_sendBtn.frame))];
        line.layer.borderWidth = 0.8;
        line.layer.borderColor = [[UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1] CGColor];
        [_sendBtn addSubview:line];
    }
    return _sendBtn;
}

- (UICollectionView *)toolBarCollection {
    if (!_toolBarCollection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [layout setItemSize:CGSizeMake(kSendBtnWidth, kToolBarHeight)];
        [layout setMinimumLineSpacing:0];
        [layout setMinimumInteritemSpacing:0];
        _toolBarCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(kSendBtnWidth*addCount, 0, ScreenWidth-kSendBtnWidth-kSendBtnWidth*addCount, kToolBarHeight) collectionViewLayout:layout];
        _toolBarCollection.showsHorizontalScrollIndicator = NO;
        _toolBarCollection.delegate = self;
        _toolBarCollection.dataSource = self;
        _toolBarCollection.backgroundColor = [UIColor clearColor];
        [_toolBarCollection registerClass:[ToolBarCell class] forCellWithReuseIdentifier:@"ToolBarCell"];
    }
    return _toolBarCollection;
}

#pragma mark - uicollectionview datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.toolBarAry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ToolBarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ToolBarCell" forIndexPath:indexPath];
    NSString * string = _toolBarAry[indexPath.row];
    if ([string hasSuffix:@"cover.png"]) {
        [cell.img setImage:[UIImage imageWithContentsOfFile:_toolBarAry[indexPath.row]]];
    }
    else{
        UIImage * image = [UIImage imageNamed:_toolBarAry[indexPath.row]];
    [cell.img setImage:image];
    }
    if (indexPath.row == seletedRow) {
        cell.selected = YES;
    }
    return cell;
}
#pragma mark - Collection View Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [WMEmojiManager sharedEmoji].selectedRow = indexPath.row;
    seletedRow = indexPath.row;
    [collectionView reloadData];
    self.selectedBlock(indexPath.row);
}


#pragma mark - click events
- (void)clickedSendBtn:(UIButton *)btn {
//    btn.enabled = NO;
//    [btn setTitleColor:[UIColor sendTitleNormalColor] forState:UIControlStateNormal];
//    btn.backgroundColor = [UIColor sendBgNormalColor];
    self.sendBlock();
}

- (void)ClickedAddBtn:(UIButton *)btn {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"clickAddGIF"];
    UIView * redView = [self.addBtn viewWithTag:12301];
    redView.hidden = YES;
    self.addBlock();
}


#pragma mark - 块方法
- (void)sendEmojis:(SendBlock)block{
    self.sendBlock = block;
}

- (void)selectedToolBar:(SelectedBlock)block {
    self.selectedBlock = block;
}

- (void)addBtnClicked:(AddBlock)block {
    self.addBlock = block;
}

@end


