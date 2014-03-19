//
//  ButtonPanel.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 8/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ButtonPanel.h"
#import	"MudButtonsDetail.h"
#import "MudClientIpad4AppDelegate.h"

@implementation ButtonPanel




@synthesize currentLayer;
@synthesize topController;
@synthesize buttons;
@synthesize iconImages;
@synthesize landscapeMode;

- (void)holdButton:(id)sender {
	
	NSTimer *t = (NSTimer *)sender;
	
	
	
	int rcvClickSeq = [(NSNumber *)t.userInfo intValue];
	
	holdTimer = nil;

	
	if (clickSequence != rcvClickSeq) {
		// We're stale
		return;
	}

	if (!heldButton) {
		// User unpressed before timer fired
		wasHeld = NO;
		return;
	}
			
	heldButton.backgroundColor = [UIColor clearColor];
	wasHeld = YES;
	clickSequence++;
	
	BOOL prevEditMode = self.topController.buttonEditMode;
	self.topController.buttonEditMode = YES;
	[self buttonClick:heldButton];
	self.topController.buttonEditMode = prevEditMode;
	

}

- (void)mainButtonClickDown:(id)sender {
	clickSequence++;
	
	wasHeld = NO;
	heldButton = sender;
	holdTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
												  target:self
												selector:@selector(holdButton:)
											    userInfo:[NSNumber numberWithInt:clickSequence]
												 repeats:YES];
	
	heldButton.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.7];
	
}

- (void)mainButtonClickUp:(id)sender {
	heldButton.backgroundColor = [UIColor clearColor];
	if (holdTimer) {
		holdTimer = nil;
	}
	
	if (!wasHeld) {
		// If not, process as a button tap
		[self buttonClick:heldButton];
	} 
	
	heldButton = nil;
}

-(void)colorButtons {
    
    UIColor *color = nil;
    
    if (self.currentLayer == 2) {
        color = [UIColor colorWithRed:0.3 green:0.0 blue:0.0 alpha:1.0];
    } else if (self.currentLayer == 3) {
        color = [UIColor colorWithRed:0.0 green:0.3 blue:0.0 alpha:1.0];
    } else {
       color = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]; 
    }
    
    for (UIView *v in self.subviews) {
        if (v.tag >= 1000) {
            continue;
        }
        v.backgroundColor = color;
    }
    
    
}

	
- (void)altButtonClickDown:(id)sender {
	UIButton *button = (UIButton *)sender;
	if (button.tag == 1000 ) {
		//self.backgroundColor = [UIColor colorWithRed:0.3 green:0.0 blue:0.0 alpha:1.0];
		self.currentLayer = 2;
	} else {
		//self.backgroundColor = [UIColor colorWithRed:0.0 green:0.3 blue:0.0 alpha:1.0];
		self.currentLayer = 3;
	}
    
    [self colorButtons];
}

- (void)altButtonClickUp:(id)sender {
	self.currentLayer = 1;
    [self colorButtons];
}

