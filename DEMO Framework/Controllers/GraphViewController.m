//
//  GraphViewController.m
//  DEMO Framework
//
//  Created by Sybase on 2015-02-18.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import "GraphViewController.h"
#import "CircularBarView.h"
#import "BEMSimpleLineGraphView.h"
#import "Constants.h"
#import "SensorReading.h"
#import "Sensor.h"
#import "SensorType.h"

@interface GraphViewController ()<BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>
{
    CircularBarView *currentBarView;
    CircularBarView *avgBarView;
    CircularBarView *minBarView;
    CircularBarView *maxBarView;
}
@property (weak, nonatomic) IBOutlet UIView *currentViewContainer;
@property (weak, nonatomic) IBOutlet UIView *avgViewContainer;
@property (weak, nonatomic) IBOutlet UIView *minViewContainer;
@property (weak, nonatomic) IBOutlet UIView *maxViewContainer;

// Line Graph
@property (strong, nonatomic) IBOutlet BEMSimpleLineGraphView *lineGraph;

@property (strong, nonatomic) NSMutableArray *lineOneData;
@property (strong, nonatomic) NSMutableArray *lineOneDataDetail;

@end

@implementation GraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLineGraph];
    [self initCircularGraph];
}

- (void)reloadViews
{
    [self.lineGraph reloadGraph];
    [currentBarView setNeedsDisplay];
    [avgBarView setNeedsDisplay];
    [minBarView setNeedsDisplay];
    [maxBarView setNeedsDisplay];
}

#pragma mark - Circlar Graph

- (void)initCircularGraph
{
    currentBarView = [[CircularBarView alloc] initWithFrame:CGRectMake(0, 0, 175, 254) Title:@"Current" DisplayColor:customOrange Percentage:65 Reading:250 Unit:@"Lumens"];// fdaa29
    [self.currentViewContainer addSubview:currentBarView];
    
    avgBarView = [[CircularBarView alloc] initWithFrame:CGRectMake(0, 0, 175, 254) Title:@"Average" DisplayColor:customBlue Percentage:45 Reading:120 Unit:@"Lumens"];
    [self.avgViewContainer addSubview:avgBarView];// 56a8e7
    
    minBarView = [[CircularBarView alloc] initWithFrame:CGRectMake(0, 0, 175, 254) Title:@"Min" DisplayColor:customRed Percentage:31 Reading:15 Unit:@"Lumens"];
    [self.minViewContainer addSubview:minBarView];// f1705c
    
    maxBarView = [[CircularBarView alloc] initWithFrame:CGRectMake(0, 0, 175, 254) Title:@"Max" DisplayColor:customGreen Percentage:69 Reading:310 Unit:@"Lumens"];
    [self.maxViewContainer addSubview:maxBarView]; // 8fc842

}

- (void)reloadData
{
    [self.lineOneData removeAllObjects];
    [self.lineOneDataDetail removeAllObjects];
    [self.recentReadings enumerateObjectsUsingBlock:^(SensorReading *reading, NSUInteger index, BOOL *stop){
        [self.lineOneData addObject:reading.sr_reading];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm:ss"];
        [self.lineOneDataDetail addObject:[formatter stringFromDate:reading.sr_read_time]];
    }];
    [self.lineGraph reloadGraph];
    
    // Graphs
    maxBarView.reading = [[self.lineGraph calculateMaximumPointValue] floatValue];
    maxBarView.percentage = [[self.lineGraph calculateMaximumPointValue] floatValue]/[self.selectedSensor.s_sensor_type.st_reading_max floatValue] * 100;
    
    minBarView.reading = [[self.lineGraph calculateMinimumPointValue] floatValue];
    minBarView.percentage = [[self.lineGraph calculateMinimumPointValue] floatValue]/[self.selectedSensor.s_sensor_type.st_reading_max floatValue] * 100;
    
    avgBarView.reading = [[self.lineGraph calculatePointValueAverage] floatValue];
    avgBarView.percentage = [[self.lineGraph calculatePointValueAverage] floatValue]/[self.selectedSensor.s_sensor_type.st_reading_max floatValue] * 100;
    
    currentBarView.reading = [[self.lineOneData lastObject] floatValue];
    currentBarView.percentage = [[self.lineOneData lastObject] floatValue]/[self.selectedSensor.s_sensor_type.st_reading_max floatValue] * 100;

    [self reloadViews];
}

#pragma mark - Line Graph

- (void)initLineGraph
{
    // Line Graph Start
    self.lineGraph.dataSource = self;
    self.lineGraph.delegate = self;
    self.lineGraph.backgroundColor = [UIColor whiteColor];
    self.lineGraph.enableBezierCurve = YES;
    self.lineGraph.enablePopUpReport = YES;
    self.lineGraph.enableTouchReport = YES;
    self.lineGraph.enableXAxisLabel = YES;
    self.lineGraph.enableYAxisLabel = YES;
    //self.lineGraph.enableReferenceAxisFrame = YES;
    self.lineGraph.enableReferenceYAxisLines = YES;
    //self.lineGraph.enableReferenceXAxisLines = YES;
    //    self.lineGraph.autoScaleYAxis = NO;
    self.lineGraph.alwaysDisplayDots = YES;
    self.lineGraph.colorPoint = graphPointColor;
    self.lineGraph.colorBackgroundXaxis = [UIColor whiteColor];
    self.lineGraph.colorTop = [UIColor whiteColor];
    self.lineGraph.colorBottom = graphBottomColor;
    self.lineGraph.colorLine = graphLineColor;
    self.lineGraph.clipsToBounds = NO;
    
    self.lineOneData = [NSMutableArray arrayWithArray:@[@60, @50, @30, @40, @80]];
    self.lineOneDataDetail = [NSMutableArray arrayWithArray:@[@"Mon",@"Tue", @"Wed", @"Thu", @"Fri"]];
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

@end
