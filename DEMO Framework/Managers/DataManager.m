//
//  CoreDataManager.m
//  DEMO Framework
//
//  Created by Zhou, Zian on 2015-02-17.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import "DataManager.h"
#import "Sensor.h"
#import "SensorType.h"
#import "SensorTypeCategory.h"
#import "SensorReading.h"
#import "Controller.h"
#import "DataUtils.h"
#include <stdlib.h>

@implementation DataManager

+ (instancetype)sharedManager {
    static DataManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        sharedMyManager.sensors = [NSMutableArray array];
        sharedMyManager.sensorReadings = [NSMutableArray array];
    });
    return sharedMyManager;
}

#pragma mark - Controller
- (Controller *)createNewControllerWithData:(NSDictionary *)data
{
    Controller *entity = [[Controller alloc] init];
    entity.c_id = [DataUtils numberFromString:[data objectForKey:@"id"]];
    entity.c_name = [data objectForKey:@"name"];
    entity.c_x_coordinate = [DataUtils numberFromString:[data objectForKey:@"x_coordinate"]];
    entity.c_y_coordinate = [DataUtils numberFromString:[data objectForKey:@"y_coordinate"]];
    entity.c_last_updated = [DataUtils dateFromSQLDateString:[data objectForKey:@"last_updated"]];
//    [self saveContext];
    return entity;
}

#pragma mark - Sensor
- (void)createNewSensorsWithData:(NSArray *)sensorData completion:(void(^)())completion
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
    entity.s_serial_num = [data objectForKey:@"serial_num"];
    entity.s_last_updated = [DataUtils dateFromSQLDateString:[data objectForKey:@"last_updated"]];
    entity.s_controller_id = [DataUtils numberFromString:[data objectForKey:@"controller_id"]];
    entity.s_sensor_type_id = [DataUtils numberFromString:[data objectForKey:@"sensor_type_id"]];
    entity.s_controller = controller;
    entity.s_sensor_type = type;
    entity.s_last_reading = reading;
    NSLog(@"New sensor");
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
- (void)createNewSensorReadingsWithData:(NSArray *)sensorReadingsData completion:(void(^)())completion
{
    [sensorReadingsData enumerateObjectsUsingBlock:^(NSDictionary *data, NSUInteger index, BOOL *stop){
//        Sensor *sensor = [self createNewSensorWithData:data[@"sensor"] Controller:nil SensorType:nil LastReading:nil];
        NSArray *sensorReadings = data[@"readings"];
        [sensorReadings enumerateObjectsUsingBlock:^(NSDictionary *readingData, NSUInteger index2, BOOL *stop2){
            [self createNewSensorReadingWithData:data];
        }];
        if (index == sensorReadingsData.count-1)
        {
            if (completion)
                completion();
        }
    }];
}

- (SensorReading *)createNewSensorReadingWithData:(NSDictionary *)data
{
    SensorReading *entity = [[SensorReading alloc] init];
    entity.sr_reading = [DataUtils numberFromString:[data objectForKey:@"reading"]];
    entity.sr_read_time = [DataUtils dateFromSQLDateString:[data objectForKey:@"read_time"]];
    entity.sr_last_updated = [DataUtils dateFromSQLDateString:[data objectForKey:@"last_updated"]];
    entity.sr_sensor_id = [DataUtils numberFromString:[data objectForKey:@"sensor_id"]];
    return entity;
}

#pragma mark - Test
- (NSArray *)addMockupData
{
    NSDictionary *mockController = @{
                                 @"id" : @"1",
                                 @"name" : @"controller1",
                                 @"x_coordinate" : @"20",
                                 @"y_coordinate" : @"20",
                                 @"last_updated" : @"2015-02-20 16:58:20.8250000"
                                 };
    Controller *controller = [self createNewControllerWithData:mockController];
    
    NSDictionary *mockSTC = @{
                              @"id" : @"1",
                              @"name" : @"lightSensor",
                              @"last_updated" : @"2015-02-20 16:58:20.8250000"
                              };
    SensorTypeCategory *stc = [self createNewSensorTypeCategoryWithData:mockSTC];
    
    NSDictionary *mockSensorType = @{
                                     @"id" : @"1",
                                     @"name" : @"light1",
                                     @"description" : @"a light sensor",
                                     @"model_num" : @"A1",
                                     @"reading_min" : @"0",
                                     @"reading_max" : @"320",
                                     @"last_updated" : @"2015-02-20 16:58:20.8250000"
                                     };
    SensorType *sensorType = [self createNewSensorTypeWithData:mockSensorType STC:stc];
    
    NSDictionary *mockReading = @{
                                     @"reading" : @"55",
                                     @"read_time" : @"2015-02-20 16:58:20.8250000",
                                     @"last_updated" : @"2015-02-20 16:58:20.8250000",
                                     @"sensor_id" : @"1"
                                     };
    SensorReading *reading = [self createNewSensorReadingWithData:mockReading];
    
    NSDictionary *mockSensor = @{
                                 @"id" : @"1",
                                 @"name" : @"sensor1",
                                 @"unit" : @"lumi",
                                 @"status" : @"1",
                                 @"channel" : @"10",
                                 @"serial_num" : @"A12345",
                                 @"controller_id" : @"1",
                                 @"sensor_type_id" : @"1",
                                 @"last_updated" : @"2015-02-20 16:58:20.8250000"
                                 };
    NSDictionary *mockSensor2 = @{
                                 @"id" : @"2",
                                 @"name" : @"sensor2",
                                 @"unit" : @"lumi",
                                 @"status" : @"1",
                                 @"channel" : @"10",
                                 @"serial_num" : @"A12345",
                                 @"controller_id" : @"1",
                                 @"sensor_type_id" : @"1",
                                 @"last_updated" : @"2015-02-20 16:58:20.8250000"
                                 };
    Sensor *sensor = [self createNewSensorWithData:mockSensor Controller:controller SensorType:sensorType LastReading:reading];
    Sensor *sensor2 = [self createNewSensorWithData:mockSensor2 Controller:controller SensorType:sensorType LastReading:reading];
    
    return @[sensor, sensor2];
}

- (void)clearMockupData
{
    
}

@end
