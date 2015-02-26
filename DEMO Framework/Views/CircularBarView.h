//
//  CircularBarView.h
//  DEMO Framework
//
//  Created by tracyshi on 2015-02-18.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircularBarView : UIView

@property (nonatomic) float percentage;
@property (nonatomic) float reading;
@property (nonatomic) double animatingTime;
@property (nonatomic, strong) NSString *unit;
@property (nonatomic, strong) UIColor *displayColor;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *percentLabel;
@property (nonatomic, strong) UILabel *readingLabel;

- (id)initWithFrame:(CGRect)frame Title:(NSString*)title DisplayColor:(UIColor*)displayColor Percentage:(CGFloat)percent Reading:(CGFloat)reading Unit:(NSString*)unit;
- (void)updatePercentage:(CGFloat)percent Reading:(CGFloat)reading Unit:(NSString*)unit;

@end
