//
//  APIManager.m
//  DEMO Framework
//
//  Created by Zhou, Zian on 2015-02-17.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import "APIManager.h"
#import "DataManager.h"

#define BASE_URL @"https://xshackerlounge.us1.hana.ondemand.com/DemoFramework"
#define API_PATH(path) [BASE_URL stringByAppendingString:path]

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
                            success:(void(^)(NSArray *sensors, NSArray *readings))success
                            failure:(void (^)(AFHTTPRequestOperation *operation))failure
{
    NSDictionary *params = @{ @"sensor_ids" : (sensors ? [sensors componentsJoinedByString:@","] : @""),
                              @"limit" : [NSNumber numberWithInteger:limit],
                              @"skip" : [NSNumber numberWithInteger:skip] };
    
    // Need to do an anonymous user connection
    [self.requestSerializer setValue:@"Basic STg0Nzg4NTpCbGFjazkyMDQxNyE=" forHTTPHeaderField:@"Authorization"];
    
    [self GET:API_PATH(@"/sensor_readings.xsjs")
   parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"%@", responseObject);
          if (responseObject && responseObject[@"meta"] && [responseObject[@"meta"][@"status_code"]  isEqual: @200])
          {
              [self parseSensorReadingsData:responseObject[@"sensors"] Completion:^(NSArray *sensors, NSArray *readings){
                  if (success)
                      success(sensors, readings);
              }];
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure)
              failure(operation);
      }];
}

#pragma mark - Sensors
- (void)getSensors:(NSArray *)sensorIds
           Details:(BOOL)showDetails
       LastReading:(BOOL)showLastReading
             Limit:(NSUInteger)limit
              Skip:(NSUInteger)skip   // offset
           success:(void(^)(NSArray *sensors))success
           failure:(void (^)(AFHTTPRequestOperation *operation))failure
{

    
    NSDictionary *params = @{ @"sensor_ids" : (sensorIds ? [sensorIds componentsJoinedByString:@","] : @""),
                              @"details" : [NSString stringWithFormat: showDetails ? @"true" : @"false"],
                              @"last_reading" : [NSString stringWithFormat: showLastReading ? @"true" : @"false"],
                              @"limit" : [NSNumber numberWithInteger:limit],
                              @"skip" : [NSNumber numberWithInteger:skip] };
    
    // Need to do an anonymous user connection
    [self.requestSerializer setValue:@"Basic STg0Nzg4NTpCbGFjazkyMDQxNyE=" forHTTPHeaderField:@"Authorization"];
    
    [self GET:API_PATH(@"/getsensor.xsjs")
   parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"%@", responseObject);
          if (responseObject && responseObject[@"meta"] && [responseObject[@"meta"][@"status_code"]  isEqual: @200]) {
              [self parseSensorsData:responseObject[@"sensors"] Details:showDetails LastReading:showLastReading Completion:^(NSArray *sensors) {
                  if (success)
                      success(sensors);
              }];
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure)
              failure(operation);
      }];
}

- (void)parseSensorsData:(NSArray *)responseObjectSensors Details:(BOOL)showDetails LastReading:(BOOL)showLastReading  Completion:(void(^)(NSArray *sensors))completion
{
    NSMutableArray *sensors = [NSMutableArray array];
    [responseObjectSensors enumerateObjectsUsingBlock:^(NSDictionary *data, NSUInteger index, BOOL *stop){
        Controller *controller = nil;
        SensorTypeCategory *sensorTypeCategory = nil;
        SensorType *sensorType = nil;
        SensorReading *lastReading = nil;
        Sensor *sensor = nil;
        if (showDetails) {
            controller = [[DataManager sharedManager] createNewControllerWithData:data[@"controller"]];
            sensorTypeCategory = [[DataManager sharedManager] createNewSensorTypeCategoryWithData:data[@"sensor_type"][@"sensor_type_category"]];
            sensorType = [[DataManager sharedManager] createNewSensorTypeWithData:data[@"sensor_type"] STC:sensorTypeCategory];
        }
        if (showLastReading) {
            if (![data[@"last_reading"][@"id"] isKindOfClass:[NSNull class]]) {
                lastReading = [[DataManager sharedManager] createNewSensorReadingWithData:data[@"last_reading"][@"sensor_reading"]];
            }
        }
        sensor = [[DataManager sharedManager] createNewSensorWithData:data Controller:controller SensorType:sensorType LastReading:lastReading];
        [sensors addObject:sensor];
        if (completion)
            completion(sensors);
    }];
}

- (void)parseSensorReadingsData:(NSArray *)sensorReadingsData Completion:(void(^)(NSArray *sensors, NSArray *readings))completion
{
    NSMutableArray *sensors = [NSMutableArray array];
    NSMutableArray *readings = [NSMutableArray array];
    [sensorReadingsData enumerateObjectsUsingBlock:^(NSDictionary *data, NSUInteger index, BOOL *stop){
        Sensor *sensor = [[DataManager sharedManager] createNewSensorWithData:data[@"sensor"] Controller:nil SensorType:nil LastReading:nil];
        [sensors addObject:sensor];
        NSArray *sensorReadings = data[@"readings"];
        [sensorReadings enumerateObjectsUsingBlock:^(NSDictionary *readingData, NSUInteger index2, BOOL *stop2){
            [readings addObject:[[DataManager sharedManager] createNewSensorReadingWithData:readingData]];
        }];
        if (index == sensorReadingsData.count-1)
        {
            if (completion)
                completion(sensors, readings);
        }
    }];
}

@end
