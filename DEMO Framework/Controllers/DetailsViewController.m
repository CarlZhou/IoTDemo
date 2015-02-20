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

#define DISPLAYED_PROPERTIES_NUM 10

@interface DetailsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *sensorTitleLabel;
@property (strong, nonatomic) IBOutlet UIView *currentViewContainer;


@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view from its nib.
    CircularBarView *currentBarView = [[CircularBarView alloc] initWithFrame:CGRectMake(0, 0, 175, 200)];
<<<<<<< HEAD
//    currentBarView.title = @"Current";
=======
    currentBarView.titleLabel.text = @"Current";
>>>>>>> FETCH_HEAD
    currentBarView.percentage = 65;
    currentBarView.displayColor = [UIColor orangeColor];    // fdaa29
    currentBarView.backgroundColor = [UIColor whiteColor];
    [self.currentViewContainer addSubview:currentBarView];
    [self reloadViews];
    
}

- (void)reloadViews
{
    self.sensorTitleLabel.text = self.selectedSensor.s_name;
    [self.tableview reloadData];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

@end
