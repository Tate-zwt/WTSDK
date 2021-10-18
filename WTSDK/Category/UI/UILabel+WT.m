//  GitHub: https://github.com/Tate-zwt/WTSDK
//  UILabel+WT.m
//  WTSDK
//
//  Created by 张威庭 on 15/12/16.
//  Copyright © 2015年 zwt. All rights reserved.
//

#import "UILabel+WT.h"
#import "WTConst.h"

@implementation UILabel (WT)

+ (UILabel *)frame:(CGRect)frame title:(NSString *)title font:(UIFont *)font color:(UIColor *)color line:(NSInteger)line addView:(UIView *)addView{
    UILabel *_ = [[UILabel alloc] initWithFrame:frame];
    _.font = font;
    if (color) {
        _.textColor = color;
    }
    _.text = title;
    _.numberOfLines = line;
    [addView addSubview:_];
    return _;
}

/** 有删除线的 */
- (void)delLineStr:(NSString *)string {
    if (WTStrIsEmpty(string)) return;
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:string];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, string.length)];
    [self setAttributedText:attri];
}

/** 有下划线的 */
- (void)underlineStr:(NSString *)string {
    if (WTStrIsEmpty(string)) return;
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:string];
    [attri addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, string.length)];
    [self setAttributedText:attri];
}

- (void)settingLabelHeightofRowString:(NSString*)string{
    [self settingLabelRowOfHeight:10 string:string];
}

- (void)settingLabelRowOfHeight:(CGFloat)height string:(NSString*)string{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:height]; //调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    self.attributedText = attributedString;
    [self sizeToFit];
}


- (void)htmlString:(NSString *)htmlStr{
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.attributedText = attributedString;
}

- (void)htmlString:(NSString *)htmlStr labelRowOfHeight:(CGFloat)height{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[htmlStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:height]; //调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];
    self.attributedText = attributedString;
    [self sizeToFit];
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
    [paragraphStyle setLineBreakMode:self.lineBreakMode];
    [paragraphStyle setAlignment:self.textAlignment];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    
    self.attributedText = attributedString;
}

+ (CGFloat)text:(NSString*)text heightWithFontSize:(CGFloat)fontSize width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing {
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, MAXFLOAT)];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.numberOfLines = 0;
    [label setText:text lineSpacing:lineSpacing];
    [label sizeToFit];
    return label.height;
}

@end
