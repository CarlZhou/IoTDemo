//
//  WebSocketClient.h
//  DEMO Framework
//
//  Created by tracyshi on 2015-03-09.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"

@interface WebSocketClient : SRWebSocket

@property (nonatomic,strong) NSNumber *subscribedSensorId;
- (instancetype)initWithURL:(NSURL *)url sensorId:(NSNumber *)sensorId;
- (void)subscribeSensor;

@end
