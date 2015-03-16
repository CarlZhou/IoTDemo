//
//  WebSocketManager.m
//  DEMO Framework
//
//  Created by tracyshi on 2015-03-05.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import "WebSocketManager.h"
#import "SRWebSocket.h"
#import "DataManager.h"
#import "ParseManager.h"
#import "DataUtils.h"

#define WEBSOCKET_URL @"wss://iotsocketadapterhackerlounge.us1.hana.ondemand.com/iotframeworksocketadapter/WebSocket"

@interface WebSocketManager()  <SRWebSocketDelegate> {
    SRWebSocket *webSocketClient;
}
@property (nonatomic,strong) NSMutableArray *subscriberBuffer;
@property (nonatomic,strong) NSMutableArray *subscribedSensorIds;

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

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.subscribedSensorIds = [NSMutableArray array];
        self.subscriberBuffer = [NSMutableArray array];
    }
    return self;
}

- (void)createWebSocketConnection
{
    webSocketClient = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:WEBSOCKET_URL]];
    webSocketClient.delegate = self;
    [webSocketClient open];
}

- (void)closeWebSocketConnection
{
    webSocketClient.delegate = nil;
    [webSocketClient close];
}

- (void)subscribeSensor:(NSNumber*)sensorId
{
    if (webSocketClient == nil) {
        [self createWebSocketConnection];
    }
    
    if ([self isSocketOpen])
    {
        [webSocketClient send:[NSString stringWithFormat:@"{command:\"subscribe\",sensorId:%@}", sensorId]];
        [self.subscribedSensorIds addObject:sensorId];
    }
    else
    {
        [self.subscriberBuffer addObject:sensorId];
    }
}

- (void)unsubscribeSensor:(NSNumber*)sensorId
{
    if ([self isSocketOpen]) {
        [webSocketClient send:[NSString stringWithFormat:@"{command:\"unsubscribe\",sensorId:%@}", sensorId]];
        [self.subscribedSensorIds removeObject:sensorId];
    }
    else
    {
        [self.subscriberBuffer removeObject:sensorId];
    }
}

- (BOOL)isSocketOpen
{
    return webSocketClient.readyState == SR_OPEN;
}

#pragma mark - web socket delegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    for (int i = 0; i < [self.subscriberBuffer count]; i++)
    {
        NSNumber *sensorId = [self.subscriberBuffer objectAtIndex:i];
        [self subscribeSensor:sensorId];
    }
    [self.subscriberBuffer removeAllObjects];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@":( Websocket Failed With Error %@", error);
    [self createWebSocketConnection];// attempt to reconnect the sensor to the websocket
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"WebSocket closed with code:%ld, with reason:%@", (long)code, reason);
    [self createWebSocketConnection];// attempt to reconnect the sensor to the websocket
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSLog(@"Received \"%@\"", message);
    id json = [NSJSONSerialization JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    if (json && json[@"sensor_id"])
    {
        [[ParseManager sharedManager] parseSensorReadingsDataFromWebSocket:json Completion:^(NSArray *readings) {
            [[DataManager sharedManager] updateSensorReadings:readings];
        }];
    }
    else if (json && json[@"alert"])
    {
        [[ParseManager sharedManager] parseAlertDataFromWebSocket:json Completion:^(Alert *alert) {
//            [[DataManager sharedManager] showAlert:readings];
        }];
    }
}

@end
