
//  Created by Caoyq on 16/5/16.
//  Copyright © 2016年 honeycao. All rights reserved.
//

#import "SinglePageEmojiCell.h"
#import "WMEmojiManager.h"
#import "EmojiCell.h"
#import "WMHeader.h"
#import "WMEmotionModel.h"
#import "UIButton+WMAdditions.h"
#import "Masonry.h"
#define kRowCount    21
static NSString *emojiCell = @"EmojiCell";
static NSString *gifCellIndifier = @"gifCellIndifier";
@interface SinglePageEmojiCell ()<UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UICollectionView *singleCollction;
@property (strong, nonatomic) WMEmojiManager *emojiManager;
@property (nonatomic, strong)UIButton * bgBtn;
@property (nonatomic, copy)NSString * cellIndifie;

@end
@implementation SinglePageEmojiCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.bgBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
            
        } action:^(UIButton *btn) {
            
        }];
        [self addSubview:self.bgBtn];
        self.backgroundColor = [UIColor clearColor];
       
    }
    return self;
}

- (void)layoutSubviews{
    [self.bgBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
#pragma mark - Lazy load
- (UICollectionView *)singleCollction{
    if (!_singleCollction) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        if ([self.reuseIdentifier isEqualToString:@"gifCell"]) {
            self.cellIndifie = gifCellIndifier;

            layout.itemSize = CGSizeMake(gifWidth_KeyBoard, gifWidth_KeyBoard);
            [layout setSectionInset:UIEdgeInsetsMake(kIconTop, kgifLeft, kIconTop, kgifLeft)];
            [layout setMinimumLineSpacing:kIconTop - 2];
            [layout setMinimumInteritemSpacing:kgifLeft - 0.5];
        }
        else{
            self.cellIndifie = emojiCell;
           layout.itemSize = CGSizeMake(kIconSize, 32);
            [layout setSectionInset:UIEdgeInsetsMake(kIconTop, kIconLeft, kIconTop, kIconLeft)];
            [layout setMinimumLineSpacing:kIconTop];
            [layout setMinimumInteritemSpacing:0];
            }
        _singleCollction = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) collectionViewLayout:layout];
        _singleCollction.tag = 9898;
        _singleCollction.scrollEnabled = NO;

        _singleCollction.delegate = self;
        _singleCollction.dataSource = self;
        _singleCollction.backgroundColor = [UIColor clearColor];
        
            [_singleCollction registerClass:[EmojiCell class] forCellWithReuseIdentifier:self.cellIndifie];
            }
    return _singleCollction;
}

#pragma mark - set dataSource
//在代理方法运行之前运行
- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    if (![self viewWithTag:9898]) {
        [self addSubview:self.singleCollction];
    }
    [_singleCollction reloadData];
}

#pragma mark - Collection View DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.cellIndifie isEqualToString:gifCellIndifier] ? _dataSource.count : 21;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EmojiCell *cell = nil;
   
         cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIndifie forIndexPath:indexPath];
        if (indexPath.row == 20) {
            [cell.lab setText:@""];
            cell.img.hidden = NO;
            cell.img.image = ImgName(@"emotion_tool_delete");
//            [cell.img mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.center.equalTo(cell);
//                make.width.equalTo(@(cell.img.size.width));
//                make.height.equalTo(@(cell.img.size.height));
//
//            }];
            return cell;
        }
        if (_dataSource && indexPath.row < _dataSource.count) {
            cell.info =  _dataSource[indexPath.row];
        }else{
            cell.info =  @"";
        }
        return cell;

    
}

#pragma mark - CollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    EmojiCell *cell = (EmojiCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (indexPath.row == kRowCount-1) {
        //删除表情 发送通知
        if (self.emotionAction) {
            self.emotionAction(nil, YES);
        }
//        [self postNotificationName:@"emotionDelete" object:nil];
    }else{
        if (_dataSource && indexPath.row >= _dataSource.count) {
            return;
        }
        id info = _dataSource[indexPath.row];
        //选中表情 发送通知
        if (self.emotionAction) {
            self.emotionAction(info, NO);
        }
//        [[HCEmojiManager sharedEmoji] addUsedEmojiAryObject:cell.lab.titleLabel.text];
//        [self postNotificationName:@"emotionSelected" object:info];
    }
}

#pragma mark - 表情选中或删除 发送通知
- (void)postNotificationName:(NSString *)name object:(id)object {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:object];
}
@end