- (void)editRemoteButtonAtIndex:(NSInteger *)index {
    MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
    MudDataButtons *buttonData = [[RemoteServer tool] buttonForRemoteAtIndex:index];
	MudSession *session = [myAppDelegate getActiveSessionRef];
	MudButtonsDetail *uv = nil;
    self.remote = YES;
	if (!buttonData) {
		buttonData = (MudDataButtons *)[NSEntityDescription insertNewObjectForEntityForName: @"MudDataButtons" inManagedObjectContext:myAppDelegate.context];
		[buttonData setRemoteIndex:[NSNumber numberWithInt:index]];
		[buttonData setRemote:[NSNumber numberWithBool:YES]];
		[buttonData setIconIndex:[NSNumber numberWithInt:-1]];
		[buttonData setPortrait:[NSNumber numberWithBool:NO]];
        [buttonData setSlotID:session.connectionData];
        [myAppDelegate saveCoreData];
        
	}
    
	if (!self.topController.mudButtonPopoverController) {
		uv = [[MudButtonsDetail alloc] init];
		uv.context = self.topController.context;
		uv.parentView = self;
		uv.bPanel = self;
		self.topController.mudButtons = uv;
		
		
		UINavigationController *localNavigationController = [[UINavigationController alloc] initWithRootViewController:self.topController.mudButtons];
		[localNavigationController setToolbarHidden:YES];
		[localNavigationController setNavigationBarHidden:NO];
		UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:localNavigationController];
		[popover setPopoverContentSize:CGSizeMake(560,320) animated:NO];
		self.topController.mudButtonPopoverController = popover;
		[popover setDelegate:uv];
	} else {
		uv = (MudButtonsDetail *)self.topController.mudButtons;
	}
	
	uv.element = buttonData;
	uv.buttitle.text = [buttonData title];
	
	[uv.tableview reloadData];
	
	if (![self.topController.mudButtonPopoverController isPopoverVisible]) {
        UIInterfaceOrientation iPadOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if ( (iPadOrientation == UIInterfaceOrientationLandscapeLeft) | (iPadOrientation == UIInterfaceOrientationLandscapeRight) ) {
            [self.topController.mudButtonPopoverController presentPopoverFromRect:CGRectMake(800,300,1,1)
																		   inView:self.topController.view
                                                         permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
        } else {
            [self.topController.mudButtonPopoverController presentPopoverFromRect:CGRectMake(700,600,1,1)
                                                                           inView:self.topController.view
                                                         permittedArrowDirections: UIPopoverArrowDirectionDown animated:YES];
        }
	}
}


- (void)buttonClick:(id)sender {
	UIButton *button = (UIButton *)sender;
	MudDataButtons *buttonData = nil;
	MudButtonsDetail *uv = nil;
	BOOL portraitMode = YES;
	self.remote = NO;
    
	int buttonRow = (int)button.tag/10;
	int buttonCol = (int)button.tag-(10*buttonRow);
	
	UIInterfaceOrientation iPadOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	if ( (iPadOrientation == UIInterfaceOrientationLandscapeLeft) | (iPadOrientation == UIInterfaceOrientationLandscapeRight) ) {
		portraitMode = NO;
	} else {
		if (buttonRow == 3) {
			buttonRow = 2;
			buttonCol = 10;
		}
		
		if ( (buttonRow == 2) && (buttonCol == 0) ) {
			buttonRow = 1;
			buttonCol = 10;
		}
	}

	
	//NSLog(@"Clicked: %d, %d", buttonCol, buttonRow);

	for (MudDataButtons *buttonTmpData in self.buttons) {

		if ( ([buttonTmpData.x intValue] == buttonCol) && ([buttonTmpData.y intValue] == buttonRow)) {
			buttonData = buttonTmpData;
			//NSLog(@"Found buttonData");
			break;
		}
	}
	
	if (!self.topController.buttonEditMode) {
		if (buttonData) {
			[self launchButton:buttonData layer:self.currentLayer];
		}	
		return;
	}
	
    //Edit mode from here on
    
	if (!buttonData) {
		//NSLog(@"Creating buttonData");
		buttonData = (MudDataButtons *)[NSEntityDescription insertNewObjectForEntityForName: @"MudDataButtons" inManagedObjectContext:self.topController.context];
		[buttonData setX:[NSNumber numberWithInt:(buttonCol)]];
		[buttonData setY:[NSNumber numberWithInt:(buttonRow)]];
		[buttonData setIconIndex:[NSNumber numberWithInt:-1]];
		[buttonData setPortrait:[NSNumber numberWithBool:portraitMode]];
		switch (self.topController.MudActiveIndex) {
			case 1:
				[buttonData setSlotID:self.topController.mudSession1.connectionData];
				break;
			case 2:
				[buttonData setSlotID:self.topController.mudSession2.connectionData];
				break;
			case 3:
				[buttonData setSlotID:self.topController.mudSession3.connectionData];
				break;
			case 4:
				[buttonData setSlotID:self.topController.mudSession4.connectionData];
				break;
		}		
		MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
		[myAppDelegate saveCoreData];	
			
	}
		
	if (!self.topController.mudButtonPopoverController) {
		uv = [[MudButtonsDetail alloc] init];
		uv.context = self.topController.context;
		uv.parentView = self;
		uv.bPanel = self;
		self.topController.mudButtons = uv;
		
		
		UINavigationController *localNavigationController = [[UINavigationController alloc] initWithRootViewController:self.topController.mudButtons];
		[localNavigationController setToolbarHidden:YES];
		[localNavigationController setNavigationBarHidden:NO]; 
		UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:localNavigationController];
		[popover setPopoverContentSize:CGSizeMake(560,320) animated:NO];
		self.topController.mudButtonPopoverController = popover;
		[popover setDelegate:uv];
	} else {
		uv = (MudButtonsDetail *)self.topController.mudButtons;
	}
	
	uv.element = buttonData;
	uv.buttitle.text = [buttonData title];
	
	[uv.tableview reloadData];
	
	if (![self.topController.mudButtonPopoverController isPopoverVisible]) {
		

		 
		 if ( (iPadOrientation == UIInterfaceOrientationLandscapeLeft) | (iPadOrientation == UIInterfaceOrientationLandscapeRight) ) {
			 [self.topController.mudButtonPopoverController presentPopoverFromRect:CGRectMake(800,300,1,1)
																		   inView:self.topController.view
																permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
		 } else {
			 [self.topController.mudButtonPopoverController presentPopoverFromRect:CGRectMake(700,600,1,1)
																			inView:self.topController.view
													permittedArrowDirections: UIPopoverArrowDirectionDown animated:YES];
		 }
		
	}
}

