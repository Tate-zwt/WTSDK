//
//  NSDate+WT.m
//  WTSDK
//
//  Created by 张威庭 on 15/12/16.
//  Copyright © 2015年 zwt. All rights reserved.
//

#import "NSDate+WT.h"

@implementation NSDate (WT)

/**
 *  判断某个时间是否为今年
 */
- (BOOL)isThisYear {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 获得某个时间的年月日时分秒
    NSDateComponents *dateCmps = [calendar components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *nowCmps = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    return dateCmps.year == nowCmps.year;
}

/**
 *  判断某个时间是否为昨天
 */
- (BOOL)isYesterday {
    NSDate *now = [NSDate date];

    // date ==  2014-04-30 10:05:28 --> 2014-04-30 00:00:00
    // now == 2014-05-01 09:22:10 --> 2014-05-01 00:00:00
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";

    // 2014-04-30
    NSString *dateStr = [fmt stringFromDate:self];
    // 2014-10-18
    NSString *nowStr = [fmt stringFromDate:now];

    // 2014-10-30 00:00:00
    NSDate *date = [fmt dateFromString:dateStr];
    // 2014-10-18 00:00:00
    now = [fmt dateFromString:nowStr];

    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmps = [calendar components:unit fromDate:date toDate:now options:0];

    return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;
}

/**
 *  判断某个时间是否为今天
 */
- (BOOL)isToday {
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";

    NSString *dateStr = [fmt stringFromDate:self];
    NSString *nowStr = [fmt stringFromDate:now];

    return [dateStr isEqualToString:nowStr];
}

/** 字符时间戳 */
- (NSString *)timeStampStr {
    return [@([self timeIntervalSince1970]).stringValue copy];
}
/**
 *  长型时间戳
 */
- (double)timeStamp{
    return [self timeIntervalSince1970];
}

/*
 *  时间成分
 */
- (NSDateComponents *)components {
    //创建日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //定义成分
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:self];
}

- (BOOL)calWithValue:(NSInteger)value {

    //得到给定时间的处理后的时间的components
    NSDateComponents *dateComponents = self.ymdDate.components;

    //得到当前时间的处理后的时间的components
    NSDateComponents *nowComponents = [NSDate date].ymdDate.components;

    //比较
    BOOL res = dateComponents.year == nowComponents.year && dateComponents.month == nowComponents.month && (dateComponents.day + value) == nowComponents.day;

    return res;
}

/*
 *  清空时分秒，保留年月日
 */
- (NSDate *)ymdDate {

    //定义fmt
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];

    //设置格式:去除时分秒
    fmt.dateFormat = @"yyyy-MM-dd";

    //得到字符串格式的时间
    NSString *dateString = [fmt stringFromDate:self];

    //再转为date
    NSDate *date = [fmt dateFromString:dateString];

    return date;
}

/**
 *  两个时间比较
 *
 *  @param unit     成分单元
 *  @param fromDate 起点时间
 *  @param toDate   终点时间
 *
 *  @return 时间成分对象
 */
+ (NSDateComponents *)dateComponents:(NSCalendarUnit)unit fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {

    //创建日历
    NSCalendar *calendar = [NSCalendar currentCalendar];

    //直接计算
    NSDateComponents *components = [calendar components:unit fromDate:fromDate toDate:toDate options:0];

    return components;
}

/**
 *@Description:根据年份、月份、日期、小时数、分钟数、秒数返回NSDate
 *@Params:
 *  year:年份
 *  month:月份
 *  day:日期
 *  hour:小时数
 *  minute:分钟数
 *  second:秒数
 *  @return:
 */
+ (NSDate *)dateWithYear:(NSUInteger)year
                   Month:(NSUInteger)month
                     Day:(NSUInteger)day
                    Hour:(NSUInteger)hour
                  Minute:(NSUInteger)minute
                  Second:(NSUInteger)second {
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date]];
    dateComponents.year = year;
    dateComponents.month = month;
    dateComponents.day = day;
    dateComponents.hour = hour;
    dateComponents.minute = minute;
    dateComponents.second = second;

    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
}

/**
 *@Description:实现dateFormatter单例方法
 *@Params:nil
 *Return:相应格式的NSDataFormatter对象
 */
+ (NSDateFormatter *)defaultDateFormatterWithFormatYYYYMMddHHmmss {
    static NSDateFormatter *staticDateFormatterWithFormatYYYYMMddHHmmss;
    if (!staticDateFormatterWithFormatYYYYMMddHHmmss) {
        staticDateFormatterWithFormatYYYYMMddHHmmss = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatYYYYMMddHHmmss setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    }

    return staticDateFormatterWithFormatYYYYMMddHHmmss;
}

