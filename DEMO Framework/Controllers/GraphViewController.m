//
//  GraphViewController.m
//  DEMO Framework
//
//  Created by tracyshi on 2015-02-18.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import "GraphViewController.h"
#import "CircularBarView.h"
#import "BEMSimpleLineGraphView.h"
#import "Constants.h"
#import "SensorReading.h"
#import "Sensor.h"
#import "SensorType.h"
#import "DataManager.h"
#import "WMGaugeView.h"
#import "MBProgressHUD.h"

#define SCALE_DIVISION 10
#define SCALE_START_ANGLE 30
#define SCALE_END_ANGLE 330

@interface GraphViewController ()<BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>
{    
    double circularViewAnimatingTime;
}
@property (weak, nonatomic) IBOutlet UIView *currentViewContainer;
@property (weak, nonatomic) IBOutlet UIView *avgViewContainer;
@property (weak, nonatomic) IBOutlet UIView *minViewContainer;
@property (weak, nonatomic) IBOutlet UIView *maxViewContainer;

@property (weak, nonatomic) IBOutlet WMGaugeView *currentGaugeView;
@property (weak, nonatomic) IBOutlet WMGaugeView *averageGaugeView;
@property (weak, nonatomic) IBOutlet WMGaugeView *minGaugeView;
@property (weak, nonatomic) IBOutlet WMGaugeView *maxGaugeView;

@property (weak, nonatomic) IBOutlet UILabel *currentLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageLabel;
@property (weak, nonatomic) IBOutlet UILabel *minLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxLabel;

@property (strong, nonatomic) IBOutlet UILabel *xAxisUnitLabel;
@property (strong, nonatomic) IBOutlet UILabel *yAxisUnitLabel;

// Line Graph
@property (strong, nonatomic) IBOutlet BEMSimpleLineGraphView *lineGraph;
@property (strong, nonatomic) NSMutableArray *lineOneData;
@property (strong, nonatomic) NSMutableArray *lineOneDataDetail;

// Toggles
@property (strong, nonatomic) IBOutlet UIView *togglesContainer;
@property (strong, nonatomic) IBOutlet UILabel *dataPointsLabel;
@property (strong, nonatomic) IBOutlet UIStepper *dataPointsStepper;
@property (strong, nonatomic) IBOutlet UIButton *dataPointsResetButton;

@end

@implementation GraphViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initLineGraph];
    [self initGaugeViews];
    self.recentReadings = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWithNewData) name:SENSOR_READINGS_DATA_UPDATED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectNewSensor) name:DID_SELECT_NEW_SENSOR object:nil];
    
    // Hidden
    self.dataPointsResetButton.layer.cornerRadius = 5.0f;
}

// Hidden
- (void)showToggles
{
    [self.togglesContainer setHidden:!self.togglesContainer.isHidden];
}
// Hidden

- (void)didSelectNewSensor
{
    self.graphAnimation = YES;
}

#pragma mark - Gauge Views

- (void)initGaugeViews
{
    [self initSingleGaugeView:self.currentGaugeView ScaleDivisionColor:customOrange];
    [self initSingleGaugeView:self.averageGaugeView ScaleDivisionColor:customBlue];
    [self initSingleGaugeView:self.minGaugeView ScaleDivisionColor:customRed];
    [self initSingleGaugeView:self.maxGaugeView ScaleDivisionColor:customGreen];
}

