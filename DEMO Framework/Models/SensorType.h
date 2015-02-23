//
//  SensorType.h
//  DEMO Framework
//
//  Created by carlzhou on 2/20/15.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SensorTypeCategory;

@interface SensorType : NSObject

@property (nonatomic, strong) NSNumber * st_id;
@property (nonatomic, strong) NSDate * st_last_updated;
@property (nonatomic, strong) NSString * st_model_num;
@property (nonatomic, strong) NSString * st_name;
@property (nonatomic, strong) NSNumber * st_reading_max;
@property (nonatomic, strong) NSNumber * st_reading_min;
@property (nonatomic, strong) NSString * st_type_description;
@property (nonatomic, strong) SensorTypeCategory *st_sensor_type_category;

@end
