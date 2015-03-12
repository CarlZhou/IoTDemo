//
//  CoreDataManager.h
//  DEMO Framework
//
//  Created by Zhou, Zian on 2015-02-17.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"

@class Sensor;

@interface DataManager : NSObject

+ (instancetype)sharedManager;

// test
- (NSArray *)addMockupData;
- (void)clearMockupData;

// Data
@property (nonatomic, strong) Sensor *selectedSensor;
@property (nonatomic, strong) NSIndexPath *selectedSensorIndexPath;
@property (nonatomic, strong) NSMutableArray *sensors;
@property (nonatomic, strong) NSMutableArray *sensorReadings;
@property (nonatomic, strong) NSMutableArray *recentReadingsOfSelectedSensor;
@property (nonatomic, strong) NSTimer *sensorsInfoUpdateTimer;
@property (nonatomic, strong) NSTimer *sensorReadingsInfoUpdateTimer;

// User Defaults
@property (nonatomic, strong) NSNumber *sensorUpdatingFrequency;
@property (nonatomic, strong) NSNumber *sensorReadingUpdatingFrequency;

// DataPoints
@property (nonatomic, strong) NSNumber *numberOfReadingPoints;

- (void)subscribeSelectedSensor;
- (void)unsubscribeSelectedSensor;
- (NSMutableArray*)getRecentReadingsOfSensor:(NSNumber*)sensorId;
- (void)updateSensorReadings:(NSArray*)newReadings;
- (void)updateSensorsInfomation;
- (void)startToUpdateSensorsInfoWithTimeInterval:(NSTimeInterval)interval;

// Methods for pulling readings from API with time interval
// Not used when using WebSocket
- (void)updateSensorReadingsInfomationWithCompletion:(void(^)())completion;
- (void)startToUpdateSensorReadingsInfoWithTimeInterval:(NSTimeInterval)interval;
- (void)stopUpdateSensorReadingsInfo;

@end
