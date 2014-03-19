//
//  MudSession.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 8/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MudSession.h"
#import	"MudPreviousCommands.h"
#import "MudClientIpad4ViewController.h"
#import "MudDataCharacters.h"
#import "MudDataSettings.h"
#import "MudDataTriggers.h"
#import "MudDataMacros.h"
#import "MudDataPreviousCommands.h"
#import <zlib.h>
#import "libtelnet.h"
#import "Macros.h"
#import "MudClientIpad4AppDelegate.h"
#import "MudDataMacroSteps.h"
#import "MudDataVariables.h"
#import "MudInputFooter.h"
#import "MudClientIpad4AppDelegate.h"
#import "MudVariables.h"
#import "MudDataSessions.h"
#import "MudDataSessionData.h"
#import "nvtLine.h"
#import "MudDataSpeedwalking.h"
#import "MudDataTouchableTexts.h"

@implementation MudSession

@synthesize parentView, connectionStreamIN, connectionStreamOUT, connectionText, connectionData, slotID, userPressedEnter;
@synthesize lastLineIncomplete, lastLineNumBytes, lastLineArrayIndex, data, readStream, writeStream, commandSeparator;
@synthesize settings, macros, triggers, variables, settingsArray, lastCommandStr, lineWidthInChars, globalTriggersDisabled;
@synthesize telnetHandler, doEcho, runningMacroStepList, lastLineMatchedTrigger, buf2, buf1, currentConnectionState, keepSessionData, sessionRecord, nvtLineHandler;
@synthesize speedwalking, touchableTexts, aliases;

static const telnet_telopt_t telopts[] = {
	{ TELNET_TELOPT_ECHO,		TELNET_WONT, TELNET_DO   },
	{ TELNET_TELOPT_TTYPE,		TELNET_WILL, TELNET_DONT },
	{ TELNET_TELOPT_COMPRESS2,	TELNET_WONT, TELNET_DO  },
	{ TELNET_TELOPT_NAWS,		TELNET_WILL, TELNET_DONT  },
	{ -1, 0, 0 }
};


static const telnet_telopt_t teloptsNoCompression[] = {
	{ TELNET_TELOPT_ECHO,		TELNET_WONT, TELNET_DO   },
	{ TELNET_TELOPT_TTYPE,		TELNET_WILL, TELNET_DONT },
	{ TELNET_TELOPT_COMPRESS2,	TELNET_WONT, TELNET_DONT  },
	{ TELNET_TELOPT_NAWS,		TELNET_WILL, TELNET_DONT  },
	{ -1, 0, 0 }
};

static void _event_handler(telnet_t *telnet, telnet_event_t *ev, void *user_data) {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = (__bridge MudSession *)user_data;
	
	switch (ev->type) {
			/* data received */
		case TELNET_EV_DATA:
			//printf("%.*s", (int)ev->data.size, ev->data.buffer);
			[session handleEvent2:ev->data.buffer length:ev->data.size];
			break;
			/* data must be sent */
		case TELNET_EV_SEND:
			//_send(sock, ev->data.buffer, ev->data.size);
			[session.connectionStreamOUT write:(uint8_t *)ev->data.buffer maxLength:ev->data.size];
			break;
			/* request to enable remote feature (or receipt) */
		case TELNET_EV_WILL:
			/* we'll agree to turn off our echo if server wants us to stop */
			if (ev->neg.telopt == TELNET_TELOPT_ECHO)
				session.doEcho = 0;
			NSLog(@"TELNET<-WILL:%d", ev->neg.telopt); 
			break;
			/* notification of disabling remote feature (or receipt) */
		case TELNET_EV_WONT:
			if (ev->neg.telopt == TELNET_TELOPT_ECHO)
		 		session.doEcho = 1;
			break;
			/* request to enable local feature (or receipt) */
		case TELNET_EV_DO:
			NSLog(@"TELNET<-DO:%d", ev->neg.telopt); 
			if (ev->neg.telopt == TELNET_TELOPT_NAWS) {
				char buf[4];
				buf[0] = 0;
				buf[1] = [myAppDelegate textWindowWidth];
				buf[2] = 0;
				buf[3] = [myAppDelegate textWindowHeight];
				telnet_subnegotiation(session.telnetHandler, TELNET_TELOPT_NAWS, buf, 4);
				NSLog(@"TELNET->NAWS response buffer sent: %d %d %d %d", 0, [myAppDelegate textWindowWidth], 0, [myAppDelegate textWindowHeight] );
			}
			break;
			/* demand to disable local feature (or receipt) */
		case TELNET_EV_DONT:
			break;
			/* respond to TTYPE commands */
		case TELNET_EV_TTYPE:
			/* respond with our terminal type, if requested */
			if (ev->ttype.cmd == TELNET_TTYPE_SEND) {
				telnet_ttype_is(telnet, "XTERM-COLOR");
			}
			break;
			/* respond to particular subnegotiations */
		case TELNET_EV_SUBNEGOTIATION:
			break;
			/* error */
		case TELNET_EV_ERROR:
			NSLog(@"libtelnet error: %s", ev->error.msg);
			exit(1);
		default:
			/* ignore */
			break;
	}
}

-(void)requestNAWS {
	return;
	
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
	
	if (self.telnetHandler) {
		char buf[4];
		buf[0] = 0;
		buf[1] = [myAppDelegate textWindowWidth];
		buf[2] = 0;
		buf[3] = [myAppDelegate textWindowHeight];
		telnet_subnegotiation(session.telnetHandler, TELNET_TELOPT_NAWS, buf, 4);
		NSLog(@"TELNET->NAWS response");
		
	}
	 
}



-(void)splitAndSendSpeedwalkPath:(NSString *)t {
    
    static NSString *lineSeparationRegex = @"(?:\r\n|[\n\v\f\r\302\205\\p{Zl}\\p{Zp}])";
    
    NSArray *lines = [RegExpTools arrayOfComponentsFromString:t withRegExp:lineSeparationRegex];
    
    //[self sendLineToMud:@"" fromUser:YES fromMacro:YES shallDisplay:NO LogPrevCommands:NO];
    
    for (NSString *l in lines) {
        
        NSArray *commands = [l componentsSeparatedByString:[settings speedwalkSeperator]];
        for (NSString *c in commands) {
            [self sendLineToMud:[NSString stringWithFormat:@"%@\n", c] fromUser:YES fromMacro:NO shallDisplay:NO LogPrevCommands:NO];
        }
    }
}


-(void)updateRunningMacroStepList:(MudDataMacros *)macro {
	
	
	if (self.runningMacroStepList) {
		self.runningMacroStepList = nil;
	}
	
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	
	//Get a list of the steps loaded into an array.
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"MudDataMacroSteps" inManagedObjectContext:myAppDelegate.context];
	[request setEntity:entity];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"macroID=%@", macro];
	[request setPredicate:predicate];
	
	// Order the events by creation date, most recent first.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"step" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];

	
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	self.runningMacroStepList = [[myAppDelegate.context executeFetchRequest:request error:&error] mutableCopy];
	

}

