//
//  MudMacroStepDelay.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 3/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MudMacroStepDelay.h"
#import "MudDataMacros.h"
#import "MudMacrosDetail.h"
#import "MudMacrosStepVariable.h"
#import "MudMacrosStepVarAssMac.h"
#import "MudMacrosStepVarAssNum.h"
#import "MudMacrosStepVarConst.h"
#import "MudStepFormattedText.h"
#import "Macros.h"
#import "MudMacrosStep.h"
#import "MudClientIpad4AppDelegate.h"
#import "MudStepFormattedText.h"

@implementation MudMacroStepDelay

@synthesize tableview;



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// As many rows as there are obects in the events array.	
	
	return 901;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	float h = 44;
	
	return h;
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = nil;
	cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}

	if (indexPath.row == 1) {
		cell.textLabel.text = @"1 second";
	} else {
		cell.textLabel.text = [NSString stringWithFormat:@"%d seconds", indexPath.row];
	}

	return cell;
	
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudStepFormattedText *t = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
	t.delay = indexPath.row;
	
	[t.tableview reloadData];

	[myAppDelegate pointToDefaultKeyboardResponder];
	
	[self.navigationController popViewControllerAnimated:YES];
}



- (void)loadView {
	
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560, 620)];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	self.navigationItem.title = @"Select Send Delay";
	
	
	self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0,0,560,620) style:UITableViewStyleGrouped];
	self.tableview.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	
	self.tableview.delegate = self;
	self.tableview.dataSource = self;
	
	
	[self.view addSubview:self.tableview];
	
}

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


- (void)dealloc {
	self.view = nil;
	    ;
}

@end

