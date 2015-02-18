//
//  SensorTableViewCell.h
//  DEMO Framework
//
//  Created by Zhou, Zian on 2015-02-17.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Sensor;

@interface SensorTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *stvc_nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stvc_timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stvc_primaryUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *stvc_secondaryUnitLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *stvc_progressView;

@property (strong, nonatomic) Sensor *stvc_sensor;

- (void)setCellWithSensor:(Sensor *)sensor;


@end
