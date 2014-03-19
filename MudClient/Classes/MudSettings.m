    //
//  MudSettings.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 7/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MudSettings.h"
#import "MudDataSettings.h"
#import "MudClientIpad4AppDelegate.h"
#import "MudDataSessions.h"
#import "MudClientIpad4ViewController.h"
#import "MudInputFooter.h"

@implementation MudSettings
 
@synthesize swapLineEndings, defaultColor, labelList, largerInputArea;

@synthesize topController, 	buttonBarsEnabled, buttonEdit, buttonShowTypedInput, buttonShowMacroOutput, swapColors, sessionData, dataCompression;

- (void)textFieldDidEndEditing:(UITextField *)textField {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudDataSettings *settingsRecord = [self getSettingsRecord];
	
	MudSession *session = [myAppDelegate getActiveSessionRef];
	session.commandSeparator = commandSeparator.text;
	
	[settingsRecord setCommandSeparator:commandSeparator.text];
	
	[myAppDelegate saveCoreData];
}


-(void)keyboardResetTapped:(id)sender {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	myAppDelegate.softwareKeyboardSeen = NO;
	[keyboardReset setTitle:@"Hardware" forState:UIControlStateNormal];
	
	[commandSeparator resignFirstResponder];
	
	MudInputFooter *footer = (MudInputFooter *)myAppDelegate.viewController.footer;
	[footer.inputTextView resignFirstResponder];
	
	MudDataSettings *settingsRecord = [self getSettingsRecord];
	[self.topController adjustViewSizes:settingsRecord];
}

-(void)largerInputAreaSwitch:(id)sender {
	UISwitch *userSwitch = (UISwitch *)sender;
	
	MudDataSettings *settingsRecord = [self getSettingsRecord];
	
	if ([userSwitch isOn] == YES) {
		[settingsRecord setLargeInputArea:[NSNumber numberWithBool:YES]];
	} else {
		[settingsRecord setLargeInputArea:[NSNumber numberWithBool:NO]];
	}
	
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	[myAppDelegate saveCoreData];		
	
	BOOL isPortrait = YES;
	if ( (myAppDelegate.viewController.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) | (myAppDelegate.viewController.interfaceOrientation == UIInterfaceOrientationLandscapeRight) ) {
		isPortrait = NO;
	}
	[myAppDelegate.viewController updateViewsForOrientation:isPortrait];
}


-(void)dataCompressionSwitch:(id)sender {
	UISwitch *userSwitch = (UISwitch *)sender;
	
	MudDataSettings *settingsRecord = [self getSettingsRecord];
	
	if ([userSwitch isOn] == YES) {
		[settingsRecord setDataCompression:[NSNumber numberWithBool:YES]];
	} else {
		[settingsRecord setDataCompression:[NSNumber numberWithBool:NO]];
	}
	
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	[myAppDelegate saveCoreData];		
}


-(void)sessionDataSwitch:(id)sender {
	UISwitch *userSwitch = (UISwitch *)sender;
	
	MudDataSettings *settingsRecord = [self getSettingsRecord];
	
	if ([userSwitch isOn] == YES) {
		[settingsRecord setStoreSessionData:[NSNumber numberWithBool:YES]];
	} else {
		[settingsRecord setStoreSessionData:[NSNumber numberWithBool:NO]];
	}
	
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
	
	session.keepSessionData = [userSwitch isOn];
	if (session.keepSessionData == YES) {
		if (!session.sessionRecord) {
			MudDataSessions *logSession = (MudDataSessions *)[NSEntityDescription insertNewObjectForEntityForName: @"MudDataSessions" inManagedObjectContext:myAppDelegate.context];
			
			[logSession setStartDate:[NSDate dateWithTimeIntervalSinceNow:0]];
			[logSession setCharacter:session.connectionData];
			
			session.sessionRecord = logSession;
			
		} 
		
	} else {
		session.sessionRecord = nil;
	}
	
	[myAppDelegate saveCoreData];		
}





