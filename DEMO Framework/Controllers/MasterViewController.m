//
//  MasterViewController.m
//  DEMO Framework
//
//  Created by Zhou, Zian on 2015-02-17.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import "MasterViewController.h"
#import "RightViewController.h"
#import "SensorTableViewCell.h"
#import "CoreDataManager.h"
#import "Sensor.h"

@interface MasterViewController ()

@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clearsSelectionOnViewWillAppear = NO;
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.sensors = [NSMutableArray array];
    
    self.detailViewController = (RightViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SensorTableViewCell" bundle:nil] forCellReuseIdentifier:@"SensorCell"];
    
    // Helpers
    __weak MasterViewController *weakSelf = self;
    
    // Initialize Fetch Request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Sensor"];
    
    // Add Sort Descriptors
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"s_id" ascending:YES]]];
    
    // Initialize Asynchronous Fetch Request
    NSAsynchronousFetchRequest *asynchronousFetchRequest = [[NSAsynchronousFetchRequest alloc] initWithFetchRequest:fetchRequest completionBlock:^(NSAsynchronousFetchResult *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // Process Asynchronous Fetch Result
            [weakSelf processAsynchronousFetchResult:result];
        });
    }];
    
    // Execute Asynchronous Fetch Request
    [[CoreDataManager sharedManager].managedObjectContext performBlock:^{
        // Execute Asynchronous Fetch Request
        NSError *asynchronousFetchRequestError = nil;
        [[CoreDataManager sharedManager].managedObjectContext executeRequest:asynchronousFetchRequest error:&asynchronousFetchRequestError];
        
        if (asynchronousFetchRequestError) {
            NSLog(@"Unable to execute asynchronous fetch result.");
            NSLog(@"%@, %@", asynchronousFetchRequestError, asynchronousFetchRequestError.localizedDescription);
        }
    }];
}

- (void)processAsynchronousFetchResult:(NSAsynchronousFetchResult *)asynchronousFetchResult {
    if (asynchronousFetchResult.finalResult) {
        // Update Items
        self.sensors = asynchronousFetchResult.finalResult.mutableCopy;
        NSLog(@"Fetched %lu items", (unsigned long)asynchronousFetchResult.finalResult.count);
        
        // Reload Table View
        [self.tableView reloadData];
    }
}

#pragma mark - Segues

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [[self sensors] objectAtIndex:indexPath.row];
    RightViewController *controller = self.detailViewController;
    [controller setDetailItem:object];
    controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    controller.navigationItem.leftItemsSupplementBackButton = YES;
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sensors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SensorCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Sensor *object = [self.sensors objectAtIndex:indexPath.row];
    SensorTableViewCell *stvc_cell = (SensorTableViewCell *)cell;
    [stvc_cell setCellWithSensor:object];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}
#pragma mark - Fetched results controller

@end