- (void)initSingleGaugeView:(WMGaugeView*)gaugeView ScaleDivisionColor:(UIColor*)color
{
    gaugeView.scaleDivisions = SCALE_DIVISION;
    gaugeView.scaleDivisionColor =  color;
    gaugeView.scaleSubdivisions = SCALE_DIVISION;
    gaugeView.scaleSubDivisionColor = color;
    gaugeView.scaleStartAngle = SCALE_START_ANGLE;
    gaugeView.scaleEndAngle = SCALE_END_ANGLE;
    gaugeView.innerBackgroundStyle = WMGaugeViewInnerBackgroundStyleFlat;
    gaugeView.showInnerBackground = NO;
    gaugeView.showScaleShadow = YES;
    gaugeView.showScale = YES;
    gaugeView.scaleFont = [UIFont fontWithName:@"AvenirNext-Bold" size:0.07];
    gaugeView.scalesubdivisionsAligment = WMGaugeViewSubdivisionsAlignmentCenter;
    gaugeView.needleStyle = WMGaugeViewNeedleStyleFlatThin;
    gaugeView.needleWidth = 0.012;
    gaugeView.needleHeight = 0.4;
    gaugeView.needleScrewStyle = WMGaugeViewNeedleScrewStylePlain;
    gaugeView.needleScrewRadius = 0.05;
    gaugeView.maxValue = [self.selectedSensor.s_sensor_type.st_reading_max integerValue] ? [self.selectedSensor.s_sensor_type.st_reading_max integerValue] : 100;
    gaugeView.value = 50;
    gaugeView.backgroundColor = [UIColor clearColor];
}

// ReloadGaugeViews
- (void)reloadGaugeViews
{
    NSInteger range = [self.selectedSensor.s_sensor_type.st_reading_max floatValue] - [self.selectedSensor.s_sensor_type.st_reading_min floatValue];
    float currentReading = 0;
    float avgReading = 0;
    float minReading = 0;
    float maxReading = 0;
    
    if (self.recentReadings.count > 0)
    {
        NSNumber *reading = [self.lineOneData lastObject];
        currentReading = [reading floatValue];
        avgReading = [[self.lineGraph calculatePointValueAverage] floatValue];
        minReading = [[self.lineGraph calculateMinimumPointValue] floatValue];
        maxReading = [[self.lineGraph calculateMaximumPointValue] floatValue];
    }
    
    [self reloadSingleGaugeView:self.currentGaugeView Label:self.currentLabel Range:range Reading:currentReading];
    [self reloadSingleGaugeView:self.averageGaugeView Label:self.averageLabel Range:range Reading:avgReading];
    [self reloadSingleGaugeView:self.maxGaugeView Label:self.maxLabel Range:range Reading:maxReading];
    [self reloadSingleGaugeView:self.minGaugeView Label:self.minLabel Range:range Reading:minReading];
}

- (void)reloadSingleGaugeView:(WMGaugeView*)gaugeView Label:(UILabel*)label Range:(NSInteger)range Reading:(float)reading
{
    gaugeView.maxValue = (range == 0 ? 100 : 10.0 * floor((range/10.0)+0.5));
    [gaugeView setValue:reading animated:YES duration:1];
    label.text = [NSString stringWithFormat:@"%.04f %@", reading, self.selectedSensor.s_unit];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor darkGrayColor]];
}

#pragma mark - Line Graph

- (void)initLineGraph
{
    // Line Graph Start
    self.lineGraph.dataSource = self;
    self.lineGraph.delegate = self;
    self.lineGraph.backgroundColor = [UIColor whiteColor];
    self.lineGraph.enableBezierCurve = NO;
    self.lineGraph.enablePopUpReport = YES;
    self.lineGraph.enableTouchReport = YES;
    self.lineGraph.enableXAxisLabel = YES;
    self.lineGraph.enableYAxisLabel = YES;
    self.lineGraph.enableReferenceYAxisLines = YES;
    self.lineGraph.alwaysDisplayDots = YES;
    self.lineGraph.colorPoint = graphPointColor;
    self.lineGraph.colorBackgroundXaxis = [UIColor whiteColor];
    self.lineGraph.colorTop = [UIColor whiteColor];
    self.lineGraph.colorBottom = graphBottomColor;
    self.lineGraph.colorLine = graphLineColor;
    self.lineGraph.clipsToBounds = NO;
    self.lineGraph.turnOnMeasureLines = YES;
    
    self.lineOneData = [NSMutableArray array];
    self.lineOneDataDetail = [NSMutableArray array];
    // Line Graph End
}