- (void)populateButtons {
	UIInterfaceOrientation iPadOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	
	[self clearButtons];
	
	if ( (iPadOrientation == UIInterfaceOrientationLandscapeLeft) | (iPadOrientation == UIInterfaceOrientationLandscapeRight) ) {
		[self drawButtonsLandscape];
		[self populateButtonsLandscape];
	} else {
		[self drawButtonsPortrait];
		[self populateButtonsPortrait];
	}
}

- (void)populateButtonsLandscape {
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"MudDataButtons" inManagedObjectContext:self.topController.context];
	[request setEntity:entity];
	
	
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
	
	
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"slotID=%@ AND portrait=NO", session.connectionData];
	[request setPredicate:predicate];
	
	
	// Order the events by creation date, most recent first.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"x" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[self.topController.context executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		// Handle the error.
	}
	
	// Set self's events array to the mutable array, then clean up.
	
	self.buttons = mutableFetchResults;
	
	
	//Fill in the details
	
	for (int myX=1;myX<=4;myX++) {
		for (int myY=1;myY<=12;myY++) {
			int tag = myX + (myY*10);
			UIButton *v = (UIButton *)[self viewWithTag:tag];
			if (!v) {
				NSLog(@"Missing button!");
				return;
			}
			
			int found=0;
			MudDataButtons *btnFound = nil;
			
			for (MudDataButtons *btn in self.buttons) {
				if (!found) {
					int btnTag = [[btn x] intValue] + ([[btn y] intValue]*10);
					if (btnTag == tag) {
						found = 1;
						btnFound = btn;
					}
				}
			}
			
			if (!found) {
				// clear the button out
				[v setBackgroundImage:nil forState:UIControlStateNormal];
				[v setTitle:@" " forState:UIControlStateNormal];
				//NSLog(@"no buttonData in populate for %d, %d", myX, myY);
			} else {
				//NSLog(@"Found ButtonData in populate for %d, %d", myX, myY);
				// populate button with an image, if available, otherwise the title, if available.

                if ([[btnFound title] length]) {
                    [v setBackgroundImage:nil forState:UIControlStateNormal];
                    [v setTitle:[btnFound title] forState:UIControlStateNormal];
                } else {
                    [v setTitle:nil forState:UIControlStateNormal];
                    
                    UIImage *tmpImage = nil;
                    int iconIndex = [[btnFound iconIndex] intValue];
                    
                    if (iconIndex > -1) {
                        tmpImage = [UIImage imageNamed:[self.iconImages objectAtIndex:iconIndex]];
                    }
                    
                    if (tmpImage) {
                        [v setBackgroundImage:tmpImage forState:UIControlStateNormal];
                    } else {
                        [v setBackgroundImage:nil forState:UIControlStateNormal];
                        [v setTitle:[btnFound title] forState:UIControlStateNormal];
                    }
                }
            }
		}
	}
	
	
	MudInputFooter *foot = (MudInputFooter *)self.topController.footer;
	    
    UILongPressGestureRecognizer *longP = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(userPressedButton:)];
    longP.minimumPressDuration = 0.001;
    [foot.redButton addGestureRecognizer:longP];
   
    longP = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(userPressedButton:)];
    longP.minimumPressDuration = 0.001;
    [foot.greenButton addGestureRecognizer:longP];
    
	[self setNeedsDisplay];
}


