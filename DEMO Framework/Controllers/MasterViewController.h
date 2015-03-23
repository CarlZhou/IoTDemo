//
//  MasterViewController.h
//  DEMO Framework
//
//  Created by Zhou, Zian on 2015-02-17.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class RightViewController;

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) RightViewController *rightViewController;
@property (strong, nonatomic) NSMutableArray *sensors;
@property (strong, nonatomic) NSMutableArray *filteredSensors;
@property (strong, nonatomic) NSMutableArray *groupedSensors;
@property (strong, nonatomic) NSDictionary *selectedFilterOptions;
@property (strong, nonatomic) UITableView *filterTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *filterButtonItem;

- (IBAction)filterButtonTapped:(id)sender;

@end

