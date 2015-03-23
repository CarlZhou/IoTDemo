//
//  NSObject_Location.h
//  DEMO Framework
//
//  Created by tracyshi on 2015-02-26.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FilterTableViewController.h"

@interface Location : NSObject<FilterOption>

@property (nonatomic, strong) NSNumber * l_id;
@property (nonatomic, strong) NSString * l_name;
@property (nonatomic, strong) NSString * l_description;
@property (nonatomic, strong) NSDate * l_last_updated;

- (NSNumber *)filterId;
- (NSString *)filterName;

@end