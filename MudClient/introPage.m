    //
//  introPage.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 4/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "introPage.h"
#import "MudClientIpad4AppDelegate.h"
#import "MudSession.h"
#import "MudDataSettings.h"
#import "MudClientIpad4ViewController.h"

@implementation introPage




-(void)supportTapped {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://ipadmudclient.com/"]];
}

-(void)positionViews:(UIInterfaceOrientation )forOrientation {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudClientIpad4ViewController *displayView = myAppDelegate.viewController;
	BOOL offScreen = YES;
	
	if (displayView.MudActiveIndex < 1) {
		offScreen = NO;
	}
	
	
	if ( (forOrientation == UIInterfaceOrientationPortrait) | (forOrientation == UIInterfaceOrientationPortraitUpsideDown) ) {
		
		float xLoc = 168/2;
		
		if (offScreen) {
			xLoc = 768;
		}
		
		self.view.frame = CGRectMake(xLoc,300,600,500);
	
		header.frame = CGRectMake(200, 15,240,40);
		
		supportLabel.frame = CGRectMake(400,450,200,30);
		supportButton.frame = CGRectMake(400,450,200,30);
		releaseNotes.frame = CGRectMake(0,100,600,350);
		
	} else {
		
		float xLoc = 424/2;
		
		if (offScreen) {
			xLoc = 1024;
		}
		
		self.view.frame = CGRectMake(xLoc,130,600,500);
	
		header.frame = CGRectMake(200, 15,240,40);
		
		
		supportLabel.frame = CGRectMake(400,450,200,30);
		supportButton.frame = CGRectMake(400,450,200,30);
		releaseNotes.frame = CGRectMake(0,100,600,350);
	
		
		
		
	}
	
	[self.view bringSubviewToFront:supportButton];
	
}

-(void)populateReleaseNotes {
    dispatch_queue_t backgroundQueue = dispatch_queue_create("com.gbcs.ipadmudclient.releasenotes", NULL);        
    dispatch_async(backgroundQueue, ^(void) {
        NSError *error = nil;
        NSString *releaseNotesText = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://ipadmudclient.com/release_notes_1.8.0.txt"] 
                                                                    encoding:NSUTF8StringEncoding 
                                                                       error:&error];
        [releaseNotes setText:releaseNotesText];
    });
	
}


- (void)loadView {
	
	self.view = [[UIView alloc] initWithFrame:CGRectZero];
	self.view.opaque = YES;
	self.view.backgroundColor = [[SettingsTool settings] stdBackgroundColor];
	[[self.view layer] setCornerRadius:8.0f];
	[[self.view layer] setMasksToBounds:YES];
	[[self.view layer] setBorderWidth:0.0f];
	
	header = [[UILabel alloc] initWithFrame:CGRectZero];
	[header setText:@""];
	[header setFont:[UIFont boldSystemFontOfSize:20.0]];
	[header setTextAlignment:NSTextAlignmentCenter];
	header.textColor = [UIColor blackColor];

	header.backgroundColor = 	[[SettingsTool settings] stdBackgroundColor];
	
	[self.view addSubview:header];
	[[header layer] setCornerRadius:8.0f];
	[[header layer] setMasksToBounds:YES];
	[[header layer] setBorderWidth:0.0f];
	
	
	supportLabel = [[UILabel alloc] initWithFrame:CGRectZero];	
	[supportLabel setText:@""];
	[supportLabel setFont:[UIFont boldSystemFontOfSize:11.0f]];
	[supportLabel setTextColor:[UIColor blackColor]];
	[supportLabel setBackgroundColor:[UIColor clearColor]];
	[supportLabel setNumberOfLines:1];
	[self.view addSubview:supportLabel];
	
	supportButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[supportButton addTarget:self action:@selector(supportTapped) forControlEvents:UIControlEventTouchUpInside];
	supportButton.backgroundColor = [UIColor colorWithWhite:0.01 alpha:0.01];
	supportButton.opaque = NO;
	[self.view addSubview:supportButton];
	
	
	releaseNotes = [[UILabel alloc] initWithFrame:CGRectZero];
	[releaseNotes setFont:[UIFont systemFontOfSize:14.0f]];
	[releaseNotes setTextColor:[UIColor grayColor]];
	[releaseNotes setBackgroundColor:[UIColor clearColor]];
	[releaseNotes setNumberOfLines:22];
	[self.view addSubview:releaseNotes];

	UIInterfaceOrientation iPadOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	[self positionViews:iPadOrientation];
	
	[self performSelector:@selector(populateReleaseNotes) withObject:nil afterDelay:0.01];
	
}

- (void)viewWillAppear:(BOOL)animated {
	UIInterfaceOrientation iPadOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	[self positionViews:iPadOrientation];
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