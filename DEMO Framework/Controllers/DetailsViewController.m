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
#import "Constants.h"
#import "WMGaugeView.h"
#import "APIManager.h"
#import "DataManager.h"

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
    
    [self reloadViews];
    [self initGaugueView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWithNewData) name:SENSOR_READINGS_DATA_UPDATED object:nil];
}

- (void)updateWithNewData
{
    self.recentReadings = [DataManager sharedManager].sensorReadings;
    [self reloadViews];
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
    self.gaugeView.scaleSubdivisions = 5;
    self.gaugeView.scaleStartAngle = 30;
    self.gaugeView.scaleEndAngle = 330;
    self.gaugeView.innerBackgroundStyle = WMGaugeViewInnerBackgroundStyleFlat;
    self.gaugeView.showScaleShadow = YES;
    self.gaugeView.showScale = YES;
    self.gaugeView.scaleFont = [UIFont fontWithName:@"AvenirNext-UltraLight" size:0.065];
    self.gaugeView.scalesubdivisionsAligment = WMGaugeViewSubdivisionsAlignmentCenter;
    self.gaugeView.scaleSubdivisionsWidth = 0.002;
    self.gaugeView.scaleSubdivisionsLength = 0.04;
    self.gaugeView.scaleDivisionsWidth = 0.007;
    self.gaugeView.scaleDivisionsLength = 0.07;
    self.gaugeView.needleStyle = WMGaugeViewNeedleStyleFlatThin;
    self.gaugeView.needleWidth = 0.012;
    self.gaugeView.needleHeight = 0.4;
    self.gaugeView.needleScrewStyle = WMGaugeViewNeedleScrewStylePlain;
    self.gaugeView.needleScrewRadius = 0.05;
    self.gaugeView.maxValue = 240;
    self.gaugeView.value = 50;
    self.gaugeView.backgroundColor = [UIColor clearColor];
}

- (void)reloadGaugueView
{
    NSInteger range = [self.selectedSensor.s_sensor_type.st_reading_max floatValue] - [self.selectedSensor.s_sensor_type.st_reading_min floatValue];
    self.gaugeView.maxValue = range == 0 ? 320 : range;
    self.gaugeView.value = [self.selectedSensor.s_last_reading.sr_reading floatValue];
    self.valueLabel.text = [NSString stringWithFormat:@"%@ %@", self.selectedSensor.s_last_reading.sr_reading ? self.selectedSensor.s_last_reading.sr_reading : @0, self.selectedSensor.s_unit];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.sensorPropertiesTableview])
    {
        return 10;
    }
    else
    {
        return self.recentReadings.count;
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
        
        SensorReading *reading = [self.recentReadings objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", reading.sr_reading, self.selectedSensor.s_unit];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", reading.sr_read_time];
        
        return cell;
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text = @"ID";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.selectedSensor.s_id];
            break;
        case 1:
            cell.textLabel.text = @"Name";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.selectedSensor.s_name];
            break;
        case 2:
            cell.textLabel.text = @"Unit";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.selectedSensor.s_unit];
            break;
        case 3:
            cell.textLabel.text = @"Status";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.selectedSensor.s_status];
            break;
        case 4:
            cell.textLabel.text = @"Channel";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.selectedSensor.s_channel];
            break;
        case 5:
            cell.textLabel.text = @"Serial Number";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.selectedSensor.s_serial_num];
            break;
        case 6:
            cell.textLabel.text = @"Sensor Type Catagory";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.selectedSensor.s_sensor_type.st_sensor_type_category.stc_name];
            break;
        case 7:
            cell.textLabel.text = @"Type Name";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.selectedSensor.s_sensor_type.st_name];
            break;
        case 8:
            cell.textLabel.text = @"Type Description";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.selectedSensor.s_sensor_type.st_type_description];
            break;
        case 9:
            cell.textLabel.text = @"Model Number";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.selectedSensor.s_sensor_type.st_model_num];
            break;
            
        default:
            break;
    }
}

@end
