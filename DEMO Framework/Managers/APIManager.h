//
//  APIManager.h
//  DEMO Framework
//
//  Created by Zhou, Zian on 2015-02-17.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"

@interface APIManager : AFHTTPRequestOperationManager

+ (instancetype)sharedManager;

- (void)getSensorReadingsForSensors:(NSArray *)sensors
                              Limit:(NSUInteger)limit
                               Skip:(NSUInteger)skip
                            success:(void(^)(NSArray *sensors, NSArray *readings))success
                            failure:(void (^)(AFHTTPRequestOperation *operation))failure;

- (void)getSensors:(NSArray *)sensorIds
           Details:(BOOL)showDetails
       LastReading:(BOOL)showLastReading
             Limit:(NSUInteger)limit
              Skip:(NSUInteger)skip   // offset
           success:(void(^)(NSArray *sensors))success
           failure:(void (^)(AFHTTPRequestOperation *operation))failure;

@end