-(void)processMacro:(MudDataMacros *)macro args:(NSArray *)args triggerExecuted:(BOOL)triggerExecuted {

	//NSLog(@"Processing Macro: %@; args: %@", macro.title, args);
	
	
	[self updateRunningMacroStepList:macro];
		
	// Set self's events array to the mutable array, then clean up.
	
	NSMutableArray *steps = self.runningMacroStepList;

	// Run them :-)
	
	int stepCount = [steps count];

	int stopRunning = 0;
	
	if (stepCount <1) {
		return;
	}
	
	int currentStepIndex = -1;
	MudDataMacroSteps *step = nil;
	MudDataVariables *v1 = nil;
	MudDataVariables *v2 = nil;
	
	//Create macro -> variable assign
	NSMutableDictionary *labelDict = [[NSMutableDictionary alloc] init];
	
	for (int x=0;x<stepCount;x++) {
		step = (MudDataMacroSteps *)[steps objectAtIndex:x];
		if ([[step command] intValue] == mMacroCommandLabelAssign) {
			[labelDict setObject:[NSNumber numberWithInt:x] forKey:[step value1]];
			//NSLog(@"%d: label: %@", x+1, [step value1]);
		}
	}

	int scriptCycles = 0;
	
	for (;!stopRunning;) {
		currentStepIndex++;
		scriptCycles++;
		if (scriptCycles >100) {
			//NSLog(@"Aborted after 100 cycles.");
			[self sendLineToMud:@"Macro Too Long: Aborted after 100 steps." fromUser:NO fromMacro:NO shallDisplay:YES LogPrevCommands:NO];
			stopRunning = 1;
		}
		if (currentStepIndex >= stepCount) {
			stopRunning = 1;
		} else {
			step = (MudDataMacroSteps *)[steps objectAtIndex:currentStepIndex];
			if (!step) {
				stopRunning = 1;
			}
			v1 = [step firstVariable];
			v2 = [step secondVariable];
			int command = [[step command] intValue];
			switch (command) {
				case mMacroCommandModVarMacroArgument:	
				case mMacroCommandModVarMacroArgumentAppend:
				{	
					int whichArg = [[step value1] intValue] -1;
					
					int argTop = [args count] -1;
					if (command == mMacroCommandModVarMacroArgument) {
						if (argTop < whichArg) {
							[v1 setCurrentValue:nil];
						} else {	
							//NSLog(@"%@", arg);
							[v1 setCurrentValue:[args objectAtIndex:whichArg]];
						}
					} else {
						if (argTop >= whichArg) {
							[v1 setCurrentValue:[NSString stringWithFormat:@"%@ %@", [v1 currentValue], [args objectAtIndex:whichArg]]];
						}
					}
				}
					
					break;
				case mMacroCommandModVarSetConstant:
					//NSLog(@"Setting %@ to %@", [v1 title], [step value1]);
					[v1 setCurrentValue:[step value1]];
					break;
				case mMacroCommandModVarAddConstant:
				{
					int originalValue = [[v1 currentValue] intValue];
					originalValue += [[step value1] intValue];
					[v1 setCurrentValue:[NSString stringWithFormat:@"%d", originalValue]];
				}
					break;
				case mMacroCommandModVarSubtractConstant:
				{
					int originalValue = [[v1 currentValue] intValue];
					originalValue -= [[step value1] intValue];
					[v1 setCurrentValue:[NSString stringWithFormat:@"%d", originalValue]];
				}
					break;
				case mMacroCommandModVarMultiplyConstant:
				{
					int originalValue = [[v1 currentValue] intValue];
					originalValue = originalValue * [[step value1] intValue];
					[v1 setCurrentValue:[NSString stringWithFormat:@"%d", originalValue]];
				}
					break;case mMacroCommandModVarDivideConstant:	
				{
					int originalValue = [[v1 currentValue] intValue];
					int divisor = [[step value1] intValue];
					if (divisor == 0) {
				
						[self sendLineToMud:[NSString stringWithFormat:@"Division by zero avoided: step %d/%d. Script ends.", currentStepIndex, stepCount] fromUser:NO fromMacro:NO shallDisplay:YES LogPrevCommands:NO];
						stopRunning = 1;
					} else {
						originalValue =  originalValue / divisor;
					}
					[v1 setCurrentValue:[NSString stringWithFormat:@"%d", originalValue]];
				}
					break;
				case mMacroCommandModVarAddVariable:
				{
					int originalValue = [[v1 currentValue] intValue];
					originalValue += [[v2 currentValue] intValue];;
					[v1 setCurrentValue:[NSString stringWithFormat:@"%d", originalValue]];
				}
					break;
				case mMacroCommandModVarSubtractVariable:
				{
					int originalValue = [[v1 currentValue] intValue];
					originalValue -= [[v2 currentValue] intValue];;
					[v1 setCurrentValue:[NSString stringWithFormat:@"%d", originalValue]];
				}
					break;	
				case mMacroCommandModVarMultiplyVariable:
				{
					int originalValue = [[v1 currentValue] intValue];
					originalValue = originalValue * [[v2 currentValue] intValue];;
					[v1 setCurrentValue:[NSString stringWithFormat:@"%d", originalValue]];
				}
					break;
				case mMacroCommandModVarDivideVariable:				// ""
				{
					int originalValue = [[v1 currentValue] intValue];
					int divisor = [[v2 currentValue] intValue];
					if (divisor == 0) {
						// skip it
						[self sendLineToMud:[NSString stringWithFormat:@"Division by zero avoided: step %d/%d. Script ends.", currentStepIndex, stepCount] fromUser:NO fromMacro:NO shallDisplay:YES LogPrevCommands:NO];
						stopRunning = 1;
					} else {
						originalValue =  originalValue / divisor;
					}
					[v1 setCurrentValue:[NSString stringWithFormat:@"%d", originalValue]];
				}
					break;	
				case mMacroCommandModVarSetFormattedText:
				case mMacroCommandSendFormattedTextServer:	
				case mMacroCommandSendFormattedTextLocal:	
				{
					
					// Make a copy of our output string for the regex to use
					
					NSString *outString = [step value1];
					
					// Pull in our mapped variable references
					
					int rowCount = [self.variables count];
					
					// Create a list of strings with references to variable ids
					NSString *formatVarList = [step formatVariableList];
                    
                    
					NSArray *formatVarArray = [formatVarList componentsSeparatedByString:@","];
                    
					
					int delay = [step.delay intValue];
					
					// cycle through our variable list, replacing $x with the variable's contents
					int varOfset = 0;
					for (NSString *idValStr in formatVarArray) {
						int idVal = [idValStr intValue];
						varOfset++;
						char searchChar;
						if (varOfset < 10) {
							searchChar = (char)(48 + varOfset);
						} else {
							searchChar = (char)(97 + varOfset - 10);
						}
						if (idVal == -10) {
							NSString *replString = [NSString stringWithFormat:@"%@", [self.connectionData characterName]];
                       
                            outString = [RegExpTools replaceMatchesInString:outString usingRegExp:[NSString stringWithFormat:@"\\$%c",searchChar] withTemplate:replString caseSensitivity:YES];
                            
                            if (delay < 1) {
								delay = 1;
							} 
						} else if (idVal == -11) {
							NSString *replString = [NSString stringWithFormat:@"%@", [self.connectionData password]];
                            outString = [RegExpTools replaceMatchesInString:outString usingRegExp:[NSString stringWithFormat:@"\\$%c",searchChar] withTemplate:replString caseSensitivity:YES];
                        } else {
							for (int x= 0;x<rowCount;x++) {
								if ([[[self.variables objectAtIndex:x] id] intValue] == idVal) {
									MudDataVariables *variable = [self.variables objectAtIndex:x];
									NSString *replString = [NSString stringWithFormat:@"%@", [variable currentValue] ? [variable currentValue] : @""];
                                    outString = [RegExpTools replaceMatchesInString:outString usingRegExp:[NSString stringWithFormat:@"\\$%c",searchChar] withTemplate:replString caseSensitivity:YES];
									//outString = [outString stringByReplacingOccurrencesOfRegex:[NSString stringWithFormat:@"\\$%c",searchChar] withString:replString];
								}
							}
						}
					}
					
					// send
					if (command == mMacroCommandModVarSetFormattedText) {
						[[step firstVariable] setCurrentValue:outString];
					} else if (command == mMacroCommandSendFormattedTextServer) {
						if ([outString length]) {
							if (delay>0) {
								[self addDelayedOutputTimer:outString delay:delay];
							} else {
								
								NSString *lineWithEnding = [NSString stringWithFormat:@"%@%@", outString, [[self.settings standardLineFeed] boolValue] ? @"\r\n" : @"\n"];
								uint8_t *str;
								if (self.nvtLineHandler.encoding == kCFStringEncodingUTF8) {
									str = (uint8_t *) [lineWithEnding cStringUsingEncoding:NSUTF8StringEncoding];
								} else {
									str = (uint8_t *) [lineWithEnding cStringUsingEncoding:NSASCIIStringEncoding];
								}
								int telnetResult = telnet_printf(self.telnetHandler, "%s", str);
								if(!telnetResult) {
									NSLog(@"telnet printf error in macro send: %d", telnetResult);
								}
                                
                                if ([[self.settings EchoMacroOutput] boolValue] == YES) {
                                    [self sendLineToMud:lineWithEnding fromUser:NO fromMacro:YES shallDisplay:YES LogPrevCommands:NO];
                               }
                                
							}
						}
					} else if (command == mMacroCommandSendFormattedTextLocal) {
						[self sendLocalText:outString];
					} 				
				}
					break;
				case mMacroCommandLabelAssign:	
					//these are read in before the script runs. 
					break;
				case mMacroCommandBranchUnconditional:
				{
					
					// Goto line identified by label, if not found, end macro
					
					NSString *tmpDest = [labelDict objectForKey:[step value1]];
					if (tmpDest == nil) {
						[self sendLineToMud:[NSString stringWithFormat:@"Destination Label for Branch Not Found: step %d/%d. Script ends.", currentStepIndex, stepCount] fromUser:NO fromMacro:NO shallDisplay:YES LogPrevCommands:NO];
						stopRunning = 1;
						break;
					} else {
						int destStep = [[labelDict objectForKey:[step value1]] intValue];
						currentStepIndex = destStep -1;
						//NSLog(@"Branching to step: %d (loop will increment at top)", currentStepIndex);
					}
				}
					break;
				case mMacroCommandBranchEquality:
					if ( [[v1 currentValue] compare:[v2 currentValue]] == NSOrderedSame) {
						int destStep = [[labelDict objectForKey:[step value1]] intValue];
						currentStepIndex = destStep -1;
						//NSLog(@"Branching to step: %d (loop will increment at top)", currentStepIndex);
					}
					break;
				case mMacroCommandBranchInequality:
					if ( [[v1 currentValue] compare:[v2 currentValue]] != NSOrderedSame) {
						int destStep = [[labelDict objectForKey:[step value1]] intValue];
						currentStepIndex = destStep -1;
						//NSLog(@"Branching to step: %d (loop will increment at top)", currentStepIndex);
					}
					break;
				case mMacroCommandBranchGreaterThan:
				{
					int v1int = [[v1 currentValue] intValue];
					int v2int = [[v2 currentValue] intValue];
					if (v1int >v2int) {
						int destStep = [[labelDict objectForKey:[step value1]] intValue];
						currentStepIndex = destStep -1;
						//NSLog(@"Branching to step: %d (loop will increment at top)", currentStepIndex);
					}
				}
					break;
				case mMacroCommandBranchLessThan:
				{
					int v1int = [[v1 currentValue] intValue];
					int v2int = [[v2 currentValue] intValue];
					if (v1int < v2int) {
						int destStep = [[labelDict objectForKey:[step value1]] intValue];
						currentStepIndex = destStep -1;
						//NSLog(@"Branching to step: %d (loop will increment at top)", currentStepIndex);
					}
				}
					break;
				case mMacroCommandEndMacro:	
					stopRunning = 1;
					break;
				case mMacroCommandRunMacro:
				{
					int rowCount = [self.macros count];
					int idVal = [[step value1] intValue];
					int found=0;
					for (int x= 0;x<rowCount;x++) {
						if ([[[self.macros objectAtIndex:x] id] intValue] == idVal) {

							//  - update the macro reference here
							macro = [self.macros objectAtIndex:x];
							//  - reset state variables
							[self updateRunningMacroStepList:macro];
							steps = self.runningMacroStepList;
							stepCount = [steps count];
							currentStepIndex = -1;
							found=1;
							labelDict = nil;
							labelDict = [[NSMutableDictionary alloc] init];
							for (int y=0;y<stepCount;y++) {
								step = (MudDataMacroSteps *)[steps objectAtIndex:y];
								if ([[step command] intValue] == mMacroCommandLabelAssign) {
									[labelDict setObject:[NSNumber numberWithInt:y] forKey:[step value1]];
									//NSLog(@"%d: label: %@", x+1, [step value1]);
								}
							}
							break;
						}
					}
					
					if (!found	) {
						NSLog(@"Chained macro not found");
						[self sendLineToMud:[NSString stringWithFormat:@"Macro Not Found in step %d/%d. Script ends.", currentStepIndex, stepCount] fromUser:NO fromMacro:NO shallDisplay:YES LogPrevCommands:NO];
						stopRunning = 1;
					} 
				}	
					break;	
			}
		}
	}
	//[self sendActionText:textToSend];
	
	MudClientIpad4ViewController *displayView = (MudClientIpad4ViewController *)self.parentView;
	MudVariables *mudVariables = (MudVariables *)displayView.mudVariables;
	if (mudVariables) {
		[mudVariables.tv reloadData];
	}
	
	

}