+ (NSDateFormatter *)defaultDateFormatterWithFormatYYYYMMdd {
    static NSDateFormatter *staticDateFormatterWithFormatYYYYMMddHHmmss;
    if (!staticDateFormatterWithFormatYYYYMMddHHmmss) {
        staticDateFormatterWithFormatYYYYMMddHHmmss = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatYYYYMMddHHmmss setDateFormat:@"YYYY.MM.dd"];
    }

    return staticDateFormatterWithFormatYYYYMMddHHmmss;
}

+ (NSDateFormatter *)defaultDateFormatterWithFormatYYYYMMdd__ {
    static NSDateFormatter *staticDateFormatterWithFormatYYYYMMddHHmmss__;
    if (!staticDateFormatterWithFormatYYYYMMddHHmmss__) {
        staticDateFormatterWithFormatYYYYMMddHHmmss__ = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatYYYYMMddHHmmss__ setDateFormat:@"YYYY-MM-dd"];
    }

    return staticDateFormatterWithFormatYYYYMMddHHmmss__;
}

+ (NSDateFormatter *)defaultDateFormatterWithFormatMMddHHmm {
    static NSDateFormatter *staticDateFormatterWithFormatMMddHHmm;
    if (!staticDateFormatterWithFormatMMddHHmm) {
        staticDateFormatterWithFormatMMddHHmm = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatMMddHHmm setDateFormat:@"MM-dd HH:mm"];
    }

    return staticDateFormatterWithFormatMMddHHmm;
}

+ (NSDateFormatter *)defaultDateFormatterWithFormatHHmm {
    static NSDateFormatter *staticDateFormatterWithFormatHHmm;
    if (!staticDateFormatterWithFormatHHmm) {
        staticDateFormatterWithFormatHHmm = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatHHmm setDateFormat:@"HH:mm"];
    }

    return staticDateFormatterWithFormatHHmm;
}

+ (NSDateFormatter *)defaultDateFormatterWithFormatYYYYMMddHHmmInChinese {
    static NSDateFormatter *staticDateFormatterWithFormatYYYYMMddHHmmssInChines;
    if (!staticDateFormatterWithFormatYYYYMMddHHmmssInChines) {
        staticDateFormatterWithFormatYYYYMMddHHmmssInChines = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatYYYYMMddHHmmssInChines setDateFormat:@"YYYY年MM月dd日 HH:mm"];
    }

    return staticDateFormatterWithFormatYYYYMMddHHmmssInChines;
}

+ (NSDateFormatter *)defaultDateFormatterWithFormatMMddHHmmInChinese {
    static NSDateFormatter *staticDateFormatterWithFormatMMddHHmmInChinese;
    if (!staticDateFormatterWithFormatMMddHHmmInChinese) {
        staticDateFormatterWithFormatMMddHHmmInChinese = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatMMddHHmmInChinese setDateFormat:@"MM月dd日 HH:mm"];
    }

    return staticDateFormatterWithFormatMMddHHmmInChinese;
}

/**********************************************************
 *@Description:获取当天的包括“年”，“月”，“日”，“周”，“时”，“分”，“秒”的NSDateComponents
 *@Params:nil
 *@Return:当天的包括“年”，“月”，“日”，“周”，“时”，“分”，“秒”的NSDateComponents
 ***********************************************************/
- (NSDateComponents *)componentsOfDay {
    return [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
}

//  --------------------------NSDate---------------------------
/****************************************************
 *@Description:获得NSDate对应的年份
 *@Params:nil
 *@Return:NSDate对应的年份
 ****************************************************/
- (NSUInteger)year {
    return [self componentsOfDay].year;
}

/****************************************************
 *@Description:获得NSDate对应的月份
 *@Params:nil
 *@Return:NSDate对应的月份
 ****************************************************/
- (NSUInteger)month {
    return [self componentsOfDay].month;
}

/****************************************************
 *@Description:获得NSDate对应的日期
 *@Params:nil
 *@Return:NSDate对应的日期
 ****************************************************/
- (NSUInteger)day {
    return [self componentsOfDay].day;
}

/****************************************************
 *@Description:获得NSDate对应的小时数
 *@Params:nil
 *@Return:NSDate对应的小时数
 ****************************************************/
- (NSUInteger)hour {
    return [self componentsOfDay].hour;
}

/****************************************************
 *@Description:获得NSDate对应的分钟数
 *@Params:nil
 *@Return:NSDate对应的分钟数
 ****************************************************/
- (NSUInteger)minute {
    return [self componentsOfDay].minute;
}

/****************************************************
 *@Description:获得NSDate对应的秒数
 *@Params:nil
 *@Return:NSDate对应的秒数
 ****************************************************/
- (NSUInteger)second {
    return [self componentsOfDay].second;
}

/****************************************************
 *@Description:获得NSDate对应的星期
 *@Params:nil
 *@Return:NSDate对应的星期
 ****************************************************/
- (NSUInteger)weekday {
    return [self componentsOfDay].weekday;
}

/******************************************
 *@Description:获取当天是当年的第几周
 *@Params:nil
 *@Return:当天是当年的第几周
 ******************************************/
- (NSUInteger)weekOfDayInYear {
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitWeekOfYear inUnit:NSCalendarUnitYear forDate:self];
}

