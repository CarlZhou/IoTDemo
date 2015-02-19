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
    currentBarView.title = @"Current";
    currentBarView.percentage = 65;
    currentBarView.displayColor = [UIColor orangeColor];    // fdaa29
    currentBarView.backgroundColor = [UIColor whiteColor];
    [self.currentViewContainer addSubview:currentBarView];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
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

@end
