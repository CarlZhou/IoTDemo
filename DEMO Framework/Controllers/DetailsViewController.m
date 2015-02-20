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
#import "Constants.h"
#import "WMGaugeView.h"
#import "APIManager.h"

#define DISPLAYED_PROPERTIES_NUM 10

@interface DetailsViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    
}

@property (strong, nonatomic) IBOutlet UIView *propertiesViewContainer;
@property (strong, nonatomic) IBOutlet UIView *readingViewContainer;
@property (strong, nonatomic) IBOutlet UIView *recentReadingsViewContainer;
@property (strong, nonatomic) IBOutlet UITableView *sensorPropertiesTableview;
@property (strong, nonatomic) IBOutlet UITableView *recentReadingsTableview;
@property (strong, nonatomic) IBOutlet WMGaugeView *gaugeView;
@property (nonatomic, strong) NSMutableArray *recentReadings;

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
}

- (void)reloadViews
{
    [self.sensorPropertiesTableview reloadData];
    
    [[APIManager sharedManager] getSensorReadingsForSensors:@[@1] Limit:10 Skip:0 success:^(NSArray *sensors, NSArray *readings){
        
        self.recentReadings = readings.mutableCopy;
        [self.recentReadingsTableview reloadData];
//                NSLog(@"readings: %@", readings);
    }failure:^(AFHTTPRequestOperation *operation){
        
    }];
    
    [self reloadGaugueView];
}

#pragma mark - Gaugue View
- (void)initGaugueView
{
    self.gaugeView.maxValue = 240.0;
    self.gaugeView.showRangeLabels = YES;
    self.gaugeView.rangeValues = @[ @50,                  @90,                @130,               @240.0              ];
    self.gaugeView.rangeColors = @[ RGB(232, 111, 33),    RGB(232, 231, 33),  RGB(27, 202, 33),   RGB(231, 32, 43)    ];
    self.gaugeView.rangeLabels = @[ @"VERY LOW",          @"LOW",             @"OK",              @"OVER FILL"        ];
    self.gaugeView.unitOfMeasurement = @"Lumi";
    self.gaugeView.showUnitOfMeasurement = YES;
    self.gaugeView.showScale = YES;
    self.gaugeView.scaleDivisionsWidth = 0.008;
    self.gaugeView.scaleSubdivisionsWidth = 0.006;
    self.gaugeView.rangeLabelsFontColor = [UIColor blackColor];
    self.gaugeView.rangeLabelsWidth = 0.04;
    self.gaugeView.value = 50.0f;
    self.gaugeView.rangeLabelsFont = [UIFont fontWithName:@"Helvetica" size:0.04];
    self.gaugeView.backgroundColor = [UIColor clearColor];
}

- (void)reloadGaugueView
{
    NSInteger range = [self.selectedSensor.s_sensor_type.st_reading_max integerValue] - [self.selectedSensor.s_sensor_type.st_reading_min integerValue];
//    float number = 350.0f;
//    self.gaugeView.maxValue = number;
    self.gaugeView.rangeValues = @[ @(range*0.25), @(range*0.75), @(range) ];
    self.gaugeView.rangeColors = @[ RGB(27, 202, 33), RGB(232, 231, 33), RGB(231, 32, 43) ];
    self.gaugeView.rangeLabels = @[ @"", @"", @"" ];
    self.gaugeView.value = [self.selectedSensor.s_last_reading.sr_reading floatValue];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.sensorPropertiesTableview])
    {
        return 6;
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
        NSLog(@"%@", reading);
        
        return cell;
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text = @"id";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.selectedSensor.s_id];
            break;
        case 1:
            cell.textLabel.text = @"name";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.selectedSensor.s_name];
            break;
        case 2:
            cell.textLabel.text = @"unit";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.selectedSensor.s_unit];
            break;
        case 3:
            cell.textLabel.text = @"status";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.selectedSensor.s_status];
            break;
        case 4:
            cell.textLabel.text = @"channel";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.selectedSensor.s_channel];
            break;
        case 5:
            cell.textLabel.text = @"serial_num";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.selectedSensor.s_serial_num];
            break;
            
        default:
            break;
    }
}

@end
