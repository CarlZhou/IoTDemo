//
//  FilterTableViewController.h
//  DEMO Framework
//
//  Created by tracyshi on 2015-03-19.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterOption <NSObject>

@property (readonly) NSNumber *filterId;
@property (readonly) NSString *filterName;

@end

@protocol FilterTableViewDelegate <NSObject>

- (void)filterTableView:(id)filterTableView didUpdate:(NSDictionary *)filterOptions;

@end

@interface FilterTableViewController : UITableViewController

@property (nonatomic, weak) id<FilterTableViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *filterNames;  // Array of filter name strings
@property (nonatomic, strong) NSMutableDictionary *filterOptions;  // key: filter name, value: array of filter option strings
@property (nonatomic, strong) NSMutableDictionary *selectedFilterOptions;   // key: filter name, value: array of selected filter option strings

- (void)updateWithNewData;

@end
