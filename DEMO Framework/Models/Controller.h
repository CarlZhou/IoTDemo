//
//  Controller.h
//  DEMO Framework
//
//  Created by Zhou, Zian on 2015-02-17.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Controller : NSManagedObject

@property (nonatomic, retain) NSNumber * c_id;
@property (nonatomic, retain) NSString * c_name;
@property (nonatomic, retain) NSNumber * c_x_coordinate;
@property (nonatomic, retain) NSNumber * c_y_coordinate;
@property (nonatomic, retain) NSDate * c_last_updated;

@end
