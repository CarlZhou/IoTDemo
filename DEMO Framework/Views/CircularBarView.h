//
//  CircularBarView.h
//  DEMO Framework
//
//  Created by Sybase on 2015-02-18.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircularBarView : UIView

@property (nonatomic) float percentage;
@property UIColor *displayColor;
@property (nonatomic, strong) UILabel *titleLabel;

- (id)initWithFrame:(CGRect)frame Title:(NSString*)title DisplayColor:(UIColor*)displayColor Percentage:(CGFloat)percent;
- (void)updateData:(CGFloat)percent;

@end
