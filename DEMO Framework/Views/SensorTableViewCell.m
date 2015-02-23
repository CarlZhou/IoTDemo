//
//  SensorTableViewCell.m
//  DEMO Framework
//
//  Created by Zhou, Zian on 2015-02-17.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import "SensorTableViewCell.h"
#import "Sensor.h"
#import "SensorReading.h"
#import "SensorType.h"
#import "NSDate+PrettyDate.h"

@implementation SensorTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithSensor:(Sensor *)sensor
{
    self.stvc_sensor = sensor;
    self.stvc_nameLabel.text = sensor.s_name;
    NSLog(@"sensor name: %@", sensor.s_name);
    
    self.stvc_primaryUnitLabel.text = [NSString stringWithFormat:@"%.4f", [sensor.s_last_reading.sr_reading doubleValue]];
    [self.stvc_progressView setProgress:[sensor.s_last_reading.sr_reading doubleValue]/[sensor.s_sensor_type.st_reading_max floatValue] animated:YES];
    self.stvc_timeLabel.text = [sensor.s_last_reading.sr_read_time prettyDate];
    
    self.stvc_secondaryUnitLabel.hidden = YES;
}

@end
