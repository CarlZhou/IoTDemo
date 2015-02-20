//
//  Controller.h
//  DEMO Framework
//
//  Created by carlzhou on 2/20/15.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Controller : NSManagedObject

@property (nonatomic, retain) NSNumber * c_id;
@property (nonatomic, retain) NSDate * c_last_updated;
@property (nonatomic, retain) NSString * c_name;
@property (nonatomic, retain) NSNumber * c_x_coordinate;
@property (nonatomic, retain) NSNumber * c_y_coordinate;

@end