- (NSString *) RTrim:(NSString *)inStr {
 
    
    NSInteger i=[inStr length]-1;
    if (i==-1) return inStr;
    
    while (i>0)
    {
        unichar thechar = [inStr characterAtIndex:i];
        if (thechar==' ' || thechar=='\n')
        {
            i--;
        }
        else
        {
            break;
        }
        
    }
	
	NSRange srange=NSMakeRange(0,i+1);
	
    return [inStr substringWithRange:srange];

}

-(void)processTriggers:(NSString *)textLine withConnection:(int)Connection {
	
	if (globalTriggersDisabled) {
		return;
	}
	
	// NSLog(@"Trigger: %@ Connection:%d", textLine, Connection);
	textLine = [self RTrim:textLine];
	
	self.lastLineMatchedTrigger = 0;
	for (MudDataTriggers *trigger in self.triggers) {
		if ([[trigger triggerEnabled] boolValue]) {
			NSString *regexpTest = [trigger expression];
		
			if (regexpTest && ([regexpTest length] >0))  {
		
				NSRange range;
				range.location = 0;
				range.length = [textLine length];
                
                NSArray *matches = [RegExpTools arrayOfCaptureComponentMatches:textLine withRegExp:regexpTest];
 
                int matchCount = [matches count];
              
				if (matchCount>0) {
					self.lastLineMatchedTrigger = 1;
					MudDataMacros *tMacro = [trigger trigmacro];
					if (tMacro) {
						[self processMacro:tMacro args:matches triggerExecuted:YES];
					}
					
					if ( [[trigger DisableOnUse] boolValue]) {
						[trigger setTriggerEnabled:[NSNumber numberWithBool:NO]];
					}
				}
			}
		}
	}
}


