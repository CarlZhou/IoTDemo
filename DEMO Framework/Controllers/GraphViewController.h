//
//  GraphViewController.h
//  DEMO Framework
//
//  Created by Sybase on 2015-02-18.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Sensor;

@interface GraphViewController : UIViewController

@property (nonatomic, strong) Sensor *selectedSensor;

@property (nonatomic, strong) NSMutableArray *recentReadings;

- (void)reloadViews;
- (void)reloadData;

@end
