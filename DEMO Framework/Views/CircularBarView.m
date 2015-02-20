//
//  CircularBarView.m
//  DEMO Framework
//
//  Created by Sybase on 2015-02-18.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import "CircularBarView.h"

@interface CircularBarView () {
    CGFloat start;
    CGFloat end;
    float currPercent;
}

@property (nonatomic, weak) CAShapeLayer *barLayer;

@end

@implementation CircularBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:frame];
        start = M_PI * 1.0;        // Start and stop angles for the arc (in radians)
        end = start + (M_PI * 2);
        currPercent = 0;
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        self.displayColor = [UIColor blackColor];
        
        self.percentage = 0;
        self.percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44.0f)];
        self.percentLabel.textAlignment = NSTextAlignmentCenter;
        [self.percentLabel setTextColor:[UIColor darkGrayColor]];
        [self.percentLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [self addSubview:self.percentLabel];
        
        self.reading = 0;
        self.readingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 175, self.frame.size.width, 44.0f)];
        self.readingLabel.textAlignment = NSTextAlignmentCenter;
        [self.readingLabel setTextColor:[UIColor darkGrayColor]];
        [self.readingLabel setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:self.readingLabel];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame Title:(NSString*)title DisplayColor:(UIColor*)displayColor Percentage:(CGFloat)percent Reading:(CGFloat)reading Unit:(NSString*)unit
{
    self = [self initWithFrame:frame];
    if (self) {
        self.displayColor = displayColor;
        self.percentage = percent;
        self.reading = reading;
        self.unit = @"Lumens";
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, self.frame.size.width, 44.0f)];
        self.titleLabel.text = title;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [self.titleLabel setTextColor:self.displayColor];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGFloat circleRadius = self.frame.size.width/4;
    CGPoint circleCentre = CGPointMake(self.center.x, self.center.y);
    CGFloat startAngle = start;
    CGFloat endAngle = start + 2.0 * M_PI * (MAX(self.percentage, currPercent)/ 100.0);
    
    // Create our arc, with the correct angles
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath addArcWithCenter:circleCentre
                          radius:circleRadius
                      startAngle:startAngle
                        endAngle:endAngle
                       clockwise:YES];
    
    // Create a shape layer that wraps the path so that animation can be applied on top of it
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    if (self.barLayer) {
        shapeLayer = self.barLayer;
    }
    [shapeLayer setPath:bezierPath.CGPath];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    [shapeLayer setLineWidth:3];
    if (self.percentage >= currPercent) {
        [shapeLayer setStrokeStart:0];
        [shapeLayer setStrokeEnd:1.0];
    } else {
        [shapeLayer setStrokeStart:0];
        [shapeLayer setStrokeEnd:1.0];
    }
    [shapeLayer setStrokeColor:self.displayColor.CGColor];
    [self.layer addSublayer:shapeLayer];
    self.barLayer = shapeLayer;
    
    [CATransaction begin]; {
        
        [CATransaction setCompletionBlock:^{        // Upon completion of the animation, adjust the path to the new length
            CGFloat endAngle = start + 2.0 * M_PI * (self.percentage/ 100.0);
            UIBezierPath* bezierPath = [UIBezierPath bezierPath];
            [bezierPath addArcWithCenter:circleCentre
                                  radius:circleRadius
                              startAngle:startAngle
                                endAngle:endAngle
                               clockwise:YES];
            [self.barLayer setPath:bezierPath.CGPath];
        }];
        
        CABasicAnimation *animateStroke = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        if (self.percentage >= currPercent) {
            animateStroke.fromValue = [NSNumber numberWithFloat:currPercent/self.percentage];   // Set animation start point
            animateStroke.toValue = [NSNumber numberWithFloat:1.0f];                            // Set animation end point
        } else {
            animateStroke.fromValue = [NSNumber numberWithFloat:1.0f];
            animateStroke.toValue = [NSNumber numberWithFloat:self.percentage/currPercent];
        }
        animateStroke.duration = 0.5;                                                           // Set animation duration, default is 0.25
        [shapeLayer addAnimation:animateStroke forKey:@"strokeEnd"];
        
    } [CATransaction commit];
    
    // Display our percentage as a string
    NSString* percentText = [NSString stringWithFormat:@"%.f%@", self.percentage, @"%"];
    self.percentLabel.center = circleCentre;
    [self.percentLabel setText:percentText];
    
    NSString* readingText;
    if (self.reading != 0) {
        // Display current reading
        readingText = [NSString stringWithFormat:@"%.f %@", self.reading, self.unit];
        [self.readingLabel setText:readingText];
    }
}

- (void)updatePercentage:(CGFloat)percent Reading:(CGFloat)reading Unit:(NSString*)unit
{
    currPercent = self.percentage;
    self.percentage = percent;
    self.reading = reading;
    self.unit = unit;
    [self setNeedsDisplay];
}

@end
