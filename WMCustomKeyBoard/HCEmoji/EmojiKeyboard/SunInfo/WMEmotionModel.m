//
//  WMEmotionModel.m
//  withMe
//
//  Created by LeiHui on 16/8/31.
//  Copyright © 2016年 从来网络. All rights reserved.
//

#import "WMEmotionModel.h"
#import "WMEmojiManager.h"

@implementation WMEmotionModel


-(instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.groupId = dic[@"id"];
        self.gif = dic[@"gif"];
        self.chName = dic[@"chs"];
        self.png  = dic[@"png"];
        self.emotionType = [dic[@"type"] integerValue];
        if (self.emotionType != WMEmotionType_big) {
            if (self.png == nil) {
                self.emotionType = WMEmotionType_emoji;
            }
            else{
                self.emotionType = WMEmotionType_custom;
                self.pngPath = [[[[NSBundle mainBundle] pathForResource:@"Emoticons" ofType:@"bundle"] stringByAppendingPathComponent:@"com.sina.lxh"] stringByAppendingPathComponent:dic[@"png"]];
            }
        }
    }
    return self;
}

- (instancetype)initWithGifDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.groupId = @"测试";
        self.gif = dic[@"expression"];
        self.gifUrl = dic[@"key"];
        self.emotionType = WMEmotionType_big;
    }
    return self;
}
@end
