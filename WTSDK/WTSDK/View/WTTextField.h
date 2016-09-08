//
//  WTTextField.h
//  WTSDK
//
//  Created by 张威庭 on 15/12/16.
//  Copyright © 2015年 zwt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTTextField : UITextField

/** 右边也加placeHolder */
- (void)addRightPlaceHolder:(NSString *)placeHolder;

/** 认为是电话号码 按电话号码的限制输入 */
@property (nonatomic, assign, getter=isTelePhone) BOOL telePhone;

/** 认为是身份证 加个button X */
@property (nonatomic, assign, getter=isIdentityInput) BOOL identityInput;

/** 纯数字形式的输入 */
@property (nonatomic, assign, getter=isNumber) BOOL number;

/** 数字形式的输入 可以有小数点 点后最多两位数 */
@property (nonatomic, assign, getter=isNumber_dot) BOOL number_dot;

/** 限制特殊字符的输入 */
@property (nonatomic, assign, getter=isDisableSpecialChat) BOOL disableSpecialChat;

/** 必须是 ASCII字符 */
@property (nonatomic, assign, getter=isMust_ASCII) BOOL must_ASCII;

/** 强制按字符长度计算限制文本的最大长度 (一个中文算两个字符！) */
@property (nonatomic, assign) NSUInteger maxCharactersLength;

/** 强制按text.length长度计算限制文本的最大长度 */
@property (nonatomic, assign) NSUInteger maxTextLength;

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;

@end