-(void)disconnectSession {
	
	[self flushDelayedOutputTimers];
	
	[sendQueue cancelAllOperations];
	[sendQueue waitUntilAllOperationsAreFinished];
	
	sendQueue = nil;
	
	[self.connectionStreamIN close];
	[self.connectionStreamOUT close];
	
	
	[self.connectionStreamIN removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[self.connectionStreamOUT removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	
	self.connectionStreamIN = nil;
	self.connectionStreamOUT = nil;
	
	
	self.lastLineNumBytes = 0;
	self.lastLineIncomplete = 0;
	self.lastLineArrayIndex = 0;
	
//	telnet_free(self.telnetHandler);
	self.telnetHandler = nil;
	MudClientIpad4ViewController *displayView = (MudClientIpad4ViewController *)self.parentView;
	MudInputFooter *footView =(MudInputFooter *)displayView.footer;
	
	self.currentConnectionState = 2;
	[footView updateReconnectState:2 session:self];
	
}

-(void)reconnectSession {
	
	[self disconnectSession];
	[self openConnection];
	
}


-(void)sendLocalText:(NSString *)textToSend {
	// parse into individual lines; feed through to linetomud
	static NSString *regexString = @"(?:\r\n|[\n\v\f\r\302\205\\p{Zl}\\p{Zp}])"; 
	
	if (!textToSend) {
		return;
	}
	
    NSArray *lines = [RegExpTools arrayOfComponentsFromString:textToSend withRegExp:regexString];
    
	//NSArray *lines = [textToSend componentsSeparatedByRegex:regexString];
	
	if ( (!lines) | ([lines count] <1)) {
		return;
	}
	//NSLog(@"Lines found: %d", [lines count]);
	
	for (NSString *line in lines) {
		[self sendLineToMud:line fromUser:NO fromMacro:NO shallDisplay:YES LogPrevCommands:NO];
	}
}

-(void)appendActionText:(NSString *)textToSend {
	// parse into individual lines; feed through to linetomud
	static NSString *regexString = @"(?:\r\n|[\n\v\f\r\302\205\\p{Zl}\\p{Zp}])"; 
	
	if (!textToSend) {
		return;
	}
	
    NSArray *lines = [RegExpTools arrayOfComponentsFromString:textToSend withRegExp:regexString];
    
	if ( (!lines) | ([lines count] <1)) {
		return;
	}

	MudClientIpad4ViewController *displayView = (MudClientIpad4ViewController*)self.parentView;
	MudInputFooter *footView =(MudInputFooter *)displayView.footer;
	
	footView.inputTextView.text = [NSString stringWithFormat:@"%@%@", footView.inputTextView.text, [lines objectAtIndex:0]];
    
    [[RemoteServer tool] appendSentTextFromMacro:[lines objectAtIndex:0]];
}




-(void)sendActionText:(NSString *)textToSend {
	// parse into individual lines; feed through to linetomud
	static NSString *regexString = @"(?:\r\n|[\n\v\f\r\302\205\\p{Zl}\\p{Zp}])"; 
	
	if (!textToSend) {
		return;
	}
	
    NSArray *lines = [RegExpTools arrayOfComponentsFromString:textToSend withRegExp:regexString];
    
	if ( (!lines) | ([lines count] <1)) {
		return;
	}
	//NSLog(@"Lines found: %d", [lines count]);
		  
	
	NSMutableString *outputBuffer = [[NSMutableString alloc] initWithString:@""];
	
	BOOL first = YES;
	for (NSString *line in lines) {
		if (first == YES) {
			first = NO;
		} else {
			[outputBuffer appendString:@"\n"];
		}
		[outputBuffer appendString:line];
	}	
	[self sendLineToMud:outputBuffer fromUser:NO fromMacro:YES shallDisplay:NO LogPrevCommands:NO];
	
}


-(void)populateCoreDataArray:(int)whichOne {
	
    NSString *entityName = nil;
	
	switch (whichOne) {
		case 1:
			entityName = @"MudDataVariables";
			break;
		case 2:
			entityName = @"MudDataTriggers";
			break;
		case 3:
			entityName = @"MudDataMacros";
			break;
        case 4:
            entityName = @"MudDataSpeedwalking";
            break;
        case 5:
            entityName = @"MudDataTouchableTexts";
            break;
        case 6:
            entityName = @"MudDataAliases";
            break;
		default:
			return;
	}
	
	MudClientIpad4ViewController *displayView = (MudClientIpad4ViewController *)self.parentView;
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:displayView.context];
	[request setEntity:entity];
	
    switch (whichOne) {
        case 4:
        case 5: 
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"character=%@", self.connectionData];
            [request setPredicate:predicate]; 
            // Order the events by creation date, most recent first.
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"key" ascending:YES];
            NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
            [request setSortDescriptors:sortDescriptors];
            
        }
            break;
            
        default: 
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"slotID=%@", self.connectionData];
            [request setPredicate:predicate];
            
            // Order the events by creation date, most recent first.
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
            NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
            [request setSortDescriptors:sortDescriptors];
       
        }
            break;
    }
	

	
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[displayView.context executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		NSLog( @"CoreDataError:%@", [error localizedDescription] ) ;

	}
	
	//NSLog(@"popcoredata:%d:%d:%d", self.slotID, whichOne, [mutableFetchResults count]);
	
	// Set self's events array to the mutable array, then clean up.
	switch (whichOne) {
		case 1:
			self.variables = mutableFetchResults;
			break;
		case 2:
			self.triggers = mutableFetchResults;
			break;
		case 3:
			self.macros = mutableFetchResults;
			break;
        case 4:
            self.speedwalking = mutableFetchResults;
            break;
        case 5:
            self.touchableTexts = mutableFetchResults;
            break;
        case 6:
            self.aliases = mutableFetchResults;
            break;
	}
	

}

