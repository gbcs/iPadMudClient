//
//  RemoteServer.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 9/27/13.
//
//

#import "RemoteServer.h"
#import "MudClientIpad4AppDelegate.h"
#import <CoreGraphics/CoreGraphics.h>
#import "MudDataCharacters.h"
#import "MudDataButtons.h"
#import "ButtonPanel.h"

#define sessionServiceType @"mudclient"
@class MudClientIpad4ViewController;

@implementation RemoteServer {
        MCSession *session;
        MCPeerID *localPeerID;
        MCNearbyServiceAdvertiser *advertiser;
        NSTimer *statusUpdateTimer;
        NSDictionary *currentStatusReport;
        NSMutableDictionary *peerMode;
    __strong InviteBlock invite;
    NSMutableDictionary *invites;

}

static RemoteServer *sharedSettingsManager = nil;


-(void)displayInvite:(InviteBlock)block forPeer:(MCPeerID *)peer {
    if (invite) {
        block(@NO, session);
        return;
    }
    
    MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudClientIpad4ViewController *displayView = (MudClientIpad4ViewController *)myAppDelegate.viewController;
    
    [displayView dismissPopovers];
    
    InviteView *v = [[InviteView alloc] initWithFrame:CGRectMake((displayView.view.frame.size.width / 2.0f) - 250 ,100,500,300)];
    v.text = [NSString stringWithFormat:@"Allow remote on %@?", peer.displayName];
    v.delegate = self;
  
    [displayView.view addSubview:v];
   
    invite = block;
    
    
}

+ (RemoteServer*)tool
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
    if (!localPeerID) {
        localPeerID = [[MCPeerID alloc] initWithDisplayName:[NSString stringWithFormat:@"%@", [[UIDevice currentDevice] name]]];
    }
    
    if (session) {
        return;
    }
    
    session = [[MCSession alloc] initWithPeer:localPeerID];
    session.delegate = self;
    
    if (!statusUpdateTimer) {
        statusUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(statusUpdateTimerEvent) userInfo:nil repeats:YES];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStatus:) name:@"responseWithStatusReport" object:nil];
    }
}

-(void)stopSession {
    if (statusUpdateTimer) {
        [statusUpdateTimer invalidate];
        statusUpdateTimer = nil;
    }
    
    if (advertiser) {
        [self stopAdvertiser];
    }
    
    if (session) {
        [session disconnect];
        session.delegate = nil;
        session = nil;
    }
}

-(void)stopAdvertiser {
    if (advertiser) {
        [advertiser stopAdvertisingPeer];
        advertiser = nil;
    }
}

-(void)startAdvertiser {
    if (advertiser) {
        return;
    }
    peerMode = [[NSMutableDictionary alloc] initWithCapacity:3];
    
    advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:localPeerID discoveryInfo:nil serviceType:sessionServiceType];
    advertiser.delegate = self;
    [advertiser startAdvertisingPeer];
    
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler {
    NSLog(@"didReceiveInvitationFromPeer:%@", peerID.displayName);
    
    [self displayInvite:invitationHandler forPeer:peerID];
}

-(void)rejectInvitewithView:(UIView *)v {
    NSLog(@"accepted invite: %@", invite);
    BOOL accept = NO;
    
    invite(accept, session);
    
    [v removeFromSuperview];
    
     invite = nil;
}

-(void)acceptInvitewithView:(UIView *)v {
    NSLog(@"accepted invite: %@", invite);
    BOOL accept = YES;
    
    invite(accept, session);
    
    [v removeFromSuperview];
    invite = nil;
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error {
    NSLog(@"advertiser start error:%@", error);
}

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    NSLog(@"session didChangeState:%@:%d", peerID.displayName, state);
    
    if (state == MCSessionStateConnected) {
        [self performSelectorOnMainThread:@selector(updateRemote) withObject:NO waitUntilDone:NO];
    } else {
        [peerMode removeObjectForKey:peerID];
    }
    
    [self performSelectorOnMainThread:@selector(resetViews) withObject:nil waitUntilDone:NO];
}
-(void)resetViews {
    [self performSelector:@selector(resetViews2) withObject:nil afterDelay:1.0];
}

