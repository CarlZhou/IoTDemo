//
//  ParseManager.m
//  DEMO Framework
//
//  Created by carlzhou on 2/25/15.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import "ParseManager.h"
#import "Sensor.h"
#import "SensorType.h"
#import "SensorTypeCategory.h"
#import "SensorReading.h"
#import "Controller.h"
#import "Location.h"
#import "DataUtils.h"
#include <stdlib.h>
#import "APIManager.h"
#import "constants.h"

@implementation ParseManager

+ (instancetype)sharedManager {
    static ParseManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

#pragma mark - Location
- (Location *)createNewLocationWithData:(NSDictionary *)data
{
    Location *entity = [[Location alloc] init];
    entity.l_id = [DataUtils numberFromString:[data objectForKey:@"id"]];
    entity.l_name = [data objectForKey:@"name"];
    entity.l_description = [data objectForKey:@"description"];
    entity.l_last_updated = [DataUtils dateFromSQLDateString:[data objectForKey:@"last_updated"]];
    return entity;
}


#pragma mark - Controller
- (Controller *)createNewControllerWithData:(NSDictionary *)data Location:(Location *)location
{
    Controller *entity = [[Controller alloc] init];
    entity.c_id = [DataUtils numberFromString:[data objectForKey:@"id"]];
    entity.c_name = [data objectForKey:@"name"];
    entity.c_serial_num = [data objectForKey:@"serial_num"];
    entity.c_x_coordinate = [DataUtils numberFromString:[data objectForKey:@"x_coordinate"]];
    entity.c_y_coordinate = [DataUtils numberFromString:[data objectForKey:@"y_coordinate"]];
    entity.c_last_updated = [DataUtils dateFromSQLDateString:[data objectForKey:@"last_updated"]];
    entity.c_location = location;
    return entity;
}

#pragma mark - Sensor
- (void)createNewSensorsWithData:(NSArray *)sensorData Completion:(void(^)())completion
{
    [sensorData enumerateObjectsUsingBlock:^(NSDictionary *data, NSUInteger index, BOOL *stop){
        [self createNewSensorWithData:data Controller:nil SensorType:nil LastReading:nil];
        if (index == sensorData.count-1)
        {
            if (completion)
                completion();
        }
    }];
}

- (Sensor *)createNewSensorWithData:(NSDictionary *)data Controller:(Controller *)controller SensorType:(SensorType *)type LastReading:(SensorReading *)reading
{
    Sensor *entity = [[Sensor alloc] init];
    entity.s_id = [DataUtils numberFromString:[data objectForKey:@"id"]];
    entity.s_name = [data objectForKey:@"name"];
    entity.s_unit = [data objectForKey:@"unit"];
    entity.s_status = [DataUtils numberFromString:[data objectForKey:@"status"]];
    entity.s_channel = [DataUtils numberFromString:[data objectForKey:@"channel"]];
    entity.s_last_updated = [DataUtils dateFromSQLDateString:[data objectForKey:@"last_updated"]];
    entity.s_controller_id = [DataUtils numberFromString:[data objectForKey:@"controller_id"]];
    entity.s_sensor_type_id = [DataUtils numberFromString:[data objectForKey:@"sensor_type_id"]];
    entity.s_controller = controller;
    entity.s_sensor_type = type;
    entity.s_last_reading = reading;
    return entity;
}

#pragma mark - Sensor Type
- (SensorType *)createNewSensorTypeWithData:(NSDictionary *)data STC:(SensorTypeCategory *)stc
{
    SensorType *entity = [[SensorType alloc] init];
    entity.st_id = [DataUtils numberFromString:[data objectForKey:@"id"]];
    entity.st_name = [data objectForKey:@"name"];
    entity.st_type_description = [data objectForKey:@"description"];
    entity.st_model_num = [data objectForKey:@"model_num"];
    entity.st_reading_min = [DataUtils numberFromString:[data objectForKey:@"reading_min"]];
    entity.st_reading_max = [DataUtils numberFromString:[data objectForKey:@"reading_max"]];
    entity.st_last_updated = [DataUtils dateFromSQLDateString:[data objectForKey:@"last_updated"]];
    entity.st_sensor_type_category = stc;
    return entity;
}

#pragma mark - Sensor Type Category
- (SensorTypeCategory *)createNewSensorTypeCategoryWithData:(NSDictionary *)data
{
    SensorTypeCategory *entity = [[SensorTypeCategory alloc] init];
    entity.stc_id = [DataUtils numberFromString:[data objectForKey:@"id"]];
    entity.stc_name = [data objectForKey:@"name"];
    entity.stc_last_updated = [DataUtils dateFromSQLDateString:[data objectForKey:@"last_updated"]];
    return entity;
}

#pragma mark - Sensor Reading
- (void)createNewSensorReadingsWithData:(NSArray *)sensorReadingsData Completion:(void(^)())completion
{
    [sensorReadingsData enumerateObjectsUsingBlock:^(NSDictionary *data, NSUInteger index, BOOL *stop){
        NSArray *sensorReadings = data[@"readings"];
        [sensorReadings enumerateObjectsUsingBlock:^(NSDictionary *readingData, NSUInteger index2, BOOL *stop2){
            [self createNewSensorReadingWithDateString:data];
        }];
        if (index == sensorReadingsData.count-1)
        {
            if (completion)
                completion();
        }
    }];
}

- (SensorReading *)createNewSensorReadingWithDateString:(NSDictionary *)data
{
    SensorReading *entity = [[SensorReading alloc] init];
    entity.sr_reading = [DataUtils numberFromString:[data objectForKey:@"reading"]];
    entity.sr_read_time = [DataUtils dateFromSQLDateString:[data objectForKey:@"read_time"]];
    entity.sr_last_updated = [DataUtils dateFromSQLDateString:[data objectForKey:@"last_updated"]];
    entity.sr_sensor_id = [DataUtils numberFromString:[data objectForKey:@"sensor_id"]];
    return entity;
}

- (SensorReading *)createNewSensorReadingWithTimeInterval:(NSDictionary *)data
{
    SensorReading *entity = [[SensorReading alloc] init];
    entity.sr_reading = [DataUtils numberFromString:[data objectForKey:@"reading"]];
    NSNumber *readTime = [DataUtils numberFromString:[data objectForKey:@"read_time"]];
    entity.sr_read_time = [NSDate dateWithTimeIntervalSince1970:[readTime doubleValue]];
    entity.sr_last_updated = [DataUtils dateFromSQLDateString:[data objectForKey:@"last_updated"]];
    entity.sr_sensor_id = [DataUtils numberFromString:[data objectForKey:@"sensor_id"]];
    return entity;
}

#pragma mark - Parse Data
- (void)parseSensorsData:(NSArray *)responseObjectSensors Details:(BOOL)showDetails LastReading:(BOOL)showLastReading  Completion:(void(^)(NSArray *sensors))completion
{
    NSMutableArray *sensors = [NSMutableArray array];
    [responseObjectSensors enumerateObjectsUsingBlock:^(NSDictionary *data, NSUInteger index, BOOL *stop){
        Location *location = nil;
        Controller *controller = nil;
        SensorTypeCategory *sensorTypeCategory = nil;
        SensorType *sensorType = nil;
        SensorReading *lastReading = nil;
        Sensor *sensor = nil;
        if (showDetails) {
            location = [[ParseManager sharedManager] createNewLocationWithData:data[@"controller"][@"location"]];
            controller = [[ParseManager sharedManager] createNewControllerWithData:data[@"controller"] Location:location];
            sensorTypeCategory = [[ParseManager sharedManager] createNewSensorTypeCategoryWithData:data[@"sensor_type"][@"sensor_type_category"]];
            sensorType = [[ParseManager sharedManager] createNewSensorTypeWithData:data[@"sensor_type"] STC:sensorTypeCategory];
        }
        if (showLastReading) {
            if (![data[@"last_reading"][@"id"] isKindOfClass:[NSNull class]]) {
                lastReading = [[ParseManager sharedManager] createNewSensorReadingWithDateString:data[@"last_reading"][@"sensor_reading"]];
            }
        }
        sensor = [[ParseManager sharedManager] createNewSensorWithData:data Controller:controller SensorType:sensorType LastReading:lastReading];
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
        Sensor *sensor = [[ParseManager sharedManager] createNewSensorWithData:data[@"sensor"] Controller:nil SensorType:nil LastReading:nil];
        [sensors addObject:sensor];
        NSArray *sensorReadings = data[@"readings"];
        [sensorReadings enumerateObjectsUsingBlock:^(NSDictionary *readingData, NSUInteger index2, BOOL *stop2){
            [readings addObject:[[ParseManager sharedManager] createNewSensorReadingWithDateString:readingData]];
        }];
        if (index == sensorReadingsData.count-1)
        {
            if (completion)
                completion(sensors, readings);
        }
    }];
    if (sensorReadingsData.count == 0 && completion)
        completion(nil, nil);
}


@end
