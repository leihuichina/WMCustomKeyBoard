//
//  ViewController.m
//  WMCustomKeyBoard
//
//  Created by LeiHui on 2017/1/22.
//  Copyright © 2017年 LeiHui. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "WMEmojiKeyboard.h"
#import "UIButton+WMAdditions.h"
#import "WMHeader.h"
@interface ViewController ()
@property (nonatomic, strong)UITextView * textView;
@property (nonatomic, strong)UIButton * emotionBtn;
@property (nonatomic, strong)WMEmojiKeyboard * custom;
@end

@implementation ViewController


- (void)viewDidLoad {
    WS(wSelf);
    [super viewDidLoad];
    self.textView = [[UITextView alloc] init];
    self.textView.font = [UIFont systemFontOfSize:15];
    self.textView.layer.borderWidth = 1.0;
    self.textView.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(70);
        make.left.equalTo(self.view).offset(10);
        make.right.bottom.equalTo(self.view).offset(-10);
    }];
    
    
    self.emotionBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        btn.backgroundColor = [UIColor redColor];
        [btn setTitle:@"表情键盘" forState:UIControlStateNormal];
    } action:^(UIButton *btn) {
        [wSelf showEmotion];
    }];
    [self.view addSubview:self.emotionBtn];
    [self.emotionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@70);
        make.height.equalTo(@30);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.view).offset(30);
    }];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)showEmotion{
    self.custom = [WMEmojiKeyboard sharedKeyboard];
    _custom.showToolBar = YES;
    _custom.showAddBtn = NO;
    _custom.showClasses = YES;
    [self.custom setTextInput:self.textView];

    [self.textView reloadInputViews];

    [self.textView becomeFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
