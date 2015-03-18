//
//  Sensor.h
//  DEMO Framework
//
//  Created by carlzhou on 2/20/15.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Controller, SensorReading, SensorType;

@interface Sensor : NSObject

@property (nonatomic, strong) NSNumber * s_channel;
@property (nonatomic, strong) NSNumber * s_controller_id;
@property (nonatomic, strong) NSNumber * s_id;
@property (nonatomic, strong) NSDate * s_last_updated;
@property (nonatomic, strong) NSString * s_name;
@property (nonatomic, strong) NSNumber * s_sensor_type_id;
@property (nonatomic, strong) NSNumber * s_status;
@property (nonatomic, strong) Controller *s_controller;
@property (nonatomic, strong) SensorReading *s_last_reading;
@property (nonatomic, strong) SensorType *s_sensor_type;

@end
