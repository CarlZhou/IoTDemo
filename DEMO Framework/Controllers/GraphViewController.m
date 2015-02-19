//
//  GraphViewController.m
//  DEMO Framework
//
//  Created by Sybase on 2015-02-18.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import "GraphViewController.h"
#import "CircularBarView.h"

@interface GraphViewController ()
@property (strong,nonatomic) CircularBarView *currentBarView;
@property (weak, nonatomic) IBOutlet UIView *currentViewContainer;
@property (weak, nonatomic) IBOutlet UIView *avgViewContainer;
@property (weak, nonatomic) IBOutlet UIView *minViewContainer;
@property (weak, nonatomic) IBOutlet UIView *maxViewContainer;


@end

@implementation GraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CircularBarView *currentBarView = [[CircularBarView alloc] initWithFrame:CGRectMake(0, 0, 175, 200)];
    currentBarView.title = @"Current";
    currentBarView.percentage = 65;
    currentBarView.displayColor = [UIColor orangeColor];
    [self.currentViewContainer addSubview:currentBarView];
    
    CircularBarView *avgBarView = [[CircularBarView alloc] initWithFrame:CGRectMake(0, 0, 175, 200)];
    avgBarView.title = @"Average";
    avgBarView.percentage = 19;
    avgBarView.displayColor = [UIColor blueColor];
    [self.avgViewContainer addSubview:avgBarView];

    CircularBarView *minBarView = [[CircularBarView alloc] initWithFrame:CGRectMake(0, 0, 175, 200)];
    minBarView.title = @"Min";
    minBarView.percentage = 31;
    minBarView.displayColor = [UIColor redColor];
    [self.minViewContainer addSubview:minBarView];
    
    CircularBarView *maxBarView = [[CircularBarView alloc] initWithFrame:CGRectMake(0, 0, 175, 200)];
    maxBarView.title = @"Max";
    maxBarView.percentage = 69;
    maxBarView.displayColor = [UIColor greenColor];
    [self.maxViewContainer addSubview:maxBarView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