-(void)resetViews2 {
   // NSLog(@"resetviews3");
    MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudClientIpad4ViewController *displayView = (MudClientIpad4ViewController *)myAppDelegate.viewController;
    BOOL isPortrait = YES;
	if ( (myAppDelegate.viewController.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) | (myAppDelegate.viewController.interfaceOrientation == UIInterfaceOrientationLandscapeRight) ) {
		isPortrait = NO;
	}
  
    [displayView updateForRemoteKeyboard];
	
    myAppDelegate.keyboardWentHidden = YES;
    MudInputFooter *footer = (MudInputFooter *)displayView.footer;
    if (![self keyboardRemoteIsConnected]) {
        footer.inputSendAgainButton.hidden = YES;
        footer.inputHistoryButton.hidden = YES;
        footer.inputTextView.userInteractionEnabled = NO;
        [footer.inputTextView becomeFirstResponder];
    } else {
        footer.inputTextView.userInteractionEnabled = YES;
         footer.inputSendAgainButton.hidden = NO;
        footer.inputHistoryButton.hidden = NO;
    }
    [displayView updateViewsForOrientation:isPortrait];
    
}


-(void)updateStatus:(NSNotification *)n {
    currentStatusReport = n.object;
}

-(void)statusUpdateTimerEvent {
    if ([session.connectedPeers count] < 1) {
        return;
    }
    
    if (currentStatusReport) {
        
        MCPeerID *nodeToUpdate = [session.connectedPeers objectAtIndex:0];
        
        NSError *error = nil;
        
        NSData *dataOut = [NSKeyedArchiver archivedDataWithRootObject:currentStatusReport];
        
        [session sendData:dataOut toPeers:@[nodeToUpdate] withMode:MCSessionSendDataReliable error:&error];
        
        if (error) {
            NSLog(@"statusUpdateTimerEvent2:%@:%@", nodeToUpdate, [error localizedDescription]);
        }
        
        currentStatusReport = nil;
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"commandSendStatus" object:nil];
    }
}

-(void)updateRemote {
    
    [self performSelectorOnMainThread:@selector(updateRemote2) withObject:nil waitUntilDone:NO];
}
-(void)updateRemote2 {
    if ( (!session.connectedPeers) || ([session.connectedPeers count]<1)) {
        return;
    }
    
    //current connection list
    //currently selected connection
    //
    MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
    MudSession *mudSession = [myAppDelegate getActiveSessionRef];
    
    NSDictionary *remoteUpdate = @{ @"command" : @"update",
                                    @"connectionList" : [myAppDelegate getSessionListForRemote],
                                    @"currentConnection" : mudSession ?  [[[mudSession.connectionData objectID] URIRepresentation] absoluteString] : @""
                                    
                                    };
   // NSLog(@"ur:%@", remoteUpdate);
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:remoteUpdate options:NSJSONWritingPrettyPrinted error:&error];
    [session sendData:data toPeers:session.connectedPeers withMode:MCSessionSendDataReliable error:&error];
}

-(void)sendButtonList {
    MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
    MudSession *mudSession = [myAppDelegate getActiveSessionRef];
    NSDictionary *response = @{ @"command" : @"answer" , @"answer" : @"ButtonList", @"data" : [self generateRemoteButtonListForCharacter:mudSession.connectionData]};
    NSError *error = nil;
    NSData *outData = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:&error];
    [session sendData:outData toPeers:session.connectedPeers withMode:MCSessionSendDataReliable error:&error];
}

-(void)appendSentTextFromMacro:(NSString *)text {
    if (!text) {
        return;
    }
    
    NSDictionary *response = @{ @"command" : @"AppendText" , @"data" : text};
    NSError *error = nil;
    NSData *outData = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:&error];
    [session sendData:outData toPeers:session.connectedPeers withMode:MCSessionSendDataReliable error:&error];
}

