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
#import "Location.h"
#import "DataUtils.h"
#include <stdlib.h>
#import "APIManager.h"
#import "constants.h"
#import "ParseManager.h"
#import "WebSocketManager.h"

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

#pragma mark - Test
- (NSArray *)addMockupData
{
    NSDictionary *mockLocation = @{
                                     @"id" : @"1",
                                     @"name" : @"location1",
                                     @"description" : @"1st floor",
                                     @"last_updated" : @"2015-02-20 16:58:20.8250000"
                                     };
    Location *location = [[ParseManager sharedManager] createNewLocationWithData:mockLocation];
    
    NSDictionary *mockController = @{
                                 @"id" : @"1",
                                 @"name" : @"controller1",
                                 @"x_coordinate" : @"20",
                                 @"y_coordinate" : @"20",
                                 @"last_updated" : @"2015-02-20 16:58:20.8250000"
                                 };
    Controller *controller = [[ParseManager sharedManager] createNewControllerWithData:mockController Location:location];
    
    NSDictionary *mockSTC = @{
                              @"id" : @"1",
                              @"name" : @"lightSensor",
                              @"last_updated" : @"2015-02-20 16:58:20.8250000"
                              };
    SensorTypeCategory *stc = [[ParseManager sharedManager] createNewSensorTypeCategoryWithData:mockSTC];
    
    NSDictionary *mockSensorType = @{
                                     @"id" : @"1",
                                     @"name" : @"light1",
                                     @"description" : @"a light sensor",
                                     @"model_num" : @"A1",
                                     @"reading_min" : @"0",
                                     @"reading_max" : @"320",
                                     @"last_updated" : @"2015-02-20 16:58:20.8250000"
                                     };
    SensorType *sensorType = [[ParseManager sharedManager] createNewSensorTypeWithData:mockSensorType STC:stc];
    
    NSDictionary *mockReading = @{
                                     @"reading" : @"55",
                                     @"read_time" : @"2015-02-20 16:58:20.8250000",
                                     @"last_updated" : @"2015-02-20 16:58:20.8250000",
                                     @"sensor_id" : @"1"
                                     };
    SensorReading *reading = [[ParseManager sharedManager] createNewSensorReadingWithData:mockReading];
    
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
    Sensor *sensor = [[ParseManager sharedManager] createNewSensorWithData:mockSensor Controller:controller SensorType:sensorType LastReading:reading];
    Sensor *sensor2 = [[ParseManager sharedManager] createNewSensorWithData:mockSensor2 Controller:controller SensorType:sensorType LastReading:reading];
    
    return @[sensor, sensor2];
}

- (void)clearMockupData
{
    
}

- (void)subscribeSelectedSensor
{
    if ([WebSocketManager sharedManager].isSocketOpen)
        {
            [[WebSocketManager sharedManager] subscribeSensor:self.selectedSensor.s_id];
        }
    else
    {
        [[WebSocketManager sharedManager] addObserver:self forKeyPath:@"isSocketOpen" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isKindOfClass:[WebSocketManager class]] && [keyPath isEqualToString:@"isSocketOpen"]
        && [WebSocketManager sharedManager].isSocketOpen)
    {
        [[WebSocketManager sharedManager] removeObserver:self forKeyPath:@"isSocketOpen"];
        [self subscribeSelectedSensor];
    }
}

- (void)updateSensorsInfomation
{
    [[APIManager sharedManager] getSensors:nil Details:true LastReading:true Limit:10 Skip:0 Success:^(NSArray *sensors) {
        self.sensors = sensors.mutableCopy;
        if (self.selectedSensorIndexPath)
        {
            if (self.sensors.count > self.selectedSensorIndexPath.row)
                self.selectedSensor = [self.sensors objectAtIndex:self.selectedSensorIndexPath.row];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:SENSOR_DATA_UPDATED object:nil];
    } Failure:^(NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SENSOR_DATA_UPDATED_FAILED object:nil];
    }];
}

- (void)startToUpdateSensorsInfoWithTimeInterval:(NSTimeInterval)interval
{
    if (self.sensorsInfoUpdateTimer)
    {
        [self.sensorsInfoUpdateTimer invalidate];
        self.sensorsInfoUpdateTimer = nil;
    }
    
    self.sensorsInfoUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(updateSensorsInfomation) userInfo:nil repeats:YES];
}

- (void)updateSensorReadingsInfomationWithCompletion:(void(^)())completion
{
    if (self.selectedSensor)
    {
        [[APIManager sharedManager] getSensorReadingsForSensors:@[self.selectedSensor.s_id] Limit:self.numberOfReadingPoints ? [self.numberOfReadingPoints integerValue]: 10 Skip:0 Success:^(NSArray *sensors, NSArray *readings){
            
            self.sensorReadings = [readings mutableCopy];
            if (completion)
            {
                completion();
            }
            else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:SENSOR_READINGS_DATA_UPDATED object:nil];
            }
            
        }Failure:^(NSError *error){
        }];
    }
}

- (void)updateSensorReadingsInfoHelper
{
    [self updateSensorReadingsInfomationWithCompletion:nil];
}

- (void)startToUpdateSensorReadingsInfoWithTimeInterval:(NSTimeInterval)interval
{
    [self stopUpdateSensorReadingsInfo];
    
    self.sensorReadingsInfoUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(updateSensorReadingsInfoHelper) userInfo:nil repeats:YES];
}

- (void)stopUpdateSensorReadingsInfo
{
    if (self.sensorReadingsInfoUpdateTimer)
    {
        [self.sensorReadingsInfoUpdateTimer invalidate];
        self.sensorReadingsInfoUpdateTimer = nil;
    }
}

@end
