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
                            Success:(void(^)(NSArray *sensors, NSArray *readings))success
                            Failure:(void (^)(NSError *operation))failure;

- (void)getSensors:(NSArray *)sensorIds
           Details:(BOOL)showDetails
       LastReading:(BOOL)showLastReading
             Limit:(NSUInteger)limit
              Skip:(NSUInteger)skip   // offset
           Success:(void(^)(NSArray *sensors))success
           Failure:(void (^)(NSError *operation))failure;

// Authorization
@property (strong, nonatomic) NSString *APIAuthorizationMethod;
@property (strong, nonatomic) NSString *APIAuthorizationAccount;
@property (strong, nonatomic) NSString *APIAuthorizationPassword;

@end
