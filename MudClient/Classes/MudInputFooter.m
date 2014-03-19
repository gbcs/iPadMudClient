//
//  MudInputFooter.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 9/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MudInputFooter.h"
#import "MudPreviousCommands.h"
#import "MudClientIpad4AppDelegate.h"
#import "MudMacros.h"
#import "MudSettings.h"
#import "MudClientIpad4ViewController.h"
#import "MudAddConnections.h"
#import "MudConnectionInstance.h"
#import "MudDataPreviousCommands.h"
#import "MudDataSpeedwalking.h"

@implementation MudInputFooter

@synthesize inputHistoryButton, inputTextView, topController, timer, inputSendAgainButton, reconnectButton, greenButton, redButton, connectionButton, settingsButton;
@synthesize connect1, connect2, connect3, connect4;
@synthesize speedwalkingButton, touchableTextsButton;

- (void)UpdateConnectionButtons {

	MudClientIpad4ViewController *displayView = (MudClientIpad4ViewController *)self.topController;
	
	UIColor *color = nil;
	
	if (displayView.mudSession1 != nil) {
		if (displayView.MudActiveIndex == 1) {
			color = [UIColor whiteColor];
		} else {
			color = [UIColor greenColor]; 
		}
	} else {
		color = [UIColor darkGrayColor]; 
	}
	[self.connect1 setTitleColor:color forState:UIControlStateNormal]; 
	
	if (displayView.mudSession2 != nil) {
		if (displayView.MudActiveIndex == 2) {
			color = [UIColor whiteColor];
		} else {
			color = [UIColor greenColor]; 
		}
	} else {
		color = [UIColor darkGrayColor]; 
	}
	[self.connect2 setTitleColor:color forState:UIControlStateNormal]; 
	
	if (displayView.mudSession3 != nil) {
		if (displayView.MudActiveIndex == 3) {
			color = [UIColor whiteColor];
		} else {
			color = [UIColor greenColor]; 
		}
	} else {
		color = [UIColor darkGrayColor]; 
	}
	[self.connect3 setTitleColor:color forState:UIControlStateNormal]; 
	
	if (displayView.mudSession4 != nil) {
		if (displayView.MudActiveIndex == 4) {
			color = [UIColor whiteColor];
		} else {
			color = [UIColor greenColor]; 
		}
	} else {
		color = [UIColor darkGrayColor]; 
	}
	[self.connect4 setTitleColor:color forState:UIControlStateNormal]; 

}

-(void)newConnectionClicked:(int)whichOne {
	
	MudClientIpad4ViewController *displayView = (MudClientIpad4ViewController *)self.topController;
	[displayView dismissPopovers];
	UIInterfaceOrientation iPadOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	
	if (!displayView.mudAddConnectionPopoverController) {
		MudAddConnections *uv = [[MudAddConnections alloc] init];
		displayView.mudAddConnections = uv;
		uv.context = displayView.context;
		uv.topController = displayView;
		
		UINavigationController *localNavigationController = [[UINavigationController alloc] initWithRootViewController:displayView.mudAddConnections];
		[localNavigationController setToolbarHidden:YES];
		[localNavigationController setNavigationBarHidden:NO]; 
		
		
		UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:localNavigationController];
		
		
		if ( (iPadOrientation == UIInterfaceOrientationLandscapeLeft) | (iPadOrientation == UIInterfaceOrientationLandscapeRight) ) {
			[popover setPopoverContentSize:CGSizeMake(560,420) animated:NO];
		} else {
			[popover setPopoverContentSize:CGSizeMake(560,300) animated:NO];
		}
		
		
		displayView.mudAddConnectionPopoverController = popover;
		
		[popover setDelegate:uv];
		
	}
	
	
	if (![displayView.mudAddConnectionPopoverController isPopoverVisible]) {
		MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
		MudAddConnections *m = [[MudAddConnections alloc] init];
		MudSession *session = [myAppDelegate getActiveSessionRef];
		BOOL largeInputArea =  [[session.settings largeInputArea] boolValue];
		CGPoint popFromPoint;
	
		if (largeInputArea && ((iPadOrientation == UIInterfaceOrientationLandscapeLeft) | (iPadOrientation == UIInterfaceOrientationLandscapeRight)) ) {
			int x = 800 + ((whichOne)*40) ;
			popFromPoint = CGPointMake(x + 20, 75);
		} else {
			int x = 720 + ((whichOne)*50) ;
			popFromPoint = CGPointMake(x + 20,40);
		}
		
		
		UITableView *tv = m.tv;
		[tv reloadData];
		
		[displayView.mudAddConnectionPopoverController	setPopoverContentSize:CGSizeMake(560,300) animated:NO];
		[displayView.mudAddConnectionPopoverController presentPopoverFromRect:CGRectMake(popFromPoint.x,popFromPoint.y,1,1) inView:(MudInputFooter *)displayView.footer permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
		[displayView.mudAddConnectionPopoverController setPassthroughViews:[NSArray arrayWithObject:self]];
	}	
	
	
}



