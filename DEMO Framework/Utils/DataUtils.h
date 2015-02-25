//
//  DataUtils.h
//  DEMO Framework
//
//  Created by carlzhou on 2/20/15.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataUtils : NSObject

+ (NSNumber *)numberFromString:(NSString *)string;
+ (NSDate *)dateFromSQLDateString:(NSString *)string;
+ (NSString *)dateStringFromDate:(NSDate *)date;

@end