/****************************************************
 *@Description:获得一般当天的工作开始时间
 *@Params:nil
 *@Return:一般当天的工作开始时间
 ****************************************************/
- (NSDate *)workBeginTime {
    unsigned int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:flags fromDate:self];
    [components setHour:9];
    [components setMinute:30];
    [components setSecond:0];

    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

/****************************************************
 *@Description:获得一般当天的工作结束时间
 *@Params:nil
 *@Return:一般当天的工作结束时间
 ****************************************************/
- (NSDate *)workEndTime {
    unsigned int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:flags fromDate:self];
    [components setHour:18];
    [components setMinute:0];
    [components setSecond:0];

    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

/****************************************************
 *@Description:获取一小时后的时间
 *@Params:nil
 *@Return:一小时后的时间
 ****************************************************/
- (NSDate *)oneHourLater {
    return [NSDate dateWithTimeInterval:3600 sinceDate:self];
}

/****************************************************
 *@Description:获得某一天的这个时刻
 *@Params:nil
 *@Return:某一天的这个时刻
 ****************************************************/
- (NSDate *)sameTimeOfDate {
    unsigned int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:flags fromDate:self];
    [components setHour:[[NSDate date] hour]];
    [components setMinute:[[NSDate date] minute]];
    [components setSecond:[[NSDate date] second]];

    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

/******************************************
 *@Description:判断与某一天是否为同一天
 *@Params:
 *  otherDate:某一天
 *@Return:YES-同一天；NO-不同一天
 ******************************************/
- (BOOL)sameDayWithDate:(NSDate *)otherDate {
    if (self.year == otherDate.year && self.month == otherDate.month && self.day == otherDate.day) {
        return YES;
    } else {
        return NO;
    }
}

/******************************************
 *@Description:判断与某一天是否为同一周
 *@Params:
 *  otherDate:某一天
 *@Return:YES-同一周；NO-不同一周
 ******************************************/
- (BOOL)sameWeekWithDate:(NSDate *)otherDate {
    if (self.year == otherDate.year && self.month == otherDate.month && self.weekOfDayInYear == otherDate.weekOfDayInYear) {
        return YES;
    } else {
        return NO;
    }
}

/******************************************
 *@Description:判断与某一天是否为同一月
 *@Params:
 *  otherDate:某一天
 *@Return:YES-同一月；NO-不同一月
 ******************************************/
- (BOOL)sameMonthWithDate:(NSDate *)otherDate {
    if (self.year == otherDate.year && self.month == otherDate.month) {
        return YES;
    } else {
        return NO;
    }
}

/** 多久以前呢 ？ 1分钟内 X分钟前 X天前 */
- (NSString *)whatTimeAgo {
    if (self == nil) {
        return @"";
    }
    NSTimeInterval timeInterval = -[self timeIntervalSinceNow];
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"1分钟内"];
    } else if ((temp = timeInterval / 60) < 60) {
        result = [NSString stringWithFormat:@"%ld分钟前", temp];
    } else if ((temp = temp / 60) < 24) {
        result = [NSString stringWithFormat:@"%ld小时前", temp];
    } else if ((temp = temp / 24) < 30) {
        result = [NSString stringWithFormat:@"%ld天前", temp];
    } else if ((temp = temp / 30) < 12) {
        result = [NSString stringWithFormat:@"%ld个月前", temp];
    } else {
        temp = temp / 12;
        result = [NSString stringWithFormat:@"%ld年前", temp];
    }
    return result;
}