- (void)connectionViewButtonTapped:(id)sender {
	
	MudClientIpad4ViewController *displayView = (MudClientIpad4ViewController *)self.topController;
	
	[displayView dismissPopovers];
	
	
	
	int SenderofClick = 0;
	
	if ((int)self.connect1 == (int)sender) {
		SenderofClick = 1;
		lastCommandLabel.text = displayView.mudSession1.lastCommandStr;
	} else if ((int)self.connect2 == (int)sender) {
		SenderofClick = 2;
		lastCommandLabel.text = displayView.mudSession2.lastCommandStr;
	} else if ((int)self.connect3 == (int)sender) {
		SenderofClick = 3;
		lastCommandLabel.text = displayView.mudSession3.lastCommandStr;
	} else if ((int)self.connect4 == (int)sender) {	
		SenderofClick = 4;
		lastCommandLabel.text = displayView.mudSession4.lastCommandStr;
	} else {
		NSLog (@"No match for sender in connectButtonClick.");
		return;
	}
	
	[displayView dismissPopovers];
	
	if (SenderofClick != displayView.MudActiveIndex) {
		switch (SenderofClick) {
			case 1:
				if (displayView.mudSession1) {
					[displayView switchToWindow:SenderofClick newConnection:NO];
				} else {
					[self newConnectionClicked:SenderofClick];
				}
				break;
			case 2:
				if (displayView.mudSession2) {
					[displayView switchToWindow:SenderofClick newConnection:NO];
				} else {
					[self newConnectionClicked:SenderofClick];
				}
				break;
			case 3:
				if (displayView.mudSession3) {
					[displayView switchToWindow:SenderofClick newConnection:NO];
				} else {
					[self newConnectionClicked:SenderofClick];
				}
				break;
			case 4:
				if (displayView.mudSession4) {
					[displayView switchToWindow:SenderofClick newConnection:NO];
				} else {
					[self newConnectionClicked:SenderofClick];
				}
				break;
				
		}
		
	} else {
		[displayView mudConnectionInstanceClickedLandscape:SenderofClick];
	}
	
	UIInterfaceOrientation iPadOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	if ( (iPadOrientation == UIInterfaceOrientationLandscapeLeft) | (iPadOrientation == UIInterfaceOrientationLandscapeRight) ) {
		[self updateOrientation:NO];
	} else {
		[self updateOrientation:YES];
	}
	
}

-(void)connectButtonClicked:(id)sender {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
		
	[session reconnectSession];
		
}
-(void)inputSendAgainButtonClicked:(id)sender {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];

	if ( (!session.lastCommandStr) | ([session.lastCommandStr length]<1) ){ 
		[session sendLineToMud:@"" fromUser:YES fromMacro:NO shallDisplay:NO LogPrevCommands:YES];
		return;
	}
	
	if ([session.commandSeparator length]) {
        
       
		NSArray *line_array = [session.lastCommandStr componentsSeparatedByString:session.commandSeparator];
		//NSLog(@"Command Separator: %@ Number of lines found: %d", session.commandSeparator, [line_array count]);
		for (NSString *line in line_array) {
			//NSLog(@"processLine:%@", line);
			[self processLine:line];
		}
	} else {
		[self processLine:session.lastCommandStr];
	}
}


	



-(void)checkOnKeyboard:(id)sender {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	
	if (myAppDelegate.keyboardWentHidden) {
		myAppDelegate.keyboardWentHidden = NO;
	
        if (![[RemoteServer tool] keyboardRemoteIsConnected]) {
              [self.inputTextView becomeFirstResponder];
        }
      
		
		MudSession *session = [myAppDelegate getActiveSessionRef];
		
		MudClientIpad4ViewController *displayView = (MudClientIpad4ViewController *)self.topController;
		
		[displayView adjustViewSizes:session.settings];
		
		if (displayView.settingsActive) {
			[(MudSettings *)displayView.mudSettings updateViews];
		}
	}
	
	
}

