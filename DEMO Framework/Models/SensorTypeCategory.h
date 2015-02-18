//
//  SensorCategoryType.h
//  DEMO Framework
//
//  Created by Zhou, Zian on 2015-02-17.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SensorTypeCategory : NSManagedObject

@property (nonatomic, retain) NSNumber * stc_id;
@property (nonatomic, retain) NSString * stc_name;
@property (nonatomic, retain) NSDate * stc_last_updated;

@end