-(void)userPressedButton:(UILongPressGestureRecognizer *)g {
    MudInputFooter *foot = (MudInputFooter *)self.topController.footer;

    if (g.state == UIGestureRecognizerStateBegan) {
        if ([g.view isEqual:foot.greenButton]) {
            self.currentLayer = 3;
        } else if ([g.view isEqual:foot.redButton]) {
            self.currentLayer = 2;
        }
    } else if (g.state == UIGestureRecognizerStateEnded) {
        self.currentLayer = 1;
    }
    
    [self colorButtons]; 
    
}


	
- (void)populateButtonsPortrait {
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"MudDataButtons" inManagedObjectContext:self.topController.context];
	[request setEntity:entity];
	
	
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
	
	
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"slotID=%@ AND portrait=YES", session.connectionData];
	[request setPredicate:predicate];
	
	
	// Order the events by creation date, most recent first.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"x" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[self.topController.context executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		// Handle the error.
	}
	
	// Set self's events array to the mutable array, then clean up.
	
	self.buttons = mutableFetchResults;
	
	
	//Fill in the details
	
	for (int myX=1;myX<=10;myX++) {
		for (int myY=1;myY<=2;myY++) {
			int tag = myX + (myY*10);
			UIButton *v = (UIButton *)[self viewWithTag:tag];
			if (!v) {
				NSLog(@"Missing button!");
				return;
			}
			
			int found=0;
			MudDataButtons *btnFound = nil;
			
			for (MudDataButtons *btn in self.buttons) {
				if (!found) {
					int btnTag = [[btn x] intValue] + ([[btn y] intValue]*10);
					if (btnTag == tag) {
						found = 1;
						btnFound = btn;
					}
				}
			}
			
			if (!found) {
				// clear the button out
				[v setBackgroundImage:nil forState:UIControlStateNormal];
				[v setTitle:nil forState:UIControlStateNormal];
				//NSLog(@"no buttonData in populate for %d, %d", myX, myY);
			} else {
				//NSLog(@"Found ButtonData in populate for %d, %d", myX, myY);
				// populate button with an image, if available, otherwise the title, if available.
                if ([[btnFound title] length]) {
                    [v setBackgroundImage:nil forState:UIControlStateNormal];
                    [v setTitle:[btnFound title] forState:UIControlStateNormal];
                } else {
                    [v setTitle:nil forState:UIControlStateNormal];
                    
                    UIImage *tmpImage = nil;
                    int iconIndex = [[btnFound iconIndex] intValue];
                    
                    if (iconIndex > -1) {
                        tmpImage = [UIImage imageNamed:[self.iconImages objectAtIndex:iconIndex]];
                    }
                    
                    if (tmpImage) {
                        [v setBackgroundImage:tmpImage forState:UIControlStateNormal];
                    } else {
                        [v setBackgroundImage:nil forState:UIControlStateNormal];
                        [v setTitle:[btnFound title] forState:UIControlStateNormal];
                    }
                }
			}
		}
	}
	[self setNeedsDisplay];
}

