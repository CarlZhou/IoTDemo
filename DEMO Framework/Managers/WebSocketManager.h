//
//  WebSocketManager.h
//  DEMO Framework
//
//  Created by tracyshi on 2015-03-05.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebSocketManager : NSObject

+ (instancetype)sharedManager;
- (void)openWebSocketForSensor:(NSNumber *)sensorId;
- (void)closeWebSocketForSensor:(NSNumber *)sensorId;

@end