-(void)updateInputFooterTasks:(id)sender {
	static int round;
	static int coreDataTimer;
	
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	
	coreDataTimer++;
	
	if (coreDataTimer>300) {
		coreDataTimer = 0;
		[myAppDelegate saveCoreData];
	}
	[self checkOnKeyboard:sender];
	
    MudSession *session = [myAppDelegate getActiveSessionRef];	
   
    
	round++;
	
	if (myAppDelegate.internetStatus == 0) {
		round += 30;
	}
	
    
	if (round < 3) 
		return;
	
	round -= 150;
		
	//see if there are any connection changes for the open sessions.
	
	[myAppDelegate.internetReach currentReachabilityStatus];
	[self updateReconnectState:session.currentConnectionState session:session];
}



-(void)updateReconnectState:(int)newState session:(MudSession *)session {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	
	int toState = newState;
	
	MudSession *activeSession = [myAppDelegate getActiveSessionRef];
	
	lastCommandLabel.text = activeSession.lastCommandStr;
	
	if (!myAppDelegate.internetStatus) {
		toState	= 3 ;
	} else if (session != activeSession) {
		
		toState = activeSession.currentConnectionState;
		// Not for us to see
	}
		
	BOOL reconnectButtonVisible = NO;
	
	if ([self viewWithTag:100]) {
		reconnectButtonVisible = YES;
	}
	
	switch (toState) {
		case 0: //connected
			if (reconnectButtonVisible) {
				[self.reconnectButton removeFromSuperview];
			}
			break;
		case 1: //connecting
			[self.reconnectButton setTitle:@"Connecting" forState:UIControlStateNormal];
			[self.reconnectButton setBackgroundColor:[UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:1.0]];
			if (!reconnectButtonVisible) {
				[self addSubview:self.reconnectButton];
			}
			break;
		case 2: //disconnected
			[self.reconnectButton setTitle:@"Disconnected (Tap to Connect)" forState:UIControlStateNormal];
			[self.reconnectButton setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0]];
			if (!reconnectButtonVisible) {
				[self addSubview:self.reconnectButton];
			}
			break;
		case 3: //reachability issue
			[self.reconnectButton setTitle:@"Waiting for Internet Connection to Become Ready" forState:UIControlStateNormal];
			[self.reconnectButton setBackgroundColor:[UIColor colorWithRed:0.75 green:0.75 blue:0.0 alpha:1.0]];
			if (!reconnectButtonVisible) {
				[self addSubview:self.reconnectButton];
			}
			break;
	}
	
	[self UpdateConnectionButtons];

}

