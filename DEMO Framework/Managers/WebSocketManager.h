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

- (void)createWebSocketConnection;
- (void)closeWebSocketConnection;
- (void)subscribeSensor:(NSNumber*)sensorId;
- (void)unsubscribeSensor:(NSNumber*)sensorId;

@end
