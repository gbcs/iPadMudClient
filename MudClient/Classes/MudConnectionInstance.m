//
//  MudConnectionInstance.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 8/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MudConnectionInstance.h"
#import "MudClientIpad4ViewController.h"
#import "MudClientIpad4AppDelegate.h"
#import "MudInputFooter.h"
#import "MudTranscriptList.h"

@implementation MudConnectionInstance


@synthesize topController,  amConnected, timer, connectionButton, sessionButton, transcriptButton;



- (void)buttonClick:(id)sender {
	
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
	
	
	if (!session) {
		return;
	}
	
	[self.timer invalidate];
	self.timer = nil;
	
	if (self.connectionButton == sender) {
		[self.topController dismissPopovers];
		if (self.amConnected) {
			[session disconnectSession];
			[session sendLineToMud:@"Disconnecting" fromUser:NO fromMacro:NO shallDisplay:YES LogPrevCommands:NO];
		} else {
			[session reconnectSession];
			[session sendLineToMud:@"Connecting" fromUser:NO fromMacro:NO shallDisplay:YES LogPrevCommands:NO];
		}
	} else if (self.sessionButton == sender) {
		[self.topController connectionDestroy:self.topController.MudActiveIndex];
	} else if (self.transcriptButton == sender) {
		MudTranscriptList *mt = [[MudTranscriptList alloc] init];
		[self.navigationController pushViewController:mt animated:YES];
	}
	
}
				 

- (void)updateViewState:(id)sender {

	if (!self.topController.MudActiveIndex) {
		return;
	}
	
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
	
	
	if (!session) {
		return;
	}
	
	int cmd = 0;
	
	
	switch ([session.connectionStreamIN	streamStatus]) {
		case   NSStreamStatusNotOpen:
			cmd = 1;
			break;
		case   	NSStreamStatusOpening:
		case   	NSStreamStatusOpen:
		case   	NSStreamStatusReading:
		case   	NSStreamStatusWriting:
		case   	NSStreamStatusAtEnd:
			cmd = 3;
			break;
		case   	NSStreamStatusClosed:
			cmd = 1;
			break;
		case   	NSStreamStatusError:
			cmd = 2;
			break;
	}
	
	switch ([session.connectionStreamOUT streamStatus]) {
		case   NSStreamStatusNotOpen:
			
			break;
		case   	NSStreamStatusOpening:
		case   	NSStreamStatusOpen:
		case   	NSStreamStatusReading:
		case   	NSStreamStatusWriting:
		case   	NSStreamStatusAtEnd:
			break;
		case   	NSStreamStatusClosed:
			if (cmd ==3) {
				cmd = 1;
			}
			break;
		case   	NSStreamStatusError:
			cmd = 2;
			break;
	}
	
	switch (cmd) {
		case 1:
		case 2:
			self.amConnected = NO;
			break;
		case 3:
			self.amConnected = YES;
			break;
	}
	
	if (self.amConnected) {
		[self.connectionButton setTitle:@"Disconnect" forState:UIControlStateNormal];
	} else {
		[self.connectionButton setTitle:@"Reconnect" forState:UIControlStateNormal];
	}
		
}
	


-(void)viewWillAppear:(BOOL)animated {
	[self updateViewState:self];

	self.view.frame = CGRectMake(0,0,560,80);
	
	CGSize contentSize;
    contentSize.width = 560;
    contentSize.height = 80;
    self.preferredContentSize = contentSize;
	
	self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
									 target:self
								   selector:@selector(updateViewState:)
								   userInfo:nil
									repeats:YES];
	

	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudClientIpad4ViewController *displayView = myAppDelegate.viewController;
	[displayView.mudConnectionInstancePopoverController setPopoverContentSize:contentSize];
	
	UIInterfaceOrientation iPadOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	if ( (iPadOrientation == UIInterfaceOrientationLandscapeLeft) | (iPadOrientation == UIInterfaceOrientationLandscapeRight) ) {
		self.transcriptButton.enabled = NO;
		[self.transcriptButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
	} else {
		self.transcriptButton.enabled = YES;
		[self.transcriptButton setTitleColor:[self.connectionButton titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
	}
}

-(void)viewWillDisappear:(BOOL)animated {
	[self.timer invalidate];
	self.timer = nil;
	self.navigationController.toolbarHidden = YES;
	
	UIInterfaceOrientation iPadOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	if ( (iPadOrientation == UIInterfaceOrientationLandscapeLeft) | (iPadOrientation == UIInterfaceOrientationLandscapeRight) ) {
		self.transcriptButton.enabled = NO;
	} else {
		self.transcriptButton.enabled = YES;
	}
	
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	[myAppDelegate pointToDefaultKeyboardResponder];
	self.navigationController.toolbarHidden = YES;
}


- (void)loadView {
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560, 80)];
	
	self.navigationItem.title = @"Connection";
	
	
	
	self.connectionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.connectionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	self.connectionButton.frame = CGRectMake(5, 10, 150, 44);
	[self.connectionButton setTitle:@"Disconnect" forState:UIControlStateNormal];
	[self.view addSubview:self.connectionButton];
	
	self.sessionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.sessionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	self.sessionButton.frame = CGRectMake(400, 10, 150, 44);
	[self.sessionButton setTitle:@"Close" forState:UIControlStateNormal];
	[self.view addSubview:self.sessionButton];
	
	self.transcriptButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	self.transcriptButton.frame = CGRectMake(200, 10, 150, 44);
	[self.transcriptButton setTitle:@"Transcripts" forState:UIControlStateNormal];
	[self.view addSubview:self.transcriptButton];
	

	[self.connectionButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.sessionButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.transcriptButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
		
	[self updateViewState:nil];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
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
