//
//  WTTextField.m
//  WTSDK
//
//  Created by 张威庭 on 15/12/16.
//  Copyright © 2015年 zwt. All rights reserved.
//

#import "NSString+WT.h"
#import "WTTextField.h"
#import <objc/runtime.h>
static const char *PlaceLabel = "PlaceLabel";
@implementation WTTextField

//重载方法，控制弹出选项
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(paste:)) //过滤粘贴操作
    {
        return NO;
    } else if (action == @selector(copy:)) //过滤赋值操作
    {
        return NO;
    } else if (action == @selector(select:)) //过滤选择操作
    {
        return NO;
    } else if (action == @selector(selectAll:)) //过滤选择全部操作
    {
        return NO;
    }
    //其它的操作不过滤
    return [super canPerformAction:action withSender:sender];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        if (([[[UIDevice currentDevice] systemVersion] floatValue] > 8.0)) {
            self.delegate = (id<UITextFieldDelegate>) self;
        } else {
        }
    }
    return self;
}

- (void)awakeFromNib {
    if (([[[UIDevice currentDevice] systemVersion] floatValue] > 8.0)) {
        self.delegate = (id<UITextFieldDelegate>) self;
    } else {
    }
}
#pragma mark - 这里可以控制里面文字的间距
//- (CGRect)editingRectForBounds:(CGRect)bounds {
//    return CGRectInset(bounds, 8, 0);
//}
//
//- (CGRect)textRectForBounds:(CGRect)bounds {
//    return CGRectInset(bounds, 8, 0);
//}

- (UILabel *)placeHolderLabel {
    return objc_getAssociatedObject(self, PlaceLabel);
}
- (void)setPlaceHolderLabel:(UILabel *)placeHolderLabel {
    objc_setAssociatedObject(self, PlaceLabel, placeHolderLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)addRightPlaceHolder:(NSString *)placeHolder {
    CGFloat W = [placeHolder widthWithFont:12 h:20];
    UILabel *La = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - W - 8, 0, W, self.frame.size.height)];
    La.text = placeHolder;
    La.textColor = [UIColor lightGrayColor];
    La.font = [UIFont systemFontOfSize:12];
    [self addSubview:La];
    [self setPlaceHolderLabel:La];
    //    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange) name:UITextFieldTextDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange) name:UITextFieldTextDidEndEditingNotification object:self];
}

- (void)textFieldChange {
    [self placeHolderLabel].hidden = self.text.length;
}

//认为是电话号码 按电话号码的限制输入
- (void)setTelePhone:(BOOL)telePhone {
    _telePhone = telePhone;
    self.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)setIdentityInput:(BOOL)identityInput {
    _identityInput = identityInput;
    self.keyboardType = UIKeyboardTypeNumberPad;
    _maxTextLength = 24;
}

//纯数字形式的输入
- (void)setNumber:(BOOL)number {
    _number = number;
    self.keyboardType = UIKeyboardTypeNumberPad;
}

//数字形式的输入 可以有小数点 点后最多两位数
- (void)setNumber_dot:(BOOL)number_dot {
    _number_dot = number_dot;
    self.keyboardType = UIKeyboardTypeDecimalPad;
}

//限制特殊字符的输入
- (void)setDisableSpecialChat:(BOOL)disableSpecialChat {
    _disableSpecialChat = disableSpecialChat;
}

//必须是 ASCII字符
- (void)setMust_ASCII:(BOOL)must_ASCII {
    _must_ASCII = must_ASCII;
    self.keyboardType = UIKeyboardTypeASCIICapable;
}

//强制按字符长度计算限制文本的最大长度 (一个中文算两个字符！) 加强判断 设另个为0
- (void)setMaxCharactersLength:(NSUInteger)maxCharactersLength {
    _maxCharactersLength = maxCharactersLength;
    _maxTextLength = 0;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:self];
}

//强制按text.length长度计算限制文本的最大长度 加强判断  设另个为0
- (void)setMaxTextLength:(NSUInteger)maxTextLength {
    _maxTextLength = maxTextLength;
    _maxCharactersLength = 0;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}

//NSNotification
- (void)textFieldDidChange {
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
}

#pragma mark - textField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.length >= 1) {
        return YES;
    }
    //电话号码
    if (_telePhone) {
        NSString *Mix = [textField.text addStr:string];
        if (Mix.delSpace.length > 11 || ![string isNumber]) {
            return NO;
        }
        if (Mix.length == 3 || Mix.length == 8) {
            textField.text = [Mix addStr:@" "];
            return NO;
        }
        return YES;
    }
    //数字
    if (_number) {
        if (![string isNumber]) {
            return NO;
        }
    }
    //可以有小数点的 数字 小数点有判断
    if (_number_dot) {
        if (![string isNumber] && ![string isEqualToString:@"."]) {
            return NO;
        }
        if ([string isEqualToString:@"."]) {
            if (textField.text.length == 0 || [textField.text rangeOfString:@"."].location != NSNotFound) {
                return NO;
            }
        } else { //输入数字
            NSUInteger at = [textField.text rangeOfString:@"."].location;
            if (at != NSNotFound) {
                if (textField.text.length - at > 2) { //点后最多两位数
                    return NO;
                }
            }
        }
    }

    if (_maxTextLength && textField.text.length >= _maxTextLength) {
        return NO;
    }

    if (_maxCharactersLength && textField.text.textLength >= _maxCharactersLength) {
        return NO;
    }

    if (_disableSpecialChat && [string isSpecialCharacter]) {
        return NO;
    }

    if (_must_ASCII && ![string isASCII]) {
        return NO;
    }

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    //    身份证 加个button X
    if (_identityInput) {
        textField.inputAccessoryView = [self createActionBar];
    } else {
        textField.inputAccessoryView = nil;
    }
    return YES;
}

- (UIToolbar *)createActionBar {
    UIToolbar *actionBar = [[UIToolbar alloc] init];
    [actionBar sizeToFit];
    UIBarButtonItem *L = [[UIBarButtonItem alloc] initWithTitle:@"  O  " style:UIBarButtonItemStylePlain target:self action:@selector(add_O_Char)];
    UIBarButtonItem *R = [[UIBarButtonItem alloc] initWithTitle:@"  X  " style:UIBarButtonItemStylePlain target:self action:@selector(add_X_Char)];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [actionBar setItems:[NSArray arrayWithObjects:L, flexible, R, nil]];
    return actionBar;
}

- (void)add_O_Char {
    if (self.text.length < 24) {
        self.text = [self.text stringByAppendingString:@"O"];
    }
}
- (void)add_X_Char {
    if (self.text.length < 24) {
        self.text = [self.text stringByAppendingString:@"X"];
    }
}

@end
