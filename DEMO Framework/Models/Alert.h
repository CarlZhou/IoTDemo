//
//  Alert.h
//  DEMO Framework
//
//  Created by tracyshi on 2015-03-16.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Alert : NSObject

@property (nonatomic, strong) NSNumber * a_id;
@property (nonatomic, strong) NSString * a_type;
@property (nonatomic, strong) NSNumber * a_level;
@property (nonatomic, strong) NSString * a_message;
@property (nonatomic, strong) NSNumber * a_sensor_id;
@property (nonatomic, strong) NSNumber * a_threshold_min;
@property (nonatomic, strong) NSNumber * a_threshold_max;
@property (nonatomic, strong) NSString * a_action_command;
@property (nonatomic, strong) NSString * a_action_body;
@property (nonatomic, strong) NSString * a_alert_status;
@property (nonatomic, strong) NSDate * a_last_updated;

@end
