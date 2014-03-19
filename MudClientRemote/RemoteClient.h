//
//  RemoteClient.h
//  Mud Client Remote
//
//  Created by Gary Barnett on 9/27/13.
//  Copyright (c) 2013 gbcs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

#define kRoleKeyboard 0
#define kRoleButtons 1
#define kRoleDisplay 2

@interface RemoteClient : NSObject <MCSessionDelegate, MCNearbyServiceBrowserDelegate, NSStreamDelegate>
@property (nonatomic, assign) NSInteger role;
@property (nonatomic, strong) NSString *selectedConnection;
@property (nonatomic, assign) NSInteger buttonLayer;
@property (nonatomic, assign) BOOL connecting;

+ (RemoteClient*)tool;

-(void)startBrowser;
-(void)stopBrowser;
-(void)stopSession;
-(void)startSession;

-(NSArray *)connectedPeers;
-(NSArray *)availablePeers;

-(void)invitePeer:(MCPeerID *)peerID;

-(void)disconnect;

-(void)requestSentText;
-(void)userTypedText:(NSString *)line;

-(void)requestButtonList;

-(void)userPressedButtonAtIndex:(NSInteger )index;
-(void)userTappedButtonAtIndex:(NSInteger )index layer:(NSInteger)layer;

-(NSArray *)toolbarButtonsForCurrentConnectionList;

-(void)connectionButtonTapped:(id)sender;

-(void)gotoMenu;

@end