-(void)refreshSettingsArray {
	MudClientIpad4ViewController *displayView = (MudClientIpad4ViewController *)self.parentView;
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"MudDataSettings" inManagedObjectContext:displayView.context];
	[request setEntity:entity];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"slotID=%@", self.connectionData];
	[request setPredicate:predicate];	
	
	// Order the events by creation date, most recent first.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"buttonBars" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[displayView.context executeFetchRequest:request error:&error] mutableCopy];
	
	self.settingsArray = mutableFetchResults;	
}

-(void)populateSettings {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudClientIpad4ViewController *displayView = (MudClientIpad4ViewController *)self.parentView;
	[self refreshSettingsArray];
	
	int settingsArrayCount = [self.settingsArray count];
	
	switch (settingsArrayCount) {
		case 0:{
			MudDataSettings *t1 = (MudDataSettings *)[NSEntityDescription insertNewObjectForEntityForName: @"MudDataSettings" inManagedObjectContext:displayView.context];
			t1.slotID = self.connectionData;
			t1.buttonBars = [NSNumber numberWithBool:YES];
			t1.EchoMacroOutput = [NSNumber numberWithBool:NO];
			t1.EchoTypedOutput= [NSNumber numberWithBool:YES];
			t1.standardLineFeed= [NSNumber numberWithBool:YES];
			t1.landscapeKeyboardAlpha = [NSDecimalNumber decimalNumberWithString:@"1.0f"];
			t1.storeSessionData = [NSNumber numberWithBool:NO];
			t1.defaultColor = [NSNumber numberWithFloat:-1.0f];
			t1.defaultBackgroundColor = [NSNumber numberWithFloat:0.0f];
			
			[myAppDelegate saveCoreData];	
			
			[self refreshSettingsArray];
			self.settings = [self.settingsArray objectAtIndex:0];
		}
			break;
		case 1:
			self.settings = [self.settingsArray objectAtIndex:0];
			self.keepSessionData = [[self.settings storeSessionData] boolValue];
			break;
		default:
			NSLog(@"Invalid settingsArrayCount");
			return;
	}
    
    self.settings.bottomLandscapeInputBar = @YES;
    self.settings.defaultBackgroundColor =[NSNumber numberWithFloat:0.0f];
    self.settings.defaultColor =[NSNumber numberWithFloat:-1.0f];
    
    
}


- (void)flushDelayedOutputTimers {
	
	for (NSTimer *t in [delayedOutputTimers allObjects] ) {
		[t invalidate];
	}
	
	[delayedOutputTimers removeAllObjects];
}

- (void)sendDelayedOutput:(NSString *)lineToSend {
	[self sendLineToMud:lineToSend fromUser:NO fromMacro:YES shallDisplay:NO LogPrevCommands:NO];
    if ([[self.settings EchoMacroOutput] boolValue] == YES) {
        [self sendLineToMud:lineToSend fromUser:NO fromMacro:YES shallDisplay:YES LogPrevCommands:NO];
    }
}

- (void)addDelayedOutputTimer:(NSString *)output delay:(int)delayInSeconds {

	if ( (delayInSeconds < 0) || (delayInSeconds > 900)) {
		delayInSeconds = 0;
	}
	
	[self performSelector:@selector(sendDelayedOutput:) withObject:output afterDelay:delayInSeconds];

}
		 
- (void)openConnection {
	MudClientIpad4ViewController *displayView = (MudClientIpad4ViewController*)self.parentView;
	MudInputFooter *footView =(MudInputFooter *)displayView.footer;
	
    [[RemoteServer tool] generateRemoteButtonListForCharacter:self.connectionData];

	if (sendQueue) {
		NSLog(@"sendQueue not nil at openConnection");
	}
	
	sendQueue = [[NSOperationQueue alloc] init];
	[sendQueue setMaxConcurrentOperationCount:1];

	
	_sentLines = [[NSMutableArray alloc] initWithCapacity:100];
	
	firstLineReceived = NO;
	globalTriggersDisabled = NO;
	
	if (delayedOutputTimers) {
		[self flushDelayedOutputTimers];
	} else {
		delayedOutputTimers = [[NSMutableSet alloc] initWithCapacity:100];
	}
	
	
	
	
	if (!self.buf2) {
		self.buf2 = (uint8_t *)calloc(2096, sizeof(uint8_t));
	}
	
	if (!self.buf1) {
		self.buf1 = (uint8_t *)calloc(1048, sizeof(uint8_t));
	}
	
	if (!self.data) {
		self.data = [[NSMutableData alloc] init];
	}
	
	int tcpPort = [[self.connectionData tcpPort] intValue];
	

   
    
#ifdef MCSSL
     BOOL useSSL = NO;
    useSSL = [[self.connectionData SSL] boolValue];
#endif
	
	if ( (tcpPort <1) || (tcpPort >65535) ) {
		// hack in a change to port 23. hah
		tcpPort = 23;
	}

	if (!self.nvtLineHandler) {
		self.nvtLineHandler = [[nvtLine alloc] init];
    }
    self.nvtLineHandler.locale = [[NSLocale alloc] initWithLocaleIdentifier:[self.connectionData lang]];
    self.nvtLineHandler.encoding  = [[self.connectionData encoding] intValue];
	
    NSString *fontText = [self.connectionData font];
    float fontSize = [[self.connectionData fontSize] floatValue];
    
    if ( fontSize && fontText && ([fontText length]>0) ) {
        self.nvtLineHandler.font = [UIFont fontWithName:fontText size:fontSize];
        NSLog(@"Using custom font: %@ (%0.02f) = %@", fontText, fontSize, self.nvtLineHandler.font);
    } else {
        self.nvtLineHandler.font = [UIFont fontWithName:@"Menlo-Regular" size:14.5f];
        NSLog(@"Using default font for this connection.");
    }
    
    [self.nvtLineHandler setupString:[self.settings.defaultColor intValue] startingBold:NO];
    
    if ([[self.settings swapColors] boolValue] == YES) {
        [self.nvtLineHandler setSwapColors:1];
    } else {
        [self.nvtLineHandler setSwapColors:0];
    }
	
	UIInterfaceOrientation iPadOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	if ( (iPadOrientation == UIInterfaceOrientationLandscapeLeft) | (iPadOrientation == UIInterfaceOrientationLandscapeRight) ) {
		displayView.displayTableView.backgroundColor = [[SettingsTool settings] stdBackgroundColor];
	} else {
		displayView.displayTableView.backgroundColor = [[SettingsTool settings] stdBackgroundColor];
	}
	
    self.lineWidthInChars =( displayView.displayTableView.frame.size.width  / [self.nvtLineHandler widthForCurrentFont]) -1;
                             
	//NSLog(@"Setting line width to %d characters for the current font.(%f / %f) = %@", self.lineWidthInChars , displayView.displayTableView.frame.size.width,[self.nvtLineHandler widthForCurrentFont] , self.nvtLineHandler.font);

    
	
	NSString *hostName = [self.connectionData hostName];
	
	if ( (!hostName) | ([hostName length]<1) ) {
		hostName = @"localhost";
	}

    CFReadStreamRef rStream;
    CFWriteStreamRef wStream;
   
    CFStreamCreatePairWithSocketToHost(
                                       NULL, 
                                       (__bridge CFStringRef)hostName, 
                                       tcpPort, 
                                       &rStream,
                                       &wStream
                                       );
	
	self.connectionStreamIN = (__bridge_transfer NSInputStream *)rStream;
    self.connectionStreamOUT = (__bridge_transfer NSOutputStream *)wStream;
    
	if (!self.connectionText) {
		self.connectionText  = [[NSMutableArray alloc] init];
	}
	
	if (!self.telnetHandler) {
		if ([[self.settings dataCompression] boolValue] == YES) {
			self.telnetHandler = telnet_init(telopts, _event_handler, 0, (__bridge void *)(self));
		} else {
			self.telnetHandler = telnet_init(teloptsNoCompression, _event_handler, 0, (__bridge void *)(self));
	
		}
	}
	[self.connectionStreamIN setDelegate:self];
	[self.connectionStreamOUT setDelegate:self];
	
	
	[self.connectionStreamIN scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	
	[self.connectionStreamOUT scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	
	
	for (MudDataTriggers *trigger in self.triggers) {
		if ([[trigger DisableOnUse] boolValue]) {
			[trigger setTriggerEnabled:[NSNumber numberWithBool:YES]];
		}
	}
	
	[self.connectionStreamOUT open];
	[self.connectionStreamIN open];
	
	
	
	self.currentConnectionState = 1;
	[footView updateReconnectState:1 session:self];
	
	commandSeparator = [self.settings commandSeparator];
	
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = [UIColor clearColor];
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0,0, tableView.frame.size.width, [self.nvtLineHandler heightForCurrentFont])];
    [cell.contentView addSubview:l];
    l.attributedText = [self.connectionText objectAtIndex:indexPath.row];
    
    //NSLog(@"label.frame = %f,%f,%f,%f", dispLabel.frame.origin.x, dispLabel.frame.origin.y, dispLabel.frame.size.width, dispLabel.frame.size.height);
    
	return cell;
}

