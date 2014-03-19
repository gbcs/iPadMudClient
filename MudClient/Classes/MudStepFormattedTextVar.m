//
//  MudStepFormattedTextVar.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 9/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MudStepFormattedTextVar.h"

#import "MudMacrosStep.h"
#import "MudDataVariables.h"
#import "MudClientIpad4AppDelegate.h"
#import "MudSession.h"
#import "MudClientIpad4ViewController.h"
#import "MudMacrosStepVariableModifier.h"
#import "MudMacrosDetail.h"
#import "MudStepFormattedText.h"

@implementation MudStepFormattedTextVar

@synthesize tv;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 50.0f;	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	MudStepFormattedText *t = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	if (indexPath.section == 0) {
		
		int aRowMax = [t.formatVariables count]-1;
		
		MudDataVariables *selectedVariable = [session.variables objectAtIndex:indexPath.row];
		
		if (aRowMax >= t.selectedVariable) {
			[t.formatVariables replaceObjectAtIndex:t.selectedVariable withObject:selectedVariable];
		} else {
			[t.formatVariables insertObject:selectedVariable atIndex:aRowMax+1];
		} 
		
		[t.tableview reloadData];
		[t.view setNeedsDisplay];
		//	NSLog(@"C:%d", [t.formatVariables count]);
	} else {
	
		int aRowMax = [t.formatVariables count]-1;
	
		if (aRowMax >= t.selectedVariable) {
			[t.formatVariables replaceObjectAtIndex:t.selectedVariable withObject:[NSNumber numberWithInt:-10 - indexPath.row]];
		} else {
			[t.formatVariables insertObject:[NSNumber numberWithInt:-10 - indexPath.row] atIndex:aRowMax+1];
		} 
		
		[t.tableview reloadData];
		[t.view setNeedsDisplay];
		//	NSLog(@"C:%d", [t.formatVariables count]);
	}
	[myAppDelegate pointToDefaultKeyboardResponder];
	
	[self.navigationController popViewControllerAnimated:YES];
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
	if (section == 1) 
		return 2;
	
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
  
	if (indexPath.section == 0) {
		MudDataVariables *event = (MudDataVariables *)[session.variables objectAtIndex:indexPath.row];	
		
		cell.textLabel.text = [event title];
	} else {
		if (indexPath.row == 0) {
			cell.textLabel.text = @"Character's Name";
		} else {
			cell.textLabel.text = @"Character's Password";
		}
	}
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	switch (section) {
		case 0:
			return @"Variables";
			break;
		case 1:
			return @"Constants";
			break;
	}
	
	return nil;
}


- (void)loadView {
	
	
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560, 420)];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	self.navigationItem.title = @"Select an Item for Reference";
	
	self.tv = [[UITableView alloc] initWithFrame:CGRectMake(0,0,560,420) style:UITableViewStyleGrouped];
    self.tv.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
		
	tv.dataSource = self;
	tv.delegate = self;
	[self.view addSubview:tv];
	
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
