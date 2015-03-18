//
//  DetailsViewController.m
//  DEMO Framework
//
//  Created by carlzhou on 2/19/15.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import "DetailsViewController.h"
#import "CircularBarView.h"
#import "Sensor.h"
#import "SensorReading.h"
#import "SensorType.h"
#import "SensorTypeCategory.h"
#import "Controller.h"
#import "Location.h"
#import "Constants.h"
#import "WMGaugeView.h"
#import "APIManager.h"
#import "DataManager.h"
#import "DataUtils.h"
#import "MBProgressHUD.h"

#define DISPLAYED_PROPERTIES_NUM 10

@interface DetailsViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    
}

@property (strong, nonatomic) IBOutlet UIView *propertiesViewContainer;
@property (strong, nonatomic) IBOutlet UIView *readingViewContainer;
@property (strong, nonatomic) IBOutlet UIView *recentReadingsViewContainer;
@property (strong, nonatomic) IBOutlet UITableView *sensorPropertiesTableview;
@property (strong, nonatomic) IBOutlet UITableView *recentReadingsTableview;
@property (strong, nonatomic) IBOutlet UILabel *valueLabel;
@property (strong, nonatomic) IBOutlet WMGaugeView *gaugeView;

@end

@implementation DetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.propertiesViewContainer.layer.cornerRadius = 5.0f;
    self.propertiesViewContainer.clipsToBounds = YES;
    self.readingViewContainer.layer.cornerRadius = 5.0f;
    self.readingViewContainer.clipsToBounds = YES;
    self.recentReadingsViewContainer.layer.cornerRadius = 5.0f;
    self.recentReadingsViewContainer.clipsToBounds = YES;
    self.sensorPropertiesTableview.layer.cornerRadius = 5.0f;
    self.recentReadingsTableview.layer.cornerRadius = 5.0f;
    
    self.recentReadings = [NSMutableArray array];
    self.sensorReadings = [NSMutableArray array];
    
    [self reloadViews];
    [self initGaugueView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWithNewData) name:SENSOR_READINGS_DATA_UPDATED object:nil];
}

- (void)updateWithNewData
{
    self.recentReadings = [[DataManager sharedManager] getRecentReadingsOfSensor:self.selectedSensor.s_id];
    [self filterReadingsIntoSections:self.recentReadings];
    [self reloadViews];
}

- (void)filterReadingsIntoSections:(NSMutableArray *)readings
{
    [self.sensorReadings removeAllObjects];
    
    if ([readings count] == 0) return;
    
    __block NSString *currentDate;
    __block NSMutableArray *currentSectionOfReadings;
    [readings enumerateObjectsUsingBlock:^(SensorReading *reading, NSUInteger index, BOOL *stop){
        if (!currentDate)
        {
            currentDate = [DataUtils dateStringFromDate:reading.sr_read_time];
            currentSectionOfReadings = [NSMutableArray array];
            [currentSectionOfReadings addObject:reading];
        }
        else if ([currentDate isEqualToString:[DataUtils dateStringFromDate:reading.sr_read_time]])
        {
            [currentSectionOfReadings addObject:reading];
        }
        else
        {
            [self.sensorReadings addObject:currentSectionOfReadings];
            currentSectionOfReadings = nil;
            currentDate = [DataUtils dateStringFromDate:reading.sr_read_time];
            currentSectionOfReadings = [NSMutableArray array];
            [currentSectionOfReadings addObject:reading];
        }
        
        if (index == readings.count-1)
        {
            [self.sensorReadings addObject:currentSectionOfReadings];
        }
    }];
}

- (void)reloadViews
{
    [self.sensorPropertiesTableview reloadData];
    [self.recentReadingsTableview reloadData];
    [self reloadGaugueView];
}

#pragma mark - Gaugue View
- (void)initGaugueView
{
    self.gaugeView.scaleDivisions = 10;
    self.gaugeView.scaleSubdivisions = 10;
    self.gaugeView.scaleStartAngle = 30;
    self.gaugeView.scaleEndAngle = 330;
    self.gaugeView.innerBackgroundStyle = WMGaugeViewInnerBackgroundStyleFlat;
    self.gaugeView.showInnerBackground = NO;
    self.gaugeView.showScaleShadow = YES;
    self.gaugeView.showScale = YES;
    self.gaugeView.scaleFont = [UIFont fontWithName:@"AvenirNext-Bold" size:0.065];
    self.gaugeView.scalesubdivisionsAligment = WMGaugeViewSubdivisionsAlignmentCenter;
    self.gaugeView.needleStyle = WMGaugeViewNeedleStyleFlatThin;
    self.gaugeView.needleWidth = 0.012;
    self.gaugeView.needleHeight = 0.4;
    self.gaugeView.needleScrewStyle = WMGaugeViewNeedleScrewStylePlain;
    self.gaugeView.needleScrewRadius = 0.05;
    self.gaugeView.maxValue = [self.selectedSensor.s_sensor_type.st_reading_max integerValue] ? [self.selectedSensor.s_sensor_type.st_reading_max integerValue] : 100;
    self.gaugeView.value = 50;
    self.gaugeView.backgroundColor = [UIColor clearColor];
}

