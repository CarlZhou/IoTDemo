//
//  SensorTypeCategory.h
//  DEMO Framework
//
//  Created by carlzhou on 2/20/15.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SensorTypeCategory : NSObject

@property (nonatomic, strong) NSNumber * stc_id;
@property (nonatomic, strong) NSDate * stc_last_updated;
@property (nonatomic, strong) NSString * stc_name;

@end