- (CGFloat)maxValueForLineGraph:(BEMSimpleLineGraphView *)graph
{
    return 100.0f;
}

- (CGFloat)minValueForLineGraph:(BEMSimpleLineGraphView *)graph
{
    return 0.0f;
}

// X-axis

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return self.lineOneData.count; // Number of points in the graph.
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index
{
//    self.lineOneData = [[DataManager sharedManager] getRecentReadingsOfSensor:self.selectedSensor.s_id];
    NSNumber *number = [self.lineOneData objectAtIndex:index];
    return [number doubleValue]; // The value of the point on the Y-Axis for the index.
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index
{
    return [self.lineOneDataDetail objectAtIndex:index];
}

// Y-axis
- (NSInteger)numberOfYAxisLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph
{
    return 11;
}

#pragma mark - Measurement lines
- (IBAction)measurementLinesToggleChanged:(UISwitch *)sender
{
    self.lineGraph.turnOnMeasureLines = sender.isOn;
    [self.lineGraph reloadGraph];
    [self.lineGraph calculatePointValueAverage];
}

- (IBAction)autoRefreshToggled:(UISwitch *)sender
{
    if (sender.isOn)
    {
        [[DataManager sharedManager] startToUpdateSensorReadingsInfoWithTimeInterval:[[DataManager sharedManager].sensorReadingUpdatingFrequency integerValue]];
    }
    else
    {
        [[DataManager sharedManager] stopUpdateSensorReadingsInfo];
    }
}

- (IBAction)dataPointsStepperValueChanged:(UIStepper *)sender {
    self.dataPointsLabel.text = [NSString stringWithFormat:@"%d", (int)sender.value];
    [DataManager sharedManager].numberOfReadingPoints = [NSNumber numberWithDouble:sender.value];
}

- (IBAction)resetButtonPressed:(id)sender {
    self.dataPointsLabel.text = [NSString stringWithFormat:@"%d", 10];
    [DataManager sharedManager].numberOfReadingPoints = [NSNumber numberWithDouble:10.0];
    self.dataPointsStepper.value = 10;
}


#pragma mark - Reload Data

- (void)updateWithNewData
{
    self.recentReadings = [[DataManager sharedManager] getRecentReadingsOfSensor:self.selectedSensor.s_id];
    [self reloadGraphView]; // gauge views reloading are triggered in reloadGraphView
}

- (void)reloadGraphView
{
    [self.lineOneData removeAllObjects];
    [self.lineOneDataDetail removeAllObjects];
    
    self.xAxisUnitLabel.text = [NSString stringWithFormat:@"Time (hh:mm:ss)"];
    self.yAxisUnitLabel.text = [NSString stringWithFormat:@"%@", self.selectedSensor.s_unit];
    
    self.recentReadings = [[[self.recentReadings reverseObjectEnumerator] allObjects] mutableCopy];
    [self.recentReadings  enumerateObjectsUsingBlock:^(SensorReading *reading, NSUInteger index, BOOL *stop){
        [self.lineOneData addObject:reading.sr_reading];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm:ss"];
        [self.lineOneDataDetail addObject:[formatter stringFromDate:reading.sr_read_time]];
        if (index == self.recentReadings.count-1)
        {
            self.lineGraph.turnOnMeasureLines = YES;
            self.lineGraph.animationGraphEntranceTime = self.graphAnimation ? 1.5 : 0;
            [self.lineGraph reloadGraph];
            if (self.graphAnimation)
            {
                self.graphAnimation = NO;
            }
            // Graphs
            [self performSelector:@selector(reloadGaugeViews) withObject:nil afterDelay:0.1];
        }
    }];
    if (self.recentReadings.count == 0)
    {
        self.lineGraph.turnOnMeasureLines = NO;
        [self.lineGraph reloadGraph];
        [self performSelector:@selector(reloadGaugeViews) withObject:nil afterDelay:0.1];
    }
}

@end
