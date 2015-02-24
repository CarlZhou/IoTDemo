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
#import "APIManager.h"
#import "Sensor.h"
#import "DataManager.h"
#import "constants.h"

@interface MasterViewController ()
{
    BOOL isInitCompleted;
    NSIndexPath *selectedIndexPath;
}

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
    self.rightViewController = (RightViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    [self.tableView registerNib:[UINib nibWithNibName:@"SensorTableViewCell" bundle:nil] forCellReuseIdentifier:@"SensorCell"];
    
    
    [[DataManager sharedManager] updateSensorsInfomation];
    [[DataManager sharedManager] startToUpdateSensorsInfoWithTimeInterval:5];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable) name:@"SENSOR_DATA_UPDATED" object:nil];
}

- (void)updateTable
{
    self.sensors = [DataManager sharedManager].sensors;
    [self.tableView reloadData];
    if (!isInitCompleted)
    {
        // Select the first row for the first time open
        selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        isInitCompleted = YES;
    }
    else
    {
        [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

#pragma mark - Segues

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedIndexPath != indexPath)
    {
        selectedIndexPath = indexPath;
        [[NSNotificationCenter defaultCenter] postNotificationName:DID_SELECT_NEW_SENSOR object:nil];
    }
    NSManagedObject *object = [[self sensors] objectAtIndex:indexPath.row];
    RightViewController *controller = self.rightViewController;
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
