//
//  DetailViewController.m
//  DEMO Framework
//
//  Created by Zhou, Zian on 2015-02-17.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import "RightViewController.h"
#import "GraphViewController.h"
#import "DetailsViewController.h"
#import "APIManager.h"
#import "DataManager.h"
#import "Sensor.h"
#import "MBProgressHUD.h"
#import "constants.h"
#import "AlertView.h"
#import "AppDelegate.h"

@interface RightViewController () {
    AlertView *alertView;
}

@property (strong, nonatomic) IBOutlet UIView *detailsContainer;
@property (strong, nonatomic) IBOutlet UIView *graphContainer;

@property (strong, nonatomic) GraphViewController *graphViewController;
@property (strong, nonatomic) DetailsViewController *detailsViewController;

@end

@implementation RightViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem)
    {
        _detailItem = newDetailItem;
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem)
    {
        [[DataManager sharedManager] unsubscribeSelectedSensor];
        [DataManager sharedManager].selectedSensor = self.detailItem;
        self.detailsViewController.selectedSensor = self.detailItem;
        self.graphViewController.selectedSensor = self.detailItem;

        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.detailsViewController updateWithNewData];
        [self.graphViewController updateWithNewData];
        [[DataManager sharedManager] subscribeSelectedSensor];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        // Below is for pulling data from API
//        [[DataManager sharedManager] updateSensorReadingsInfomationWithCompletion:^(){
//            self.graphViewController.recentReadings = [DataManager sharedManager].recentReadingsOfSelectedSensor;
//            [self.detailsViewController updateWithNewData];
//            [self.graphViewController reloadData];
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            [[DataManager sharedManager] startToUpdateSensorReadingsInfoWithTimeInterval:[[DataManager sharedManager].sensorReadingUpdatingFrequency integerValue]];
//        }];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    UIBarButtonItem *hiddenButton = [[UIBarButtonItem alloc] initWithTitle:@"    " style:UIBarButtonItemStylePlain target:self action:@selector(showToggles)];
    self.navigationItem.rightBarButtonItem = hiddenButton;
}

- (void)showToggles
{
    [self.graphViewController showToggles];
}

- (void)showAlertView:(NSString*)message
{
    NSArray* nibViews= [[NSBundle mainBundle] loadNibNamed:@"AlertView"
                                                     owner:self
                                                   options:nil];
    alertView = [nibViews objectAtIndex:0];
    [alertView setFrame:CGRectMake(350.0f, self.view.frame.size.height - 40.0f, self.view.frame.size.width - 65.0f, 35.0f)];
    alertView.layer.cornerRadius = 5.0f;
    alertView.alertMessageLabel.text = [NSString stringWithFormat:@"%@ !", message];
    [self.splitViewController.view addSubview:alertView];
}

- (void)dismissAlertView
{
    [alertView removeFromSuperview];
}

- (IBAction)segControllValueChanged:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self.view bringSubviewToFront:self.detailsContainer];
            break;
        case 1:
            [self.view bringSubviewToFront:self.graphContainer];
            self.graphViewController.graphAnimation = true;
            [self.graphViewController updateWithNewData];
            break;
        default:
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"GraphViewController"])
    {
        self.graphViewController = (GraphViewController *) [segue destinationViewController];
    }
    else if ([segueName isEqualToString: @"DetailsViewController"])
    {
        self.detailsViewController = (DetailsViewController *) [segue destinationViewController];
    }
}

@end
