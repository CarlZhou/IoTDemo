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

@property (nonatomic, strong) Sensor *selectedSensor;

@property (nonatomic, strong) NSMutableArray *recentReadings;
@property (nonatomic, strong) NSMutableArray *sensorReadings;

- (void)updateWithNewData;

@end