- (void)reloadGaugueView
{
    self.gaugeView.scaleDivisions = 10;
    self.gaugeView.scaleSubdivisions = 10;
    NSInteger range = [self.selectedSensor.s_sensor_type.st_reading_max floatValue] - [self.selectedSensor.s_sensor_type.st_reading_min floatValue];
    self.gaugeView.maxValue = range == 0 ? 100 : 10.0 * floor((range/10.0)+0.5);
    
    if (self.sensorReadings.count > 0)
    {
        SensorReading *reading = [[self.sensorReadings objectAtIndex:0] objectAtIndex:0];
        [self.gaugeView setValue:[reading.sr_reading floatValue] animated:YES duration:1.6];
        self.valueLabel.text = [NSString stringWithFormat:@"%.04f %@", reading.sr_reading ? [reading.sr_reading floatValue] : 0, self.selectedSensor.s_sensor_type.st_unit];
    }
    else
    {
        [self.gaugeView setValue:[self.selectedSensor.s_last_reading.sr_reading floatValue] animated:YES duration:3];
        self.valueLabel.text = [NSString stringWithFormat:@"%.04f %@", self.selectedSensor.s_last_reading.sr_reading ? [self.selectedSensor.s_last_reading.sr_reading floatValue] : 0, self.selectedSensor.s_sensor_type.st_unit];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:self.sensorPropertiesTableview])
    {
        return 1;
    }
    else
    {
        return self.sensorReadings.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.sensorPropertiesTableview])
    {
        return @"";
    }
    else
    {
        if (self.recentReadings.count > 0)
        {
            SensorReading *reading = [[self.sensorReadings objectAtIndex:0] objectAtIndex:0];
            return [DataUtils dateStringFromDate:reading.sr_read_time];
        }
        else
        {
            return @"";
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.sensorPropertiesTableview])
    {
        return 13;
    }
    else
    {
        NSArray *data = [self.sensorReadings objectAtIndex:section];
        return data.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.sensorPropertiesTableview])
    {
        static NSString *CellIdentifier = @"DetailsCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        [self configureCell:cell atIndexPath:indexPath];
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"ReadingsCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        NSArray *data = [self.sensorReadings objectAtIndex:indexPath.section];
        SensorReading *reading = [data objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%.04f %@", [reading.sr_reading floatValue], self.selectedSensor.s_sensor_type.st_unit];
        cell.detailTextLabel.text = [DataUtils timeStringFromDate:reading.sr_read_time];
        
        return cell;
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text = @"ID";
            cell.detailTextLabel.text = self.selectedSensor ? [NSString stringWithFormat:@"%@", self.selectedSensor.s_id] : @"";
            break;
        case 1:
            cell.textLabel.text = @"Name";
            cell.detailTextLabel.text = self.selectedSensor ? [NSString stringWithFormat:@"%@", self.selectedSensor.s_name] : @"";
            break;
        case 2:
            cell.textLabel.text = @"Unit";
            cell.detailTextLabel.text = self.selectedSensor ? [NSString stringWithFormat:@"%@", self.selectedSensor.s_sensor_type.st_unit] : @"";
            break;
        case 3:
            cell.textLabel.text = @"Status";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.selectedSensor.s_status == [NSNumber numberWithInt:0] ? @"Off" : @"On"];
            break;
        case 4:
            cell.textLabel.text = @"Channel";
            cell.detailTextLabel.text = self.selectedSensor ? [NSString stringWithFormat:@"%@", self.selectedSensor.s_channel] : @"";
            break;
        case 5:
            cell.textLabel.text = @"Sensor Type";
            cell.detailTextLabel.text = self.selectedSensor ? [NSString stringWithFormat:@"%@", self.selectedSensor.s_sensor_type.st_name] : @"";
            break;
        case 6:
            cell.textLabel.text = @"Reading Range";
            cell.detailTextLabel.text = self.selectedSensor ? [NSString stringWithFormat:@"%@ - %@", self.selectedSensor.s_sensor_type.st_reading_min,self.selectedSensor.s_sensor_type.st_reading_max] : @"";
            break;
        case 7:
            cell.textLabel.text = @"Type Catagory";
            cell.detailTextLabel.text = self.selectedSensor ? [NSString stringWithFormat:@"%@", self.selectedSensor.s_sensor_type.st_sensor_type_category.stc_name] : @"";
            break;
        case 8:
            cell.textLabel.text = @"Model Number";
            cell.detailTextLabel.text = self.selectedSensor ? [NSString stringWithFormat:@"%@", self.selectedSensor.s_sensor_type.st_model_num] : @"";
            break;
        case 9:
            cell.textLabel.text = @"Controller";
            cell.detailTextLabel.text = self.selectedSensor ? [NSString stringWithFormat:@"%@", self.selectedSensor.s_controller.c_name] : @"";
            break;
        case 10:
            cell.textLabel.text = @"Serial Number";
            cell.detailTextLabel.text = self.selectedSensor ? [NSString stringWithFormat:@"%@", self.selectedSensor.s_controller.c_serial_num] : @"";
            break;
        case 11:
            cell.textLabel.text = @"Location";
            cell.detailTextLabel.text = self.selectedSensor ? [NSString stringWithFormat:@"%@", self.selectedSensor.s_controller.c_location.l_name] : @"";
            break;
        case 12:
            cell.textLabel.text = @"Location Detail";
            cell.detailTextLabel.text = self.selectedSensor ? [NSString stringWithFormat:@"%@", self.selectedSensor.s_controller.c_location.l_description] : @"";
            break;
            
        default:
            break;
    }
}

@end
