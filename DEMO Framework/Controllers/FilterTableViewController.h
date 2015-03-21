//
//  FilterTableViewController.h
//  DEMO Framework
//
//  Created by tracyshi on 2015-03-19.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *filters;
@property (nonatomic, strong) NSMutableDictionary *filterData;
@property (nonatomic, strong) NSMutableDictionary *selectedRows;

- (void)updateWithNewData;

@end