- (void) launchButton:(MudDataButtons *)button layer:(NSInteger)layer {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];

	
	NSString *action = nil;
	MudDataMacros *macro = nil;
	BOOL appendFlag = NO;
	
	switch (layer) {
		case 1:
			if (button.layer1Action && [button.layer1Action length]) {
				action = button.layer1Action;
				appendFlag = [button.appendFlag1 boolValue];
			} else if (button.layer1Macro) {
				macro = button.layer1Macro;
			} else {
				// nothing assigned to this action.
				return;
			}
			 break;
		case 2:
			if (button.layer2Action && [button.layer2Action length]) {
				action = button.layer2Action;
				appendFlag = [button.appendFlag2 boolValue];
			} else if (button.layer2Macro) {
				macro = button.layer2Macro;
			} else {
				// nothing assigned to this action.
				return;
			}
			break;
		case 3:
			if (button.layer3Action && [button.layer3Action length]) {
				action = button.layer3Action;
				appendFlag = [button.appendFlag3 boolValue];
			} else if (button.layer3Macro) {
				macro = button.layer3Macro;
			} else {
				// nothing assigned to this action.
				return;
			}
			break;
		default:
			// Invalid layer
			return;
	}
		
	
	if (action) {
		if (appendFlag) {
			[session appendActionText:action];
		} else {
			[session sendActionText:action];
		}
	} else if (macro) {
		MudInputFooter *foot = (MudInputFooter *)self.topController.footer;
		if (foot.inputTextView.text && ([foot.inputTextView.text length]>0)) {
			//NSMutableArray *lines = [[foot.inputTextView.text componentsSeparatedByRegex:@" "] mutableCopy];
            NSMutableArray *lines = [RegExpTools arrayOfComponentsFromString:foot.inputTextView.text withRegExp:@" "];
            
			[lines insertObject:@"" atIndex:0];
			[session processMacro:macro args:lines triggerExecuted:NO];
		} else {
			[session processMacro:macro args:nil triggerExecuted:NO];
		}
	} else {
		// bah
		return;
	}

}

- (void)clearButtons {

	for ( UIView *v in [self subviews]) {
		[v removeFromSuperview];
	}
}

- (void)drawButtons {

	UIInterfaceOrientation iPadOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	
	[self clearButtons];
	
	if ( (iPadOrientation == UIInterfaceOrientationLandscapeLeft) | (iPadOrientation == UIInterfaceOrientationLandscapeRight) ) {
		[self drawButtonsLandscape];
	} else {
		[self drawButtonsPortrait];
	}
		
	
}



