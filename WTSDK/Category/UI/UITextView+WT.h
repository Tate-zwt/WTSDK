//  GitHub: https://github.com/Tate-zwt/WTSDK
//  UITextView+WT.h
//  WTSDK
//
//  Created by 张威庭 on 15/12/16.
//  Copyright © 2015年 zwt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (WT)
/** 插入NSAttributedString */
- (void)insertAttributedText:(NSAttributedString *)text;
- (void)insertAttributedText:(NSAttributedString *)text settingBlock:(void (^)(NSMutableAttributedString *attributedText))settingBlock;

/** 设置行距 */
- (void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing;

/** 计算TextView的行高 */
+ (CGFloat)text:(NSString*)text heightWithFontSize:(CGFloat)fontSize width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing;
@end
