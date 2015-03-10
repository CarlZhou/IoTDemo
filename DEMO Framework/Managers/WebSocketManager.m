//
//  WebSocketManager.m
//  DEMO Framework
//
//  Created by tracyshi on 2015-03-05.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import "WebSocketManager.h"
#import "SRWebSocket.h"
#import "WebSocketClient.h"
#import "DataManager.h"
#import "ParseManager.h"
#import "DataUtils.h"

#define WEBSOCKET_URL @"wss://iotsocketadapterhackerlounge.us1.hana.ondemand.com/iotframeworksocketadapter/WebSocket"

@interface WebSocketManager()  <SRWebSocketDelegate> {
    NSMutableArray *webSocketClients;
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

- (void)openWebSocketOnSensor:(NSNumber *)sensorId
{
    WebSocketClient *webSocket = [[WebSocketClient alloc] initWithURL:[NSURL URLWithString:WEBSOCKET_URL] sensorId:sensorId];
    webSocket.delegate = self;
    [webSocketClients addObject:webSocket];
}

#pragma mark - web socket delegate

- (void)webSocketDidOpen:(WebSocketClient *)webSocket
{
    [webSocket subscribeSensor];
}

- (void)webSocket:(WebSocketClient *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@":( Websocket Failed With Error %@", error);
    NSNumber *failedSensorId = webSocket.subscribedSensorId;
    [webSocketClients removeObject:webSocket];
    [self openWebSocketOnSensor:failedSensorId];// attempt to reconnect the sensor to the websocket
}

- (void)webSocket:(WebSocketClient *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"WebSocket closed with code:%ld, with reason:%@", (long)code, reason);
    NSNumber *failedSensorId = webSocket.subscribedSensorId;
    [webSocketClients removeObject:webSocket];
    [self openWebSocketOnSensor:failedSensorId];// attempt to reconnect the sensor to the websocket
}

- (void)webSocket:(WebSocketClient *)webSocket didReceiveMessage:(id)message
{
    NSLog(@"Received \"%@\"", message);
    id json = [NSJSONSerialization JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    if (json && json[@"sensor_id"] && [json[@"sensor_id"] isEqualToNumber:webSocket.subscribedSensorId]) {
        [[ParseManager sharedManager] parseSensorReadingsDataFromWebSocket:json[@"readings"]Completion:^(NSArray *readings) {
            [[DataManager sharedManager] updateSensorReadings:readings];
        }];
    }
}

@end
