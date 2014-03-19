//
//  MudClientIpad4ViewController.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 6/29/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//
#import "MudClientIpad4ViewController.h"
#import "MudVariables.h"
#import "MudTriggers.h"
#import "MudMacros.h"
#import "MudSettings.h"
#import "MudAddConnections.h"
#import "ButtonPanel.h"
#import "MudConnectionInstance.h"
#import "MudPreviousCommands.h"
#import "MudSession.h"
#import "MudClientIpad4AppDelegate.h"
#import "MudDataSessionData.h"
#import "MudDataSessions.h"
#import "MudButtonsDetail.h"
#import "SpeedwalkingList.h"
#import "TouchableTexts.h"
#import "MudAliases.h"
#import "RemoteServer.h"

@implementation MudClientIpad4ViewController {
   
}

@synthesize HelpButton;
@synthesize MudPickButton;
@synthesize mainToolbar;

@synthesize mudVarPopoverController;
@synthesize mudVariables;

@synthesize mudTriggerPopoverController;
@synthesize mudTriggers;

@synthesize mudMacroPopoverController;
@synthesize mudMacros;

@synthesize mudButtonPopoverController;
@synthesize mudButtons;

@synthesize mudPreviousCommandsPopoverController;
@synthesize mudPreviousCommands;

@synthesize mudSettingPopoverController;
@synthesize mudSettings;

@synthesize mudAddConnectionPopoverController;
@synthesize mudAddConnections;

@synthesize mudSpeedwalkingPopoverController;
@synthesize mudTouchableTextsPopoverController;

@synthesize mudSpeedwalking;
@synthesize mudTouchableTexts;

@synthesize MudSpacer, MudVr, MudTr, MudMa, MudSe, MudSp, MudTt, MudAl;

@synthesize MudActiveIndex, context, window;

@synthesize displayTableView, buttonPanel;

@synthesize mudConnectionInstance;

@synthesize mudConnectionInstancePopoverController;

@synthesize buttonEditMode;

@synthesize footer;

@synthesize connectionButton1,connectionButton2,connectionButton3,connectionButton4, mudSession1, mudSession2, mudSession3, mudSession4;

@synthesize landscapeConnectionPopoverController,landscapeConnection;

@synthesize settingsActive;
@synthesize mudAliases, mudAliasPopoverController   ;

-(void)updateViewsForOrientation:(BOOL)orientationIsPortrait {
	
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
   
	
	[iPage positionViews:orientationIsPortrait ? UIInterfaceOrientationPortrait : UIInterfaceOrientationLandscapeLeft];
	
	self.displayTableView.frame = [self figureFrameBounds:1 sessionSettings:[myAppDelegate getActiveSessionRef].settings];
	
	self.buttonPanel.frame = [self figureFrameBounds:3 sessionSettings:[myAppDelegate getActiveSessionRef].settings];
	
	self.mainToolbar.frame = [self figureFrameBounds:6 sessionSettings:[myAppDelegate getActiveSessionRef].settings];	
	
	if (self.mudSettings) {
		[(MudSettings *)self.mudSettings positionViews:self.interfaceOrientation offScreen:NO];
	}
		
	MudInputFooter *f = (MudInputFooter *)self.footer;
	
	f.frame	 = [self figureFrameBounds:2 sessionSettings:[myAppDelegate getActiveSessionRef].settings];	

	[f updateOrientation:orientationIsPortrait];
	
	[(ButtonPanel *)self.buttonPanel populateButtons];
	
	MudSession *session = [myAppDelegate getActiveSessionRef];
	
	if (orientationIsPortrait == YES) {
		self.navigationController.toolbarHidden = YES;
		self.displayTableView.backgroundColor =[[SettingsTool settings] stdBackgroundColor];
        //[myAppDelegate computeBackgroundColorForSlider:[session.settings.defaultBackgroundColor floatValue]];
	
		
		
	} else {
		self.navigationController.toolbarHidden = YES;
		self.displayTableView.backgroundColor = [[SettingsTool settings] stdBackgroundColor];
			
	
		
	}
    
    session.lineWidthInChars = (self.displayTableView.frame.size.width / [session.nvtLineHandler widthForCurrentFont]) -1;
	//NSLog(@"Setting line width to %d characters for the current font.(%f / %f)", session.lineWidthInChars , self.displayTableView.frame.size.width,[session.nvtLineHandler widthForCurrentFont] );
	[session requestNAWS];
}




