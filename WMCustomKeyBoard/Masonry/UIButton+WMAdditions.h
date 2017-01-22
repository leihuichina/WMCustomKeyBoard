//
//  UIButton+ILAdditions.h
//  iLight
//
//  Created by chang qin on 15/9/4.
//  Copyright (c) 2015年 xiaokakeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (WMAdditions)

- (void)clickForce;
+ (instancetype)buttonWithType:(UIButtonType)buttonType configure:(void(^)(UIButton *btn))configureBlock action:(void(^)(UIButton *btn))actionBlock;
@end
