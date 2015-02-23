//
//  SensorReading.h
//  DEMO Framework
//
//  Created by carlzhou on 2/20/15.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SensorReading : NSObject

@property (nonatomic, strong) NSDate * sr_read_time;
@property (nonatomic, strong) NSNumber * sr_reading;
@property (nonatomic, strong) NSDate * sr_last_updated;
@property (nonatomic, strong) NSNumber *sr_sensor_id;

@end
