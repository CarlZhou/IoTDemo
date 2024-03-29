//
//  GraphViewController.h
//  DEMO Framework
//
//  Created by tracyshi on 2015-02-18.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Sensor;

@interface GraphViewController : UIViewController

@property (nonatomic, strong) Sensor *selectedSensor;
@property (nonatomic, strong) NSMutableArray *recentReadings;
@property (nonatomic) BOOL graphAnimation;

- (void)updateWithNewData;

// Hidden
- (void)showToggles;

@end