-(void)buttonSwapColorsSwitch:(id)sender {
	UISwitch *userSwitch = (UISwitch *)sender;
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
	MudDataSettings *settingsRecord = [self getSettingsRecord];
	
	if ([userSwitch isOn] == YES) {
		[settingsRecord setSwapColors:[NSNumber numberWithBool:YES]];
		[session.nvtLineHandler setSwapColors:1];
	} else {
		[settingsRecord setSwapColors:[NSNumber numberWithBool:NO]];
		[session.nvtLineHandler setSwapColors:0];
	}	
	
	[myAppDelegate saveCoreData];	
	
}


-(MudDataSettings *)getSettingsRecord {
	MudDataSettings *settingsRecord = nil;
	switch (self.topController.MudActiveIndex) {
		case 1:
			settingsRecord = self.topController.mudSession1.settings;
			break;
		case 2:
			settingsRecord = self.topController.mudSession2.settings;
			break;
		case 3:
			settingsRecord = self.topController.mudSession3.settings;
			break;
		case 4:
			settingsRecord = self.topController.mudSession4.settings;
			break;
	}
	if (!settingsRecord) {
		NSLog(@"Returning nil settingsRecord");
	}
	return settingsRecord;
}


-(void)buttonLineEndingsSwitch:(id)sender {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	UISwitch *userSwitch = (UISwitch *)sender;
	MudDataSettings *settingsRecord = [self getSettingsRecord];
	
	if ([userSwitch isOn] == YES) {
		[settingsRecord setStandardLineFeed:[NSNumber numberWithBool:YES]];
	} else {
		[settingsRecord setStandardLineFeed:[NSNumber numberWithBool:NO]];
	}
	
	[myAppDelegate saveCoreData];	

}

	
-(void)buttonBarsEnabledSwitch:(id)sender {
	UISwitch *userSwitch = (UISwitch *)sender;
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudDataSettings *settingsRecord = [self getSettingsRecord];
	
	if ([userSwitch isOn] == YES) {
		[settingsRecord setButtonBars:[NSNumber numberWithBool:YES]];
		self.buttonEdit.enabled = YES;
	} else {
		[settingsRecord setButtonBars:[NSNumber numberWithBool:NO]];
		[self.buttonEdit setOn:NO];
		self.topController.buttonEditMode = 0;
		self.buttonEdit.enabled = NO;
	}
	
	[myAppDelegate saveCoreData];
    
    [self.topController updateViewsForFeatureChange];
	
	//[self.topController adjustViewSizes:settingsRecord];
	
	[self.view.superview bringSubviewToFront:self.view];
	
}

-(void)bottomInputBarSwitch:(id)sender {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	UISwitch *userSwitch = (UISwitch *)sender;
	MudDataSettings *settingsRecord = [self getSettingsRecord];
	
	if ([userSwitch isOn] == YES) {
		[settingsRecord setBottomLandscapeInputBar:[NSNumber numberWithBool:YES]];
	} else {
		[settingsRecord setBottomLandscapeInputBar:[NSNumber numberWithBool:NO]];
	}
	
	[myAppDelegate saveCoreData];
	
	if ( (myAppDelegate.viewController.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) | (myAppDelegate.viewController.interfaceOrientation == UIInterfaceOrientationLandscapeRight) ) {
		[myAppDelegate.viewController updateViewsForOrientation:NO];
	}

}

-(void)buttonShowTypedInputSwitch:(id)sender {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	UISwitch *userSwitch = (UISwitch *)sender;
	MudDataSettings *settingsRecord = [self getSettingsRecord];
	
	if ([userSwitch isOn] == YES) {
		[settingsRecord setEchoTypedOutput:[NSNumber numberWithBool:YES]];
	} else {
		[settingsRecord setEchoTypedOutput:[NSNumber numberWithBool:NO]];
	}
	
	[myAppDelegate saveCoreData];		

}

