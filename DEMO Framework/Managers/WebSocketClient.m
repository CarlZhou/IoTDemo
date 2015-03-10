//
//  WebSocketClient.m
//  DEMO Framework
//
//  Created by tracyshi on 2015-03-09.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import "WebSocketClient.h"

@implementation WebSocketClient

#pragma mark - Connection

- (instancetype)initWithURL:(NSURL *)url sensorId:(NSNumber *)sensorId
{
    self = [super initWithURL:url];
    if (self) {
        self.subscribedSensorId = sensorId;
        [self open];
    }
    return self;
}

- (void)subscribeSensor
{
    [self send:[NSString stringWithFormat:@"{command:\"subscribe\",sensorId:%@}", self.subscribedSensorId]];
}

- (void)closeConnnection
{
    [self close];
}

@end