- (void)adjustViewSizes:(MudDataSettings *)settings {
	//Update view sizes based on settings/keyboard
	
	if (!settings) {
		NSLog(@"NO settings in adjustviewSizes");
		return;
	}
	
	[self.displayTableView setFrame:[self figureFrameBounds:4 sessionSettings:settings]];
	[(MudInputFooter *)self.footer setFrame:[self figureFrameBounds:2 sessionSettings:settings]];
	[self.buttonPanel setFrame:[self figureFrameBounds:3 sessionSettings:settings]];
		
	BOOL useButtonPanel = [[settings buttonBars] boolValue];
	
	ButtonPanel	*bp = nil;
	for (NSObject *v in [self.view subviews]) {
		if ((int)v == (int)self.buttonPanel) {
			bp = (ButtonPanel *)v;
			if (useButtonPanel == NO)
				[bp removeFromSuperview];
			break;
		}
	}
	
	if ( ( useButtonPanel == YES) && (!bp)) {
		[self.view addSubview:self.buttonPanel];
	}
	
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
	
	
	int rowCount = [session.connectionText count];
	if (rowCount >0) {
		NSIndexPath *ip = [NSIndexPath indexPathForRow:rowCount-1 inSection:0];
		[self.displayTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO];
	}
	
	
	UIInterfaceOrientation iPadOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	
	if ( (iPadOrientation == UIInterfaceOrientationLandscapeLeft) | (iPadOrientation == UIInterfaceOrientationLandscapeRight) ) {
		if (useButtonPanel == YES) {
			[myAppDelegate setTextWindowWidth:84];
		} else {
			[myAppDelegate setTextWindowWidth:112];
		}
		
	} else {
		[myAppDelegate setTextWindowWidth:84];
	}
	
	[myAppDelegate setTextWindowHeight:40];
	
	if (session != nil) {
		[session requestNAWS];

	}
}
- (void) viewWillDisappear:(BOOL)animated {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	[myAppDelegate saveCoreData];

}
-(void)switchToWindow:(int)windowNumber newConnection:(BOOL)newConnection {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	   
	if (windowNumber == self.MudActiveIndex) {
			MudSession *session = [myAppDelegate getActiveSessionRef];
		
		
		[(MudInputFooter *)self.footer updateReconnectState:session.currentConnectionState session:session];
		[self.displayTableView reloadData];
        [[RemoteServer tool] updateRemote];
		return;
	}
	
	self.MudActiveIndex = windowNumber;
	
	//NSLog(@"Selecting %d", self.MudActiveIndex);
	int tableRowCount = 0;
	
	
	MudDataSettings *settings = nil;
	
	switch (windowNumber) {
		case 1:
			[self.displayTableView setDelegate:self.mudSession1];
			[self.displayTableView setDataSource:self.mudSession1];
			[self.displayTableView reloadData];
			tableRowCount = [self.mudSession1.connectionText count]-1;
			[self.mudSession1 populateSettings];
			settings = self.mudSession1.settings;
			[(MudInputFooter *)self.footer updateReconnectState:self.mudSession1.currentConnectionState session:self.mudSession1];
			break;
		case 2:;
			[self.displayTableView setDelegate:self.mudSession2];
			[self.displayTableView setDataSource:self.mudSession2];
			[self.displayTableView reloadData];
			tableRowCount = [self.mudSession2.connectionText count]-1;
			[self.mudSession2 populateSettings];
			settings = self.mudSession2.settings;
			[(MudInputFooter *)self.footer updateReconnectState:self.mudSession2.currentConnectionState session:self.mudSession2];
			break;
		case 3:
			[self.displayTableView setDelegate:self.mudSession3];
			[self.displayTableView setDataSource:self.mudSession3];
			[self.displayTableView reloadData];
			tableRowCount = [self.mudSession3.connectionText count]-1;
			[self.mudSession3 populateSettings];
			settings = self.mudSession3.settings;
			[(MudInputFooter *)self.footer updateReconnectState:self.mudSession3.currentConnectionState session:self.mudSession3];
			break;	
		case 4:
			[self.displayTableView setDelegate:self.mudSession4];
			[self.displayTableView setDataSource:self.mudSession4];
			[self.displayTableView reloadData];
			tableRowCount = [self.mudSession4.connectionText count]-1;
			[self.mudSession4 populateSettings];
			settings = self.mudSession4.settings;
			[(MudInputFooter *)self.footer updateReconnectState:self.mudSession1.currentConnectionState session:self.mudSession4];
			break;	
	}
	
	[myAppDelegate pointToDefaultKeyboardResponder];
	
	if (self.mudPreviousCommands) {
		MudPreviousCommands *pc = (MudPreviousCommands *)self.mudPreviousCommands;
		[pc.tv reloadData];
	}
	
	if (self.mudSettings) {
		MudSettings *ms = (MudSettings *)self.mudSettings;
		[ms updateViews];
	}
	
	if (self.mudMacros) {
		MudMacros *pc = (MudMacros *)self.mudMacros;
			
		[pc.navigationController popToRootViewControllerAnimated:NO];
		
		[pc.tv reloadData];
	
	}
	
	if (self.mudTriggers) {
		MudTriggers *pc = (MudTriggers *)self.mudTriggers;
			
		[pc.navigationController popToRootViewControllerAnimated:NO];
		[pc.tv reloadData];
	}
	
    if (self.mudSpeedwalking) {
		MudTriggers *pc = (MudTriggers *)self.mudTriggers;
        
		[pc.navigationController popToRootViewControllerAnimated:NO];
		[pc.tv reloadData];
	}
    
    if (self.mudTouchableTexts) {
		MudTriggers *pc = (MudTriggers *)self.mudTriggers;
        
		[pc.navigationController popToRootViewControllerAnimated:NO];
		[pc.tv reloadData];
	}
    
	if (self.mudVariables) {
		MudVariables *pc = (MudVariables *)self.mudVariables;
			
		[pc.navigationController popToRootViewControllerAnimated:NO];
		[pc.tv reloadData];
	}
	
	[self adjustViewSizes:settings];	
	
	
	if (tableRowCount <0) {
		tableRowCount = 0;
	}
	if (tableRowCount >0) {
		NSIndexPath *ip = [NSIndexPath indexPathForRow:tableRowCount inSection:0];
		[self.displayTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO];
	}
	
	[self buildMainToolbar];
	
	if (self.mudConnectionInstance) {
		[(MudConnectionInstance *)self.mudConnectionInstance updateViewState:nil];
	}
	[(ButtonPanel *)self.buttonPanel populateButtons];
	
	UIInterfaceOrientation iPadOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	if ( (iPadOrientation == UIInterfaceOrientationLandscapeLeft) | (iPadOrientation == UIInterfaceOrientationLandscapeRight) ) {
		[(MudInputFooter *)self.footer updateOrientation:NO];
	} else {
		[(MudInputFooter *)self.footer updateOrientation:YES];
	}
    [[RemoteServer tool] updateRemote];
    
}

