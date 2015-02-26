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
#import "SensorTypeCategory.h"
#import "NSDate+PrettyDate.h"
#import "constants.h"

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
    NSString *sensorTypeCategory = sensor.s_sensor_type.st_sensor_type_category.stc_name;
    float currentReading = [sensor.s_last_reading.sr_reading floatValue];
    float maxReading = [sensor.s_sensor_type.st_reading_max floatValue];
    
    self.stvc_sensor = sensor;
    self.stvc_nameLabel.text = sensor.s_name;
    self.stvc_primaryUnitLabel.text = sensorTypeCategory;
    self.stvc_secondaryUnitLabel.text = [NSString stringWithFormat:@"%.04f %@", currentReading, sensor.s_unit];
    self.stvc_timeLabel.text = [sensor.s_last_reading.sr_read_time prettyDate];
    [self.stvc_progressView setProgress:currentReading/maxReading animated:YES];
    
    if (sensor)
    {
        if ([sensor.s_status integerValue] == 0) {
            [self.sensorStatusBar setBackgroundColor:customRed];
        } else {
            [self.sensorStatusBar setBackgroundColor:customGreen];
        }
    }
}

@end