-(void)updateOrientation:(BOOL)isPortrait {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *activeSession = [myAppDelegate getActiveSessionRef];
	BOOL largeInputArea = [[activeSession.settings largeInputArea] boolValue];	

	if (isPortrait == YES) {
		
		variableEditButton			.frame = CGRectZero;
		triggerEditButton			.frame = CGRectZero;
		macroEditButton				.frame = CGRectZero;
        aliasEditButton             .frame = CGRectZero;
		
		if (largeInputArea) {
			self.greenButton			.frame = CGRectMake(0,-100,0,0);
			self.redButton				.frame = CGRectMake(0,-100,0,0);
			self.inputHistoryButton		.frame = CGRectMake(5, 22, 55, 45);
			self.inputTextView		.frame = CGRectMake(55, 10, 670, 70);
			self.inputSendAgainButton	.frame = CGRectMake(720, 22, 55, 45);
			self.reconnectButton		.frame = CGRectMake(4, 10, 758, 80);
			self.settingsButton			.frame = CGRectMake(-100,-100,0,0);
            self.speedwalkingButton		.frame = CGRectMake(-100,-100,0,0);
            //self.touchableTextsButton	.frame = CGRectMake(-100,-100,0,0);
			self.connect1				.frame = CGRectMake(0,-100,0,0);
			self.connect2				.frame = CGRectMake(0,-100,0,0);
			self.connect3				.frame = CGRectMake(0,-100,0,0);
			self.connect4				.frame = CGRectMake(0,-100,0,0);
			lastCommandLabel			.frame = CGRectMake(55,75,670,15);

		} else {
			self.greenButton			.frame = CGRectMake(0,-100,0,0);
			self.redButton				.frame = CGRectMake(0,-100,0,0);
			self.inputHistoryButton		.frame = CGRectMake(5, 5, 55, 45);
			self.inputTextView		.frame = CGRectMake(55, 10, 670, 50);
			self.inputSendAgainButton	.frame = CGRectMake(720, 5, 55, 45);
			self.reconnectButton		.frame = CGRectMake(4, 8, 758, 40);
			self.settingsButton			.frame = CGRectMake(-100,-100,0,0);
            self.speedwalkingButton		.frame = CGRectMake(-100,-100,0,0);
            //self.touchableTextsButton	.frame = CGRectMake(-100,-100,0,0);
			self.connect1				.frame = CGRectMake(0,-100,0,0);
			self.connect2				.frame = CGRectMake(0,-100,0,0);
			self.connect3				.frame = CGRectMake(0,-100,0,0);
			self.connect4				.frame = CGRectMake(0,-100,0,0);
			lastCommandLabel			.frame = CGRectZero;
		}
	} else {
            self.greenButton			.frame = CGRectMake(5,2,40,40);
			self.redButton				.frame = CGRectMake(50,2,40,40);
			self.inputHistoryButton		.frame = CGRectMake(100, 0, 44, 44);
			self.inputTextView			.frame = CGRectMake(145, 10, 572, 50);
			self.inputSendAgainButton	.frame = CGRectMake(720, 0, 55, 45);
			self.settingsButton			.frame = CGRectZero;
            speedwalkingButton		.frame = CGRectZero;
           // touchableTextsButton	.frame = CGRectZero;
			self.connect1				.frame = CGRectZero;;
			self.connect2				.frame = CGRectZero;;
			self.connect3				.frame = CGRectZero;;
			self.connect4				.frame = CGRectZero;;
			self.reconnectButton		.frame = CGRectMake(5, 2, 770, 40);
			lastCommandLabel			.frame = CGRectZero;
			variableEditButton			.frame = CGRectZero;
			triggerEditButton			.frame = CGRectZero;
			macroEditButton				.frame = CGRectZero;
            aliasEditButton             .frame = CGRectZero;
	}
}


-(void)settingsButtonTapped:(id)sender {
	MudClientIpad4ViewController *displayView = (MudClientIpad4ViewController *)self.topController;
	[displayView mudSettingsClicked:nil];
}

-(void)processLine:(NSString *)theLine {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];	
	
	if ( (!theLine) | ([theLine length]<1) ) {
		[session sendLineToMud:@"" fromUser:YES fromMacro:NO shallDisplay:NO LogPrevCommands:YES];
		return;
	}
	
	if ( [theLine characterAtIndex:0] == [[session.settings speedwalkPrefix] characterAtIndex:0]) {
		NSArray *walk_args_array = [theLine componentsSeparatedByString:@" "];
		
		NSString *walkCommand = [[walk_args_array objectAtIndex:0] substringWithRange:NSMakeRange(1, [[walk_args_array objectAtIndex:0] length]-1)];
		
		MudDataSpeedwalking *foundwalk = nil;
		
		for (MudDataSpeedwalking *walk in session.speedwalking) {
			NSString *walkTitle = [walk key];
			NSComparisonResult result = [walkTitle compare:walkCommand options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [walkTitle length])];
			if (result == NSOrderedSame)
			{
				foundwalk = walk;
				break;
			}
		}
		
        if (foundwalk) {
			[session splitAndSendSpeedwalkPath:foundwalk.path];
		} else {
			[session sendLineToMud:[NSString stringWithFormat:@"Speedwalk path '%@' not found", walkCommand] fromUser:NO fromMacro:YES shallDisplay:YES LogPrevCommands:NO];
		}
    } else if ( [theLine characterAtIndex:0] == [[session.settings macroPrefix] characterAtIndex:0]) {
        NSMutableArray *macro_args_array = [[theLine componentsSeparatedByString:@" "] mutableCopy];
       
        NSString *macroCommand = [[macro_args_array objectAtIndex:0] substringWithRange:NSMakeRange(1, [[macro_args_array objectAtIndex:0] length]-1)];
        
        MudDataMacros *foundMacro = nil;
      
        [macro_args_array removeObjectAtIndex:0];
        
        for (MudDataMacros *macro in session.macros) {
            NSString *macroTitle = [macro title];
            NSComparisonResult result = [macroTitle compare:macroCommand options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [macroTitle length])];
            if (result == NSOrderedSame)
            {
                foundMacro = macro;
                break;
            }
        }
        
        if (foundMacro) {
            [session processMacro:foundMacro args:macro_args_array triggerExecuted:NO];
        } else {
            [session sendLineToMud:[NSString stringWithFormat:@"Macro '%@' not found", macroCommand] fromUser:NO fromMacro:YES shallDisplay:YES LogPrevCommands:NO];
        }
	}  else {
        
        //Find and 
        //Expand aliases
        
        
        
        theLine = [self expandAliases:theLine];
        
        
        
		[session sendLineToMud:theLine fromUser:YES fromMacro:NO shallDisplay:NO LogPrevCommands:YES];
	}
		
}


