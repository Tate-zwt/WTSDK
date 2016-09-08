//
//  WTTextView.h
//  WTSDK
//
//  Created by 张威庭 on 15/12/16.
//  Copyright © 2015年 zwt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTTextView : UITextView

/**
 *  提示用户输入的标语
 */
@property (nonatomic, copy) NSString *placeHolder;

/**
 *  标语文本的颜色
 */
@property (nonatomic, strong) UIColor *placeHolderTextColor;

/**
 *  获取自身文本占据有多少行
 */
- (NSUInteger)numberOfLinesOfText;

/**
 *  获取每行的高度
 */
+ (NSUInteger)maxCharactersPerLine;

/**
 *  获取某个文本占据自身适应宽带的行数
 */
+ (NSUInteger)numberOfLinesForMessage:(NSString *)text;

/**
 *  边框啊 传空默认颜色或hex   宽默认1
 */
@property (nonatomic, copy) NSString *bor_c;

/**
 *  强制按字符长度计算限制文本的最大长度 (一个中文算两个字符！)
 */
@property (nonatomic, assign) NSUInteger maxCharactersLength;
/**
 *  强制按text.length长度计算限制文本的最大长度
 */
@property (nonatomic, assign) NSUInteger maxTextLength;
/** 显示ToolBar */
@property (nonatomic, assign, getter=isShowToolBar) BOOL showToolBar;
/** 点换行是取消响应 */
@property (nonatomic, assign, getter=isReturnToresign) BOOL returnToresign;
@property (nonatomic, strong) UIToolbar *toolbar;
/** 禁止使用表情字符 */
@property (nonatomic, assign, getter=isDisabelEmoji) BOOL disabelEmoji;

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
- (void)textViewDidChange:(UITextView *)textView;

@end
