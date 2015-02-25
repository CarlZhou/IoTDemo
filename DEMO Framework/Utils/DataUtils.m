//
//  DataUtils.m
//  DEMO Framework
//
//  Created by carlzhou on 2/20/15.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import "DataUtils.h"

@implementation DataUtils

+ (NSNumber *)numberFromString:(NSString *)string
{
    NSNumberFormatter *numFormat = [[NSNumberFormatter alloc] init];
    numFormat.formatterBehavior = NSNumberFormatterDecimalStyle;
    return [numFormat numberFromString:string];
}

+ (NSDate *)dateFromSQLDateString:(NSString *)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter dateFromString:[string substringToIndex:19]];
}

+ (NSString *)dateStringFromDate:(NSDate *)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.locale = [NSLocale systemLocale];
    df.timeZone = [NSTimeZone systemTimeZone];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *string = [df stringFromDate:date];
    
    NSLog(@"Date: %@", string);
    
    return string;
}

@end
