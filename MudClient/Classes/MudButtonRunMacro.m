    //
//  MudButtonRunMacro.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 8/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MudButtonRunMacro.h"
#import "ButtonPanel.h"
#import "MudButtonsDetail.h"
#import "MudAddButtonAction.h"
#import "MudDataMacros.h"
#import "MudClientIpad4ViewController.h"
#import "MudClientIpad4AppDelegate.h"

@implementation MudButtonRunMacro

@synthesize tableview;
@synthesize  parentView;



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
	
	return [session.macros count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
	
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
	
	UITableViewCell *cell = nil;
	
	cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	cell.textLabel.text = [[session.macros objectAtIndex:indexPath.row] title];
 	return cell;
}


- (void)viewWillAppear:(BOOL)animated {
	CGSize contentSize;
	contentSize.width = 560;
	contentSize.height = 290;
	self.preferredContentSize = contentSize;
		
	[self.tableview reloadData];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];

	if ([session.macros count] <1) {
		
			[myAppDelegate pointToDefaultKeyboardResponder];
		
		[self.navigationController popViewControllerAnimated:YES];
	}
	
}


- (void)selectNoneAsMacro:(id)sender {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	
	MudAddButtonAction *ma = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
	MudButtonsDetail *detailView = (MudButtonsDetail *)ma.parentView;
	
	switch (detailView.editLayer) {
		case 1:
			[detailView.element setLayer1Macro:nil];
			break;
		case 2:
			[detailView.element setLayer2Macro:nil];
			break;
		case 3:
			[detailView.element setLayer3Macro:nil];
			break;
	}
	
	[myAppDelegate saveCoreData];
	
	[detailView.tableview reloadData];
	
	[myAppDelegate pointToDefaultKeyboardResponder];
	
	[self.navigationController popToRootViewControllerAnimated:YES];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	MudAddButtonAction *ma = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
	MudButtonsDetail *detailView = (MudButtonsDetail *)ma.parentView;
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
	
	
	switch (detailView.editLayer) {
		case 1:
			[detailView.element setLayer1Macro:[session.macros objectAtIndex:indexPath.row]];
			[detailView.element setLayer1Action:@""];
			break;
		case 2:
			[detailView.element setLayer2Macro:[session.macros objectAtIndex:indexPath.row]];
			[detailView.element setLayer2Action:@""];
			break;
		case 3:
			[detailView.element setLayer3Macro:[session.macros objectAtIndex:indexPath.row]];
			[detailView.element setLayer3Action:@""];
			break;
	}
	
	[detailView.tableview reloadData];
	
	// Save out to the persistent store
	[myAppDelegate saveCoreData];	
	[myAppDelegate pointToDefaultKeyboardResponder];
	[self.navigationController popToRootViewControllerAnimated:YES];
	
}

- (void)loadView {
	
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560, 420)];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	MudAddButtonAction *ma = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
	
	UIBarButtonItem *rb = [[UIBarButtonItem alloc] initWithTitle:@"None" style:UIBarButtonItemStylePlain target:self action:@selector(selectNoneAsMacro:)];
	self.navigationItem.rightBarButtonItem = rb;
	
	
	self.parentView = ma;


	UITableView *tc = [[UITableView alloc] initWithFrame:CGRectMake(0,0,560,420) style:UITableViewStyleGrouped];
	tc.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	[self.navigationItem setTitle:@"Assign Macro"];
	tc.delegate = self;
	tc.dataSource = self;
	
	
	
	[self.view addSubview:tc];
	
	self.tableview = tc;
	
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




@end

