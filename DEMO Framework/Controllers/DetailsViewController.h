//
//  DetailsViewController.h
//  DEMO Framework
//
//  Created by carlzhou on 2/19/15.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Sensor;

@interface DetailsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) Sensor *selectedSensor;

- (void)reloadViews;

@end