-(NSString *)expandAliases:(NSString *)theLine {
    MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
    //Search the beginning of the string for each alias; 
   
    NSString *outLine = theLine;
    
    for (MudDataAliases *alias in session.aliases) {
        if([theLine isEqualToString:alias.title]) {
            //match
        
            outLine = alias.value;
            
            if (alias.firstVariable) {
                outLine = [outLine stringByReplacingOccurrencesOfString:@"$1" withString:alias.firstVariable.currentValue];
            }
            
            if (alias.secondVariable) {
                outLine = [outLine stringByReplacingOccurrencesOfString:@"$2" withString:alias.secondVariable.currentValue];
            }
            
            if (alias.thirdVariable) {
                outLine = [outLine stringByReplacingOccurrencesOfString:@"$3" withString:alias.thirdVariable.currentValue];
            }
    
            break;
        }
    }
    
    return outLine;
}

-(void)processLineFromRemote:(NSString *)thisLine {
    MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudClientIpad4ViewController *displayView = (MudClientIpad4ViewController *)myAppDelegate.viewController;
	MudSession *session = [myAppDelegate getActiveSessionRef];

    if ([thisLine length]) {
        session.lastCommandStr = [NSString stringWithFormat:@"%@", thisLine];
        [lastCommandLabel setText:session.lastCommandStr];
        
        if ([session.commandSeparator length]) {
            NSArray *line_array = [thisLine componentsSeparatedByString:session.commandSeparator];
            for (NSString *line in line_array) {
                [self processLine:line];
            }
        } else {
            [self processLine:thisLine];
        }
        
        if (session.doEcho && ([thisLine length] >5)) {
            if (![displayView checkForPreviousCommandsExistance:thisLine]) {
                MudDataPreviousCommands *char1 = (MudDataPreviousCommands *)[NSEntityDescription insertNewObjectForEntityForName: @"MudDataPreviousCommands" inManagedObjectContext:displayView.context];
                [char1 setCommandText:thisLine];
                [char1 setShowNoMore:[NSNumber numberWithBool:NO]];
                [char1 setSlotID:session.connectionData];
                
                [myAppDelegate saveCoreData];
                
                MudPreviousCommands *m = (MudPreviousCommands *)displayView.mudPreviousCommands;
                if (m) {
                    [m PullRecordsforList];
                    [m.tv reloadData];
                }
            }
        }
        
    } else {
        [session sendLineToMud:@"" fromUser:YES fromMacro:NO shallDisplay:NO LogPrevCommands:YES];
    }

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)thisTypedCharacter {
	BOOL shouldChangeText = YES;
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudClientIpad4ViewController *displayView = (MudClientIpad4ViewController *)myAppDelegate.viewController;
	MudSession *session = [myAppDelegate getActiveSessionRef];	

	//When we get an enter; we spring into action
	
	if ([thisTypedCharacter isEqualToString:@"\n"]) {
		NSString *thisLine = [NSString stringWithFormat:@"%@", textView.text];
		
		if ([thisLine length]) {
			session.lastCommandStr = [NSString stringWithFormat:@"%@", textView.text];
			[lastCommandLabel setText:session.lastCommandStr];
			
			if ([session.commandSeparator length]) {
				NSArray *line_array = [thisLine componentsSeparatedByString:session.commandSeparator];
				//NSLog(@"Command Separator: %@ Number of lines found: %d", session.commandSeparator, [line_array count]);
				for (NSString *line in line_array) {
					//NSLog(@"processLine:%@", line);
					[self processLine:line];
				}
			} else {
				[self processLine:thisLine];
			}
			
			if (session.doEcho && ([thisLine length] >5)) {
				if (![displayView checkForPreviousCommandsExistance:thisLine]) {
					MudDataPreviousCommands *char1 = (MudDataPreviousCommands *)[NSEntityDescription insertNewObjectForEntityForName: @"MudDataPreviousCommands" inManagedObjectContext:displayView.context];
					[char1 setCommandText:thisLine];
					[char1 setShowNoMore:[NSNumber numberWithBool:NO]];
					[char1 setSlotID:session.connectionData];
					
					[myAppDelegate saveCoreData];	
					
					MudPreviousCommands *m = (MudPreviousCommands *)displayView.mudPreviousCommands;
					if (m) {
						[m PullRecordsforList];
						[m.tv reloadData];
					}
				}
			}
			
		} else {
			//Blank line
			[session sendLineToMud:@"" fromUser:YES fromMacro:NO shallDisplay:NO LogPrevCommands:YES];
		}
		
		textView.text = @"";
		shouldChangeText = NO;
			
	}
	
	return shouldChangeText;
} 

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		self.backgroundColor = [[SettingsTool settings] inputBackgroundColor];
		
		self.opaque = YES;
		
		lastCommandLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		lastCommandLabel.font = [UIFont systemFontOfSize:11.0f];
		lastCommandLabel.textColor = [UIColor lightGrayColor];
		lastCommandLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:lastCommandLabel];
		
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
		btn.frame = CGRectMake(5, 0, 55, 45);
		[[btn layer] setCornerRadius:8.0f];
		[[btn layer] setMasksToBounds:YES];
		[[btn layer] setBorderWidth:0.0f];
		[btn setContentMode: UIViewContentModeScaleAspectFit];
		[btn setImage:[UIImage imageNamed:@"list_go.png"] forState:UIControlStateNormal];
		self.inputHistoryButton = btn;
		[self.inputHistoryButton addTarget:self action:@selector(inputHistoryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:self.inputHistoryButton];
		
		btn = [UIButton buttonWithType:UIButtonTypeCustom];
		btn.frame = CGRectMake(720, 0, 55, 45);
		[[btn layer] setCornerRadius:8.0f];
		[[btn layer] setMasksToBounds:YES];
		[[btn layer] setBorderWidth:0.0f];
		[btn setContentMode: UIViewContentModeScaleAspectFit];
		[btn setImage:[UIImage imageNamed:@"edit-redo.png"] forState:UIControlStateNormal];
		self.inputSendAgainButton = btn;
		[self.inputSendAgainButton addTarget:self action:@selector(inputSendAgainButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:self.inputSendAgainButton];
		
		
		
		UITextView *textField = [[UITextView alloc] initWithFrame:CGRectMake(55, 10, 670, 24)];
        textField.keyboardAppearance = UIKeyboardAppearanceDark;
        textField.delegate = self;
		textField.textAlignment = NSTextAlignmentLeft;
		[textField setFont:[UIFont systemFontOfSize:17.0]];
		[textField setBackgroundColor:[UIColor clearColor]];
		[textField setTextColor:[UIColor whiteColor]];


		[textField setReturnKeyType:UIReturnKeySend];
        textField.spellCheckingType = UITextSpellCheckingTypeNo;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		[textField setEnablesReturnKeyAutomatically:NO];
		[textField setOpaque:YES];
		[[textField layer] setCornerRadius:1.0f];
		self.inputTextView = textField;
		[self addSubview:self.inputTextView];
		
		/*
		CGRect accessFrame = CGRectMake(0.0, 0.0, 768.0, 40.0);
        textField.inputAccessoryView = [[UIView alloc] initWithFrame:accessFrame];
        textField.inputAccessoryView.backgroundColor = [UIColor blueColor];
		*/
		
		
		btn = [UIButton buttonWithType:UIButtonTypeCustom];
		btn.frame = CGRectZero;
		btn.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0];
		btn.opaque = YES;
		btn.tag = 100;
		[[btn layer] setCornerRadius:8.0f];
		[[btn layer] setMasksToBounds:YES];
		[[btn layer] setBorderWidth:0.0f];
		[btn addTarget:self action:@selector(connectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
		self.reconnectButton = btn;
		
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.frame = CGRectMake(7, 2, 40, 40);
		
		button.backgroundColor = [UIColor colorWithRed:0.3 green:0.0 blue:0.0 alpha:1.0];
		button.opaque = YES;
		button.tag = 1000;
		[[button layer] setCornerRadius:8.0f];
		[[button layer] setMasksToBounds:YES];
		[[button layer] setBorderWidth:1.0f];
		
		[self addSubview:button];
		
		self.redButton = button;
		
		button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.frame = CGRectMake(57, 2, 40, 40);
		button.backgroundColor = [UIColor colorWithRed:0.0 green:0.3 blue:0.0 alpha:1.0];
		button.opaque = YES;
		
		[[button layer] setCornerRadius:8.0f];
		[[button layer] setMasksToBounds:YES];
		[[button layer] setBorderWidth:1.0f];
		
		
		[self addSubview:button];
		self.greenButton = button;
		
        
        aliasEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
		aliasEditButton.frame = CGRectZero;
		[aliasEditButton setImage:[UIImage imageNamed:@"187-pencil.png"] forState:UIControlStateNormal];
		aliasEditButton.opaque = NO;
		aliasEditButton.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.7];
		[[aliasEditButton layer] setCornerRadius:6.0f];
		[[aliasEditButton layer] setMasksToBounds:YES];
		[[aliasEditButton layer] setBorderWidth:0.0f];
		aliasEditButton.tag = 9000;
		[aliasEditButton addTarget:self action:@selector(launchAliasEditor:) forControlEvents:UIControlEventTouchUpInside ];
		[self addSubview:aliasEditButton];

		variableEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
		variableEditButton.frame = CGRectZero;
		[variableEditButton setImage:[UIImage imageNamed:@"96-book.png"] forState:UIControlStateNormal];
		variableEditButton.opaque = NO;
		variableEditButton.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.7];
		[[variableEditButton layer] setCornerRadius:6.0f];
		[[variableEditButton layer] setMasksToBounds:YES];
		[[variableEditButton layer] setBorderWidth:0.0f];
		variableEditButton.tag = 9000;
		[variableEditButton addTarget:self action:@selector(launchVariableEditor:) forControlEvents:UIControlEventTouchUpInside ];
		[self addSubview:variableEditButton];
		
		triggerEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
		triggerEditButton.frame = CGRectZero;
		[triggerEditButton setImage:[UIImage imageNamed:@"20-gear2.png"] forState:UIControlStateNormal];
		triggerEditButton.opaque = NO;
		triggerEditButton.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.7];
		[[triggerEditButton layer] setCornerRadius:6.0f];
		[[triggerEditButton layer] setMasksToBounds:YES];
		[[triggerEditButton layer] setBorderWidth:0.0f];
		triggerEditButton.tag = 9000;
		[triggerEditButton addTarget:self action:@selector(launchTriggerEditor:) forControlEvents:UIControlEventTouchUpInside ];
		[self addSubview:triggerEditButton];
		
		macroEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
		macroEditButton.frame = CGRectZero;
		[macroEditButton setImage:[UIImage imageNamed:@"104-index-cards.png"] forState:UIControlStateNormal];
		macroEditButton.opaque = NO;
		macroEditButton.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.7];
		[[macroEditButton layer] setCornerRadius:6.0f];
		[[macroEditButton layer] setMasksToBounds:YES];
		[[macroEditButton layer] setBorderWidth:0.0f];
		macroEditButton.tag = 9000;
		[macroEditButton addTarget:self action:@selector(launchMacroEditor:) forControlEvents:UIControlEventTouchUpInside ];
		[self addSubview:macroEditButton];		
		
		
        speedwalkingButton = [UIButton buttonWithType:UIButtonTypeCustom];
		speedwalkingButton.frame = CGRectZero;
		[speedwalkingButton setImage:[UIImage imageNamed:@"102-walk.png"] forState:UIControlStateNormal];
		speedwalkingButton.opaque = NO;
		speedwalkingButton.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.7];
		[[speedwalkingButton layer] setCornerRadius:6.0f];
		[[speedwalkingButton layer] setMasksToBounds:YES];
		[[speedwalkingButton layer] setBorderWidth:0.0f];
		speedwalkingButton.tag = 9000;
		[speedwalkingButton addTarget:self action:@selector(launchSpeedwalkingEditor:) forControlEvents:UIControlEventTouchUpInside ];
		[self addSubview:speedwalkingButton];	
        
        /*
        touchableTextsButton = [UIButton buttonWithType:UIButtonTypeCustom];
		touchableTextsButton.frame = CGRectZero;
		[touchableTextsButton setImage:[UIImage imageNamed:@"10-arrows-in.png"] forState:UIControlStateNormal];
		touchableTextsButton.opaque = NO;
		touchableTextsButton.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.7];
		[[touchableTextsButton layer] setCornerRadius:6.0f];
		[[touchableTextsButton layer] setMasksToBounds:YES];
		[[touchableTextsButton layer] setBorderWidth:0.0f];
		touchableTextsButton.tag = 9000;
		[touchableTextsButton addTarget:self action:@selector(launchTouchableTextsEditor:) forControlEvents:UIControlEventTouchUpInside ];
		[self addSubview:touchableTextsButton];	
        */
        
        
        
		// Check for keyboard disappearing when it should be pointed at inputbar (hack)
		self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
													  target:self
													selector:@selector(updateInputFooterTasks:)
													userInfo:nil
													 repeats:YES];
		
		UIInterfaceOrientation iPadOrientation = [[UIApplication sharedApplication] statusBarOrientation];
		if ( (iPadOrientation == UIInterfaceOrientationLandscapeLeft) | (iPadOrientation == UIInterfaceOrientationLandscapeRight) ) {
			[self updateOrientation:NO];
		} else {
			[self updateOrientation:YES];
		}
    }		
    return self;
}
- (void)launchMacroEditor:(id)arg {
	
	MudClientIpad4ViewController *displayView = (MudClientIpad4ViewController *)self.topController;
	
	[displayView mudMacrosClickedLandscape:nil];
	

}

