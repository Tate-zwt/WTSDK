//  GitHub: https://github.com/Tate-zwt/WTSDK
//  UITextView+WT.m
//  WTSDK
//
//  Created by 张威庭 on 15/12/16.
//  Copyright © 2015年 zwt. All rights reserved.
//

#import "UITextView+WT.h"
#import "UIView+WT.h"

@implementation UITextView (WT)

- (void)insertAttributedText:(NSAttributedString *)text {
    [self insertAttributedText:text settingBlock:nil];
}

- (void)insertAttributedText:(NSAttributedString *)text settingBlock:(void (^)(NSMutableAttributedString *))settingBlock {
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    // 拼接之前的文字（图片和普通文字）
    [attributedText appendAttributedString:self.attributedText];

    // 拼接其他文字
    NSUInteger loc = self.selectedRange.location;
    //    [attributedText insertAttributedString:text atIndex:loc];
    [attributedText replaceCharactersInRange:self.selectedRange withAttributedString:text]; //选中的内容替换

    // 调用外面传进来的代码
    if (settingBlock) {
        settingBlock(attributedText);
    }

    self.attributedText = attributedText;

    // 移除光标到表情的后面
    self.selectedRange = NSMakeRange(loc + 1, 0);
}

- (void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing {
    if (lineSpacing < 0.01 || !text) {
        self.text = text;
        return;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, [text length])];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    
    self.attributedText = attributedString;
}

+ (CGFloat)text:(NSString*)text heightWithFontSize:(CGFloat)fontSize width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing {
    UITextView* textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, width, MAXFLOAT)];
    textView.font = [UIFont systemFontOfSize:fontSize];
    [textView setText:text lineSpacing:lineSpacing];
    [textView sizeToFit];
    return textView.height;
}
@end
