//
//  WebSocketManager.m
//  DEMO Framework
//
//  Created by tracyshi on 2015-03-05.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import "DataManager.h"
#import "ParseManager.h"
#import "WebSocketManager.h"
#import "SRWebSocket.h"

#define WEBSOCKET_URL @"wss://iotsocketadapterhackerlounge.us1.hana.ondemand.com/iotframeworksocketadapter/WebSocket"

@interface WebSocketManager() <SRWebSocketDelegate> {
    NSNumber *subscribedSensorId;
    SRWebSocket *srWebSocket;
}

@end

@implementation WebSocketManager

+ (instancetype)sharedManager
{
    static WebSocketManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

#pragma mark - Connection

- (void)connectWebSocket {
    srWebSocket.delegate = nil;
    srWebSocket = nil;
    srWebSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:WEBSOCKET_URL]];
    srWebSocket.delegate = self;
    
    [srWebSocket open];
}


#pragma mark - SRWebSocket delegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    srWebSocket = webSocket;
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@":( Websocket Failed With Error %@", error);
    srWebSocket = nil;
    [self connectWebSocket];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"WebSocket closed with code:%ld, with reason:%@", (long)code, reason);
    srWebSocket = nil;
    [self connectWebSocket];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"Received \"%@\"", message);
        id json = [NSJSONSerialization JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        if (json && json[@"sensor_id"]) // TODO: check if sensor_id equals subscribedSensorId
        {
            [self addNewReadings:message[@"readings"]];
            [[DataManager sharedManager] updateSensorReadings];
        }
}

- (void)addNewReadings:(NSArray*)readings {
    [readings enumerateObjectsUsingBlock:^(NSDictionary *data, NSUInteger index, BOOL *stop){
        SensorReading *sensorReading = [[ParseManager sharedManager] createNewSensorReadingWithData:data];
        NSLog(@"new reading: %@", sensorReading);
        [[DataManager sharedManager].sensorReadings addObject:sensorReading];
    }];
}

- (void)subscribeSensor:(NSNumber *)sensorId {
    subscribedSensorId = sensorId;
    [srWebSocket send:[NSString stringWithFormat:@"{command:\"subscribe\",sensorId:%@}", sensorId]];   // test
}

- (BOOL)isSocketOpen{
    return srWebSocket.readyState == SR_OPEN;
}

@end
