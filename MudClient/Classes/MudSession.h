//
//  mudSession.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 8/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MudDataCharacters.h"
//#import "telnet.h"
#import <CoreText/CoreText.h>
#import <Foundation/Foundation.h>
#import "UIFont+CoreTextExtensions.h"

#import "libtelnet.h"
#import "nvtLine.h"



@interface MudSession : NSObject <UITableViewDataSource, UITableViewDelegate, NSStreamDelegate>{
	NSObject *parentView;
	NSInputStream *connectionStreamIN;									/* Input streams */	
	NSOutputStream *connectionStreamOUT;								/* Output streams */
	MudDataCharacters *connectionData;									/* Reference to the core-data pointer for the connection object */
	NSMutableArray *connectionText;										/* For the tableview */
	int	slotID;															/* Connection Slot reference */
	int	userPressedEnter;												/* User responded to a prompt; used in event handler */
	int lastLineIncomplete;
	int lastLineNumBytes;
	int lastLineArrayIndex;
	NSMutableData *data;
	CFReadStreamRef readStream;
	CFWriteStreamRef writeStream;
	MudDataSettings *settings;
	NSMutableArray *settingsArray;
	NSMutableArray *macros;
	NSMutableArray *triggers;
	NSMutableArray *variables;
    NSMutableArray *aliases;
    NSMutableArray *speedwalking;
    NSMutableArray *touchableTexts;
	int doEcho;
	telnet_t *telnetHandler;
	NSMutableArray *runningMacroStepList;
	int lastLineMatchedTrigger;
	int currentConnectionState;
	uint8_t *buf2;
	uint8_t *buf1;
	BOOL keepSessionData;
	MudDataSessions *sessionRecord;
	nvtLine *nvtLineHandler;
	NSMutableSet *delayedOutputTimers;
	BOOL firstLineReceived;
	NSString *lastCommandStr;
	int lineWidthInChars;
	NSString *commandSeparator;
	BOOL globalTriggersDisabled;
	
	NSOperationQueue *sendQueue;
 
}

@property (nonatomic, strong) NSObject *parentView;
@property(nonatomic, strong) NSInputStream *connectionStreamIN;
@property(nonatomic, strong) NSOutputStream *connectionStreamOUT;
@property(nonatomic, strong) NSMutableArray *connectionText;
@property(nonatomic, strong) MudDataCharacters *connectionData;
@property(nonatomic)	int slotID;
@property(nonatomic)	int lastLineIncomplete;
@property(nonatomic)	int userPressedEnter;
@property(nonatomic)	int lastLineNumBytes;
@property(nonatomic)	int lastLineArrayIndex;
@property(nonatomic, strong) NSMutableData *data;
@property(nonatomic) CFReadStreamRef readStream;
@property(nonatomic) CFWriteStreamRef writeStream;
@property(nonatomic, strong) MudDataSettings *settings;
@property(nonatomic, strong) NSMutableArray *macros;
@property(nonatomic, strong) NSMutableArray *triggers;
@property(nonatomic, strong) NSMutableArray *variables;
@property(nonatomic, strong) NSMutableArray *aliases;
@property(nonatomic, strong) NSMutableArray *speedwalking;
@property(nonatomic, strong) NSMutableArray *touchableTexts;
@property (nonatomic, strong) 	NSMutableArray *settingsArray;
@property (nonatomic) telnet_t *telnetHandler;
@property (nonatomic) int doEcho;
@property (nonatomic, strong) NSMutableArray *runningMacroStepList;
@property (nonatomic) int lastLineMatchedTrigger;
@property (nonatomic, assign) uint8_t *buf2;
@property (nonatomic, assign) uint8_t *buf1;
@property (nonatomic) int currentConnectionState;
@property (nonatomic) BOOL keepSessionData;
@property (nonatomic, strong) MudDataSessions *sessionRecord;
@property (nonatomic, strong) nvtLine *nvtLineHandler;
@property (nonatomic, strong) NSString *lastCommandStr;
@property (nonatomic) int lineWidthInChars;
@property (nonatomic, strong) NSString *commandSeparator;
@property (nonatomic) BOOL globalTriggersDisabled;
@property (nonatomic, strong) NSMutableArray *sentLines;

-(void)openConnection;
-(void)sendLineToMud:(NSString *)lineToSend fromUser:(BOOL)fromUser fromMacro:(BOOL)fromMacro shallDisplay:(BOOL)shallDisplay LogPrevCommands:(BOOL)LogPrevCommands;
-(int)handleIncomingLine:(NSAttributedString *)line updateLineNumber:(int)updateLineNumber;
-(void)pruneConnectionText;
-(void)sendActionText:(NSString *)textToSend;
-(void)sendLocalText:(NSString *)textToSend;
-(void)reconnectSession;
-(void)disconnectSession;
-(void)populateCoreDataArray:(int)whichOne;
-(void)populateSettings;
-(void)processMacro:(MudDataMacros *)macro args:(NSArray *)args triggerExecuted:(BOOL)triggerExecuted ;
- (void)handleEvent2:(char *)bufIn length:(int)len;
-(void)updateRunningMacroStepList:(MudDataMacros *)macro;
-(void)requestNAWS; 
- (void)addDelayedOutputTimer:(NSString *)output delay:(int)delayInSeconds;
- (void)flushDelayedOutputTimers;
- (void)sendDelayedOutput:(id)sender;
-(void)appendActionText:(NSString *)textToSend;
-(void)splitAndSendSpeedwalkPath:(NSString *)t;
@end
