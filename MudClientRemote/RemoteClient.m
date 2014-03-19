//
//  RemoteClient.m
//  Mud Client Remote
//
//  Created by Gary Barnett on 9/27/13.
//  Copyright (c) 2013 gbcs. All rights reserved.
//

#import "RemoteClient.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

#define sessionServiceType @"mudclient"

@implementation RemoteClient {
    MCSession *session;
    MCPeerID *localPeerID;
    MCNearbyServiceBrowser *browser;

    NSTimer *heartbeatUpdateTimer;
    int lastHeartbeatSeen;
    
    MCPeerID *remoteServer;
    
    NSMutableArray *availablePeers;
    
    NSArray *mudConnections;
    NSString *currentConnection;
    NSMutableDictionary *mudConnectionSessionData;

}

-(NSArray *)availablePeers {
    return availablePeers ? [availablePeers copy] : [NSArray array];
}


-(NSArray *)connectedPeers {
    return session.connectedPeers ? session.connectedPeers : [NSArray array];
}

static RemoteClient *sharedSettingsManager = nil;

+ (RemoteClient*)tool
{
    if (sharedSettingsManager == nil) {
        sharedSettingsManager = [[super allocWithZone:NULL] init];
    }
    
    return sharedSettingsManager ;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self tool];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

-(void)startSession {
    if (session) {
        NSLog(@"session already running");
        return;
    }
    
    localPeerID = [[MCPeerID alloc] initWithDisplayName:[NSString stringWithFormat:@"%@", [[UIDevice currentDevice] name]]];

    if (!availablePeers) {
        availablePeers = [[NSMutableArray alloc] initWithCapacity:3];
    } else {
        [availablePeers removeAllObjects];
    }

    session = [[MCSession alloc] initWithPeer:localPeerID];
    session.delegate = self;
    
    mudConnections = [NSArray array];
    mudConnectionSessionData = [[NSMutableDictionary alloc] initWithCapacity:4];
}

-(void)stopSession {
    if (browser) {
        [self stopBrowser];
    }
    
    [availablePeers removeAllObjects];
    if (session) {
        [session disconnect];
        session.delegate = nil;
        session = nil;
    }
}



-(void)startBrowser {
    if (browser) {
        NSLog(@"browser already running");
        return;
    }
    
    browser = [[MCNearbyServiceBrowser alloc] initWithPeer:localPeerID serviceType:sessionServiceType];
    browser.delegate = self;
    [browser startBrowsingForPeers];
    
    if (!heartbeatUpdateTimer ) {
        heartbeatUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(heartbeatTimerEvent) userInfo:nil repeats:YES];
    }
    
}

-(void)stopBrowser {
    if (browser) {
        [browser stopBrowsingForPeers];
        browser = nil;
    }
    if (heartbeatUpdateTimer) {
        [heartbeatUpdateTimer invalidate];
        heartbeatUpdateTimer = nil;
    }
    [availablePeers removeAllObjects];

    
}
-(void)disconnect {
    if (session.connectedPeers) {
        [session disconnect];
    }
}

-(void)invitePeer:(MCPeerID *)peerID {
    [browser invitePeer:peerID toSession:session withContext:nil timeout:10.0];
}

- (void)browser:(MCNearbyServiceBrowser *)aBrowser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info {
    if ([availablePeers indexOfObject:peerID] == NSNotFound) {
        [availablePeers addObject:peerID];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"peerListChanged" object:nil];
}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    if ([availablePeers indexOfObject:peerID] != NSNotFound) {
        [availablePeers removeObject:peerID];
    }
    NSLog(@"lost peer:%@", peerID.displayName);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"peerListChanged" object:nil];
}

-(void)gotoMenu {
    AppDelegate *appD = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self disconnect];
    [self stopBrowser];
    [self stopSession];
    [self performSelector:@selector(startSession) withObject:nil afterDelay:0.5f];
    [self performSelector:@selector(startBrowser) withObject:nil afterDelay:1.0f];
    [appD popToRoot];
  
}

- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error {
    NSLog(@"browser start error:%@", error);
}

- (void)session:(MCSession *)asession peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
  //  NSLog(@"session didChangeState:%@:%d", peerID.displayName, state);
    if (state == MCSessionStateConnected) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            NSDictionary *request = @{ @"command" : @"ConnectionList" };
            NSError *error = nil;
            NSData *data = [NSJSONSerialization dataWithJSONObject:request options:NSJSONWritingPrettyPrinted error:&error];
            
            [asession sendData:data toPeers:self.connectedPeers withMode:MCSessionSendDataReliable error:&error];
        });
        [self stopBrowser];
    } else {
        [self performSelectorOnMainThread:@selector(gotoMenu) withObject:nil waitUntilDone:NO];
    }
    
}

-(void)userPressedButtonAtIndex:(NSInteger )index {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSDictionary *request = @{ @"command" : @"ButtonPress", @"index" : [NSNumber numberWithInteger:index] };
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:request options:NSJSONWritingPrettyPrinted error:&error];
        [session sendData:data toPeers:self.connectedPeers withMode:MCSessionSendDataReliable error:&error];
    });
}

-(void)userTappedButtonAtIndex:(NSInteger )index layer:(NSInteger)layer {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSDictionary *request = @{ @"command" : @"ButtonTap", @"index" : [NSNumber numberWithInteger:index], @"layer" : [NSNumber numberWithInteger:layer +1] };
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:request options:NSJSONWritingPrettyPrinted error:&error];
        [session sendData:data toPeers:self.connectedPeers withMode:MCSessionSendDataReliable error:&error];
    });
}

-(void)switchActiveConnection:(NSString *)connection {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSDictionary *request = @{ @"command" : @"SwitchActiveConnection", @"connection" : connection };
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:request options:NSJSONWritingPrettyPrinted error:&error];
        [session sendData:data toPeers:self.connectedPeers withMode:MCSessionSendDataReliable error:&error];
    });
}


-(void)requestButtonList {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSDictionary *request = @{ @"command" : @"ButtonList" };
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:request options:NSJSONWritingPrettyPrinted error:&error];
        [session sendData:data toPeers:self.connectedPeers withMode:MCSessionSendDataReliable error:&error];
    });
}

-(void)requestSentText {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSDictionary *request = @{ @"command" : @"SentTextBuffer" };
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:request options:NSJSONWritingPrettyPrinted error:&error];
        [session sendData:data toPeers:self.connectedPeers withMode:MCSessionSendDataReliable error:&error];
    });
}

-(void)userTypedText:(NSString *)line {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSDictionary *request = @{ @"command" : @"AddNewLineOfText", @"line" : line, @"currentConnection" : currentConnection };
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:request options:NSJSONWritingPrettyPrinted error:&error];
        [session sendData:data toPeers:self.connectedPeers withMode:MCSessionSendDataReliable error:&error];
    });
}


