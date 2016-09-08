//
//  WTTextView.m
//  WTSDK
//
//  Created by 张威庭 on 15/12/16.
//  Copyright © 2015年 zwt. All rights reserved.
//

#import "WTConst.h"
#import "WTTextView.h"
@implementation WTTextView

- (void)setPlaceHolder:(NSString *)placeHolder {
    if ([placeHolder isEqualToString:_placeHolder]) {
        //        return;
    }

    NSUInteger maxChars = [WTTextView maxCharactersPerLine];
    if ([placeHolder length] > maxChars) {
        placeHolder = [placeHolder substringToIndex:maxChars - 8];
        placeHolder = [[placeHolder stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByAppendingFormat:@"..."];
    }

    _placeHolder = placeHolder;
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveTextDidChangeNotification:) name:UITextViewTextDidChangeNotification object:self];
    [self setNeedsDisplay];
}

- (void)setPlaceHolderTextColor:(UIColor *)placeHolderTextColor {
    if ([placeHolderTextColor isEqual:_placeHolderTextColor]) {
        return;
    }

    _placeHolderTextColor = placeHolderTextColor;
    [self setNeedsDisplay];
}

#pragma mark - Message text view

- (NSUInteger)numberOfLinesOfText {
    return [WTTextView numberOfLinesForMessage:self.text];
}

+ (NSUInteger)maxCharactersPerLine {
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 33 : 109;
}

+ (NSUInteger)numberOfLinesForMessage:(NSString *)text {
    return (text.length / [WTTextView maxCharactersPerLine]) + 1;
}

#pragma mark - Text view overrides

- (void)setText:(NSString *)text {
    [super setText:text];
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    [super setContentInset:contentInset];
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self setNeedsDisplay];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    [self setNeedsDisplay];
}

#pragma mark - Notifications

- (void)didReceiveTextDidChangeNotification:(NSNotification *)notification {
    [self setNeedsDisplay];
}

#pragma mark - Life cycle

- (void)setup {
    _placeHolderTextColor = [UIColor lightGrayColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.scrollIndicatorInsets = UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 8.0f);
    self.contentInset = UIEdgeInsetsZero;
    self.scrollEnabled = YES;
    self.scrollsToTop = YES;
    self.userInteractionEnabled = YES;
    self.font = [UIFont systemFontOfSize:16.0f];
    self.textColor = [UIColor blackColor];
    self.backgroundColor = [UIColor whiteColor];
    self.keyboardAppearance = UIKeyboardAppearanceDefault;
    self.keyboardType = UIKeyboardTypeDefault;
    self.returnKeyType = UIReturnKeySend;
    ;
    self.textAlignment = NSTextAlignmentJustified;

    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.enablesReturnKeyAutomatically = YES;
}

/**
 *  当控件是从xib storyboard中创建时,就会先调用这个方法initWithCoder:之后awakeFromNib:方法
 *
 */
- (id)initWithCoder:(NSCoder *)decoder {

    if (self = [super initWithCoder:decoder]) {

        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)dealloc {
    _placeHolder = nil;
    _placeHolderTextColor = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if ([self.text length] == 0 && self.placeHolder) {
        CGRect placeHolderRect = CGRectMake(13.0f, 7.0f, rect.size.width, rect.size.height);
        [self.placeHolderTextColor set];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        paragraphStyle.alignment = self.textAlignment;
        [self.placeHolder drawInRect:placeHolderRect withAttributes:@{
            NSFontAttributeName : self.font ? self.font : [UIFont systemFontOfSize:13],
            NSForegroundColorAttributeName : self.placeHolderTextColor ? self.placeHolderTextColor : [UIColor lightGrayColor],
            NSParagraphStyleAttributeName : paragraphStyle
        }];
    }
}

- (UIToolbar *)toolbar {
    if (_toolbar == nil) {
        UIToolbar *actionBar = [[UIToolbar alloc] init];
        [actionBar sizeToFit];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(wancheng)];
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [actionBar setItems:[NSArray arrayWithObjects:flexible, doneButton, nil]];
        _toolbar = actionBar;
        _toolbar.barStyle = UIBarStyleDefault;
        _toolbar.translucent = YES;
    }
    return _toolbar;
}

- (void)wancheng {
    [self endEditing:YES];
}

/**
 *  边框啊 颜色 宽默认1
 */
- (void)setBor_c:(NSString *)bor_c {
    if ([bor_c isEqualToString:@"EVGO_Color"] || bor_c.length == 0) {
        [self border:[UIColor lightGrayColor] width:1];
        return;
    }
    if (![bor_c hasPrefix:@"0x"]) {
        bor_c = [NSString stringWithFormat:@"0x%@", bor_c];
    }
    //    unsigned long red = strtoul([bor_c UTF8String],0,16);
    [self border:[UIColor lightGrayColor] width:1];
}

//强制按字符长度计算限制文本的最大长度 (一个中文算两个字符！) 加强判断 设另个为0
- (void)setMaxCharactersLength:(NSUInteger)maxCharactersLength {
    _maxCharactersLength = maxCharactersLength;
    _maxTextLength = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange) name:UITextViewTextDidChangeNotification object:self];
}

//强制按text.length长度计算限制文本的最大长度 加强判断  设另个为0
- (void)setMaxTextLength:(NSUInteger)maxTextLength {
    _maxTextLength = maxTextLength;
    self.delegate = (id<UITextViewDelegate>) self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange) name:UITextViewTextDidChangeNotification object:self];
}

- (void)setShowToolBar:(BOOL)showToolBar {
    _showToolBar = showToolBar;
    self.delegate = (id<UITextViewDelegate>) self;
}

- (void)setDisabelEmoji:(BOOL)disabelEmoji {
    _disabelEmoji = disabelEmoji;
    self.delegate = (id<UITextViewDelegate>) self;
}

//NSNotification
- (void)textViewDidChange {
    if (_maxCharactersLength) {
        if (self.markedTextRange == nil && [self.text textLength] > _maxCharactersLength) {
            self.text = [self.text limitMaxTextShow:_maxCharactersLength];
        }
    }
    if (_maxTextLength) {
        if (self.markedTextRange == nil && self.text.length > _maxTextLength) {
            self.text = [self.text substringToIndex:_maxTextLength];
        }
    }
    [self setNeedsDisplay];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    if (range.length == 1) {
        return YES;
    }
    if (_maxTextLength && self.text.length > _maxTextLength) {
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (self.showToolBar) {
        textView.inputAccessoryView = self.toolbar;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    [textView scrollRangeToVisible:NSMakeRange([textView.text length] - 1, 0)];
    NSRange textRange = [textView selectedRange];
    if (self.disabelEmoji && self.markedTextRange == nil) {
        [textView setText:textView.text.disableEmoji];
    }
    [textView setSelectedRange:textRange];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
}

@end
