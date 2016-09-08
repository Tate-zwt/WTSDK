//
//  NSTimer+WT.h
//  WTSDK
//
//  Created by 张威庭 on 15/12/16.
//  Copyright © 2015年 zwt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (WT)
//而scheduled的初始化方法将以默认mode直接添加到当前的runloop中.
+ (id)runTimer:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock rep:(BOOL)inRepeats;
//不用scheduled方式初始化的，需要手动addTimer:forMode: 将timer添加到一个runloop中。   [[NSRunLoop currentRunLoop]addTimer:he forMode:NSDefaultRunLoopMode];
+ (id)timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;

/**
 *  暂停
 */
- (void)pause;
/**
 *  继续
 */
- (void)goOn;
/**
 *  X秒后继续
 */
- (void)goOn:(NSTimeInterval)interval;
@end
