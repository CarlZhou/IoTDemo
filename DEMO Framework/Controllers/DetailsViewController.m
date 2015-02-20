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

#define DISPLAYED_PROPERTIES_NUM 10
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

@interface DetailsViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    
}

@property (strong, nonatomic) IBOutlet UIView *propertiesViewContainer;
@property (strong, nonatomic) IBOutlet UIView *readingViewContainer;
@property (strong, nonatomic) IBOutlet UIView *recentReadingsViewContainer;
@property (strong, nonatomic) IBOutlet UITableView *sensorPropertiesTableview;
@property (strong, nonatomic) IBOutlet UITableView *recentReadingsTableview;
@property (strong, nonatomic) IBOutlet WMGaugeView *gaugeView;

@end

@implementation DetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
<<<<<<< HEAD
    self.propertiesViewContainer.layer.cornerRadius = 5.0f;
    self.propertiesViewContainer.clipsToBounds = YES;
    self.readingViewContainer.layer.cornerRadius = 5.0f;
    self.readingViewContainer.clipsToBounds = YES;
    self.recentReadingsViewContainer.layer.cornerRadius = 5.0f;
    self.recentReadingsViewContainer.clipsToBounds = YES;
    self.sensorPropertiesTableview.layer.cornerRadius = 5.0f;
    self.recentReadingsTableview.layer.cornerRadius = 5.0f;
=======
    currentBarView = [[CircularBarView alloc] initWithFrame:CGRectMake(0, 0, 175, 255) Title:@"Current" DisplayColor:customOrange Percentage:65 Reading:250 Unit:@"Lumens"];// fdaa29
    [self.currentViewContainer addSubview:currentBarView];
>>>>>>> FETCH_HEAD
    
    [self reloadViews];
    [self initGaugueView];
}

- (void)reloadViews
{
    [self.sensorPropertiesTableview reloadData];
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
//    self.gaugeView.rangeValues = @[ self.selectedSensor.s_sensor_type.st_reading_min, self.selectedSensor.s_sensor_type.st_reading_max];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
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
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
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