- (void)drawButtonsLandscape {
		
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	int x;
	int y;
	
	int absy = 0;
	int absx = 0;
	
	UIButton *button = nil;
	
	for (y=1;y<=12;y++) {
		switch (y) {
			case 1:
				absy = 0;
				break;
			case 2:
				absy = 55;
				break;
			case 3:
				absy = 110;
				break;
			case 4:
				absy = 165;
				break;
			case 5:
				absy = 220;
				break;
			case 6:
				absy = 275;
				break;
			case 7:
				absy = 335;
				break;
			case 8:
				absy = 390;
				break;
			case 9:
				absy = 445;
				break;
			case 10:
				absy = 500;
				break;
			case 11:
				absy = 555;
				break;
			case 12:
				absy = 610;
				break;
		}
		for (x=1;x<=4;x++) {
			absx = (x-1) * 60 + 10;
			
			button = [[UIButton alloc] initWithFrame:CGRectMake(absx, absy, 45, 45)];
			[button setTag:x + (y*10)];
			//button.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.1f];
			button.opaque = YES;
			[button setContentMode:UIViewContentModeScaleAspectFit];
			
			[button addTarget:myAppDelegate.viewController.buttonPanel action:@selector(mainButtonClickUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];	
			[button addTarget:myAppDelegate.viewController.buttonPanel action:@selector(mainButtonClickDown:) forControlEvents:UIControlEventTouchDown];	
			
            [button.layer setBorderWidth:1.0];
            [button.layer setCornerRadius:3.0];
            [button.layer setBorderColor:[[UIColor colorWithWhite:0.15 alpha:0.7] CGColor]];
			[self addSubview:button];

        }
	}
	
	
}

- (void)drawButtonsPortrait {
		
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	int x;
	int y;
	
	int absy = 0;
	int absx = 0;
	
	UIButton *button = nil;
	
	for (y=1;y<=2;y++) {
		switch (y) {
			case 1:
				absy = 10;
				break;
			case 2:
				absy = 65;
				break;
		}
		
		for (x=1;x<=10;x++) {
			absx = (x * 70) + 18;
		
			
			button = [[UIButton alloc] initWithFrame:CGRectMake(absx, absy, 50, 45)];
			[button setTag:x + (y*10)];
			//button.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.1f];
			button.opaque = YES;
			[button setContentMode:UIViewContentModeScaleAspectFit];
			[button addTarget:myAppDelegate.viewController.buttonPanel action:@selector(mainButtonClickUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];	
			[button addTarget:myAppDelegate.viewController.buttonPanel action:@selector(mainButtonClickDown:) forControlEvents:UIControlEventTouchDown];	
			
            [button.layer setBorderWidth:1.0];
            [button.layer setCornerRadius:3.0];
            [button.layer setBorderColor:[[UIColor colorWithWhite:0.15 alpha:0.7] CGColor]];
			[self addSubview:button];
			button = nil;
		}
	}
	 
	

	button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(5, 10, 58, 44);
	[button setTag:1000];
	button.backgroundColor = [UIColor colorWithRed:0.3 green:0.0 blue:0.0 alpha:1.0];
	button.opaque = YES;
	[button addTarget:self action:@selector(altButtonClickUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];	
	[button addTarget:self action:@selector(altButtonClickDown:) forControlEvents:UIControlEventTouchDown];	
	[[button layer] setCornerRadius:8.0f];
	[[button layer] setMasksToBounds:YES];
	[[button layer] setBorderWidth:1.0f];
	
	[self addSubview:button];
	
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(5, 70, 58, 44);
	[button setTag:1001];
	button.backgroundColor = [UIColor colorWithRed:0.0 green:0.3 blue:0.0 alpha:1.0];
	button.opaque = YES;
	[button addTarget:self action:@selector(altButtonClickUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];	
	[button addTarget:self action:@selector(altButtonClickDown:) forControlEvents:UIControlEventTouchDown];	

	
	//[button setTitle:@"3" forState:UIControlStateNormal];
	[[button layer] setCornerRadius:8.0f];
	[[button layer] setMasksToBounds:YES];
	[[button layer] setBorderWidth:1.0f];
	[self addSubview:button];
}


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
   
		self.currentLayer = 1;
		
		clickSequence = 0;
		
		self.iconImages = [[NSArray alloc] initWithObjects:
                           @"arrow-down.png",
						   @"arrow-left.png",
						   @"arrow-right.png",
						   @"arrow-up.png",
						   @"help.png",
						   @"eye.png",
                           
						   nil];
		
		
	}
	self.opaque = YES;
    [self colorButtons];
	self.clipsToBounds = YES;
	[self drawButtons];
    return self;
}





@end
