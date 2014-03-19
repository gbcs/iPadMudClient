//
//  RemoteServer.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 9/27/13.
//
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "InviteView.h"

typedef void (^InviteBlock)(BOOL accept, MCSession *session);

@class MudDataCharacters;
@class MudDataButtons;

@interface RemoteServer : NSObject <MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, NSStreamDelegate, InviteDelegate>
+ (RemoteServer*)tool;


-(void)startAdvertiser;
-(void)stopAdvertiser;

-(void)stopSession;

-(void)startSession;

- (NSDictionary*)generateRemoteButtonListForCharacter:(MudDataCharacters *)character;
-(MudDataButtons *)buttonForRemoteAtIndex:(NSInteger)index;

-(void)sendButtonList;

-(void)updateRemote;

-(BOOL)keyboardRemoteIsConnected;
-(void)appendSentTextFromMacro:(NSString *)text;

@end
