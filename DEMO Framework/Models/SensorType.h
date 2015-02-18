//
//  SensorType.h
//  DEMO Framework
//
//  Created by Zhou, Zian on 2015-02-17.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SensorTypeCategory;

@interface SensorType : NSManagedObject

@property (nonatomic, retain) NSNumber * st_id;
@property (nonatomic, retain) NSString * st_name;
@property (nonatomic, retain) NSString * st_type_description;
@property (nonatomic, retain) NSString * st_model_num;
@property (nonatomic, retain) NSNumber * st_reading_min;
@property (nonatomic, retain) NSNumber * st_reading_max;
@property (nonatomic, retain) NSDate * st_last_updated;
@property (nonatomic, retain) SensorTypeCategory *st_sensor_type_category;

@end