-(void)doSendLine:(NSString *)_line {
	
    
    uint8_t *str;
    if (self.nvtLineHandler.encoding == kCFStringEncodingUTF8) {
        str = (uint8_t *) [_line cStringUsingEncoding:NSUTF8StringEncoding];
    } else {
        str = (uint8_t *) [_line cStringUsingEncoding:NSASCIIStringEncoding];
    }
    
	 int telnetResult = telnet_printf(self.telnetHandler, "%s", str);
	 
	 //NSLog(@"Sent->%s", str);
	 
	 if(!telnetResult) {
		 NSLog(@"telnet printf error sendLineToMud: %d", telnetResult);
	 }
	
	[NSThread sleepForTimeInterval:0.1];

}

-(void)sendLineToMud:(NSString *)lineToSend fromUser:(BOOL)fromUser fromMacro:(BOOL)fromMacro shallDisplay:(BOOL)shallDisplay LogPrevCommands:(BOOL)LogPrevCommands {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];

	
	if (self.sessionRecord) {
		MudDataSessionData *logEntry = (MudDataSessionData *)[NSEntityDescription insertNewObjectForEntityForName: @"MudDataSessionData" inManagedObjectContext:myAppDelegate.context];
		[logEntry setTimestamp:[NSDate dateWithTimeIntervalSinceNow:0]];
		[logEntry setSession:self.sessionRecord];
		[logEntry setLine:lineToSend];
	}
	
    [_sentLines addObject:lineToSend];
    
	if (shallDisplay == NO) {
		
		/*
		This functions very similarly to fprintf, except that output is
		sent through libtelnet for processing. IAC bytes are properly
			escaped, C newlines (\n) are translated into CR LF, and C carriage
			returns (\r) are translated into CR NUL, all as required by
			RFC854. The return code is the length of the formatted text.
			
			NOTE: due to an internal implementation detail, the maximum
			lenth of the formatted text is 4096 characters.
		*/
	
		//const uint8_t *str = (uint8_t *) [(NSString *)lineToSend cStringUsingEncoding:kCFStringEncodingASCII];
		
		NSString *lineWithEnding = [NSString stringWithFormat:@"%@%@", lineToSend, [[self.settings standardLineFeed] boolValue] ? @"\r\n" : @"\n"];
		
		
		NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(doSendLine:) object:lineWithEnding];
        [sendQueue addOperation:op];
		/*
		int telnetResult = telnet_printf(self.telnetHandler, "%s", str);
		
		NSLog(@"Sent->%s<- (%@)", str, lineToSend);
		
		if(!telnetResult) {
			NSLog(@"telnet printf error sendLineToMud: %d", telnetResult);
		}
		 */
		
	}
	
	MudClientIpad4ViewController *displayView = (MudClientIpad4ViewController *)self.parentView;
	
	BOOL logScreen = NO;
	
	if ( (fromUser == YES)  &&  ([[self.settings EchoTypedOutput] boolValue] == YES) ) {
		if (self.doEcho) {
			logScreen = YES;
		} else {
			logScreen = NO;
			
		}
	}
	
	if ( (fromMacro == YES)  &&  ([[self.settings EchoMacroOutput] boolValue] == YES) ) {
		logScreen = YES;
	}
	
	if (shallDisplay == YES) {
		logScreen = YES;
	}
	
	if (self.slotID == displayView.MudActiveIndex ) {
		
		if ( logScreen == NO) {
			self.lastLineIncomplete = 0;
		} 
		
		if (logScreen == YES) {
			NSAttributedString * stratt = nil;
			if (lineToSend && [lineToSend length]>lineWidthInChars) {
				lineToSend = [NSString stringWithFormat:@"%@", [lineToSend substringToIndex:lineWidthInChars]] ;
			}
			if (shallDisplay) {
				stratt = [self.nvtLineHandler copyScreenMessage:[NSString stringWithFormat:@">%@", lineToSend ? lineToSend : @""] color:0];
			} else {
				stratt = [self.nvtLineHandler copyScreenMessage:[NSString stringWithFormat:@">%@", lineToSend ? lineToSend : @""] color:1];
			}
			
			[self.connectionText insertObject:stratt atIndex:[self.connectionText count]];
			
			userPressedEnter++;
			
			[displayView.displayTableView beginUpdates];
			NSIndexPath *ip_add = [NSIndexPath indexPathForRow:[self.connectionText count]-1 inSection:0];
			[displayView.displayTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:ip_add] withRowAnimation:UITableViewRowAnimationNone];
			[displayView.displayTableView endUpdates];
		} 
		
		
		int ctCount = [self.connectionText count];
		if (ctCount >0) {
			NSIndexPath *ip = [NSIndexPath indexPathForRow:ctCount-1 inSection:0];
			[displayView.displayTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO];
	
		}
	}
}


