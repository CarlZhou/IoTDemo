//
//  SensorReading.h
//  DEMO Framework
//
//  Created by Zhou, Zian on 2015-02-17.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SensorReading : NSManagedObject

@property (nonatomic, retain) NSNumber * sr_reading;
@property (nonatomic, retain) NSDate * sr_read_time;

@end
