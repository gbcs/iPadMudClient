//
//  MudMacrosStepVarVar.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 9/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MudMacrosStepVarVar.h"

#import "MudMacrosStep.h"
#import "MudDataVariables.h"
#import "MudClientIpad4AppDelegate.h"
#import "MudSession.h"
#import "MudClientIpad4ViewController.h"
#import "MudMacrosStepVariableModifier.h"
#import "MudMacrosDetail.h"

@implementation MudMacrosStepVarVar


@synthesize tv;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 50.0f;	
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	
	
	MudSession *session = [myAppDelegate getActiveSessionRef];
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	myAppDelegate.mudMacrosDetail.macroStep.secondVariable = [session.variables objectAtIndex:indexPath.row];
	
	[myAppDelegate.mudMacrosDetail saveStep];
	
	[myAppDelegate pointToDefaultKeyboardResponder];
	
	[self.navigationController popToViewController:myAppDelegate.mudMacrosDetail animated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Only one section.
    return 2;
	
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	CGSize contentSize;
	UIInterfaceOrientation iPadOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	if ( (iPadOrientation == UIInterfaceOrientationLandscapeLeft) | (iPadOrientation == UIInterfaceOrientationLandscapeRight) ) {
	    contentSize.width = 560;
		contentSize.height = 290;
	} else {
	    contentSize.width = 560;
		contentSize.height = 620;;
	}
    self.preferredContentSize = contentSize;
	
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	[myAppDelegate pointToDefaultKeyboardResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
	
	if (section == 0) 
		return [session.variables count];
	
	return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
	
    static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		//cell.editingAccessoryType = UITableViewCellEditingStyleNone;
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
  
	MudDataVariables *event = (MudDataVariables *)[session.variables objectAtIndex:indexPath.row];	
	
	cell.textLabel.text = [event title];
	
	return cell;
}



- (void)loadView {
	
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
	
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560, 620)];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
    self.navigationItem.title = @"Select a Variable";
	
	if ([session.variables	count] <1) {
		UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(60,220,300,100)];
		label1.textAlignment = NSTextAlignmentCenter;
		label1.font = [UIFont boldSystemFontOfSize:17];
		label1.textColor = [UIColor blackColor];
		label1.backgroundColor = [UIColor clearColor];
		label1.numberOfLines = 30;
		[label1 setText:@"No variables currently exist.\r\n\r\nCreate a variable and return."]; 
		[self.view addSubview:label1];
	} else {
		self.tv = [[UITableView alloc] initWithFrame:CGRectMake(0,0,560,420) style:UITableViewStyleGrouped];
		self.tv.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
        
		
		tv.dataSource = self;
		tv.delegate = self;
		
		
		[self.view addSubview:tv];
		
	}
	
	
	
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

