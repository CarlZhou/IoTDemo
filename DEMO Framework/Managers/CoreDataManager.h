//
//  CoreDataManager.h
//  DEMO Framework
//
//  Created by Zhou, Zian on 2015-02-17.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Controller;
@class Sensor;
@class SensorType;
@class SensorReading;

@interface CoreDataManager : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

+ (instancetype)sharedManager;

// Core Data
- (NSEntityDescription *)getEntityForName:(NSString *)name;
// Core Data fetch
- (void)fetchDataWithEntityName:(NSString *)entityName Discriptors:(NSArray *)discriptors Completion:(void(^)(NSArray *))completion;

// Sensor
- (void)createNewSensorsWithData:(NSArray *)sensorData completion:(void(^)())completion;
- (Sensor *)createNewSensorWithData:(NSDictionary *)data Controller:(Controller *)controller SensorType:(SensorType *)type LastReading:(SensorReading *)reading;

// Sensor Readings
- (void)createNewSensorReadingsWithData:(NSArray *)sensorReadingsData completion:(void(^)())completion;
- (SensorReading *)createNewSensorReadingWithData:(NSDictionary *)data;

// test
- (void)addMockupData;
- (void)clearMockupData;

@end
