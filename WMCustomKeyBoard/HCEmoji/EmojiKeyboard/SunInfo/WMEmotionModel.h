//
//  WMEmotionModel.h
//  withMe
//
//  Created by LeiHui on 16/8/31.
//  Copyright © 2016年 从来网络. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    WMEmotionType_emoji,//系统emoji表情
    WMEmotionType_custom,//自定义小表情
    WMEmotionType_big,//大表情
} WMEmotionType;

@interface WMEmotionModel : NSObject
@property (nonatomic, copy)NSString * groupId;//表情组
@property (nonatomic, copy)NSString * chName;//表情输入名称
@property (nonatomic, copy)NSString * png;
@property (nonatomic, copy)NSString * gif;
@property (nonatomic, assign)WMEmotionType emotionType;
@property (nonatomic, copy)NSString * pngPath;
@property (nonatomic, copy)NSString * gifPath;
@property (nonatomic, copy)NSString * gifUrl;
- (instancetype)initWithDic:(NSDictionary *)dic;
- (instancetype)initWithGifDic:(NSDictionary *)dic;
@end