-(void)handlePacket:(NSArray *)args {
    NSData *data = [args objectAtIndex:0];
    MCPeerID *peer = [args objectAtIndex:1];
    
    MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudClientIpad4ViewController *displayView = (MudClientIpad4ViewController *)myAppDelegate.viewController;
	
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    NSString *command = [json objectForKey:@"command"];
    MudSession *mudSession = [myAppDelegate getActiveSessionRef];
    
    if ([command isEqualToString:@"ButtonList"]) {
        [self performSelector:@selector(sendButtonList) withObject:nil afterDelay:0.1];
        [peerMode setObject:@1 forKey:peer];
    } else if ([command isEqualToString:@"SentTextBuffer"]) {
        NSDictionary *response = @{ @"command" : @"answer" , @"answer" : @"SentTextBuffer", @"data" : mudSession.sentLines ? [mudSession.sentLines copy]  : [NSArray array] };
        NSData *data2 = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:&error];
         [session sendData:data2 toPeers:@[ peer ] withMode:MCSessionSendDataReliable error:&error];
        [peerMode setObject:@0 forKey:peer];
        myAppDelegate.softwareKeyboardSeen = NO;
   
        [displayView updateForRemoteKeyboard];
        
    } else if ([command isEqualToString:@"ReceivedTextBuffer"]) {
        NSDictionary *response = @{ @"command" : @"answer" , @"answer" : @"ReceivedTextBuffer", @"data" : [mudSession.connectionText copy] };
        NSData *data2 = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:&error];
       [session sendData:data2 toPeers:session.connectedPeers withMode:MCSessionSendDataReliable error:&error];
    } else if ([command isEqualToString:@"AddNewLineOfText"]) {
        NSString *line = [json objectForKey:@"line"];
        MudInputFooter *footer = (MudInputFooter *)displayView.footer;
        [footer performSelectorOnMainThread:@selector(processLineFromRemote:) withObject:line waitUntilDone:NO];
    } else if ([command isEqualToString:@"CommandHistory"]) {
        NSDictionary *response = @{ @"command" : @"answer" , @"answer" : @"CommandHistory", @"data" : [self commandHistoryForCharacter:mudSession.connectionData] };
        NSData *data2 = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:&error];
        [session sendData:data2 toPeers:session.connectedPeers withMode:MCSessionSendDataReliable error:&error];
    } else if ([command isEqualToString:@"ConnectionList"]) {
        NSString *currentSession =[[[mudSession.connectionData objectID] URIRepresentation] absoluteString];
        NSDictionary *response = @{ @"command" : @"answer" ,
                                    @"answer" : @"ConnectionList",
                                    @"data" : [myAppDelegate getSessionListForRemote] ,
                                    @"currentConnection" : currentSession ?  currentSession : @""
                                    };
        NSData *data2 = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:&error];
       [session sendData:data2 toPeers:session.connectedPeers withMode:MCSessionSendDataReliable error:&error];
    } else if ([command isEqualToString:@"ButtonTap"]) {
        NSNumber *index = [json objectForKey:@"index"];
        NSNumber *layer = [json objectForKey:@"layer"];

        MudDataButtons *button = [self buttonForRemoteAtIndex:[index integerValue]];
        ButtonPanel *panel = (ButtonPanel *)displayView.buttonPanel;
        [panel launchButton:button layer:[layer integerValue]];
    } else if ([command isEqualToString:@"ButtonPress"]) {
        NSNumber *index = [json objectForKey:@"index"];
        ButtonPanel *panel = (ButtonPanel *)displayView.buttonPanel;
        [panel editRemoteButtonAtIndex:[index integerValue]];
    } else if ([command isEqualToString:@"SwitchActiveConnection"]) {
        NSString *connection = [json objectForKey:@"connection"];
        [self performSelectorOnMainThread:@selector(updateWindow:) withObject:connection waitUntilDone:NO];
         } else {
        NSLog(@"Unknown remote command:%@", json);
    }
}

