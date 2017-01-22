
//  Created by Caoyq on 16/5/13.
//  Copyright © 2016年 honeycao. All rights reserved.
//

#import "EmojiCell.h"
#import "WMEmojiManager.h"
#import "WMEmotionModel.h"
#import "WMEmotionAttachment.h"
#import "Masonry.h"
@implementation EmojiCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.lab];
        [self addSubview:self.img];
        [self.lab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        [self.img mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.lessThanOrEqualTo(self.mas_width);
            make.height.lessThanOrEqualTo(self.mas_height);

        }];

        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UILabel *)lab {
    if (!_lab) {
        _lab = [[UILabel alloc] init];
        _lab.textColor = [UIColor blackColor];
        _lab.font = [UIFont systemFontOfSize:30];
        _lab.textAlignment = NSTextAlignmentCenter;
    }
    return _lab;
}

- (UIImageView *)img {
    if (!_img) {
        _img = [[UIImageView alloc]init];
        [_img setContentMode:UIViewContentModeScaleAspectFit];
    }
    return _img;
}

- (void)layoutSubviews{
   }

-(void)setInfo:(id)info{
    if ([info isKindOfClass:[NSString class]]) {
        self.img.hidden = YES;
        self.lab.hidden = NO;
        self.lab.text = info;
    }
    else{
        WMEmotionModel * model = (WMEmotionModel *)info;
        self.img.hidden = NO;
        self.lab.hidden = YES;
        if (model.emotionType == WMEmotionType_big) {
            [self.img setImage:[UIImage imageWithContentsOfFile:[model gifPath]]];
        }
        else{
            [self.img setImage:[UIImage imageNamed:[model png]]];

        }
    }
}
@end