-(void)buttonShowMacroOutputSwitch:(id)sender {
	UISwitch *userSwitch = (UISwitch *)sender;
	MudDataSettings *settingsRecord = [self getSettingsRecord];
	
	if ([userSwitch isOn] == YES) {
		[settingsRecord setEchoMacroOutput:[NSNumber numberWithBool:YES]];
	} else {
		[settingsRecord setEchoMacroOutput:[NSNumber numberWithBool:NO]];
	}

	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	
	[myAppDelegate saveCoreData];	

}
	

-(void)buttonEditSwitch:(id)sender {
	if (sender && [sender isOn]) {
		self.topController.buttonEditMode = 1;
	} else {
		self.topController.buttonEditMode = 0;
	}
}

/*
- (void)aboutPressed:(id)sender {
		
	MudAbout *uv = [[[MudAbout alloc ] init] autorelease];
	
	[self.navigationController pushViewController:uv animated:YES];
	
}
 */


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CGSize contentSize;
    contentSize.width = 768;
    contentSize.height = 320;
    self.preferredContentSize = contentSize;
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	[myAppDelegate pointToDefaultKeyboardResponder];
}

-(void)supportTapped {
    [[SettingsTool settings] displayHelpForSection:kHelpSectionSettings];
}

-(void)headerTapped {
	MudClientIpad4ViewController *displayView = (MudClientIpad4ViewController *)self.topController;
	
	[displayView mudSettingsClicked:nil];
}


