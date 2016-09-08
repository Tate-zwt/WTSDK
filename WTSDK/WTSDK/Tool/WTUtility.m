//
//  WTUtility.m
//  WTSDK
//
//  Created by 张威庭 on 15/9/27.
//  Copyright © 2015年 zwt. All rights reserved.
//

#import "SystemConfiguration/SystemConfiguration.h"
#import "UIImage+WT.h"
#import "WTUtility.h"
#import <AVFoundation/AVFoundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import <MapKit/MapKit.h>
#import <mach/mach_time.h>
#include <netdb.h>

#define ORIGINAL_MAX_WIDTH 640.0f
@implementation WTUtility

/** 计算两个经纬的距离 */
+ (double)calculateDistanceWithLatitude:(NSString *)latitudeOne andLongitude:(NSString *)longitudeOne twoDistanceWithLatitude:(NSString *)latitudeTwo andLongitude:(NSString *)longitudeTwo {
    CLLocation *orig = [[CLLocation alloc] initWithLatitude:latitudeOne.doubleValue longitude:longitudeOne.doubleValue];
    CLLocation *dist = [[CLLocation alloc] initWithLatitude:latitudeTwo.doubleValue longitude:longitudeTwo.doubleValue];

    CLLocationDistance kilometers = [orig distanceFromLocation:dist] / 1000;
    NSLog(@"距离:%f", kilometers);

    return kilometers;
}

+ (void)saveLastUserName:(NSString *)userName password:(NSString *)password {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = @{ @"userName" : userName,
                           @"password" : password };
    [userDefaults setObject:dic forKey:@"UserNameAndPasswordDic"];
}

+ (NSDictionary *)getUserNameAndPasswordInfoDic {
    return [NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserNameAndPasswordDic"]];
}
+ (void)saveUserInfoDic:(NSMutableDictionary *)dic {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dic forKey:@"UserModelDic"];
    [userDefaults synchronize];
}

+ (void)removeUserInfoDic {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"UserModelDic"];
}

+ (void)removeUserNameAndPasswordInfoDic {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"UserNameAndPasswordDic"];
}
+ (NSMutableDictionary *)getUserInfoDic {
    return [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserModelDic"]];
}

// 纯颜色图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//验证是否ASCII码
+ (BOOL)isASCII:(NSString *)Character {
    NSCharacterSet *cs;
    cs = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@／:;（）¥「」!,.?<>£＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\"/"
                                                             ""];
    NSRange specialrang = [Character rangeOfCharacterFromSet:cs];
    if (specialrang.location != NSNotFound) {
        return YES;
    }
    return NO;
}
//验证是含本方法定义的 “特殊字符”
+ (BOOL)isSpecialCharacter:(NSString *)Character {
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／:;（）¥「」!,.?<>£＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\"/"
                                                                              ""];
    NSRange specialrang = [Character rangeOfCharacterFromSet:set];
    if (specialrang.location != NSNotFound) {
        return YES;
    }
    return NO;
}

// 验证是否是数字
+ (BOOL)isNumber:(NSString *)Character {
    NSCharacterSet *cs;
    cs = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSRange specialrang = [Character rangeOfCharacterFromSet:cs];
    if (specialrang.location != NSNotFound) {
        return YES;
    }
    return NO;
}
//震动效果
+ (CAKeyframeAnimation *)shakeAnimation {
    CAKeyframeAnimation *shake = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    shake.values = @[ [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f)], [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f)] ];
    shake.autoreverses = YES;
    shake.repeatCount = 2.0f;
    shake.duration = 0.07f;
    return shake;
    //[Btn.layer addAnimation:shake forKey:nil];
}

/**
 *  代码执行时间
 */
void WTUseTime(void (^block)(void)) {
    mach_timebase_info_data_t info;
    if (mach_timebase_info(&info) != KERN_SUCCESS) return;
    uint64_t start = mach_absolute_time();
    block();
    uint64_t end = mach_absolute_time();
    uint64_t elapsed = end - start;
    uint64_t nanos = elapsed * info.numer / info.denom;
    NSLog(@"⏰ %f", (CGFloat) nanos / NSEC_PER_SEC);
}
/**
 *  代码执行时间(循环XXXXX次)
 */
void code_RunTime(int times, void (^block)(void)) {
    int TureTime = times ? times : 10000;
    WTUseTime(^{
        for (int i = 0; i < TureTime; i++) {
            block();
        }
    });
}

/**
 *  延迟执行
 */
void after_Run(float time, void (^block)(void)) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

+ (BOOL)connectedToNetwork {
    // 创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_in zeroAddress; //sockaddr_in是与sockaddr等价的数据结构
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET; //sin_family是地址家族，一般都是“AF_xxx”的形式。通常大多用的是都是AF_INET,代表TCP/IP协议族

    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *) &zeroAddress); //创建测试连接的引用：
    SCNetworkReachabilityFlags flags;

    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);

    if (!didRetrieveFlags) {
        printf("Error. Could not recover network reachability flagsn");
        return NO;
    }

    /**
     *  kSCNetworkReachabilityFlagsReachable: 能够连接网络
     *  kSCNetworkReachabilityFlagsConnectionRequired: 能够连接网络,但是首先得建立连接过程
     *  kSCNetworkReachabilityFlagsIsWWAN: 判断是否通过蜂窝网覆盖的连接,
     *  比如EDGE,GPRS或者目前的3G.主要是区别通过WiFi的连接.
     *
     */
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);

    //    NSLog(@"------%d",isReachable);
    //    NSLog(@"------%d",needsConnection);
    //return (isReachable && !needsConnection) ? NO : YES;//反向测试
    return (isReachable && !needsConnection) ? YES : NO;
}

+ (NSMutableString *)sepearteMoneyByString:(NSMutableString *)money {
    NSInteger three = 0;
    NSInteger slong = money.length;
    while (slong--) {
        three++;
        if (three == 3) {
            three = 0;
            [money insertString:@" " atIndex:slong];
        }
    }
    return money;
}

//保证在scrollview上的Btn也有点击效果
+ (void)btnSuddenlyTouch:(UIButton *)senderBtn {
    senderBtn.selected = !senderBtn.isSelected;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        senderBtn.selected = !senderBtn.isSelected;
    });
}


//随机
+ (NSString *)randomStr {
    const int N = 5;
    NSString *sourceString = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *result = [[NSMutableString alloc] init];
    // srand((int)time(0));
    for (int i = 0; i < N; i++) {
        [result appendString:[sourceString substringWithRange:NSMakeRange(rand() % [sourceString length], 1)]];
    }
    return result;
}

/**
 *  能否使用相机
 */
+ (BOOL)canUseCamera {
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authStatus == AVAuthorizationStatusRestricted) {
        NSLog(@"Restricted");
    } else if (authStatus == AVAuthorizationStatusDenied) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请在设备的设置-隐私-相机 中允许访问相机。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    } else if (authStatus == AVAuthorizationStatusAuthorized) { //允许访问
        return YES;
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:mediaType
                                 completionHandler:^(BOOL granted) {
                                     if (granted) { //点击允许访问时调用
                                         //用户明确许可与否，媒体需要捕获，但用户尚未授予或拒绝许可。
                                         NSLog(@"Granted access to %@", mediaType);
                                     } else {
                                         NSLog(@"Not granted access to %@", mediaType);
                                     }
                                 }];
    } else {
        NSLog(@"Unknown authorization status");
    }

    return YES;
}

@end