-(void)connectionDestroy:(int)connectionIndex {
	[self dismissPopovers];
	//NSLog(@"Destroying: %d", connectionIndex)
	
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
	
	
	
	if (!session) {
		return;
	}
	
	[session disconnectSession];

	session = nil;
	
	switch (connectionIndex) {
		case 1:
			self.connectionButton1 = nil;
			self.mudSession1 = nil;
			break;
		case 2:
			self.connectionButton2 = nil;
			self.mudSession2 = nil;
			break;
		case 3:
			self.connectionButton3 = nil;
			self.mudSession3 = nil;
			break;
		case 4:
			self.connectionButton4 = nil;
			self.mudSession4 = nil;
			break;
	}
	
	int firstConnectedSlot = 0;
	
	if (self.connectionButton1) {
		firstConnectedSlot = 1;
	} else if (self.connectionButton2) {
		firstConnectedSlot = 2;
	} else if (self.connectionButton3) {
		firstConnectedSlot = 3;
	} else if (self.connectionButton4) {
		firstConnectedSlot = 4;
	}
	
	
	
	if (!firstConnectedSlot) {
		[self destroyConnectionUserInterface];
		[self buildMainToolbar];
		self.MudActiveIndex = 0;
		[iPage positionViews:self.interfaceOrientation];
	} else {
		[self switchToWindow:firstConnectedSlot newConnection:NO];
		
	}
	
    [[RemoteServer tool] updateRemote];
    
	
	
}
-(void)connectionRequest:(MudDataCharacters *)selectedCharacter {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	UIInterfaceOrientation iPadOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	
	[self dismissPopovers];
	
	int firstFreeSlot = 0;
	int NumSlotsOccupied = 0;
	int selectedChar = 0;
	
	if (self.connectionButton1) {
		NumSlotsOccupied++;
		if ([self.mudSession1.connectionData objectID] == [selectedCharacter objectID]) { selectedChar = 1; }
	} else if (!firstFreeSlot) { firstFreeSlot = 1; };
	
	if (self.connectionButton2) {
		NumSlotsOccupied++;
		if ([self.mudSession2.connectionData objectID] == [selectedCharacter objectID]) { selectedChar = 2; }
	} else if (!firstFreeSlot) { firstFreeSlot = 2; };
	
	if (self.connectionButton3) {
		NumSlotsOccupied++;
		if ([self.mudSession3.connectionData objectID] == [selectedCharacter objectID]) { selectedChar = 3; }
	} else if (!firstFreeSlot) { firstFreeSlot = 3; };
	
	if (self.connectionButton4) {
		NumSlotsOccupied++;
		if ([self.mudSession4.connectionData objectID] == [selectedCharacter objectID]) { selectedChar = 4; }
	} else if (!firstFreeSlot) { firstFreeSlot = 4; };
	
	
	
	//Switch to the already existing active session if exists and not already viewing.
	if (selectedChar) {
		if (selectedChar != self.MudActiveIndex) {
			[self switchToWindow:selectedChar newConnection:NO];
		}
		return;
	}

	//check for a free connectionbutton
	if (NumSlotsOccupied >= 4) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Limit" message:@"Only 4 simultaneous sessions are supported." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
		return;
	}
	
	
	self.MudActiveIndex = firstFreeSlot;
		
	// Create our button and put it in the instance var.
	NSString *slotTitle;
	
	if ([[selectedCharacter characterName] length]) {
		slotTitle = [NSString stringWithFormat:@"%@", [selectedCharacter characterName]];
	} else if ([[selectedCharacter serverTitle] length]) {
		slotTitle = [NSString stringWithFormat:@"%@", [selectedCharacter serverTitle]];
	} else {
		slotTitle = @"Unnamed";
	}
	
	int slotTitleLength = [slotTitle length];
	
	if (slotTitleLength > 10) {
		slotTitle = [slotTitle substringToIndex:10];
	}
	
	
	UIBarButtonItem *MudInstance = [[UIBarButtonItem alloc] initWithTitle:slotTitle
																	style:UIBarButtonItemStyleBordered
																   target:self
																	action:@selector(connectButtonClick:)];
	
	
	MudSession *mudSession = [[MudSession alloc] init];
	
	[mudSession setSlotID:firstFreeSlot];
	[mudSession setConnectionData:selectedCharacter];
	[mudSession setParentView:self];
	
	[mudSession populateSettings];
    
	[mudSession populateCoreDataArray:1];
	[mudSession populateCoreDataArray:2];
	[mudSession populateCoreDataArray:3];
    [mudSession populateCoreDataArray:4];
    [mudSession populateCoreDataArray:5];
    [mudSession populateCoreDataArray:6];
    
	switch (firstFreeSlot) {
		case 1:
			self.connectionButton1 = MudInstance;
			self.mudSession1 = mudSession;
			break;
		case 2:
			connectionButton2 = MudInstance;
			self.mudSession2 = mudSession;
			break;	
		case 3:
			connectionButton3 = MudInstance;
			self.mudSession3 = mudSession;
			break;
		case 4:
			connectionButton4 = MudInstance;
			self.mudSession4 = mudSession;
			break;
		default:
			break;
	}
	
	if (!NumSlotsOccupied) {
		[self loadConnectionUserInterface];
	}
	
	switch (firstFreeSlot) {
		case 1:
			[self.displayTableView setDelegate:self.mudSession1];
			[self.displayTableView setDataSource:self.mudSession1];
			break;
		case 2:
			[self.displayTableView setDelegate:self.mudSession2];
			[self.displayTableView setDataSource:self.mudSession2];
			break;	
		case 3:
			[self.displayTableView setDelegate:self.mudSession3];
			[self.displayTableView setDataSource:self.mudSession3];
			break;
		case 4:
			[self.displayTableView setDelegate:self.mudSession4];
			[self.displayTableView setDataSource:self.mudSession4];
			break;
		default:
			break;
	}
	
	
	if (self.mudPreviousCommands) {
		MudPreviousCommands *pc = (MudPreviousCommands *)self.mudPreviousCommands;
		[pc PullRecordsforList];
		[pc.tv reloadData];
	}
	
	if (self.mudSettings) {
		MudSettings *v = (MudSettings *)self.mudSettings;
		[v updateViews];
	}
	
	if (self.mudMacros) {
		MudMacros *pc = (MudMacros *)self.mudMacros;
		[pc.tv reloadData];
	}
	
	if (self.mudTriggers) {
		MudTriggers *pc = (MudTriggers *)self.mudTriggers;
		[pc.tv reloadData];
	}
	
	if (self.mudVariables) {
		MudVariables *pc = (MudVariables *)self.mudVariables;
		[pc.tv reloadData];
	}
	
	[(ButtonPanel *)self.buttonPanel populateButtons];
	[self.displayTableView reloadData];
	
	[self buildMainToolbar];
	
	[mudSession openConnection];
	
	if (mudSession.keepSessionData == YES) {
		if (!mudSession.sessionRecord) {
			MudDataSessions *logSession = (MudDataSessions *)[NSEntityDescription insertNewObjectForEntityForName: @"MudDataSessions" inManagedObjectContext:myAppDelegate.context];
			
			[logSession setStartDate:[NSDate dateWithTimeIntervalSinceNow:0]];
			[logSession setCharacter:mudSession.connectionData];
			
			mudSession.sessionRecord = logSession;
			
		} 
	}
	
	MudInputFooter *tmpFooter = (MudInputFooter *)self.footer;
	[tmpFooter.inputTextView becomeFirstResponder];
	
	if ( (iPadOrientation == UIInterfaceOrientationPortrait) | (iPadOrientation == UIInterfaceOrientationPortraitUpsideDown) ) {
		[self updateViewsForOrientation:YES];
	} else {
		[self updateViewsForOrientation:NO];
	}
	
	
	[mudSession sendLineToMud:@"Connecting" fromUser:NO fromMacro:NO shallDisplay:YES LogPrevCommands:NO];
	//NSLog(@"Connecting with %@",  myAppDelegate.internetStatus == 2 ? @"Wifi" : @"WWAN");
	
    [[RemoteServer tool] updateRemote];
    
}

-(void)mudConnectionInstanceClickedLandscape:(int)SenderofClick{
	
	if (!mudConnectionInstancePopoverController) {
		MudConnectionInstance *uv = [[MudConnectionInstance alloc] init];
		mudConnectionInstance = uv;
		uv.topController = self;
		UINavigationController *localNavigationController = [[UINavigationController alloc] initWithRootViewController:mudConnectionInstance];
		[localNavigationController setToolbarHidden:YES];
		[localNavigationController setNavigationBarHidden:NO]; 
		
		
		UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:localNavigationController];
		[popover setPopoverContentSize:CGSizeMake(560,100) animated:NO];
		self.mudConnectionInstancePopoverController = popover;
		uv.topController = self;
		[popover setDelegate:uv];
	}	
	
		
	if (![mudConnectionInstancePopoverController isPopoverVisible]) {
		MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
		MudConnectionInstance *m = (MudConnectionInstance *)self.mudConnectionInstance;
		
		[m updateViewState:nil];
		
		MudSession *session = [myAppDelegate getActiveSessionRef];
		BOOL largeInputArea =  [[session.settings largeInputArea] boolValue];
		BOOL bottomInput = [[session.settings bottomLandscapeInputBar] boolValue];
		if (myAppDelegate.softwareKeyboardSeen) {
			bottomInput = NO;
		}
		int x;
		int y;
		
		if (largeInputArea) {
			x = 800 + ((SenderofClick)*40);
			y = 75;
		} else {
			x = 740 + (SenderofClick*50);
			y  = 40;
		}
		
		if (bottomInput) {
			y = 728;
		}
		
	
		[mudConnectionInstancePopoverController setPopoverContentSize:CGSizeMake(560,100) animated:NO];
		[mudConnectionInstancePopoverController presentPopoverFromRect:CGRectMake(x,y,1,1) inView:myAppDelegate.viewController.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
		 
	}	
	
}


