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
#import "Sensor.h"
#import "Controller.h"
#import "APIManager.h"
#import "DataManager.h"
#import "WebSocketManager.h"
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
    
    self.sensors = [NSMutableArray array];
    self.groupedSensors = [NSMutableArray array];
    
    self.rightViewController = (RightViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    [self.tableView registerNib:[UINib nibWithNibName:@"SensorTableViewCell" bundle:nil] forCellReuseIdentifier:@"SensorCell"];
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{ NSForegroundColorAttributeName : RGB(110, 120, 127),
                               NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:20.0]}];
    
    [[DataManager sharedManager] updateSensorsInfomation];
    [[DataManager sharedManager] startToUpdateSensorsInfoWithTimeInterval:[[DataManager sharedManager].sensorUpdatingFrequency integerValue]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable) name:SENSOR_DATA_UPDATED object:nil];
}

- (void)updateTable
{
    self.sensors = [DataManager sharedManager].sensors;
    [self filterSensorsIntoSections:self.sensors];
    [self.tableView reloadData];
    if (!isInitCompleted)
    {
        // Select the first row for the first time open
        selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [DataManager sharedManager].selectedSensorIndexPath = selectedIndexPath;
        [self.tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        isInitCompleted = YES;
    }
    else
    {
        [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)filterSensorsIntoSections:(NSMutableArray*)sensors
{
    [self.groupedSensors removeAllObjects];
    if (sensors.count == 0) return;
    
    __block Controller *currentController = [[self.sensors objectAtIndex:0] s_controller];
    __block NSMutableArray *currentSectionOfSensors = [NSMutableArray array];
    
    [sensors enumerateObjectsUsingBlock:^(Sensor *sensor, NSUInteger idx, BOOL *stop) {
        if ([sensor.s_controller.c_id isEqualToNumber:currentController.c_id])
        {
            [currentSectionOfSensors addObject:sensor];
        }
        else
        {
            [self.groupedSensors addObject:currentSectionOfSensors];
            currentController = sensor.s_controller;
            currentSectionOfSensors = nil;
            currentSectionOfSensors = [NSMutableArray array];
            [currentSectionOfSensors addObject:sensor];
        }
        if (idx == sensors.count-1)
        {
            [self.groupedSensors addObject:currentSectionOfSensors];
        }
    }];
}

#pragma mark - Segues

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    
    if (selectedIndexPath != indexPath)
    {
        selectedIndexPath = indexPath;
        [DataManager sharedManager].selectedSensorIndexPath = selectedIndexPath;
        [[NSNotificationCenter defaultCenter] postNotificationName:DID_SELECT_NEW_SENSOR object:nil];
    }
    Sensor *sensor = [[self.groupedSensors objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    RightViewController *controller = self.rightViewController;
    [controller setDetailItem:sensor];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groupedSensors.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.sensors.count > 0)
    {
        Sensor *sensor = [[self.groupedSensors objectAtIndex:section] objectAtIndex:0];
        return sensor.s_controller.c_name;
    }
    else
    {
        return @"";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.groupedSensors objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SensorCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSArray *sensorsInSection = [self.groupedSensors objectAtIndex:indexPath.section];
    Sensor *sensor = [sensorsInSection objectAtIndex:indexPath.row];
    SensorTableViewCell *stvc_cell = (SensorTableViewCell *)cell;
    [stvc_cell setCellWithSensor:sensor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

@end
