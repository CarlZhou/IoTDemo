//
//  APIManager.m
//  DEMO Framework
//
//  Created by Zhou, Zian on 2015-02-17.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import "APIManager.h"
#import "CoreDataManager.h"

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
    NSDictionary *params = @{ @"sensor_ids" : [sensors componentsJoinedByString:@","],
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

- (void)parseSensorReadingsData:(NSArray *)sensorReadingsData Completion:(void(^)(NSArray *sensors, NSArray *readings))completion
{
    NSMutableArray *sensors = [NSMutableArray array];
    NSMutableArray *readings = [NSMutableArray array];
    [sensorReadingsData enumerateObjectsUsingBlock:^(NSDictionary *data, NSUInteger index, BOOL *stop){
        Sensor *sensor = [[CoreDataManager sharedManager] createNewSensorWithData:data[@"sensor"] Controller:nil SensorType:nil LastReading:nil];
        [sensors addObject:sensor];
        NSArray *sensorReadings = data[@"readings"];
        [sensorReadings enumerateObjectsUsingBlock:^(NSDictionary *readingData, NSUInteger index2, BOOL *stop2){
            [readings addObject:[[CoreDataManager sharedManager] createNewSensorReadingWithData:data]];
        }];
        if (index == sensorReadingsData.count-1)
        {
            if (completion)
                completion(sensors, readings);
        }
    }];
}

@end