-(void)mudConnectionInstanceClicked:(id)sender{
	
	if (!mudConnectionInstancePopoverController) {
		MudConnectionInstance *uv = [[MudConnectionInstance alloc] init];
		mudConnectionInstance = uv;
		uv.topController = self;
		UINavigationController *localNavigationController = [[UINavigationController alloc] initWithRootViewController:mudConnectionInstance];
		[localNavigationController setToolbarHidden:YES];
		[localNavigationController setNavigationBarHidden:NO]; 
		
		
		UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:localNavigationController];
		[popover setPopoverContentSize:CGSizeMake(560,100) animated:NO];
		self.mudConnectionInstancePopoverController = popover;
		uv.topController = self;
		[popover setDelegate:uv];
	} else {
		[self.mudConnectionInstance.navigationController popToRootViewControllerAnimated:NO];
	}
	
	UIBarButtonItem *button;
	
	switch (self.MudActiveIndex) {
		case 1:
			button = self.connectionButton1;
			break;
		case 2:
			button = self.connectionButton2;
			break;
		case 3:
			button = self.connectionButton3;
			break;
		case 4:
			button = self.connectionButton4;
			break;
		default:
			return;
			break;
	}
	
	if (![mudConnectionInstancePopoverController isPopoverVisible]) {
		
		MudConnectionInstance *m = (MudConnectionInstance *)self.mudConnectionInstance;
		

		[m updateViewState:nil];
		[mudConnectionInstancePopoverController setPopoverContentSize:CGSizeMake(560,100) animated:NO];
		[mudConnectionInstancePopoverController presentPopoverFromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}	
	
}




- (void)destroyConnectionUserInterface {

	[self.displayTableView removeFromSuperview];
	[self.buttonPanel removeFromSuperview];
	[(MudInputFooter *)self.footer removeFromSuperview];
	
}

#define kViewBounds


- (CGRect)figureFrameBounds:(int)whichComponent sessionSettings:(MudDataSettings *)settings {
	
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	UIInterfaceOrientation iPadOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	
	
	if ( (iPadOrientation == UIInterfaceOrientationLandscapeLeft) | (iPadOrientation == UIInterfaceOrientationLandscapeRight) ) {
		

		
		
		
		return [self figureFrameBoundsLandscape:whichComponent sessionSettings:settings];
	} else {
		return [self figureFrameBoundsPortrait:whichComponent sessionSettings:settings];
	}
	
	
}


- (CGRect)figureFrameBoundsLandscape:(int)whichComponent sessionSettings:(MudDataSettings *)settings {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	int x = 0;
	int y = 0;
	int h = 0;
	int w = 1024;
	
	BOOL bPanelEnabled = YES;
	BOOL bottomInputBar = YES;
	BOOL largeInputBar = YES;
	
	if (settings && ([[settings buttonBars] intValue] == NO)) {
		bPanelEnabled = NO;
	}
	
	if (settings && ([[settings bottomLandscapeInputBar] intValue] == NO)) {
		bottomInputBar = NO;
	}
	
	if (myAppDelegate.softwareKeyboardSeen) {
		bottomInputBar = NO;
	}
	
	if (settings && ([[settings largeInputArea] intValue] == NO)) {
		largeInputBar = NO;
	}
	
	switch (whichComponent) {
		case 1: // scrollview
		case 4:
            if (myAppDelegate.tvReady) {
                x = 0;
                y = 0;
                h = 720;
                w = 1280;
                
            } else {
                if (bPanelEnabled == YES) {
                    w = 780;
                } else {
                    w = 1024;
                }
                
                h = 768 - 354 - 64 - 44;
                
                if (!myAppDelegate.softwareKeyboardSeen) {
                    h = 768 - 44 - 64;
                }
                
                y = 64;
                
        
                
            }
			break;
		case 2: // input bar
	
				
			if (myAppDelegate.softwareKeyboardSeen) {
                h = 44;
				y=768 - 354 - 44;
				w=780;
				x=0;
            } else {
                h = 44;
				y=768 - 44;
				w=1024;
				x=0;
            }
			
		
        
			break;
		case 3: // button panel
            x=780;
			w=265;
            y = 92;
            
			if (myAppDelegate.softwareKeyboardSeen) {
                h = 330;
			} else {
                h = 600;
			}
			break;
		case 6: // tool bar
			x = 0;
			y = 0;
			h = 44;
			w = 1024;
			break;
			
	}
	
	CGRect myRect = CGRectMake(x, y, w, h);

	return myRect;
	
}


- (CGRect)figureFrameBoundsPortrait:(int)whichComponent sessionSettings:(MudDataSettings *)settings {
	int x = 0;
	int y = 0;
	int h = 0;
	int w = 768;
	
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	
	BOOL bPanelEnabled = YES;
	BOOL largeInputBar = YES;
	
	if (settings && ([[settings buttonBars] intValue] == NO)) {
		bPanelEnabled = NO;
	}
	
	if (settings && ([[settings largeInputArea] intValue] == NO)) {
		largeInputBar = NO;
	}
	
	switch (whichComponent) {
		case 1: // scrollview
		case 4:
			
            if (myAppDelegate.tvReady) {
                x = 0;
                y = 0;
                h = 720;
                w = 1280;
                
            } else {
                y = 64;
                
                if (myAppDelegate.softwareKeyboardSeen && bPanelEnabled) {
                    // panel and software keyboard
                    h = 516;
                } else if (bPanelEnabled) {
                    // panel only, hardware keyboard
                    h = 780;
                } else if (myAppDelegate.softwareKeyboardSeen) {
                    // software keyboard no panel
                    h = 640;
                } else {
                    // no panel and hardware keyboard
                    h = 905;
                }
                
                if (largeInputBar) {
                    h -= 44;
                }
                
            }
			break;
		case 2: // input bar
			h = 53;
			if (myAppDelegate.softwareKeyboardSeen && bPanelEnabled) {
				// panel and software keyboard
				y = 578;
			} else if (bPanelEnabled) {
				// panel only, hardware keyboard
				y = 840;
			} else if (myAppDelegate.softwareKeyboardSeen) {
				// software keyboard no panel
				y = 686;
			} else {
				// no panel and hardware keyboard
				y = 929;
			}
			
			if (largeInputBar) {
				h += 44;
				y -= 44;
			}
			break;
		case 3: // button panel
			h = 125;
			if (myAppDelegate.softwareKeyboardSeen && bPanelEnabled) {
				// panel and software keyboard
				y = 635;
			} else if (bPanelEnabled) {
				// panel only, hardware keyboard
				y = 899;
			} 
				
			break;
		case 6: // tool bar
			x = 0;
			y = 0;
			h = 44;
			w = 768;
			
	}
	
	
	
	CGRect myRect = CGRectMake(x, y, w, h);
	
	return myRect;
	
}

-(void)updateDisplayForTeleEvent {
    MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
    if (myAppDelegate.tvReady) {
        [myAppDelegate.teleVC.view addSubview:self.displayTableView];
    } else {
        [self.view addSubview:self.displayTableView]; 
    }
    self.displayTableView.frame = [self figureFrameBounds:1 sessionSettings:[[myAppDelegate getActiveSessionRef] settings]];
    
    [self updateViewsForFeatureChange];
}

