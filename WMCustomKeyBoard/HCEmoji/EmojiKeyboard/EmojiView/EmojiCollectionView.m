
//  Created by Caoyq on 16/5/12.
//  Copyright © 2016年 honeycao. All rights reserved.
//

#import "EmojiCollectionView.h"
#import "WMEmojiManager.h"
#import "WMHeader.h"
#import "SinglePageEmojiCell.h"

@interface EmojiCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) UIPageControl *indexPC;/**< 页数显示 */
@property (nonatomic, assign) NSInteger nowSection;
@end

@implementation EmojiCollectionView

#pragma mark - Init
- (instancetype)init {
    self = [super init];
    self.backgroundColor = [UIColor emojiBgColor];
    self.frame = CGRectMake(0, 0, ScreenWidth, kCollectionHeight+kPageControlHeight);
    if (self) {
        _dataSource = [[WMEmojiManager sharedEmoji] emotionAllAr];
        [self addSubview:self.emojiCollection];
        [self addSubview:self.indexPC];
        [self.emojiCollection addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

#pragma mark - 初始化
+ (EmojiCollectionView *)sharedCollection {
    return [self new];
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [_emojiCollection reloadData];
//    _indexPC = nil;
//    [self indexPC];
}

#pragma mark - Lazy load
- (UICollectionView *)emojiCollection {
    if (!_emojiCollection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [layout setItemSize:CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-kPageControlHeight)];
        [layout setMinimumLineSpacing:0];
        [layout setMinimumInteritemSpacing:0];
        
        _emojiCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-kPageControlHeight) collectionViewLayout:layout];
        [_emojiCollection setPagingEnabled:YES];
        [_emojiCollection setBounces:YES];
        _emojiCollection.delegate = self;
        _emojiCollection.dataSource = self;
        [_emojiCollection setContentSize:CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-kPageControlHeight)];
        [_emojiCollection setShowsHorizontalScrollIndicator:NO];
        _emojiCollection.backgroundColor = [UIColor clearColor];
        [_emojiCollection registerClass:[SinglePageEmojiCell class] forCellWithReuseIdentifier:@"Cell"];
        [_emojiCollection registerClass:[SinglePageEmojiCell class] forCellWithReuseIdentifier:@"gifCell"];
    }
    return _emojiCollection;
}

- (UIPageControl *)indexPC {
    if (!_indexPC) {
        _indexPC = [[UIPageControl alloc]init];
        _indexPC.frame = CGRectMake(0, CGRectGetHeight(_emojiCollection.frame), CGRectGetWidth(self.bounds), kPageControlHeight);
        _indexPC.currentPage = 0;
        _indexPC.numberOfPages = ceil([_dataSource[0] count] / kPageCount);
        if (_indexPC.numberOfPages == 1) {
            _indexPC.hidden = YES;
        }
        
        _indexPC.pageIndicatorTintColor = [UIColor pageIndicatorTintColor];
        _indexPC.currentPageIndicatorTintColor = [UIColor currentPageIndicatorTintColor];
        _indexPC.backgroundColor = [UIColor clearColor];
    }
    return _indexPC;
}


#pragma mark - uicollectionview datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _dataSource.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section > 2) {
        if ([_dataSource[section] count] < gifPageCount) {
            return 1;
        }
        return ceil([_dataSource[section] count] / gifPageCount);
    }
    return ceil([_dataSource[section] count] / kPageCount);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"row = %ld,section = %ld",indexPath.row,indexPath.section);
    NSArray * dataSec = _dataSource[indexPath.section];
    SinglePageEmojiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:indexPath.section > smallEmtionCount - 1 ? @"gifCell" : @"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    NSIndexSet *indexSet = nil;
    if (indexPath.section > smallEmtionCount - 1) {
        if (indexPath.row < ceil(dataSec.count/gifPageCount)-1) {
            indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(gifPageCount*indexPath.row, gifPageCount)];
        }else{
            NSInteger leng = dataSec.count - gifPageCount*indexPath.row;
            indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(gifPageCount*indexPath.row, leng)];
        }
    }
    else{
        if (indexPath.row < ceil(dataSec.count/kPageCount)-1) {
            indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(kPageCount*indexPath.row, kPageCount)];
        }else{
            NSInteger leng = dataSec.count - kPageCount*indexPath.row;
            indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(kPageCount*indexPath.row, leng)];
        }
    }
    cell.emotionAction = self.emotionAction;
    if (dataSec) {
        cell.dataSource = [dataSec objectsAtIndexes:indexSet];
    }
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"EndDragging");
    [self getTheNowSection:scrollView];
}

//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
//    
//}

- (void)getTheNowSection:(UIScrollView *)scrollView{
//    CGFloat offset = scrollView.contentOffset.x;
//    int count = offset / ScreenWidth;
    NSArray * indexAr = [_emojiCollection indexPathsForVisibleItems];
    NSArray * cells = [_emojiCollection visibleCells];
    int index = 0;
    if (cells.count > 1) {
        float near = 1000;
        for (int i = 0; i < cells.count; i++) {
            CGRect rect = [cells[i] frame];
            float tempsmall =  rect.origin.x - scrollView.contentOffset.x >= 0 ? rect.origin.x - scrollView.contentOffset.x : scrollView.contentOffset.x - rect.origin.x;
            if (tempsmall < near) {
                near = tempsmall;
                index = i;
            }
        }
    }
    NSIndexPath * indexPath = indexAr.count > 0 ? indexAr[index] : nil;
    if(indexPath){
        if (self.nowSection == [indexPath section]) {
            _indexPC.currentPage = indexPath.row;
        }
        else{
            self.nowSection = indexPath.section;
            _indexPC.numberOfPages = [_emojiCollection numberOfItemsInSection:indexPath.section];
            if (_indexPC.numberOfPages == 1) {
                _indexPC.hidden = YES;
            }
            else{
                _indexPC.hidden = NO;
            }
            _indexPC.currentPage = indexPath.row;
        }
    }
}
- (void)checkNowCell{
    
}

- (void)setNowSection:(NSInteger)nowSection{
    _nowSection = nowSection;
    if (self.selectedBlock) {
        self.selectedBlock(nowSection);
    }
}

#pragma mark - KVO监控
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {

    }
}
#pragma mark - 注销
- (void)dealloc {
    [_emojiCollection removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)reloadSection:(NSInteger)index{
    [self.emojiCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    _indexPC.currentPage = 0;
    if (index <= smallEmtionCount - 1) {
        _indexPC.numberOfPages = ceil([_dataSource[index] count] / kPageCount);
    }
    else{
        _indexPC.numberOfPages = ceil([_dataSource[index] count] / gifPageCount);
    }
    _indexPC.hidden = _indexPC.numberOfPages == 1 ;
    
}
@end
