//
//  DetailViewController.m
//  DEMO Framework
//
//  Created by Zhou, Zian on 2015-02-17.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import "RightViewController.h"

@interface RightViewController ()

@property (strong, nonatomic) IBOutlet UIView *detailsContainer;
@property (strong, nonatomic) IBOutlet UIView *graphContainer;

@end

@implementation RightViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [[self.detailItem valueForKey:@"s_name"] description];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segControllValueChanged:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self.view bringSubviewToFront:self.detailsContainer];
            break;
        case 1:
            [self.view bringSubviewToFront:self.graphContainer];
            break;
        default:
            break;
    }
}


@end