- (void)loadConnectionUserInterface {
    

	MudDataSettings *settings = nil;
	
	switch (self.MudActiveIndex) {
		case 1:
			settings = self.mudSession1.settings;
			break;
		case 2:
			settings = self.mudSession2.settings;
			break;
		case 3:
			settings = self.mudSession3.settings;
			break;
		case 4:
			settings = self.mudSession4.settings;
			break;
	}	
	
	if (!self.displayTableView) {
        self.displayTableView = [[UITableView alloc] initWithFrame:[self figureFrameBounds:4 sessionSettings:settings] style:UITableViewStylePlain];
		self.displayTableView.backgroundColor = [[SettingsTool settings] stdBackgroundColor];
		self.displayTableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
		self.displayTableView.opaque = YES;
	}
    
	
   	
    
	if (self.footer) {
		[self.view addSubview:(MudInputFooter *)self.footer];
	} else {
		//CGRectMake(0,558,768,55)
		MudInputFooter *tmpFooter = [[MudInputFooter alloc] initWithFrame:[self figureFrameBounds:2 sessionSettings:settings]];
		tmpFooter.topController = self;
		self.footer = tmpFooter;
		[self.view addSubview:(MudInputFooter *)self.footer];
		[tmpFooter.inputTextView becomeFirstResponder];
	}
	
	if (!self.buttonPanel) {
		ButtonPanel *bp = [[ButtonPanel alloc] initWithFrame:[self figureFrameBounds:3 sessionSettings:settings]];
		bp.topController = self;
		self.buttonPanel = bp;
	}
	
	
	
	[self adjustViewSizes:settings];
			 
    [self updateDisplayForTeleEvent];

	
	
}


-(void)buildMainToolbar {
	
	int connectionsFound = 0;
    
	NSMutableArray *itemsL = [NSMutableArray arrayWithObjects:self.MudPickButton,nil];
	NSMutableArray *itemsR = [[NSMutableArray alloc] initWithCapacity:3];
	
	if (self.connectionButton1 && self.connectionButton2 && self.connectionButton3 && self.connectionButton4) {
		self.MudPickButton.enabled = NO;
	} else {
		self.MudPickButton.enabled = YES;
	}
	
	
	if (self.connectionButton1 != nil) {
		[itemsL addObject:self.connectionButton1];
		connectionsFound++;
	} 
	if (self.connectionButton2) {
		[itemsL addObject:self.connectionButton2];
		connectionsFound++;
	}
	if (self.connectionButton3) {
		[itemsL addObject:self.connectionButton3];
		connectionsFound++;
	}
	if (self.connectionButton4) {
		[itemsL addObject:self.connectionButton4];
		connectionsFound++;
	}
	
	//if ( (self.MudActiveIndex>0) && (iPadOrientation == UIInterfaceOrientationPortrait) | (iPadOrientation == UIInterfaceOrientationPortraitUpsideDown) ) {
      //  [items insertObject:self.MudSpacer atIndex:items.count];
     //   [items insertObject:self.MudSp atIndex:items.count];
        

        //[itemsR insertObject:self.MudTt atIndex:items.count];
    
        [itemsR addObject:self.MudAl];
		[itemsR addObject:self.MudVr];
		[itemsR addObject:self.MudTr];
		[itemsR addObject:self.MudMa];
		[itemsR addObject:self.MudSe];
        [itemsR addObject:self.MudSp];
   	//}
	
	 
	
	if (connectionsFound) {
        self.MudAl.enabled = YES;
		self.MudVr.enabled = YES;
		self.MudTr.enabled = YES;
		self.MudMa.enabled = YES;
		self.MudSe.enabled = YES;
        self.MudSp.enabled = YES;
       // self.MudTt.enabled = YES;
        
        if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
            self.mainToolbar.hidden = YES;
        }
	} else {
        [itemsL addObject:self.HelpButton];
        
        self.MudAl.enabled = NO;
		self.MudVr.enabled = NO;
		self.MudTr.enabled = NO;
		self.MudMa.enabled = NO;
		self.MudSe.enabled = NO;	
        self.MudSp.enabled = NO;
      //  self.MudTt.enabled = NO;
        
        self.mainToolbar.hidden = NO;
        
        
	}
    
    MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
    MudSession *session = [myAppDelegate getActiveSessionRef];
    
    self.connectionButton1.tintColor = [session isEqual:self.mudSession1] ? [UIColor blueColor] : [UIColor blackColor] ;
    self.connectionButton2.tintColor = [session isEqual:self.mudSession2] ? [UIColor blueColor] : [UIColor blackColor] ;
    self.connectionButton3.tintColor = [session isEqual:self.mudSession3] ? [UIColor blueColor] : [UIColor blackColor] ;
    self.connectionButton4.tintColor = [session isEqual:self.mudSession4] ? [UIColor blueColor] : [UIColor blackColor] ;
    
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItems = itemsL;
   
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItems = itemsR;
	
	
}
	

-(void)connectButtonClick:(id) sender {
	
	
	int SenderofClick = 0;
	
	if ((int)connectionButton1 == (int)sender) {
		SenderofClick = 1;
	} else if ((int)connectionButton2 == (int)sender) {
		SenderofClick = 2;
	} else if ((int)connectionButton3 == (int)sender) {
		SenderofClick = 3;
	} else if ((int)connectionButton4 == (int)sender) {	
		SenderofClick = 4;
	} else {
		NSLog (@"No match for sender in connectButtonClick.");
		return;
	}
	
	[self dismissPopovers];
	
	if (SenderofClick != MudActiveIndex) {
		[self switchToWindow:SenderofClick newConnection:NO];
	} else {
		[self mudConnectionInstanceClicked:self];
	}
}

