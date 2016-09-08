//
//  CALayer+WT.m
//  WTSDK
//
//  Created by 张威庭 on 15/12/16.
//  Copyright © 2015年 zwt. All rights reserved.
//

#import "CALayer+WT.h"

@implementation CALayer (WT)

/**
 *  颤抖效果
 */
- (CAAnimation *)shakeFunction {
    CAKeyframeAnimation *shake = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    shake.values = @[ [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f)], [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f)] ];
    shake.autoreverses = YES;
    shake.repeatCount = 2.0f;
    shake.duration = 0.07f;
    [self addAnimation:shake forKey:nil];
    return shake;
}

/**
 *  渐显效果
 */
- (CATransition *)fadeFunction {
    return [self fadeFunction:0.4];
}

/**
 *  渐显效果 效果时间
 */
- (CATransition *)fadeFunction:(CGFloat)time {
    CATransition *animation = [CATransition animation];
    [animation setDuration:time];
    [animation setType:kCATransitionFade];
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [self addAnimation:animation forKey:nil];
    return animation;
}

/**
 *  缩放效果
 */
- (CAKeyframeAnimation *)transformScaleFunction {
    CAKeyframeAnimation *transformscale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    transformscale.values = @[ @(0), @(0.5), @(1.08) ];
    transformscale.keyTimes = @[ @(0.0), @(0.2), @(0.3) ];
    transformscale.calculationMode = kCAAnimationLinear;
    [self addAnimation:transformscale forKey:nil];
    return transformscale;
}

/**
 *  简3D动画吧
 */
- (CAAnimation *)anim_revers:(AnimReverDirection)direction duration:(NSTimeInterval)duration isReverse:(BOOL)isReverse repeatCount:(NSUInteger)repeatCount {
    NSString *key = @"reversAnim";
    if ([self animationForKey:key] != nil) {
        [self removeAnimationForKey:key];
    }
    NSString *directionStr = nil;
    if (AnimReverDirectionX == direction) directionStr = @"x";
    if (AnimReverDirectionY == direction) directionStr = @"y";
    if (AnimReverDirectionZ == direction) directionStr = @"z";
    //创建普通动画
    CABasicAnimation *reversAnim = [CABasicAnimation animationWithKeyPath:[NSString stringWithFormat:@"transform.rotation.%@", directionStr]];
    //起点值
    reversAnim.fromValue = @(0);
    //终点值
    reversAnim.toValue = @(M_PI_2);
    //时长
    reversAnim.duration = duration;
    //自动反转
    reversAnim.autoreverses = isReverse;
    //完成删除
    reversAnim.removedOnCompletion = YES;
    //重复次数
    reversAnim.repeatCount = repeatCount;
    //添加
    [self addAnimation:reversAnim forKey:key];

    return reversAnim;
}

@end