//凌晨(3：00—6：00) 早上(6：00—8：00) 上午(8：00—11：00) 中午(11：00—14：00) 下午(14：00—19：00) 晚上(19：00—24：00)  深夜0：00—3：00) JE准则
/** 前段时间日期的描述 上午？？ 星期二 下午？？ */
- (NSString *)whatTimeBefore {
    if (self == nil) {
        return @"";
    }
    NSDate *yesterday = [[NSDate date] dateByAddingTimeInterval:-(24 * 60 * 60)];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = /*NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitHour |NSCalendarUnitMinute | */ NSCalendarUnitDay;
    NSDateComponents *Compareday = [calendar components:unitFlags fromDate:self];
    NSDateComponents *Yesterday = [calendar components:unitFlags fromDate:yesterday];
    NSDateComponents *Today = [calendar components:unitFlags fromDate:[NSDate date]];

    NSDateFormatter *F_Mon_Day = [[NSDateFormatter alloc] init];
    [F_Mon_Day setDateFormat:@"MM-dd"];
    NSDateFormatter *F_H_M = [[NSDateFormatter alloc] init];
    [F_H_M setDateFormat:@"HH:mm"];
    NSString *S_H = [[F_H_M stringFromDate:self] substringWithRange:NSMakeRange(0, 2)];
    NSString *S_M = [[F_H_M stringFromDate:self] substringWithRange:NSMakeRange(3, 2)];
    NSString *sunormoon = @"";
    NSInteger Hour = [S_H integerValue];

    if (Hour >= 3 && Hour < 6) {
        sunormoon = @"凌晨";
    } else if (Hour >= 6 && Hour < 8) {
        sunormoon = @"早上";
    } else if (Hour >= 8 && Hour < 11) {
        sunormoon = @"上午";
    } else if (Hour >= 11 && Hour < 14) {
        sunormoon = @"中午";
    } else if (Hour >= 14 && Hour < 19) {
        sunormoon = @"下午";
    } else if (Hour >= 19 /*&& Hour < 23*/) {
        sunormoon = @"晚上";
    } else if (Hour >= 0 && Hour < 3) {
        sunormoon = @"深夜";
    }

    if (Hour > 12) {
        Hour = Hour - 12;
    }

    NSString *Mon_Day = [F_Mon_Day stringFromDate:self];
    NSString *Hou_Min = [NSString stringWithFormat:@"%@ %d:%@", sunormoon, (int) Hour, S_M];
    NSString *Week = [self whatDayTheWeek];
    NSTimeInterval oldtime = [self timeIntervalSince1970];
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];

    if ([[[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitYear fromDate:self] year] != [[[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]] year]) {
        [F_Mon_Day setDateFormat:@"YYYY-MM-dd"];
        Mon_Day = [F_Mon_Day stringFromDate:self];
    }

    if ([Today day] == [Compareday day]) {
        return [NSString stringWithFormat:@"%@", Hou_Min];
    }

    if ([Yesterday day] == [Compareday day]) {
        return [NSString stringWithFormat:@"昨天  %@", Hou_Min];
    }

    if ((nowTime - oldtime) / 60 / 60 / 24 >= 7) {
        return [NSString stringWithFormat:@"%@   %@", Mon_Day, Hou_Min];
    }

    if ((nowTime - oldtime) / 60 / 60 / 24 < 7) {
        return [NSString stringWithFormat:@"%@  %@", Week, Hou_Min];
    }

    return [NSString stringWithFormat:@"%@   %@", Mon_Day, Hou_Min];
}

/**
 *  今天星期几来着？
 */
- (NSString *)whatDayTheWeek {
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday fromDate:self];
    int weekday = (int) [componets weekday]; //a就是星期几，1代表星期日，2代表星期一，后面依次
    switch (weekday) {
        case 1:
            return @"星期日";
            break;
        case 2:
            return @"星期一";
            break;
        case 3:
            return @"星期二";
            break;
        case 4:
            return @"星期三";
            break;
        case 5:
            return @"星期四";
            break;
        case 6:
            return @"星期五";
            break;
        case 7:
            return @"星期六";
            break;

        default:
            break;
    }

    return @"";
}

/****************************************************
 *@Description:获取时间的字符串格式
 *@Params:nil
 *@Return:时间的字符串格式
 ****************************************************/
- (NSString *)WT_YYYYMMddHHmmss {
    return [[NSDate defaultDateFormatterWithFormatYYYYMMddHHmmss] stringFromDate:self];
}

- (NSString *)WT_YYYYMMdd {
    return [[NSDate defaultDateFormatterWithFormatYYYYMMdd] stringFromDate:self];
}
- (NSString *)WT_YYYYMMdd__ {
    return [[NSDate defaultDateFormatterWithFormatYYYYMMdd__] stringFromDate:self];
}
- (NSString *)MMddHHmm {
    return [[NSDate defaultDateFormatterWithFormatMMddHHmm] stringFromDate:self];
}

- (NSString *)WT_HHmm {
    return [[NSDate defaultDateFormatterWithFormatHHmm] stringFromDate:self];
}

- (NSString *)YYYYMMddHHmmInChinese {
    return [[NSDate defaultDateFormatterWithFormatYYYYMMddHHmmInChinese] stringFromDate:self];
}

- (NSString *)MMddHHmmInChinese {
    return [[NSDate defaultDateFormatterWithFormatMMddHHmmInChinese] stringFromDate:self];
}

@end
