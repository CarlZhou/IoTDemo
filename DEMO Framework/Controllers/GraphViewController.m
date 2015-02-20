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
#import "constants.h"

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
    
    // Do any additional setup after loading the view from its nib.
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
    currentBarView = [[CircularBarView alloc] initWithFrame:CGRectMake(0, 0, 175, 254) Title:@"Current" DisplayColor:customOrange Percentage:65 Reading:250 Unit:@"lumi"];// fdaa29
    [self.currentViewContainer addSubview:currentBarView];
    
    avgBarView = [[CircularBarView alloc] initWithFrame:CGRectMake(0, 0, 175, 254) Title:@"Average" DisplayColor:customBlue Percentage:45 Reading:120 Unit:@"lumi"];
    [self.avgViewContainer addSubview:avgBarView];// 56a8e7
    
    minBarView = [[CircularBarView alloc] initWithFrame:CGRectMake(0, 0, 175, 254) Title:@"Min" DisplayColor:customRed Percentage:31 Reading:15 Unit:@"lumi"];
    [self.minViewContainer addSubview:minBarView];// f1705c
    
    maxBarView = [[CircularBarView alloc] initWithFrame:CGRectMake(0, 0, 175, 254) Title:@"Max" DisplayColor:customGreen Percentage:69 Reading:310 Unit:@"lumi"];
    [self.maxViewContainer addSubview:maxBarView]; // 8fc842

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
    self.lineGraph.colorPoint = [UIColor colorWithRed:122.0/255.0 green:147.0/255.0 blue:174.0/255.0 alpha:1];
    self.lineGraph.colorBackgroundXaxis = [UIColor whiteColor];
    self.lineGraph.colorTop = [UIColor whiteColor];
    self.lineGraph.colorBottom = [UIColor colorWithRed:193.0/255.0 green:210.0/255.0 blue:218.0/255.0 alpha:1.0];
    self.lineGraph.colorLine = [UIColor colorWithRed:122.0/255.0 green:147.0/255.0 blue:174.0/255.0 alpha:1];
    
    self.lineOneData = [NSMutableArray arrayWithArray:@[@60, @50, @30, @40, @60]];
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
