//
//  NSDate+WeekSpec.mm
//  NSDateCategoriesSpec
//
//  Created by Alexey Belkevich on 9/5/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Cedar/Cedar.h>
#import <OCFuntime/OCFuntime+Methods.h>
#import "NSDate+Week.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(NSDateWeekSpec)

describe(@"Date with week", ^
{
    __block NSDate *date;
    __block NSDateFormatter *formatter;
    __block OCFuntime *funtime;

    beforeEach(^
               {
                   formatter = [[NSDateFormatter alloc] init];
                   [formatter setDateFormat:@"dd-MM-y HH:mm:ss"];
                   date = [formatter dateFromString:@"01-08-2013 13:04:35"];
                   funtime = [[OCFuntime alloc] init];
               });

    afterEach(^
              {
                  [funtime revertAllMethods];
              });

    it(@"should get local week of month number", ^
    {
        date.weekOfMonth should equal(1);
    });

    it(@"should get local week of year number", ^
    {
        date.weekOfYear should equal(31);
    });

    it(@"should get local weekday", ^
    {
        date.weekday should equal(5);
    });

    it(@"should get local week start date without time", ^
    {
        NSString *dateWeekStart = [formatter stringFromDate:[date dateWeekStart]];
        NSString *checkDate = [NSCalendar currentCalendar].firstWeekday == 2 ?
                              @"29-07-2013 00:00:00" : @"28-07-2013 00:00:00";
        dateWeekStart should equal(checkDate);
    });

    it(@"should get local week end date without time", ^
    {
        NSString *dateWeekEnd = [formatter stringFromDate:[date dateWeekEnd]];
        NSString *checkDate = [NSCalendar currentCalendar].firstWeekday == 2 ?
                              @"04-08-2013 00:00:00" : @"03-08-2013 00:00:00";
        dateWeekEnd should equal(checkDate);
    });

    it(@"should get local date week ago", ^
    {
        NSString *dateWeekAgo = [formatter stringFromDate:[date dateWeekAgo]];
        dateWeekAgo should equal(@"25-07-2013 13:04:35");
    });

    it(@"should get local date week ahead", ^
    {
        NSString *dateWeekAhead = [formatter stringFromDate:[date dateWeekAhead]];
        dateWeekAhead should equal(@"08-08-2013 13:04:35");
    });

    it(@"should get local date with changed weekday if first weekday sunday ", ^
    {
        [funtime changeClass:NSCalendar.class classMethod:@selector(currentCalendar) implementation:^
        {
            NSCalendar *calendar = [[NSCalendar alloc]
                                                initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            calendar.firstWeekday = 1;
            return calendar;
        }];
        NSString *dateChanged = [formatter stringFromDate:[date dateBySettingWeekday:1]];
        dateChanged should equal(@"28-07-2013 13:04:35");
    });

    it(@"should get local date with changed weekday if first weekday monday ", ^
    {
        [funtime changeClass:NSCalendar.class classMethod:@selector(currentCalendar) implementation:^
        {
            NSCalendar *calendar = [[NSCalendar alloc]
                                                initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            calendar.firstWeekday = 2;
            return calendar;
        }];
        NSString *dateChanged = [formatter stringFromDate:[date dateBySettingWeekday:1]];
        dateChanged should equal(@"28-07-2013 13:04:35");
    });

    it(@"should get local date with changed week of year", ^
    {
        NSString *dateChanged = [formatter stringFromDate:[date dateBySettingWeekOfYear:2]];
        dateChanged should equal(@"10-01-2013 13:04:35");
    });

    it(@"should get local date with changed week of month", ^
    {
        NSString *dateChanged = [formatter stringFromDate:[date dateBySettingWeekOfMonth:3]];
        dateChanged should equal(@"15-08-2013 13:04:35");
    });

    it(@"should get local date with added week", ^
    {
        NSString *dateChanged = [formatter stringFromDate:[date dateByAddingWeek:1]];
        dateChanged should equal(@"08-08-2013 13:04:35");
    });

    it(@"should get local week start date without time for sunday in 'monday-start' calendar", ^
    {
        [funtime changeClass:NSCalendar.class classMethod:@selector(currentCalendar) implementation:^
        {
            NSCalendar *calendar = [[NSCalendar alloc]
                                                initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            calendar.firstWeekday = 2;
            return calendar;
        }];
        date = [formatter dateFromString:@"05-06-2016 19:26:44"]; // sunday
        NSString *dateWeekStart = [formatter stringFromDate:[date dateWeekStart]];
        NSString *checkDate = @"30-05-2016 00:00:00";
        dateWeekStart should equal(checkDate);
    });

    it(@"should get local week end date without time for sunday in 'monday-start' calendar", ^
    {
        [funtime changeClass:NSCalendar.class classMethod:@selector(currentCalendar) implementation:^
        {
            NSCalendar *calendar = [[NSCalendar alloc]
                                                initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            calendar.firstWeekday = 2;
            return calendar;
        }];
        date = [formatter dateFromString:@"04-06-2016 19:26:44"]; // sunday
        NSString *dateWeekEnd = [formatter stringFromDate:[date dateWeekEnd]];
        NSString *checkDate = @"05-06-2016 00:00:00";
        dateWeekEnd should equal(checkDate);
    });

    it(@"should get local week start date without time for thursday in 'sunday-start' calendar", ^
    {
        [funtime changeClass:NSCalendar.class classMethod:@selector(currentCalendar) implementation:^
        {
            NSCalendar *calendar = [[NSCalendar alloc]
                                                initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            calendar.firstWeekday = 1;
            return calendar;
        }];
        date = [formatter dateFromString:@"11-06-2016 19:26:44"]; // thursday
        NSString *dateWeekStart = [formatter stringFromDate:[date dateWeekStart]];
        NSString *checkDate = @"05-06-2016 00:00:00";
        dateWeekStart should equal(checkDate);
    });

    it(@"should get local week end date without time for thursday in 'sunday-start' calendar", ^
    {
        [funtime changeClass:NSCalendar.class classMethod:@selector(currentCalendar) implementation:^
        {
            NSCalendar *calendar = [[NSCalendar alloc]
                                                initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            calendar.firstWeekday = 1;
            return calendar;
        }];
        date = [formatter dateFromString:@"11-06-2016 19:26:44"]; // thursday
        NSString *dateWeekEnd = [formatter stringFromDate:[date dateWeekEnd]];
        NSString *checkDate = @"11-06-2016 00:00:00";
        dateWeekEnd should equal(checkDate);
    });

});

SPEC_END