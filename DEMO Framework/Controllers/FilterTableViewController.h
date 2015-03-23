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

@interface FilterTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *filterNames;  // Array of filter name strings
@property (nonatomic, strong) NSMutableDictionary *filterOptions;  // key: filter name, value: array of filter option strings
@property (nonatomic, strong) NSMutableDictionary *selectedFilterOptions;   // key: filter name, value: array of selected filter option strings

- (void)updateWithNewData;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *selectAllButtonItem;
- (IBAction)selectAllButtonTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *clearAllButtonItem;
- (IBAction)clearAllButtonTapped:(id)sender;

@end
