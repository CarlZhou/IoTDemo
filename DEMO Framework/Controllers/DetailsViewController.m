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
    currentBarView.titleLabel.text = @"Current";
    currentBarView.percentage = 65;
    currentBarView.displayColor = [UIColor orangeColor];    // fdaa29
    currentBarView.backgroundColor = [UIColor whiteColor];
    [self.currentViewContainer addSubview:currentBarView];
    
    self.sensorTitleLabel.text = self.selectedSensor.s_name;
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

@end
