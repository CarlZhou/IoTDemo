//
//  CoreDataManager.h
//  DEMO Framework
//
//  Created by Zhou, Zian on 2015-02-17.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Controller;
@class Sensor;
@class SensorReading;
@class SensorType;
@class SensorTypeCategory;

@interface DataManager : NSObject

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

// test
- (NSArray *)addMockupData;
- (void)clearMockupData;

// Data
@property (nonatomic, strong) NSMutableArray *sensors;
@property (nonatomic, strong) NSTimer *sensorsInfoUpdateTimer;
@property (nonatomic, strong) Sensor *selectedSensor;
@property (nonatomic, strong) NSMutableArray *sensorReadings;
@property (nonatomic, strong) NSTimer *sensorReadingsInfoUpdateTimer;

- (void)updateSensorsInfomation;
- (void)startToUpdateSensorsInfoWithTimeInterval:(NSTimeInterval)interval;
- (void)updateSensorReadingsInfomationWithCompletion:(void(^)())completion;
- (void)startToUpdateSensorReadingsInfoWithTimeInterval:(NSTimeInterval)interval;

@end