- (int)handleIncomingLine:(NSAttributedString *)line updateLineNumber:(int)updateLineNumber{
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];	
	static MudDataSessionData *lastEntry;
	
	if (!line) {
		return -1;
	}

	
	if ( (self.keepSessionData == YES) && (self.sessionRecord) ) {
		if (updateLineNumber == 0) {
			lastEntry = (MudDataSessionData *)[NSEntityDescription insertNewObjectForEntityForName: @"MudDataSessionData" inManagedObjectContext:myAppDelegate.context];
			[lastEntry setTimestamp:[NSDate dateWithTimeIntervalSinceNow:0]];
			[lastEntry setSession:self.sessionRecord];
		} 
		[lastEntry setLine:[line string]];
	}
	
	int lineNumberReturned = updateLineNumber;	
	MudClientIpad4ViewController *displayView = (MudClientIpad4ViewController*)self.parentView;
	
	if (updateLineNumber) {
		[self.connectionText replaceObjectAtIndex:updateLineNumber-1 withObject:line];
		if (self.slotID == displayView.MudActiveIndex) {
			[displayView.displayTableView beginUpdates];
			NSIndexPath *ip_upd = [NSIndexPath indexPathForRow:updateLineNumber-1 inSection:0];
			[displayView.displayTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:ip_upd] withRowAnimation:UITableViewRowAnimationNone];
			[displayView.displayTableView endUpdates];
		}
	} else {
		lineNumberReturned = [self.connectionText count];
		[self.connectionText insertObject:line atIndex:lineNumberReturned];
		if (self.slotID == displayView.MudActiveIndex) {
			[displayView.displayTableView beginUpdates];
			NSIndexPath *ip_add = [NSIndexPath indexPathForRow:lineNumberReturned inSection:0];
			[displayView.displayTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:ip_add] withRowAnimation:UITableViewRowAnimationNone];
			[displayView.displayTableView endUpdates];
			[displayView.displayTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.connectionText count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
		}
	}
	
	return lineNumberReturned;
}

