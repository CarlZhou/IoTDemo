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
#import "Constants.h"

#define DISPLAYED_PROPERTIES_NUM 10

@interface DetailsViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    CircularBarView *currentBarView;
}

@property (strong, nonatomic) IBOutlet UIView *currentViewContainer;


@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    currentBarView = [[CircularBarView alloc] initWithFrame:CGRectMake(0, 0, 175, 200) Title:@"Current" DisplayColor:customOrange Percentage:65];// fdaa29
    [self.currentViewContainer addSubview:currentBarView];
    
    [self reloadViews];
    
}

- (void)reloadViews
{
    [self.tableview reloadData];
    currentBarView.percentage = [self.selectedSensor.s_last_reading.sr_reading floatValue];
    [currentBarView setNeedsDisplay];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
