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
}
@property (nonatomic) float currPercent;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *percentLabel;
@property (nonatomic, weak) CAShapeLayer *barLayer;

@end

@implementation CircularBarView

@synthesize currPercent = _currPercent;
@synthesize percentage = _percentage;
@synthesize barLayer = _barLayer;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setFrame:frame];
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        _currPercent = 0;
        _percentage = 0;
        start = M_PI * 1.0;        // Start and stop angles for the arc (in radians)
        end = start + (M_PI * 2);
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGFloat circleRadius = self.frame.size.width/4;
    CGPoint circleCentre = CGPointMake(self.center.x, self.center.y+25);
    CGFloat startAngle = start;
    CGFloat endAngle = start + 2.0 * M_PI * (MAX(_percentage, _currPercent)/ 100.0);
    
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
    if (_percentage >= _currPercent) {
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
        
        [CATransaction setCompletionBlock:^{
            CGFloat endAngle = start + 2.0 * M_PI * (_percentage/ 100.0);
            UIBezierPath* bezierPath = [UIBezierPath bezierPath];
            [bezierPath addArcWithCenter:circleCentre
                                  radius:circleRadius
                              startAngle:startAngle
                                endAngle:endAngle
                               clockwise:YES];
            [self.barLayer setPath:bezierPath.CGPath];
        }];
        
        CABasicAnimation *animateStroke = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        if (_percentage >= _currPercent) {
            animateStroke.fromValue = [NSNumber numberWithFloat:_currPercent/_percentage];     // Set animation start point
            animateStroke.toValue = [NSNumber numberWithFloat:1.0f];                            // Set animation end point
        } else {
            animateStroke.fromValue = [NSNumber numberWithFloat:1.0f];
            animateStroke.toValue = [NSNumber numberWithFloat:_percentage/_currPercent];
        }
        animateStroke.duration = 0.5;   // default is 0.25                                      // Set animation duration
        [shapeLayer addAnimation:animateStroke forKey:@"strokeEnd"];
        
    } [CATransaction commit];
    
    // Display our percentage as a string
    NSString* textContent = [NSString stringWithFormat:@"%.f", _percentage];
    self.percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44.0f)];
    self.percentLabel.textAlignment = NSTextAlignmentCenter;
    self.percentLabel.center = circleCentre;
    [self.percentLabel setTextColor:[UIColor darkGrayColor]];
    [self.percentLabel setFont:[UIFont boldSystemFontOfSize:25]];
    [self.percentLabel setText:textContent];
    [self addSubview:self.percentLabel];
    
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, self.frame.size.width, 44.0f)];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    [self.textLabel setTextColor:self.displayColor];
    [self.textLabel setText:self.title];
    [self addSubview:self.textLabel];

}


@end
