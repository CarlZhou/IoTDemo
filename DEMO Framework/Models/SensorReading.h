//
//  SensorReading.h
//  DEMO Framework
//
//  Created by carlzhou on 2/20/15.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface SensorReading : NSManagedObject

@property (nonatomic, retain) NSDate * sr_read_time;
@property (nonatomic, retain) NSNumber * sr_reading;
@property (nonatomic, retain) NSDate * sr_last_updated;
@property (nonatomic, retain) NSNumber *sr_sensor_id;

@end
