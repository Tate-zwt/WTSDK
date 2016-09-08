//
//  NSDate+WT.h
//  WTSDK
//
//  Created by 张威庭 on 15/12/16.
//  Copyright © 2015年 zwt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (WT)
/**
 *  判断某个时间是否为今年
 */
- (BOOL)isThisYear;
/**
 *  判断某个时间是否为昨天
 */
- (BOOL)isYesterday;
/**
 *  判断某个时间是否为今天
 */
- (BOOL)isToday;

/** 字符串时间戳。 */
@property (nonatomic, copy, readonly) NSString *timeStampStr;

/**
 *  长型时间戳
 */
@property (nonatomic, assign, readonly) double timeStamp;

/**
 *  时间成分
 */
@property (nonatomic, strong, readonly) NSDateComponents *components;

/**
 *  两个时间比较
 *
 *  @param unit     成分单元
 *  @param fromDate 起点时间
 *  @param toDate   终点时间
 *
 *  @return 时间成分对象
 */
+ (NSDateComponents *)dateComponents:(NSCalendarUnit)unit fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

/**
 *@Description:根据年份、月份、日期、小时数、分钟数、秒数返回NSDate
 *@Params:
 *  year:年份
 *  month:月份
 *  day:日期
 *  hour:小时数
 *  minute:分钟数
 *  second:秒数
 *@Return:
 */
+ (NSDate *)dateWithYear:(NSUInteger)year
                   Month:(NSUInteger)month
                     Day:(NSUInteger)day
                    Hour:(NSUInteger)hour
                  Minute:(NSUInteger)minute
                  Second:(NSUInteger)second;

/**
 *@Description:实现dateFormatter单例方法
 *@Params:nil
 *Return:相应格式的NSDataFormatter对象
 */
+ (NSDateFormatter *)defaultDateFormatterWithFormatYYYYMMddHHmmss;
+ (NSDateFormatter *)defaultDateFormatterWithFormatYYYYMMdd;
+ (NSDateFormatter *)defaultDateFormatterWithFormatMMddHHmm;

+ (NSDateFormatter *)defaultDateFormatterWithFormatYYYYMMddHHmmInChinese;
+ (NSDateFormatter *)defaultDateFormatterWithFormatMMddHHmmInChinese;

/**
 *@Description:获取当天的包括“年”，“月”，“日”，“周”，“时”，“分”，“秒”的NSDateComponents
 *@Params:nil
 *@Return:当天的包括“年”，“月”，“日”，“周”，“时”，“分”，“秒”的NSDateComponents
 */
- (NSDateComponents *)componentsOfDay;

/**
 *@Description:获得NSDate对应的年份
 *@Params:nil
 *@Return:NSDate对应的年份
 **/
- (NSUInteger)year;

/**
 *@Description:获得NSDate对应的月份
 *@Params:nil
 *@Return:NSDate对应的月份
 */
- (NSUInteger)month;

/**
 *@Description:获得NSDate对应的日期
 *@Params:nil
 *@Return:NSDate对应的日期
 */
- (NSUInteger)day;

/**
 *@Description:获得NSDate对应的小时数
 *@Params:nil
 *@Return:NSDate对应的小时数
 */
- (NSUInteger)hour;

/**
 *@Description:获得NSDate对应的分钟数
 *@Params:nil
 *@Return:NSDate对应的分钟数
 */
- (NSUInteger)minute;

/**
 *@Description:获得NSDate对应的秒数
 *@Params:nil
 *@Return:NSDate对应的秒数
 */
- (NSUInteger)second;

/**
 *@Description:获得NSDate对应的星期
 *@Params:nil
 *@Return:NSDate对应的星期
 */
- (NSUInteger)weekday;

/**
 *@Description:获取当天是当年的第几周
 *@Params:nil
 *@Return:当天是当年的第几周
 */
- (NSUInteger)weekOfDayInYear;

/**
 *@Description:获得一般当天的工作开始时间
 *@Params:nil
 *@Return:一般当天的工作开始时间
 */
- (NSDate *)workBeginTime;

/**
 *@Description:获得一般当天的工作结束时间
 *@Params:nil
 *@Return:一般当天的工作结束时间
 */
- (NSDate *)workEndTime;

/**
 *@Description:获取一小时后的时间
 *@Params:nil
 *@Return:一小时后的时间
 **/
- (NSDate *)oneHourLater;

/**
 *@Description:获得某一天的这个时刻
 *@Params:nil
 *@Return:某一天的这个时刻
 */
- (NSDate *)sameTimeOfDate;

/**
 *@Description:判断与某一天是否为同一天
 *@Params:
 *  otherDate:某一天
 *@Return:YES-同一天；NO-不同一天
 */
- (BOOL)sameDayWithDate:(NSDate *)otherDate;

/**
 *@Description:判断与某一天是否为同一周
 *@Params:
 *  otherDate:某一天
 *@Return:YES-同一周；NO-不同一周
 */
- (BOOL)sameWeekWithDate:(NSDate *)otherDate;

/**
 *@Description:判断与某一天是否为同一月
 *@Params:
 *  otherDate:某一天
 *@Return:YES-同一月；NO-不同一月
 */
- (BOOL)sameMonthWithDate:(NSDate *)otherDate;

/** 多久以前呢 ？ 1分钟内 X分钟前 X天前 */
- (NSString *)whatTimeAgo;

/** 前段时间日期的描述 上午？？ 星期二 下午？？ */
- (NSString *)whatTimeBefore;

/**
 *  今天星期几来着？
 */
- (NSString *)whatDayTheWeek;

/** YYYY-MM-dd HH:mm:ss */
- (NSString *)WT_YYYYMMddHHmmss;
/** YYYY.MM.dd */
- (NSString *)WT_YYYYMMdd;
/** YYYY-MM-dd */
- (NSString *)WT_YYYYMMdd__;
/** HH:mm */
- (NSString *)WT_HHmm;

- (NSString *)MMddHHmm;
- (NSString *)YYYYMMddHHmmInChinese;
- (NSString *)MMddHHmmInChinese;

@end
