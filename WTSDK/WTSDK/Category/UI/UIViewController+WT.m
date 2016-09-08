//
//  UIViewController+WT.m
//  WTSDK
//
//  Created by 张威庭 on 15/12/16.
//  Copyright © 2015年 zwt. All rights reserved.
//

#import "UIViewController+WT.h"
#import <objc/runtime.h>
static const void *HttpRequestHUDKey = &HttpRequestHUDKey;
@implementation UIViewController (WT)

/**
 *  self.navigationController
 */
- (UINavigationController *)nav {
    UINavigationController *nav = self.navigationController;
    return nav ? nav : self.tabBarController.navigationController;
}

- (UIViewController *)VcWithClassStr:(NSString *)ClassStr {
    UINavigationController *CurrentNav = (UINavigationController *) ([self isKindOfClass:[UINavigationController class]] ? (self) : (self.nav));
    for (UIViewController *vc in [CurrentNav.viewControllers reverseObjectEnumerator]) {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            UITabBarController *Tab = (UITabBarController *) vc;
            for (UIViewController *vc in [Tab.viewControllers reverseObjectEnumerator]) {
                if ([vc isKindOfClass:NSClassFromString(ClassStr)]) {
                    return vc;
                }
            }
        }
        if ([vc isKindOfClass:NSClassFromString(ClassStr)]) {
            return vc;
        }
    }
    return nil;
}

/**
 *  self.nav 默认动画 pushViewController:vc animated:YES
 */
- (void)pushVc:(UIViewController *)vc {
    [self.nav pushViewController:vc animated:YES];
}
- (void)pushVcStr:(NSString *)vcstr {
    [self.nav pushViewController:[[NSClassFromString(vcstr) alloc] init] animated:YES];
}
/**
 * 构建 rightBarButtonItem title
 */
- (void)rightBarBtn:(NSString *)title act:(SEL)selector {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:selector];
}
/**< 构建 rightBarButtonItem title */
- (void)rightBarBtnImgN:(NSString *)imageN act:(SEL)selector {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:imageN] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:selector];
}

- (MBProgressHUD *)HUD {
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}

- (void)setHUD:(MBProgressHUD *)HUD {
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showHUD {
    [self showHUD:nil touch:NO img:-1 delay:-1];
}

- (void)showHUDTouch:(BOOL)touch {
    [self showHUD:nil touch:touch img:-1 delay:-1];
}

- (void)showHUD:(NSString *)text de:(CGFloat)delay {
    [self showHUD:text touch:YES img:-1 delay:delay];
}

- (void)showHUD:(NSString *)text img:(NSInteger)img de:(CGFloat)delay {
    [self showHUD:text touch:YES img:img delay:delay];
}

/**
 *  转 和 文字
 */
- (void)showHUDLabelText:(NSString *)text de:(CGFloat)delay {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.userInteractionEnabled = YES;
    HUD.removeFromSuperViewOnHide = YES;
    HUD.yOffset = -73.0f;
    HUD.labelText = text;
    if (delay != -1) {
        if (delay == 0) {
            [HUD hide:YES afterDelay:0.618];
        } else {
            [HUD hide:YES afterDelay:delay];
        }
    }
    [self setHUD:HUD];
}
/**
 * 显示文本    img -1 不显示图片 1成功 0失败  延迟消失
 */
- (void)showHUD:(NSString *)text touch:(BOOL)touch img:(NSInteger)img delay:(CGFloat)delay {
    //         MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];

    [self.HUD hide:YES];
    MBProgressHUD *HUD;
    if ([self isKindOfClass:[UITableViewController class]] || [self isKindOfClass:[UICollectionView class]]) {
        HUD = [MBProgressHUD showHUDAddedTo:self.view.superview animated:YES];
    } else {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    HUD.userInteractionEnabled = !touch;
    HUD.removeFromSuperViewOnHide = YES;
    //    HUD.yOffset = -10.0f;
    if (text) {
        HUD.mode = MBProgressHUDModeText;
        HUD.labelText = text;
    }
    if (img != -1) {
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[UIImageView alloc] initWithImage:(img) ? ([UIImage imageNamed:@"checkmark_success_white"]) : ([UIImage imageNamed:@"checkmark_failure_white"])];
    }
    if (delay != -1) {
        if (delay == 0) {
            [HUD hide:YES afterDelay:1];
        } else {
            [HUD hide:YES afterDelay:delay];
        }
    }
    [self setHUD:HUD];
}

- (void)hideHud {
    [[self HUD] hide:YES];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (void)viewWillDisappear:(BOOL)animated {
    //    [[self HUD] hide:YES];
}
#pragma clang diagnostic pop
//
- (void)touchesBegan:(nonnull NSSet *)touches withEvent:(nullable UIEvent *)event {
    [self.view endEditing:YES];
}

/** 打个电话 */
- (void)callTelephone:(NSString *)link {
    UIWebView *callWebview = [[UIWebView alloc] init];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", link]];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [callWebview loadRequest:[NSURLRequest requestWithURL:url]];
        [self.view addSubview:callWebview];
    } else {
        [self showHUD:@"这打不了电话 😅" img:0 de:1.28];
    }
}

#pragma mark -  push 动画

#define kDuration 0.35 // 动画持续时间(秒)
/**
 *  push vc 带其他动画 具体效果自己看
 */
- (void)pushVc:(UIViewController *)vc animateType:(NSInteger)row {
    if (row < 4) {
        //UIView Animation
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:kDuration];
        [self.navigationController pushViewController:vc animated:NO];
        switch (row) {
            case 0:
                [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:YES];
                break;
            case 1:
                [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.navigationController.view cache:YES];
                break;
            case 2:
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:YES];
                break;
            case 3:
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:YES];
                break;
            default:
                break;
        }
        [UIView commitAnimations];
    } else {
        //core animation
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = kDuration;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.subtype = kCATransitionFromLeft;
        switch (row) {
            case 4:
                animation.type = kCATransitionReveal;
                break;
            case 5:
                animation.type = kCATransitionMoveIn;
                break;
            case 6:
                animation.type = @"cube";
                break;
            case 7:
                animation.type = @"suckEffect";
                break;
            case 8:
                animation.type = @"rippleEffect";
                break;
            case 9:
                animation.type = @"pageCurl";
                break;
            case 10:
                animation.type = @"pageUnCurl";
                break;
            case 11:
                animation.type = kCATransitionFade;
                break;
            case 12:
                animation.type = kCATransitionMoveIn;
                animation.subtype = kCATransitionFromTop;
                break;
            default:
                break;
        }

        [self.navigationController pushViewController:vc animated:NO];
        [[self.navigationController.view layer] addAnimation:animation forKey:@"animation"];
    }
}

@end
