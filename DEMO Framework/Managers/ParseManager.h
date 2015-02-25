//
//  ParseManager.h
//  DEMO Framework
//
//  Created by carlzhou on 2/25/15.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Controller;
@class Sensor;
@class SensorReading;
@class SensorType;
@class SensorTypeCategory;

@interface ParseManager : NSObject

+ (instancetype)sharedManager;

// Sensor
- (void)createNewSensorsWithData:(NSArray *)sensorData completion:(void(^)())completion;
- (Sensor *)createNewSensorWithData:(NSDictionary *)data Controller:(Controller *)controller SensorType:(SensorType *)type LastReading:(SensorReading *)reading;

// Sensor Readings
- (void)createNewSensorReadingsWithData:(NSArray *)sensorReadingsData completion:(void(^)())completion;
- (SensorReading *)createNewSensorReadingWithData:(NSDictionary *)data;

// Controller
- (Controller *)createNewControllerWithData:(NSDictionary *)data;

// Sensor Type
- (SensorType *)createNewSensorTypeWithData:(NSDictionary *)data STC:(SensorTypeCategory *)stc;

// Sensor Type Category
- (SensorTypeCategory *)createNewSensorTypeCategoryWithData:(NSDictionary *)data;

// Parse
- (void)parseSensorsData:(NSArray *)responseObjectSensors Details:(BOOL)showDetails LastReading:(BOOL)showLastReading  Completion:(void(^)(NSArray *sensors))completion;
- (void)parseSensorReadingsData:(NSArray *)sensorReadingsData Completion:(void(^)(NSArray *sensors, NSArray *readings))completion;

@end