- (void)pruneConnectionText {
	
	MudClientIpad4ViewController *displayView = (MudClientIpad4ViewController*)self.parentView;
	
	int itemCount = [self.connectionText count];
	
	if (itemCount <600) {
		return;
	}
	
	int pruneCount =  500;
	
	//NSLog(@"Pruning %d items: total:%d", pruneCount, itemCount);
	int item = 0;
	int delCount=0;
	//NSMutableArray *ic = nil;
	
	
	for (;item<pruneCount;item++) {
		[self.connectionText removeObjectAtIndex:0];
        delCount++;
	}
	
	itemCount -= delCount;
	self.lastLineArrayIndex -= delCount;
	
	if (self.slotID == displayView.MudActiveIndex) {
        [displayView.displayTableView reloadData];
		if (itemCount>1) {
			[displayView.displayTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:itemCount-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
		}
	}
}

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode {
	MudClientIpad4ViewController *displayView = (MudClientIpad4ViewController*)self.parentView;
	MudInputFooter *footView =(MudInputFooter *)displayView.footer;
	
	int streamFound = -1;
	int streamid = (int)stream;
	
	if (streamid == (int)self.connectionStreamIN) {
		streamFound = 1;
	} else if (streamid == (int)self.connectionStreamOUT) {
		streamFound = 5;
	} 
	
	if (streamFound == -1 ) {
		NSLog(@"Unable to find stream in connectionStreamIN in handleEvent");
		exit(0);
	} 

	
	if (eventCode == NSStreamEventEndEncountered) {
		switch (streamFound) {
			case 1:
				[self.connectionStreamIN close];
				[self.connectionStreamIN removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
				self.connectionStreamIN = nil;
				break;
			case 5:
				[self.connectionStreamOUT close];
				[self.connectionStreamOUT removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
				self.connectionStreamOUT = nil;
				break;
				
		}
		[self sendLineToMud:@"Connection broken" fromUser:NO fromMacro:NO shallDisplay:YES LogPrevCommands:NO];
		
		self.currentConnectionState = 2;
		[footView updateReconnectState:2 session:self];
		return;
		
	}
	
	
	if (streamFound >4) {
		// nothing to do here for output streams, for now, at least
		return;
	}
	
	if (eventCode == NSStreamEventHasBytesAvailable) {
		if (self.currentConnectionState != 0) {
			self.currentConnectionState = 0;
			[footView updateReconnectState:0 session:self];
		}
		
		if (!connectionText) {
			NSLog(@"nil connectionText");
			return;
		}
		
		//uint8_t buf1[1048];
		
		unsigned int len = 0;
		len = [(NSInputStream *)stream read:self.buf1 maxLength:1024];
		
		if (len>1024) {
			[self sendLineToMud:@">Connection problem detected. Reconnecting" fromUser:NO fromMacro:NO shallDisplay:YES LogPrevCommands:NO];
			NSLog(@"Buffer returned from nsinputstream is corrupt; len >1024 (len is %d. reconnecting session", len);
			[self reconnectSession];
			return;
		}
		
		if (len >0) {
			telnet_recv(self.telnetHandler,(char *) self.buf1, len);
		}
	}

	else if (eventCode ==  NSStreamEventOpenCompleted) {
		[self sendLineToMud:@"Connected" fromUser:NO fromMacro:NO shallDisplay:YES LogPrevCommands:NO];
											
	} else if (eventCode == NSStreamEventErrorOccurred) {
		[self sendLineToMud:@"Unable to connect" fromUser:NO fromMacro:NO shallDisplay:YES LogPrevCommands:NO];
		if (self.slotID == displayView.MudActiveIndex) {
			self.currentConnectionState = 2;
			[footView updateReconnectState:2 session:self];
		}
	}
	
	[self pruneConnectionText];
}

- (void)generateAttributedStringForArray:(NSString *)linetoSend attributes:(NSDictionary *)attributes {


}

#define DEBUGANSI 0

- (void)handleEvent2:(char *)bufIn length:(int)len {
	static int ansiState = 0;
	int cleanLineLength = 0;
	static BOOL first = YES;
	static int ansiPenColor; 
	static BOOL ansiPenBold = NO;

	static int ansiBackground = 0;
	
	static int ansiState2TmpChar = 0;
	static int ansiState2TmpChar2 = 0;
	static int ansiState2Pos = 0;
	
	static int ansiState2PenColor ;
	static int ansiState2PenBold = 0;
	
	
	
	if (first) {
		first = NO;
		ansiPenColor = 2;
        
        if ([[self.settings defaultColor] intValue] > -1) {
            ansiPenColor = [[self.settings defaultColor] intValue];
        }
        
	}
	
	//NSLog(@"--->>>\n%s\n<<<---", (char *)bufIn );
	
	
	if (len <1) {
		return;
	} 
	
	if (!self.connectionText) {
		NSLog(@"nil connectionText");
		return;
	}
	
	int forceNewLine = 0;
	
	for (int x=0;x<len;x++) {
		int i = bufIn[x];
		
		if ( (i == 10) || (i == 13) || (lastLineIncomplete && userPressedEnter) || (forceNewLine)) {
			if (forceNewLine) 
				x--;
			cleanLineLength = 0;
			self.lastLineMatchedTrigger = 0;
			
			//Look for line ending character
			if (i == 10) {
				// invalid combination; 13 must be first. See if we have a 13 to clean up ahead.
				if ( (len>x) && (bufIn[x+1] == 13)) {
					x++;
				}
			} else if (i == 13) {
				if ( (len>x) && (bufIn[x+1] == 10)) {
					x++;
				}
			}
			
			forceNewLine = 0;
			
            //Copy our our string with attributes applied
            NSAttributedString *stratt = [self.nvtLineHandler copyAttributedString];
			    
            
            // NSLog(@"Stratt is:%@", stratt);
            
            //Reset nvt handler for a new string
            [self.nvtLineHandler setupString:ansiPenColor startingBold:NO];
			
			if (lastLineIncomplete) {
				
				if (userPressedEnter) {
					x--;
					userPressedEnter = 0;
				} else {
					[self handleIncomingLine:stratt updateLineNumber:lastLineArrayIndex];
				}
				lastLineIncomplete = 0;
                
        
			} else {
				if (stratt && ([stratt length]>0)) {
					[self handleIncomingLine:stratt updateLineNumber:0];
				}
			}
			if ( (!self.lastLineMatchedTrigger) && stratt && ([stratt length]>0)) {
				[self processTriggers:[stratt string] withConnection:self.slotID];
			}
			self.lastLineMatchedTrigger = 0;
			stratt = nil;
			
			if (!firstLineReceived) {
				firstLineReceived = YES;
				//telnet_negotiate(self.telnetHandler, TELNET_DO, TELNET_TELOPT_BINARY);
			}
			
			
		} else {
			// States of ansi ness
			// 0 - not in a code
			// 1 - esc seen
			// 2 - [ seen
			// 3 - endChar seen
			
			if (ansiState == 3) {
				ansiState = 0;
			}
			
			
			if ( (ansiState == 0) && (i == 27)) {
				ansiState = 1;
                if (DEBUGANSI == 1) { NSLog(@"ESC - ansiState =1"); }
			} else if ( (ansiState == 1) && (i >= 64) && (i <= 95) && (i != 91) ) {
				ansiState = 3;
                if (DEBUGANSI == 1) { NSLog(@"END - ansiState = 3"); }
			} else if ( (ansiState == 1) && ( i == 91) ) {  // 91 = [
                if (DEBUGANSI == 1) { NSLog(@"[ seen - ansiState = 2"); }
				ansiState = 2;
				ansiState2Pos = 0;
				ansiState2PenColor = 2;
				ansiState2PenBold = 0;
				ansiBackground = 0;
				ansiState2TmpChar = 48;
				ansiState2TmpChar2 = 48;
			} else if ( (ansiState == 2) && ( (i >= 64) && (i <=126) ) ) {
                
				ansiState = 3;
				int ourValue = ((ansiState2TmpChar - 48) *10) + (ansiState2TmpChar2 - 48);
				if (ourValue == 0) {
					ansiState2PenBold = 0;
				} else if (ourValue == 1) {
					ansiState2PenBold  = 1;
				} else if ( (ourValue >= 30) && (ourValue <= 37) ) {
					ansiState2PenColor = ourValue - 30;
				} else if ( (ourValue >= 40) && (ourValue <= 47) ) {
					//ignore for now
				} else {
					// ignore
				}
				
				if (i == (int)'m') {
						ansiPenColor = ansiState2PenColor;
						ansiPenBold = ansiState2PenBold;
                    if (DEBUGANSI == 1) { NSLog(@"ansiState 2 => 3 Changing Color to %d/%d", ansiPenColor, ansiPenBold); }
					[self.nvtLineHandler changeColor:ansiPenColor colorBold:ansiPenBold ? YES : NO];
				} else {
                     if (DEBUGANSI == 1) { NSLog(@"ansiState 2 => 3 didn't change color"); }
                }
			} else if ( (ansiState == 2) && (i == 59) && (ansiState2TmpChar == 48) && (ansiState2TmpChar == 48) )	{
				//Reset to default color
                 if (DEBUGANSI == 1) { NSLog(@"ansiState 2 resetting to default color"); }
				int defClr = [self.settings.defaultColor intValue];
				if (defClr == -1) {
					defClr = 2;
				}
				ansiState2PenColor = defClr;
				ansiState2Pos = 0;
                ansiPenColor = defClr;
			} else if ( (ansiState == 2) && (i == 59) ) {   // 59 = ;
			    // see what we got
				int ourValue = ((ansiState2TmpChar - 48) *10) + (ansiState2TmpChar2 - 48);
				
				if ( (ourValue == 10) && (ansiState2TmpChar2 == 48) ) {
					// was a 1
					ourValue = 1;
				}
				if (ourValue == 0) {
					ansiState2PenBold  = [self.settings.defaultColor intValue];
				} else if (ourValue == 1) {
					ansiState2PenBold  = 1;
				} else if ( (ourValue >= 30) && (ourValue <= 37) ) {
					ansiState2PenColor = ourValue - 30;
				} else if ( (ourValue >= 40) && (ourValue <= 47) ) {
					//ignore for now
				} else {
				   // ignore
				}
				ansiState2Pos = 0;
				ansiState2TmpChar = 48;
				ansiState2TmpChar2 = 48;
			} else if (ansiState == 2) { 
				if ( (i >= 48) || (i <=57) ) {
					if (ansiState2Pos == 0) {
						ansiState2TmpChar = i;
						ansiState2Pos++;
						
					} else {
						ansiState2TmpChar2 = i;
					}
				}

			}
			
			if (ansiState == 0) {
				[self.nvtLineHandler addCharacter:(char)i];
				cleanLineLength++;
			}
			
			if ([self.nvtLineHandler charCount] > lineWidthInChars) {
               // NSLog(@"Forcing new line:\n%@", [self.nvtLineHandler copyAttributedString]);
				forceNewLine = 1;
			}
			
			
		}
	}
	
	
	if ([self.nvtLineHandler charCount]>0) {
		
		self.lastLineMatchedTrigger = 0;
		NSAttributedString *stratt = [self.nvtLineHandler copyAttributedString];
		lastLineArrayIndex = [self handleIncomingLine:stratt updateLineNumber:0];
		
		if (!self.lastLineMatchedTrigger) {
			[self processTriggers:[stratt string] withConnection:self.slotID];
		}
		lastLineIncomplete = 1;
		lastLineArrayIndex = [self.connectionText count];
		userPressedEnter = 0;
		stratt = nil;
	}
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.connectionText count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [self.nvtLineHandler heightForCurrentFont];
}

- (void)dealloc {
		
	if (self.buf2) {
		free(self.buf2);
  	}
	
    if (self.buf1) {
		free(self.buf1);
  	}
    
}


@end