- (void)session:(MCSession *)s didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    NSError *error = nil;
    NSDictionary *rmt = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    //NSLog(@"CMD:%@", rmt);
    NSString *command = [rmt objectForKey:@"command"];
    
    if ([command isEqualToString:@"answer"])   {
        NSString *response = [rmt objectForKey:@"answer"];
        if ([response isEqualToString:@"ConnectionList"]) {
            mudConnections = [rmt objectForKey:@"data"];
            currentConnection = [rmt objectForKey:@"currentConnection"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ConnectionList" object:nil];
        } else  if ([response isEqualToString:@"SentTextBuffer"]) {
            if (currentConnection) {
                NSArray *buffer = [rmt objectForKey:@"data"];
                NSOrderedSet *mySet = [[NSOrderedSet alloc] initWithArray:buffer];
                NSArray *cleanBuffer = [[NSArray alloc] initWithArray:[mySet array]];
                
                
                [[mudConnectionSessionData objectForKey:currentConnection] setObject:cleanBuffer forKey:@"SentTextBuffer"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"sentTextFull" object:cleanBuffer];
            }
        } else  if ([response isEqualToString:@"ReceivedTextBuffer"]) {
            if (currentConnection) {
                NSArray *buffer = [rmt objectForKey:@"data"];
                [[mudConnectionSessionData objectForKey:currentConnection] setObject:buffer forKey:@"ReceivedTextBuffer"];
                NSLog(@"updated ReceivedTextBuffer");
            }
        } else  if ([response isEqualToString:@"CommandHistory"]) {
            if (currentConnection) {
                NSArray *buffer = [rmt objectForKey:@"data"];
                [[mudConnectionSessionData objectForKey:currentConnection] setObject:buffer forKey:@"CommandHistory"];
                NSLog(@"updated CommandHistory");
            }
        } else  if ([response isEqualToString:@"ButtonList"]) {
            if (currentConnection) {
                NSArray *buffer = [rmt objectForKey:@"data"];
                [[mudConnectionSessionData objectForKey:currentConnection] setObject:buffer forKey:@"ButtonList"];
                NSLog(@"updated buttonList");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ButtonList" object:buffer];
            }
        }
    } else if ([command isEqualToString:@"PushNewLineOfText"]) {
        if (currentConnection) {
            NSArray *buffer = [rmt objectForKey:@"data"];
            NSArray *existing = buffer ? [buffer arrayByAddingObjectsFromArray:[rmt objectForKey:@"data"]] : [rmt objectForKey:@"data"];
            [[mudConnectionSessionData objectForKey:currentConnection] setObject:existing forKey:@"ReceivedTextBuffer"];
            NSLog(@"updated ReceivedTextBuffer");
        }
    } else if ([command isEqualToString:@"AppendText"]) {
        if (currentConnection) {
            NSString *text = [rmt objectForKey:@"data"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"appendText" object:text];
            NSLog(@"appendedText:%@", text);
        }
    } else if ([command isEqualToString:@"update"]) {
         mudConnections = [rmt objectForKey:@"connectionList"];
         currentConnection = [rmt objectForKey:@"currentConnection"];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"ConnectionList" object:nil];
    } else {
       NSLog(@"Unknown server command:%@", rmt);
    }


}

-(void)connectionButtonTapped:(id)sender {
    UIBarButtonItem *button = (UIBarButtonItem *)sender;
    NSString *connection = [[[mudConnections objectAtIndex:button.tag] allKeys] objectAtIndex:0];
    [self performSelectorOnMainThread:@selector(switchActiveConnection:) withObject:connection waitUntilDone:NO];
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    NSLog(@"session didStartReceivingResourceWithName:%@:%@", peerID.displayName, resourceName);
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    NSLog(@"session didFinishReceivingResourceWithName:%@:%@", peerID.displayName, resourceName);
}


- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    
}

//- (void)session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void(^)(BOOL accept))certificateHandler {
//     NSLog(@"session didReceiveCertificate:%@", peerID.displayName);
//}

-(void)notifyServerNotResponded {
  //  NSLog(@"notifyServerNotResponded");
}

-(void)heartbeatTimerEvent {
    lastHeartbeatSeen++;
    if (lastHeartbeatSeen > 10) {
        [self performSelector:@selector(notifyServerNotResponded) withObject:nil afterDelay:0.01];
    }
}

-(NSArray *)toolbarButtonsForCurrentConnectionList {
    BOOL isiPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:4];
    int index = 0;
    for (NSDictionary *dict in mudConnections) {
        NSString *name = [[dict allValues] objectAtIndex:0];
        
        if ( (!isiPad) && name && ([name length] > 6)) {
            name = [name substringToIndex:6];
        }
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:name style:UIBarButtonItemStylePlain target:[RemoteClient tool] action:@selector(connectionButtonTapped:)];
        NSString *connection = [[dict allKeys] objectAtIndex:0];
        if ([currentConnection isEqualToString:connection]) {
            [button setTintColor:[UIColor blueColor]];
        }
        
        button.tag = index;
        [list addObject:button];
        index++;
    }
    
    return [list copy];
}

@end