-(void)createViews {
	
	versionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	[versionLabel setText:[NSString stringWithFormat:@"v%@", [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]]];
	[versionLabel setFont:[UIFont boldSystemFontOfSize:8.0f]];
	[versionLabel setBackgroundColor:[UIColor clearColor]];
	[versionLabel setNumberOfLines:1];
	[self.view addSubview:versionLabel];
	

	supportButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [supportButton setTitle:@"Help" forState:UIControlStateNormal];
	[supportButton addTarget:self action:@selector(supportTapped) forControlEvents:UIControlEventTouchUpInside];
	supportButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
	supportButton.opaque = NO;
    [supportButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[self.view addSubview:supportButton];

	 
	 
	UILabel *l = nil;
	
	l = [[UILabel alloc] initWithFrame:CGRectZero];
	[l setText:@" Button Bars"];
	[l setFont:[UIFont boldSystemFontOfSize:14.0]];
	[l setBackgroundColor:[UIColor clearColor]];
	[l setNumberOfLines:2];
	[self.labelList addObject:l];
	[self.view addSubview:l];
	
	l = [[UILabel alloc] initWithFrame:CGRectZero];
	[l setText:@" Echo Typed Output"];
	[l setFont:[UIFont boldSystemFontOfSize:14.0]];
	[l setBackgroundColor:[UIColor clearColor]];
	[l setNumberOfLines:2];
	[self.labelList addObject:l];
	[self.view addSubview:l];
	
	l = [[UILabel alloc] initWithFrame:CGRectZero];
	[l setText:@" Echo Macro Output"];
	[l setFont:[UIFont boldSystemFontOfSize:14.0]];
	[l setBackgroundColor:[UIColor clearColor]];
	[l setNumberOfLines:2];
	[self.labelList addObject:l];
	[self.view addSubview:l];
	
	l = [[UILabel alloc] initWithFrame:CGRectZero];
	[l setText:@" Swap Colors"];
	[l setFont:[UIFont boldSystemFontOfSize:14.0]];
	[l setBackgroundColor:[UIColor clearColor]];
	[l setNumberOfLines:2];
	[self.labelList addObject:l];
	[self.view addSubview:l];
	
	l = [[UILabel alloc] initWithFrame:CGRectZero];
	[l setText:@"Send Each Line With:\n ON = CRLF OFF = CR"];
	[l setNumberOfLines:2];
	[l setFont:[UIFont boldSystemFontOfSize:14.0]];
	[l setBackgroundColor:[UIColor clearColor]];
	[self.labelList addObject:l];
	[self.view addSubview:l];
		
	l = [[UILabel alloc] initWithFrame:CGRectZero];
	[l setText:@" Save Session Transcript\n"];
	[l setFont:[UIFont boldSystemFontOfSize:14.0]];
	[l setBackgroundColor:[UIColor clearColor]];
	[l setNumberOfLines:2];
	[self.labelList addObject:l];
	[self.view addSubview:l];
	
	l = [[UILabel alloc] initWithFrame:CGRectZero];
	[l setText:@" Data Compression\n (MCCPv2)"];
	[l setFont:[UIFont boldSystemFontOfSize:14.0]];
	[l setBackgroundColor:[UIColor clearColor]];
	[l setNumberOfLines:2];
	[self.labelList addObject:l];
	[self.view addSubview:l];
	
		
	l = [[UILabel alloc] initWithFrame:CGRectZero];
	[l setText:@" Larger Text Input Area"];
	[l setFont:[UIFont boldSystemFontOfSize:14.0]];
	[l setBackgroundColor:[UIColor clearColor]];
	[l setNumberOfLines:2];
	[self.labelList addObject:l];
	[self.view addSubview:l];
	
	l = [[UILabel alloc] initWithFrame:CGRectZero];
	[l setText:@" Keyboard Type\n (tap to use hardware keyboard)"];
	[l setFont:[UIFont boldSystemFontOfSize:14.0]];
	[l setBackgroundColor:[UIColor clearColor]];
	[l setNumberOfLines:2];
	[self.labelList addObject:l];
	[self.view addSubview:l];
	
	l = [[UILabel alloc] initWithFrame:CGRectZero];
	[l setText:@" Command Separator"];
	[l setFont:[UIFont boldSystemFontOfSize:14.0]];
	[l setBackgroundColor:[UIColor clearColor]];
	[l setNumberOfLines:2];
	[self.labelList addObject:l];
	[self.view addSubview:l];
	
	buttonBarsEnabled = [[UISwitch alloc] initWithFrame:CGRectZero];
	[self.view addSubview:buttonBarsEnabled];
	
	buttonShowTypedInput = [[UISwitch alloc] initWithFrame:CGRectZero];
	[self.view addSubview:buttonShowTypedInput];
	
	buttonShowMacroOutput = [[UISwitch alloc] initWithFrame:CGRectZero];
	[self.view addSubview:buttonShowMacroOutput];
	
	swapColors = [[UISwitch alloc] initWithFrame:CGRectZero];
	[self.view addSubview:swapColors];
	
	swapLineEndings = [[UISwitch alloc] initWithFrame:CGRectZero];
	[self.view addSubview:swapLineEndings];
	
	sessionData = [[UISwitch alloc] initWithFrame:CGRectZero];
	[self.view addSubview:sessionData];
	
	dataCompression = [[UISwitch alloc] initWithFrame:CGRectZero];
	[self.view addSubview:dataCompression];
	
	largerInputArea = [[UISwitch alloc] initWithFrame:CGRectZero];
	[self.view addSubview:largerInputArea];
	
	keyboardReset = [UIButton buttonWithType:UIButtonTypeCustom];
	[[keyboardReset layer] setCornerRadius:6.0f];
	[[keyboardReset layer] setMasksToBounds:YES];
	[[keyboardReset layer] setBorderWidth:0.0f];
	[keyboardReset setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[keyboardReset setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.7]];
	[self.view addSubview:keyboardReset];
	
	commandSeparator = [[UITextField alloc] initWithFrame:CGRectZero];
    commandSeparator.keyboardAppearance = UIKeyboardAppearanceDark;
	commandSeparator.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
	commandSeparator.autocorrectionType = UITextAutocorrectionTypeNo;
	commandSeparator.autocapitalizationType = UITextAutocapitalizationTypeNone;
	[[commandSeparator layer] setCornerRadius:8.0f];
	[[commandSeparator layer] setMasksToBounds:YES];
	[[commandSeparator layer] setBorderWidth:0.0f];
	commandSeparator.delegate = self;
	[self.view addSubview:commandSeparator];
	
	[buttonBarsEnabled addTarget:self action:@selector(buttonBarsEnabledSwitch:) forControlEvents:UIControlEventValueChanged];
	[buttonShowTypedInput addTarget:self action:@selector(buttonShowTypedInputSwitch:) forControlEvents:UIControlEventValueChanged];
	[buttonShowMacroOutput addTarget:self action:@selector(buttonShowMacroOutputSwitch:) forControlEvents:UIControlEventValueChanged];
	[swapColors addTarget:self action:@selector(buttonSwapColorsSwitch:) forControlEvents:UIControlEventValueChanged];
	[swapLineEndings addTarget:self action:@selector(buttonLineEndingsSwitch:) forControlEvents:UIControlEventValueChanged];
	[sessionData addTarget:self action:@selector(sessionDataSwitch:) forControlEvents:UIControlEventValueChanged];
	[dataCompression addTarget:self action:@selector(dataCompressionSwitch:) forControlEvents:UIControlEventValueChanged];
	[bottomInputBar addTarget:self action:@selector(bottomInputBarSwitch:) forControlEvents:UIControlEventValueChanged];
	[largerInputArea addTarget:self action:@selector(largerInputAreaSwitch:) forControlEvents:UIControlEventValueChanged];

	
	[keyboardReset addTarget:self action:@selector(keyboardResetTapped:) forControlEvents:UIControlEventTouchUpInside];
	
}

-(void)updateViews {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	
	MudDataSettings *settingsRecord = [self getSettingsRecord];
	
	[buttonBarsEnabled setOn:[[settingsRecord buttonBars] boolValue]];
	[buttonShowTypedInput setOn:[[settingsRecord EchoTypedOutput] boolValue]];
	[buttonShowMacroOutput setOn:[[settingsRecord EchoMacroOutput] boolValue]];
	[swapColors setOn:[[settingsRecord swapColors] boolValue]];
	[swapLineEndings setOn:[[settingsRecord standardLineFeed] boolValue]];
	[sessionData setOn:[[settingsRecord storeSessionData] boolValue]];
	[dataCompression setOn:[[settingsRecord dataCompression] boolValue]];
	
	

	
	[bottomInputBar setOn:[[settingsRecord bottomLandscapeInputBar] boolValue]];
	
	[largerInputArea setOn:[[settingsRecord largeInputArea] boolValue]];
	
	if (myAppDelegate.softwareKeyboardSeen) {
		[keyboardReset setTitle:@"Software" forState:UIControlStateNormal];
	} else {
		[keyboardReset setTitle:@"Hardware" forState:UIControlStateNormal];
	}
	
	commandSeparator.text = [settingsRecord commandSeparator];
	
}

-(void)positionViews:(UIInterfaceOrientation )forOrientation offScreen:(BOOL)offScreen {
	BOOL isPortrait;
	
	if ( (forOrientation == UIInterfaceOrientationPortrait) | (forOrientation == UIInterfaceOrientationPortraitUpsideDown) ) {
		
		float xLoc = 68;
		
		if (offScreen) {
			xLoc = 768;
		}
		
		self.view.frame = CGRectMake(xLoc,60,680,660);
		isPortrait = YES;
		header.frame = CGRectMake(384 - 68 - 225, 15,500,40);
		
		versionLabel.frame = CGRectMake(640,10,40,10);
		
		supportButton.frame = CGRectMake(10,20,80,30);
		
	} else {
		
		float xLoc = 64;
		
		if (offScreen) {
			xLoc = 1024;
		}
		
		self.view.frame = CGRectMake(xLoc,64,900,350);
		isPortrait = NO;
		header.frame = CGRectMake(512 - 64 - 250, 15,500,40);
		
		versionLabel.frame = CGRectMake(870,10,30,10);
		
		supportButton.frame = CGRectMake(10,20,80,30);
	
		
		
	}
    
    CGSize size = header.bounds.size;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(-2,-2)];
    [path addLineToPoint:CGPointMake(size.width,-2)];
    [path addLineToPoint:CGPointMake(size.width,size.height+4)];
    [path addLineToPoint:CGPointMake(-2, size.height+4)];
    [path addLineToPoint:CGPointMake(-2, -2)];
    
    header.layer.shadowPath = path.CGPath;

    
    
	headerButton.frame = header.frame;
	[self.view bringSubviewToFront:headerButton];
	[self.view bringSubviewToFront:supportButton];
	
	int labelCount = [labelList count];
	for (int x=0;x<labelCount;x++) {
		
		float xLoc;
		float yLoc;
		
		if (isPortrait) {
			switch (x) {
				case 0:
					xLoc = 10;
					yLoc = 10;
					break;
				case 1:
					xLoc = 10;
					yLoc = 60;
					break;
				case 2:
					xLoc = 10;
					yLoc = 110;
					break;
				case 3:
					xLoc = 10;
					yLoc = 160;
					break;
				case 4:
					xLoc = 10;
					yLoc = 210;
					break;
				case 5:
					xLoc = 10;
					yLoc = 260;
					break;
				case 6:
					xLoc = 10;
					yLoc = 310;
					break;
				case 7:
					xLoc = 10;
					yLoc = 360;
					break;
				case 8:
					xLoc = 10;
					yLoc = 410;
					break;
				case 9:
					xLoc = 10;
					yLoc = 460;
					break;	
				case 10:
					xLoc = 10;
					yLoc = 510;
					break;	
				case 11:
					xLoc = 310;
					yLoc = 10;
					break;	
				case 12:
					xLoc = 310;
					yLoc = 60;
					break;
				case 13:
					xLoc = 310;
					yLoc = 110;
					break;
				case 14:
					xLoc = 310;
					yLoc = 160;
					break;
			}
            yLoc += 60;
			xLoc += 40 + 140;
		} else {
			switch (x) {
				case 0:
					xLoc = 10;
					yLoc = 10;
					break;
				case 1:
					xLoc = 10;
					yLoc = 60;
					break;
				case 2:
					xLoc = 10;
					yLoc = 110;
					break;
				case 3:
					xLoc = 10;
					yLoc = 160;
					break;
				case 4:
					xLoc = 10;
					yLoc = 210;
					break;
				case 5:
					xLoc = 310;
					yLoc = 10;
					break;
				case 6:
					xLoc = 310;
					yLoc = 60;
					break;
				case 7:
					xLoc = 310;
					yLoc = 110;
					break;
				case 8:
					xLoc = 310;
					yLoc = 160;
					break;
				case 9:
					xLoc = 310;
					yLoc = 210;
					break;	
				case 10:
					xLoc = 610;
					yLoc = 10;
					break;	
				case 11:
					xLoc = 610;
					yLoc = 60;
					break;	
				case 12:
					xLoc = 610;
					yLoc = 110;
					break;
				case 13:
					xLoc = 610;
					yLoc = 160;
					break;
				case 14:
					xLoc = 610;
					yLoc = 210;
					break;
					
			}
            xLoc += 150;
			
			yLoc += 60;
		}
		
		UILabel *l = (UILabel *)[labelList objectAtIndex:x];
		l.frame = CGRectMake(xLoc,yLoc,280,44);
		l.font = [UIFont systemFontOfSize:12.0];
		//l.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.7 alpha:0.5];
        
        l.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        
        l.layer.shadowColor = [[UIColor blackColor] CGColor];
		l.layer.shadowOffset = CGSizeMake(2.0f,2.0f);
		l.layer.shadowOpacity = .5f;
		l.layer.shadowRadius = 2.0f;
		l.clipsToBounds = NO;
        
		
		CGSize size = l.bounds.size;
		UIBezierPath *path = [UIBezierPath bezierPath];
		[path moveToPoint:CGPointMake(-2,-2)];
		[path addLineToPoint:CGPointMake(size.width,-2)];
		[path addLineToPoint:CGPointMake(size.width,size.height+4)];
		[path addLineToPoint:CGPointMake(-2, size.height+4)];
		[path addLineToPoint:CGPointMake(-2, -2)];
		
		l.layer.shadowPath = path.CGPath;
        
		switch (x) {
			case 0:				
				buttonBarsEnabled.frame = CGRectMake(xLoc+180,yLoc+8,80,44);
				break;
			case 1:
				buttonShowTypedInput.frame = CGRectMake(xLoc+180,yLoc+8,80,44);
				break;
			case 2:	
				buttonShowMacroOutput.frame = CGRectMake(xLoc+180,yLoc+8,80,44);
				break;
			case 3:
				swapColors.frame = CGRectMake(xLoc+180,yLoc+8,80,44);
				break;
			case 4:				
				swapLineEndings.frame = CGRectMake(xLoc+180,yLoc+8,80,44);
				break;
			
			case 5:
				sessionData.frame = CGRectMake(xLoc+180,yLoc+8,80,44);
				break;
			case 6:
				dataCompression.frame = CGRectMake(xLoc+180,yLoc+8,80,44);
				break;
			case 7:
				largerInputArea.frame = CGRectMake(xLoc+180,yLoc+8,80,44);
				break;
			case 8:
				keyboardReset.frame = CGRectMake(xLoc+180,yLoc+6,95,32);
				break;
			case 9:
				commandSeparator.frame = CGRectMake(xLoc+180,yLoc+10,95,24);
				break;
		}
	}
}



