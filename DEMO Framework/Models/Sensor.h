//
//  Sensor.h
//  DEMO Framework
//
//  Created by Zhou, Zian on 2015-02-17.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Controller, SensorReading, SensorType;

@interface Sensor : NSManagedObject

@property (nonatomic, retain) NSNumber * s_id;
@property (nonatomic, retain) NSString * s_name;
@property (nonatomic, retain) NSString * s_unit;
@property (nonatomic, retain) NSNumber * s_status;
@property (nonatomic, retain) NSNumber * s_channel;
@property (nonatomic, retain) NSString * s_serial_num;
@property (nonatomic, retain) NSDate * s_last_updated;
@property (nonatomic, retain) SensorType *s_sensor_type;
@property (nonatomic, retain) Controller *s_controller;
@property (nonatomic, retain) SensorReading *s_last_reading;

@end