-(void)dismissPopovers {
	
	if ([self.mudPreviousCommandsPopoverController isPopoverVisible]) {
		[self.mudPreviousCommandsPopoverController dismissPopoverAnimated:YES];
		MudPreviousCommands *mp = (MudPreviousCommands *)self.mudPreviousCommands;
		[mp.navigationController popToRootViewControllerAnimated:NO];
	}
	
	if ([self.mudVarPopoverController isPopoverVisible]) {
		[self.mudVarPopoverController dismissPopoverAnimated:YES];
		MudVariables *mv = (MudVariables *)self.mudVariables;
		[mv.navigationController popToRootViewControllerAnimated:NO];
	}
	if ([self.mudMacroPopoverController isPopoverVisible]) {
		[self.mudMacroPopoverController dismissPopoverAnimated:YES];
		MudMacros *mm = (MudMacros *)self.mudMacros;
		[mm.navigationController popToRootViewControllerAnimated:NO];
	}
	if ([self.mudTriggerPopoverController isPopoverVisible]) {
		[self.mudTriggerPopoverController dismissPopoverAnimated:YES];
		MudTriggers *mt= (MudTriggers *)self.mudTriggers;
		[mt.navigationController popToRootViewControllerAnimated:NO];
	}
	if ([self.mudButtonPopoverController isPopoverVisible]) {
		[self.mudButtonPopoverController dismissPopoverAnimated:YES];
		MudButtonsDetail *md = (MudButtonsDetail *)self.mudButtons;
		[md.navigationController popToRootViewControllerAnimated:NO];
	}
	
	
	 if (self.mudSettings) {
		[self.mudSettings.view removeFromSuperview];
		settingsActive = NO;
	}
	
	if ([self.mudAddConnectionPopoverController isPopoverVisible]) {
		[self.mudAddConnectionPopoverController dismissPopoverAnimated:YES];
		MudAddConnections *ma = (MudAddConnections *)self.mudAddConnections;
		[ma.navigationController popToRootViewControllerAnimated:NO];
	}
	
	if ([self.mudConnectionInstancePopoverController isPopoverVisible]) {
		[self.mudConnectionInstancePopoverController dismissPopoverAnimated:YES];
		MudConnectionInstance *mc = (MudConnectionInstance *)self.mudConnectionInstance;
		[mc.navigationController popToRootViewControllerAnimated:NO];
		[mc.navigationController popToRootViewControllerAnimated:NO];
	}

    if ([self.mudSpeedwalkingPopoverController isPopoverVisible]) {
		[self.mudSpeedwalkingPopoverController dismissPopoverAnimated:YES];
		SpeedwalkingList *ma = (SpeedwalkingList *)self.mudSpeedwalking;
		[ma.navigationController popToRootViewControllerAnimated:NO];
	}
	
    
    if ([self.mudTouchableTextsPopoverController isPopoverVisible]) {
		[self.mudTouchableTextsPopoverController dismissPopoverAnimated:YES];
		TouchableTexts *ma = (TouchableTexts *)self.mudTouchableTexts;
		[ma.navigationController popToRootViewControllerAnimated:NO];
	}
	
    if ([self.mudAliasPopoverController isPopoverVisible]) {
		[self.mudAliasPopoverController dismissPopoverAnimated:YES];
		MudAliases *ma = (MudAliases *)self.mudAliases;
		[ma.navigationController popToRootViewControllerAnimated:NO];
	}
    
	
	
}
-(void)mudAddConnectionsClicked:(id)sender{		
	[self dismissPopovers];
	
	if (!mudAddConnectionPopoverController) {
		MudAddConnections *uv = [[MudAddConnections alloc] init];
		mudAddConnections = uv;
		uv.context = self.context;
		uv.topController = self;
		
		UINavigationController *localNavigationController = [[UINavigationController alloc] initWithRootViewController:mudAddConnections];
		[localNavigationController setToolbarHidden:YES];
		[localNavigationController setNavigationBarHidden:NO]; 
		
		
		UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:localNavigationController];
		
		UIInterfaceOrientation iPadOrientation = [[UIApplication sharedApplication] statusBarOrientation];
		if ( (iPadOrientation == UIInterfaceOrientationLandscapeLeft) | (iPadOrientation == UIInterfaceOrientationLandscapeRight) ) {
			[popover setPopoverContentSize:CGSizeMake(560,300) animated:NO];
		} else {
			[popover setPopoverContentSize:CGSizeMake(560,420) animated:NO];
		}
		
		
		self.mudAddConnectionPopoverController = popover;

		[popover setDelegate:uv];
		
	}
	
	if (![mudAddConnectionPopoverController isPopoverVisible]) {
		
		UIInterfaceOrientation iPadOrientation = [[UIApplication sharedApplication] statusBarOrientation];
		if ( (iPadOrientation == UIInterfaceOrientationLandscapeLeft) | (iPadOrientation == UIInterfaceOrientationLandscapeRight) ) {
				[mudAddConnectionPopoverController setPopoverContentSize:CGSizeMake(560,300) animated:NO];
		} else {
				[mudAddConnectionPopoverController setPopoverContentSize:CGSizeMake(560,420) animated:NO];
		}
		
	
		[mudAddConnectionPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}	
	
}

