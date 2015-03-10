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
    
}

@property (strong, nonatomic) NSMutableDictionary *webSocketClients;

@end

@implementation WebSocketManager

+ (instancetype)sharedManager
{
    static WebSocketManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        sharedMyManager.webSocketClients = [NSMutableDictionary dictionary];
    });
    return sharedMyManager;
}

- (void)openWebSocketForSensor:(NSNumber *)sensorId
{
    if (![self.webSocketClients objectForKey:sensorId]) {
        WebSocketClient *webSocket = [[WebSocketClient alloc] initWithURL:[NSURL URLWithString:WEBSOCKET_URL] sensorId:sensorId];
        webSocket.delegate = self;
        [self.webSocketClients setObject:webSocket forKey:sensorId];
    }
}

- (void)closeWebSocketForSensor:(NSNumber *)sensorId
{
    if ([self.webSocketClients objectForKey:sensorId]) {
        [[self.webSocketClients objectForKey:sensorId] closeConnnection];
        [self.webSocketClients removeObjectForKey:sensorId];
    }
}

#pragma mark - web socket delegate

- (void)webSocketDidOpen:(WebSocketClient *)webSocket
{
    [webSocket subscribeSensor];
}

- (void)webSocket:(WebSocketClient *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@":( Websocket Failed With Error %@", error);
    NSNumber *sensorId = webSocket.subscribedSensorId;
    [self.webSocketClients removeObjectForKey:sensorId];
    [self openWebSocketForSensor:sensorId];// attempt to reconnect the sensor to the websocket
}

- (void)webSocket:(WebSocketClient *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"WebSocket closed with code:%ld, with reason:%@", (long)code, reason);
    NSNumber *sensorId = webSocket.subscribedSensorId;
    [self.webSocketClients removeObjectForKey:sensorId];
    [self openWebSocketForSensor:sensorId]; // attempt to reconnect the sensor to the websocket
}

- (void)webSocket:(WebSocketClient *)webSocket didReceiveMessage:(id)message
{
    NSLog(@"Received \"%@\"", message);
    id json = [NSJSONSerialization JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    if (json && json[@"sensor_id"] && [json[@"sensor_id"] isEqualToNumber:webSocket.subscribedSensorId]) {
        [[ParseManager sharedManager] parseSensorReadingsDataFromWebSocket:json[@"readings"] forSensor:json[@"sensor_id"] Completion:^(NSArray *readings) {
            [[DataManager sharedManager] updateSensorReadings:readings];
        }];
    }
}

@end