-(void)updateWindow:(NSString *)connection {
    MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
    MudClientIpad4ViewController *displayView = (MudClientIpad4ViewController *)myAppDelegate.viewController;
	
    if (displayView.mudSession1 && [[[[displayView.mudSession1.connectionData objectID] URIRepresentation] absoluteString] isEqualToString:connection]) {
        [displayView switchToWindow:1 newConnection:NO];
    } else if (displayView.mudSession2 && [[[[displayView.mudSession2.connectionData objectID] URIRepresentation] absoluteString] isEqualToString:connection]) {
        [displayView switchToWindow:2 newConnection:NO];
    } else if (displayView.mudSession3 && [[[[displayView.mudSession3.connectionData objectID] URIRepresentation] absoluteString] isEqualToString:connection]) {
        [displayView switchToWindow:3 newConnection:NO];
    } else if (displayView.mudSession4 && [[[[displayView.mudSession4.connectionData objectID] URIRepresentation] absoluteString] isEqualToString:connection]) {
        [displayView switchToWindow:4 newConnection:NO];
    }
   

}

- (void)session:(MCSession *)aSession didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    [self performSelectorOnMainThread:@selector(handlePacket:) withObject:@[ data, peerID] waitUntilDone:YES];
    
}

-(MudDataButtons *)buttonForRemoteAtIndex:(NSInteger)index {
    MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
    MudSession *mudSession = [myAppDelegate getActiveSessionRef];
    
    NSError *error = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MudDataButtons" inManagedObjectContext:myAppDelegate.context];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"slotID=%@ and remote=YES and remoteIndex=%d", mudSession.connectionData, index];
    [request setPredicate:predicate];
    
    
    NSArray *results = [myAppDelegate.context executeFetchRequest:request error:&error];
    
    MudDataButtons *button = nil;
    
    if (results && ([results count]>0)) {
        button = [results objectAtIndex:0];
    }
    
    return button;
}
                                  

-(NSArray *)commandHistoryForCharacter:(MudDataCharacters *)character {
    MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	
    NSError *error = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MudDataPreviousCommands" inManagedObjectContext:myAppDelegate.context];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"slotID=%@ AND showNoMore=NO", character];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"commandText" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSArray *results = [myAppDelegate.context executeFetchRequest:request error:&error];
    
    return results ? results : @[ ];
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    NSLog(@"session didReceiveStreamWithName:%@:%@", peerID.displayName, streamName);
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    NSLog(@"session didStartReceivingResourceWithName:%@:%@", peerID.displayName, resourceName);
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    NSLog(@"session didFinishReceivingResourceWithName:%@:%@", peerID.displayName, resourceName);
}

//- (void)session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void(^)(BOOL accept))certificateHandler {
//    NSLog(@"session didReceiveCertificate:%@", peerID.displayName);
//}

- (NSDictionary *)generateRemoteButtonListForCharacter:(MudDataCharacters *)character {
	MudClientIpad4AppDelegate *appD = (MudClientIpad4AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"MudDataButtons" inManagedObjectContext:appD.context];
	[request setEntity:entity];
	
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"slotID=%@ AND remote=YES", character];
	
    [request setPredicate:predicate];
	
	NSError *error = nil;
	NSArray *results = [appD.context executeFetchRequest:request error:&error];
	
    NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:30];
    
    for (MudDataButtons *b in results) {
        NSInteger iconIndex = [b.iconIndex integerValue];
        NSInteger rmtIndex = [b.remoteIndex integerValue];
        
        if (iconIndex > -1) {
            [list addObject:@[[NSNumber numberWithInteger:rmtIndex],[NSNumber numberWithInteger:iconIndex] ] ];
            
        }
    }
    //NSLog(@"generateRemoteButtonListForCharacter=%@", [list copy]);
    

    
    return  [list copy];
}

-(BOOL)keyboardRemoteIsConnected {
    
    BOOL answer = NO;
    
    for (NSNumber *n in [peerMode allValues]) {
        if ([n integerValue] == 0) {
            answer = YES;
            break;
        }
    }
    
    return answer;
}



@end