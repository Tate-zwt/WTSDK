
#ifdef DEBUG //处于开发阶段
#define NSLog(...) NSLog(@"%s %d\n %@\n\n", __func__, __LINE__, [NSString stringWithFormat:__VA_ARGS__])
#else //处于发布阶段
#define NSLog(...)
#endif

//我要导入的东西哈哈哈哈哈😊😊😊😊😊😊😊😊😊😊😊😊😊
#ifdef __OBJC__
//basic frame 😅
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//category
#import "CALayer+WT.h"
#import "NSArray+WT.h"
#import "NSDate+WT.h"
#import "NSString+WT.h"
#import "NSTimer+WT.h"
#import "UIBarButtonItem+WT.h"
#import "UIImage+WT.h"
#import "UILabel+WT.h"
#import "UITextView+WT.h"
#import "UIView+WT.h"
#import "UIViewController+WT.h"

//tool
#import "WTUtility.h"
#import "Singleton.h"

//View 😙😙😙😙😙😙😙😙😙😙
#import "UIButton+WT.h"
#import "WTTextField.h"
#import "WTTextView.h"

#endif
//导入的东西 END😊😊😊😊😊😊😊😊😊😊😊😊😊😊

#define USDF [NSUserDefaults standardUserDefaults]

//获取最上层的window
#define WTTopWindow [[UIApplication sharedApplication].windows lastObject]
//弱引用申明
#define WSELF __weak __typeof(self) weakSelf = self;

#define SFM(x) ([NSString stringWithFormat:@"%@", (x)])

#define WTAppDelegate ((AppDelegate *) [[UIApplication sharedApplication] delegate])
#define WTUserDefaults [NSUserDefaults standardUserDefaults]

//状态栏高度
#define WTStatus_Bar_Height 20
//NavBar高度
#define WTNavigation_Bar_Height 44
//状态栏 ＋ 导航栏 高度
#define WTStatus_And_Navigation_Height ((WTStatus_Bar_Height) + (WTNavigation_Bar_Height))
//底部tab高度
#define WTTab_Bar_Height 49

//通知中心
#define WTNotificationCenter [NSNotificationCenter defaultCenter]
#define WTScreenHeight [UIScreen mainScreen].bounds.size.height
#define WTScreenWidth [UIScreen mainScreen].bounds.size.width
#define WTDeviceHeight [UIScreen mainScreen].bounds.size.height
#define WTDeviceWidth [UIScreen mainScreen].bounds.size.width
#define PI 3.14159265358979323846

#define WTStrIsEmpty(str) ([str isKindOfClass:[NSNull class]] || [str length] < 1 ? YES : NO || [str isEqualToString:@"(null)"] || [str isEqualToString:@"null"])
//随机色
#define WTRandomColor [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1.0]

// RGB颜色
#define WTColor(r, g, b) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1.0]

#define WTAlphaColor(r, g, b, a) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]
#define WTHexColor(X) [UIColor colorWithRed:((float) ((X & 0xFF0000) >> 16)) / 255.0 green:((float) ((X & 0xFF00) >> 8)) / 255.0 blue:((float) (X & 0xFF)) / 255.0 alpha:1.0]
#define WTHexColorA(X, A) [UIColor colorWithRed:((float) ((X & 0xFF0000) >> 16)) / 255.0 green:((float) ((X & 0xFF00) >> 8)) / 255.0 blue:((float) (X & 0xFF)) / 255.0 alpha:A]

// 是否为iOS9,获得系统版本
#define WTIOS9 ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0)

// 是否为iOS7,获得系统版本
#define WTIOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

// 是否为iOS8,获得系统版本
#define WTIOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
// 是否为iOS6,获得系统版本
#define WTIOS6 ([[UIDevice currentDevice].systemVersion doubleValue] <= 6.1)

#define iPhone4_Screen (WTDeviceHeight == 480 ? 1 : 0)
#define iPhone6_Screen (WTDeviceWidth == 375 ? 1 : 0)
#define iPhone6Plus_Screen (WTDeviceWidth == 414 ? 1 : 0)