- (void)loadView {
	
	self.view = [[UIView alloc] initWithFrame:CGRectZero];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
    self.view.opaque = YES;
	self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
	[[self.view layer] setCornerRadius:8.0f];
	[[self.view layer] setMasksToBounds:YES];
	[[self.view layer] setBorderWidth:0.0f];
	
	header = [[UILabel alloc] initWithFrame:CGRectZero];
	[header setText:@"Settings for the Current Connection"];
	[header setFont:[UIFont boldSystemFontOfSize:20.0]];
	[header setTextAlignment:NSTextAlignmentCenter];
	//header.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.7 alpha:0.5];
	header.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    header.layer.shadowColor = [[UIColor blackColor] CGColor];
    header.layer.shadowOffset = CGSizeMake(2.0f,2.0f);
    header.layer.shadowOpacity = .5f;
    header.layer.shadowRadius = 2.0f;
    header.clipsToBounds = NO;
   
	[self.view addSubview:header];
    
	headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[headerButton addTarget:self action:@selector(headerTapped) forControlEvents:UIControlEventTouchUpInside];
	headerButton.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.1];
	[self.view addSubview:headerButton];
	
	[self.view bringSubviewToFront:headerButton];
	
	self.labelList = [[NSMutableArray alloc] initWithCapacity:50];
	[self createViews];
	
	UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTappedBackground:)];
	[self.view addGestureRecognizer:tapG];
	
}

-(void)userTappedBackground:(UITapGestureRecognizer *)g {
    MudClientIpad4ViewController *displayView = (MudClientIpad4ViewController *)self.topController;
	
    if (g.state == UIGestureRecognizerStateEnded) {
        [self.view removeFromSuperview];
        displayView.settingsActive = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	[myAppDelegate saveCoreData];		
}


- (void)viewWillAppear:(BOOL)animated {
	UIInterfaceOrientation iPadOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	[self updateViews];
	[self positionViews:iPadOrientation offScreen:NO];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
}





@end
