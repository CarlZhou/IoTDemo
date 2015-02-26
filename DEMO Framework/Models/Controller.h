//
//  Controller.h
//  DEMO Framework
//
//  Created by carlzhou on 2/20/15.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Location;

@interface Controller : NSObject

@property (nonatomic, strong) NSNumber * c_id;
@property (nonatomic, strong) NSDate * c_last_updated;
@property (nonatomic, strong) NSString * c_serial_num;
@property (nonatomic, strong) NSString * c_name;
@property (nonatomic, strong) NSNumber * c_x_coordinate;
@property (nonatomic, strong) NSNumber * c_y_coordinate;
@property (nonatomic, strong) Location *c_location;

@end
