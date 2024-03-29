//
//  APIManager.m
//  DEMO Framework
//
//  Created by Zhou, Zian on 2015-02-17.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import "APIManager.h"
#import "DataManager.h"
#import "ParseManager.h"

#define BASE_URL @"https://xshackerlounge.us1.hana.ondemand.com/IoTFramework"
#define API_PATH(path) [BASE_URL stringByAppendingString:path]
#define GET_SENSOR_PATH API_PATH(@"/sensors.xsjs")
#define GET_SENSOR_READING_PATH API_PATH(@"/sensor_readings.xsjs")
#define GET_LOCATION_PATH API_PATH(@"/locations.xsjs")

@implementation APIManager

+ (instancetype)sharedManager
{
    static APIManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

#pragma mark - Sensor Readings
- (void)getSensorReadingsForSensors:(NSArray *)sensors
                              Limit:(NSUInteger)limit
                               Skip:(NSUInteger)skip
                            Success:(void(^)(NSArray *sensors, NSArray *readings))success
                            Failure:(void (^)(NSError *error))failure
{
    NSDictionary *params = @{ @"sensor_ids" : (sensors ? [sensors componentsJoinedByString:@","] : @""),
                              @"limit" : [NSNumber numberWithInteger:limit],
                              @"skip" : [NSNumber numberWithInteger:skip] };
    
    // Set account
    if (self.APIAuthorizationMethod && self.APIAuthorizationAccount && self.APIAuthorizationPassword)
    {
        [self.requestSerializer setValue:[NSString stringWithFormat:@"%@ %@", self.APIAuthorizationMethod, [[[NSString stringWithFormat:@"%@:%@", self.APIAuthorizationAccount, self.APIAuthorizationPassword] dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0]] forHTTPHeaderField:@"Authorization"];
    }
    
    [self GET:GET_SENSOR_READING_PATH
   parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          if (responseObject && responseObject[@"meta"] && [responseObject[@"meta"][@"status_code"]  isEqual: @200])
          {
              [[ParseManager sharedManager] parseSensorReadingsData:responseObject[@"sensors"] Completion:^(NSArray *sensors, NSArray *readings){
                  if (success)
                      success(sensors, readings);
              }];
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure)
              failure(error);
      }];
}

#pragma mark - Sensors
- (void)getSensors:(NSArray *)sensorIds
           Details:(BOOL)showDetails
       LastReading:(BOOL)showLastReading
           OrderBy:(NSArray *)orderBy
             Limit:(NSUInteger)limit
              Skip:(NSUInteger)skip   // offset
           Success:(void(^)(NSArray *sensors))success
           Failure:(void (^)(NSError *error))failure
{
    NSDictionary *params = @{ @"sensor_ids" : (sensorIds ? [sensorIds componentsJoinedByString:@","] : @""),
                              @"details" : [NSString stringWithFormat: showDetails ? @"true" : @"false"],
                              @"last_reading" : [NSString stringWithFormat: showLastReading ? @"true" : @"false"],
                              @"order_by" : (orderBy ? [orderBy componentsJoinedByString:@","] : @""),
                              @"limit" : limit ? [NSNumber numberWithInteger:limit] : @"",
                              @"skip" : skip ? [NSNumber numberWithInteger:skip] : @""};
    
//    [self.requestSerializer setValue:@"Basic STg0Nzg4NTpCbGFjazkyMDQxNyE=" forHTTPHeaderField:@"Authorization"];
    if (self.APIAuthorizationMethod && self.APIAuthorizationAccount && self.APIAuthorizationPassword)
    {
        [self.requestSerializer setValue:[NSString stringWithFormat:@"%@ %@", self.APIAuthorizationMethod, [[[NSString stringWithFormat:@"%@:%@", self.APIAuthorizationAccount, self.APIAuthorizationPassword] dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0]] forHTTPHeaderField:@"Authorization"];
    }
    
    [self GET:GET_SENSOR_PATH
   parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          if (responseObject && responseObject[@"meta"] && [responseObject[@"meta"][@"status_code"]  isEqual: @200]) {
              [[ParseManager sharedManager] parseSensorsData:responseObject[@"sensors"] Details:showDetails LastReading:showLastReading Completion:^(NSArray *sensors) {
                  if (success)
                      success(sensors);
              }];
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure)
              failure(error);
      }];
}

#pragma mark - Locations
- (void)getLocations:(NSArray *)ids
                Names:(NSArray *)names
           OrderBy:(NSArray *)orderBy
             Limit:(NSNumber*)limit
              Skip:(NSNumber*)skip   // offset
           Success:(void(^)(NSArray *sensors))success
           Failure:(void (^)(NSError *error))failure
{
    NSDictionary *params = @{ @"location_ids" : (ids ? [ids componentsJoinedByString:@","] : @""),
                              @"location_names" : (names ? [names componentsJoinedByString:@","] : @""),
                              @"order_by" : (orderBy ? [orderBy componentsJoinedByString:@","] : @""),
                              @"limit" : limit ? limit : @"",
                              @"skip" : skip ? skip : @""};
    
    //    [self.requestSerializer setValue:@"Basic STg0Nzg4NTpCbGFjazkyMDQxNyE=" forHTTPHeaderField:@"Authorization"];
    if (self.APIAuthorizationMethod && self.APIAuthorizationAccount && self.APIAuthorizationPassword)
    {
        [self.requestSerializer setValue:[NSString stringWithFormat:@"%@ %@", self.APIAuthorizationMethod, [[[NSString stringWithFormat:@"%@:%@", self.APIAuthorizationAccount, self.APIAuthorizationPassword] dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0]] forHTTPHeaderField:@"Authorization"];
    }
    
    [self GET:GET_LOCATION_PATH parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
          if (responseObject && responseObject[@"meta"] && [responseObject[@"meta"][@"status_code"]  isEqual: @200]) {
              [[ParseManager sharedManager] parseLocationsData:responseObject[@"locations"] Completion:^(NSArray *locations) {
                  if (success)
                      success(locations);
              }];
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure)
              failure(error);
      }];
}

@end
