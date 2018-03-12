//  GitHub: https://github.com/Tate-zwt/WTSDK
//  UILabel+WT.h
//  WTSDK
//
//  Created by 张威庭 on 15/12/16.
//  Copyright © 2015年 zwt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (WT)

/** 创建一个 */
+ (UILabel *)frame:(CGRect)frame title:(NSString *)title font:(UIFont *)font color:(UIColor *)color line:(NSInteger)line addView:(UIView *)addView;

/** 有删除线的 */
- (void)delLineStr:(NSString *)string;

/** 有下划线的 */
- (void)underlineStr:(NSString *)string;

/** 设置label的行高默认为：10 */
- (void)settingLabelHeightofRowString:(NSString*)string;

/** 设置label的行高*/
- (void)settingLabelRowOfHeight:(CGFloat)height string:(NSString*)string;

/** 设置Html代码格式Str */
- (void)htmlString:(NSString *)htmlStr;

/** 设置Html代码格式Str与行高 */
- (void)htmlString:(NSString *)htmlStr labelRowOfHeight:(CGFloat)height;


/** 设置行距 */
- (void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing;

/** 计算label的行高 */
+ (CGFloat)text:(NSString*)text heightWithFontSize:(CGFloat)fontSize width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing;
@end