- (void)launchTriggerEditor:(id)arg {
	MudClientIpad4ViewController *displayView = (MudClientIpad4ViewController *)self.topController;
	[displayView mudTriggersClickedLandscape:nil];	
}


- (void)launchAliasEditor:(id)arg {
	MudClientIpad4ViewController *displayView = (MudClientIpad4ViewController *)self.topController;
	[displayView mudAliasesClickedLandscape:nil];
}

- (void)launchVariableEditor:(id)arg {
	MudClientIpad4ViewController *displayView = (MudClientIpad4ViewController *)self.topController;
	[displayView mudVariablesClickedLandscape:nil];
}


-(void)inputHistoryButtonClicked:(id)sender{
	UIButton *button = (UIButton *)sender;
	
    MudClientIpad4ViewController *displayView = (MudClientIpad4ViewController *)self.topController;
	
	
	[displayView dismissPopovers];
	
	if (!displayView.mudPreviousCommandsPopoverController) {
		MudPreviousCommands *uv = [[MudPreviousCommands alloc] init];
		displayView.mudPreviousCommands = uv;
		uv.topController = displayView;
		UINavigationController *localNavigationController = [[UINavigationController alloc] initWithRootViewController:displayView.mudPreviousCommands];
		[localNavigationController setToolbarHidden:YES];
		//[localNavigationController setNavigationBarHidden:YES]; 
		
		
		UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:localNavigationController];
		[popover setPopoverContentSize:CGSizeMake(560,300) animated:NO];
		displayView.mudPreviousCommandsPopoverController = popover;
		[popover setDelegate:uv];
	}
	
	if (![displayView.mudPreviousCommandsPopoverController isPopoverVisible]) {
		CGRect senderFrame = button.frame;
		
		[displayView.mudPreviousCommandsPopoverController presentPopoverFromRect:CGRectMake(senderFrame.origin.x+32, senderFrame.origin.y-10,1,1) inView:self permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
		
	} 
	
	MudPreviousCommands *pc = (MudPreviousCommands *)displayView.mudPreviousCommands;
	UITableView *tv = pc.tv;
	[tv reloadData];
	
	[displayView.mudPreviousCommands.view setNeedsDisplay];
}

- (void)launchSpeedwalkingEditor:(id)arg {
	
	MudClientIpad4ViewController *displayView = (MudClientIpad4ViewController *)self.topController;
	
	[displayView mudSpeedwalkingClickedLandscape:nil];
	
    
}

- (void)launchTouchableTextsEditor:(id)arg {
	
	MudClientIpad4ViewController *displayView = (MudClientIpad4ViewController *)self.topController;
	
	[displayView mudTouchableTextsClickedLandscape:nil];
	
    
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
	//NSLog(@"TS should end");
	return YES;
}

- (void)textViewDidChange:(UITextView *)textView {

    //	NSLog(@"TS did change");
}



- (void)dealloc {
    [self.timer invalidate];
}


@end