-(void)mudMacrosClickedLandscape:(id)sender{
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	[self dismissPopovers];
	
	if (!mudMacroPopoverController) {
		MudMacros *uv = [[MudMacros alloc] init];
		mudMacros = uv;
		UINavigationController *localNavigationController = [[UINavigationController alloc] initWithRootViewController:mudMacros];
		[localNavigationController setToolbarHidden:YES];
		[localNavigationController setNavigationBarHidden:NO]; 
		
		
		UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:localNavigationController];
		[popover setPopoverContentSize:CGSizeMake(560,320) animated:NO];
		self.mudMacroPopoverController = popover;
		[popover setDelegate:uv];
		
		[popover setPassthroughViews:[NSArray arrayWithObjects:self.view,self.footer,nil]];
		
	}
	
	
	
	if (![mudMacroPopoverController isPopoverVisible]) {
		if ([[[[myAppDelegate getActiveSessionRef] settings] bottomLandscapeInputBar] boolValue] && (!myAppDelegate.softwareKeyboardSeen) )  {
			[mudMacroPopoverController presentPopoverFromRect:CGRectMake(945,700,1,1) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
		} else {
			[mudMacroPopoverController presentPopoverFromRect:CGRectMake(945,45,1,1) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
		}
	}	
}

-(void)mudMacrosClicked:(id)sender{

	[self dismissPopovers];
	
	if (!mudMacroPopoverController) {
		MudMacros *uv = [[MudMacros alloc] init];
		mudMacros = uv;
		UINavigationController *localNavigationController = [[UINavigationController alloc] initWithRootViewController:mudMacros];
		[localNavigationController setToolbarHidden:YES];
		[localNavigationController setNavigationBarHidden:NO]; 
		
		
		UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:localNavigationController];
		[popover setPopoverContentSize:CGSizeMake(560,320) animated:NO];
		self.mudMacroPopoverController = popover;
		[popover setDelegate:uv];
		
	}
	
	if (![mudMacroPopoverController isPopoverVisible]) {
		[mudMacroPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}	
	
}

-(void)mudSpeedwalkingClicked:(id)sender {
    
	[self dismissPopovers];
	
	if (!mudSpeedwalkingPopoverController) {
		SpeedwalkingList *uv = [[SpeedwalkingList alloc] init];
        uv.element = nil;
        mudSpeedwalking = uv;
        uv.element = nil;
		UINavigationController *localNavigationController = [[UINavigationController alloc] initWithRootViewController:mudSpeedwalking];
		[localNavigationController setToolbarHidden:YES];
		[localNavigationController setNavigationBarHidden:NO]; 
		
		
		UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:localNavigationController];
		[popover setPopoverContentSize:CGSizeMake(560,320) animated:NO];
		self.mudSpeedwalkingPopoverController = popover;
		[popover setDelegate:uv];
		
	}
	
	if (![mudSpeedwalkingPopoverController isPopoverVisible]) {
		[mudSpeedwalkingPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}	

}

-(void)mudSpeedwalkingClickedLandscape:(id)sender {
    MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	[self dismissPopovers];
	
	if (!mudSpeedwalkingPopoverController) {
		SpeedwalkingList *uv = [[SpeedwalkingList alloc] init];
        uv.element = nil;
        mudSpeedwalking = uv;
        uv.element = nil;
		UINavigationController *localNavigationController = [[UINavigationController alloc] initWithRootViewController:mudSpeedwalking];
		[localNavigationController setToolbarHidden:YES];
		[localNavigationController setNavigationBarHidden:NO]; 
		
		
		UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:localNavigationController];
		[popover setPopoverContentSize:CGSizeMake(560,320) animated:NO];
		self.mudSpeedwalkingPopoverController = popover;
		[popover setDelegate:uv];
        [popover setPassthroughViews:[NSArray arrayWithObjects:self.view,self.footer,nil]];
	}
	
	if (![mudSpeedwalkingPopoverController isPopoverVisible]) {
        if ([[[[myAppDelegate getActiveSessionRef] settings] bottomLandscapeInputBar] boolValue] && (!myAppDelegate.softwareKeyboardSeen) )  {
            [mudSpeedwalkingPopoverController presentPopoverFromRect:CGRectMake(795,700,1,1) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        } else {
            [mudSpeedwalkingPopoverController presentPopoverFromRect:CGRectMake(795,45,1,1) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }	

    
}

-(void)mudTouchableTextClicked:(id)sender {
    
	[self dismissPopovers];
	
	if (!mudTouchableTextsPopoverController) {
		TouchableTexts *uv = [[TouchableTexts alloc] init];
		mudTouchableTexts = uv;
		UINavigationController *localNavigationController = [[UINavigationController alloc] initWithRootViewController:mudTouchableTexts];
		[localNavigationController setToolbarHidden:YES];
		[localNavigationController setNavigationBarHidden:NO]; 
		
		
		UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:localNavigationController];
		[popover setPopoverContentSize:CGSizeMake(560,320) animated:NO];
		self.mudTouchableTextsPopoverController = popover;
		[popover setDelegate:uv];
		
	}
	
	if (![mudTouchableTextsPopoverController isPopoverVisible]) {
		[mudTouchableTextsPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}	

}


-(void)mudTouchableTextsClickedLandscape:(id)sender {
    MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	[self dismissPopovers];
	
	if (!mudTouchableTextsPopoverController) {
		TouchableTexts *uv = [[TouchableTexts alloc] init];
		mudTouchableTexts = uv;
		UINavigationController *localNavigationController = [[UINavigationController alloc] initWithRootViewController:mudTouchableTexts];
		[localNavigationController setToolbarHidden:YES];
		[localNavigationController setNavigationBarHidden:NO]; 
		
		
		UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:localNavigationController];
		[popover setPopoverContentSize:CGSizeMake(560,320) animated:NO];
		self.mudTouchableTextsPopoverController = popover;
		[popover setDelegate:uv];
		 [popover setPassthroughViews:[NSArray arrayWithObjects:self.view,self.footer,nil]];
	}
	
    
	if (![mudTouchableTextsPopoverController isPopoverVisible]) {
        if ([[[[myAppDelegate getActiveSessionRef] settings] bottomLandscapeInputBar] boolValue] && (!myAppDelegate.softwareKeyboardSeen) )  {
            [mudTouchableTextsPopoverController presentPopoverFromRect:CGRectMake(895,700,1,1) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        } else {
            [mudTouchableTextsPopoverController presentPopoverFromRect:CGRectMake(895,45,1,1) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }	
}

-(void)settingsOutAnimationDone:(id)sender {
	[mudSettings.view removeFromSuperview];
	settingsActive = NO;
}


-(void)mudSettingsClicked:(id)sender{
	
	if (!mudSettings) {
		MudSettings *m = [[MudSettings alloc] init];
		m.topController = self;
		mudSettings = m;
	}
	
	if (!settingsActive) {
		[self dismissPopovers];
		[(MudSettings *)mudSettings positionViews:self.interfaceOrientation offScreen:NO];
		[(MudSettings *)mudSettings updateViews];
		[self.view addSubview:mudSettings.view];
		settingsActive = YES;
	} else {
        
        [mudSettings.view removeFromSuperview];
        settingsActive = NO;
    }
	
}

-(void)mudTriggersClickedLandscape:(id)sender{
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	
	[self dismissPopovers];
	
	if (!mudTriggerPopoverController) {
		MudTriggers *uv = [[MudTriggers alloc] init];
		mudTriggers = uv;
		UINavigationController *localNavigationController = [[UINavigationController alloc] initWithRootViewController:mudTriggers];
		[localNavigationController setToolbarHidden:YES];
		[localNavigationController setNavigationBarHidden:NO]; 
		
		
		UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:localNavigationController];
		[popover setPopoverContentSize:CGSizeMake(560,320) animated:NO];
		self.mudTriggerPopoverController = popover;
		[popover setDelegate:uv];
		
		[popover setPassthroughViews:[NSArray arrayWithObjects:self.view,self.footer,nil]];
	}
	
	if (![mudTriggerPopoverController isPopoverVisible]) {
		if ([[[[myAppDelegate getActiveSessionRef] settings] bottomLandscapeInputBar] boolValue] && (!myAppDelegate.softwareKeyboardSeen) )  {
			[mudTriggerPopoverController presentPopoverFromRect:CGRectMake(895,700,1,1) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
		} else {
			[mudTriggerPopoverController presentPopoverFromRect:CGRectMake(895,45,1,1) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
		}
	}	
	
}


-(void)mudTriggersClicked:(id)sender{

	
		[self dismissPopovers];
	if (!mudTriggerPopoverController) {
		MudTriggers *uv = [[MudTriggers alloc] init];
		mudTriggers = uv;
		UINavigationController *localNavigationController = [[UINavigationController alloc] initWithRootViewController:mudTriggers];
		[localNavigationController setToolbarHidden:YES];
		[localNavigationController setNavigationBarHidden:NO]; 
		
		
		UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:localNavigationController];
		[popover setPopoverContentSize:CGSizeMake(560,320) animated:NO];
		self.mudTriggerPopoverController = popover;
		[popover setDelegate:uv];
	}
	
	if (![mudTriggerPopoverController isPopoverVisible]) {
		[mudTriggerPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}	
	
}

-(void)mudVariablesClickedLandscape:(id)sender{
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	[self dismissPopovers];
	
	if (!mudVarPopoverController) {
		MudVariables *uv = [[MudVariables alloc] init];
		mudVariables = uv;
		
		UINavigationController *localNavigationController = [[UINavigationController alloc] initWithRootViewController:mudVariables];
		[localNavigationController setToolbarHidden:YES];
		[localNavigationController setNavigationBarHidden:NO]; 
		
		
		UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:localNavigationController];
		[popover setPopoverContentSize:CGSizeMake(560,320) animated:NO];
		self.mudVarPopoverController = popover;
		[popover setDelegate:uv];
		
		[popover setPassthroughViews:[NSArray arrayWithObjects:self.view,self.footer,self.displayTableView,self,nil]];
	}
	
	if (![mudVarPopoverController isPopoverVisible]) {
		if ([[[[myAppDelegate getActiveSessionRef] settings] bottomLandscapeInputBar] boolValue] && (!myAppDelegate.softwareKeyboardSeen) )  {
			[mudVarPopoverController presentPopoverFromRect:CGRectMake(845,700,1,1) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
		} else {
			[mudVarPopoverController presentPopoverFromRect:CGRectMake(845,45,1,1) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
		}
	}	
}

-(void)mudAliasesClickedLandscape:(id)sender{
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	[self dismissPopovers];
	
	if (!mudAliasPopoverController) {
		MudAliases *uv = [[MudAliases alloc] init];
		mudAliases = uv;
		
		UINavigationController *localNavigationController = [[UINavigationController alloc] initWithRootViewController:mudAliases];
		[localNavigationController setToolbarHidden:YES];
		[localNavigationController setNavigationBarHidden:NO];
		
		
		UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:localNavigationController];
		[popover setPopoverContentSize:CGSizeMake(560,320) animated:NO];
		self.mudAliasPopoverController = popover;
		[popover setDelegate:uv];
		
		[popover setPassthroughViews:[NSArray arrayWithObjects:self.view,self.footer,self.displayTableView,self,nil]];
	}
	
	if (![mudAliasPopoverController isPopoverVisible]) {
		if ([[[[myAppDelegate getActiveSessionRef] settings] bottomLandscapeInputBar] boolValue] && (!myAppDelegate.softwareKeyboardSeen) )  {
			[mudAliasPopoverController presentPopoverFromRect:CGRectMake(795,700,1,1) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
		} else {
			[mudAliasPopoverController presentPopoverFromRect:CGRectMake(795,90,1,1) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
		}
	}
}

-(void)updateForRemoteKeyboard {
    [footer.inputTextView resignFirstResponder];
}

-(void)mudAliasesClicked:(id)sender{
	
    [self dismissPopovers];
	if (!mudAliasPopoverController) {
		MudAliases *uv = [[MudAliases alloc] init];
		mudAliases = uv;
        
		UINavigationController *localNavigationController = [[UINavigationController alloc] initWithRootViewController:mudAliases];
		[localNavigationController setToolbarHidden:YES];
		[localNavigationController setNavigationBarHidden:NO];
        
        
		UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:localNavigationController];
		[popover setPopoverContentSize:CGSizeMake(560,320) animated:NO];
		self.mudAliasPopoverController = popover;
		[popover setDelegate:uv];
	}
	
	if (![mudAliasPopoverController isPopoverVisible]) {
		[mudAliasPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}	
}



-(void)mudVariablesClicked:(id)sender{
	
		[self dismissPopovers];
	if (!mudVarPopoverController) {
		MudVariables *uv = [[MudVariables alloc] init];
		mudVariables = uv;

		UINavigationController *localNavigationController = [[UINavigationController alloc] initWithRootViewController:mudVariables];
		[localNavigationController setToolbarHidden:YES];
		[localNavigationController setNavigationBarHidden:NO]; 
	
			
		UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:localNavigationController];
		[popover setPopoverContentSize:CGSizeMake(560,320) animated:NO];
		self.mudVarPopoverController = popover;
		[popover setDelegate:uv];
	}
	
	if (![mudVarPopoverController isPopoverVisible]) {
		[mudVarPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}	
}
-(void)updateViewsForFeatureChange {
    MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	UIInterfaceOrientation toInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
	if ( (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)) {
		[self updateViewsForOrientation:NO];
	} else {
		[self updateViewsForOrientation:YES];
	}
    
    int itemCount = [[[myAppDelegate getActiveSessionRef] connectionText] count];
    
	if (itemCount >0) {
		[self.displayTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:itemCount-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
	}
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	
	[self dismissPopovers];
	
	if ( (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)) {
		[self updateViewsForOrientation:NO];
	} else {
		[self updateViewsForOrientation:YES];
	}
	
	[self buildMainToolbar];
	
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        self.mainToolbar.hidden = NO;
    }
    
	int itemCount = [[[myAppDelegate getActiveSessionRef] connectionText] count];
    
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        self.mainToolbar.hidden = itemCount > 0 ? YES : NO;
    }
    
	if (itemCount >0) {
		[self.displayTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:itemCount-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
	}

    [self performSelector:@selector(updateKeyboardAfterRotation) withObject:nil afterDelay:0.75];
}

-(void)updateKeyboardAfterRotation {
    MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	//myAppDelegate.softwareKeyboardSeen = NO;
	
	MudInputFooter *f = (MudInputFooter *)myAppDelegate.viewController.footer;
	[f.inputTextView resignFirstResponder];
	
    [self updateViewsForFeatureChange];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

-(BOOL)checkForPreviousCommandsExistance:(NSString *)cmd {
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"MudDataPreviousCommands" inManagedObjectContext:self.context];
	[request setEntity:entity];
	
	MudDataCharacters *tmpChar = nil;
	switch (self.MudActiveIndex) {
		case 1:
			tmpChar = self.mudSession1.connectionData;
			break;
		case 2:
			tmpChar = self.mudSession2.connectionData;
			break;
		case 3:
			tmpChar =  self.mudSession3.connectionData;
			break;
		case 4:
			tmpChar = self.mudSession4.connectionData;
			break;
	}
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"slotID=%@ && commandText=%@", tmpChar, cmd];
	[request setPredicate:predicate];	
	
	
	
	// Order the events by creation date, most recent first.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"commandText" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[self.context executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		// Handle the error.
	}
	
	// Set self's events array to the mutable array, then clean up.
	
	BOOL Found = NO;
	
	NSMutableArray *m = mutableFetchResults;
	if ([m count]>0) {
		Found = YES;
	} 

	return Found;
	
}

-(void)helpClicked:(id)sender {
    [[SettingsTool settings] displayHelpForSection:kHelpSectionMain];
}

- (void)loadView  {
    [super loadView];
	
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	
	//self.view = [[UIView alloc] initWithFrame:myAppDelegate.window.bounds];
	
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0,0,768,1024)];
				 
	self.view.backgroundColor = [[SettingsTool settings] stdBackgroundColor];
	
	self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	
	[self.view sizeToFit];
	
	
	iPage = [[introPage alloc] init];
	[self.view addSubview:iPage.view];
	
	
	// Create always present barbuttonitems
	
	self.HelpButton = [[UIBarButtonItem alloc] initWithTitle:@"Help" style:UIBarButtonItemStylePlain target:self action:@selector(helpClicked:)];
	
	self.MudPickButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(mudAddConnectionsClicked:)];
	self.MudPickButton.style = UIBarButtonItemStyleBordered;
	self.MudSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];		
    
   
    self.MudVr = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"96-book.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(mudVariablesClicked:)];
    
	self.MudAl = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"187-pencil.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(mudAliasesClicked:)];
	self.MudTr = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"20-gear2.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(mudTriggersClicked:)];
	self.MudMa = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"104-index-cards.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(mudMacrosClicked:)];
    self.MudSe = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"106-sliders.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(mudSettingsClicked:)];

    self.MudSp = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"102-walk.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(mudSpeedwalkingClicked:)];
    //self.MudTt = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"10-arrows-in.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(mudTouchableTextClicked:)];

    
    
	self.MudPickButton.enabled = YES;
    self.MudAl.enabled = NO;
	self.MudVr.enabled = NO;
	self.MudTr.enabled = NO;
	self.MudMa.enabled = NO;
	self.MudSe.enabled = NO;
	self.MudSp.enabled = NO;
    //self.MudTt.enabled = NO;
    
	[self buildMainToolbar];
		
	[myAppDelegate.window makeKeyAndVisible];
}



- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
	NSLog(@"Main view got a memory warning.");
	
}

@end
